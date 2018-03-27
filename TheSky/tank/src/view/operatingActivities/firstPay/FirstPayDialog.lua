--[[--
--首充dialog
--Author: H.X.Sun
--Date: 2015-06-24
--]]--

local FirstPayDialog = qy.class("FirstPayDialog", qy.tank.view.BaseDialog, "view/operatingActivities/firstPay/FirstPayDialog")

function FirstPayDialog:ctor(delegate)
    FirstPayDialog.super.ctor(self)
    self.model = qy.tank.model.OperatingActivitiesModel
    local payData = self.model:getFirstPayData()
    local AwardType = qy.tank.view.type.AwardType

    self:InjectView("txt")
	self:InjectView("bg")
    self:InjectView("tip")
    self.tip:setLocalZOrder(10)
	self:OnClick("closeBtn", function(sender)
        self:dismiss()
    end,{["isScale"] = false})

    self:OnClick("getBtn", function(sender)
    	if payData.is_have_pay == 1 then
            local service = qy.tank.service.OperatingActivitiesService
            service:getCommonGiftAward(nil, "first_pay", true, function(reData)
                self:dismiss()
                qy.tank.command.AwardCommand:show(reData.award)
                qy.tank.model.ActivityIconsModel:closeActivityByName("first_pay")
                qy.Event.dispatch(qy.Event.ACTIVITY_REFRESH)
                if delegate and delegate.callBack2 then
                    delegate.callBack2()
                end
            end,false)
        else
            self:dismiss()
            qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.RECHARGE)
        end
    end)

    if payData.is_have_pay == 1 then
        self.txt:setSpriteFrame("Resources/common/txt/lingqu5.png")
    else
        self.txt:setSpriteFrame("Resources/common/txt/chongzhi4.png")
    end
    -- local function __createEquipSuitEffert(_target)
    --     local _effert = ccs.Armature:create("Flame")
    --     _target:addChild(_effert,999)
    --     _effert:setPosition(cc.p(2,0))
    --     _effert:getAnimation():playWithIndex(0)
    -- end

    self.awardList = qy.AwardList.new({
        ["award"] = payData.award,
        ["cellSize"] = cc.size(140,180),
        ["len"] = 4,
        ["itemSize"] = 1,
        ["hasName"] = false,
    })
    self.awardList:setPosition(cc.p(105,240))
    self.bg:addChild(self.awardList)
    for i = 1, #payData.award do
        -- if AwardType.EQUIP == payData.award[i].type then
        --     --装备
        --     __createEquipSuitEffert(self.awardList.list[i])
        -- else
        if AwardType.TANK == payData.award[i].type then
            --坦克
            self.awardList.list[i]:setPosition(self.awardList.list[i]:getPositionX() - 20 , self.awardList.list[i]:getPositionY())
        end
    end

end

return FirstPayDialog
