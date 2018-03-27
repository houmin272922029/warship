--[[
	跨服军团战
	Author: 
]]

local DefenceCell = qy.class("DefenceCell", qy.tank.view.BaseView, "service_legion_war/ui/DefenceCell")

local userModel = qy.tank.model.UserInfoModel
local service = qy.tank.service.ServiceLegionWarService
local model = qy.tank.model.ServiceLegionWarModel
local examiservice =qy.tank.service.ExamineService

function DefenceCell:ctor(delegate)
    DefenceCell.super.ctor(self)
    for i = 1, 2 do
        self:InjectView("icon"..i)
        self:InjectView("name"..i)
        self:InjectView("power"..i)
        self:InjectView("Bt"..i)
        self:InjectView("Btimg"..i)
        self:InjectView("wu"..i)
        self:InjectView("level"..i)
    end
    self:OnClick("Bt1",function()
        if model.is_auth == 0 then
            qy.hint:show("军团司令，副司令，参谋长有权限调整布放。")
            return
        end
        local aa = (self.index-1)*2 +1
        local lists = model:getDefenceByPos(aa)
        -- print("+++++++",json.encode(lists))
        local kid = 0
        if #lists ~= 0 then
            kid = lists[1].kid
        end
        service:getDefencelist(delegate.site,aa,function ( data )
            local list = data.member_list
            -- print("............",json.encode(list))
            for i=1,#list do
                if tonumber(list[i].kid) == tonumber(kid) then
                    table.remove(list, i)
                    break
                end
            end
            local item = require("service_legion_war.src.ChangeView").new({
                ["datas"] = list,
                ["site"] = delegate.site,
                ["pos"] = aa,
                ["callback"] = function (  )
                    delegate:callback()
                end 
                })
            item:show()
        end)
    end)
    self:OnClick("Bt2",function()
        if model.is_auth == 0 then
            qy.hint:show("军团司令，副司令，参谋长有权限调整布放。")
            return
        end
        local aa = (self.index-1)*2 + 2
        local lists = model:getDefenceByPos(aa)
        local kid = 0
        if #lists ~= 0 then
            kid = lists[1].kid
        end
        service:getDefencelist(delegate.site,aa,function ( data )
            local list = data.member_list
            for i=1,#list do
                if list[i].kid == kid then
                    table.remove(list, i)
                    break
                end
            end
            local item = require("service_legion_war.src.ChangeView").new({
                ["datas"] = list,
                ["site"] = delegate.site,
                ["pos"] = aa,
                ["callback"] = function (  )
                    delegate:callback()
                end 
                })
            item:show()
        end)
    end)
    -- self:OnClick("icon1",function()
    --     local aa = (self.index-1)*2 +1
    --     local list = model:getDefenceByPos(aa)
    --     if list[1].kid == 10000 then
    --         qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.EXAMINE_AI_L,list[1].kid)
    --     else
    --         qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.EXAMINE,list[1].kid)
    --     end
    -- end,{["isScale"] = false})
    -- self:OnClick("icon2",function()
    --     local aa = (self.index-1)*2 +2
    --     local list = model:getDefenceByPos(aa)
    --     if list[1].kid == 10000 then
    --         qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.EXAMINE_AI_L,list[1].kid)
    --     else
    --         qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.EXAMINE,list[1].kid)
    --     end
    -- end,{["isScale"] = false})
    
    self.data = model.garrison_list

end

function DefenceCell:render(_idx)
    self.index = _idx
    local x = (_idx-1)*2
    for i=1,2 do
        local list = model:getDefenceByPos(x+i)
        -- print("sssss-----------",json.encode(list))
        if #list ~= 0 then
            self["icon"..i]:setVisible(true)
            self["name"..i]:setVisible(true)
            self["power"..i]:setVisible(true)
            self["Btimg"..i]:loadTexture("service_legion_war/res/huanfang.png",1)
            self["name"..i]:setString(list[1].nickname)
            self["power"..i]:setString("战斗力:"..list[1].fight_power)
            local png = "Resources/user/icon_"..list[1].headicon..".png"
            self["level"..i]:setString("等级:"..list[1].level)
            self["level"..i]:setVisible(true)
            self["icon"..i]:loadTexture(png)
            self["wu"..i]:setVisible(false)
            self["icon"..i]:setScale(1.2)
        else
            self["icon"..i]:setVisible(false)
            self["name"..i]:setVisible(false)
            self["power"..i]:setVisible(false)
            self["level"..i]:setVisible(false)
            self["wu"..i]:setVisible(true)
            self["Btimg"..i]:loadTexture("service_legion_war/res/zhushou.png",1)
        end
        if model.is_auth == 1 then
            self["Bt"..i]:setVisible(true)
        else
            self["Bt"..i]:setVisible(false)
        end
        if model.status == 4 then
            self["Bt"..i]:setVisible(false)
        end
    end
end

function DefenceCell:onEnter()
  
end

function DefenceCell:onExit()
    
end

return DefenceCell
