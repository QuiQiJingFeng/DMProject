local ObjectPool = class("ObjectPool")
local Card = require("Card")

function ObjectPool:init()
    PROPERTY(self,"objects",{})
    PROPERTY(self,"actives",{})
end

function ObjectPool:getObject()
    local objects = self:getObjects()
    local obj = table.remove(objects)
    if not obj then
        obj = Card.new()
    end
    local actives = self:getActives()
    table.insert(actives,obj)
    return obj
end

function ObjectPool:pushObject(obj)
    local actives = self:getActives()
    local objects = self:getObjects()
    for idx,card in ipairs(actives) do
        if card:getId() == obj:getId() then
            obj = table.remove(actives,idx)
            table.insert(objects,obj)
            break
        end
    end
end

function ObjectPool:clear()
    local objects = self:getObjects()
    local actives = self:getActives()
    for i=#actives,1,-1 do
        local obj = table.remove(actives)
        table.insert(objects,obj)
    end
end

return ObjectPool