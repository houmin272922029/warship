local PreviewDialog = qy.class("PreviewDialog", qy.tank.view.BaseDialog, "view/inherit/PreviewDialog")

local model = qy.tank.model.AdvanceModel
-- require("advance.src.AdvanceModel")
-- model:init()

function PreviewDialog:ctor(delegate)
    PreviewDialog.super.ctor(self)

    self.service = qy.tank.service.InheritService

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


    local style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(701,455),
        position = cc.p(0,0),
        offset = cc.p(0,0),  
        bgShow = false,
        titleUrl = "Resources/inherit/333.png", 
        
        ["onClose"] = function()
            self:dismiss()
        end
    })
    self:addChild(style)
   
    self.entity = clone(delegate.entity)
    self.entity2 = clone(delegate.entity2)
    self._entity = clone(delegate.entity)
    self._entity2 = clone(delegate.entity2)
   

    self.entity2.level = self._entity.level
    self.entity2.advance_level = self._entity.advance_level
    self.entity2.reform_stage = self._entity.reform_stage
    self.entity2.quality = self._entity.quality

    self.entity.level = self._entity2.level
    self.entity.advance_level = self._entity2.advance_level
    self.entity.reform_stage = self._entity2.reform_stage
    self.entity.quality = self._entity2.quality

    if self.entity.advance_level < 6 and self._entity.advance_level >= 6 and self.entity.last_tank_id ~= "" then
      self.entity.tank_id = tonumber(self.entity.last_tank_id)
    end

    if self.entity.advance_level >= 6 and self._entity.advance_level < 6 and self.entity.last_tank_id == "" and self.entity.ids then
        local strArr = qy.tank.utils.String.split(self.entity.ids ,"|")
            if #self.entity.ids > 5 then
              self.entity.tank_id = tonumber(strArr[1])
            else
              self.entity.tank_id = tonumber(self.entity.ids)
            end
      --self.entity.tank_id = tonumber(self.entity.ids)
    end

    if self.entity2.advance_level < 6 and self._entity2.advance_level >= 6 and self.entity2.last_tank_id ~= "" then
      self.entity2.tank_id = tonumber(self.entity2.last_tank_id)
    end

    if self.entity2.advance_level >= 6 and self._entity2.advance_level < 6 and self.entity2.last_tank_id == "" and self.entity2.ids then
        local strArr = qy.tank.utils.String.split(self.entity2.ids ,"|")
        if #self.entity2.ids > 5 then
          self.entity2.tank_id = tonumber(strArr[1])
        else
          self.entity2.tank_id = tonumber(self.entity2.ids)
        end
      --self.entity2.tank_id = tonumber(self.entity2.ids)
    end

    self:initTank1()
    self:initTank2()
end

function PreviewDialog:initTank1()
    self.tank1 =  qy.tank.view.garage.GarageTankCell.new(self.entity)
    self.tank1:setPosition(35, 170)
    self.TankBg1:addChild(self.tank1)

    self:updateTank1()
end

function PreviewDialog:initTank2()
    self.tank2 =  qy.tank.view.garage.GarageTankCell.new(self.entity2)
    self.tank2:setPosition(35, 170)
    self.TankBg2:addChild(self.tank2)

    self:updateTank2()
end

function PreviewDialog:updateTank1()
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


function PreviewDialog:updateTank2()
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





return PreviewDialog
