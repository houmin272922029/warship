local DesDialog = qy.class("DesDialog", qy.tank.view.BaseDialog, "help.ui.DesDialog")

local model = require("help.src.HelpModel")
-- local service = require("help.src.AdvanceService")

function DesDialog:ctor(delegate)
   	DesDialog.super.ctor(self)

   	self:setCanceledOnTouchOutside(true)
   	self:InjectView("Title")
    self:InjectView("ScrollView_1")
    -- self.ScrollView_1:setSwallowTouches(false)

    -- self.ScrollView_1:addEventListener(function(sender, eventype)
    --     if eventype == ccui.TouchEventType.moved then
    --         self.enableCallback = false
    --     elseif eventype == ccui.TouchEventType.CONTAINER_MOVED then

    --     end
    -- end)
    self.delegate = delegate

    local MOVE_INCH = 7.0/160.0
    local function convertDistanceFromPointToInch(pointDis)
        local glview = cc.Director:getInstance():getOpenGLView()
        local factor = (glview:getScaleX() + glview:getScaleY())/2
        return pointDis * factor / cc.Device:getDPI()
    end
  
    local touchPoint
    self.touchMoved = false

    self.onTouchBegan = function(touch, event)
        touchPoint = touch:getLocation()
        self.touchMoved = false
        return true
    end

    self.onTouchMoved = function(touch, event)
        local moveDistance = touch:getLocation()
        moveDistance.x = moveDistance.x - touchPoint.x
        moveDistance.y = moveDistance.y - touchPoint.y
        local dis = math.sqrt(moveDistance.x * moveDistance.x + moveDistance.y * moveDistance.y)
        if math.abs(convertDistanceFromPointToInch(dis)) >= MOVE_INCH then
            self.touchMoved = true
        end
    end

    self.listener = cc.EventListenerTouchOneByOne:create()
    self.listener:setSwallowTouches(false)
    self.listener:registerScriptHandler(self.onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    self.listener:registerScriptHandler(self.onTouchMoved, cc.Handler.EVENT_TOUCH_MOVED)
    self:getEventDispatcher():addEventListenerWithFixedPriority(self.listener, -1)

    local data = model.list[tostring(delegate.id1)][tostring(delegate.id2)]
    self.list = {}
    self:createList(data)
end



function DesDialog:createList(data)
    local ActivitiesCommand = qy.tank.command.ActivitiesCommand
    local ActivityIconsModel = qy.tank.model.ActivityIconsModel
    local mainCommand = qy.tank.command.MainCommand

    local h = 0
    for i, v in pairs(data) do
        local item = nil
        local iconDelegate = {
              ["data"] = v,
              ["node"] = self,
              ["callBack"] = function(idx)
                  if not self.touchMoved then
                      self.delegate.onClose()
                      self:dismiss()
                      print("收到的公司嘎嘎嘎 " .. idx)
                      if idx == 1 then

                      elseif (idx == 2 or idx == 59 or idx == 48 or idx == 44) then -- 军资基地
                          mainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.EXTRACTION_CARD)
                      elseif (idx == 3 or idx == 63) then -- 车库
                          mainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.TRAINING)
                          -- qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.GARAGE)
                      elseif idx == 4 then -- 装备强化
                          mainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.EQUIP)
                      elseif (idx == 5 or idx == 19) then -- 科技
                          mainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.TECHNOLOGY)
                      elseif idx == 6 then -- 合金
                          mainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.ALLOY)
                      elseif idx == 7 then -- 首充礼包
                          if ActivityIconsModel:hasFirstPayData() then
                              ActivitiesCommand:showActivity(qy.tank.view.type.ModuleType.FIRST_PAY)
                          else
                              qy.hint:show(qy.TextUtil:substitute(48030))
                          end
                      elseif idx == 8 then -- 累冲礼包
                          if ActivityIconsModel:hasIcon("total_pay") then
                              ActivitiesCommand:showActivity(qy.tank.view.type.ModuleType.TOTAL_PAY)
                          else
                              qy.hint:show(qy.TextUtil:substitute(48031))
                          end
                      elseif idx == 9 then --超值月卡
                          if ActivityIconsModel:hasIcon("month_card") then
                              ActivitiesCommand:showActivity(qy.tank.view.type.ModuleType.MONTH_CARD)
                          else
                              qy.hint:show(qy.TextUtil:substitute(48032))
                          end
                      elseif idx == 10 then
                          if ActivityIconsModel:hasIcon("up_fund") then
                              ActivitiesCommand:showActivity(qy.tank.view.type.ModuleType.UP_FUND)
                          else
                              qy.hint:show(qy.TextUtil:substitute(48033))
                          end
                      elseif (idx == 11 or idx == 45 or idx == 49 or idx == 54) then -- vip津贴
                          if ActivityIconsModel:hasIcon("vip_award") then
                              ActivitiesCommand:showActivity(qy.tank.view.type.ModuleType.VIP_AWARD)
                          else
                              qy.hint:show(qy.TextUtil:substitute(50005))
                          end
                      elseif (idx == 12 or idx == 34 or idx == 36) then -- 补给
                          qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.SUPPLY)
                      elseif idx == 13 then -- 训练场
                          mainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.TRAINING)
                      elseif idx == 14 then -- 大锅饭
                          if ActivityIconsModel:hasIcon("pot") then
                              ActivitiesCommand:showActivity(qy.tank.view.type.ModuleType.POT)
                          else
                              qy.hint:show(qy.TextUtil:substitute(48034))
                          end
                      elseif (idx == 15 or idx == 32) then --任务
                          qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.TASK)
                      elseif (idx == 16 or idx == 33 or idx == 41) then --战役
                          qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.CHAPTER)
                      elseif (idx == 17  or idx == 58) then -- 战车工厂
                          qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.TANK_SHOP)
                      elseif idx == 18 then -- 炮手训练
                          ActivitiesCommand:showActivity(qy.tank.view.type.ModuleType.GUNNER_TRAIN)
                      elseif idx == 20 then -- 伞兵入侵
                          ActivitiesCommand:showActivity(qy.tank.view.type.ModuleType.INVADE)
                      elseif (idx == 21 or idx == 42 or idx == 47) then -- 经典战役
                          ActivitiesCommand:showActivity(qy.tank.view.type.ModuleType.CLASSIC_BATTLE) 
                      elseif (idx == 22 or idx == 51) then -- 每日检阅
                          ActivitiesCommand:showActivity(qy.tank.view.type.ModuleType.INSPECTION) 
                      elseif (idx == 23 or idx == 35) then -- 矿区
                          qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.MINE_MAIN_VIEW)
                      elseif (idx == 24 or idx == 52 or idx == 56) then -- 军神榜
                          qy.tank.command.ActivitiesCommand:showActivity(qy.tank.view.type.ModuleType.ARENA)
                      elseif (idx == 25 or idx == 40 or idx == 46 or idx == 50 or idx == 55 or idx == 57 or idx == 62) then -- 远征
                          ActivitiesCommand:showActivity(qy.tank.view.type.ModuleType.FIGHT_JAPAN)
                      elseif idx == 26 then -- 图鉴
                          qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.ACHIEVEMENT, {["mType"] = mType})
                      elseif idx == 27 then -- 成就
                          qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.ACHIEVEMENT, {["mType"] = mType})
                      elseif (idx == 28 or idx == 53) then -- 分解
                          if qy.tank.model.ResolveModel:testOpen() then
                              qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.RESOLVE)
                          else
                              qy.hint:show(qy.TextUtil:substitute(48035) .. qy.TextUtil:substitute(48036, qy.Config.function_open["21"].open_level))
                          end
                      elseif idx == 29 then -- 世界BOSS
                          ActivitiesCommand:showActivity(qy.tank.view.type.ModuleType.BOSS)
                      elseif (idx == 30 or idx == 60 or idx == 61) then -- 黄金地堡
                          ActivitiesCommand:showActivity(qy.tank.view.type.ModuleType.GOLD_BUNKER)
                      elseif (idx == 31 or idx == 64) then -- 战车进阶
                          qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.GARAGE)
                      elseif (idx == 37 or idx == 38 or idx == 43) then -- 军需商店
                          qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.PROP_SHOP)
                      elseif idx == 39 then -- Vip
                          qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.VIP)
                      end
                  end
                  -- self.ScrollView_1:addEventListener()
              end
          }
        if v.icon == "" then
            item = require("help.src.DesList1").new(iconDelegate)
        else
            item = require("help.src.DesList2").new(iconDelegate)
        end

        table.insert(self.list, item)
        self.ScrollView_1:addChild(item)        
        h = h + item.h
    end
    local height = h > 450 and h or 450
    self.ScrollView_1:setInnerContainerSize(cc.size(550, height))

    local h2 = 0
    for i, v in pairs(self.list) do
        h2 = h2 + v.h
        v:setPositionY(height - h2)
    end
end

function DesDialog:render(title)
    self.Title:setString(title)
end

return DesDialog
