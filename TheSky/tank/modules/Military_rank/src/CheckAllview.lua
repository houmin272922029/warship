local CheckAllview = qy.class("CheckAllview", qy.tank.view.BaseView, "Military_rank/ui/CheckAllView")

local  model = qy.tank.model.MilitaryRankModel

function CheckAllview:ctor(delegate)
    CheckAllview.super.ctor(self)
      local style = qy.tank.view.style.ViewStyle1.new({
        titleUrl = "Resources/common/title/junxian.png",
        ["onExit"] = function()
             delegate.viewStack:pop()
        end
    })
    self:addChild(style, 13)
    self:InjectView("ScrollView_1")
    self.level = model:getRankLevel()--或许当前等级
    self.list={}
    self:createList()
    
end

function CheckAllview:createList()
	local item1 = require("Military_rank.src.TitleCells").new(self)
	item1:render(1)
	table.insert(self.list, item1)
	self.ScrollView_1:addChild(item1)
	for i = 1, self.level do
		local item = require("Military_rank.src.ItemCells").new(self)
		item:render(i)
		table.insert(self.list, item)
		
		self.ScrollView_1:addChild(item)
	end
	if self.level ~= 24 then 
		local item11 = require("Military_rank.src.TitleCells").new(self)
		table.insert(self.list, item11)
		item11:render(2)
		self.ScrollView_1:addChild(item11)
	end
	for i = self.level+1, 24 do
		local items = require("Military_rank.src.ItemCells").new(self)
		items:render(i)
		table.insert(self.list, items)
		
		self.ScrollView_1:addChild(items)
	end
	self:update()
end

function CheckAllview:update()
	local h = 0
	for i, v in pairs(self.list) do
		-- v:setPositionY(h)
		h = h + v.h
	end
	local height = h > 570 and h or 570
	self.ScrollView_1:setInnerContainerSize(cc.size(910, height))
	self.ScrollView_1:setContentSize(cc.size(910, 570))

	local h2 = 0
	for i, v in pairs(self.list) do
		h2 = h2 + v.h
		v:setPositionY(height - h2)
	end
end



return CheckAllview