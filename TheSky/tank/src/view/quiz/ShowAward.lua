--[[
	知识竞赛奖励
]]

local ShowAward = qy.class("ShowAward", qy.tank.view.BaseDialog, "quiz/ui/ShowAward")

function ShowAward:ctor(delegate)
    ShowAward.super.ctor(self)
    local model = qy.tank.model.OperatingActivitiesModel

    self:InjectView("Text1")
    self:InjectView("Text2")
    self:InjectView("Text3")

    self:OnClick("Button_1", function(sender)
        qy.Event.dispatch(qy.Event.USER_RESOURCE_DATA_UPDATE)
        self:dismiss()
    end)

    local style = qy.tank.view.style.DialogStyle5.new({
        size = cc.size(500,320),
        position = cc.p(0,0),
        offset = cc.p(0,0),
    })
    self:addChild(style, -10)

    self.Text1:setString(model.quizCorrectNum)
    self.Text2:setString(model.quizCurScore)
    local awardSilver
    for k,v in pairs(model.quizAward) do
        awardSilver = v.num
    end
    self.Text3:setString(awardSilver*qy.tank.model.UserInfoModel.userInfoEntity.level)
end

function ShowAward:onEnter()

end

function ShowAward:onExit()
end

return ShowAward
