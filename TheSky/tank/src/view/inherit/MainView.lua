local MainView = qy.class("MainView", qy.tank.view.BaseView, "view/inherit/MainView")

local model = qy.tank.model.AdvanceModel
-- require("advance.src.AdvanceModel")
-- model:init()

function MainView:ctor(delegate)
   	MainView.super.ctor(self)

    self.service = qy.tank.service.InheritService

    self:InjectView("bg")
   	self:InjectView("TankBg1")
   	self:InjectView("TankBg2")
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
    self:InjectView("jiahao")
    self:InjectView("Node_2")
    self:InjectView("Sprite1")


   	self:OnClick("Btn_go", function()
      if self.entity2 then
        qy.alert:show({"提示", {255,255,255}}, "是否进行花费2000钻石进行坦克置换", cc.size(450 , 260), {{qy.TextUtil:substitute(46006), 4}, {qy.TextUtil:substitute(46007) , 5}}, function(flag)
          if flag == qy.TextUtil:substitute(46007) then
            self.service:go(function()
              qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync("fx/".. qy.language .."/ui/ui_fx_jiaohuan",function()
                local effect = ccs.Armature:create("ui_fx_jiaohuan")
                effect:setScale(1.3)
                self.Sprite1:addChild(effect, 1)
                effect:setPosition(-380, 230)
                effect:getAnimation():playWithIndex(0)

                effect:runAction(cc.Sequence:create(cc.DelayTime:create(1.5), cc.CallFunc:create(function()
                  self.Sprite1:removeChild(effect)
                    
                  self._entity = clone(self.entity)
                  self._entity2 = clone(self.entity2)           

                  self.entity2.level = self._entity.level
                  self.entity2.advance_level = self._entity.advance_level
                  self.entity2.reform_stage = self._entity.reform_stage
                  self.entity2.quality = self._entity.quality

                  self.entity.level = self._entity2.level
                  self.entity.advance_level = self._entity2.advance_level
                  self.entity.reform_stage = self._entity2.reform_stage
                  self.entity.quality = self._entity2.quality

                  if self.entity.advance_level < 6 and self._entity.advance_level >= 6 and self.entity.last_tank_id ~= "" then
                    print("MainView---1",self.entity.last_tank_id)
                    self.entity.tank_id = tonumber(self.entity.last_tank_id)
                  end

                  if self.entity.advance_level >= 6 and self._entity.advance_level < 6 and self.entity.last_tank_id == "" and self.entity.ids then
                    print("MainView---2",self.entity.ids)

                    local strArr = qy.tank.utils.String.split(self.entity.ids ,"|")
                    if #self.entity.ids > 5 then
                      self.entity.tank_id = tonumber(strArr[1])
                    else
                      self.entity.tank_id = tonumber(self.entity.ids)
                    end
                  end

                  if self.entity2.advance_level < 6 and self._entity2.advance_level >= 6 and self.entity2.last_tank_id ~= "" then
                    print("MainView---3",self.entity2.last_tank_id)
                    self.entity2.tank_id = tonumber(self.entity2.last_tank_id)
                  end

                  if self.entity2.advance_level >= 6 and self._entity2.advance_level < 6 and self.entity2.last_tank_id == "" and self.entity2.ids then
                    print("MainView---4",self.entity2.ids)
                    local strArr = qy.tank.utils.String.split(self.entity2.ids ,"|")
                    if #self.entity2.ids > 5 then
                      self.entity2.tank_id = tonumber(strArr[1])
                    else
                      self.entity2.tank_id = tonumber(self.entity2.ids)
                    end
                    --self.entity2.tank_id = tonumber(self.entity2.ids)
                  end

                  self:update()
                end)))
              end)
            end, self.entity.unique_id, self.entity2.unique_id)
          end
        end,"")  
      else
        qy.hint:show("没有可置换的战车")
      end
    end,{["isScale"] = false})

    self:OnClick("Btn_preview", function()
      if self.entity2 then
        require("view.inherit.PreviewDialog").new(self):show()
      else
        qy.hint:show("没有可置换的战车")
      end
    end,{["isScale"] = false})


   	self:addChild(qy.tank.view.style.ViewStyle1.new({
        ["onExit"] = function()
            delegate.dismiss()
        end,
        showHome = false,
        ["titleUrl"] = "Resources/inherit/inherit.png",

    }))

    self:OnClick("Btn_add", function()
      require("view.inherit.TankSelectDialog").new(self):show()
    end,{["isScale"] = false})

    self:OnClick("Btn_help", function()
        qy.tank.view.common.HelpDialog.new(qy.tank.model.HelpTxtModel:getHelpDataByIndx(43)):show(true)
    end)
   
   	self.entity = clone(delegate.entity)
    self.entity2 = nil
   	
    self:update()
