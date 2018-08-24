local v = class("GameFSM")
local loader = require("CSVLoader")
local player = require("Player")
function v:ctor()
    self.__curState = nil
    self.__config = loader.loadCSV("ALL.csv")
    self.__finishId = 0
end

function v:hasState()
    return self.__curState == nil
end

function v:setCurState(state)
    self.__curState = state
end


function v:selectState()
    --select full condition state name
    local id = self.__finishId + 1
    local data = self.__config[id]
    --CHECK CONDITION player.level > data.condition1
    self:changeState(data.name)
end

function v:update()
    if not self.__curState then
        self:selectState()
    end

    local finish = self.__curState:update()
    if finish then
        self.__finishId = self.__finishId + 1
        self:setCurState(nil)
    end
end

function v:changeState(name)
    local state = require("GameState").new(name)
    self:setCurState(state)

    local data = loader:loadCSV("config/"..name..".csv")
    state:enter(data)
end

return v