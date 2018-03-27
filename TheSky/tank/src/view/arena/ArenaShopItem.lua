--[[
	军神榜商店item
	Author: Aaron Wei
	Date: 2015-12-29 14:26:46
]]

local ArenaShopItem = qy.class("ArenaShopItem", qy.tank.view.BaseView, "view/fightJapan/ExchangeItem")

local tankType = qy.tank.view.type.AwardType.TANK
local userInfoModel = qy.tank.model.UserInfoModel
local awardCommand = qy.tank.command.AwardCommand

function ArenaShopItem:ctor(delegate)
    ArenaShopItem.super.ctor(self)

    self.delegate = delegate

    self:InjectView("bg")
    self:InjectView("coinIcon")
    self:InjectView("valueTxt")
    self:InjectView("limited")
    self:InjectView("soldOut")
    self:InjectView("itemNode")

    self.coinIcon:initWithFile("Resources/common/icon/coin/21.png")
    self.coinIcon:setScale(0.6)

    self:OnClickForBuilding("bg", function(sender)
        if not delegate:isTouchMoved() then
            self:clickLogic()
        end
    end,{["isScale"] = false})
    self.bg:setSwallowTouches(false)
end

--商品点击
function ArenaShopItem:clickLogic()
    if self.exData.remain_times == 0 then
        qy.hint:show(qy.TextUtil:substitute(4013))
        return
    end

    local num = tonumber(self.exData.award[1].num)
    local numStr = num <=1 and "" or "x"..num

    local itemData = qy.tank.view.common.AwardItem.getItemData(self.exData.award[1])

    local image = ccui.ImageView:create()
    image:setContentSize(cc.size(500,120))
    image:setScale9Enabled(true)
    image:loadTexture("Resources/common/bg/c_12.png")
    self:OnClick(image, function(sender)
        if itemData.callback then
            itemData.callback()
        end
    end,{["isScale"] = false})

    local color = qy.tank.utils.ColorMapUtil.qualityMapColorFor3b(itemData.quality)

    local richTxt = ccui.RichText:create()
    richTxt:ignoreContentAdaptWithSize(false)
    richTxt:setContentSize(500, 150)
    richTxt:setAnchorPoint(0,0.5)
    local stringTxt1 = ccui.RichElementText:create(1, cc.c3b(255,255,255), 255, qy.TextUtil:substitute(4007), qy.res.FONT_NAME_2, 24)
    richTxt:pushBackElement(stringTxt1)
    local stringTxt2 = ccui.RichElementText:create(2, cc.c3b(255,255,0), 255, self.exData.cost , qy.res.FONT_NAME_2, 24)
    richTxt:pushBackElement(stringTxt2)
    local stringTxt3 = ccui.RichElementText:create(3, cc.c3b(255,255,255), 255, qy.TextUtil:substitute(4008), qy.res.FONT_NAME_2, 24)
    richTxt:pushBackElement(stringTxt3)
    local stringTxt4 = ccui.RichElementText:create(4, color, 255, itemData.name , qy.res.FONT_NAME_2, 24)
    richTxt:pushBackElement(stringTxt4)
    local stringTxt5 = ccui.RichElementText:create(5, cc.c3b(255,255,0), 255, numStr , qy.res.FONT_NAME_2, 24)
    richTxt:pushBackElement(stringTxt5)
    image:addChild(richTxt)

    local function callback(flag)
        if qy.TextUtil:substitute(4012) == flag then
            if userInfoModel.userInfoEntity.prestige >= self.exData.cost then
                local param1 = {}
                param1.id = self.exData.id
                qy.tank.service.ArenaService:exchageItem(param1,function(data)
                    self:update()
                    local awardData = data.award
                    awardCommand:add(awardData)
                    awardCommand:show(awardData)
                end)
            else
                qy.hint:show(qy.TextUtil:substitute(4009))
            end
        end
    end

    qy.alert:showWithNode(qy.TextUtil:substitute(4010),  image, cc.size(560,250), {{qy.TextUtil:substitute(4011) , 4},{qy.TextUtil:substitute(4012) , 5} }, callback, {})
    image:setPosition(image:getPositionX() + 5, image:getPositionY() - 30)

end

function ArenaShopItem:render(data)
    self.exData = data
    if self._awardItem then
        self.itemNode:removeChild(self._awardItem)
        self._awardItem = nil
    end

    local itemData = qy.tank.view.common.AwardItem.getItemData(data.award[1],false)
    if data.award[1].type == tankType then
        itemData.namePos = 2
        itemData.fontSize = 18
        itemData.scale = 0.82
        self._awardItem = qy.tank.view.common.TankItem.new(itemData)
        self._awardItem:setPosition(0, 10)
    else
        itemData.size = cc.size(0,0)
        itemData.fontSize = 20
        itemData.bgScale = 0.82
        self._awardItem = qy.tank.view.common.ItemIcon.new(itemData)
        self._awardItem:setTitlePosition(1)
        self._awardItem:setPosition(0, -4)
    end
    self:update(data.remain_times)

    if data.purchase_type == 2 then
        self.limited:setVisible(true)
    else
        self.limited:setVisible(false)
    end
    self.valueTxt:setString(data.cost)

    self.itemNode:addChild(self._awardItem)
    self.itemData = itemData
end

function ArenaShopItem:update()
    if self.exData.remain_times == 0 then
        self.soldOut:setVisible(true)
    else
        self.soldOut:setVisible(false)
    end
end

return ArenaShopItem
