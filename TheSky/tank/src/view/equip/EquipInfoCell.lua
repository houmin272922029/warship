--[[
    装备详情 cell
    Author: H.X.Sun
    Date: 2015-04-18
]]

local EquipInfoCell = qy.class("EquipInfoCell", qy.tank.view.BaseView, "view/equip/EquipInfoCell")

function EquipInfoCell:ctor(delegate)
    EquipInfoCell.super.ctor(self)
    self.delegate = delegate

    self.model = qy.tank.model.EquipModel
    self:InjectView("lightSprite")
    self:InjectView("equipBg")
    self:InjectView("equipIcon")
    self:InjectView("equipName")
    self:InjectView("level")
    self:InjectView("tankName")
    self:InjectView("mark")
    self:InjectView("desc")
    self:InjectView("expand")
    self:InjectView("bg")
    self:InjectView("img_expand")
    self:InjectView("icon_hd")
    self:InjectView("icon_hd_advance")

end

--[[--
--刷新
    @param #table entity 装备实体
    @param #number nCurIdx 当前的index
--]]
function EquipInfoCell:render(entity, selectEquipIdx, idx, reform_callback, advance_callback,clear_callback)
    if entity ~= nil then
        self.entity = entity
        self.reform_callback = reform_callback
        self.advance_callback = advance_callback
        self.clear_callback = clear_callback
        self.equipBg:setSpriteFrame(entity:getIconBg())
        local markUrl = entity:getMark()
        if markUrl then
            self.mark:setSpriteFrame(entity:getMark())
            self.mark:setVisible(true)
        else
            self.mark:setVisible(false)
        end
        self.equipIcon:setTexture(entity:getIcon())
        self.equipName:setString(entity:getName())
        self.equipName:setTextColor(qy.tank.utils.ColorMapUtil.qualityMapColor(entity:getQuality()))
        self.level:setString(entity.level)
        if entity.unique_id == -1 then
            self.desc:setVisible(true)
            self.tankName:setVisible(true)
            self.desc:setString(qy.TextUtil:substitute(9001))
            local composeNum = qy.tank.model.EquipModel:getEquipComposeNum(entity:getQuality() .. "")
            self.tankName:setString("" .. entity.num .. " / " ..  composeNum)
            self.tankName:setTextColor(qy.tank.utils.ColorMapUtil.qualityMapColor(entity:getQuality()))
        elseif entity:getTankName() == nil then
            self.desc:setVisible(false)
            self.tankName:setVisible(false)
        else
            self.desc:setVisible(true)
            self.tankName:setVisible(true)
            self.tankName:setTextColor(qy.tank.utils.ColorMapUtil.qualityMapColor(entity:getTankQuality()))
            self.tankName:setString(entity:getTankName())
            self.desc:setString(qy.TextUtil:substitute(9002))
        end
        self.tankName:setPosition(self.desc:getPositionX() + self.desc:getContentSize().width, self.desc:getPositionY())
        self:showRedDot()
    end
    self.bg:setPositionY(0)


    self:OnClick("Button_reform", function(sender)
        if qy.tank.model.UserInfoModel.userInfoEntity.level >= self.model:getEquipReformOpenLevel() then
            if selectEquipIdx == idx then
                reform_callback(self)
            end
        else
            qy.hint:show(qy.TextUtil:substitute(90273, self.model:getEquipReformOpenLevel()))
        end
    end,{["isScale"] = false})


    self:OnClick("Button_advanced", function(sender)
        if entity and entity:getQuality() > 4 then
            if qy.tank.model.UserInfoModel.userInfoEntity.level >= self.model:getEquipClearOpenLevel() then
                if selectEquipIdx == idx then
                    advance_callback(self)
                end
            else
                qy.hint:show(qy.TextUtil:substitute(90284, self.model:getEquipClearOpenLevel()))
            end
        else
            qy.hint:show(qy.TextUtil:substitute(90277))
        end
    end,{["isScale"] = false})
    self:OnClick("Button_clear", function(sender)
        if entity and entity:getQuality() > 5 then
            if qy.tank.model.UserInfoModel.userInfoEntity.level >= self.model:getEquipClearOpenLevel() then
                if selectEquipIdx == idx then
                    clear_callback(self)
                end
            else
                qy.hint:show(qy.TextUtil:substitute(90325, self.model:getEquipClearOpenLevel()))
            end
        else
            qy.hint:show(qy.TextUtil:substitute(90326))
        end
    end,{["isScale"] = false})

    if reform_callback and advance_callback and clear_callback then
        self.img_expand:setVisible(true)
        self:updateReformAndAdvanceRedDot()
    else
        self.img_expand:setVisible(false)
    end
end

--[[--
--显示红点
--]]
function EquipInfoCell:showRedDot()
    if self.dot == nil then
        self.dot = qy.tank.view.common.RedDot.new({})
        self.equipBg:addChild(self.dot)
        self.dot:setPosition(100, 100)
    end

    if self.delegate.type and self.delegate.type ~= "total" and self.entity.tank_unique_id ~= qy.tank.model.EquipModel:getFirstEquipTankUid() then
        self.dot:setVisible(false)
    elseif self.entity.unique_id > 0 then
        self.dot:update(self.entity:getNew())
        if self.entity:hasRedDot() or self.entity:reformHasDot() or self.entity:advanceHasDot() then
            self.dot:setVisible(true)
        else
            self.dot:setVisible(false)
        end
    else
        self.dot:setVisible(false)
    end
end


function EquipInfoCell:updateReformAndAdvanceRedDot()
    if not self.entity then
        return 
    end

    if self.model:reformCanUp(self.entity) and qy.tank.model.UserInfoModel.userInfoEntity.level >= self.model:getEquipReformOpenLevel() then
        self.icon_hd:setVisible(true)
    else
        self.icon_hd:setVisible(false)
    end

    if self.model:testCanAdvance(self.entity) == 3 and qy.tank.model.UserInfoModel.userInfoEntity.level >= self.model:getEquipAdvanceOpenLevel() then
        self.icon_hd_advance:setVisible(true)
    else
        self.icon_hd_advance:setVisible(false)
    end
end

--[[--
--选中
--]]
function EquipInfoCell:setSelected(_isOpenStatus)
    self.lightSprite:setVisible(true)

    if _isOpenStatus then
        self:openExpand()
    else
        self:closeExpand()
    end
end

--[[--
--不选中
--]]
function EquipInfoCell:removeSelected()
    self.lightSprite:setVisible(false)
    self:closeExpand()
end

function EquipInfoCell:openExpand()
    if self.entity.tank_unique_id > 0 and self.reform_callback and self.advance_callback and self.clear_callback then
        self.expand:runAction(cc.ScaleTo:create(0.12, 1))
        self.img_expand:setRotation(180)
        self.bg:setPositionY(75)
    end    
end


function EquipInfoCell:closeExpand(callback)
    if self.entity.tank_unique_id > 0 and self.reform_callback and self.advance_callback and self.clear_callback then
        self.img_expand:setRotation(0)
        self.expand:runAction(cc.Sequence:create(cc.ScaleTo:create(0.12, 1, 0), cc.CallFunc:create(function()
            if callback then
                self.bg:setPositionY(0)
                callback()
            end
        end)))    
    else
        self.expand:setScale(1, 0)
    end
end



function EquipInfoCell:onExit()
    if self.entity:getNew() then
        self.entity:updateNew()
        qy.tank.model.RedDotModel:changeEquipRedDot()
    end
end

return EquipInfoCell
