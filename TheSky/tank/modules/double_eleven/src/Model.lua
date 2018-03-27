--[[
	双十一活动
]]

local Model = class("Model", qy.tank.model.BaseModel)

function Model:init(data)
	self.data = data
	self.config = qy.Config.double_eleven
end

-- function Model:getaward()
-- 	local award_list = {}
-- 	for k,v in pairs(self.config) do
-- 		if v.day == self.data.today_num then
-- 			table.insert(award_list,v)
-- 		end
-- 	end
-- 	table.sort(award_list,function(a,b)
--         return tonumber(a.id) < tonumber(b.id)
--     end)	
-- 	return award_list
-- end

function Model:get_show_award(  )
	return self.data.today_award
end

--0 未购买 1 已购买 改变按钮的状态 id为按钮id
function Model:get_btn_status(id)
	return self.data.double_eleven.extends_data[tostring(self.data.today_num)][tostring(id + 4*(self.data.today_num - 1))].state
end

function Model:change_btn_status(id)
	self.data.double_eleven.extends_data[tostring(self.data.today_num)][tostring(id + 4*(self.data.today_num - 1))].state = 2
end


return Model
