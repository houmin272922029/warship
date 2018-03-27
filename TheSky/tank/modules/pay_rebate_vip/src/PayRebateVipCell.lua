--[[--
--新版累充返利cell
--Author: Fu.Qiang
--Date: 2016-07-04
--]]--

local PayRebateVipCell = qy.class("PayRebateVipCell", qy.tank.view.BaseView, "pay_rebate_vip/ui/payRebateVipCell")

local _moduleType = qy.tank.view.type.ModuleType.PAY_REBATE_VIP

function PayRebateVipCell:ctor(delegate)
    PayRebateVipCell.super.ctor(self)
    self.model = qy.tank.model.OperatingActivitiesModel

    --self:InjectView("recharge_num")
    --self:InjectView("hasReceive")
    --self:InjectView("getBtn")
    --self:InjectView("bg")
    --self:InjectView("get_name")

    self:InjectView("pay_num_txt")
    self:InjectView("hasReceive")
    self:InjectView("go_pay_btn")
    self:InjectView("bg")
    self:InjectView("quchongzhi")

    self:OnClick("go_pay_btn", function(sender)
        if self.data.status == 0 then
            delegate.callBack()
            qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.RECHARGE)
            return
        end
        if self.data.type == 1 then
            self:sendMsg()
        else
            --[[--function callBack(flag)
                if flag == qy.TextUtil:substitute(63011) then
                    self:sendMsg(self.content.chooseIdx - 1)
                end
            end
            self.content = qy.tank.view.operatingActivities.pay_rebate.ChooseAwardCell.new({
                ["award"] = self.data.award
            })
            qy.alert:showWithNode(qy.TextUtil:substitute(63012),  self.content, cc.size(560,290), {{qy.TextUtil:substitute(63013) , 4},{qy.TextUtil:substitute(63011) , 5} }, callBack, {})
            --]]--
        end
    end)
end

function PayRebateVipCell:sendMsg(chooseIdx)
    local id = self.data.cash
    if chooseIdx then
        id = self.data.cash .. "-" .. chooseIdx
    end
    local service = qy.tank.service.OperatingActivitiesService
    service:getCommonGiftAward(id, _moduleType, true, function(reData)
        self.model:upRebateDataVipStaByIdx(self.idx)
        self:updateStatus(2)
    end)
end

function PayRebateVipCell:render(_idx)
    self.data = self.model:getPayRebateVipAwardByIndex(_idx)
    self.idx = _idx
    self.pay_num_txt:setString(qy.TextUtil:substitute(63014).. self.data.cash.. qy.TextUtil:substitute(63015))
    if self.awardList then
        self.bg:removeChild(self.awardList)
    end

    self.awardList = qy.AwardList.new({
        ["award"] = self.data.award,
        ["cellSize"] = cc.size(130,180),
        ["type"] = 1,
        ["itemSize"] = 2,
        ["hasName"] = false,
    })
    self.awardList:setPosition(80,240)
    self.bg:addChild(self.awardList)

    if self.vip_btn then
        self.bg:removeChild(self.vip_btn)
    end

    if self.data.vip_lv then
        cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/common/icon/vip/vip_icon.plist")

        self.vip_btn = ccui.ImageView:create()
        self:OnClick(self.vip_btn, function(sender)
            qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.VIP, {["index"] = self.data.vip_lv})
        end,{["isScale"] = false})
        self.vip_btn:setSwallowTouches(false)
        self.vip_btn:loadTexture("Resources/common/icon/vip/"..tostring(self.data.vip_lv)..".png", 1)
        self.vip_btn:setPosition(460, 60)
        self.bg:addChild(self.vip_btn, 1)
    end

    local _d = 1
    local _w = 30
    local _x = 0
    local _y = 0
    --[[--for i = 1, #self.data.award do
        if self.data.award[i].type == tankType then
            _x = self.awardList.list[i]:getPositionX() + _d * _w
            _y = self.awardList.list[i]:getPositionY()
            self.awardList.list[i]:setPosition(_x, _y)
            _d = _d + 2
            self.awardList.list[i]:setTitlePosition(2)
        end

        -- if self.data.award[i].type == 12 then
        --     local itemData = qy.tank.view.common.AwardItem.getItemData(self.data.award[i])
        --     if itemData.entity:getSuitID() > 0 then
        --         self:createEquipSuitEffert(self.awardList.list[i])
        --     end
        -- end
    end--]]--

	self:updateStatus(self.data.status)
end

function PayRebateVipCell:createEquipSuitEffert(_target)
    local _effert = ccs.Armature:create("Flame")
    -- _effert:setScale(1.1)
    _target:addChild(_effert,999)
    _effert:setPosition(2,0)
    _effert:getAnimation():playWithIndex(0)
    return _effert
end

function PayRebateVipCell:updateStatus(_status)
	if _status == 0 then
		self.go_pay_btn:setVisible(true)
		self.hasReceive:setVisible(false)
        self.quchongzhi:setSpriteFrame("Resources/common/txt/quchongzhi.png")
        self.quchongzhi:setScale(1)
    elseif _status == 1 then
        self.quchongzhi:setSpriteFrame("Resources/common/txt/lingqu.png")
        self.quchongzhi:setScale(1.3)
        self.go_pay_btn:setVisible(true)
        self.hasReceive:setVisible(false)
    else
		self.go_pay_btn:setVisible(false)
		self.hasReceive:setVisible(true)
	end
end

return PayRebateVipCell
