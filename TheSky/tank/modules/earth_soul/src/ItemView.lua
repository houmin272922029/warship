local ItemView = qy.class("ItemView", qy.tank.view.BaseView, "earth_soul.ui.ItemView")

local model = qy.tank.model.OperatingActivitiesModel
local service = qy.tank.service.OperatingActivitiesService
local activity = qy.tank.view.type.ModuleType
function ItemView:ctor(delegate)
   	ItemView.super.ctor(self)

    self:InjectView("Times")
    self:InjectView("Name1")
    self:InjectView("Name2")
    self:InjectView("soul_1")
    self:InjectView("Num1")
    self:InjectView("soul_2")
    self:InjectView("soul_3")
    self:InjectView("Num2")
    self:InjectView("Num3")
    self:InjectView("Button_1")
    self:InjectView("Btn_text")
    self:InjectView("HasGot")
    
    -- self.Image_1:setSwallowTouches(false)
   	self:OnClick("Button_1", function()
        if self.status == 1 then
            service:getCommonGiftAward({
                ["type"] = 2,
                ["id"] = self.id,
                ["activity_name"] = activity.EARTH_SOUL
            }, activity.EARTH_SOUL,false, function(reData)
                self:update()
        end, true)
        elseif self.status == 2 then
            qy.hint:show(qy.TextUtil:substitute(45002))
        elseif self.status == 3 then
            qy.hint:show(qy.TextUtil:substitute(45003))
        end
    end,{["isScale"] = false})
end

function ItemView:setData(data, idx)
    local award = data.award

    self.Name1:setVisible(false)
    self.Name2:setVisible(false)
    for i = 1, 3 do
        self["soul_" .. i]:setVisible(false)
        self["Num" .. i]:setVisible(false)
    end

    for i, v in pairs(data.award) do
        local itemData = qy.tank.view.common.AwardItem.getItemData(v)
        if v.type ~= 12 then
            self["soul_" .. i]:setVisible(true)
            self["soul_" .. i]:setTexture(itemData.icon)
            self["soul_" .. i]:setScale(0.5)
            self["Num" .. i]:setVisible(true)
            self["Num" .. i]:setString("x" .. itemData.num)
        else
            self["Name" .. i]:setVisible(true)
            self["Name" .. i]:setString(itemData.name)
        end
    end

    self.Times:setString(qy.TextUtil:substitute(45004) .. data.times .. qy.TextUtil:substitute(45005))

    self.data = data

    self.id = data.id
    self:update()
end

function ItemView:update()
     if model.earthSoulTotalTimes >= self.data.times then
        if table.keyof(model.earthSoulAchieveAward, self.id) then
            self.status = 3
        else
            self.status = 1
        end 
    else
        self.status = 2
    end
    self.Button_1:setBright(self.status == 1)
    self.Button_1:setVisible(self.status ~= 3)
    self.HasGot:setVisible(self.status == 3)
    local info = self.status == 2 and "weidacheng" or "lingqu"
    self.Btn_text:setSpriteFrame("Resources/common/txt/" .. info .. ".png")
end

return ItemView
