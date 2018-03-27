--[[
	跨服军团战
	Author: 
]]

local DefenceMainView1 = qy.class("DefenceMainView1", qy.tank.view.BaseDialog, "service_legion_war/ui/DefenceMainView")

local userModel = qy.tank.model.UserInfoModel
local service = qy.tank.service.ServiceLegionWarService
local model = qy.tank.model.ServiceLegionWarModel

function DefenceMainView1:ctor(delegate)
    DefenceMainView1.super.ctor(self)
    for i = 1, 6 do
        self:InjectView("legionhui"..i)
        self["legionhui"..i]:setVisible(false)
        self:InjectView("legionname"..i)
        self:InjectView("legionBt"..i)
        self:InjectView("failtext"..i)
        self["failtext"..i]:setVisible(false)
    end
    self:InjectView("shauxinBt")
    self:InjectView("closeBt")
    self:InjectView("legionname")--军团名称
    self:InjectView("totalnum")--弹药储备
    self:InjectView("addBt")--添加按钮
    self:InjectView("flagnode")--防守的时候不显示
    self:InjectView("buzhenBt")
    self:InjectView("titleimg")
    self.titleimg:loadTexture("service_legion_war/res/kuafu_quanjuntuji.png",1)
    if delegate.type == 1 then
        self.flagnode:setVisible(true)
    else
        self.flagnode:setVisible(false)
    end
    self:OnClick("closeBt",function()
        self:dismiss()
    end)
    self:OnClick("addBt",function()
        if model.ammo_store >= 20 then
            qy.hint:show("弹药储备最大为20 ，无需补充")
            return
        end
        if model.buytime >= 3 then
             qy.hint:show("每轮军团战最多购买三次弹药储备")
            return
        end
        self:Buy()
    end)
    self:OnClick("buzhenBt",function()
        qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.EMBATTLE)
    end)
    self:OnClick("shauxinBt",function()
        service:GetAttackSitelist(model.chooselegion,function (  )
            self:dismiss()
            local item = require("service_legion_war.src.DefenceMainView1").new({
                ["type"] = 1,
                ["legionname"] = model.attacklist[model.chooselegion].legion_name,
                ["site"] = model.chooselegion
                })
            item:show()
        end)
    end)
        -- legionBt
    self:OnClickForBuilding("legionBt1", function(sender)
            if self.touchty1 == false then
                qy.hint:show("该据点已被击破")
                return
            end
            self.legionhui1:setVisible(false)
            service:GetAttackBypos(delegate.site,1,function( data )
                local item = require("service_legion_war.src.AttackView").new({
                    ["index"] = 1,
                    ["type"] = delegate.type,
                    ["totalnum1"] = 8,
                    ["id"] = 1,
                    ["legionname"] = delegate.legionname,
                    ["site"]= delegate.site,
                    ["callback"] = function (  )
                        self:update()
                    end
                    })
                item:show()
            end)
          
        end
        ,{["beganFunc"] = function () self.legionhui1:setVisible(true) end,
        ["canceledFunc"] = function () self.legionhui1:setVisible(false) end,
        -- ["audioType"] = qy.SoundType.CLICK_BUILDING,
    })
    self:OnClickForBuilding("legionBt2", function(sender)
            if self.touchty2 == false then
                qy.hint:show("该据点已被击破")
                return
            end
            if self.touchty1 == true then
                qy.hint:show("请先攻破前面的据点")
                self.legionhui2:setVisible(false)
                return
            end
            self.legionhui2:setVisible(false)
            service:GetAttackBypos(delegate.site,2,function( data )
                local item = require("service_legion_war.src.AttackView").new({
                    ["index"] = 1,
                    ["type"] = delegate.type,
                    ["totalnum1"] = 8,
                    ["id"] = 2,
                    ["legionname"] = delegate.legionname,
                    ["site"]= delegate.site,
                     ["callback"] = function (  )
                        self:update()
                    end
                    })
                item:show()
            end)
        end
        ,{["beganFunc"] = function () self.legionhui2:setVisible(true) end,
        ["canceledFunc"] = function () self.legionhui2:setVisible(false) end,
    })
    self:OnClickForBuilding("legionBt3", function(sender)
            if self.touchty3 == false then
                qy.hint:show("该据点已被击破")
                return
            end
            self.legionhui3:setVisible(false)
            service:GetAttackBypos(delegate.site,3,function( data )
                local item = require("service_legion_war.src.AttackView").new({
                    ["index"] = 1,
                    ["type"] = delegate.type,
                    ["totalnum1"] = 8,
                    ["id"] = 3,
                    ["legionname"] = delegate.legionname,
                    ["site"]= delegate.site,
                     ["callback"] = function (  )
                        self:update()
                    end
                    })
                item:show()
            end)
        end
        ,{["beganFunc"] = function () self.legionhui3:setVisible(true) end,
        ["canceledFunc"] = function () self.legionhui3:setVisible(false) end,
    })
    self:OnClickForBuilding("legionBt4", function(sender)
            if self.touchty4 == false then
                qy.hint:show("该据点已被击破")
                return
            end
            if self.touchty3 == true then
                 qy.hint:show("请先攻破前面的据点")
                 self.legionhui4:setVisible(false)
                return
            end
            self.legionhui4:setVisible(false)
                service:GetAttackBypos(delegate.site,4,function( data )
                    local item = require("service_legion_war.src.AttackView").new({
                        ["index"] = 1,
                        ["type"] = delegate.type,
                        ["totalnum1"] = 8,
                        ["id"] = 4,
                        ["legionname"] = delegate.legionname,
                        ["site"]= delegate.site,
                         ["callback"] = function (  )
                        self:update()
                        end
                        })
                    item:show()
                end)
        end
        ,{["beganFunc"] = function () self.legionhui4:setVisible(true) end,
        ["canceledFunc"] = function () self.legionhui4:setVisible(false) end,
    })
    self:OnClickForBuilding("legionBt5", function(sender)
            if self.touchty5 == false then
                qy.hint:show("该据点已被击破")
                return
            end
            if self.touchty2 == true and self.touchty4 == true then
                 qy.hint:show("请先攻破前面的据点")
                 self.legionhui5:setVisible(false)
                return
            end
            self.legionhui5:setVisible(false)
            service:GetAttackBypos(delegate.site,5,function( data )
                local item = require("service_legion_war.src.AttackView").new({
                    ["index"] = 1,
                    ["type"] = delegate.type,
                    ["totalnum1"] = 8,
                    ["id"] = 5,
                    ["legionname"] = delegate.legionname,
                    ["site"]= delegate.site,
                    ["callback"] = function (  )
                        self:update()
                    end
                    })
                item:show()
            end)
        end
        ,{["beganFunc"] = function () self.legionhui5:setVisible(true) end,
        ["canceledFunc"] = function () self.legionhui5:setVisible(false) end,
    })
    self:OnClickForBuilding("legionBt6", function(sender)
            if self.touchty6 == false then
                qy.hint:show("该据点已被击破")
                return
            end
             if self.touchty5 == true then
                 qy.hint:show("请先攻破前面的据点")
                 self.legionhui6:setVisible(false)
                return
            end
            self.legionhui6:setVisible(false)
            service:GetAttackBypos(delegate.site,6,function( data )
                local item = require("service_legion_war.src.AttackView").new({
                    ["index"] = 1,
                    ["type"] = delegate.type,
                    ["totalnum1"] = 10,
                    ["id"] = 6,
                    ["legionname"] = delegate.legionname,
                    ["site"]= delegate.site,
                    ["callback"] = function (  )
                        self:update()
                    end
                    })
                item:show()
            end)
        end
        ,{["beganFunc"] = function () self.legionhui6:setVisible(true) end,
        ["canceledFunc"] = function () self.legionhui6:setVisible(false) end,
    })
    self.legionname:setString(delegate.legionname.."军团")
     for i=1,6 do
         self["touchty"..i] = true
     end
    self:update()
    self:updatedan()

