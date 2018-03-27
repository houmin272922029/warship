--数字图片的工具类
local NumPicUtils = {}

function NumPicUtils.getNumPicInfoByType(numType)
	if numType == 1 then
		return {
			["numImg"] = "font/num/num_1.png",
			["width"] = 26.5,
			["height"] = 41,
		}
	elseif numType == 2 then
		return {
			["numImg"] = "font/num/num_2.png",
			["width"] = 30,
			["height"] = 40,
		}
	elseif numType == 3 then
		return {
			["numImg"] = "font/num/num_3.png",
			["width"] = 28,
			["height"] = 40,
		}
	elseif numType == 4 then
		return {
			["numImg"] = "font/num/num_4.png",
			["width"] = 25,
			["height"] = 35,
		}
	elseif numType == 5 then
		return {
			["numImg"] = "font/num/num_5.png",
			["width"] = 19.4,
			["height"] = 32,
		}
	elseif numType == 6 then
		return {
			["numImg"] = "font/num/num_6.png",
			["width"] = 22,
			["height"] = 27,
		}
	elseif numType == 7 then
		return {
			["numImg"] = "font/num/num_7.png",
			["width"] = 41.5,
			["height"] = 58,
		}
	elseif numType == 8 then
		return {
			["numImg"] = "font/num/num_8.png",
			["width"] = 104,
			["height"] = 151,
		}
	elseif numType == 9 then
		return {
			["numImg"] = "font/num/num_9.png",
			["width"] = 37.2,
			["height"] = 58,
		}
	elseif numType == 10 then
		return {
			["numImg"] = "font/num/num_10.png",
			["width"] = 39.3,
			["height"] = 49,
		}
	elseif numType == 11 then
		return {
			["numImg"] = "font/num/num_11.png",
			["width"] = 23,
			["height"] = 25,
		}
	elseif numType == 12 then
		return {
			["numImg"] = "font/num/num_12.png",
			["width"] = 22,
			["height"] = 30,
		}
	elseif numType == 13 then
		--战斗暴击使用
		return {
			["numImg"] = "font/num/num_13.png",
			["width"] = 33,
			["height"] = 43,
		}
	elseif numType == 14 then
		return {
			["numImg"] = "font/num/num_14.png",
			["width"] = 29.5,
			["height"] = 32,
		}
	elseif numType == 15 then
		return {
			["numImg"] = "font/num/num_15.png",
			["width"] = 29.5,
			["height"] = 32,
		}
	elseif numType == 16 then
		return {
			["numImg"] = "font/num/num_16.png",
			["width"] = 11,
			["height"] = 16,
		}
	elseif numType == 17 then
		return {
			["numImg"] = "font/num/num_17.png",
			["width"] = 22,
			["height"] = 28,
		}
	elseif numType == 18 then
		return {
			["numImg"] = "font/num/num_18.png",
			["width"] = 43,
			["height"] = 42,
		}
	elseif numType == 19 then
		return {
			["numImg"] = "font/num/num_19.png",
			["width"] = 20,
			["height"] = 18,
		}
	elseif numType == 20 then
		return {
			["numImg"] = "font/num/num_20.png",
			["width"] = 24,
			["height"] = 26,
		}
	elseif numType == 21 then
		return {
			["numImg"] = "font/num/num_21.png",
			["width"] = 24,
			["height"] = 26,
		}
	elseif numType == 22 then
		return {
			["numImg"] = "font/num/num_22.png",
			["width"] = 25,
			["height"] = 36,
		}
	elseif numType == 23 then
		return {
			["numImg"] = "font/num/num_23.png",
			["width"] = 71,
			["height"] = 82,
		}
	elseif numType == 24 then
		return {
			["numImg"] = "font/num/num_24.png",
			["width"] = 37,
			["height"] = 39,
		}
	elseif numType == 25 then
		return {
			["numImg"] = "font/num/num_25.png",
			["width"] = 33,
			["height"] = 31,
		}
	elseif numType == 26 then
		return {
			["numImg"] = "font/num/num_26.png",
			["width"] = 23,
			["height"] = 30,
		}
	end

	assert(false, qy.TextUtil:substitute(70027, numType))
end


return NumPicUtils
