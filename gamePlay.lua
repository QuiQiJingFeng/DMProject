local Engine = require("Engine")

local engine = Engine.new()



local EventManager = require("EventManager")
local Constant = require("Constant")
local PLAY_TYPE = Constant.PLAY_TYPE

local gamePlay = {}

function gamePlay:registerEvents()
    EventManager:addEventListenerByTag(PLAY_TYPE.PLAY_A_CARD,handler(self,self[PLAY_TYPE.PLAY_A_CARD]),self)
end

gamePlay[PLAY_TYPE.PLAY_A_CARD] = function(self)
    
end


return gamePlay