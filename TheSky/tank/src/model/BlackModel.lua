local BlackModel = qy.class("BlackModel", qy.tank.model.BaseModel)

function BlackModel:init(data)
	self.blackList = data
end

return BlackModel