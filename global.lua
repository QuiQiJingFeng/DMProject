function handler(obj, method)
    return function(...)
        return method(obj, ...)
    end
end

function clone(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local newObject = {}
        lookup_table[object] = newObject
        for key, value in pairs(object) do
            newObject[_copy(key)] = _copy(value)
        end
        return setmetatable(newObject, getmetatable(object))
    end
    return _copy(object)
end

local setmetatableindex_
setmetatableindex_ = function(t, index)
    local mt = getmetatable(t)
    if not mt then mt = {} end
    if not mt.__index then
        mt.__index = index
        setmetatable(t, mt)
    elseif mt.__index ~= index then
        setmetatableindex_(mt, index)
    end
end
setmetatableindex = setmetatableindex_

function class(classname, super)
    local cls = {__cname = classname}

    local superType = type(super)
    assert(superType == "nil" or superType == "table",
        string.format("class() - create class \"%s\" with invalid super class type \"%s\"",
            classname, superType))

    if superType == "table" then
        cls.super = super
    else
        error(string.format("class() - create class \"%s\" with invalid super type",
                    classname), 0)
    end
 
    cls.__index = cls
    if cls.super then
        setmetatable(cls, {__index = cls.super})
    end

    if not cls.ctor then
        -- add default constructor
        cls.ctor = function() end
    end
    cls.new = function(...)
        local instance = {}
        setmetatableindex(instance, cls)
        instance.class = cls
        instance:ctor(...)
        return instance
    end

    return cls
end

--FYD 添加一个包装,规定对类对象的属性赋值,只能在类内部
local function pacakge(target)
    if type(target) == "userdata" then
        local peer = tolua.getpeer(target)
        if not peer then
            peer = {}
        end
        local newpeer = pacakge(peer)
        tolua.setpeer(target,newpeer)
        return target
    else
        local obj = {__stack = {}}
        function obj:push(func)
            table.insert(self.__stack,func)
        end

        function obj:pop()
            table.remove(self.__stack)
        end

        function obj:inFunc()
            local curFunc = self.__stack[#self.__stack]
            local compareFunc = nil
            for i=3,10 do
                if debug.getinfo(i).what == "Lua" then
                    compareFunc = debug.getinfo(i).func
                    break
                end
            end
            return curFunc == compareFunc
        end
        local values = target
        local meta = {}
        setmetatable(obj, meta)
        meta.__index = function(tb,key)
            --下划线开头变量(私有变量) 不允许在外边直接访问,只能通过get方法来访问
            --下滑先开头的方法为私有方法，不可以在类外部调用
            if not (tb:inFunc()) and string.find(key,"_") == 1 then
                error("下划线开头的变量不允许在外部访问")
            end
            --检查变量名的格式 小写字母开头
            if string.lower(string.sub(key,1,1)) ~= string.sub(key,1,1) then
                error("变量名必须以小写字母开头")
            end

            if type(values[key])  == "function" then
                --方法的长度检测, 暂时有个问题 没有将注释以及空行给去掉
                local info = debug.getinfo(values[key])
                if info.what == "Lua" then
                    local lineNums = info.lastlinedefined - info.linedefined
                    local totalNum = lineNums
                    local maxLineNum = 35
                    assert(lineNums <= maxLineNum,"方法的长度不能超过"..maxLineNum.."行")
                end

                return function(...)
                    tb:push(values[key])
                    local ret = {values[key](...)}
                    tb:pop()
                    local tableunpack = nil
                    if unpack then
                        tableunpack = unpack
                    else
                        tableunpack = table.unpack
                    end
                    return tableunpack(ret)
                end
            else
                return values[key]
            end
        end
        meta.__newindex = function(tb,key,value)
            if type(value) == "function" then
                values[key] = value
            elseif (tb:inFunc()) then 
                values[key] = value
            else
                error("不允许在外部对成员变量赋值")
            end
        end
        return obj
    end
end

--严格模式检测,用法同class
function Class(...)
    local cls = class(...)
    --只在测试环境下对 对象的使用方式做检测
    if device.platform == "windows" or device.platform == "macosx" then
        local origin = cls.new
        cls.new = function(...)
            local instance = origin(...)
            return pacakge(instance)
        end
    end
    return cls
end