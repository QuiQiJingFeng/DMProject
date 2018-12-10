local Player = class("Player")

function Player:init()
    PROPERTY(self,"handleList",{})                         --手牌数组
    PROPERTY(self,"outList",{})                            --出牌数组
    PROPERTY(self,"operateObjects",{})                     --操作牌 吃碰杠等
    PROPERTY(self,"huaList",{})                            --花牌数组
    PROPERTY(self,"pos",0)                                 --位置
    PROPERTY(self,"state",nil)                             --状态
end

function Player:addHandleCard(card)
    local handleCards = self:getHandleList()
    table.insert(handleList,card)
end

function Player:addHandleCardList(list)
    for i,v in ipairs(list) do
        self:addHandleCard(v)
    end
end

function Player:removeHandleCard(id)
    local handleList = self:getHandleList()
    for idx,card in ipairs(handleList) do
        if card:getId() == id then
            return table.remove(handleList,idx)
        end
    end
end

function Player:addOutCard(card)
    local outList = self:getOutList()
    table.insert(outList,card)
end

function Player:addHuaCard(card)
    local huaList = self:getHuaList()
    table.insert(huaList,card)
end

function Player:addOperateObject(obj)
    local operateObjects = self:getOperateObjects()
    table.insert(operateObjects,obj)
end

function Player:checkPeng()

end

function Player:checkGang()

end

function Player:checkChi()

end


return Player