local Model = require("gold_bunker.src.Model")
local Controller = require("gold_bunker.src.Controller")

return function()
    print("gold_bunker module")

    -- 请求数据
    Model:init(function()
        Controller.new():start()
    end)
end
