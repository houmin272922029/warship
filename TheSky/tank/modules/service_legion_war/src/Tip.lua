--[[
	跨服军团战
	Author: 
]]

local Tip = qy.class("Tip", qy.tank.view.BaseView, "service_legion_war/ui/Tip")

local userModel = qy.tank.model.UserInfoModel
local service = qy.tank.service.ServiceLegionWarService
local model = qy.tank.model.ServiceLegionWarModel

function Tip:ctor(delegate)
    Tip.super.ctor(self)
    self.delegate = delegate
 	self:InjectView("Bt1")
    self:InjectView("Bt2")--集火
    self:OnClick("Bt1",function()
        service:GetAttackSitelist(delegate.index,function (  )
            model.chooselegion = delegate.index
            qy.alert:removeTip()
            local item = require("service_legion_war.src.DefenceMainView1").new({
                ["type"] = 1,
                ["legionname"] = model.attacklist[delegate.index].legion_name,
                ["site"] = delegate.index
                })
            item:show()
        end)
      
    end)
    self:OnClick("Bt2",function()
        if model.is_auth == 0 then
            qy.hint:show("您无权限,军团军团司令，副司令，参谋长可选择集合军团。")
            return
        end
        if model.fire_pos == 0 then
            service:firepos(delegate.index,function (  )
                qy.alert:removeTip()
                model.fire_pos = delegate.index
                delegate:callback()
            end)
        else
            if delegate.index == model.fire_pos then
                qy.hint:show("您已经集火该军团")
            else
                if model.attacklist[model.fire_pos].is_break == 0 then
                    qy.hint:show("只有击破集火军团才可再次集火")
                else
                    service:firepos(delegate.index,function (  )
                        qy.alert:removeTip()
                        model.fire_pos = delegate.index
                        delegate:callback()
                    end)
                end
            end
        end
        
    end)
    if model.is_auth == 0 then
        self.Bt2:setEnabled(false)
        self.Bt2:setBright(false)
    end
    

end

function Tip:onEnter()
  
end

function Tip:onExit()
    
end

return Tip
