local ListView = qy.class("ListView", qy.tank.view.BaseView, "head_treasure.ui.ListView")

local model = qy.tank.model.OperatingActivitiesModel
local service = qy.tank.service.OperatingActivitiesService
local aType = qy.tank.view.type.ModuleType
function ListView:ctor(delegate, idx)
   	ListView.super.ctor(self)
    self:InjectView("bg")
    self:InjectView("Title")
    self:InjectView("Image_2")
    
    local z = 0
    local n = math.ceil(#delegate / 4)

    table.sort(delegate, function(a, b)
        return a.id < b.id
    end)

    for i, v in pairs(delegate) do
        local item = qy.tank.view.common.AwardItem.createAwardView(v.award[1],1)

        item.fatherSprite:setSwallowTouches(false)
        self.bg:addChild(item)

        local num = math.floor(z / 4)
        item:setPosition(z % 4 * 150 + 85, (n - math.floor(z / 4)) *  150 - 60)
        z = z + 1   
    end

    self.bg:setContentSize(cc.size(615,n * 150 + 50))
    self.Image_2:setPositionY(n * 150 + 20)

    local num = idx + 8
    self.Title:setSpriteFrame("head_treasure/res/" .. num .. ".png")
end

return ListView
