--[[
	报名界面
	Author: H.X.Sun
]]

local SignUpCell = qy.class("SignUpCell", qy.tank.view.BaseView, "legion_war/ui/SignUpCell")

function SignUpCell:ctor(params)
    SignUpCell.super.ctor(self)
    self:InjectView("title")
    self:InjectView("btn")
    self:InjectView("btn_title")

    local service = qy.tank.service.LegionWarService
    self.model = qy.tank.model.LegionWarModel
    cc.SpriteFrameCache:getInstance():addSpriteFrames("legion_war/res/legion_war.plist")
    self.entity = self.model:getLegionWarInfoEntity()
    self._stage = self.entity:getGameStage()
    self.title:setSpriteFrame("legion_war/res/game_title_"..self._stage..".png")

    self:update()

    self:OnClick("btn",function()
        if self.entity:canSignUp() then
            service:join(function()
                self:update()
                params.callback()
            end)
        else
            if self._stage == self.model.STAGE_FINAL then
                -- qy.hint:show("取消报名")
                service:cancel_join(function()
                    self:update()
                    params.callback()
                end)
            else
                qy.hint:show(qy.TextUtil:substitute(53032))
            end
        end
    end)
end

function SignUpCell:update()
    self.btn_title:setString(qy.TextUtil:substitute(53033))

    if self.entity:canSignUp() then
        self.btn:setBright(true)
    else
        if self._stage == self.model.STAGE_FINAL then
            self.btn:setBright(true)
            self.btn_title:setString(qy.TextUtil:substitute(53034))
        else
            self.btn:setBright(false)
        end
    end
end

return SignUpCell
