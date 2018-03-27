--[[
    设置 Model
    Author: H.X.Sun
]]

local SettingModel = qy.class("SettingModel", qy.tank.model.BaseModel)

--更换服务器时清除旧数据
function SettingModel:clearData()
    qy.tank.model.LegionModel:clear()
end

return SettingModel
