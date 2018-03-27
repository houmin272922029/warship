--[[
	仓库model
	Author: Aaron Wei
	Date: 2015-04-17 15:30:24
]]

local StorageModel = qy.class("StorageModel", qy.tank.model.BaseModel)

function StorageModel:init(data) 
	self.data = data 
	self.totalData = {}
	self.totalList = {}
	self.materialList = {}
	self.chestList = {}
	self.propsList = {}

	-- local props = nil
	-- for k,v in pairs(data) do
	-- 	if type(v) == "table" then
	-- 		for _k,_v in pairs(v) do
	-- 			local props = qy.tank.entity.PropsEntity.new(_v)
	-- 			self.totalData[_k] = props	
	-- 			table.insert(self.totalList,props) 
	-- 			table.insert(self[k.."List"],props)
	-- 		end 
	-- 	end  
	-- end
	if data.material then
		for k,v in pairs(data.material) do
			local material = qy.tank.entity.PropsEntity.new(v)
			table.insert(self.materialList,material)
			table.insert(self.totalList,material) 
			self.totalData[k] = material
		end
	end  

	if data.chest then
		for k,v in pairs(data.chest) do
			local chest = qy.tank.entity.PropsEntity.new(v)
			table.insert(self.chestList,chest) 
			table.insert(self.totalList,chest) 
			self.totalData[k] = chest
		end
	end

	if data.props then
		for k,v in pairs(data.props) do 
			local props = qy.tank.entity.PropsEntity.new(v)
			table.insert(self.propsList,props) 
			table.insert(self.totalList,props) 
			self.totalData[k] = props
		end
	end

	self:sort()
end

function StorageModel:update(data)
	local entity = self:getEntityByID(data.props_id) 
	if data.remain > 0 then
		entity.num_:set(data.remain)
	else
		self:remove(data.props_id,data.sell_num)
	end
end

function StorageModel:getEntityByID(id)
	return self.totalData[tostring(id)]
end

function StorageModel:getPropNameByID(id)
	if self:getEntityByID(id) then
		return self:getEntityByID(id).name
	else
		local staticdata = qy.Config.props
		return staticdata[tostring(id)].name
	end
end

function StorageModel:getPropNumByID(id)
	if self:getEntityByID(id) then
		return self:getEntityByID(id).num
	else
		return 0
	end
end

function StorageModel:add(id,num)
	print("++++++++++++++++++++++++++++++",id,num)
	local entity = nil 
	if self.totalData[tostring(id)] then
		entity = self.totalData[tostring(id)]
		print("entity.num==" .. entity.num)
		entity.num = entity.num + num
		print("entity.num==" .. entity.num)
	else
		entity = qy.tank.entity.PropsEntity.new({["id"]=id,["num"]=num})
		self.totalData[tostring(id)] = entity
		table.insert(self.totalList,entity)
		if entity.type == 1 then
			table.insert(self.chestList,entity)
		elseif entity.type == 2 then
			table.insert(self.propsList,entity)
		elseif entity.type == 3 then
			table.insert(self.materialList,entity)
		end
	end
	self:sort()
end

function StorageModel:remove(id,num)
	local entity = nil
	if self.totalData[tostring(id)] then
		entity = self.totalData[tostring(id)]
		assert(entity.num>=num,qy.TextUtil:substitute(32015)) 
		if entity.num > num then
			entity.num = entity.num - num
		elseif entity.num <= num then 
			self.totalData[tostring(id)] = nil
			table.remove(self.totalList,self:getIdx(id,self.totalList))
			if entity.type == 1 then
				table.remove(self.chestList,self:getIdx(id,self.chestList))
			elseif entity.type == 2 then
				table.remove(self.propsList,self:getIdx(id,self.propsList))
			elseif entity.type == 3 then
				table.remove(self.materialList,self:getIdx(id,self.materialList))
			end
		end		
	else
		qy.hint:show(qy.TextUtil:substitute(32016))
		-- assert(self.totalData[i],"仓库中没有该物品!")
	end
end

function StorageModel:addEntity(entity)
	self:add(entity.id,entty.num)	
end

function StorageModel:removeEntity(entity)
	self:remove(entity.id,entty.num)	
end

function StorageModel:contains(id)
	return self.totalData[id]
end

function StorageModel:enough(id, num)
	return self.totalData[tostring(id)] and self.totalData[tostring(id)].num >= num
end

function StorageModel:getIdx(id,arr)
	for i=1,#arr do
		local entity = arr[i]
		if entity and entity.id == id then
			return i
		end 
	end
	return nil
end

function StorageModel:sort()
	self:sortTotal()
	self:sortMaterial()
	self:sortChest()
	self:sortProps()
end

function StorageModel:sortTotal()
	self:__sort(self.totalList)
	return self.totalList
end

function StorageModel:sortMaterial()
	self:__sort(self.materialList)
	return self.materialList	
end

function StorageModel:sortChest()
	self:__sort(self.chestList)
	return self.chestList	
end

function StorageModel:sortProps()
	self:__sort(self.propsList)
	return self.propsList	
end

function StorageModel:__sort(arr)
	table.sort(arr,function(a,b)
		if tonumber(a.type) == tonumber(b.type) then
			if tonumber(a.quality) == tonumber(b.quality) then
				if tonumber(a.id) == tonumber(b.id) then
				else
					-- 按ID排序
					return tonumber(a.id) < tonumber(b.id)
				end
			else
				-- 按颜色排序
				return tonumber(a.quality) > tonumber(b.quality)
			end
		else
			-- 按道具类型排序
			return tonumber(a.type) < tonumber(b.type)
		end
	end)
	return arr
end

return StorageModel

