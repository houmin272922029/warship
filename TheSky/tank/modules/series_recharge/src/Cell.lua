local Cell = qy.class("Cell", qy.tank.view.BaseView, "series_recharge.ui.Cell")

function Cell:ctor(delegate)
   	Cell.super.ctor(self)

    self:InjectView("Bg")
    self:InjectView("Text")

end

function Cell:render(_data, idx)	
    local data1 = {}
    local data2 = {}

    table.insert(data1, _data[1])
    table.insert(data2, _data[2])
    table.insert(data2, _data[3])

    if self.award1 then
        self.Bg:removeChild(self.award1)
    end

    self.award1 = qy.AwardList.new({
        ["award"] = data1,
        ["cellSize"] = cc.size(130,180),
        ["type"] = 1,
        ["itemSize"] = 2,
        ["hasName"] = false,
    })
    self.award1:setPosition(110,340)
    self.Bg:addChild(self.award1)

    if self.award2 then
        self.Bg:removeChild(self.award2)
    end

    self.award2 = qy.AwardList.new({
        ["award"] = data2,
        ["cellSize"] = cc.size(90,180),
        ["type"] = 1,
        ["itemSize"] = 2,
        ["hasName"] = false,
    })
    self.award2:setPosition(65,245)
    self.Bg:addChild(self.award2)


    self.Text:setString(qy.TextUtil:substitute(90314, idx))
end

return Cell