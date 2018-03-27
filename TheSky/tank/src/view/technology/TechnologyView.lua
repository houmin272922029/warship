--[[
    科技入口类
]]
local TechnologyView = qy.class("TechnologyView", qy.tank.view.BaseView, "view/technology/TechnologyView")

function TechnologyView:ctor(delegate)
    TechnologyView.super.ctor(self)

    self.delegate = delegate
    self.model = qy.tank.model.TechnologyModel
    self.userModel = qy.tank.model.UserInfoModel
    -- self:InjectView("btn1")
    -- self:InjectView("btn2")
    -- self:InjectView("btn3")
    -- self:InjectView("btn4")

    --小齿轮
    self:InjectView("smallWheel1")
    self:InjectView("smallWheel2")
    self:InjectView("smallWheel3")
    self:InjectView("smallWheel4")
    self:InjectView("Image_6")

    local winSize = cc.Director:getInstance():getWinSize()
    self.Image_6:setPositionX(winSize.width / 2)

    -- 中齿轮
    self:InjectView("middleWheel1")
      self:InjectView("middleWheel_shadow1")
      self:InjectView("middleWheel_wheel1")
      self:InjectView("middleWheel_close1")
      self:InjectView("middleWheel_none1")
    self:InjectView("middleWheel2")
      self:InjectView("middleWheel_shadow2")
      self:InjectView("middleWheel_wheel2")
      self:InjectView("middleWheel_close2")
      self:InjectView("middleWheel_none2")
    self:InjectView("middleWheel3")
      self:InjectView("middleWheel_shadow3")
      self:InjectView("middleWheel_wheel3")
      self:InjectView("middleWheel_close3")
      self:InjectView("middleWheel_none3")
    self:InjectView("middleWheel4")
      self:InjectView("middleWheel_shadow4")
      self:InjectView("middleWheel_wheel4")
      self:InjectView("middleWheel_close4")
      self:InjectView("middleWheel_none4")

    -- 超级齿轮
    self:InjectView("supperWheel")
    self:InjectView("superWheelBg")

    -- 中齿轮标题
    self:InjectView("nameBg1")
      self:InjectView("nameBg_open1")
      self:InjectView("name1")
    self:InjectView("nameBg2")
      self:InjectView("name2")
      self:InjectView("nameBg_open2")
    self:InjectView("nameBg3")
      self:InjectView("name3")
      self:InjectView("nameBg_open3")
    self:InjectView("nameBg4")
      self:InjectView("name4")
      self:InjectView("nameBg_open4")

    self:InjectView("eye")

    self.service = qy.tank.service.TechnologyService

    self:OnClick("closeBtn", function(sender)
        self:clear()
        self.delegate.dismiss()
    end,{["audioType"] = qy.SoundType.BTN_CLOSE,["isScale"] = false})

    self:OnClick("middleWheel_none1", function(sender)
         self:getListByTemplateIndex(1)
    end, {["isScale"] = false})

    self:OnClick("middleWheel_none2", function(sender)
        -- local currentUserLevel = self.userModel.userInfoEntity.level
        -- local needLevel = self.model.unlockLevel[2]
        if self.model:testOpen(2) then
            self:getListByTemplateIndex(2)
        else
            qy.hint:show(qy.TextUtil:substitute(35013))
        end
    end, {["isScale"] = false})

    self:OnClick("middleWheel_none3", function(sender)
        -- local currentUserLevel = self.userModel.userInfoEntity.level
        -- local needLevel = self.model.unlockLevel[2]
        if self.model:testOpen(3) then
            self.service:getList2(1,function(data)
                self.delegate.showDetail2(1)
            end)
        else
            qy.hint:show(qy.TextUtil:substitute(48036, tonumber(self.model.unlockLevel[3])))
        end
    end, {["isScale"] = false})

    self:OnClick("middleWheel_none4", function(sender)
        -- local currentUserLevel = self.userModel.userInfoEntity.level
        -- local needLevel = self.model.unlockLevel[2]
        if self.model:testOpen(4) then
            self.service:getList2(2,function(data)
                self.delegate.showDetail2(2)
            end)
        else
            qy.hint:show(qy.TextUtil:substitute(48036, tonumber(self.model.unlockLevel[4])))
        end
    end, {["isScale"] = false})



    -- self:OnClick("btn3", function(sender)
    --     self:getListByTemplateIndex(3)
    -- end)

    -- self:OnClick("btn4", function(sender)
    --     self:getListByTemplateIndex(4)
    -- end)



    self.model:getTechEffertAttr()

    -- particle effect
   -- local effect = qy.tank.view.common.ParticleEffect

   -- effect:showMeteor(self, 200)

   -- local thisEffert2 = effect:showSnow(self, 100)
   -- thisEffert2:setPosition(0,-qy.winSize.height/4)
   -- thisEffert2:setRotation(-120)
   -- thisEffert2:setScale(2)

   -- thisEffert.speed =  10000
   -- effect:showMeteor(self)
   -- effect:showSmoke(self)
   -- effect:showExplosion(self)
   -- effect:showFire(self)
   -- effect:showFireworks(self)
   -- effect:showFlower(self)
   -- effect:showGalaxy(self)
   -- effect:showSpiral(self)
   -- effect:showSun(self)
   -- effect:showRain(self)
   self:init()

   self:inAnimationRun()

   qy.tank.utils.cache.CachePoolUtil.addArmatureFile("fx/".. qy.language .."/ui/technology/UI_fx_zhuangbeishengji")

   self.isInit = true
   qy.Event.dispatch(qy.Event.SERVICE_LOADING_HIDE)
