--[[--
--掠夺cell
--Author: H.X.Sun
--Date: 2015-05-25
--]]--

local PlunderCell = qy.class("PlunderCell", qy.tank.view.BaseView, "view/mine/PlunderCell")

function PlunderCell:ctor(delegate)
    PlunderCell.super.ctor(self)
	self.delegate = delegate
	self:InjectView("product")
	self:InjectView("userLevel")
	self:InjectView("userName")
	self:InjectView("revengeMark")
	self:InjectView("mineIcon")
    self:InjectView("legion_tip")
	self.model = qy.tank.model.MineModel

	--掠夺
	self:OnClick("plunderBg", function (sendr)
		if self.model.mineEntity.owner.oil > 0 then
			local service = qy.tank.service.MineService
	        service:plunder(self.entity, function(data)
	        	qy.tank.manager.ScenesManager:pushBattleScene()
	        	-- qy.tank.manager.ScenesManager:pushScene(qy.tank.view.scene.BattleScene.new())
	        	if delegate.updateOil then
	        		delegate.updateOil()
	        	end
	        	self:updateCell(self.entity)
	        end)
	    else
	    	qy.hint:show(qy.TextUtil:substitute(21021))
	    end
	end)
end

function PlunderCell:updateCell(entity)
	self.entity = entity
	self.product:setString(entity.curProduct)
	self.userName:setString(entity.owner.nickname)
	self.userLevel:setString(entity.owner.level)
	print("entity.owner.head_img===" ..entity.owner.head_img)
	self.mineIcon:setTexture(qy.tank.utils.UserResUtil.getRoleIconByHeadType(entity.owner.head_img))
	if entity.owner.isRevenge == 1 then
		self.revengeMark:setVisible(true)
	else
		self.revengeMark:setVisible(false)
	end
    if self.model.mineEntity.owner.legion_id == 0 then
        self.legion_tip:setVisible(false)
    elseif self.model.mineEntity.owner.legion_id == entity.owner.legion_id then
        self.legion_tip:setVisible(true)
    else
        self.legion_tip:setVisible(false)
    end
end

--[[--
--显示掠夺结果
--]]
function PlunderCell:showPlunderResult()
	if  self.model:isSuccessfulPlunder() then
		qy.hint:show(qy.TextUtil:substitute(21022))
	else
		qy.hint:show(qy.TextUtil:substitute(21023))
	end
end

return PlunderCell
