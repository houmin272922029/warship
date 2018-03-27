local StrongholdDialog = qy.class("StrongholdDialog", qy.tank.view.BaseDialog, "service_faction_war/ui/StrongholdDialog")

local model = qy.tank.model.ServerFactionModel
local service = qy.tank.service.ServerFactionService


local inPosition = {
	    ["1"] = cc.p(5, 380),["2"] = cc.p(155, 380),["3"] = cc.p(305, 380),["4"] = cc.p(455, 380),["5"] = cc.p(605, 380),["6"] = cc.p(755, 380),
	    ["7"] = cc.p(5, 280),["8"] = cc.p(155, 280),["9"] = cc.p(605, 280),["10"] = cc.p(755, 280),["11"] = cc.p(5, 180),["12"] = cc.p(155, 180),
	    ["13"] = cc.p(605, 180),["14"] = cc.p(755, 180),["15"] = cc.p(5, 80),["16"] = cc.p(155, 80),["17"] = cc.p(305, 80),["18"] = cc.p(455, 80),
	    ["19"] = cc.p(605, 80),["20"] = cc.p(755, 80)
	}
function StrongholdDialog:ctor(delegate)
	StrongholdDialog.super.ctor(self)
    self.cityid = delegate

    self:InjectView("closeBt")
    self:InjectView("listbg")
    self:InjectView("buBT")
    self:InjectView("attBT")
    self:InjectView("Text_1")
    self:InjectView("jindu")
    self:InjectView("xiufuimg")
    self:InjectView("jingongimg")
    self:InjectView("icon")
    self:InjectView("zhanBT")
    self.zhanBT:setVisible(false)
    
   	self:OnClick("closeBt",function()
        service:exitCity(model.slectcity_id,function (  )
            qy.Event.remove(self.listener_2)
            -- qy.alert:removeTip()
            qy.Event.dispatch(qy.Event.REFRESHMAINVIEW)
            self:dismiss()
        end)
        
    end) 
    self:OnClick("buBT", function()
        qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.EMBATTLE)
    end)
     self:OnClick("attBT", function()
        if self.type == 1 then
            --调修复接口
            service:repairCity(self.cityid,function (  )
                -- body
            end)
        else
            service:fightCity(self.cityid,function (  )
                -- body
            end)
        end
    end)
    self:addhold() 
    self:update()
    self.listener_2 = qy.Event.add(qy.Event.REFRESHCITY,function(event)
        self:update()
    end)
end
function StrongholdDialog:update(  )
    for i=1,20 do
        self["item"..i]:update()
    end
    if model.campbase.camp == model.my_camp then
        self.type = 1 --修复
    else
        self.type = 2
    end
    self.xiufuimg:setVisible(model.campbase.camp == model.my_camp)
    self.jingongimg:setVisible(model.campbase.camp ~= model.my_camp)
    self.Text_1:setString(string.format("%0.2f%%", model.campbase.current_blood / model.campbase.total_blood * 100))
    self.jindu:setScaleX(model.campbase.current_blood / model.campbase.total_blood)
    self.icon:setVisible(model.campbase.camp ~= 0)
    local camp = model.campbase.camp
    if camp == 1 then
        self.icon:setSpriteFrame("service_faction_war/res/hong.png")
    elseif camp == 2 then
        self.icon:setSpriteFrame("service_faction_war/res/lv.png")
    else
        self.icon:setSpriteFrame("service_faction_war/res/lan.png")
    end
end
function StrongholdDialog:addhold(  )
	for i=1,20 do
		self["item"..i] = require("service_faction_war.src.Stronghold1").new({
            ["id"] = i,
            ["cityid"] = self.cityid,
            ["callback"] = function ( )
              
            end
            })
		self["item"..i]:setPosition(cc.p(inPosition[tostring(i)]))
		self.listbg:addChild(self["item"..i])
	end
end

return StrongholdDialog
