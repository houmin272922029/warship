--[[--
--创建角色提示
--Author: H.X.Sun
--Date: 2015-08-24
--]]

local CreateRoleTips = qy.class("CreateRoleTips", qy.tank.view.BaseView)

function CreateRoleTips:ctor(delegate)
    CreateRoleTips.super.ctor(self)

    self.layout = ccui.Layout:create()
    self.layout:setContentSize(qy.winSize.width, qy.winSize.height)
    self.layout:setBackGroundColor(cc.c3b(0, 0, 0))
    self.layout:setBackGroundColorType(1)
    self.layout:setBackGroundColorOpacity(50)
    self.layout:setTouchEnabled(true)
    self:addChild(self.layout, -1)

    --使用前加载plist
    cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/common/img/common_img.plist")
    self.loadingBg = cc.Sprite:createWithSpriteFrameName("Resources/common/img/tip_detail.png")
    self.loadingBg:setPosition(qy.winSize.width / 2, 319)
    self:addChild(self.loadingBg)

    self.loadingTxt = ccui.Text:create()
    self.loadingTxt:setFontName("Resources/font/ttf/black_body_2.TTF")
    self.loadingTxt:setFontSize(30)
    self.loadingTxt:setString(qy.TextUtil:substitute(15005))
    self.loadingTxt:setPosition(qy.winSize.width / 2, 319)
    self.loadingTxt:enableOutline(cc.c4b(0,0,0,255),1)
    self:addChild(self.loadingTxt)
end

return CreateRoleTips
