--[[
	跨服军团战
	Author: 
]]

local DefenceMainView = qy.class("DefenceMainView", qy.tank.view.BaseDialog, "service_legion_war/ui/DefenceMainView")

local userModel = qy.tank.model.UserInfoModel
local service = qy.tank.service.ServiceLegionWarService
local model = qy.tank.model.ServiceLegionWarModel

function DefenceMainView:ctor(delegate)
    DefenceMainView.super.ctor(self)
    for i = 1, 6 do
        self:InjectView("legionhui"..i)
        self["legionhui"..i]:setVisible(false)
        self:InjectView("legionname"..i)
        self:InjectView("legionBt"..i)
        self:InjectView("failtext"..i)
        self["failtext"..i]:setVisible(false)
    end
    for i=1,5 do
        self:InjectView("jiantou"..i)
        self["jiantou"..i]:setVisible(false)
    end
    self:InjectView("legionname")--军团名称
    self:InjectView("titleimg")
    self:InjectView("totalnum")--弹药储备
    self:InjectView("addBt")--添加按钮
    self:InjectView("flagnode")--防守的时候不显示
    self:InjectView("buzhenBt")
    self.titleimg:loadTexture("service_legion_war/res/kuafu_juntuan.png",1)
    if delegate.type == 1 then
        self.flagnode:setVisible(true)
    else
        self.flagnode:setVisible(false)
    end
    self:OnClick("closeBt",function()
        self:dismiss()
    end)
    self:OnClick("addBt",function()
        -- self:Buy()
    end)
    self:OnClick("buzhenBt",function()
        qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.EMBATTLE)
    end)
        -- legionBt
    self:OnClickForBuilding("legionBt1", function(sender)
            self.legionhui1:setVisible(false)
            if delegate.type == 2 then
                service:getDefenceByid(1,function( data )
                    local item = require("service_legion_war.src.DefenseView").new({
                        ["index"] = 1,
                        ["type"] = delegate.type,
                        ["totalnum"] = 8,
                        ["id"] = 1,
                        })
                    item:show()
                end)
            else
                --进攻
            end
        end
        ,{["beganFunc"] = function () self.legionhui1:setVisible(true) end,
        ["canceledFunc"] = function () self.legionhui1:setVisible(false) end,
        -- ["audioType"] = qy.SoundType.CLICK_BUILDING,
    })
    self:OnClickForBuilding("legionBt2", function(sender)
            self.legionhui2:setVisible(false)
            if delegate.type == 2 then
                service:getDefenceByid(2,function( data )
                    local item = require("service_legion_war.src.DefenseView").new({
                        ["index"] = 1,
                        ["type"] = delegate.type,
                        ["totalnum"] = 8,
                        ["id"] = 2,
                        })
                    item:show()
                end)
            else
                --进攻
            end
        end
        ,{["beganFunc"] = function () self.legionhui2:setVisible(true) end,
        ["canceledFunc"] = function () self.legionhui2:setVisible(false) end,
    })
    self:OnClickForBuilding("legionBt3", function(sender)
            self.legionhui3:setVisible(false)
               if delegate.type == 2 then
                service:getDefenceByid(3,function( data )
                    local item = require("service_legion_war.src.DefenseView").new({
                        ["index"] = 1,
                        ["type"] = delegate.type,
                        ["totalnum"] = 8,
                        ["id"] = 3,
                        })
                    item:show()
                end)
            else
                --进攻
            end
        end
        ,{["beganFunc"] = function () self.legionhui3:setVisible(true) end,
        ["canceledFunc"] = function () self.legionhui3:setVisible(false) end,
    })
    self:OnClickForBuilding("legionBt4", function(sender)
            self.legionhui4:setVisible(false)
            if delegate.type == 2 then
                service:getDefenceByid(4,function( data )
                    local item = require("service_legion_war.src.DefenseView").new({
                        ["index"] = 1,
                        ["type"] = delegate.type,
                        ["totalnum"] = 8,
                        ["id"] = 4,
                        })
                    item:show()
                end)
            else
                --进攻
            end
        end
        ,{["beganFunc"] = function () self.legionhui4:setVisible(true) end,
        ["canceledFunc"] = function () self.legionhui4:setVisible(false) end,
    })
    self:OnClickForBuilding("legionBt5", function(sender)
            self.legionhui5:setVisible(false)
            if delegate.type == 2 then
                service:getDefenceByid(5,function( data )
                    local item = require("service_legion_war.src.DefenseView").new({
                        ["index"] = 1,
                        ["type"] = delegate.type,
                        ["totalnum"] = 8,
                        ["id"] = 5,
                        })
                    item:show()
                end)
            else
                --进攻
            end
        end
        ,{["beganFunc"] = function () self.legionhui5:setVisible(true) end,
        ["canceledFunc"] = function () self.legionhui5:setVisible(false) end,
    })
    self:OnClickForBuilding("legionBt6", function(sender)
            self.legionhui6:setVisible(false)
            if delegate.type == 2 then
                service:getDefenceByid(6,function( data )
                    local item = require("service_legion_war.src.DefenseView").new({
                        ["index"] = 1,
                        ["type"] = delegate.type,
                        ["totalnum"] = 10,
                        ["id"] = 6,
                        })
                    item:show()
                end)
            else
                --进攻
            end
        end
        ,{["beganFunc"] = function () self.legionhui6:setVisible(true) end,
        ["canceledFunc"] = function () self.legionhui6:setVisible(false) end,
    })
    self.legionname:setString(delegate.legionname.."军团")

end
function DefenceMainView:onEnter()
  
end

function DefenceMainView:onExit()
    
end

return DefenceMainView
