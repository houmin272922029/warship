--
-- Author: Wei Long
-- Date: 2014-12-05 14:12:59
--

local ListNode = class("ListNode",function()
	return cc.Node:create()
end)

function ListNode:ctor()
	self.data = nil
	self.cellSize = nil
	self.direction = nil
end

-- function ListNode:autoAlign(arr,gap,direction)
-- 	local node,node_before
-- 	if direction == "h" then
-- 		for i=1,#arr do
-- 			node = arr[i]
-- 			if i == 1 then
-- 				node:setPosition(0,0)
-- 			else 
-- 				node_before = arr[i-1]
-- 				node:setPosition(node_before:getPositionX()+node_before:getWidth()+gap,0)
-- 			end
-- 			self:addChild(node)
-- 		end
-- 	elseif direction == "v" then
-- 		for i=#arr,1,-1 do
-- 			node = arr[i]
-- 			if i == #arr then
-- 				node:setPosition(0,0)
-- 			else 
-- 				node_before = arr[i+1]
-- 				node:setPosition(node_before:getPositionY()+node_before:getHeight()+gap,0)
-- 			end
-- 			self:addChild(node)
-- 		end
-- 	end
-- end

function ListNode:align(arr,cellSize,direction)
	self.data = arr
	self.cellSize = cellSize
	self.direction = direction

	self:update()
end

function ListNode:update()
	local node
	if self.direction == "h" then
		for i=1,#self.data do
			node = self.data[i]
			node:setPosition((i-1)*self.cellSize,0)
			self:addChild(node)
		end
	elseif self.direction == "v" then
		for i=1,#self.data do
			node = self.data[i]
			node:setPosition(0,0-i*self.cellSize)
			self:addChild(node)
		end
	end
end

function ListNode:add(cell)
	table.insert(self.data,cell)
	self:update()
end

function ListNode:addlAt(cell,idx)
	table.insert(self.data,idx,cell)
	self:update()
end

function ListNode:removeAt(idx)
	local cell = self.data[idx]
	table.remove(self.data,idx)
	self:removeChild(cell)
	self:update()
end

function ListNode:swap(id1,id2)
	local cell1 = self.data[id1]
	local cell2 = self.data[id2]
	self.data[id1] = cell2
	self.data[id2] = cell1
	self:update()
end

function ListNode:clear()
	for i=#self.data,1,-1 do
		local node = self.data[i]
		table.remove(self.data,i)
		if node:getParent() then
			node:getParent():removeChild(node)
		end
	end
end

return ListNode
