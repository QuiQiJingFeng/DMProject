local loader = require("HALL.CSVLoader")
local TaskExecutor = class("TaskExecutor")

function TaskExecutor:ctor(name,csv)
    self.__taskName = name
    self.__data = loader:loadCSV(csv)
end

function TaskExecutor:getName()
    return self.__taskName
end

--这里负责具体任务的执行
function TaskExecutor:update()
    --[[
        if success then
            return true
        end
    ]]
end
 

return TaskExecutor