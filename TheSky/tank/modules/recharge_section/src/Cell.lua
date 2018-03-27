local Cell = qy.class("Cell", qy.tank.view.BaseView, "recharge_section.ui.Cell")

local model = qy.tank.model.OperatingActivitiesModel
local service = qy.tank.service.OperatingActivitiesService
function Cell:ctor(delegate)
   	Cell.super.ctor(self)
    self:InjectView("awardbg")
    self:InjectView("getBt")
    self:InjectView("des")
    self:InjectView("yilingqu")
    self:InjectView("goimg")
    self:InjectView("getimg")

   	self:OnClick("getBt", function()
        if self.status == 0 then
            delegate:removeSelf()
            qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.RECHARGE)
        elseif self.status == 1 then
            service:getsectionaward(self.cash, function(data)
                model.rechargesetionList[self.index].status = -1
                delegate:update()
            end)
        end
    end,{["isScale"] = false})

end

function Cell:setData(data, idx)
    self.index = idx
    self.awardbg:removeAllChildren(true)
    self.des:setString("累积充值"..data.cash.."元")
    for i=1,#data.award do
        local item = qy.tank.view.common.AwardItem.createAwardView(data.award[i], 1)
        item:setPosition( 110 *i -40,50)
        item:showTitle(false)
        item:setScale(0.9)
        item.fatherSprite:setSwallowTouches(false)
        self.awardbg:addChild(item,99,99)
    end
    self.cash = data.cash
    self.status = data.status
    self.goimg:setVisible(self.status == 0)
    self.getimg:setVisible(self.status == 1)
    self.yilingqu:setVisible(self.status == -1)
    self.getBt:setVisible(self.status ~= -1)
end


return Cell
