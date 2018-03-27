local MainDialog = qy.class("MainDialog", qy.tank.view.BaseView, "iron_mine.ui.MainDialog")

local service = qy.tank.service.OperatingActivitiesService
local model = qy.tank.model.OperatingActivitiesModel
local activity = qy.tank.view.type.ModuleType
function MainDialog:ctor(delegate)
   	MainDialog.super.ctor(self)
    self:InjectView("Image_1")
   	self:InjectView("Sprite_1")
   	self:InjectView("Sprite_2")
   	self:InjectView("Sprite_3")
    self:InjectView("Price1")
    self:InjectView("Price2")
    self:InjectView("Price3")
   	self:InjectView("Time")

    self:InjectView("Text_20")
    self:InjectView("Text_21")
    self:InjectView("Text_22")
    self.Text_20:setString(qy.tank.model.UserInfoModel.userInfoEntity.blueIron)
    self.Text_21:setString(qy.tank.model.UserInfoModel.userInfoEntity.purpleIron)
    self.Text_22:setString(qy.tank.model.UserInfoModel.userInfoEntity.orangeIron)
   	-- self:InjectView("Pages")
    -- self:InjectView("Btn_choose")
    -- self:InjectView("Btn_carray")
    -- self:InjectView("arrowTip")  

    -- self.Buttom:setLocalZOrder(5)

    self:OnClick("Button_1", function()
        service:getCommonGiftAward(1, activity.IRON_MINE,false, function(reData)
            self:showAction(1)
        end, true, 1)
        
    end,{["isScale"] = false})

    self:OnClick("Button_2", function()
        service:getCommonGiftAward(2, activity.IRON_MINE,false, function(reData)
            self:showAction(2)
        end, true, 1)
        -- local dialog = require("iron_mine.src.InfoDialog").new(self, 2)
        -- dialog:show()
    end,{["isScale"] = false})

    self:OnClick("Button_3", function()
        service:getCommonGiftAward(3, activity.IRON_MINE,false, function(reData)
            self:showAction(3)
        end, true, 1)
        -- local dialog = require("iron_mine.src.InfoDialog").new(self, 3)
        -- dialog:show()
    end,{["isScale"] = false})

    local staticData = qy.Config.iron_mine_double

    self.Price1:setString("x" .. staticData["1"].price1)
    self.Price2:setString("x" .. staticData["2"].price1)
    self.Price3:setString("x" .. staticData["3"].price1)
    self:play()

end

function MainDialog:showAction(type)
    qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsyncByModules("iron_mine/fx/ui_fx_caikuang",function()
        self.effect = ccs.Armature:create("ui_fx_caikuang")
        self.effect:getAnimation():playWithIndex(0,-1,0)
        self.effect:getAnimation():setMovementEventCallFunc(function(armatureBack,movementType,movementID)
            if movementType == ccs.MovementEventType.complete then
                self.effect:getParent():removeChild(self.effect)
                local dialog = require("iron_mine.src.InfoDialog").new(self, type)
                dialog:show()
            end
        end)
        self["Sprite_" .. type]:addChild(self.effect)
        self.effect:setPosition(100, 70)

        
    end)
end

function MainDialog:play()
    qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsyncByModules("iron_mine/fx/ui_fx_kuangmailan",function()
        local effect = ccs.Armature:create("ui_fx_kuangmailan")
        effect:getAnimation():playWithIndex(0,-1,1)
        -- effect:getAnimation():setMovementEventCallFunc(function(armatureBack,movementType,movementID)
        --     if movementType == ccs.MovementEventType.complete then
        --         effect:getParent():removeChild(self.effect)
        --         local dialog = require("iron_mine.src.InfoDialog").new(self, type)
        --         dialog:show()
        --     end
        -- end)
        self["Sprite_1"]:addChild(effect)
        effect:setPosition(100, 70)
    end)

    qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsyncByModules("iron_mine/fx/ui_fx_kuangmaizi",function()
        local effect = ccs.Armature:create("ui_fx_kuangmaizi")
        effect:getAnimation():playWithIndex(0,-1,1)
        -- effect:getAnimation():setMovementEventCallFunc(function(armatureBack,movementType,movementID)
        --     if movementType == ccs.MovementEventType.complete then
        --         effect:getParent():removeChild(self.effect)
        --         local dialog = require("iron_mine.src.InfoDialog").new(self, type)
        --         dialog:show()
        --     end
        -- end)
        self["Sprite_2"]:addChild(effect)
        effect:setPosition(100, 70)
    end)

    qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsyncByModules("iron_mine/fx/ui_fx_kuangmaicheng",function()
        local effect = ccs.Armature:create("ui_fx_kuangmaicheng")
        effect:getAnimation():playWithIndex(0,-1,1)
        -- effect:getAnimation():setMovementEventCallFunc(function(armatureBack,movementType,movementID)
        --     if movementType == ccs.MovementEventType.complete then
        --         effect:getParent():removeChild(self.effect)
        --         local dialog = require("iron_mine.src.InfoDialog").new(self, type)
        --         dialog:show()
        --     end
        -- end)
        self["Sprite_3"]:addChild(effect)
        effect:setPosition(100, 70)
    end)
end

function MainDialog:onEnter()
    -- self.ironMineType = data.type
    -- self.ironMineNum = data.num
    -- self.ironMineStatus = data.status
    if model.ironMineStatus == 1 then
        performWithDelay(self ,function()
            local dialog = require("iron_mine.src.InfoDialog").new(self, model.ironMineType)
            dialog:show()
        end, 0.05)
        
    end

    if model.ironMineEndtime then
        self.Time:setString(qy.tank.utils.DateFormatUtil:toDateString(model.ironMineEndtime - qy.tank.model.UserInfoModel.serverTime, 3))
        self.listener_1 = qy.Event.add(qy.Event.BONUS_TIME,function(event)
            self.Text_20:setString(qy.tank.model.UserInfoModel.userInfoEntity.blueIron)
            self.Text_21:setString(qy.tank.model.UserInfoModel.userInfoEntity.purpleIron)
            self.Text_22:setString(qy.tank.model.UserInfoModel.userInfoEntity.orangeIron)
            -- self.Time1:setString(qy.tank.utils.DateFormatUtil:toDateString(model.bonusBeginTime, 3))
            self.Time:setString(qy.tank.utils.DateFormatUtil:toDateString(model.ironMineEndtime - qy.tank.model.UserInfoModel.serverTime, 3))
        end)
    end
end

function MainDialog:onExit()
    if self.listener_1 then
        qy.Event.remove(self.listener_1)
    end
end

return MainDialog
