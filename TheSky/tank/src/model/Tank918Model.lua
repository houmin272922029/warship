local Tank918Model = qy.class("Tank918Model", qy.tank.model.BaseModel)

function Tank918Model:init(data)
	self.activittstatus = 0--存不存在这个活动 1为存在
	if data.tank_918 then
		if data.tank_918.is_get == 0 then
			self.activittstatus = 1
		else
			self.activittstatus = 0
		end
	end
end
function Tank918Model:update( data )
	self.iscanget = data.is_can_get
	self.is_get = data.is_get
	self.starttime = data.start_time
	self.endtime  = data.end_time
end
function Tank918Model:initstatus(  )
	self.activittstatus = 0
end

return Tank918Model