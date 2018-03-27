--[[
	文本Util
]]
local TextUtil = {}


--[[
	自动换行
	text  ccui.text
	size cc.size
]]
function TextUtil:autoChangeLine(text , size)
	text:ignoreContentAdaptWithSize(false)
	text:setTextAreaSize(size)
end

--[[--
--下划线
--@param #ccui.Text text 目标控件
-- @param #cc.p pos 开始位置
--]]
function TextUtil:drawLine(text)
	local beginPos = cc.p(text:getPosition())
	local anchor = text:getAnchorPoint()
	local endX = (1 - anchor.x) * text:getContentSize().width + beginPos.x
	local endPos = cc.p(endX, beginPos.y)
	local line = cc.DrawNode:create()
	line:drawLine(beginPos,endPos, cc.c4b(255,0,0,255))
	line:setPosition(beginPos)

	-- local line = cc.DrawPrimitives.drawLine(beginPos,endPos)
	-- local line = cc.DrawPrimitives:drawLine(beginPos,endPos, {255,255,255,255})
	text:addChild(line)
end

-- 格式化字符串 （出理 \r  等特殊功能）
function TextUtil:format(text)
	local temp1 = string.gsub(text, "\\r", "      ")
	local temp2 = string.gsub(temp1, "\\n", "\n")
	return temp2
end

--[[--
--国际化文字
	@param key 目标文字的key
	@param 要代替的文字
	qy.TextUtil:substitute(1001,"a","b")
	qy.TextUtil:substitute(1001)
--]]

function TextUtil:substitute(key, ...)
	local str = qy.Config.lua_text[tostring(key)][qy.language]
	if ... then
		return string.format(str, ...)
	else
		return str
	end
end
-- @function StringSplit lua字符串分割函数    
-- @param str 待分割的字符串  
-- @param splitStr 用于分割字符串  
-- @param addNemptyStr 是否将空字符串也放入返回字串表中（默认false,可空）  
-- @param addSplitStrInTable 是否将分割用的字符串加入数组（默认false,可空）  
-- @return 分割后字符串Table  
-- Create by lijain  
function TextUtil:StringSplit(str, splitStr,addNemptyStr,addSplitStrInTable)  
    if not addNemptyStr then addNemptyStr = false end  
    if not addSplitStrInTable then addSplitStrInTable = false end  
    local subStrTab = {};  
    while (true) do  
        local pos = string.find(str, splitStr);  
        if (not pos)  then  
            if str ~="" or addNemptyStr then  
                subStrTab[#subStrTab + 1] = str;  
            end  
            break;  
        end  
        local subStr = string.sub(str, 1, pos - 1);  
        if subStr~="" or addNemptyStr then  
            subStrTab[#subStrTab + 1] = subStr;  
        end  
        if addSplitStrInTable then  
            subStrTab[#subStrTab + 1] = splitStr;  
        end  
        str = string.sub(str, pos +string.len(splitStr) , #str);  
    end  
    return subStrTab;  
end 
return TextUtil
