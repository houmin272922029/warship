local ItemCell = qy.class("ItemCell", qy.tank.view.BaseView, "outstanding.ui.ItemCell")

local model = qy.tank.model.OperatingActivitiesModel
local service = qy.tank.service.OperatingActivitiesService
function ItemCell:ctor(delegate)
   	ItemCell.super.ctor(self)
   	self:InjectView("Text_1")
   	self:InjectView("Text_2")
   	self:InjectView("Button_1")
    self:InjectView("Sprite_1")
   	self:InjectView("Sprite_2")
    self:InjectView("Sprite_3")
    self:InjectView("Panel_1")

   	self:OnClick("Button_1", function()
        if self.state == 0 then
            local passenger = {["idx1"] = 2, ["idx2"] = 1}
            qy.tank.command.MainCommand:viewRedirectByModuleType("passenger", passenger)
            qy.Event.dispatch(qy.Event.SEARCH_TREASURE)
        elseif self.state == 2 then
            local aType = qy.tank.view.type.ModuleType
                service:getCommonGiftAward({
                    ["id"] = self.times,
                    ["activity_name"] = aType.OUTSTANDING
                }, aType.OUTSTANDING,false, function()
                    self.Button_1:setVisible(false)
                    self.Text_2:setVisible(false)
                    self.Sprite_3:setVisible(true)
            end)
        end
   		
   	end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})
end

function ItemCell:setData(data, index)
    self.id = index
    self.times = data.times
    cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/common/txt/common_txt.plist")
    local awardData = data.award
    self.Panel_1:removeAllChildren()
	for i=1,#awardData do
        local item = qy.tank.view.common.AwardItem.createAwardView(awardData[i] ,1)
        self.Panel_1:addChild(item)
        item:setPosition(90 + 120*(i - 1), 60)
        item:setScale(0.85)
        item.name:setVisible(false)
        item.fatherSprite:setSwallowTouches(false)
    end

    local outStandingData = model.outStandingData
    self.Text_1:setString("累计招募乘员"..data.times.."次")
    self.Text_2:setString("进度："..(outStandingData.num <= data.times and outStandingData.num or data.times).."/"..data.times)

    self.state = tonumber(outStandingData[data.times..""])
    self.Sprite_3:setVisible(self.state == 1)
    self.Button_1:setVisible(self.state ~= 1)
    self.Text_2:setVisible(self.state ~= 1)
    if self.state == 0 then
        self.Sprite_2:setSpriteFrame("Resources/common/txt/qianwang.png")
    elseif self.state == 2 then
        self.Sprite_2:setSpriteFrame("Resources/common/txt/lingqu.png")
    end
end

return ItemCell