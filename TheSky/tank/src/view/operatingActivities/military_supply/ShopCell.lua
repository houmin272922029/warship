--[[
	军资整备 商店
	Author: H.X.Sun
]]
local ShopCell = qy.class("ShopCell", qy.tank.view.BaseView, "military_supply/ui/ShopCell")

function ShopCell:ctor(delegate)
   	ShopCell.super.ctor(self)
    self.delegate = delegate
    self:InjectView("bg")
    self:InjectView("title_txt")
    self:InjectView("num_txt")
    self:InjectView("btn")
    self:InjectView("get_icon")
    self:InjectView("click_btn")

    local service = qy.tank.service.OperatingActivitiesService
    local userinfoModel = qy.tank.model.UserInfoModel

    self:OnClickForBuilding("btn", function(sender)
        if not delegate:isTouchMoved() then
            if userinfoModel.userInfoEntity.ticket < self.data.number then
                qy.hint:show(qy.TextUtil:substitute(90114))
                return
            end
            service:doMilitaryAction({
                ["type"] = 5,
                ["id"] = self.data.id
            },function(data)
                qy.tank.command.AwardCommand:show(data.award)
                delegate.updateList()
            end)
        end
    end,{["isScale"] = false})

    self:OnClickForBuilding("click_btn", function(sender)
        if not delegate:isTouchMoved() then
            self.item_data.callback()
        end
    end,{["isScale"] = false})
    self.click_btn:setSwallowTouches(false)
end

function ShopCell:render(data)
    self.data = data
    local remain = data.num-data.has_num
    if data.shop_type == 1 then
        self.title_txt:setString(qy.TextUtil:substitute(90108).. remain .. "/"..data.num)
    elseif data.shop_type == 2 then
        self.title_txt:setString(qy.TextUtil:substitute(90109) .. remain .. "/"..data.num)
    elseif data.shop_type == 3 then
        self.title_txt:setString(qy.TextUtil:substitute(90110) .. remain .. "/"..data.num)
    else
        self.title_txt:setString("")
    end
    self.num_txt:setString(data.number)
    self.bg:removeAllChildren()
    self.item_data = qy.tank.view.common.AwardItem.getItemData(data.award[1],1, 0.9)
    local awardItem = qy.tank.view.common.AwardItem.createAwardView(data.award[1],1, 0.9, false)
    self.bg:addChild(awardItem)
    awardItem:setPosition(73,110)
    self:showBtn(data.status)
end

function ShopCell:showBtn(_status)
    self.status = _status
    cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/common/img/common_img.plist")
    cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/common/txt/common_txt.plist")

    if _status == 1 then
        -- 可领取
        self.btn:setVisible(true)
        self.get_icon:setVisible(false)
        self.btn:setBright(true)
        self.btn:setTouchEnabled(true)
    else
        -- 已领取/已购买/已售罄
        self.btn:setVisible(false)
        self.get_icon:setVisible(true)
        if _status == 3 then
            -- 售罄
            cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/fight_japan/fight_japan.plist")
            self.get_icon:setSpriteFrame("Resources/fight_japan/09.png")
        elseif self.tab_idx == 4 then
            -- 已购买
            self.get_icon:setSpriteFrame("Resources/common/img/ygmc.png")
        else
            -- 已领取
            self.get_icon:setSpriteFrame("Resources/common/img/D_12.png")
        end
    end
end

return ShopCell
