--[[
	颜色映射工具
	Author: Aaron Wei
	Date: 2015-03-13 14:57:37
]]

local ColorMapUtil = {}

function ColorMapUtil.qualityMapColor(quality)
	-- 白绿蓝紫橙
	quality = tostring(quality)
	if quality == "2" then
		return cc.c4b(46, 190, 83, 255)
	elseif quality == "3" then
		return cc.c4b(36, 174, 242,255)
	elseif quality == "4" then
		return cc.c4b(172, 54, 249,255)
	elseif quality == "5" then
		return cc.c4b(255, 153, 0,255)
	elseif quality == "0" then
		return cc.c4b(164, 164, 164,255)
	elseif quality == "10" then
		return cc.c4b(216, 197, 157,255)
	elseif quality == "6" then
		return cc.c4b(251, 48, 0,255)
	elseif quality == "8" then
		return cc.c4b(251, 48, 0,255)
	elseif quality == "9" then			--9 ,10 这两个是因配件增加新品质而增加的，本身都是8红色
		return cc.c4b(251, 48, 0,255)
	elseif quality == "11" then
		return cc.c4b(251, 48, 0,255)
	end

	return cc.c4b(255,255,255,255)
end

function ColorMapUtil.qualityMapColorFor3b(quality)
	-- 白绿蓝紫橙
	if quality == 1 or quality == "1" then
		return cc.c3b(255,255,255)
	elseif quality == 2 or quality == "2" then
		return cc.c3b(46, 190, 83)
	elseif quality == 3 or quality == "3" then
		return cc.c3b(36, 174, 242)
	elseif quality == 4 or quality == "4" then
		return cc.c3b(172, 54, 249)
	elseif quality == 5 or quality == "5" then
		return cc.c3b(255, 153, 0)
	elseif quality == 6 or quality == "6" then
		return cc.c3b(251, 48, 0)
	elseif quality == 7 or quality == "7" then
		return cc.c3b(255, 255, 255)
	elseif quality == 8 or quality == "8" then
		return cc.c3b(251, 48, 0)
	end
end

--代币变化的颜色
function ColorMapUtil.tokenMapColor(nType)
	-- 白绿红
	--print("nType ==" .. nType)
	if tonumber(nType) ==1 then
		return cc.c4b(255,255,255,255)
	elseif tonumber(nType) == 2 then
		return cc.c4b(46,167,14,255)
	elseif tonumber(nType) == 3 then
		return cc.c4b(255,0,56,255)
	end
end

--公告颜色
function ColorMapUtil.getAnnounceColor(nType)
	if tonumber(nType) == 0 then
		return cc.c3b(255,255,255)
	elseif tonumber(nType) == 1 then
		return cc.c3b(255,0,56)
	end
end

return ColorMapUtil
