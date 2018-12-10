local generator = require("generator")
local Card = class("Card")

function Card:init()
    PROPERTY(self,"id",generator:generateId())
    PROPERTY(self,"value",0)
end

function Card:getType()
    return self:getValue() % 10
end


return Card