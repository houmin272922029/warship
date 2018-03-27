--[[
	单笔充值-白虎来袭
	Author: H.X.Sun
]]

local SingleRechargeDialog = qy.class("SingleRechargeDialog", qy.tank.view.BaseDialog, "single_recharge/ui/SingleRechargeDialog")

local NumberUtil = qy.tank.utils.NumberUtil
local _ModuleType = qy.tank.view.type.ModuleType
local _userModel = qy.tank.model.UserInfoModel
local GO_RECHARGE = 0
local GET_AWARD = 1

function SingleRechargeDialog:ctor(delegate)
    SingleRechargeDialog.super.ctor(self)
    self:InjectView("get_btn")
    self:InjectView("container")

    self.model = qy.tank.model.OperatingActivitiesModel
    local service = qy.tank.service.OperatingActivitiesService
    local awardItem = qy.tank.view.common.AwardItem
    local _status = self.model:getSingleRechargeStatus()
    local tank_data = {["type"] = 11,["tank_id"] = 100}
    -- local tank_card = awardItem.createAwardView(tank_data,2,1,true,nil,{["cornerUrl"] = "Resources/common/corner/give_icon.png"})
    -- self.container:addChild(tank_card)
    -- tank_card:setPosition(10,-205)
    -- tank_card:setScale(0.5)

    cc.SpriteFrameCache:getInstance():addSpriteFrames("single_recharge/res/single_recharge.plist")
    if _status == GET_AWARD then
        self.get_btn:loadTexture("single_recharge/res/4.png",1)
    else
        self.get_btn:loadTexture("single_recharge/res/2.png",1)
    end

    self:OnClick("close_btn", function(sender)
        self:dismiss()
    end)

    self:OnClick("get_btn", function(sender)
        if _status == GET_AWARD then
            service:getCommonGiftAward(nil, "single_recharge", true, function(reData)
                self:dismiss()
                qy.tank.command.AwardCommand:show(reData.award)
                qy.tank.model.ActivityIconsModel:closeActivityByName("single_recharge")
                qy.Event.dispatch(qy.Event.ACTIVITY_REFRESH)
            end,false)
        else
            self:dismiss()
            qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.RECHARGE)
        end
    end)

    local itemData = awardItem.getItemData(tank_data)
    self:OnClick("watch_btn", function(sender)
        itemData.callback()
    end)


end

return SingleRechargeDialog
