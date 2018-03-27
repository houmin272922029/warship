--[[--
--充值返利cell
--Author: H.X.Sun
--Date: 2015-06-24
--]]--

local TotalPayCell = qy.class("TotalPayCell", qy.tank.view.BaseView, "view/operatingActivities/totalPay/TotalPayCell")

local tankType = qy.tank.view.type.AwardType.TANK
local totalPayType = qy.tank.view.type.ModuleType.TOTAL_PAY

function TotalPayCell:ctor(delegate)
    TotalPayCell.super.ctor(self)
    self.model = qy.tank.model.OperatingActivitiesModel

    self:InjectView("recharge_num")
    self:InjectView("hasReceive")
    self:InjectView("getBtn")
    self:InjectView("bg")
    self:InjectView("get_name")

    self:OnClick("getBtn", function(sender)
        if self.data.status == 0 then
            delegate.callBack()
            qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.RECHARGE)
            return
        end
        if self.data.type == 1 then
            self:sendMsg()
        else
            function callBack(flag)
                if flag == qy.TextUtil:substitute(63019) then
                    self:sendMsg(self.content.chooseIdx - 1)
                end
            end
            self.content = qy.tank.view.operatingActivities.totalPay.ChooseAwardCell.new({
                ["award"] = self.data.award
            })
            qy.alert:showWithNode(qy.TextUtil:substitute(63020),  self.content, cc.size(560,290), {{qy.TextUtil:substitute(63021) , 4},{qy.TextUtil:substitute(63019) , 5} }, callBack, {})
        end
    end)
end

function TotalPayCell:sendMsg(chooseIdx)
    local id = self.data.cash
    if chooseIdx then
        id = self.data.cash .. "-" .. chooseIdx
    end
    local service = qy.tank.service.OperatingActivitiesService
    service:getCommonGiftAward(id, totalPayType, true, function(reData)
        self.model:updatePayDataStatusByIdx(self.idx)
        self:updateStatus(2)
    end)
end

function TotalPayCell:render(_idx)
    self.data = self.model:getToTalPayAwardByIndex(_idx)
    self.idx = _idx
    self.recharge_num:setString(qy.TextUtil:substitute(63022).. self.data.cash.. qy.TextUtil:substitute(63023))
    if self.awardList then
        self.bg:removeChild(self.awardList)
    end

    self.awardList = qy.AwardList.new({
        ["award"] = self.data.award,
        ["cellSize"] = cc.size(120,180),
        ["type"] = 1,
        ["itemSize"] = 2,
        ["hasName"] = false,
        ["len"] = 4,
    })
    self.awardList:setPosition(80,235)
    self.bg:addChild(self.awardList)

    local _d = 1
    local _w = 30
    local _x = 0
    local _y = 0
    for i = 1, #self.data.award do
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
    end

	self:updateStatus(self.data.status)
end

function TotalPayCell:createEquipSuitEffert(_target)
    local _effert = ccs.Armature:create("Flame")
    -- _effert:setScale(1.1)
    _target:addChild(_effert,999)
    _effert:setPosition(2,0)
    _effert:getAnimation():playWithIndex(0)
    return _effert
end

function TotalPayCell:updateStatus(_status)
	if _status == 0 then
		self.getBtn:setVisible(true)
		self.hasReceive:setVisible(false)
        self.get_name:setSpriteFrame("Resources/common/txt/quchongzhi.png")
        self.get_name:setScale(1)
    elseif _status == 1 then
        self.get_name:setSpriteFrame("Resources/common/txt/lingqu.png")
        self.get_name:setScale(1.3)
        self.getBtn:setVisible(true)
        self.hasReceive:setVisible(false)
    else
		self.getBtn:setVisible(false)
		self.hasReceive:setVisible(true)
	end
end

return TotalPayCell
