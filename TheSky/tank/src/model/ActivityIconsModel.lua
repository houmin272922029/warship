--[[
	主界面活动图标model
]]
local ActivityIconsModel = {}
local _ModuleType = qy.tank.view.type.ModuleType

function ActivityIconsModel:initList(data)
	if data.activity_list["3"] == nil then 
		data.activity_list["3"] = {}
	end
	local listArr = data.activity_list["3"]  
	self.listIndex = {}
	self.otherData = {}
	self.listIcon2 = data.activity_list["2"]

	for i, v in pairs(listArr) do
		if i == "first_pay" then
			table.insert(self.listIndex , i)
		elseif v == "first_pay" then
			table.insert(self.listIndex , v)
		end
	end

end

function ActivityIconsModel:closeActivityByName(_name)
	if self.listIndex == nil then
		return
	end
	for i = 1, #self.listIndex do
		if self.listIndex[i] == _name then
			table.remove(self.listIndex, i)
			return
		end
	end
end

function ActivityIconsModel:getActivityNun()
	return table.nums(self.listIndex)
end

function ActivityIconsModel:getIconList( )
	return self.listIndex
end

function ActivityIconsModel:hasFirstPayData()
	for i = 1, #self.listIndex do
		if self.listIndex[i] == _ModuleType.FIRST_PAY then
			return true
		end
	end
	return false
end

--累计充值
function ActivityIconsModel:hasIcon(icon)
	for i, v in pairs(self.listIcon2) do
		if v == icon then
			return true
		end
	end

	return false
end

return ActivityIconsModel