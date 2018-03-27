--[[
关卡机制  关卡
]]

local CampaignCheckpointEntity = qy.class("CampaignCheckpointEntity", qy.tank.entity.BaseEntity)

function CampaignCheckpointEntity:ctor(data,is_true)
    if is_true then
        staticData = assert(qy.Config.checkpoint[tostring(data.checkpoint_id)], qy.TextUtil:substitute(6021))
    else
        staticData = assert(qy.Config.hard_checkpoint[tostring(data.checkpoint_id)], qy.TextUtil:substitute(6021))
    end
    self:setproperty("checkpointId", data.checkpoint_id)
    self:setproperty("times", data.times or 0)
    self:setproperty("status", data.status)
    self:setproperty("timesUptime", data.times_uptime)

    -- 下面是静态数据
    self:setproperty("name", staticData.name)
    self:setproperty("show_no", staticData.show_no)
    self:setproperty("desc", staticData.desc)  
    self:setproperty("monster1", staticData.monster1)
    self:setproperty("monster2", staticData.monster2)
    self:setproperty("monster3", staticData.monster3)
    self:setproperty("monster4", staticData.monster4)
    self:setproperty("monster5", staticData.monster5)
    self:setproperty("monster6", staticData.monster6)
    self:setproperty("first_exp", staticData.first_exp)
    self:setproperty("exp", staticData.exp)
    self:setproperty("first_award", staticData.first_award)
    self:setproperty("award", staticData.award)
    self:setproperty("drop_award", staticData.drop_award)
    self:setproperty("type", staticData.type)
    self:setproperty("icon", staticData.icon)
    self:setproperty("drop_rate", staticData.drop_rate)
end

function CampaignCheckpointEntity:upData(data)
	if data.times then
		self.times = data.times
	end

	if data.status then
		self.status = data.status
	end

	if data.times_uptime then
		self.timesUptime = data.times_uptime
	end
end

-- 次数每日更新
function CampaignCheckpointEntity:getTimes()
    local day1 = os.date("%x", os.time())
    local day2 = os.date("%x", self.timesUptime)

    if day1 == day2 then
        return self.times
    else
        -- qy.hint:show("为什么ios时间会不一致！！！！"  .. day1 .. "    " .. day2)
        return 0
    end
end

return CampaignCheckpointEntity