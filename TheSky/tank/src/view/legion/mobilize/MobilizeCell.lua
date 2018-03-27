--[[
	动员cell
	Author: H.X.Sun
]]

local MobilizeCell = qy.class("MobilizeCell", qy.tank.view.BaseView, "legion/ui/mobilize/MobilizeCell")

local ColorMapUtil = qy.tank.utils.ColorMapUtil
local ModuleType = qy.tank.view.type.ModuleType
local UserInfoModel = qy.tank.model.UserInfoModel
local service = qy.tank.service.LeMobilizeService

function MobilizeCell:ctor(delegate)
    MobilizeCell.super.ctor(self)
    self.delegate = delegate
    self.model = qy.tank.model.LeMobilizeModel
    self:InjectView("c_title")
    self:InjectView("c_initiate")
    self:InjectView("c_join")
    self:InjectView("cost_txt")
    for i = 1, 3 do
        self:InjectView("c_target_"..i)
    end

    self:OnClick("join_btn", function(sender)
        if UserInfoModel.userInfoEntity.diamond >= self.data.create_cost_diamond then
            local _status = self.model:getCreateStatus(self.data.id)
            if _status == self.model.CAN_CREATE_JOIN then
                self:joinLogic()
            elseif _status == self.model.ONLY_JOIN then
                qy.hint:show(qy.TextUtil:substitute(52009))
                -- qy.tank.view.legion.mobilize.TipsDialog.new({
                --     ["callBack"] = function()
                --         self:joinLogic()
                --     end,
                --     ["id"] = self.data.id,
                -- }):show(true)
            else
                qy.hint:show(qy.TextUtil:substitute(52010))
            end
        else
            qy.tank.command.MainCommand:viewRedirectByModuleType(ModuleType.DIAMOND_NOT_ENOUGH)
        end
    end)
end

function MobilizeCell:joinLogic()
    service:create(self.data.id,function()
        self.delegate.callBack()
    end)
end

function MobilizeCell:update(_idx)
    local data = self.model:getInitiateDataByIdx(_idx)
    if data == nil then
        return
    end

    self.data = data
    self.c_title:setString(data.title)
    self.c_title:setTextColor(ColorMapUtil.qualityMapColor(tostring(data.quality)))

    self.c_target_1:setString(data.describe)
    self.c_initiate:setString(qy.TextUtil:substitute(52011, data.create_silver, data.create_legion_exp))
    self.c_join:setString(qy.TextUtil:substitute(52011, data.join_silver, data.join_legion_exp))
    self.cost_txt:setString(qy.TextUtil:substitute(52013, data.create_cost_diamond))


    -- local p1x = self.c_target_1:getPositionX()
    -- local p1y = self.c_target_1:getPositionY()
    -- local w1 = self.c_target_1:getContentSize().width
    -- local p2x = p1x + w1
    -- self.c_target_2:setPosition(p2x, p1y)
    -- local w2 = self.c_target_2:getContentSize().width
    -- self.c_target_3:setPosition(p2x + w2, p1y)
end

return MobilizeCell
