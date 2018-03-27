local MainView = qy.class("MainView", qy.tank.view.BaseView, "advance.ui.MainView")

local model = qy.tank.model.AdvanceModel
local service = require("advance.src.AdvanceService")
-- require("advance.src.AdvanceModel")
-- model:init()

function MainView:ctor(delegate)
   	MainView.super.ctor(self)

   	self:InjectView("TankBg1")
   	self:InjectView("TankBg2")
   	self:InjectView("star1_1")
   	self:InjectView("star1_2")
   	self:InjectView("star1_3")
   	self:InjectView("star1_4")
   	self:InjectView("star1_5")
   	self:InjectView("star1_6")
    self:InjectView("star1_7")
   	self:InjectView("star2_1")
   	self:InjectView("star2_2")
   	self:InjectView("star2_3")
   	self:InjectView("star2_4")
   	self:InjectView("star2_5")
   	self:InjectView("star2_6")
    self:InjectView("star2_7")
   	self:InjectView("Advance1")
   	self:InjectView("Atack1")
   	self:InjectView("Defense1")
   	self:InjectView("Blood1")
   	self:InjectView("AtackAdd1")
   	self:InjectView("DefenseAdd1")
   	self:InjectView("BloodAdd1")
    self:InjectView("AtackAdd2")
    self:InjectView("DefenseAdd2")
    self:InjectView("BloodAdd2")
   	self:InjectView("Atack2")
   	self:InjectView("Defense2")
   	self:InjectView("Blood2")
   	self:InjectView("Advance2")
   	self:InjectView("needLevel2")
    self:InjectView("needLevel")
   	self:InjectView("AwardBg")
    self:InjectView("Image_1")
    self:InjectView("Info2")
    self:InjectView("Btn_check") 	
   	self:InjectView("Max")
    self:InjectView("Text_1_0")
    self:InjectView("starNode2")
    self:InjectView("Image_16_0")
    self:InjectView("ResourceNum")
    -- self:InjectView("fight_4")
    -- self:InjectView("fight_4")
    -- self:InjectView("fight_4")
    -- self:InjectView("fight_4")

   	-- self:InjectView("Blood2")
    self.Btn_check:setVisible(false)
    self.fightList = {}

   	self:OnClick("Btn_check", function()
        qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.ADVANCE, {["entity"] = self.entity, ["isTips"] = true})
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})

   	self:OnClick("Btn_advance", function()
        --qy.QYPlaySound.stopMusic()
        local oldTankId = self.entity.tank_id
        service:doAdvance(self.entity, function()
            qy.QYPlaySound.playEffect(qy.SoundType.TANK_UPGRADE)
            self:updateTank1()
            self:updateTank2()
            self:updateSpecail()
            self.tank2:playAvanceAnimate()

            if model:testAddStar(self.entity) then
                if not self.effect then
                  qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsyncByModules("advance/fx/ui_fx_jinjie1", function()
                      self.effect = ccs.Armature:create("ui_fx_jinjie1") 
                      -- self.TankBg1:addChild(self.effect,999)
                      self.effect:setAnchorPoint(0.5,0.5)
                      self:addChild(self.effect)
                      -- self.effect:setLocalZOrder(100)
                      local position = self.TankBg1:getParent():convertToWorldSpace(cc.p(self.TankBg1:getPositionX(),self.TankBg1:getPositionY()))
                      self.effect:setPosition(position.x - 80, position.y)
                      -- self.effect:setLocalZOrder(5)
                      self.effect:getAnimation():playWithIndex(0, 1, 0)
                  end)
                else
                  self.effect:getAnimation():playWithIndex(0, 1, 0)
                end
                qy.hint:show(qy.TextUtil:substitute(40032))   
            else
                local view = require("advance.src.AdvanceStarView").new(delegate, oldTankId)
                delegate.viewStack:push(view)
            end
        end)
       -- local view = require("advance.src.AdvanceStarView").new(delegate)
       --  delegate.viewStack:push(view)
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})

   	self:addChild(qy.tank.view.style.ViewStyle1.new({
        ["onExit"] = function()
            delegate.viewStack:pop()
        end,
        ["titleUrl"] = "Resources/common/title/zhanchejinjie.png",
        ["showHome"] = true,

    }))
   
    self.freeSource = {}
   	self.entity = delegate.entity
   	self:initTank()
end

-- 添加tank
function MainView:initTank()
  	self:initTank1()
    self:initTank2()
    if model:testMax(self.entity) then
        self:setMax()
    else
        self:addAnimate()
    end
    self:updateSpecail()
end

