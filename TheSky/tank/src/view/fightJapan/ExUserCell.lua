--[[
	远征人物 cell
	Author: H.X.Sun
	Date: 2015-09-09
--]]
local ExUserCell = qy.class("ExChestCell", qy.tank.view.BaseView, "view/fightJapan/ExUserCell")

function ExUserCell:ctor(delegate)
	self:InjectView("lvTxt")
    self:InjectView("nameTxt")
    self:InjectView("idxTxt")
    self:InjectView("roleIcon")

    local data = delegate.data

    self.roleIcon:loadTexture(qy.tank.utils.UserResUtil.getRoleIconByHeadType(data.head_img))
    self.nameTxt:setString(data.nickname)
    self.lvTxt:setString("LV. "..data.level)
    self.idxTxt:setString("("..data.index.."/"..qy.tank.model.FightJapanModel:getTotalEnemyNum()..")")
end


return ExUserCell