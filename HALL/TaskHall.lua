local loader = require("HALL.CSVLoader")
local constants = require("HALL.Constants")
local condition_processer = require("HALL.ConditionProcesser")
local TaskHall = {}

function TaskHall:init()
    self.__taskList = loader:loadCSV(constants.TASK_ALL)
    --[[
        这里需要排序,加权重从而让所有任务都得到执行,比如五环权重在升级任务之前
    ]]

    self.__curTaskExecutor = nil

--[[
    ID,name,executor,conditions,csv
]]
end

function TaskHall:filterTask()
    for id, task in ipairs(self.__taskList) do
        local can = condition_processer:check(task.conditions)
        if can then
            self.__curTaskExecutor = require(task.executor).new(task.name,task.csv,self)
            print(string.format("☆☆☆任务[%s]开始执行☆☆☆"  ,task.name))
            return
        end
    end
end

function TaskHall:update()
    if not self.__curTaskExecutor then
        return self:filterTask()
    end
    --如果返回true,说明任务执行完毕
    local finish = self.__curTaskExecutor:update()
    if finish then
        print(string.format("★★★任务[%s]执行完毕★★★"  ,self.__curTaskExecutor:getName()))
        self.__curTaskExecutor = nil
    end
end

return TaskHall