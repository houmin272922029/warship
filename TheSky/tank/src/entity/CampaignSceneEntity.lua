--[[
    关卡机制  场景实体
]]

local CampaignSceneEntity = qy.class("CampaignSceneEntity", qy.tank.entity.BaseEntity)

function CampaignSceneEntity:ctor(scene,is_true)
	if is_true then
	     data = assert(qy.Config.scene[tostring(scene.scene_id)], qy.TextUtil:substitute(6022))
	else
		 data = assert(qy.Config.hard_scene[tostring(scene.scene_id)], qy.TextUtil:substitute(6022))
	end
	    self:setproperty("sceneId", scene.scene_id)
	    self:setproperty("status", scene.status or 0) --0 进行中 1 已完成 
	    self:setproperty("isDrawAward", scene.is_draw_award or 0)  --奖励是否领取 
	    self:setproperty("drawAwardTime", scene.draw_award_time or 0) --奖励领取时间
	    self:setproperty("name", data.name) -- 名字
	    self:setproperty("award", data.award)
	    self:setproperty("chapter_id", data.chapter_id)
end

function CampaignSceneEntity:upData(data)
	if data.status then
		print("oooooooooqqqp",data.status)
		self.status = data.status
	end

	if data.is_draw_award then
		print("lingqqqqqqqq",data.is_draw_award)
		self.isDrawAward = data.is_draw_award
	end

	if data.draw_award_time then
		self.drawAwardTime = data.draw_award_time
	end
end

return CampaignSceneEntity