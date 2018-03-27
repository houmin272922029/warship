local StackNode = class("StackNode",function()
	return cc.Node:create()
end)

function StackNode:ctor()
	self.table = {}
end

function StackNode:push(node) 
	if #self.table > 0 then
	 	local removed = self.table[#self.table]
	 	if removed == node then
			print("StackNode:push==========>added & current are the same!",added,self.table[#self.table])
	 		return
	 	else 
	 		self:removeChild(removed)
			print("StackNode:push==========>added & current aren't the same!",added,self.table[#self.table])
		end
	end

	local added = node
	if self:contains(added)>0 then
		print("StackNode:push==========>contains added!",added)
		table.remove(self.table,self:contains(added))
	else
		print("StackNode:push==========>dosen't contain added!",added)
		added:retain()
	end
	self:addChild(added)
	table.insert(self.table,added)
	print("StackNode.push #table = ",#self.table)
end 

function StackNode:pop()
	if #self.table > 0 then 
		local removed = self.table[#self.table]
		if removed then
			print("StackNode:pop==========>pop",removed,#self.table)
			self:removeChild(removed)
			table.remove(self.table,#self.table)
			removed:release()
		end
	end

	if #self.table >0 then
		local added = self.table[#self.table]
		if added then
			self:addChild(added)
		end
	end
end

function StackNode:peek()
	if #self.table > 0 then 
		return self.table[#self.table]
	else
		return nil
	end
end

function StackNode:popAll()
	for i = #self.table,1,-1 do
		local node = self.table[i]
		if node then
			self:removeChild(node)
			table.remove(self.table,node)
			removed:release()
		end
	end
end

function StackNode:popAllExceptFirst()
	for i = #self.table,2,-1 do
		local node = self.table[i]
		if node then
			self:removeChild(node)
			table.remove(self.table,node)
			removed:release()
		end
	end
end

function StackNode:popAllExcept(id)
	for i = #self.table,1,-1 do
		local node = self.table[i]
		if node then
			if i ~= id then 
				self:removeChild(node)
				table.remove(self.table,node)
				removed:release()
			end
		end
	end
end

function StackNode:replace(node)
	self:pop(StackNode:peek())
	self:push(node)
end

function StackNode:contains(node)
	for i=1,#self.table do
		if self.table[i] == node then
			return i
		end
	end
	return -1
end 

return StackNode