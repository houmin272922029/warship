--[[
--坦克信息 cell
--Author: H.X.Sun
--Date:
]]
local TankInfoCell = qy.class("TankInfoCell", qy.tank.view.BaseView, "view/training/TankInfoCell")

function TankInfoCell:ctor()
    TankInfoCell.super.ctor(self)

    self:InjectView("bgQuality")--品质框
    self:InjectView("tankLevel")--战车等级
    self:InjectView("tankImage")--战车精灵
    self:InjectView("tankName")--战车名字
    self:InjectView("lightSprite")--发光背景
    self:InjectView("trainStatus")
    self:InjectView("battleSprite")
    self:InjectView("reform_num")
    self:InjectView("reform_bg")
    self.lightSprite:setVisible(false)
end

--[[--
--刷新信息
--@param #table entity 战车实体
--]]
function TankInfoCell:render(entity)
    if entity then
        self.entity = entity
        self.tankName:setString(entity.name)
        self.tankName:setTextColor(entity:getFontColor())
        self.tankLevel:setString("LV : "..entity.level)
        self.bgQuality:setTexture(entity:getIconBg())
        self.tankImage:loadTexture(entity:getIcon())
        if entity:getToBattle() then
            self.battleSprite:setVisible(true)
        else
            self.battleSprite:setVisible(false)
        end

        if entity.is_train == 1 then
            self.trainStatus:setVisible(true)
            local trainArea = qy.tank.model.TrainingModel:getTrainAreaByIdx(entity.train_pos)
            if trainArea:getRemainTime() > 0 then
                self.trainStatus:setSpriteFrame("Resources/training/XL_25.png")
            else
                self.trainStatus:setSpriteFrame("Resources/training/XL_40.png")
            end
        else
            self.trainStatus:setVisible(false)
        end

        if qy.InternationalUtil:hasTankReform() then
            if entity.reform_stage == 0 then
                self.reform_bg:setVisible(false)
            else
                self.reform_bg:setVisible(true)
                self.reform_num:setString(entity.reform_stage)
            end
        end
    end
end

--选中效果
function TankInfoCell:setSelected()
    self.lightSprite:setVisible(true)
end

--去掉选中效果
function TankInfoCell:removeSelected()
    self.lightSprite:setVisible(false)
end

return TankInfoCell
