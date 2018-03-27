local NumberUtil = {}

local userModel = qy.tank.model.UserInfoModel

--获取资源单位自动转换后的数值：当资源大于8位时，自动变成“万”为单位的字符串，否则，依然显示当前数字
function NumberUtil:getResNumString(num)
    local cNum = tonumber(num)
    if qy.language == "en" then
        -- 英文 k
        if cNum > 9999999 then
            return math.floor(cNum/1000).."K"
        else
            return num
        end
    else
        -- 中文 W
        if cNum > 9999999 then
            return math.floor(cNum/10000).."W"
        else
            return num
        end
    end
end

--[[--
--数字刷新动画
--@param ui 动画Ui
--]]
function NumberUtil.numRefreshAnim(ui, nType)
	ui:stopAllActions()
	ui:setTextColor(cc.c4b(255,255,255,255))
	local times = 1
	local show = cc.CallFunc:create(function()
		if nType == 1 then
			ui:setTextColor(cc.c4b(46,167,14,255))
		else
			ui:setTextColor(cc.c4b(255,0,56,255))
		end
        	end)
	local callFunc = cc.CallFunc:create(function ()
		ui:setTextColor(cc.c4b(255,255,255,255))
	end)
	local scaleBig = cc.ScaleTo:create(0.1, 1.1)
	local scaleSmall = cc.ScaleTo:create(0.1, 1)
	local spawn1 = cc.Spawn:create(show,scaleBig)
	local spawn2 = cc.Spawn:create(scaleSmall,cc.DelayTime:create(0.1))

	ui:runAction(cc.Sequence:create(spawn1, spawn2, callFunc))
end

--[[--
--秒数变时间字符串
--@param #number 1 :时:分:秒(01:01:01)  2:分:秒(01:01) 3：(01时01分01秒)4：(01分01秒) 5：天时分
--]]
function NumberUtil.secondsToTimeStr(time, nType)
	local hour = math.floor(time / 3600) .. ""
	--print("hour ==" ..hour)
	local min = math.floor((time - tonumber(hour) * 3600) / 60) .. ""
	local seconds = time - tonumber(hour )* 3600 - tonumber(min) * 60
	if string.len(hour) == 1 then
		hour = "0" .. hour
	end
	if string.len(min) == 1 then
		min = "0" .. min
	end
	if string.len(seconds) == 1 then
		seconds = "0" .. seconds
	end
	if nType == nil then
		nType = 1
	end

	if nType == 1 then
  		return hour .. ":" .. min .. ":" .. seconds
  	elseif nType == 2 then
  		return  min .. ":" .. seconds
  	elseif nType == 3 then
  		return hour .. qy.TextUtil:substitute(70024) .. min .. qy.TextUtil:substitute(70025) .. seconds .. qy.TextUtil:substitute(70026)
  	elseif nType == 4 then
  		return min .. qy.TextUtil:substitute(70025) .. seconds .. qy.TextUtil:substitute(70026)
  	elseif nType == 5 then
  		if tonumber(hour) > 24 then
  			local _day = math.floor(tonumber(hour) / 24)
  			local _hour = tonumber(hour) % 24
  			if string.len(_hour) == 1 then
				_hour = "0" .. _hour
			end
			   return _day .. qy.TextUtil:substitute(70023) .. _hour ..qy.TextUtil:substitute(70024) ..min .. (qy.InternationalUtil:isShow2())
  		else
			   return hour ..qy.TextUtil:substitute(70024) ..min ..(qy.InternationalUtil:isShow2())
  		end
  	elseif nType == 6 then
  		if tonumber(hour) > 24 then
  			local _day = math.floor(tonumber(hour) / 24)
  			local _hour = tonumber(hour) % 24
  			if string.len(_hour) == 1 then
				_hour = "0" .. _hour
			end
			return _day .. qy.TextUtil:substitute(70023) .. _hour ..":" ..min .. ":" .. seconds
  		else
			return hour ..":" ..min .. ":" .. seconds
  		end
    elseif nType == 7 then
        if tonumber(hour) > 24 then
            local _day = math.floor(tonumber(hour) / 24)
            return _day .. qy.TextUtil:substitute(70023)
  		elseif tonumber(hour) == 0 then
            return tonumber(min) .. qy.TextUtil:substitute(70016)
        else
            return tonumber(hour) ..qy.TextUtil:substitute(70015)
  		end
    elseif nType == 8 then
        local _day = 0
        local _hour = 0
        if tonumber(hour) > 24 then
            _day = math.floor(tonumber(hour) / 24)
            _hour = tonumber(hour) - 24 * _day
        else
            _hour = hour
        end
        local str = ""
        str = _day .. qy.TextUtil:substitute(70023)
        str = str .. _hour .. qy.TextUtil:substitute(70015)
        str = str .. min .. qy.TextUtil:substitute(70025)
        str = str .. seconds .. qy.TextUtil:substitute(70026)
        return str
    elseif nType == 9 then
        local _day = 0
        local _hour = 0
        if tonumber(hour) > 24 then
            _day = math.floor(tonumber(hour) / 24)
            _hour = tonumber(hour) - 24 * _day
        else
            _hour = hour
        end
        local str = ""

        if tonumber(_day) > 0 then
          str = _day .. qy.TextUtil:substitute(70023)
        end        

        if tonumber(_hour) > 0 then
          str = str .. _hour .. qy.TextUtil:substitute(70015)
        end        

        str = str .. min .. qy.TextUtil:substitute(70025)
        str = str .. seconds .. qy.TextUtil:substitute(70026)
        return str
  	end
end

--[[--
    是否是另一天
    _oldTimes:和现在对比的时间（单位：秒）
--]]
function NumberUtil.isOtherDay(_oldTimes)
    if tonumber(_oldTimes) == nil then
        _oldTimes = 0
    end
    local day1 = os.date("%x",_oldTimes)
    local day2 = os.date("%x",userModel.serverTime)

    if day1 ~= day2 then
        return true
    else
        return false
    end
end


return NumberUtil