end

function TechnologyView:addRainAndSnowEffert( )
  if self.rainEffert ~= nil then return end
  self.rainEffert = true
   --particle effect
   local effect = qy.tank.view.common.ParticleEffect
   local thisEffert1 = effect:showRain(self, 200)
   thisEffert1:setPosition(0.2*qy.winSize.width,-3.5*qy.winSize.height)
   thisEffert1:setRotation(-100)
   thisEffert1:setScale(10)

   local thisEffert2 = effect:showSnow(self, 100)
   thisEffert2:setPosition(0,-qy.winSize.height/4)
   thisEffert2:setRotation(-120)
   thisEffert2:setScale(2)
end

-- 播放闪电动画
function TechnologyView:runLightning()
    if self.currentEffert == nil then
      self.currentEffert = ccs.Armature:create("UI_fx_zhuangbeishengji")
      self:addChild(self.currentEffert,999)
      -- self.currentEffert:getAnimation():setMovementEventCallFunc(function(armatureBack,movementType,movementID)
      --     if movementType == ccs.MovementEventType.complete then
      --         -- self.currentEffert = nil
      --         -- effect:getParent():removeChild(effect)
      --         -- effect = nil
      --         self:runLightning()
      --     end
      -- end)
    end
    local direct = 10*math.random() >5 and 1 or -1
    local areaNum = 300
    self.currentEffert:setPosition(qy.winSize.width/2 + areaNum*direct*math.random(), qy.winSize.height/2+areaNum*direct*math.random())
    self.currentEffert:getAnimation():playWithIndex(0)
    local seq = cc.Sequence:create(cc.DelayTime:create(1+10*math.random()) , cc.CallFunc:create(function()
        self:runLightning()
    end))
    self:runAction(seq)
end

-- 播放中型齿轮
function TechnologyView:inAnimationRun( )
  self.nameBg1:setVisible(false)
  self.nameBg2:setVisible(false)
  self.nameBg3:setVisible(false)
  self.nameBg4:setVisible(false)

  local startScale = 5
  self.middleWheel1:setScale(startScale)
  self.middleWheel2:setScale(startScale)
  self.middleWheel3:setScale(startScale)
  self.middleWheel4:setScale(startScale)

  self.middleWheel1:setOpacity(0)
  self.middleWheel2:setOpacity(0)
  self.middleWheel3:setOpacity(0)
  self.middleWheel4:setOpacity(0)

  function toMoveMiddleWheel(middleWheel , startDelay , nameBg , middleWheelBorder1, middleWheelShadow)
      local runTime = 0.3
      local scale = cc.ScaleTo:create(runTime,1) --  缩放
      local fadeIn = cc.FadeIn:create(runTime) -- 渐入
      local delay = cc.DelayTime:create(startDelay)
      local spawn = cc.Spawn:create(fadeIn ,  scale )
      local seq = cc.Sequence:create(delay , spawn ,cc.CallFunc:create(function()
          nameBg:setScaleX(1)
          nameBg:setScaleY(0.1)
          nameBg:setVisible(true)
          nameBg:runAction(cc.Sequence:create(cc.ScaleTo:create(0.5,1)))


          local allTime = runTime * 10
          local rotate1 = cc.RotateBy:create(allTime,360) -- 旋转
          local rotate2 = cc.RotateBy:create(allTime,360) -- 旋转
          local rotate3 = cc.RotateBy:create(allTime,360) -- 旋转
          -- local seq1 = cc.Sequence:create(rotate1)
          -- local seq2 = cc.Sequence:create(rotate2)
          -- local seq3 = cc.Sequence:create(rotate3)
          middleWheelBorder1:runAction(rotate1)
          -- middleWheelBorder2:runAction(rotate2)
          middleWheelShadow:runAction(rotate3)
          self:superWheelRun(2 , 1  , -1)

      end))
      middleWheel:runAction(seq)
    end



    local disTime = 0.2
    toMoveMiddleWheel(self.middleWheel1 , 0.1 +disTime * 0 , self.nameBg1 , self.middleWheel_wheel1, self.middleWheel_shadow1 )
    toMoveMiddleWheel(self.middleWheel2 , 0.1 +disTime * 1 , self.nameBg2 , self.middleWheel_wheel2, self.middleWheel_shadow2 )
    toMoveMiddleWheel(self.middleWheel3 , 0.1 +disTime * 2 , self.nameBg3 , self.middleWheel_wheel3, self.middleWheel_shadow3 )
    toMoveMiddleWheel(self.middleWheel4 , 0.1 +disTime * 3 , self.nameBg4 , self.middleWheel_wheel4, self.middleWheel_shadow4 )
