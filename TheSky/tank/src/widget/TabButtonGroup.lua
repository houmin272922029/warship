--[[
	tab按钮组
	Author: Aaron Wei
	Date: 2015-04-14 20:30:05
]]

local TabButtonGroup = class("TabButtonGroup", function(csd,tabs,cellSize,layout,callback)
    return cc.Node:create()
end)
--color参数后加，传颜色数组，数组大小不能大于按钮个数
function TabButtonGroup:ctor(csd,tabs,cellSize,layout,callback, defaultIdx,color)
	self.btns = {}
	self.csd = csd
	self.cellSize = cellSize
	self.layout = layout
	self.callback = callback

	if defaultIdx == nil then
		defaultIdx = 1 
	end
	self:setTabs(tabs)
    self:switchTo(defaultIdx)
    if color then
    	self:setTabColor(color)
    end
end

function TabButtonGroup:switchTo(idx)
	if self._lastBtn then
		self._lastBtn:setSelected(false)
	end
	self._lastBtn = self.btns[idx]
	self._lastBtn:setSelected(true)

	if self.callback then
		self.callback(idx)
	end
	qy.Event.dispatch("tab_changed")
end

function TabButtonGroup:arrange()
	if self.layout == "h" then
		qy.tank.utils.ListUtil.align(self.btns,self.cellSize,"h")
	elseif self.layout == "v" then
		-- qy.tank.utils.ListUtil.align(self.btns,self.cellSize,"v")
		for i=1,#self.btns do
			local node = self.btns[i]
			node:setPosition(0,(#self.btns-i)*self.cellSize.height)
		end
	end
end

function TabButtonGroup:setTabs(arr)
	self.tabs = arr
	for i=1,#self.tabs do
    	local btn = qy.tank.widget.TabButton.new(self.csd,self.tabs[i],i,function(_btn)
 			self:switchTo(_btn.idx)
    	end)
    	self:addChild(btn)
    	table.insert(self.btns,btn)
    end
    self:arrange()
end

function TabButtonGroup:setTabNames(arr)
	self.tabs = arr
	for i=1,#self.tabs do
    	local btn = self.btns[i]
    	btn:setTitleText(arr[i])
    end
end
function TabButtonGroup:setTabColor( color )
	local tabs = color
	for i=1,#tabs  do
    	local btn = self.btns[i]
    	btn:setTitleColor(color[i])
    end
end

function TabButtonGroup:setCellSize(size)
	self.cellSize = size
	self:arrange()
end

function TabButtonGroup:setDirection(d)
	self.direction = d
	self:arrange()
end

function TabButtonGroup:setGap(num)
 	self.gap = num
	self:arrange()
end

return TabButtonGroup