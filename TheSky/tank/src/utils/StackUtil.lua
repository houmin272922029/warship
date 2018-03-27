StackUtil = {}

function StackUtil.push(container,stack,node)
	-- 将堆栈中最后一个元素从显示列表中移除，但仍在堆栈中保留引用
	if #stack > 0 then
	 	local removed = stack[#stack]
	 	if removed then
	 		container:removeChild(removed)
	 	end
	end
	local added = node 
	container:addChild(added)
	table.insert(stack,added)
	added:retain()
	print("StackUtil.push #stack = ",#stack)
end 

function StackUtil.pop(container,stack)
	if #stack > 0 then 
		local removed = stack[#stack]
		if removed then
			container:removeChild(removed)
			table.remove(stack,removed)
			removed.release()
		end
	end

	if #stack >0 then
		local added = stack[#stack]
		if added then
			container:addChild(added)
		end
	end
end

function StackUtil.peek(stack)
	if #stack > 0 then 
		return stack[#stack]
	else
		return nil
	end
end

function StackUtil.popAll(container,stack)
	for i = #stack,1,-1 do
		local node = stack[i]
		if node then
			container:removeChild(node)
			table.remove(stack,node)
			removed.release()
		end
	end
end

function StackUtil.popAllExceptFirst(container,stack)
	for i = #stack,2,-1 do
		local node = stack[i]
		if node then
			container:removeChild(node)
			table.remove(stack,node)
			removed.release()
		end
	end
end

function StackUtil.popAllExcept(container,stack,id)
	for i = #stack,2,-1 do
		local node = stack[i]
		if node then
			if i ~= id then
				container:removeChild(node)
				table.remove(stack,node)
				removed.release()
			end
		end
	end
end