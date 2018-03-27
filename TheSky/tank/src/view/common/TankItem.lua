--[[
	tank item
	Author: H.X.Sun
	Date: 2015-07-30

	local TankItem = qy.tank.view.common.TankItem.new({
		["entity"] = entity,
		["scale"] = 1, --缩放，可以为nil，默认为1
		["namePos"] = 名字位置：默认1， 1：在下面；2:,在里面
		["fontSize"] = 18,字体默认18
	})
--]]

local TankItem = qy.class("TankItem", qy.tank.view.BaseView, "view/common/TankItem")

function TankItem:ctor(params)
    TankItem.super.ctor(self)

	self:InjectView("fatherSprite")
	self:InjectView("childSprite")
	self:InjectView("tank_fragment")
	self:InjectView("name")
	self:InjectView("num")
	self.name:enableOutline(cc.c4b(0,0,0,255),1)

	if params then
		self:update(params)
	end
end

function TankItem:update(params)
	self.fatherSprite:loadTexture(params.entity:getIconBg(), 0)
	self.childSprite:setTexture(params.entity:getIcon())
	self.name:setString(params.entity.name)
	self.name:setTextColor(qy.tank.utils.ColorMapUtil.qualityMapColor(params.entity.quality))

	if params.callback then
		self:OnClickForBuilding(self.fatherSprite, function()
			params.callback(self)
		end,{["isScale"] = false})
	end
	self.fatherSprite:setSwallowTouches(false)

	if params.isFragment then
		self.tank_fragment:setVisible(true)
		self.num:setVisible(true)
		self.num:setString(params.num)
	end

	if params.scale == nil then
		params.scale = 0.824
	end
	self.fatherSprite:setScale(params.scale)

	if params.namePos == nil then
		params.namePos = 1
	end

	if params.namePos == 2 then
		--在里面
		self.name:setPosition(180,qy.InternationalUtil:getTankItemNameY())
		self.name:setAnchorPoint(1,0.5)
	elseif params.namePos == 1 then
		--在下面
		self.name:setPosition(97,-15)
		self.name:setAnchorPoint(0.5,0.5)
	end
	if params.fontSize == nil then
		params.fontSize = qy.InternationalUtil:getTankFontSize()
	end

	self.name:setFontSize(params.fontSize)
end

function TankItem:getWidth()
	return self.fatherSprite:getContentSize().width
end

function TankItem:getHeight()
	return self.fatherSprite:getContentSize().height + self.name:getContentSize().height
end

--是否显示标题
function TankItem:showTitle(show)
	self.name:setVisible(show)
end

function TankItem:getTitle()
	return ""
end

function TankItem:getColor()
	return ""
end

--设置title位置，目前有两个参数：
--1：在下面；2:,在里面
function TankItem:setTitlePosition(namePos)
	self.name:setVisible(true)
	if namePos == 2 then
		--在里面
		self.name:setPosition(185,20)
		self.name:setAnchorPoint(1,0.5)
	elseif namePos == 1 then
		--在下面
		self.name:setPosition(97,-15)
		self.name:setAnchorPoint(0.5,0.5)
	end
end

--[[--
--创建角标
--params.cornerUrl:角标图
--params.cornerPos:位置
--]]
function TankItem:createCorner(params)
    if self.cornerSprite == nil then
        self.cornerSprite = cc.Sprite:create()
        self:addChild(self.cornerSprite)
    end
    if params.cornerUrl then
        self.cornerSprite:setTexture(params.cornerUrl)
    end
    if params.pos then
        self.cornerSprite:setPosition(params.pos)
    else
        self.cornerSprite:setPosition(0,0)
    end
end

function TankItem:setTouchEnabled(flag)
    self.fatherSprite:setTouchEnabled(flag)
end

return TankItem