end

-- 初始化4个科技齿轮
function TechnologyView:init( )
    for i=1,4 do
      self:initSingleTech(i , self.model.unlockLevel[i])
    end
end

--初始化单个科技齿轮
function TechnologyView:initSingleTech(id , needLevel)
    -- local middleWheel_shadow =  self:findViewByName("middleWheel_shadow"..id)
    local middleWheel_wheel = self["middleWheel_wheel"..id]
    -- local middleWheel_open = self:findViewByName("middleWheel_open"..id)
    local middleWheel_close = self["middleWheel_close"..id]
    local middleWheel_none = self["middleWheel_none"..id]

    middleWheel_close:setVisible(false)
    -- middleWheel_none:setVisible(false)
    local nameBg_open = self["nameBg_open"..id]
    -- local nameBg_close = self["nameBg_close"..id]
    -- local nameBg_none = self["nameBg_none"..id]
    local name = self["name"..id]
    -- nameBg_open:setVisible(false)
    -- nameBg_close:setVisible(false)
    -- nameBg_none:setVisible(false)

    local currentUserLevel = self.userModel.userInfoEntity.level

    if needLevel == nil then
      -- middleWheel_wheel_none:setVisible(true)
      -- middleWheel_none:setVisible(true)
      -- nameBg_none:setVisible(true)
      nameBg_open:setSpriteFrame("Resources/technology/noneTxtBg.png")
      middleWheel_wheel:setSpriteFrame("Resources/technology/black.png")
      middleWheel_none:loadTexture("Resources/technology/close" .. id .. ".png", ccui.TextureResType.plistType)
      name:setSpriteFrame("Resources/technology/noneTxt.png")
    elseif currentUserLevel< needLevel then
      middleWheel_close:setVisible(true)
      middleWheel_wheel:setSpriteFrame("Resources/technology/light.png")
      middleWheel_none:loadTexture("Resources/technology/open" .. id .. ".png", ccui.TextureResType.plistType)
      nameBg_open:setSpriteFrame("Resources/technology/closeTxtBg.png")
      name:setSpriteFrame("Resources/technology/closeTxt"..id..".png")
    else
      middleWheel_wheel:setSpriteFrame("Resources/technology/light.png")
      middleWheel_none:loadTexture("Resources/technology/open" .. id .. ".png", ccui.TextureResType.plistType)
      nameBg_open:setSpriteFrame("Resources/technology/openTxtBg.png")

      if cc.SpriteFrameCache:getInstance():getSpriteFrame("Resources/technology/openTxt" .. id .. ".png") then
          name:setSpriteFrame("Resources/technology/openTxt" .. id .. ".png")
      end
      -- nameBg_open:setVisible(true)
    end
end

