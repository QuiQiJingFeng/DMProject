local v = class("GameState")

function v:ctor(name)
    self.__name = name
end

function v:enter(data)
    self.__data = data
    self.__taskId = 1
end

function v:update()
    local opdata = self.__data[self.__taskId]
    if not opdata then
        return true
    end
    local operator = opdata.operator

    if operator == "SEARCH_PIC" then
        self:processPic()
    elseif operator == "MOVE_CLICK" then
        self:processMoveClick()
    end
end

function v:processPic()
    --.......
    self.__taskId = self.__taskId + 1
end

function v:processMoveClick()
    --skynet.call("lua","HANDWARE","MoveClick")
    self.__taskId = self.__taskId + 1
end

function v:exit()

end

return v