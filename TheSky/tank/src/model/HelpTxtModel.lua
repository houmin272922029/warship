--[[--
--帮助 model
--Author: H.X.Sun
--Date: 2015-04-24
--]]

local HelpTxtModel = qy.class("HelpTxtModel", qy.tank.model.BaseModel)

--[[--
--获取帮助数据
--1：车库
--2：竞技场
--3：远征
--4：矿区
--5：经典战役
--]]
function HelpTxtModel:getHelpDataByIndx(_idx)
	local data = qy.Config.module_rules
	local index = tostring(_idx)
	if index and data and data[index] then
		return data[index]
	else
		return {
			["title"] = qy.TextUtil:substitute(48001),
			["content"] = "",
				}
	end
	return _txtData
end

return HelpTxtModel
