--[[
--tip
--Author: H.X.Sun
--Date: 2015-05-21
]]

local GeneralTip = qy.class("GeneralTip", qy.tank.view.BaseView, "view/tip/GeneralTip")

function GeneralTip:ctor(params)
    GeneralTip.super.ctor(self)

	self.params = params
	local style = qy.tank.view.style.DialogStyle5.new({
		size = cc.size(441,220),
        position = cc.p(0,0),
        offset = cc.p(0,0),

		-- ["onClose"] = function()
		-- 	-- self:dismiss()
		-- end
	})
	self:addChild(style, -1)
	self:InjectView("name")
	self:InjectView("intro")
	self:InjectView("panel")
	-- qy.tank.utils.TextUtil:autoChangeLine(self.intro , cc.size(247 , 55))

	self.icon = params.icon
	self.nameStr = params.name
	self.introStr = params.intro


	if type(params.iconScale) == "number" then
		self.icon.childSprite:setScale(params.iconScale)
	end

	--加了个比较傻逼的图片 特殊处理；
	if params.icons == "props/62.png" then
		self.icon.childSprite:setScale(0.94)
	end
	if params.icons == "props/97.png" then
		--这个闲字儿小，放大一点
		self.intro:setFontSize(18)
	end
	assert(self.icon, "icon不能为空")
	assert(self.nameStr, "name不能为空")
	-- assert(self.introStr, "intro不能为空")
	if self.introStr == nil then
		self.introStr = ""
	end
	self.icon:setPosition(90,70)
	self.panel:addChild(self.icon)

	self.name:setString(self.nameStr)
	print("ssssssss+++++++++", params.nameTextColor)
	self.name:setTextColor(params.nameTextColor)
	self.name:enableOutline(cc.c4b(0,0,0,255),1)
	
	self.intro:setString(self.introStr)

	if self.colorSprite then
        self.colorSprite:loadTexture(params.color)
    else
        self.colorSprite = ccui.ImageView:create(params.color,ccui.TextureResType.localType)
        self.colorSprite:setPosition(56.5,56.5)
        self.icon.fatherSprite:addChild(self.colorSprite)
    end
    self.icon.childSprite:setLocalZOrder(10)
end

return GeneralTip
