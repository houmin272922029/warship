--[[
	单笔充值-白虎来袭
	Author: H.X.Sun
]]

local SingleRechargeDialog = qy.class("SingleRechargeDialog", qy.tank.view.BaseDialog, "limit_reinforce/ui/SingleRechargeDialog")

local NumberUtil = qy.tank.utils.NumberUtil
local _ModuleType = qy.tank.view.type.ModuleType
local _userModel = qy.tank.model.UserInfoModel
local GO_RECHARGE = 0
local GET_AWARD = 1

function SingleRechargeDialog:ctor(delegate)
    SingleRechargeDialog.super.ctor(self)
    self:InjectView("get_btn")
    self:InjectView("container")
    self:InjectView("starttime")
    self:InjectView("endtime")

    self.model = qy.tank.model.Tank918Model
    local service = qy.tank.service.Tank918Service
    local awardItem = qy.tank.view.common.AwardItem
    local _status = self.model.iscanget
    local tank_data = {["type"] = 11,["tank_id"] = 55}

    cc.SpriteFrameCache:getInstance():addSpriteFrames("limit_reinforce/res/single_recharge.plist")
    if _status == GET_AWARD then
        self.get_btn:loadTexture("limit_reinforce/res/4.png",1)
    else
        self.get_btn:loadTexture("limit_reinforce/res/2.png",1)
    end

    self:OnClick("close_btn", function(sender)
        self:removeSelf()
    end)

    self:OnClick("get_btn", function(sender)
        if _status == GET_AWARD then
            service:getaward( function(reData)
                self:removeSelf()
                qy.Event.dispatch(qy.Event.TANK918)
            end,false)
        else
            self:removeSelf()
            qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.RECHARGE)
        end
    end)

    local itemData = awardItem.getItemData(tank_data)
    self:OnClick("watch_btn", function(sender)
        itemData.callback()
    end,{["isScale"] = false})
     self.starttime:setString("开始时间:"..os.date("%Y.%m.%d %H:%M:%S", self.model.starttime))
    self.endtime:setString("结束时间:"..os.date("%Y.%m.%d %H:%M:%S", self.model.endtime))

end

return SingleRechargeDialog
