--[[
	仓库物品cell
	Author: Aaron Wei
	Date: 2015-04-16 17:57:05
]]

local StorageCell = qy.class("StorageCell", qy.tank.view.BaseView, "view/storage/StorageCell")

function StorageCell:ctor(delegate)
    StorageCell.super.ctor(self)

	self:InjectView("bg")
	self:InjectView("saleBtn")
	self:InjectView("useBtn")
	self:InjectView("icon")
	-- self:InjectView("color")
	self:InjectView("iconBG")
	self:InjectView("des")
	self:InjectView("num")
	self:InjectView("goodsName")
	-- qy.tank.utils.TextUtil:autoChangeLine(self.des , cc.size(395 , 55))

	self:OnClick("useBtn",function()
		if self.entity.is_use == 1 then
            -- 使用
    		delegate.onUse(self.entity)
        elseif self.entity.is_use == 2 then
            -- 跳转到战地援助
            delegate.dismiss()
            qy.tank.command.ActivitiesCommand:showActivity(qy.tank.view.type.ModuleType.WAR_AID)
        elseif self.entity.is_use == 3 then
            -- 跳转到幸运夺宝
            delegate.dismiss()
            qy.tank.command.ActivitiesCommand:showActivity(qy.tank.view.type.ModuleType.LUCKY_INDIANA)
        elseif self.entity.is_use == 4 then
            -- 跳转到大转盘
            qy.tank.model.LuckyTurntableModel:init(self.entity.trigger_args,self.entity.id,self.entity.need_id)
            delegate.dismiss()
            qy.tank.command.ActivitiesCommand:showActivity(qy.tank.view.type.ModuleType.LUCKY_TRUNTABLE)
    	elseif self.entity.is_use == 5 then
    		delegate.dismiss()
    		qy.tank.view.common.ChangeName.new():show()
    	else
            -- 不可使用
    		qy.hint:show(self.entity.not_use_tips)
    	end
    end)

    self:OnClick("saleBtn",function()
    	if self.entity.sell_limit == 1 then
    		delegate.onSell(self.entity)
    	else
    		qy.hint:show(self.entity.not_sell_tips)
    	end
    end)
end

function StorageCell:render(entity)
	self.entity = entity
	if entity then
		self.goodsName:setString(entity.name)
		self.goodsName:setTextColor(qy.tank.utils.ColorMapUtil.qualityMapColor(entity.quality))
		self.num:setString(qy.TextUtil:substitute(32010)..entity.num)
		self.des:setString(entity.desc)
		if entity.sell_limit == 1 then
			self.saleBtn:setEnabled(true)
	    	self.saleBtn:setBright(true)
		else
			self.saleBtn:setEnabled(false)
	    	self.saleBtn:setBright(false)
		end

		if entity.is_use == 0 then
            self.useBtn:setEnabled(false)
	    	self.useBtn:setBright(false)
		else
            self.useBtn:setEnabled(true)
	    	self.useBtn:setBright(true)
		end
		self.icon:setTexture(entity:getIcon())
		self.iconBG:setSpriteFrame(entity:getIconBG())
	end
end

return StorageCell
