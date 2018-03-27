--[[
	Author: Aaron Wei
	Date: 2016-01-04 20:38:17
]]

local TorchCell = qy.class("TorchCell", qy.tank.view.BaseView,"torch.ui.TorchCell")

function TorchCell:ctor(delegate)
	self.delegate = delegate
    TorchCell.super.ctor(self)

	self:InjectView("title")
	self:InjectView("titleBg")
	self:InjectView("bg")
	self:InjectView("btn")
	self:InjectView("btnLabel")
	self:InjectView("icon")

	self.titleBg:setLocalZOrder(1)
	self.title:setLocalZOrder(2)

	self:OnClick("btn",function()
		if self.entity.is_draw == 0 then -- 前往
    		delegate.goto(self.entity.view_id)
    	else -- 领取
    		-- delegate.draw(self.entity.day,self.entity.id)
    		delegate.draw(self.entity)
    	end
    end)

    -- self:OnClick("saleBtn",function()
    -- 	if self.entity.sell_limit == 1 then
    -- 		delegate.onSell(self.entity)
    -- 	else
    -- 		qy.hint:show(self.entity.not_sell_tips)
    -- 	end
    -- end)
end

function TorchCell:render(data)
	self.entity = data
	if self.entity then
		self.title:setString(self.entity.content)

		if data.is_draw == 0 then -- 未完成
    		self.btn:setVisible(true)
    		self.btn:loadTextures("Resources/common/button/btn_4.png","Resources/common/button/anniulan02.png",nil,1)
    		self.btnLabel:initWithSpriteFrameName("Resources/common/txt/qianwang.png")
    		self.icon:setVisible(false)

    		self.icon:setVisible(false)
    		-- self.icon:initWithFile("Resources/common/txt/hjxd03.png")
    	else -- 已达成
    		if data.is_draw == 1 then -- 已领取
    			self.btn:setVisible(false)
    			self.icon:setVisible(true)
    			self.icon:initWithSpriteFrameName("Resources/common/img/D_12.png")
    		elseif data.is_draw == 2 then -- 未领取
    			self.btn:setVisible(true)
    			self.btn:loadTextures("Resources/common/button/btn_3.png","Resources/common/button/anniuhong02.png",nil,1)
    			self.btnLabel:initWithSpriteFrameName("Resources/common/txt/lingqu.png")
    			self.icon:setVisible(false)
    		end
    	end

		if self.entity.award then
			if not tolua.cast(self.awardList,"cc.Node") then
		        self.awardList = qy.AwardList.new({
		            ["award"] =  self.entity.award,
		            ["hasName"] = false,
		            ["type"] = 1,
		            ["cellSize"] = cc.size(140,100),
		            ["itemSize"] = 1, 
		        })
		        self.awardList:setPosition(105,160)
		        self.bg:addChild(self.awardList,0)
		        self.awardList:setScale(0.9)
		   	else
		   		self.awardList:update(self.entity.award)
		   	end
	    end
	end
end

return TorchCell                   
