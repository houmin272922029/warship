--[[
    Lua 标准库拓展
]]
-- 计算表中字段数量
function table.nums(t)
    local count = 0
    for k, v in pairs(t) do
        count = count + 1
    end
    return count
end

-- 检查并尝试转换为数值，如果无法转换则返回 0
function checknumber(value, base)
    return tonumber(value, base) or 0
end

-- 格式化数值
-- use: string.formatnumberthousands(1924235) 1,924,235
function string.formatnumberthousands(num)
    local formatted = tostring(checknumber(num))
    local k
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then break end
    end
    return formatted
end

-- 用指定字符或字符串切割，返回包含分割结果的数据
-- use: local input = "Hello,World"
--      local res = string.split(input, ",")
--      res = {"Hello", "World"}
function string.split(input, delimiter)
    input = tostring(input)
    delimiter = tostring(delimiter)
    if (delimiter=='') then return false end
    local pos,arr = 0, {}
    -- for each divider found
    for st,sp in function() return string.find(input, delimiter, pos, true) end do
        table.insert(arr, string.sub(input, pos, st - 1))
        pos = sp + 1
    end
    table.insert(arr, string.sub(input, pos))
    return arr
end

-- 从表格中查找指定值，返回其索引，如果没找到返回 false
function table.indexof(array, value, begin)
    for i = begin or 1, #array do
        if array[i] == value then return i end
    end
    return false
end

-- 从表格中查找指定值，返回其 key，如果没找到返回 nil
function table.keyof(hashtable, value)
    for k, v in pairs(hashtable) do
        if v == value then return k end
    end
    return nil
end

-- 使用cocos studio导出的lua中Text组件的自定义大小存在bug，暂时使用该方法解决
function ccui.Text:fixSize(size)
    self:ignoreContentAdaptWithSize(false)
    self:setTextAreaSize(size)
end

-- 设置行高
function ccui.Text:setLineHeight(lineHeight)
    self:getVirtualRenderer():setLineHeight(lineHeight)
end

local ccs_ArmatureAnimation_playWithIndex = ccs.ArmatureAnimation.playWithIndex
function ccs.ArmatureAnimation:playWithIndex(animationIndex, durationTo, loop)
    self:setSpeedScale(0.5)
    if self:getMovementCount() == 1 then
        animationIndex = 0
    end
    if durationTo and loop then
        ccs_ArmatureAnimation_playWithIndex(self, animationIndex, durationTo, loop)
    elseif durationTo then
        ccs_ArmatureAnimation_playWithIndex(self, animationIndex, durationTo)
    else
        ccs_ArmatureAnimation_playWithIndex(self, animationIndex)
    end
end