ListUtil = {}

function ListUtil.autoAlign(arr,gap,direction)
	local node,node_before
	if direction == "h" then
		for i=1,#arr do
			node = arr[i]
			if i == 1 then
				node:setPosition(0,0)
			else 
				node_before = arr[i-1]
				node:setPosition(node_before:getPositionX()+node_before:getContentSize().width+gap,0)
			end
		end
	elseif direction == "v" then
		for i=#arr,1,-1 do
			node = arr[i]
			if i == #arr then
				node:setPosition(0,0)
			else 
				node_before = arr[i+1]
				node:setPosition(node_before:getPositionY()+node_before:getContentSize().height+gap,0)
			end
		end
	end
end

function ListUtil.align(arr,cellSize,direction)
	local node
	if direction == "h" then
		for i=1,#arr do
			node = arr[i]
			node:setPosition((i-1)*cellSize.width,0)
		end
	elseif direction == "v" then
		for i=#arr,1,-1 do
			node = arr[i]
			node:setPosition(0,(i-1)*cellSize.height)
		end
	end
end

return ListUtil
