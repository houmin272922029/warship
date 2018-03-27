--[[
    关卡攻略  item
]]
local HowToPlayItem = qy.class("HowToPlayItem", qy.tank.view.BaseView, "view/campaign/HowToPlayItem")

function HowToPlayItem:ctor(delegate)
    HowToPlayItem.super.ctor(self)

    self:InjectView("nameTxt")
    self:InjectView("lvTxt")
    self:InjectView("seeBtn")
    -- self.data = delegate.data
    
    -- self.nameTxt:setString(self.data.nickname)
    -- self.lvTxt:setString("LV."..self.data.level)
    self.delegate = delegate
    self:OnClick(self.seeBtn, function()
        local _MineService = qy.tank.service.SingleHeroService
        _MineService:video(delegate.checkpoint_id, self.data.kid, function (data)
            qy.tank.manager.ScenesManager:pushScene(qy.tank.view.scene.BattleScene.new())
        end)
    end)
end

function HowToPlayItem:update(data)
    self.nameTxt:setString(data.nickname)
    self.lvTxt:setString("LV."..data.level)
    self.data = data
end

return HowToPlayItem