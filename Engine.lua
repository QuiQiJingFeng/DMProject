local Engine = class("Engine")
local Player = class("Player")
local EventManager = require("EventManager")
local Constant = require("Constant")
local ObjectPool = require("ObjectPool")

function Engine:init()
    PROPERTY(self,"players",{})
    PROPERTY(self,"pool",{})
end

function Engine:setPlayerNum(num)
    local players = self:getPlayers()
    for pos=1,num do
        local player = Player.new()
        player:setPos(pos)
        table.insert(players,player)
    end
end

--0x1,0x2,0x3,45
function Engine:generalPool(...)
    local args = {...}
    local pool = self:getPool()
    for _,key in ipairs(args) do
        if key == Constant.BASE_CARD then
            for _,value in ipairs(Constant.BASE_CARD_POOL) do
                for n=1,4 do
                    local card = ObjectPool:getObject()
                    card:setValue(value)
                    table.insert(pool,card)
                end
            end
        elseif key == Constant.FENG_CARD then
            for _,value in ipairs(Constant.FENG_CARD_POOL) do
                for n=1,4 do
                    local card = ObjectPool:getObject()
                    card:setValue(value)
                    table.insert(pool,card)
                end
            end
        elseif key == Constant.HUA_CARD then
            for _,value in ipairs(Constant.HUA_CARD_POOL) do
                for n=1,4 do
                    local card = ObjectPool:getObject()
                    card:setValue(value)
                    table.insert(pool,card)
                end
            end
        else
            local value = tonumber(key)
            assert(value,"value must be number")
            for i=1,4 do
                local card = ObjectPool:getObject()
                card:setValue(value)
                table.insert(pool,card)
            end
        end
    end
end

function Engine:sortPool()
    local cardPool = self:getPool()
    for i = #cardPool,1,-1 do
        --在剩余的牌中随机取一张
        local j = math.random(i)
        --交换i和j位置的牌
        local temp = cardPool[i]
        cardPool[i] = cardPool[j]
        cardPool[j] = temp
    end
end

--从牌库 尾部 获取指定的N张牌
function Engine:getCardsFromPoolByNum(num)
    local cardPool = self:getPool()
    if #cardPool < num then
        return nil
    end
    local list = {}
    for i=1,num do
        local card = table.remove(cardPool)
        table.insert(list,card)
    end
    return list
end

function Engine:getPlayerByPos(pos)
    local players = self:getPlayers()
    return players[pos]
end

--发牌
function Engine:drewCard(steps)
    local players = self:getPlayers()
    for _,player in ipairs(players) do
        local list = self:getCardsFromPoolByNum(13)
        player:addHandleCardList(list)

        local step = {}
        


    end
    local list = self:getCardsFromPoolByNum(1)
    players[1]:addHandleCardList(list)
end

--摸牌
function Engine:drawCard(pos)
    local player = self:getPlayerByPos(pos)
    local list = self:getCardsFromPoolByNum(1)
    player:addHandleCardList(list)


end
--ishua 是否将牌打到花牌区
function Engine:playHandleCard(pos,cardId,ishua)
    local player = self:getPlayerByPos(pos)
    local card = player:removeHandleCard(cardId)
    if ishua then
        player:addHuaCard(card)
    else
        player:addOutCard(card)
    end
end

--设置胡牌算法 不同的玩法胡牌算法可能不一样
function Engine:setHuAlgorithm(checkHu)
    self.__algorithm = checkHu
end

--设置检查吃碰杠的回调方法
function Engine:check(player)

end

return Engine