--[[
	军团战-奖励&帮助
	Author: H.X.Sun
]]

local RewardList = qy.class("RewardList", qy.tank.view.BaseView,"legion_war/ui/RewardList")

local LIST_HIGHT = 518

function RewardList:ctor(params)
    RewardList.super.ctor(self)
    self:InjectView("reward_list")
    local model = qy.tank.model.LegionWarModel

    local h = 0
    local arr = {qy.TextUtil:substitute(53029), qy.TextUtil:substitute(53030), qy.TextUtil:substitute(53031)}
    local indexArr = {model.STAGE_FINAL, model.STAGE_SEMI,model.STAGE_EARLY}
    for i = 1, 3 do
        if not tolua.cast(self["awardList"..i],"cc.Node") then
            self["awardList"..i] = qy.tank.view.legion.war.AwardList.new({["title"] = arr[i],["stage"] = indexArr[i]})
            self.reward_list:addChild(self["awardList"..i])
            h = h + self["awardList"..i]:getHight()
            self["awardList"..i]:setPosition(0,h)
        end
    end

    if not tolua.cast(self.instruction,"cc.Node") then
        self.instruction = qy.tank.view.legion.war.InstructionCell.new()
        self.reward_list:addChild(self.instruction)
        h = h + self.instruction:getHight()
        self.instruction:setPosition(0,h)
    end

    self.reward_list:setInnerContainerSize(cc.size(980,h))
end

return RewardList
