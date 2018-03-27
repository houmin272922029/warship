--[[
	群战-战斗列表-人员
	Author: H.X.Sun
]]

local NameCell = qy.class("NameCell", qy.tank.view.BaseView, "war_group/ui/NameCell")

local userModel = qy.tank.model.UserInfoModel

function NameCell:ctor(params)
    NameCell.super.ctor(self)
    self:InjectView("name_txt")
    self:InjectView("cell_bg")
    self:InjectView("lv_txt")
end

function NameCell:render(data,_idx)
    if _idx % 2 == 0 then
        self.cell_bg:setVisible(true)
    else
        self.cell_bg:setVisible(false)
    end
    self.name_txt:setString(data.name)
    self.lv_txt:setString("Lv."..data.level)
    if userModel.userInfoEntity.kid == data.kid then
        self.name_txt:setTextColor(cc.c4b(2, 204, 253, 255))
    else
        self.name_txt:setTextColor(cc.c4b(255, 255, 255, 255))
    end
end

return NameCell
