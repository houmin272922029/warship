local PreView = qy.class("PreView", qy.tank.view.BaseView, "view/advance/PreView")

local garageModel = qy.tank.model.GarageModel
local model = qy.tank.model.AdvanceModel
-- require("advance.src.AdvanceModel")
-- model:init()

function PreView:ctor(delegate)
   	PreView.super.ctor(self)

    self:addChild(qy.tank.view.style.ViewStyle1.new({
        ["onExit"] = function()
            if delegate.isTips then
                delegate:finish()
            else
                delegate.viewStack:pop()
            end
        end,
        ["titleUrl"] = "Resources/common/title/shengxingyulan2.png",
        ["showHome"] = true,

    }))

   	self:InjectView("BG")
   	self:InjectView("Sprite1")
   	self:InjectView("Buttom")

    self:InjectView("ScrollView_1")

    self.Buttom:setLocalZOrder(10)

    local winsize = display.size

    -- local x = self.Sprite1:getPositionX()
    -- local fix_x = (display.size.width - 1080) / 2

    local item1 = qy.tank.view.advance.TankInfoList.new(cc.size(300,635))
    local data1 = qy.tank.entity.TankEntity.new(delegate.entity.tank_id, false) 
    item1:render(data1, false)
    item1:setPosition(winsize.width / 2 - 240 - 150, 0)

    local item2 = qy.tank.view.advance.TankInfoList.new(cc.size(300,635))
    local data = model:atSpecailByLevel(delegate.entity, 6)
    local data1 = {}
    if data.type == 9 then
        data1 = qy.tank.entity.TankEntity.new(data.param, false) 
    else
        data1 = qy.tank.entity.TankEntity.new(14, false) 
    end
    item2:render(data1, false)
    item2:setPosition(winsize.width / 2 + 240 - 150, 0)


    if item1.h > item2.h then
        item2:setPositionY(item1.h - item2.h)
    else
        item1:setPositionY(item2.h - item1.h)
    end

    local h = item1.h > item2.h and item1.h or item2.h
    self.ScrollView_1:setInnerContainerSize(cc.size(display.size.width, h + 400))
    -- self.ScrollView_1:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.ScrollView_1:addChild(item1)
    self.ScrollView_1:addChild(item2)
end

return PreView
