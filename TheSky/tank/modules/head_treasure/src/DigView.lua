local DigView = qy.class("DigView", qy.tank.view.BaseView, "head_treasure.ui.DigView")

local model = qy.tank.model.OperatingActivitiesModel
local service = qy.tank.service.OperatingActivitiesService
local aType = qy.tank.view.type.ModuleType
function DigView:ctor(delegate)
   	DigView.super.ctor(self)
    self:InjectView("Tool1")
    self:InjectView("Tool2")
    self:InjectView("Num1")
    self:InjectView("Num2")
    self:InjectView("Info1")
    self:InjectView("Info2")
    -- self:InjectView("hasGot")
   

   	self:OnClick("Btn_find1", function()
        local param = {
            ["id"] = self.idx,
            ["activity_name"] = aType.HEAD_TREASURE,
            ["times"] = 1
        }
        service:getCommonGiftAward(param, aType.HEAD_TREASURE,false, function(reData)
            self:setData(self.idx)
        end)
    end,{["isScale"] = false})

    self:OnClick("Btn_find2", function()
        if model.headTreasureTimes > 0 then
            qy.hint:show(qy.TextUtil:substitute(47001))
        else
            local param = {
                ["id"] = self.idx,
                ["activity_name"] = "head_treasure",
                ["times"] = 10
            }

            service:getCommonGiftAward(param, aType.HEAD_TREASURE,false, function(reData)
                self:setData(self.idx)
            end)
        end
    end,{["isScale"] = false})
end

function DigView:setData(data)
    cc.SpriteFrameCache:getInstance():addSpriteFrames("head_treasure/res/res.plist")
    self.idx = data
    local num = data + 5
    self.Tool1:setSpriteFrame("head_treasure/res/" .. num .. ".png")
    self.Tool2:setSpriteFrame("head_treasure/res/" .. num .. ".png")
    self.Num1:setString(model.headTreasureDiamond)
    self.Num2:setString(model.headTreasureDiamond * 10)

    self.Info1:setVisible(model.headTreasureTimes <= 0)
    self.Info2:setVisible(model.headTreasureTimes > 0)
    self.Info2:setString(qy.TextUtil:substitute(47002) .. model.headTreasureTimes)
end

return DigView
