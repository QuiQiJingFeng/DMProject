local util = require("Util")
local CSVLoader = {}

function CSVLoader:init()
    self.__cache = {}
end

--加载CSV
function CSVLoader:loadCSV(path)
    local data = self.__cache[path]
    if data then
        return data
    end
    local file = io.open(path,"rb")
    local content = file:read("*a")
    file:close()
    local list = util:split(content,"\n")
    local typedata = {}
    local keys = util:split(list[1],",")
    local types = util:split(list[2],",")
    for idx,key in ipairs(keys) do
        typedata[key] = types[idx];
    end

    local data = {}
    for i = 3, #list do
        local line = list[i]
        local values = util:split(line,",")
        local cell = {}
        for idx,value in ipairs(values) do
            local key = keys[idx]
            local type = types[idx]
            local var = nil
            if type == "number" then
                var = tonumber(value)
            elseif type == "string" then
                var = tostring(value)
            end
            cell[key] = var
        end
        --必须有ID 才会存入到数组中,这样可以在不指定ID的情况下写注释
        if cell.ID then
            data[cell.ID] = cell
        end
    end
    self.__cache[path] = data
    return data
end

--深度递归刷新,避免引用发生变化
function CSVLoader:refresh(dest, src)
    for k, v in pairs(src) do
        if type(v) ~= "table" then
            dest[k] = v
        else
            self:refresh(dest[k],v)
        end
    end

    --解决数据删减的问题
    for k, v in pairs(dest) do
        if not src[k] then
            dest[k] = nil
        end
    end
end

--刷新CSV数据,不该变原来的引用
function CSVLoader:refreshCSV(path)
    local origin = self.__cache[path]
    self.__cache[path] = nil
    local data = self:loadCSV(path)
    self:refresh(origin, data)

    self.__cache[path] = origin
end

--重新加载CSV数据,改变原来的引用
function CSVLoader:reloadCSV(path)
    local origin = self.__cache[path]
    self.__cache[path] = nil
    local data = self:loadCSV(path)
    self.__cache[path] = data
end

return CSVLoader