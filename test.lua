local loader = require("CSVLoader")
local util = require("Util")
loader:init()

local data = loader:loadCSV("config/ALL.csv")
loader:refreshCSV("config/ALL.csv")
print("data ===>>",util:dump(data))

 