--dialog边框样式3

local DialogStyle3 = qy.class("DialogStyle3", qy.tank.view.style.DialogBaseStyle, "view/style/DialogStyle3")

function DialogStyle3:ctor(params)
    DialogStyle3.super.ctor(self, params)
    self:InjectView("title_bg")
    self:InjectView("title")

    -- self.closeBtn:setPosition(self.frame:getPositionX()+params.size.width /2 self.closeBtn:getContentSize().width/4, self.frame:getPositionY()+params.size.height/2 + self.closeBtn:getContentSize().height/4)
    self.closeBtn:setPosition(params.size.width + 10,params.size.height + 20)
    self.title_bg:setPosition(self.frame:getPositionX(), self.frame:getPositionY()+params.size.height/2)
    self.bg:setContentSize(params.size.width - 20,params.size.height -20)

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

end

return DialogStyle3