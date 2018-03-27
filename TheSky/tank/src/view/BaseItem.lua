--[[
	base item
	Author: Your Name
	Date: 2015-05-13

用法：
    	1)  创建
    		qy.tank.view.BaseItem.new({
        			["fatherImg"] = itemData.card,
        			["childImg"] = itemData.frame,
        			["offset"] = cc.p(158,82), 
        		})
		fatherImg：为下面的图片, 在card中, 则为tankCard,在icon中,则为iconBg (fatherSprite)
		childImg：为下面的图片, 在card中, 则为frame,在icon中,则为icon图片, (childSprite 为 fatherSprite的子节点)
		offset：偏移量，可以为nil，默认为 ["offset"] = cc.p(0,0)，如果使用icon，则使用默认值即可，如果使用card, 则 ["offset"] = cc.p(-0.5,-10.5)

        	2)对item增加点击监听
    	3)item的名字
    	card ：
    		self.name = cc.Label:createWithTTF(itemData.name,qy.res.FONT_NAME, 20.0,cc.size(300,0),1)
    		self.name:enableOutline(cc.c4b(0,0,0,255),1)
    		self.name:setAnchorPoint(0.5,1)
    		self.name:setTextColor(cc.c4b(255, 255, 255,255))
    		self.name:setPosition(174,32)
     		self.childSprite:addChild(self.name) --已self.childSprite为父节点
     		也可以直接使用 ItemCard

]]

local BaseItem = qy.class("BaseItem", qy.tank.view.BaseView)

function BaseItem:ctor(params)
    cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/common/item/common_item.plist")
    BaseItem.super.ctor(self)
    self.fatherSprite = ccui.ImageView:create()

    if cc.SpriteFrameCache:getInstance():getSpriteFrame(params.fatherImg) then
        self.fatherSprite:loadTexture(params.fatherImg,1)
    else
        self.fatherSprite:loadTexture(params.fatherImg,ccui.TextureResType.localType)
    end

    self.fatherSprite:setPosition(0,0)
    self:addChild(self.fatherSprite)

    self.childSprite = ccui.ImageView:create(params.childImg,ccui.TextureResType.localType)
    self.fatherSprite:addChild(self.childSprite)
    if params.offset then
        self.childSprite:setPosition(params.offset)
	else
        self.childSprite:setPosition(0,0)
	end

    -- 选中光
    if not self.light then
        self.light = ccui.ImageView:create("Resources/common/img/XL_11.png",1)
        self.light:setTextureRect(cc.rect(43, 43, 43,43))
        self.light:setScale9Enabled(true)
        self.light:setContentSize(cc.size(120, 120))
        -- self.light:setPosition(58, 58)
        self.light:setVisible(false)
        self:addChild(self.light)
    end
end

return BaseItem