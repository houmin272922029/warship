--[[
	跨服军团战
	Author: 
]]

local AttackMainView = qy.class("AttackMainView", qy.tank.view.BaseDialog, "service_legion_war/ui/AttackMainView")

local userModel = qy.tank.model.UserInfoModel
local service = qy.tank.service.ServiceLegionWarService
local model = qy.tank.model.ServiceLegionWarModel

function AttackMainView:ctor(delegate)
    AttackMainView.super.ctor(self)
    for i = 1, 4 do
        self:InjectView("legionhui"..i)
        self["legionhui"..i]:setVisible(false)
        self:InjectView("legionname"..i)
        self:InjectView("legionBt"..i)
        self:InjectView("failtext"..i)
        self:InjectView("logionimg"..i)
        self["failtext"..i]:setVisible(false)
    end
    self:InjectView("jiantou1")
    self.failtext1:setVisible(false)
     for i = 2, 4 do
        self:InjectView("jihuo"..i)
        self["jihuo"..i]:setVisible(false)
    end
    self:InjectView("closeBt")
    self:OnClick("closeBt",function()
        self:dismiss()
    end)
        -- legionBt
    self:OnClickForBuilding("legionBt1", function(sender)
        self.legionhui1:setVisible(false)
            local item = require("service_legion_war.src.DefenceMainView").new({
                ["type"] = 2,
                ["legionname"]= model.legionname
            })
            item:show()
        end
        ,{["beganFunc"] = function () self.legionhui1:setVisible(true) end,
        ["canceledFunc"] = function () self.legionhui1:setVisible(false) end,
        -- ["audioType"] = qy.SoundType.CLICK_BUILDING,
    })
    self:OnClickForBuilding("legionBt2", function(sender)
        if self.type2 == false then
            qy.hint:show("该军团已被击破")
            return
        end
        self.legionhui2:setVisible(false)
            local item = require("service_legion_war.src.Tip").new({
                ["index"] = 2,
                ["callback"] = function (  )
                    self.jihuo2:setVisible(true)
                end
                })
            item:setPosition(cc.p(180,220))
            qy.alert:showTip1(item)
        end
        ,{["beganFunc"] = function () self.legionhui2:setVisible(true) end,
        ["canceledFunc"] = function () self.legionhui2:setVisible(false) end,
    })
    self:OnClickForBuilding("legionBt3", function(sender)
        if self.type3 == false then
            qy.hint:show("该军团已被击破")
            return
        end
        self.legionhui3:setVisible(false)
            local item = require("service_legion_war.src.Tip").new({
                ["index"] = 3,
                ["callback"] = function (  )
                    self.jihuo3:setVisible(true)
                end
                })
            item:setPosition(cc.p(350,20))
            qy.alert:showTip1(item)
        end
        ,{["beganFunc"] = function () self.legionhui3:setVisible(true) end,
        ["canceledFunc"] = function () self.legionhui3:setVisible(false) end,
    })
    self:OnClickForBuilding("legionBt4", function(sender)
        if self.type4 == false then
            qy.hint:show("该军团已被击破")
            return
        end
        self.legionhui4:setVisible(false)
            local item = require("service_legion_war.src.Tip").new({
                ["index"] = 4,
                ["callback"] = function (  )
                    self.jihuo4:setVisible(true)
                end
                })
            item:setPosition(cc.p(0,-40))
            qy.alert:showTip1(item)
        end
        ,{["beganFunc"] = function () self.legionhui4:setVisible(true) end,
        ["canceledFunc"] = function () self.legionhui4:setVisible(false) end,
    })
    self.type2 = true
    self.type3 = true
    self.type4 = true
    self:update()
end
function AttackMainView:update(  )
    --先判断是否有第四个军团
    local list = model.attacklist
    if list[4].legion_id then
        self.logionimg4:setVisible(true)
        self.jiantou1:setVisible(true)
    else
        self.logionimg4:setVisible(false)
        self.jiantou1:setVisible(false)
    end
    for i=2,#list do
        if list[i].legion_id then
            self["legionname"..i]:setString("["..list[i].server.."]"..list[i].legion_name)
            if model.attacklegionlist[tostring(i)] == 0 then
                self["failtext"..i]:setVisible(false)
                self["type"..i] = true
                self["legionhui"..i]:setVisible(false)
            else
                self["failtext"..i]:setVisible(true)
                self["type"..i] = false
                self["legionhui"..i]:setVisible(true)
            end
        end
    end
    if model.fire_pos ~= 0 then
        if model.attacklegionlist[tostring(model.fire_pos)] == 1 then 
             self["jihuo"..model.fire_pos]:setVisible(false)
        else
             self["jihuo"..model.fire_pos]:setVisible(true)
        end
    end
end

function AttackMainView:onEnter()
    self.listener_1 = qy.Event.add(qy.Event.LEGION_WAR_ATT,function(event)
        self:update()
    end)
end

function AttackMainView:onExit()
    qy.Event.remove(self.listener_1)
end

return AttackMainView
