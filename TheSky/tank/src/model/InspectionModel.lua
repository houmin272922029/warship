--[[
    每日检阅model
    add by lianyi
]]
local InspectionModel = qy.class("InspectionModel", qy.tank.model.BaseModel)

function InspectionModel:init() -- 这个data是后端接口返回的数据
	self.inspectionList = nil
	self.inspectionNum = 0
end

function InspectionModel:update(data) 
	if type(data) == "number" or data == nil then return end
    self.inspectionList = data.list
    self.inspectionNum1 = data.inspection1_num
    self.inspectionNum2 = data.inspection2_num
    self.inspectionNum3 = data.inspection3_num
    self.inspectionNum4 = data.inspection4_num
end

function  InspectionModel:getList( ... )
	return self.inspectionList
end

return InspectionModel