function MainView:initTank1()
    self.tank1 =  qy.tank.view.common.TankItem3.new()
   	self.tank1:setPosition(35, 145)
   	self.TankBg1:addChild(self.tank1)
   	self:updateTank1()
end

function MainView:initTank2()
  	self.tank2 =  qy.tank.view.common.TankItem3.new()
  	self.tank2:setPosition(35, 145)
  	self.TankBg2:addChild(self.tank2)
    -- if self.entity.advance_level + 1 == 5 and data.type == 9 then
    self:updateTank2()
    
end

-- 进阶前展示
function MainView:updateTank1()
    local data1 = qy.tank.view.common.AwardItem.getItemData({
      ["type"] = 11,
      ["tank_id"] = self.entity.tank_id,
    })
    data1.notPic = 1
    data1.advanceStatus = false
    self.tank1:setData(data1)
    self.Defense1:setString(qy.TextUtil:substitute(40033) .. data1.entity:getInitialDefense())
    self.Blood1:setString(qy.TextUtil:substitute(40034) .. data1.entity:getInitialBlood())
    self.Atack1:setString(qy.TextUtil:substitute(40035) .. data1.entity:getInitialAttack())

    for i = 1, 7 do
      self["star1_" .. i]:setVisible(false)
    end

    for i = 1, self.entity.star do
      self["star1_" .. i]:setVisible(true)
    end
    -- 普通属性
    local data2 = model:atCommonAttr(self.entity.advance_level)
    local data = model:atCommonAttr(self.entity.advance_level + 1)
    local data3 = model:atGrowUp(self.entity)
    
    local level = self.entity.advance_level > 0 and self.entity.advance_level or qy.TextUtil:substitute(40031)
    self.Advance1:setString(qy.TextUtil:substitute(40037) .. level)

    if data2 then
        self.AtackAdd1:setString("+" .. data2.attack_plus)
        self.DefenseAdd1:setString("+" .. data2.defense_plus)
        self.BloodAdd1:setString("+" .. data2.blood_plus)

        self.AtackAdd1:setPositionX(self.Atack1:getPositionX() + self.Atack1:getContentSize().width)
        self.DefenseAdd1:setPositionX(self.Defense1:getPositionX() + self.Defense1:getContentSize().width)
        self.BloodAdd1:setPositionX(self.Blood1:getPositionX() + self.Blood1:getContentSize().width)
    else
        self.AtackAdd1:setString("")
        self.DefenseAdd1:setString("")
        self.BloodAdd1:setString("")
    end

    self:showFreeSource(data, data3)
end

-- 特殊属性展示
function MainView:updateSpecail()
    -- 特殊属性
    local data = model:atSpecailAttr(self.entity)
    local level = self.entity.advance_level + 1 > model:getMaxLevel(self.entity) and model:getMaxLevel(self.entity) or self.entity.advance_level + 1      
    if data.type and data.name ~= "" then
      local value = (data.type == 8 or data.type == 12 or data.type == 13 or data.type == 14 or data.type == 15 or data.type == 6 or data.type == 7 or data.type == 11) and data.param / 10 .. "%" or data.param
      if data.type ~= 9 then
          -- if data.name and (data.type > 0 and model.attrTypes[tostring(data.type)]) then
          --   self.Info2:setString(qy.TextUtil:substitute(40038) .. level .." ".. qy.TextUtil:substitute(40039) .. data.name .. "】" .. model.attrTypes[tostring(data.type)] .. "+" .. value)
          -- end
          local text = qy.TextUtil:substitute(40038) .. level .." ".. qy.TextUtil:substitute(40039) .. data.name .. "】"
          if data.type > 0 and model.attrTypes[tostring(data.type)] then
              text = text.. model.attrTypes[tostring(data.type)] .. "+" .. value
          end
          self.Info2:setString(text)
          self.Btn_check:setVisible(false)
      else
          self.Info2:setString(qy.TextUtil:substitute(40038) .. level .." ".. qy.TextUtil:substitute(40039) .. data.name .. qy.TextUtil:substitute(40040))
          if self.entity.is_tujian == 1 then
              self.Btn_check:setVisible(true)
          end
      end
      -- self.Info2:setString("(进阶+" .. level .. "解锁)")
      -- self.Info2:setPositionX(460 + self.Info1:getContentSize().width + 20)
    elseif data.name and data.name ~= "" then
      self.Info2:setString(qy.TextUtil:substitute(40038) .. level .." ".. qy.TextUtil:substitute(40039) .. data.name.. "】")
    elseif data.desc and data.desc ~= "" then
      self.Info2:setString(qy.TextUtil:substitute(40038) .. level .." ".. qy.TextUtil:substitute(40039) .. data.desc.. "】")
    end
    if model:testMax(self.entity) then
        self.Info2:setString("")
        -- self.Info1:setString("")
    end

    self.ResourceNum:setString(qy.tank.model.UserInfoModel.userInfoEntity.advanceMaterial)
