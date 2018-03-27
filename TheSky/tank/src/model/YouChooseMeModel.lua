

local YouChooseMeModel = qy.class("YouChooseMeModel", qy.tank.model.BaseModel)

local userinfoModel = qy.tank.model.UserInfoModel
local NumberUtil = qy.tank.utils.NumberUtil

function YouChooseMeModel:init(data)
	self.data = data
	self.config = qy.Config.you_choose_i_send
	self.step = data.step
	self.start_time = data.start_time
	self.end_time = data.end_time
	self.about_gift_id = data.about_gift_id
end

function YouChooseMeModel:getAward(  )
	local gift_award = {}
	for i=1,5 do
		table.insert(gift_award,self.config[tostring(self.data.list[i])])
	end
	table.sort(gift_award,function(a,b)
        return tonumber(a.id) < tonumber(b.id)
    end)
	return gift_award
end

function YouChooseMeModel:getAward2(  )
	if self.data.about_gift_id ~= 0 then
		local gift_award = self.config[tostring(self.data.about_gift_id)]
		return gift_award
	end
end

function YouChooseMeModel:change_about_gift_id(idx)
	local id = self.data.list[idx]
	self.data.about_gift_id = id
	return id
end

-- 确定变为消失  1 -- 0
function YouChooseMeModel:changeStatus(  )
	self.step = 0
end

-- 领取变为确定  2 -- 1
function YouChooseMeModel:changeStatus2(  )
	self.step = 1
end

-- 领取变为确定  2 -- -1
function YouChooseMeModel:changeStatus3(  )
	self.step = -1
end


function YouChooseMeModel:changeButtonStatus(  )
	
end



return YouChooseMeModel