--[[

]]

local FireRebateModel = class("FireRebateModel", qy.tank.model.BaseModel)
 

-- fire_line_rebate_draw   返利抽奖
--     返利累冲
-- fire_line_rebate_sign   登录奖励

--初始化
function FireRebateModel:init( _data )
	if _data == nil then
		print("FireRebateModel获取活动数据失败--传入数据为nil")
		return
	end
	local data =  _data.activity_info
	self.mrecharge_times = data.activity_info.recharge_times -- 抽奖次数
	self.mtotal = data.activity_info.total -- 累计充值数量
	self.mextend_data = data.activity_info.extend_data -- 累计充值 记录数组
	self.mlogin_times = data.activity_info.login_times -- 签到数组


	self.mSurplusTimes = data.end_time  - data.server_time
	self.mLeijiLoginCf = qy.Config.fire_line_rebate_sign
	self.mWelfareCf = qy.Config.fire_line_rebate_draw
	self.mActivityCf = qy.Config.fire_line_rebate_recharge

	self.mLuckdrawState = false

end


--[[
	获取当前签到的数组
]]--
function FireRebateModel:GetSign(  )
	return self.mlogin_times
end



--[[
	获得当前签到的状态
]]--
function FireRebateModel:GetSignState(  )
	return self.mlogin_times.state
end


--[[
	设置当前签到的状态
]]--
function FireRebateModel:SetSignStateYes( _state )
	self.mlogin_times.state = _state
end


--[[
	判断当前签到的天数
]]--
function FireRebateModel:IsSignState(  )

	for k,v in pairs(self.mlogin_times) do
		if v == 1 and k ~= "state"  then
			return k,v
		end
	end
	return 0,0
end

--[[
	获得签到的状态
]]--
function FireRebateModel:SetSignState( _day )

	local x = _day
	for k,v in pairs(self.mlogin_times) do
		if k == tostring(_day) then
			self.mlogin_times[k] = 2
		end
	end
end



--[[
	获取活动剩余的时间
]]--
function FireRebateModel:GetSurplusTiems(  )
	if self.mSurplusTimes == nil then
		self.mSurplusTimes = 0
	end
	return self.mSurplusTimes
end


--[[
	算出是否是最后一天
]]--
function FireRebateModel:GetSurplusTiemsState()
	if self.mSurplusTimes <= 0 then
		return true
	else
		return false
	end
end


--[[
	抽奖时候这里不可点击
]]--
function FireRebateModel:GetLuckdrawState()
	return self.mLuckdrawState
end

function FireRebateModel:SetLuckdrawState( _state )
	self.mLuckdrawState = _state
end



--[[  下面三个函数 返回对应界面的表格 ]]--
function FireRebateModel:ReturnLeijiLoginCf( ... )
	return self.mLeijiLoginCf
end

function FireRebateModel:ReturnWelfareCf( ... )
	return self.mWelfareCf

end

function FireRebateModel:ReturnActivityCf( ... )
	return self.mActivityCf

end




--[[
	返回充值福利剩余次数
]]--
function FireRebateModel:GetWelfareTime( ... )
	if self.mrecharge_times == nil then
		self.mrecharge_times = 0
	end
	return self.mrecharge_times
end

function FireRebateModel:SetWelfareTime( times )
	self.mrecharge_times = self.mrecharge_times - 1
end



--[[
	返回活动累充当前已经充值砖石数量
]]--
function FireRebateModel:GetActivityConNum( ... )
	if self.mtotal == nil then
		self.mtotal = 0
	end
	return self.mtotal
end

function FireRebateModel:SetActivityConNum( times )
	self.ActivityConNum = times
end




--[[
	抽奖转圈后找出是抽取到第几个
]]--
function FireRebateModel:getLuckdrawIndex( _data )
	local data = {}
	data.type = tonumber(_data[1].type)
	data.num = tonumber(_data[1].num)


	for k,v in pairs(self.mWelfareCf) do
		if v.award[1].type == data.type and v.award[1].num == data.num then
			return k
		end
	end
end


--[[
	根据累计充值表获取对应的状态
]]--
function FireRebateModel:GetActivityAddState( _val )
	for k,v in pairs(self.mextend_data) do
		local numberk = tonumber(k)
		local x = numberk
		if numberk == _val then
			return v
		end
	end
	return 0
end


--[[
	根据累计充值表获取对应的状态
]]--
function FireRebateModel:SetActivityAddState( _key )
	for k,v in pairs(self.mextend_data) do
		local numberk = tonumber(k)
		if numberk == _key then
			self.mextend_data[k] = 2
		end
	end
	return 0
end





--[[
	领取界面的奖励
]]--
function FireRebateModel:getawardData( _type, _data )

end

return FireRebateModel
