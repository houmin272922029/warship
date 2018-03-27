TileUtil = {}

function TileUtil.arrange(arr,len,cellWidth,cellHight,original,type1)
	local node
	for i=1,#arr do
		local h = math.ceil(i/len)
		local w = (i -1) % len
		node = arr[i]
		if type1 == 1 then
			node:setPosition((original.x+w*cellWidth)-45,(original.y-h*cellHight)-45)--修改后运营活动专用
		else
			node:setPosition(original.x+w*cellWidth,original.y-h*cellHight)
		end
		--print("==========================================================")
		-- print(i .. "====[x]==" ..original.x+(i-1)*cellWidth.. "==[y]=="..original.y-j*cellHight)
		-- print("=original.x==="..original.x.."===(i-1)*cellWidth=="..(i-1)*cellWidth.."=================================================")
		-- print(j .."=original.y==="..original.y.."===j*cellHight=="..j*cellHight.."=================================================")
	end
	-- for i = 1, #arr do
	-- 	node = arr[i]
		
end

return TileUtil
