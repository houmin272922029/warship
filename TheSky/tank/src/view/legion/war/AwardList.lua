--[[
	军团战-奖励
	Author: H.X.Sun
]]

local AwardList = qy.class("AwardList", qy.tank.view.BaseView)

function AwardList:ctor(params)
    AwardList.super.ctor(self)

    local head = qy.tank.view.legion.war.HelpCell.new(params)
    self:addChild(head)
    head:setPosition(0,-18)
    self.h = 0

    local model = qy.tank.model.LegionWarModel
    local num = model:getAwardNumByStage(params.stage)
    for i = 1, num do
        local cell = qy.tank.view.legion.war.AwardCell.new(model:getAwardDataByStageAndIdx(params.stage,i))
        self.h = -66-i*48
        cell:setPosition(0,self.h)
        self:addChild(cell)
    end

end

function AwardList:getHight()
    return -self.h
end


function AwardList:onEnter()

end

return AwardList
