--[[
	Author: 
]]

local Tip = qy.class("Tip", qy.tank.view.BaseView, "service_faction_war/ui/Tip")

local model = qy.tank.model.ServerFactionModel
local service = qy.tank.service.ServerFactionService

function Tip:ctor(delegate)
    Tip.super.ctor(self)
    self.type = delegate.type
    self.texttype = delegate.texttype
    self.info = delegate.info
    local cityid = delegate.cityid
    local id = delegate.id
    self:InjectView("Bt2")
    self:InjectView("img1")
    self:InjectView("img2")
    self:InjectView("img3")
    self:InjectView("txt1")
    self:InjectView("txt2")
    self:OnClick("Bt2",function()
        if self.type == 3 then
            --撤离
            service:BackCity(function (date)
                if date.add_credit then
                    local msg = "获得功勋"..date.add_credit
                    if date.add_credit_is_max == 1 then
                        msg = msg..",今日获得功勋已达到上限"
                    end 
                    qy.hint:show(msg)
                end
                qy.alert:removeTip()
            end)
        else
            service:getCamp(cityid,id ,function (  )
                qy.alert:removeTip()
            end)
        end
    end)
    self.img1:setVisible(self.type == 2)
    self.img2:setVisible(self.type == 1)
    self.img3:setVisible(self.type == 3)
    self.Bt2:setVisible(self.type ~= 0)
    local DefensivePoint = model:getDefensivePoint(delegate.cityid)
    self.txt1:setString(DefensivePoint.."级防守点")
    self.txt2:setString(self.info)
end

return Tip