-- 小齿轮运动动画
function TechnologyView:smallWheelRun()
    -- self.smallWheel1
    function toMoveSmallWheel(smallWheel , direct  )
      local runTime = 5+2*math.random()
      local fadeIn = cc.FadeIn:create(runTime) -- 渐入
      local rotate = cc.RotateBy:create(runTime,direct*360) -- 旋转
      -- local scale = cc.ScaleTo:create(runTime,0.1) --  缩放
      -- local bezier ={
      --     prepoint,--起始点
      --     cc.p(maxX*getRandom(), maxY*getRandom()),--控制点
      --     cc.p(maxX*getRandom() , maxY*getRandom())--结束点
      -- }
      -- local bezierTo = cc.BezierTo:create(.5, bezier)
      local seq = cc.Sequence:create(rotate,cc.CallFunc:create(function()
          toMoveSmallWheel(smallWheel , direct)
      end))
      smallWheel:runAction(seq)
    end

    toMoveSmallWheel(self.smallWheel1 , 1)
    toMoveSmallWheel(self.smallWheel2 , -1)
    toMoveSmallWheel(self.smallWheel3 , 1)
    toMoveSmallWheel(self.smallWheel4 , -1)
end

-- 眼睛动
function TechnologyView:eyeRun()
    function toMoveEye()
      local runTime = 1+5*math.random()
      local fadeIn = cc.FadeIn:create(1) -- 渐入
      local fadeOut = cc.FadeOut:create(1) -- 渐入
      local delay = cc.DelayTime:create(runTime) -- 旋转
      local seq = cc.Sequence:create(fadeIn , delay ,fadeOut ,delay,cc.CallFunc:create(function()
          toMoveEye()
      end))
      self.eye:runAction(seq)
    end

    toMoveEye()

end

-- 转超级齿轮  time持续时间    circleNum 旋转圈数   direct旋转方向：1 顺时针  -1 逆时针
function TechnologyView:superWheelRun( time , circleNum ,direct )
  if self.superIsRuning ~=nil then
    return
  end
  self.superIsRuning = true
  local rotate = cc.RotateBy:create(time,direct*circleNum*360 ) -- 旋转
  local seq = cc.Speed:create(cc.Sequence:create(rotate , cc.CallFunc:create(function()
      self:smallWheelRun()
      self:eyeRun()
      -- self:runLightning()
      self:runLightning()
      self:addRainAndSnowEffert()
  end)) ,0.5)
  self.supperWheel:runAction(seq)
end

-- 清理
function TechnologyView:clear()
    self.smallWheel1:stopAllActions()
    self.smallWheel2:stopAllActions()
    self.smallWheel3:stopAllActions()
    self.smallWheel4:stopAllActions()
    self.eye:stopAllActions()
    self.supperWheel:stopAllActions()
    self.currentEffert = nil
    qy.tank.utils.cache.CachePoolUtil.removeArmatureFile("fx/".. qy.language .."/ui/technology/UI_fx_zhuangbeishengji")
end

function TechnologyView:getListByTemplateIndex(index)
    local param = {}
    param["template"] = index
    self.service:getList(param,function(data)
        data.index = index
        self.delegate.showDetail(data)
        if index == 1 then
          qy.GuideManager:nextTiggerGuide()
        end
    end)
end

 --更新所有科技信息
function TechnologyView:updataAllTech( isExit)
   --  self.service = qy.tank.service.TechnologyService
   -- local param = {}
   --  param["template"] = 0
   --  self.service:getList(param,function(data)
   --      --更新所有科技信息
   --      -- self.model:updateTechnologyList(data)
   --  end , isExit
   --  )
end

function TechnologyView:onEnter()
    self:updataAllTech()
     qy.RedDotCommand:addSignal({
          [qy.RedDotType.TECH_TEMP_1] = self.nameBg_open1,
          [qy.RedDotType.TECH_TEMP_2] = self.nameBg_open2,
          [qy.RedDotType.TECH_TEMP_3] = self.nameBg_open3,
          [qy.RedDotType.TECH_TEMP_4] = self.nameBg_open4,
     })
     qy.RedDotCommand:updateTechTemplateRedDot()

     qy.Event.dispatch(qy.Event.SERVICE_LOADING_HIDE)
     if self.isInit~=nil and self.isInit == true then
        -- self:init()
     end

    --触发式引导
    print("=========TechnologyView======================addTriggerUiRegister===================")
    qy.GuideCommand:addTriggerUiRegister({
        {["ui"] = self.middleWheel_none1, ["step"] = {"T_TE_4"}}
    })
end

function TechnologyView:onExit()
   self:updataAllTech(true)
   qy.RedDotCommand:removeSignal({
        qy.RedDotType.TECH_TEMP_1,qy.RedDotType.TECH_TEMP_2,qy.RedDotType.TECH_TEMP_3,qy.RedDotType.TECH_TEMP_4,
    })

    --触发式引导
    qy.GuideCommand:removeTriggerUiRegister({"T_TE_4"})
end
return TechnologyView
