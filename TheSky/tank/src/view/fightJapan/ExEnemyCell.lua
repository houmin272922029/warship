--[[
	远征敌人 cell
	Author: H.X.Sun
	Date: 2015-09-09
--]]
local ExEnemyCell = qy.class("ExEnemyCell", qy.tank.view.BaseView, "view/fightJapan/ExEnemyCell")

function ExEnemyCell:ctor(delegate)
	self:InjectView("enemyName")
	self:InjectView("okSign")
	self:InjectView("enemyBtn")
	self.model = qy.tank.model.FightJapanModel

	self:OnClick("enemyBtn", function(sender)
		qy.tank.view.fightJapan.EnemyInfoDialog.new({
			["data"] = self.entity,
			["index"] = self.index,
		}):show(true)
	end)
end

function ExEnemyCell:refresh(idx)
	self.index = idx
	self.entity = self.model:getExpeEnemyDataByIdx(idx)
	self.enemyName:setString(self.entity.nickname)
	if self.entity.is_pass == 1 then
		self.okSign:setVisible(true)
	else
		self.okSign:setVisible(false)
	end

	if self.entity:getStatus() == 0 then
		self.enemyBtn:setEnabled(false)
        self.enemyBtn:setBright(false)
	else
		self.enemyBtn:setEnabled(true)
        self.enemyBtn:setBright(true)
	end
end

return ExEnemyCell