local ChooseHard = qy.class("ChooseHard", qy.tank.view.BaseDialog, "view/common/ChooseHard")


local model = qy.tank.model.AttackBerlinModel
local service = qy.tank.service.AttackBerlinService
function ChooseHard:ctor(delegate)
   	ChooseHard.super.ctor(self)
   	self:InjectView("awardbg")
    self:InjectView("times")
    self:InjectView("AttackBt")
    self:InjectView("zhanbaoBt")
    self:InjectView("closeBt")

    self:OnClick("closeBt", function()
        self:removeSelf()
    end,{["isScale"] = false})
    for i=1,3 do
        self:InjectView("BT"..i)
        self:InjectView("img"..i)
    end
    for i=1,3 do
        self:OnClick("BT"..i,function()
            self.flag1 = i
            self:update( i )
        end,{["isScale"] = false})
    end
    self:OnClick("okBt", function()
        self:removeSelf()
        service:open(self.flag1,function (  )
             qy.tank.command.LegionCommand:viewRedirectByModuleType("attack_berlin")
        end)
    end,{["isScale"] = false})

    self.flag1 = 1
    self:update()
   
end
function ChooseHard:update(_idx)
    for i=1,3 do
        self["img"..i]:setVisible(self.flag1 == i)
    end
end

return ChooseHard
