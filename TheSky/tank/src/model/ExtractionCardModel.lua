--[[
    抽卡 model  
    add by lianyi
]]
local ExtractionCardModel = qy.class("ExtractionCardModel", qy.tank.model.BaseModel)

function ExtractionCardModel:init(data)
    local staticData = qy.Config.recruit_achievement
	local data2 = data.recruit or data

    self.cdTime1 = data2.recruit1.cd_time
    self.cdTime2 = data2.recruit2.cd_time
    self.serviceTime = data.server_time
    self.leftTimes1 = data2.recruit1.left_times
    self.redpoint = data2.recruit2.redpoint -- 军资基地 领奖入口推送图标状态
    self.diamond_times = data2.recruit2.diamond_times -- 判断当前是否首次花钻石抽奖
    self.total_times = data2.recruit2.total_times or 0
    self.achievement_award_list = data2.recruit2.achievement_award_list or {}
    self.cfg = {}

    for i = 1, table.nums(staticData) do
        local item = qy.tank.entity.ExtractionCardAwardEntity.new(staticData[tostring(i)])
        table.insert(self.cfg, item)
    end

    table.sort(self.cfg, function(a, b)
        return a.id < b.id
    end)
end

function ExtractionCardModel:update(data)
    self:init(data)
    self:dealRewards(data.award)
end

function ExtractionCardModel:dealRewards(awards)
    
end

function ExtractionCardModel:testDiamond(isTen)
	local num = isTen and 2700 or 288
	return qy.tank.model.UserInfoModel.userInfoEntity.diamond >= num
end

return ExtractionCardModel
