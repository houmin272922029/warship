--[[
	将配置文件转为二维数组
]]

local Config2ArrUtil = {}

--[[--
--新手引导
--]]
function Config2ArrUtil.getArrByGuideConfig(data)
	if type(data) == "table" then
		local arr = {}
		local index = -1
		local subIndex = -1
		for _k, _v in pairs(data) do
			-- print("_k==" .. _k)
			index = data[_k].step--大步骤
			-- print("index ===" ..index)
			subIndex = data[_k].sub_step --小步骤
			-- print("subIndex ===" ..subIndex)
			if arr[index] == nil then
				arr[index] = {}
			end
			arr[index][subIndex] = data[_k]
		end
		return arr
	else
		return data
	end
end


--[[--
--触发引导
--]]
function Config2ArrUtil.getArrByTriggerGuideConfig(data)
	local functionArr = {}
	if type(data) == "table" then
		local arr = {}
		local index = -1
		local subIndex = -1
		for _k, _v in pairs(data) do
			index = data[_k].level--等级
			subIndex = data[_k].step --步骤
			if arr[index] == nil then
				arr[index] = {}
			end
			arr[index][subIndex] = data[_k]
			if subIndex == 1 then
				functionArr[data[_k].res] = index
			end
		end
		return arr,functionArr
	else
		return data, functionArr
	end
end

return Config2ArrUtil