end

-- 进阶后坦克展示
function MainView:updateTank2()
    local data = model:atSpecailAttr(self.entity)
    local data2 = {}
    if data.type == 9 then
        data2 = qy.tank.view.common.AwardItem.getItemData({
          ["type"] = 11,
          ["tank_id"] = data.param,
        })
        data2.notPic = 1
        data2.advanceStatus = false

        self.tank2:setData(data2)
        -- local temp_entity = qy.tank.entity.TankEntity.new(data.param, false)

        self.Defense2:setString(qy.TextUtil:substitute(40033) .. data2.entity:getInitialDefense())
        self.Blood2:setString(qy.TextUtil:substitute(40034) .. data2.entity:getInitialBlood())
        self.Atack2:setString(qy.TextUtil:substitute(40035) .. data2.entity:getInitialAttack())
    else
        data2 = qy.tank.view.common.AwardItem.getItemData({
          ["type"] = 11,
          ["tank_id"] = self.entity.tank_id,
        })

        data2.notPic = 1
        data2.advanceStatus = false
        self.tank2:setData(data2)
        self.Defense2:setString(qy.TextUtil:substitute(40033) .. data2.entity:getInitialDefense())
        self.Blood2:setString(qy.TextUtil:substitute(40034) .. data2.entity:getInitialBlood())
        self.Atack2:setString(qy.TextUtil:substitute(40035) .. data2.entity:getInitialAttack())
    end

    for i = 1, 7 do
      self["star2_" .. i]:setVisible(false)
    end

    for i = 1, data2.entity.star do
      self["star2_" .. i]:setVisible(true)
    end

    local data = model:atCommonAttr(self.entity.advance_level + 1)
    -- local data2 = model:atCommonAttr(self.entity.advance_level + 2)
    local color = data.tank_level > self.entity.level and cc.c4b(251, 48, 0,255) or cc.c4b(46, 190, 83, 255)
    self.needLevel:setString(data.tank_level)
    self.needLevel:setColor(color)

    local level = self.entity.advance_level + 1 > model:getMaxLevel(self.entity) and model:getMaxLevel(self.entity) or self.entity.advance_level + 1

    self.Advance2:setString(qy.TextUtil:substitute(40037) .. level)

    if data then
        self.AtackAdd2:setString("+" .. data.attack_plus)
        self.DefenseAdd2:setString("+" .. data.defense_plus)
        self.BloodAdd2:setString("+" .. data.blood_plus)

        self.AtackAdd2:setPositionX(self.Atack2:getPositionX() + self.Atack2:getContentSize().width)
        self.DefenseAdd2:setPositionX(self.Defense2:getPositionX() + self.Defense2:getContentSize().width)
        self.BloodAdd2:setPositionX(self.Blood2:getPositionX() + self.Blood2:getContentSize().width)
    else
        self.AtackAdd2:setString("")
        self.DefenseAdd2:setString("")
        self.BloodAdd2:setString("")
    end

    if model:testMax(self.entity) then
        self:setMax()
    end
end

