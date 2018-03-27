--[[
    军团战信息
    Author: H.X.Sun
]]

local LeWarInfoEntity = qy.class("LeWarInfoEntity", qy.tank.entity.BaseEntity)

local model = qy.tank.model.LegionWarModel

function LeWarInfoEntity:ctor()
	--赛段 0-休息/1-初赛/2-复赛/3-决赛
	self:setproperty("stage",0)
	--行为 1-报名/2-进行中/3-排名/4-观战
	self:setproperty("action",0)
	--状态 0-未报名 1-已报名 2-死亡
	self:setproperty("status", 0)
	--轮数
	self:setproperty("round", 0)
end

function LeWarInfoEntity:update(data)
	self.stage = data.stage or self.stage
	self.action = data.action or self.action
	self.status = data.status or self.status
	self.round = data.round or self.round
end

function LeWarInfoEntity:hasSignUp()
	if self.status == 1 then
		return true
	else
		return false
	end
end

--可以报名
function LeWarInfoEntity:canSignUp()
	if self.status == 1 then
		return false
	else
		return true
	end
end

--今日比赛
function LeWarInfoEntity:getWarName()
    if tonumber(self.stage) == model.STAGE_EARLY then
        return "初赛"
    elseif tonumber(self.stage) == model.STAGE_SEMI then
        return "复赛"
    else
        return "决赛"
    end
end

--昨日比赛
function LeWarInfoEntity:getLastWarName()
	if tonumber(self.stage) == model.STAGE_SEMI then
	    return "初赛"
	elseif tonumber(self.stage) == model.STAGE_FINAL then
	    return "复赛"
	else
	    return "决赛"
	end
end

function LeWarInfoEntity:isFinalLastGrand()
	if tonumber(self.stage) == model.STAGE_SEMI or tonumber(self.stage) == model.STAGE_FINAL then
		return false
	else
		return true
	end
end

--赛段
function LeWarInfoEntity:getGameStage()
	return tonumber(self.stage)
end

--行为
function LeWarInfoEntity:getGameAction()
	return tonumber(self.action)
end

--是否休息
-- function LeWarInfoEntity:isRest()
-- 	if tostring(self.stage) == tostring(0) then
-- 		return true
-- 	else
-- 		return false
-- 	end
-- end

--是否报名
-- function LeWarInfoEntity:isSignUp()
-- 	if tonumber(self.action) == model.ACTION_SIGN then
-- 		return true
-- 	else
-- 		return false
-- 	end
-- end
--
-- --是否进行中
-- function LeWarInfoEntity:isPlaying()
-- 	if string.find(self.stage, "-2") then
-- 		return true
-- 	else
-- 		return false
-- 	end
-- end

return LeWarInfoEntity
