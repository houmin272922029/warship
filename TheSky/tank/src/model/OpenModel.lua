local OpenModel = qy.class("OpenModel", qy.tank.model.BaseModel)

function OpenModel:ctor()
end

function OpenModel:getOpenArray(level)
	local cfg = qy.Config.gongneng_open
	local Array = {}
	for k,v in pairs(cfg) do
		if type(v.open_level1) == "number" and type(v.open_level2) == "number" then
			if tonumber(level) >= tonumber(v.open_level1) and tonumber(level) <= tonumber(v.open_level2) then
				table.insert(Array, v)
			end
		end
	end
	if #Array == 1 then 
		local nextRank = Array[1].rank + 1
		for k,v in pairs(cfg) do
			if v.open_level<=70 and v.open_level>=10 then
				if tonumber(nextRank) == v.rank then
					table.insert(Array, v)
				end
			end
		end
	end
	table.sort(Array, function(a, b)
		return a.rank < b.rank 
	end)

	return Array
end

return OpenModel