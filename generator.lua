local generator = {}

function generator:reset()
    self.__id = 0
end

function generator:generateId()
    self.__id = self.__id + 1
    return self.__id
end

return generator