--[[
	审核cell
	Author: H.X.Sun
]]

local AuditCell = qy.class("AuditCell", qy.tank.view.BaseView, "legion/ui/basic/AuditCell")

local NumberUtil = qy.tank.utils.NumberUtil
local UserInfoModel = qy.tank.model.UserInfoModel

function AuditCell:ctor(delegate)
    AuditCell.super.ctor(self)
    self:InjectView("icon_head")
    self:InjectView("u_name")
    self:InjectView("u_level")
    self:InjectView("time")

    self.delegate = delegate

    self.model = qy.tank.model.LegionModel

    local service = qy.tank.service.LegionService
    --拒绝申请
    self:OnClick("no_btn",function()
        service:applyRefuse(self.entity.kid,function()
            delegate.updateList()
        end)
    end)
    --通过申请
    self:OnClick("ok_btn",function()
        service:applyAgree(self.entity.kid,function()
            qy.hint:show(qy.TextUtil:substitute(50037, self.entity.name))
            delegate.updateList()
        end,function()
            delegate.updateList()
        end)
    end)
end

function AuditCell:render(entity)
    self.entity = entity
    self.icon_head:setTexture(entity:getHeadIcon())
    self.u_name:setString(entity.name)
    self.u_level:setString("Lv."..entity.level)
    if entity.t > 60 then
		  local sTime = NumberUtil.secondsToTimeStr((entity.t), 7)
		  self.time:setString(qy.TextUtil:substitute(50039, sTime))
    else
      self.time:setString(qy.TextUtil:substitute(50040))
    end
end

return AuditCell
