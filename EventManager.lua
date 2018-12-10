local EventManager = {}
local handlers = {}
local EVENT_LIST = {}

function EventManager:addEventListenerByTag(eventName,handle,tag)
    assert(EVENT_LIST[eventName],"EVENT_LIST has not eventName - ",eventName)

    handlers[tag] = handlers[tag] or {}
    handlers[tag][eventName] = handle
end

function EventManager:dispatchEvent(eventName,...)
    for _,data in pairs(handlers) do
        for name,handle in pairs(data) do
            if eventName == name then
                handle(...)
            end
        end
    end
end

function EventManager:removeEventListenerByTag(tag)
    handlers[tag] = nil
end

function EventManager:clear()
    handlers = {}
end

return EventManager