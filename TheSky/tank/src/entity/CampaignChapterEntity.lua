--[[
    关卡机制  章节实体
]]

local CampaignChapterEntity = qy.class("CampaignChapterEntity", qy.tank.entity.BaseEntity)

function CampaignChapterEntity:ctor(data)
	local staticData = assert(qy.Config.chapter[tostring(data.chapter_id)], qy.TextUtil:substitute(6020))

    self:setproperty("chapterId", data.chapter_id)
    self:setproperty("status", data.status or 0)  --0 进行中 1 已完成 
    self:setproperty("isDrawAward", data.is_draw_award or 0)  --奖励是否领取 
    self:setproperty("drawAwardTime", data.draw_award_time or 0) --奖励领取时间

    self.name = staticData.name
    self.award = staticData.award
end

function CampaignChapterEntity:upData(data)
	if data.status then
		self.status = data.status
	end

	if data.is_draw_award then
		self.isDrawAward = data.is_draw_award
	end

	if data.draw_award_time then
		self.drawAwardTime = data.draw_award_time
	end
end


return CampaignChapterEntity