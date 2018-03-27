

local FieldBanquetModel = qy.class("FieldBanquetModel", qy.tank.model.BaseModel)



function FieldBanquetModel:init(data)
	self.data = data
	self.interface =  0 --显示页面
	self.start_time = data.server_time
	self.end_time = data.end_time

	self.config = qy.Config.war_party_shop
	self.config2 = qy.Config.war_party_attr
	
end

function FieldBanquetModel:set_page1(  )
	self.interface = 0
end

function FieldBanquetModel:set_page2(  )
	self.interface = 1
end
--拿奖励
function FieldBanquetModel:getAward(id)
	return self.config[tostring(id)]
end

--拿属性
function FieldBanquetModel:getattr(id)
	return self.config2[tostring(id)]
end

--购买之后减除徽记 并且增加消耗徽记 is_get 设置为1
function FieldBanquetModel:change_huiji(id,num)
	self.data.user_activity_data.point = self.data.user_activity_data.point - num
	self.data.user_activity_data.total_desc_point = self.data.user_activity_data.total_desc_point + num
	self.data.user_activity_data.list[tostring(id)].is_get = 1

end

--刷新shop替换user_activity_data
function FieldBanquetModel:chage_user_data(data)
	self.data.user_activity_data = data
end

function FieldBanquetModel:set_is_active(  )
	self.model.data.user_activity_data.attr[tostring(i)].is_active = 1
end

-- function FieldBanquetModel:totalAttr(_is_active,_config_id,id)
-- 	self.config2 = qy.Config.war_party_attr
-- 	local data = self:getattr(_config_id)
-- 	if tonumber(data.attr_type) == tonumber(id) then
-- 	   return data.attr_num
-- 	else 
-- 		return 0 
-- 	end
-- end

function FieldBanquetModel:setInitData(_data)
	self._data = _data
end

function FieldBanquetModel:totalAttr( _id) --_id 1 ,2,3
	self.config2 = qy.Config.war_party_attr
	local list = {}
	local num = 0

	if self._data.war_party_attr and table.nums(self._data.war_party_attr) > 0 then
		for i=1,table.nums(self._data.war_party_attr) do
			local id = self._data.war_party_attr[tostring(i)].config_id
			local is_activ = self._data.war_party_attr[tostring(i)].is_active
			local data = self:getattr(id)
			if is_activ == 1 then
				if data.attr_type == _id then
					num = num + data.attr_num
				else
					num = num + 0
				end
			else
				num =num + 0
			end
		end
	end
	return num
end

function FieldBanquetModel:setTankEntity(data)
	--qy.tank.entity.TankEntity.new(self._data)
	self._data.war_party_attr = data.attr
end

--最佳商品
function FieldBanquetModel:getZuijia(id)
	local list = {}
	for k,v in pairs(self.config) do
		if v.day == id and v.type == 1 then
			table.insert(list,v)
		end
	end
	return list
end

--购买覆盖属性
function FieldBanquetModel:change_attr(data)
	self.data.user_activity_data = data
end


return FieldBanquetModel