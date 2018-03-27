--[[
    item card
    Author: H.X.Sun
    Date: 2015-05-08

--用法：
    local itemCard =  qy.tank.view.common.ItemCard.new({
        ["card"] = TankEntity:getCard(),
        ["frame"] = TankEntity:getCardFrame(),
        ["name"] = TankEntity.name,
        ["bgScale"] = 1,
        ["callback"] = callback,
        ["hasLevel"] = 0,--是否显示等级0：否1：是
    })
    -- bgScale 可以为nil，默认为1
    --callback 可以为nil, 没有点击事件为nil
    --level 如果不用显示等级，则传nil
    --lineColor 等级描边的颜色，如果没有等级label， 则为nil，默认cc.c4b(0,0,0,255)
    --创建为有坦克名称的坦克卡
]]

local ItemCard = qy.class("ItemCard", qy.tank.view.BaseItem)

function ItemCard:ctor(params)
    ItemCard.super.ctor(self, {
        ["fatherImg"] = params.entity:getCard(),
        ["childImg"] = params.entity:getCardFrame(),
        ["offset"] = cc.p(158,90),
    })
    self.params = params
    if params.callback then
        self:OnClickForBuilding(self.fatherSprite, function()
            params.callback(self)
        end)
    end
    self.fatherSprite:setSwallowTouches(false)
    self.childSprite:setSwallowTouches(false)
    self.name = cc.Label:createWithTTF(params.entity.name,qy.res.FONT_NAME_2, 26.0,cc.size(300,0),1)
    self.name:enableOutline(cc.c4b(0,0,0,255),1)
    self.name:setAnchorPoint(0.5,1)
    self.name:setTextColor(cc.c4b(255, 255, 255,255))
    self.name:setPosition(174,48)
    self.childSprite:addChild(self.name)

    self.sealSprite = ccui.ImageView:create()
    self.sealSprite:setPosition(273,145)
    self.fatherSprite:addChild(self.sealSprite)

    self:updateSeal(params)

    if params.bgScale == nil then
        params.bgScale = 1
    end
    self.fatherSprite:setScale(params.bgScale)
    if params.hasLevel == 1 then
        --如果有添加等级的需求
        self:updateLeve(params.entity.level)
    end

    if params.expandArr and params.expandArr.cornerUrl then
        if not tolua.cast(self.cornerSprite,"cc.Node") then
            self.cornerSprite = ccui.ImageView:create()
            self.cornerSprite:setPosition(38,160)
            self.fatherSprite:addChild(self.cornerSprite)
        end
        self.cornerSprite:loadTexture(params.expandArr.cornerUrl)
    end
end

function ItemCard:getWidth()
    return self.card:getContentSize().width
end

function ItemCard:getHeight()
    return self.card:getContentSize().height
end

function ItemCard:showTitle(show)
    self.name:setVisible(show)
end

function ItemCard:getTitle()
    return self.params.entity.name
end

function ItemCard:getColor()
    return qy.tank.utils.ColorMapUtil.qualityMapColor(self.params.entity.quality)
end

function ItemCard:setTitlePosition(namePos)

end

--[[--
--更新
--]]
function ItemCard:update(params)
    if params.entity then
        self.fatherSprite:loadTexture(params.entity:getCard())
        self.childSprite:loadTexture(params.entity:getCardFrame())
        self.name:setString(params.entity.name)
    end
    if params.hasLevel == 1 then
        self:updateLeve(params.entity.level)
    end

    if params.callback then
        self:OnClickForBuilding(self.fatherSprite, function()
            params.callback(self)
        end)
    end
    self:updateSeal(params)
end

function ItemCard:updateSeal(params)
    if params.hasSeal == nil then
        params.hasSeal = true
    end

    if params.hasSeal then
        cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/common/icon/common_icon.plist")
         self.sealSprite:loadTexture(params.entity:getSealIcon(),1)
         self.sealSprite:setVisible(true)
    else
         self.sealSprite:setVisible(false)
    end
end

--[[--
--等级
--]]
function ItemCard:updateLeve(nLevel)
    if self.level == nil then
        self.level = cc.Label:createWithTTF("LV." ..nLevel,qy.res.FONT_NAME, 20.0,cc.size(300,0),1)
        if lineColor == nil then
            lineColor = cc.c4b(0,0,0,255)
        end
        self.level:enableOutline(cc.c4b(0, 0, 0,255),1)
        self.level:setAnchorPoint(0.5,1)
        self.level:setTextColor(cc.c4b(255, 255, 255,255))
        self.level:setPosition(60,210)
        self.childSprite:addChild(self.level)
    else
        self.level:setString("LV." ..nLevel)
        self.level:enableOutline(lineColor,1)
    end
end

--[[--
--创建角标
--params.cornerUrl:角标图
--params.cornerPos:位置
--]]
function ItemCard:createCorner(params)
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

function ItemCard:setTouchEnabled(flag)
    self.fatherSprite:setTouchEnabled(flag)
end

return ItemCard