-- 花费
function MainView:showFreeSource(data, data2)
    for i, v in pairs(self.freeSource) do
        v:removeSelf()
    end

  	self.freeSource = {}
    local y = 56
    
    local num = 0

    if data.silver > 0 then
        num = num + 1
    end

    if data.advance_material > 0 then
        num = num + 1
    end

    if data.purple_iron > 0  and data2.type == 7 then
        num = num + 1
    end

    if data.orange_iron > 0 and data2.type == 8 then
        num = num + 1
    end

    if data.reputation > 0 and data2.type2 == 28 then
        num = num + 1
    end

    local x = num == 2 and 235 or num == 3 and 165 or 95

  	if data.silver > 0 then
  		local item = qy.tank.view.common.AwardItem.createAwardView({
  				["type"] = 3,
  				["num"] = data.silver,
  				["id"] = 0,
  			}, 1)
  		item:setPosition(x, y)
      item.name:setVisible(false)
      local color = data.silver > qy.tank.model.UserInfoModel.userInfoEntity.silver and cc.c4b(251, 48, 0,255) or cc.c4b(255, 255, 255, 255)
      item.num:setTextColor(color)
  		self.AwardBg:addChild(item)
  		table.insert(self.freeSource, item)
  	end

  	if data.purple_iron > 0 and data2.type == 7 then
  		local item = qy.tank.view.common.AwardItem.createAwardView({
  				["type"] = 7,
  				["num"] = data.purple_iron,
  				["id"] = 0,
  			}, 1)
      local color = data.purple_iron > qy.tank.model.UserInfoModel.userInfoEntity.purpleIron and cc.c4b(251, 48, 0,255) or cc.c4b(255, 255, 255, 255)
      item.num:setTextColor(color)
  		item:setPosition(#self.freeSource * 140 + x, y)
      item.name:setVisible(false)
  		self.AwardBg:addChild(item)
  		table.insert(self.freeSource, item)
  	end

  	if data.orange_iron > 0 and data2.type == 8 then
  		local item = qy.tank.view.common.AwardItem.createAwardView({
  				["type"] = 8,
  				["num"] = data.orange_iron,
  				["id"] = 0,
  			}, 1)
      local color = data.orange_iron > qy.tank.model.UserInfoModel.userInfoEntity.orangeIron and cc.c4b(251, 48, 0,255) or cc.c4b(255, 255, 255, 255)
      item.num:setTextColor(color)
  		item:setPosition(#self.freeSource * 140 + x, y)
      item.name:setVisible(false)
  		self.AwardBg:addChild(item)
  		table.insert(self.freeSource, item)
  	end

	if data.advance_material > 0 then
		local item = qy.tank.view.common.AwardItem.createAwardView({
				["type"] = 20,
				["num"] = data.advance_material,
				["id"] = 0,
			}, 1)
		item:setPosition(#self.freeSource * 140 + x, y)
    local color = data.advance_material > qy.tank.model.UserInfoModel.userInfoEntity.advanceMaterial and cc.c4b(251, 48, 0,255) or cc.c4b(255, 255, 255, 255)
    item.num:setTextColor(color)
		self.AwardBg:addChild(item)
    item.name:setVisible(false)
		table.insert(self.freeSource, item)
	end


  if data.reputation > 0 then
    local item = qy.tank.view.common.AwardItem.createAwardView({
        ["type"] = 28,
        ["num"] = data.reputation,
        ["id"] = 0,
      }, 1)
    item:setPosition(#self.freeSource * 140 + x, y)
    local color = data.reputation > qy.tank.model.UserInfoModel.userInfoEntity.reputation and cc.c4b(251, 48, 0,255) or cc.c4b(255, 255, 255, 255)
    item.num:setTextColor(color)
    self.AwardBg:addChild(item)
    item.name:setVisible(false)
    table.insert(self.freeSource, item)
  end
end

function MainView:setMax()
  self.Max:setVisible(true)
  self.Text_1_0:setVisible(false)
  self.starNode2:setVisible(false)
  self.AtackAdd2:setVisible(false)
  self.DefenseAdd2:setVisible(false)
  self.Blood2:setVisible(false)
  self.Advance2:setVisible(false)
  self.needLevel2:setVisible(false)
  self.needLevel:setString("")
  self.Atack2:setVisible(false)
  self.Defense2:setVisible(false)
  self.BloodAdd2:setVisible(false)
  self.Image_1:setVisible(false)
  -- self.Image_1:setString("")
  self.Info2:setString("")

  for i, v in pairs(self.fightList) do
      if v then
          v:setVisible(false)
      end
  end
end

function MainView:addAnimate()
    local list = {
        ["1"] = {["x"] = 172.00, ["y"] = 105.50},
        ["2"] = {["x"] = 213.00, ["y"] = 77.50},
        ["3"] = {["x"] = 213.00, ["y"] = 51.50},
        ["4"] = {["x"] = 213.00, ["y"] = 22.50},
    }
    qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsyncByModules("advance/fx/ui_fx_jiantoutishi", function()
        for i = 1, 4 do
            local effect = ccs.Armature:create("ui_fx_jiantoutishi")
            self.Image_16_0:addChild(effect,999)
            effect:setAnchorPoint(0.5,0.5)
            effect:setPosition(list[tostring(i)].x ,list[tostring(i)].y)
            effect:getAnimation():playWithIndex(0, 1, 1)
            table.insert(self.fightList, effect)
        end
        -- self.effect = ccs.Armature:create("ui_fx_jiantoutishi") 
        -- self.TankBg1:addChild(self.effect,999)
        -- self.effect:setAnchorPoint(0.5,0.5)
        -- self.effect:setPosition(50 ,160)
        -- self.effect:getAnimation():playWithIndex(0, 1, 0)
    end)
end

function MainView:onExit()
    -- if self.effect then
    --     qy.tank.utils.cache.CachePoolUtil.removeArmatureFileByModules("fx/temp/ui_fx_jinjie1")
    --     self.effect:getParent():removeChild(self.effect, true)
    -- end
end

return MainView