end
function DefenceMainView1:update(  )
    local list = model.passlist
    for i=1,6 do
        local tempnum = 0
        for k=1,#list do
            if list[k] == i then
                tempnum = 1
                break
            end
        end
        if tempnum == 1 then
            self["touchty"..i] = false
            self["legionhui"..i]:setVisible(true)
            self["failtext"..i]:setVisible(true)
        else
            self["touchty"..i] = true
            self["legionhui"..i]:setVisible(false)
            self["failtext"..i]:setVisible(false)
        end
    end
    local tempnum1 = 0
    for k=1,#list do
        if list[k] == 6 then
            tempnum1 = 1
            break
        end
    end
    --判断是否全被击破
    if tempnum1 == 1 then
        model.attacklegionlist[tostring(model.chooselegion)] = 1
        qy.Event.dispatch(qy.Event.LEGION_WAR_ATT)--刷新
    end

end
--刷新弹药逻辑
function DefenceMainView1:updatedan(  )
    local x = model.ammo_store < 0 and 0 or model.ammo_store
    self.totalnum:setString(x.."/".."20")
end
function DefenceMainView1:Buy(  )
    local function callBack(flag)
        if flag == qy.TextUtil:substitute(4012) then
            service:Buy(function (  )
                self:updatedan()
            end)
        end
    end
    local image = ccui.ImageView:create()
    image:setContentSize(cc.size(500,120))
    image:setScale9Enabled(true)
    image:loadTexture("Resources/common/bg/c_12.png")

    local image1 = ccui.ImageView:create()
    image1:loadTexture("Resources/common/icon/coin/1a.png")
    image1:setPosition(cc.p(138,60))
    image:addChild(image1)

    local richTxt = ccui.RichText:create()
    richTxt:ignoreContentAdaptWithSize(false)
    richTxt:setContentSize(500, 150)
    richTxt:setAnchorPoint(0,0.5)
    local tempnum = 0
    local huafei = 100
    if   model.buytime == 1 then
        huafei = 300
    elseif model.buytime == 2 then
        huafei = 500
    end
    local stringTxt1 = ccui.RichElementText:create(1, cc.c3b(255,255,255), 255, "是否要花费      ", qy.res.FONT_NAME_2, 24)
    richTxt:pushBackElement(stringTxt1)
    local stringTxt2 = ccui.RichElementText:create(1, cc.c3b(0,120, 255), 255, huafei, qy.res.FONT_NAME_2, 24)
    richTxt:pushBackElement(stringTxt2)
    local stringTxt3 = ccui.RichElementText:create(1, cc.c3b(255,255,255), 255, "购买", qy.res.FONT_NAME_2, 24)
    richTxt:pushBackElement(stringTxt3)
    local stringTxt3 = ccui.RichElementText:create(1, cc.c3b(255,165,0), 255, "10", qy.res.FONT_NAME_2, 24)
    richTxt:pushBackElement(stringTxt3)
    local stringTxt3 = ccui.RichElementText:create(1, cc.c3b(255,255,255), 255, "点弹药储备？", qy.res.FONT_NAME_2, 24)
    richTxt:pushBackElement(stringTxt3)
      local stringTxt3 = ccui.RichElementText:create(1, cc.c3b(255,15,0), 255, "(弹药储备上限为20点,请谨慎购买)", qy.res.FONT_NAME_2, 24)
    richTxt:pushBackElement(stringTxt3)
    image:addChild(richTxt)

    qy.alert1:showWithNode(qy.TextUtil:substitute(9004),  image, cc.size(560,250), {{qy.TextUtil:substitute(4011) , 4},{qy.TextUtil:substitute(4012) , 5} }, callBack, {})
    image:setPosition(image:getPositionX() + 5, image:getPositionY() - 30)
end

function DefenceMainView1:onEnter()
    self.listener_2 = qy.Event.add(qy.Event.LEGION_WAR,function(event)
        self:updatedan()
    end)
end

function DefenceMainView1:onExit()
    qy.Event.remove(self.listener_2)
end

return DefenceMainView1