end

function MainView:initTank1()
  print(self.entity.reform_stage)
    if self.tank1 then
      self.TankBg1:removeChild(self.tank1)
    end
    self.tank1 =  qy.tank.view.garage.GarageTankCell.new(self.entity)
   	self.tank1:setPosition(35, 170)
   	self.TankBg1:addChild(self.tank1)

   	self:updateTank1()
end

function MainView:initTank2()
  print(self.entity2.reform_stage)
    if self.tank2 then
      self.TankBg2:removeChild(self.tank2)
    end
  	self.tank2 =  qy.tank.view.garage.GarageTankCell.new(self.entity2)
  	self.tank2:setPosition(35, 170)
  	self.TankBg2:addChild(self.tank2)

    self:updateTank2()    
end

function MainView:updateTank1()
    local data1 = qy.tank.view.common.AwardItem.getItemData({
      ["type"] = 11,
      ["tank_id"] = self.entity.tank_id,
    })
    data1.notPic = 1
    data1.advanceStatus = false
    self.Defense1:setString(qy.TextUtil:substitute(40033) .. data1.entity:getInitialDefense())
    self.Blood1:setString(qy.TextUtil:substitute(40034) .. data1.entity:getInitialBlood())
    self.Atack1:setString(qy.TextUtil:substitute(40035) .. data1.entity:getInitialAttack())

    -- 普通属性
    local data2 = model:atCommonAttr(self.entity.advance_level)

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

end


function MainView:updateTank2()
    local data1 = qy.tank.view.common.AwardItem.getItemData({
      ["type"] = 11,
      ["tank_id"] = self.entity2.tank_id,
    })
    data1.notPic = 1
    data1.advanceStatus = false
    self.Defense2:setString(qy.TextUtil:substitute(40033) .. data1.entity:getInitialDefense())
    self.Blood2:setString(qy.TextUtil:substitute(40034) .. data1.entity:getInitialBlood())
    self.Atack2:setString(qy.TextUtil:substitute(40035) .. data1.entity:getInitialAttack())

    -- 普通属性
    local data2 = model:atCommonAttr(self.entity2.advance_level)
    
    local level = self.entity2.advance_level > 0 and self.entity2.advance_level or qy.TextUtil:substitute(40031)
    self.Advance2:setString(qy.TextUtil:substitute(40037) .. level)

    if data2 then
        self.AtackAdd2:setString("+" .. data2.attack_plus)
        self.DefenseAdd2:setString("+" .. data2.defense_plus)
        self.BloodAdd2:setString("+" .. data2.blood_plus)

        self.AtackAdd2:setPositionX(self.Atack2:getPositionX() + self.Atack2:getContentSize().width)
        self.DefenseAdd2:setPositionX(self.Defense2:getPositionX() + self.Defense2:getContentSize().width)
        self.BloodAdd2:setPositionX(self.Blood2:getPositionX() + self.Blood2:getContentSize().width)
    else
        self.AtackAdd2:setString("")
        self.DefenseAdd2:setString("")
        self.BloodAdd2:setString("")
    end

end


function MainView:set(entity)
  self.entity2 = clone(entity)
  self:update()
end


function MainView:update()
    self:initTank1()
    if self.entity2 then
      self.jiahao:setVisible(false)
      self.Node_2:setVisible(true)
      self:initTank2()
    else
      self.jiahao:setVisible(true)
      self.Node_2:setVisible(false)
    end
end



return MainView
