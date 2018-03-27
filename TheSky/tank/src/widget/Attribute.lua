--[[--
--属性组件
-- Author: H.X.Sun
--Date: 2015-05-15

--用法：
	local attribute = qy.tank.widget.Attribute.new({
        		["attributeImg"] = qy.ResConfig.IMG_ATTACK, --属性字：例如攻击力,可以为空，为空时，数字居中
        		["numType"] = 1,-- 1~?(图片num_1.png,中的，在NumPicUtils中根据这个type能找到图片的图片和宽高)
        		["hasMark"] = 1, --0没有加减号，1:有 默认为0
        		["value"] = -1,--支持正负，但图必须是由加减号 ["hasMark"] = 1
        		["anchorPoint"] = cc.p(0, 0.5) ,--锚点，默认cc.p(0,0.5)
        		["space"] = 0,
        		["picType"] = 1, --1：- + 0123456789，2：+ - 0123456789 默认是1
        		["showType"] = 1,--表现方式（默认1）：1：左字右数；2：左数右字
        	})
--]]

local Attribute = qy.class("Attribute", qy.tank.view.BaseView, "widget/Attribute")

function Attribute:ctor(params)
	cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/toast/toast_txt.plist")
    Attribute.super.ctor(self)

	self:InjectView("attributeName")
	self:InjectView("attributeName2")

	self.valueLabel = ccui.TextAtlas:create()
	self:addChild(self.valueLabel)

	self:render(params)
end

function Attribute:render(params)
	self.params = params
	if params.picType == nil then
		params.picType = 1
	end

	self.info = qy.tank.utils.NumPicUtils.getNumPicInfoByType(params.numType)

	if params.space == nil then
		params.space = 0
	end
	if params.anchorPoint == nil then
		params.anchorPoint = cc.p(0,0.5)
	end

	self:update(params.value, params.isPrecent)
	self.valueLabel:setAnchorPoint(params.anchorPoint)

	if params.attributeImg then
		if cc.SpriteFrameCache:getInstance():getSpriteFrame(params.attributeImg) then
            self.attributeName:setSpriteFrame(params.attributeImg)
        else
            self.attributeName:setTexture(params.attributeImg)
        end
		self.valueLabel:setPosition(params.space,self.attributeName:getPositionY())
		self.attributeName:setVisible(true)
		self:__changePos(params.showType)
	else
		self.valueLabel:setAnchorPoint(params.anchorPoint)
		self.valueLabel:setPosition(0,0)
		self.attributeName:setVisible(false)
	end

	if params.attributeImg2 then
		self.attributeName2:setVisible(true)
		if cc.SpriteFrameCache:getInstance():getSpriteFrame(params.attributeImg2) then
            self.attributeName2:setSpriteFrame(params.attributeImg2)
        else
            self.attributeName2:setTexture(params.attributeImg2)
        end
        local size = self.attributeName:getContentSize()
        self.attributeName2:setPositionX(self.attributeName:getPositionX() - size.width)
    else
    	self.attributeName2:setVisible(false)
	end
end

function Attribute:__changePos(showType)
	if showType == nil then
		return
	end
	if showType == 2 then
		--左数右字
		self.valueLabel:setAnchorPoint(qy.InternationalUtil:getAttributeValueLabelAnchor(),0.5)
		self.valueLabel:setPosition(qy.InternationalUtil:getAttributeValueLabelX(), qy.InternationalUtil:getAttributeValueLabelY())
		self.attributeName:setAnchorPoint(0,0.5)
		self.attributeName:setPosition(qy.InternationalUtil:getAttributeValueLabelNameX(),0)
	end
end

--[[--
--更新
--]]
function Attribute:update(value, isPrecent)
	if self.valueLabel == nil then return end
	self.params.value = value
	if self.params.hasMark == 1 then
		local valueStr = nil
		if self.params.picType == 1 then
			-- - + 0123456789
			if value >= 0 then
				valueStr = string.format("/%d", math.abs(value))
			else
				valueStr = string.format(".%d", math.abs(value))
    			end
    		elseif self.params.picType == 2 then
    			-- + -  0123456789
    			if value >= 0 then
				valueStr = string.format(".%d", math.abs(value))
			else
				valueStr = string.format("/%d", math.abs(value))
    			end
    		end

    		if isPrecent then
    			valueStr = valueStr .. '-'
    			self.valueLabel:setProperty(valueStr,self.info.numImg,self.info.width,self.info.height,"-")
    		else
    			self.valueLabel:setProperty(valueStr,self.info.numImg,self.info.width,self.info.height,".")
    		end
	else
		self.valueLabel:setProperty(value, self.info.numImg, self.info.width,self.info.height, "0")
	end
end

--[[--
--获取数字的值
--]]
function Attribute:getStringValue()
	if self.params.value then
		return self.params.value
	else
		return 0
	end
end


return Attribute
