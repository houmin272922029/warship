local MainView = qy.tank.module.BaseUI.class("MainView", "gold_bunker.ui.MainView")

local Model = require("gold_bunker.src.Model")


function MainView:ctor()
    MainView.super.ctor(self)
end

function MainView:onEnter()
    self:update()
end

function MainView:update()
    local isresume = Model:getInitData().status == 1
    self.ui.Text_str2:setVisible(not isresume)

    if not isresume then
        if Model:getInitData().need_energy == 0 then
            self.ui.Text_str2:setString(qy.TextUtil:substitute(46012))
        else
            self.ui.Text_str2:setString(qy.TextUtil:substitute(46013) .. Model:getInitData().need_energy)
        end
    end
    self.ui.Image_4:setSwallowTouches(true)
    self.ui.Text_str1:setString(qy.TextUtil:substitute(46014) .. Model:getInitData().max_id)
    self.ui.Text_str1:setPositionY(isresume and 160 or 177)
    cc.SpriteFrameCache:getInstance():addSpriteFrames("gold_bunker/res/ui.plist")
    self.ui.button_title:setSpriteFrame("gold_bunker/res/" .. (isresume and "jixu" or "jinrudibao") .. ".png")
    self.model = qy.tank.model.UserInfoModel
    self.ui.energyTxt:setString(self.model.userInfoEntity:getEnergyStr() .. "/" .. self.model:getEnergyLimitByVipLevel())
    self.userResourceDatalistener = qy.Event.add(qy.Event.USER_RESOURCE_DATA_UPDATE,function(event)
        self.ui.energyTxt:setString(self.model.userInfoEntity:getEnergyStr() .. "/" .. self.model:getEnergyLimitByVipLevel())
    end)

    if Model.is_hard == 1 then
        self.ui.bg:loadTexture("gold_bunker/res/bg2.jpg")
        self.ui.Btn_mode:loadTexture("gold_bunker/res/b.png")
    else
        self.ui.bg:loadTexture("gold_bunker/res/bg1.jpg")
        self.ui.Btn_mode:loadTexture("gold_bunker/res/a.png")
    end
end

return MainView
