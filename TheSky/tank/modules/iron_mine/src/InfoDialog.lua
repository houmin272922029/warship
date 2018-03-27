local InfoDialog = qy.class("InfoDialog", qy.tank.view.BaseDialog, "iron_mine.ui.InfoDialog")

local model = qy.tank.model.OperatingActivitiesModel
local service = qy.tank.service.OperatingActivitiesService
local activity = qy.tank.view.type.ModuleType
function InfoDialog:ctor(delegate, type)
   	InfoDialog.super.ctor(self)
    -- self:setCanceledOnTouchOutside(true)
    self:InjectView("BG")
   	self:InjectView("Img")
   	self:InjectView("Sprite_2")
   	self:InjectView("Num1")
   	self:InjectView("Num2")
   	self:InjectView("Num3")
    self:InjectView("Mul")
    self:InjectView("Success")
    self:InjectView("Sprite_1")
    self:InjectView("Info2")    
    self:InjectView("Info3")  
    self:InjectView("Num3") 
    self:InjectView("Sprite_3") 
    self:InjectView("NumBg")
    
    -- self.Buttom:setLocalZOrder(5)

    self:OnClick("Button_award", function()
        service:getCommonGiftAward(self.type, activity.IRON_MINE,false, function(reData)
            self:dismiss()
        end, true, 3)
    end,{["isScale"] = false})

    self:OnClick("Button_mul", function()
        service:getCommonGiftAward(self.type, activity.IRON_MINE,false, function(reData)
            if reData.activity_info.is_success then
                self:setData()
                self:upAction()
            else
                self:upAction()
                performWithDelay(self,function()
                    self:dismiss()
                    local dialog = require("iron_mine.src.TipsDialog").new(self.type, reData.award)
                    dialog:show()
                end, 1)
            end
        end, true, 2)
    end,{["isScale"] = false})

    self.BG:setPositionX(display.width / 2)

    self.x = self.Success:getPositionX()
    self.y = self.Success:getPositionY()
    self.Img:setSpriteFrame("iron_mine/res/" .. type .. ".png")
    self.type = type
    self:setData()
    self:upAction()
    self:play2()
end

function InfoDialog:setData()
    self.Num1:setString("+" .. model.ironMineNum)
    -- self.Num1:setTextColor(qy.tank.utils.ColorMapUtil.qualityMapColor(tostring(self.type + 2)))
    self.Num2:setString("x" .. model.ironMineNum * 2)
    self.Num3:setString("x" .. model.ironMinePrice or 0)
    local mul = model.ironMineTimes > 1 and model.ironMineTimes or qy.TextUtil:substitute(49001)
    self.Mul:setString(qy.TextUtil:substitute(49002) .. mul)
    local id = self.type + 5
    self.Sprite_1:setTexture("Resources/common/icon/coin/" .. id .. ".png" )
    self.Sprite_2:setTexture("Resources/common/icon/coin/" .. id .. ".png" )

    if model.ironMineTimes >= 10 then
        self.Info2:setVisible(false)
        self.Sprite_2:setVisible(false)
        self.Num2:setVisible(false)
        self.Info3:setVisible(false)
        self.Sprite_3:setVisible(false)
        self.Num3:setVisible(false)
        self.NumBg:setVisible(false)
    end
end

function InfoDialog:upAction()
    local idx = model.ironMineSuccess and 1 or 2
    self.Success:setSpriteFrame("iron_mine/res/success" .. idx .. ".png")
    self.Success:setVisible(model.ironMineSuccess ~= nil)
    self.Success:setOpacity(0)

      -- model.ironMineNum
    if self.Success:isVisible() then
        self:play()
    end
end

function InfoDialog:play()
    self.Success:setOpacity(255)
    -- self.Success:setPosition(self.x, self.y + 50)
    self.Success:setScale(1.5)

    local func1 = cc.ScaleTo:create(0.1, 0.9)
    local func2 = cc.ScaleTo:create(0.05, 1)
    local func3 = cc.FadeTo:create(0.5, 0)
    -- local func3 = cc.callFunc:create(function()
    --     self.Success:setOpacity(0)
    -- end)

    local seq = cc.Sequence:create(func1, func2, func3)

    -- local func4 = cc.Spawn:create(seq, func3)

    self.Success:runAction(seq)
end

function InfoDialog:play2()
    -- self.Sprite_1:stopAllActions()
    local moveUp = cc.MoveBy:create(0.4, cc.p(0,10))
    local moveDown = cc.MoveBy:create(0.4, cc.p(0,-10))
    local seq = cc.Sequence:create(callFunc, moveUp, moveDown)
    self.Sprite_1:runAction(cc.RepeatForever:create(seq))

    -- self.Num1:stopAllActions()
    local moveUp = cc.MoveBy:create(0.4, cc.p(0,10))
    local moveDown = cc.MoveBy:create(0.4, cc.p(0,-10))
    local seq = cc.Sequence:create(callFunc, moveUp, moveDown)
    self.Num1:runAction(cc.RepeatForever:create(seq))
end

return InfoDialog