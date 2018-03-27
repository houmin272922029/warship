--dialog边框样式1

local DialogStyle1 = qy.class("DialogStyle1", qy.tank.view.style.DialogBaseStyle, "view/style/DialogStyle1")

function DialogStyle1:ctor(params)
    DialogStyle1.super.ctor(self, params)
    self:InjectView("title_bg")
    self:InjectView("title")

    -- self.closeBtn:setPosition(self.frame:getPositionX()+params.size.width /2 self.closeBtn:getContentSize().width/4, self.frame:getPositionY()+params.size.height/2 + self.closeBtn:getContentSize().height/4)
    self.closeBtn:setPosition(params.size.width + 10,params.size.height + 20)
    self.title_bg:setPosition(self.frame:getPositionX(), self.frame:getPositionY()+params.size.height/2)
    self.bg:setContentSize(params.size.width - 20,params.size.height -20)

    if params.titleUrl then
    	self.title:setVisible(true)
        self:setTitle(params.titleUrl)
    else
    	self.title:setVisible(false)
    end


    if params.bgShow == false then
        self.bg:setVisible(false)
    end
end


-- 改变title
function DialogStyle1:setTitle(titleUrl)
    if cc.SpriteFrameCache:getInstance():getSpriteFrame(titleUrl) then
        self.title:setSpriteFrame(titleUrl)
    else
        self.title:setTexture(titleUrl)
    end
end

return DialogStyle1