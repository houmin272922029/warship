--[[
    item icon
    Author: H.X.Sun
    Date: 2015-05-08
--用法：
    local itemIcon = qy.tank.view.common.ItemIcon.new({
        ["bg"] = "",
        ["icon"] = "",
        ["num"] = 10,
        ["name"] = "xxx",
        ["iconScale"] = 1, --icon缩放，可以为nil，默认为1
        ["bgScale"] = 1,--bg缩放，可以为nil，默认为1
        ["nameTextColor"] = "xxx"--名字颜色
        ["type"] = 13,--装备碎片需要角标，所以要type
    })
--]]

local ItemIcon = qy.class("ItemIcon", qy.tank.view.BaseItem)

local AwardType = qy.tank.view.type.AwardType

function ItemIcon:ctor(params)

    if params then
        ItemIcon.super.ctor(self, {
            ["fatherImg"] = params.bg,
            ["childImg"] = params.icon,
            ["offset"] = cc.p(65.5,65.5),
            ["localType"] = 1,
        })
        self:setData(params)
    end
end

function ItemIcon:setData(params)
    if not self.fatherSprite then
        ItemIcon.super.ctor(self, {
            ["fatherImg"] = params.bg,
            ["childImg"] = params.icon,
            ["offset"] = cc.p(65.5,65.5),
            ["localType"] = 1,
        })
    end

    self.params = params
    local swTouches = false

    if not params.beganFunc then
        params.beganFunc = function(self)

        end
    end

    if params.callback then
        swTouches = true
        self:OnClickNew(self.fatherSprite, function()
            params.callback(self)
        end,{["isScale"] = false, ["beganFunc"] = params.beganFunc})
    end

    -- if self.colorSprite then
    --     self.colorSprite:loadTexture(params.bg)
    -- else
    --     self.colorSprite = ccui.ImageView:create(params.bg,ccui.TextureResType.localType)
    --     self.fatherSprite:addChild(self.colorSprite)
    -- end
    -- self.colorSprite:setSwallowTouches(false)

    self.fatherSprite:setSwallowTouches(swTouches)
    self.childSprite:loadTexture(params.icon,ccui.TextureResType.localType)


    self.fatherSprite:loadTexture(params.bg,ccui.TextureResType.plistType)
    local _size = self.fatherSprite:getContentSize()
    -- self.colorSprite:setPosition(_size.width/2,_size.height/2)
    self.childSprite:setPosition(_size.width/2,_size.height/2)

    -- self.childSprite:setLocalZOrder(10)


    if params.fontSize == nil then
        params.fontSize = 20
    end

    --如果物品数量为0，则隐藏数量
    if params.num and params.num > 0 then
        if not self.num then
            self.num = cc.Label:createWithTTF(params.num,"Resources/font/ttf/black_body_2.TTF", params.fontSize,cc.size(0,0),1)
            self.num:enableOutline(cc.c4b(0,0,0,255),1)
            self.num:setAnchorPoint(1,0)
            self.num:setTextColor(cc.c4b(255, 255, 255,255))
            -- self.num:setPosition(30,-30)
            self:addChild(self.num)
        end
        self.num:setString(params.num)
    end

    if params.size == nil then
        params.size = cc.size(220,50)
    end

    -- self.name = cc.Label:createWithSystemFont(params.name,nil,18,cc.size(165,50),cc.TEXT_ALIGNMENT_CENTER,cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
    if not self.name then
        self.name = cc.Label:createWithTTF(params.name,"Resources/font/ttf/black_body_2.TTF", (qy.InternationalUtil:getItemIconNameFontSize()),params.size,1)--cc.size(165,50)
        self.name:enableOutline(cc.c4b(0,0,0,255),1)
        if self.name:getStringLength() < 8 then
            self.name:setHeight(25)
        end
        self.name:setAnchorPoint(0.5,1)
        if params.nameTextColor then
            self.name:setTextColor(params.nameTextColor)
        end
        self:addChild(self.name)
    else
        if params.nameTextColor then
            self.name:setTextColor(params.nameTextColor)
        end
        self.name:setString(params.name)
    end
    -- self.name:setPosition(2,-80)

    if params.iconScale == nil then
        params.iconScale = 1
    end
  
    self.childSprite:setScale(params.iconScale)
  

    if params.icon and "props/62.png" == params.icon then --有个道具图片比较sb 暂时这样处理下
        self.childSprite:setScale(0.94)
    end

    if params.type == AwardType.PASSENGER_FRAGMENT or params.type == AwardType.PASSENGER then
        self.childSprite:setScale(1)
        self.childSprite:setPosition(_size.width/2,_size.height/2+1)
    end
    if params.bgScale == nil then
        params.bgScale = 1
    end
    self.fatherSprite:setScale(params.bgScale)

    --自动调整尺寸
    local totalWidth , totalHeight
    totalWidth = self.fatherSprite:getContentSize().width * params.bgScale
    totalHeight = self.fatherSprite:getContentSize().height * params.bgScale

    --自动设置数量和名称位置
    if self.num then
        self.num:setPosition((totalWidth)/2-11* params.bgScale,(-totalHeight)/2 + 8)
    end

    self:setTitlePosition(2)
    -- totalHeight = totalHeight - 1
    -- self.name:setPosition(0,-totalHeight/2+3)

    if params.type then
        local cornerData = {}
        if params.type == AwardType.EQUIP_FRAGMENT then
            cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/equip/equip.plist")
            cornerData.cornerUrl = "Resources/equip/suipian.png"
            cornerData.pos = cc.p(-8,8)
        elseif params.type == AwardType.STORAGE then
            cornerData.cornerUrl = "props/corner_"..params.id..".png"
            cornerData.pos = cc.p(-12,28)
        elseif params.type == AwardType.PASSENGER_FRAGMENT then
            cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/equip/equip.plist")
            cornerData.cornerUrl = "Resources/equip/suipian2.png"
            cornerData.pos = cc.p(-20,20)
        end
        self:createCorner(cornerData,params)
    end

    if tolua.cast(self.effert,"cc.Node") then
        self.effert:getParent():removeChild(self.effert)
    end

    -- if params.type and params.type == AwardType.EQUIP and params.entity:isHasSuit() then
    --     self.effert = self:createEquipSuitEffert()
    -- end

    if params.type then
        if params.type == AwardType.EQUIP or params.type == AwardType.EQUIP_FRAGMENT then
            if params.entity:isHasSuit() then
                self.effert = self:createEquipSuitEffert()
            end
        end
    end
    if params.bg == "Resources/common/item/newcommon.png" then
        self.childSprite:setScale(0.75)
    end
end

function ItemIcon:createEquipSuitEffert()
    local _effert = ccs.Armature:create("Flame")
    -- _effert:setScale(1.1)
    self.fatherSprite:addChild(_effert,999)
    -- _effert:setPosition(51,49)
    local w = self:getWidth() / 2
    _effert:setPosition(w,w)
    _effert:getAnimation():playWithIndex(0)
    return _effert
end

function ItemIcon:getWidth()
    return self.fatherSprite:getContentSize().width
end

function ItemIcon:setHorizontalAlignment()
    self.name:setHorizontalAlignment(0)
end

function ItemIcon:getHeight()
    return self.fatherSprite:getContentSize().height + self.name:getContentSize().height
end

--是否显示标题
function ItemIcon:showTitle(show)
    self.name:setVisible(show)
end

function ItemIcon:setNameAnchorPoint(x,y)
    self.name:setAnchorPoint(x,y)
end

function ItemIcon:changeTitle(_str)
    self.name:setString(_str)
end

function ItemIcon:getTitle()
    return self.params.name
end

function ItemIcon:getColor()
    return self.params.nameTextColor
end

--设置title位置，目前有两个参数：
--1，标题至于icon之上。
--2，标题至于icon之下。
--3 ,标题在框内，且在正下方
function ItemIcon:setTitlePosition(namePos)
    local totalWidth , totalHeight
    totalWidth = self.fatherSprite:getContentSize().width * self.params.bgScale
    totalHeight = self.fatherSprite:getContentSize().height * self.params.bgScale
    if namePos == 2 then
        totalHeight = totalHeight - 1
        self.name:setPosition(0,-totalHeight/2+3)
    elseif namePos ==1 then
        self.name:setPosition(0,(totalHeight/2 + self.name:getContentSize().height))
    elseif namePos == 3 then
        self.name:setPosition(0, self.name:getContentSize().height -totalHeight/2+13)
    elseif namePos == 4 then
        self.name:setAnchorPoint(0.5, self.name:getAnchorPoint().y)
        self.name:setPosition(totalWidth + 75, self.name:getContentSize().height / 2)
    elseif namePos == 5 then
        self.name:setPosition(-46, 48)
    end
end

--[[--
--创建角标
--params.cornerUrl:角标图
--params.cornerPos:位置
--]]
function ItemIcon:createCorner(params,params2)
    if self.cornerSprite == nil then
        self.cornerSprite = cc.Sprite:create()
        self:addChild(self.cornerSprite)
        if params2.bg == "Resources/common/item/newcommon.png" then
            self.childSprite:setScale(0.7)
        else
            self.cornerSprite:setScale(self.fatherSprite:getScale())
        end
    end
    if params.cornerUrl then
        if cc.SpriteFrameCache:getInstance():getSpriteFrame(params.cornerUrl) then
            self.cornerSprite:setSpriteFrame(params.cornerUrl)
        else
            self.cornerSprite:setTexture(params.cornerUrl)
        end
        if params.pos then
            self.cornerSprite:setPosition(params.pos)
        else
            self.cornerSprite:setPosition(0,0)
        end
        self.cornerSprite:setVisible(true)
    else
        self.cornerSprite:setVisible(false)
    end

end

function ItemIcon:setTouchEnabled(flag)
    self.fatherSprite:setTouchEnabled(flag)
end

function ItemIcon:updateTitle(_str)
    self.name:setString(_str)
end

return ItemIcon
