--[[
	季卡年卡
	
]]

local Model = class("Model", qy.tank.model.BaseModel)
function Model:init(data)
	self.data = data
	--拿到表中的数据
	self.config = qy.Config.month_card
	print("777====777",self.config)
	
	
end

--拿到表中的一条数据
function Model:GetSeasonDataById(id)
	local list = {}
	for k,v in pairs(self.config) do
		if v.id == id then
			table.insert(list,v)
		end
	end
	table.sort(list,function(a,b)
        return tonumber(a.id) < tonumber(b.id)
    end)
	return list	
end

--拿到状态 天数
function Model:GesStatusById(id)--id 3 = 季卡  4 = 年卡
	return self.data[""..id].status,self.data[""..id].count_down_day
end

--改变天数
function Model:ChangeTime(id)
	self.data[""..id].count_down_day = self.data[""..id].count_down_day - 1
end

--设置天数
function Model:SetTime(id)
	--self.data[""..id].count_down_day = 90
	if id == 3 then
		self.data[""..id].count_down_day = 90
	elseif id == 4 then
		self.data[""..id].count_down_day = 365	
	end
end

--成功购买后改变状态
function Model:ChangeStatus(id)
	self.data[""..id].status = 2
end

--成功领取后改变状态
function Model:ChangeStatus2(id)
	self.data[""..id].status = 3
end

-- 获取钻石数据
function Model:atMonthCardDiamond(idx)
	local num = self.config[tostring(idx)].diamond
	return qy.tank.view.common.AwardItem.getItemData({["type"] = 1, ["num"] = num})
end


return Model
