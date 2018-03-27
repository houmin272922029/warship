local ItemView = qy.class("ItemView", qy.tank.view.BaseView, "recharge_king.ui.ItemView")

local model = qy.tank.model.OperatingActivitiesModel
local service = qy.tank.service.OperatingActivitiesService
function ItemView:ctor(delegate)
   	ItemView.super.ctor(self)
    -- self:InjectView("Day")
    self:InjectView("Image_1")
    self:InjectView("Button_1")
    self:InjectView("HasGot")
    self:InjectView("Btn_text")
    self:InjectView("Name")
    self:InjectView("Rechage")

    self.Image_1:setSwallowTouches(false)
   	self:OnClick("Button_1", function()
        if self.status == 1 then
            delegate:removeSelf()
            qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.RECHARGE)
        elseif self.status == 2 then
            service:getCommonGiftAward(nil, qy.tank.view.type.ModuleType.RECHARGE_KING,false, function(data)
                self.status = 5
                self:update()
            end)
        elseif self.status == 3 then
            qy.hint:show(qy.TextUtil:substitute(60001))
        elseif self.status == 4 then
            qy.hint:show(qy.TextUtil:substitute(60002))
        end
    end,{["isScale"] = false})

    self.item = {}
    for i = 1, 3 do
        local item = qy.tank.view.common.ItemIcon.new()
        self.item[i] = item
        self:addChild(item)
        item:setPosition(150 + i * 120, 90)
        item:setScale(0.95)
    end

    local rank = ccui.TextAtlas:create("2", "recharge_king/fx/level_number.png", 26, 25, '0')
    rank:setPosition(134, 102)
    rank:setAnchorPoint(0.5, 0.5)
    self.rank = rank
    self:addChild(rank)
end

function ItemView:setData(data, idx)
    self.rank:setString(idx + 1)

    for i, v in pairs(data.award) do
        local itemData = qy.tank.view.common.AwardItem.getItemData(v)
        -- print("奖励",json.encode(itemData))
        self.item[i]:setData(itemData)
        if v.type == 22 then
            self.item[i].num:setString("Lv." .. itemData.entity.level)
        end
    end
    for i=1,3 do
        self.item[i]:setVisible(data.award[i] and true or false)
    end

    self.Rechage:setString(qy.TextUtil:substitute(60003) .. data.amount .. qy.TextUtil:substitute(60004))
    if model.rechargeKingRankList[tostring(idx + 1)] then
        self.Name:setString("["..model.rechargeKingRankList[tostring(idx + 1)].server.."]"..model.rechargeKingRankList[tostring(idx + 1)].nickname)
    else
        self.Name:setString(qy.TextUtil:substitute(60005))
    end

    -- 1去充值,2领取,3非本人不可领取,4充值金额不足不可领取，5已领取
    local rankData = model.rechargeKingRankList[tostring(idx + 1)]


    if qy.tank.model.UserInfoModel.serverTime >= model.rechargeKingEndTime then
            if rankData and rankData.kid == qy.tank.model.UserInfoModel.userInfoEntity.kid then
                if model.rechargeKingAmount >= data.amount then
                    if model.rechargeKingDrawAward == 0 then
                        self.status = 2 -- 排行榜本人，并且活动已经结束，自己的充值金额满足条件
                        self.Btn_text:setSpriteFrame("Resources/common/txt/lingqu.png")
                    else
                        self.status = 5  -- 已领取
                    end
                else
                    self.Btn_text:setSpriteFrame("Resources/common/txt/lingqu.png")
                    self.status = 4 -- 排行榜本人，充值活动已结束，但充值金额不满足条件
                end
            else
                self.Btn_text:setSpriteFrame("Resources/common/txt/lingqu.png")
                self.status = 3  -- 不是排行榜本人不能领取
            end

    else
        self.status = 1 --活动进行中只能充值
        self.Btn_text:setSpriteFrame("Resources/common/txt/quchongzhi.png")
    end

    self.Button_1:setBright(self.status == 1 or self.status == 2)
    self:update()
end

function ItemView:update()
    self.HasGot:setVisible(self.status == 5)
    self.Button_1:setVisible(self.status ~= 5)
end

return ItemView
