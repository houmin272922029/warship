--[[
	远征宝箱 cell
	Author: H.X.Sun
	Date: 2015-09-09
--]]
local ExChestCell = qy.class("ExChestCell", qy.tank.view.BaseView, "view/fightJapan/ExChestCell")

function ExChestCell:ctor(delegate)
	self:InjectView("chestBtn")
	self:InjectView("light")

	self:OnClick("chestBtn", function(sender)
		if self.chestStatus == 0 then
			qy.tank.view.fightJapan.ChestInfoDialog1.new({["id"] = self.entity.id}):show(true)
		elseif self.chestStatus == 1 then
			--领奖
            qy.tank.service.FightJapanService:getAwards(self.index,function(data)
                qy.tank.command.AwardCommand:show(data.award,{["callback"] = function()
					if delegate.updateExMaps then
	                	delegate.updateExMaps()
	                end
				end})
                -- if delegate.updateExMaps then
                -- 	delegate.updateExMaps()
                -- end
            end)
		end
	end)

	self.model = qy.tank.model.FightJapanModel
end

function ExChestCell:refresh(idx)
	self.index = idx
	-- print("==========idx==" ..idx)
	self.entity = self.model:getExpeEnemyDataByIdx(idx)
	self.chestStatus = self.entity:getStatus()
	local lastIdx = self.model:getExpeEnemyNum()
	cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/common/icon/common_icon.plist")
	if idx == lastIdx then
		self.chestBtn:setContentSize(157,124)
		self.light:setVisible(false)
		if self.chestStatus == 2 then
			--已开过
			self.chestBtn:loadTexture("Resources/common/icon/chestIcon_2.png",1)
		elseif self.chestStatus == 1 then
			--正在开
			self.chestBtn:loadTexture("Resources/common/icon/chestIcon.png",1)
		else
			--未开
			self.chestBtn:loadTexture("Resources/common/icon/chestIcon_3.png",1)
		end
	else
		self.chestBtn:setContentSize(94, 90)
		if self.chestStatus == 2 then
			--已开过
			self.light:setVisible(false)
			self.chestBtn:loadTexture("Resources/fight_japan/D_5.png",1)
		elseif self.chestStatus == 1 then
			--正在开
			self.light:setVisible(true)
			self.chestBtn:loadTexture("Resources/fight_japan/D_4.png",1)
		else
			--未开
			self.light:setVisible(false)
			self.chestBtn:loadTexture("Resources/fight_japan/D_4.png",1)
		end
	end


end

return ExChestCell
