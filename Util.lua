local Util = {}

function Util:init()
    
end

function  Util:split(s, delim)
    if type(delim) ~= "string" or string.len(delim) <= 0 then
        return
    end

    local start = 1
    local t = {}
    while true do
    local pos = string.find (s, delim, start, true) -- plain find
        if not pos then
          break
        end

        table.insert (t, string.sub (s, start, pos - 1))
        start = pos + string.len (delim)
    end
    table.insert (t, string.sub (s, start))

    return t
end

function Util:dump(data, max_level, prefix,need_type)
    if type(prefix) ~= "string" then
        prefix = ""
    end
    if type(data) ~= "table" then
        print(prefix .. tostring(data))
    else
        print(data)
        if max_level ~= 0 then
            local prefix_next = prefix .. "    "
            print(prefix .. "{")
            for k,v in pairs(data) do
                io.stdout:write(prefix_next .. k .. " = ")
                if type(v) ~= "table" or (type(max_level) == "number" and max_level <= 1) then
                    if need_type then
                        print(v,type(v))
                    else
                        print(v)
                    end
                else
                    if max_level == nil then
                        self:dump(v, nil, prefix_next,need_type)
                    else
                        self:dump(v, max_level - 1, prefix_next,need_type)
                    end
                end
            end
            print(prefix .. "}")
        end
    end
end

return Util