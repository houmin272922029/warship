--[[
	跨服军团战
	Author: 
]]

local AttackCell = qy.class("AttackCell", qy.tank.view.BaseView, "service_legion_war/ui/AttackCell")

local userModel = qy.tank.model.UserInfoModel
local service = qy.tank.service.ServiceLegionWarService
local model = qy.tank.model.ServiceLegionWarModel
local examiservice = qy.tank.service.ExamineService

function AttackCell:ctor(delegate)
    AttackCell.super.ctor(self)
    for i = 1, 2 do
        self:InjectView("icon"..i)
        self:InjectView("name"..i)
        self:InjectView("power"..i)
        self:InjectView("level"..i)
        self:InjectView("Bt"..i)
        self:InjectView("bg"..i)
        self:InjectView("totalnum"..i)
        self:InjectView("failimg"..i)
        self:InjectView("Btimg"..i)
    end
    self.changeColorUi1 = {self.bg1,self.icon1}
    self.changeColorUi2 = {self.bg2,self.icon2}
    self:OnClick("Bt1",function()
        if model.ammo_store <= 0 then
            qy.hint:show("弹药储备不足,无法进攻")
            return
        end
        local aa = (self.index-1)*2 +1
        service:Attack(delegate.site,delegate.id,aa,function (  )
            delegate:callback()
            qy.Event.dispatch(qy.Event.LEGION_WAR)
        end)
    end)
    self:OnClick("Bt2",function()
        if model.ammo_store <= 0 then
            qy.hint:show("弹药储备不足,无法进攻")
            return
        end
       local aa = (self.index-1)*2 +2
        service:Attack(delegate.site,delegate.id,aa,function (  )
            delegate:callback()
            qy.Event.dispatch(qy.Event.LEGION_WAR)
        end)
    end)
    -- self:OnClick("icon1",function()
    --     local aa = (self.index-1)*2 +1
    --     local list = model.site_member[aa]
    --     if list.kid == 10000 then
    --         qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.EXAMINE_AI_L,list.kid)
    --     else
    --         qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.EXAMINE,list.kid)
    --     end
    -- end,{["isScale"] = false})
    -- self:OnClick("icon2",function()
    --     local aa = (self.index-1)*2 +2
    --     local list = model.site_member[aa]
    --     if list.kid == 10000 then
    --         qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.EXAMINE_AI_L,list.kid)
    --     else
    --         qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.EXAMINE,list.kid)
    --     end
    -- end,{["isScale"] = false})
end

function AttackCell:render(_idx)
    self.index = _idx
    local isChangeColor = false
    local x = (_idx-1)*2
    for i=1,2 do
        local list = model.site_member[x+i]
        print("sssss-----------",json.encode(list))
        if list ~= nil then
            self["bg"..i]:setVisible(true)
            self["name"..i]:setString(list.nickname)
            self["power"..i]:setString("战斗力:"..list.fight_power)
            self["level"..i]:setString("等级:"..list.level)
            local png = "Resources/user/icon_"..list.headicon..".png"
            self["icon"..i]:loadTexture(png)
            self["icon"..i]:setScale(1.2)
            self["totalnum"..i]:setString("弹药储备:"..list.ammo_store)
            if list.ammo_store <= 0 then
                self["failimg"..i]:setVisible(true)
                self["Bt"..i]:setVisible(false)
                isChangeColor = true
            else
                self["failimg"..i]:setVisible(false)
                self["Bt"..i]:setVisible(true)
                isChangeColor = false
            end
            if i == 1 then
                for k = 1, #self.changeColorUi1 do
                    qy.tank.utils.NodeUtil:darkNode(self.changeColorUi1[k],isChangeColor)
                end
            else
                for k = 1, #self.changeColorUi2 do
                    qy.tank.utils.NodeUtil:darkNode(self.changeColorUi2[k],isChangeColor)
                end
            end
        else
            --数据正常不会走到这里来的
            self["bg"..i]:setVisible(false)
        end
    end
end

function AttackCell:onEnter()
  
end

function AttackCell:onExit()
    
end

return AttackCell
