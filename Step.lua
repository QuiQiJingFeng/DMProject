local Step = class("Step")

function Step:init(type)
    PROPERTY(self,"type",type)
end

return Step