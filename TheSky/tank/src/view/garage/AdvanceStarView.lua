local AdvanceStarView = qy.class("AdvanceStarView", qy.tank.view.BaseView, "view/garage/AdvanceStarView")

local garageModel = qy.tank.model.GarageModel
local model = qy.tank.model.AdvanceModel
-- require("advance.src.AdvanceModel")
-- model:init()

function AdvanceStarView:ctor(delegate, oldTankId,newTankId)
   	AdvanceStarView.super.ctor(self)

    qy.tank.utils.cache.CachePoolUtil.addArmatureFile(qy.ResConfig.JINJIE_CHENGGONG)
   	self:InjectView("BG")
    self:InjectView("ScrollView_1")

    -- self.Sprite:setLocalZOrder(10)
    self:OnClick("CloseBtn", function()
        --delegate.viewStack:pop()
        self:removeSelf()
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})

    local winsize = display.size


    local item1 = require("view/garage/TankInfoList2").new(cc.size(470,635))
     local data1 = qy.tank.entity.TankEntity.new(oldTankId, false) 
     local data2 = qy.tank.entity.TankEntity.new(newTankId,false)
    -- local data = model:atSpecailByLevel(delegate.entity, 6)
    -- if data.type == 9 then
    --     local data2 = qy.tank.entity.TankEntity.new(data.param, false)

         item1:render(data1, data2)
    -- end
    
    item1:setPosition(winsize.width / 2 - 235, 0)

    local h = item1.h or 1000
    self.ScrollView_1:setInnerContainerSize(cc.size(display.size.width, h + 400))

    self.ScrollView_1:setContentSize(display.size)
    -- self.ScrollView_1:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.ScrollView_1:addChild(item1)
    -- self.ScrollView_1:addChild(item2)
    self.item = item1

    self:playAnimate()
end

function AdvanceStarView:playAnimate()
    qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsyncByModules("advance/fx/ui_fx_jinjie", function()
    -- qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsyncByModules("fx/temp/ui_fx_jinjie",function()
        if not self.effect then
          self.effect = ccs.Armature:create("ui_fx_jinjie") 
          self.item.tankCard:addChild(self.effect)
          self.item.tankCard.fatherSprite:setLocalZOrder(2)
          self.item.tankCard.childSprite:setLocalZOrder(2)
          self.item.tankCard.name:setLocalZOrder(2)
          self.item.tankCard.sealSprite:setLocalZOrder(2)
          local x = self.item.tankCard:getPositionX()
          local y = self.item.tankCard:getPositionY()
          self.effect:setAnchorPoint(0.5,0.5)
          self.effect:getAnimation():playWithIndex(0, 1, 1)

          self.effect:setScale(1.5)
          -- self.effect:setLocalZOrder(-1)
        else
          self.effect:getAnimation():playWithIndex(0, 1, 1)
        end
    end) 

    self.advance = ccs.Armature:create("ui_fx_jinjiechenggong") 
    self.advance:setAnchorPoint(0.5,0.5)
    self.item.tankCard:addChild(self.advance, 10)
    self.advance:getAnimation():playWithIndex(1)
end

function AdvanceStarView:onExit()
     -- qy.tank.utils.cache.CachePoolUtil.removeArmatureFileByModules("fx/temp/ui_fx_jinjie")
     -- self.effect:getParent():removeChild(self.effect, true)
     qy.tank.utils.cache.CachePoolUtil.removeArmatureFile(qy.ResConfig.JINJIE_CHENGGONG)
end

return AdvanceStarView
