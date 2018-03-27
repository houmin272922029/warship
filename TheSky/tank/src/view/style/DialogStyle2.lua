--[[
	dialog边框样式2
	Author: Your Name
	Date: 2015-04-17 13:15:45
]]

local DialogStyle2 = qy.class("DialogStyle2", qy.tank.view.style.DialogBaseStyle, "view/style/DialogStyle2")

function DialogStyle2:ctor(params)
    DialogStyle2.super.ctor(self, params)
    self:InjectView("title_bg")
    self:InjectView("title")
    self:InjectView("line")
    self:InjectView("headBg")

    -- self.closeBtn:setPosition(self.frame:getPositionX()+params.size.width /2 self.closeBtn:getContentSize().width/4, self.frame:getPositionY()+params.size.height/2 + self.closeBtn:getContentSize().height/4)
    self.closeBtn:setPosition(params.size.width + 10,params.size.height + 20)
    self.title_bg:setPosition(self.frame:getPositionX(), self.frame:getPositionY()+params.size.height/2)
    self.bg:setContentSize(params.size.width - 20,params.size.height -20)
    self.headBg:setContentSize(params.size.width-10,100)
    self.headBg:setPosition(self.frame:getPositionX(),self.frame:getPositionY()+params.size.height/2-66)
    self.line:setContentSize(params.size.width-10,15)
    self.line:setPosition(self.frame:getPositionX(),self.frame:getPositionY()+params.size.height/2-122)

    if params.titleUrl then
    	self.title:setVisible(true)
    	if cc.SpriteFrameCache:getInstance():getSpriteFrame(params.titleUrl) then
            self.title:setSpriteFrame(params.titleUrl)
        else
            self.title:setTexture(params.titleUrl)
        end
    else
    	self.title:setVisible(false)
    end

    self.params = params
end

function DialogStyle2:changeHeadBgSize(height)
    self.headBg:setContentSize(self.params.size.width - 10, height)
    self.headBg:setPositionY(self.frame:getPositionY() + self.params.size.height / 2 - height / 2)
    self.line:setPositionY(self.headBg:getPositionY() -  height / 2)
end

return DialogStyle2