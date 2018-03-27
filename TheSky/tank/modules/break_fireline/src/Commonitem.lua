

local Commonitem = qy.class("Commonitem", qy.tank.view.BaseView, "break_fireline/ui/Commonitem")


function Commonitem:ctor(delegate)
    Commonitem.super.ctor(self)
    self.model = qy.tank.model.BreakFireModel
    local service = qy.tank.service.OperatingActivitiesService
    self:InjectView("bg")
    self.types = delegate.types
    -- local  item = qy.tank.view.common.AwardItem.createAwardView(delegate.data ,1)
    local icon = qy.tank.utils.AwardUtils.getAwardIconByType(delegate.data.type)
    icon:setScale(0.8)
    -- item.name:setVisible(false)
    icon:setPosition(cc.p(45,45))
    self.bg:addChild(icon)
     
    self:OnClick("bt1",function()
        local itemData = qy.tank.view.common.AwardItem.getItemData(delegate.data,true, 1,{})
        qy.alert:showTip(qy.tank.utils.TipUtil.createTipContent(itemData))
    end,{["isScale"] = false})
end



return Commonitem
