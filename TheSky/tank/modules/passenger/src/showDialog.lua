
local showDialog = qy.class("showDialog", qy.tank.view.BaseDialog, "passenger.ui.showDialog")

local PassengerService = qy.tank.service.PassengerService
local model = qy.tank.model.StorageModel
local PassengerModel = qy.tank.model.PassengerModel

function showDialog:ctor(type,award)
   	showDialog.super.ctor(self)
   	self:setCanceledOnTouchOutside(true)
   	self.type = type
   	self:InjectView("Button_1")
    self:InjectView("Text_1")
    self:InjectView("Text_2")
    self:InjectView("rank")
    self:InjectView("card")
    self:InjectView("Sprite_9")
    self:InjectView("Sprite_2")
    self:InjectView("textType")
    cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/common/item/common_item.plist")
    cc.SpriteFrameCache:getInstance():addSpriteFrames("passenger/res/passengerui.plist")
    cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/common/item/common_icon.plist")
    self.Text_2:setString(self.type == 100 and 50 or 300)
    self.Sprite_9:loadTexture(self.type == 100 and "Resources/common/icon/coin/1.png" or "Resources/common/icon/coin/1.png")
    
    if self.type == 100 and model:getPropNumByID(51)>0 then
        self.Text_2:setString(1)
        self.Sprite_9:loadTexture("Resources/common/icon/12.png", 1)
    end
   	self:OnClick("Button_1", function()
        if self.type == 100 then
            if model:getPropNumByID(51)>0 then
                PassengerService:extract({
                        ["num"] = 1,
                        ["type"] = self.type,
                    },function(reData)
                        model:remove(51, 1)
                        self:update(reData.award, 1)
                end)
            else
                qy.hint:show(qy.TextUtil:substitute(12001))
                qy.tank.model.PropShopModel:init()
                local entity = qy.tank.model.PropShopModel:getShopPropsEntityById(24)
                local buyDialog = qy.tank.view.shop.PurchaseDialog.new(entity,function(num)
                    local service = qy.tank.service.ShopService
                    service:buyProp(entity.id,num,function(data)
                        if data and data.consume then
                            qy.hint:show(qy.TextUtil:substitute(8029)..data.consume.num)
                        end
                        if model:getPropNumByID(51) > 0 then
                            self.Text_2:setString(1)
                            self.Sprite_9:loadTexture("Resources/common/icon/12.png", 1)
                        end
                    end)
                end)
                buyDialog:show(true)
            end
        else
            PassengerService:extract({
                    ["num"] = 1,
                    ["type"] = self.type,
                },function(reData)
                    self:update(reData.award, 1)
            end)
        end
    end,{["isScale"] = false})
    local scale1 = cc.ScaleTo:create(0.2,0.94)
    local scale2 = cc.ScaleTo:create(0.1,1.08)
    local scale3 = cc.ScaleTo:create(0.1,1)
    local sound = cc.CallFunc:create(function()
        qy.QYPlaySound.playEffect(qy.SoundType.SWITCH_CHAPTER)
    end)

    local seq1 = cc.Sequence:create(sound,scale1,scale2,scale3)
    self.Sprite_2:runAction(cc.Sequence:create(seq1,cc.CallFunc:create(function()

    end)))
    self:update(award)
end

function showDialog:update(award, actionType)
    local passengerId = award[1].id
    local cfg = qy.Config.passenger
    self.Text_1:setString(cfg[tostring(passengerId)].name)
    self.Text_1:setColor(qy.tank.utils.ColorMapUtil.qualityMapColor(cfg[tostring(passengerId)].quality or 1))
    self.textType:setString(cfg[tostring(passengerId)].type == 1 and ("(将领)"..PassengerModel.typeNameList[cfg[tostring(passengerId)].type .. ""]) or  PassengerModel.typeNameList[cfg[tostring(passengerId)].type .. ""])
    self.textType:setColor(qy.tank.utils.ColorMapUtil.qualityMapColor(cfg[tostring(passengerId)].quality or 1))
    self.rank:setSpriteFrame("Resources/common/item/k" .. cfg[tostring(passengerId)].quality .. ".png")
    self.Text_2:setString(self.type == 100 and 50 or 300)
    self.Sprite_9:loadTexture(self.type == 100 and "Resources/common/icon/coin/1.png" or "Resources/common/icon/coin/1.png")
    if self.type == 100 then
        self.Text_2:setString(1)
        self.Sprite_9:loadTexture("Resources/common/icon/12.png", 1)
    end
    self.card:loadTexture("res/passenger/" .. passengerId .. ".jpg")

    if actionType == 1 then
        local scale1 = cc.ScaleTo:create(0.2,0.9)
        local scale2 = cc.ScaleTo:create(0.1,1.1)
        local scale3 = cc.ScaleTo:create(0.1,1)
        local sound = cc.CallFunc:create(function()
            qy.QYPlaySound.playEffect(qy.SoundType.SWITCH_CHAPTER)
        end)

        local seq1 = cc.Sequence:create(sound,scale1,scale2,scale3)
        self.card:runAction(cc.Sequence:create(seq1,cc.CallFunc:create(function()

        end)))
    end
end

function showDialog:onEnter()
    
end

function showDialog:onExit()

end

return showDialog