--[[
	最强之战-报名
	Author: H.X.Sun
]]

local SignUpName = qy.class("SignUpName", qy.tank.view.BaseView, "greatest_race/ui/SignUpName")

function SignUpName:ctor(delegate)
    SignUpName.super.ctor(self)

    self:InjectView("name_1")
    self:InjectView("name_2")

    self.model = qy.tank.model.GreatestRaceModel
end

function SignUpName:render(idx)
    local index1 = idx * 2 + 1
    local index2 = idx * 2 + 2
    self.name_1:setString(self.model:getSignUpListByIdx(index1))
    self.name_2:setString(self.model:getSignUpListByIdx(index2))
end

return SignUpName
