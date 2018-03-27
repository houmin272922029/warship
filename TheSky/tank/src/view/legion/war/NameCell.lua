--[[
	报名列表的cell
	Author: H.X.Sun
]]

local NameCell = qy.class("NameCell", qy.tank.view.BaseView, "legion_war/ui/NameCell")

function NameCell:ctor(params)
    NameCell.super.ctor(self)
    self:InjectView("name_txt")
    self:InjectView("cell_bg")
    self:InjectView("angle_sp")
    self.model = qy.tank.model.LegionWarModel
    local w_entity = self.model:getLegionWarInfoEntity()
    if w_entity:getGameAction() ~= self.model.ACTION_SIGN or w_entity:getGameStage() == self.model.STAGE_FINAL then
        self.angleVisible = false
        self.name_txt:setAnchorPoint(0.5,0.5)
        self.name_txt:setPosition(155,24)
    else
        print("self.model =====>>>>>")
        self.angleVisible = true
        self.name_txt:setAnchorPoint(0,0.5)
        self.name_txt:setPosition(24,24)
    end
end

function NameCell:render(_idx)
    if _idx % 2 == 0 then
        self.cell_bg:setVisible(true)
    else
        self.cell_bg:setVisible(false)
    end
    local entity = self.model:getMemberByIdx(_idx)
    self.angle_sp:setVisible(self.angleVisible and entity:hasSignUp())
    self.name_txt:setString(entity.name)
end

return NameCell
