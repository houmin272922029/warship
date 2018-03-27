--[[
    时间格式化类
    
]]
local DateFormatUtil = class("DateFormatUtil")

--[[
    参数：以秒为单位的时间值
    type 为nil 
        返回 时分秒 00:00:00
    type 为 1
        返回  天 时分秒  0天小时0分钟

]]
function DateFormatUtil:toDateString(t , type)
    local timeStr
    local time = t
    local day = math.floor(time / 3600/24) .. ""
    if type ~= nil then
        if type == 1 or type == 2 then
            time = time - tonumber(day)*24*3600
        end
    end
    local hour =   math.floor(time / 3600) .. ""
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
    if type == nil then 
        timeStr = hour .. ":" .. min .. ":" .. seconds
    elseif type ==1 then
        timeStr = day..qy.TextUtil:substitute(70014)..hour .. qy.TextUtil:substitute(70015) .. min .. (qy.InternationalUtil:isShow1())
    elseif type == 2 then
        timeStr = day.. "d"..hour .. "h" .. min .. "min"
    elseif type == 3 then
        local hour =   math.floor((time % 86400) / 3600) .. ""
        timeStr = day..qy.TextUtil:substitute(70014)..hour .. qy.TextUtil:substitute(70015) .. min .. qy.TextUtil:substitute(70016) .. seconds .. qy.TextUtil:substitute(70017)
    elseif type == 4 then
        local hour =   math.floor((time % 86400) / 3600)
        if tonumber(day) > 0 then
            timeStr = day.. "d "..hour .. ":" .. min .. ":" .. seconds
        else
            timeStr = hour .. ":" .. min .. ":" .. seconds
        end
    elseif type == 5 then
        timeStr = min .. ":" .. seconds
    elseif type == 6 then
        local hour =   math.floor((time % 86400) / 3600)
        timeStr = hour .. ":" .. min .. ":" .. seconds
    elseif type == 7 then
        local hour =   math.floor((time % 86400) / 3600)
        timeStr = day.. qy.TextUtil:substitute(23005) .." "..hour .. ":" .. min .. ":" .. seconds
    elseif type == 8 then
        local hour =   math.floor((time % 86400) / 3600) + tonumber(day) * 24
        timeStr = hour .. ":" .. min .. ":" .. seconds
    end
    return timeStr
end

function DateFormatUtil:toDateString1(t,type)
    local timeStr
    local time = t
    local day = math.floor(time/3600/24) .. ""
    time = time%(3600*24)
    local hour =   math.floor(time/3600) .. ""
    time = time%3600
    local min = math.floor(time/60) .. ""
    time = time%60
    local sec = time .. ""
    if string.len(hour) == 1 then
        hour = "0" .. hour
    end
    if string.len(min) == 1 then
        min = "0" .. min
    end
    if string.len(sec) == 1 then
        sec = "0" .. sec
    end
    if type == nil then 
        timeStr = day .. ":" .. hour .. ":" .. min .. ":" .. sec
    elseif type ==1 then
        timeStr = day .. qy.TextUtil:substitute(70014) .. hour .. qy.TextUtil:substitute(70015) .. min .. qy.TextUtil:substitute(70016) .. sec .. qy.TextUtil:substitute(70017)
    elseif type == 2 then
        timeStr = day .. "d" .. hour .. "h" .. min .. "m" .. sec .. "s"
    elseif type == 3 then
        timeStr = hour .. qy.TextUtil:substitute(70015) .. min .. qy.TextUtil:substitute(70016)
    end
    return timeStr
end

return DateFormatUtil