
DateUtil = {}

--将秒数转换为h:m形式
function DateUtil:second2hm(sec)
    local hour = math.floor(sec / 3600)
    sec = sec % 3600
    local min = math.floor(sec / 60)
    return string.format("%02d:%02d", hour, min)
end

--将秒数转换为h:m:s形式
function DateUtil:second2hms(sec)
    local hour = math.floor(sec / 3600)
    sec = sec % 3600
    local min = math.floor(sec / 60)
    sec = sec % 60
    return string.format("%02d:%02d:%02d", hour, min, sec)
end

--将秒数转换为m:s形式
function DateUtil:second2ms(sec)
    local min = math.floor(sec / 60)
    sec = sec % 60
    return string.format("%02d:%02d", min, sec)
end

-- 将秒数转换为h:m:s形式，大于一天显示x天
function DateUtil:second2dhms(sec)
    local day = math.floor(sec / (3600 * 24))
    if day > 0 then
        day = sec % (3600 * 24) == 0 and day or day + 1
        --return string.format(HLNSLocalizedString("days"), day)
        return string.format(HLNSLocalizedString("%d天"), day)
    else
        sec = sec % (3600 * 24)
        local hour = math.floor(sec / 3600)
        sec = sec % 3600
        local min = math.floor(sec / 60)
        sec = sec % 60
        return string.format("%02d:%02d:%02d", hour, min, sec)
    end
end

-- 分别获得天时分秒
function DateUtil:secondGetdhms(sec)
    local day = math.floor(sec / (3600 * 24))
    sec = sec % (3600 * 24)
    local hour = math.floor(sec / 3600)
    sec = sec % 3600
    local min = math.floor(sec / 60)
    sec = sec % 60
    return day, hour, min, sec
end

function DateUtil:formatSeedTime(sec)
    local hours = math.floor(sec / 3600)
    if hours > 0 then
        return HLNSLocalizedString("hours",hours)
    end
    local minutes = math.floor(sec / 60)
    if minutes > 0 then
        return HLNSLocalizedString("minutes",minutes)
    end
    return HLNSLocalizedString("seedDefaultTiem")
end

--将秒数转换成日期"2012-09-10 13:18:01"的形式
function DateUtil:formatTime(time)
    return os.date("%Y-%m-%d %H:%M:%S", time)
end

--将秒数转换成日期"2012-09-10 13:18:01"的形式
function DateUtil:formatTimeYMDHM(time)
    return os.date("%Y-%m-%d %H:%M", time)
end

--将秒数转换成日期"2012-09-10"的形式
function DateUtil:formatDateTime(time)
    return os.date("%Y-%m-%d", time)
end

--将秒数转换成日期"13:18:01"的形式
function DateUtil:formatTodayTime(time)
    return os.date("%H:%M:%S", time)
end

--将秒数转换成小时的形式
function DateUtil:formatHourTime(time)
    return os.date("%H", time)
end

--将时间转换成一个table
function DateUtil:time2table(time)
    return os.date("*t", time)
end

-- 将秒数转换成日期"m.d"的格式
function DateUtil:formatMMDDTime(time)
    return os.date("%m.%d", time)
end

--将日期"2012-09-10 13:18:01"转换成秒数
function DateUtil:time2long(date)
    local y, m, d, h, mi, s = string.match(date, "(%d+)-(%d+)-(%d+)%s*(%d+):(%d+):(%d+)")
    local timetable = { year = y, month = m, day = d, hour = h, min = mi, sec = s}
    return os.time(timetable)
end

-- 根据时间戳获得当天开始时间
function DateUtil:beginDay(time)
    local date = DateUtil:formatDateTime(time)
    date = string.format("%s 00:00:00", date)
    return DateUtil:time2long(date)
end

-- 补全日期
function DateUtil:dayTime2long( date )
    -- body
    local h, m, s = string.match(date, "(%d+):(%d+):(%d+)")

    local tmpTime = os.date("*t")

    local tmpTab = {year = tmpTime.year, month = tmpTime.month, day = tmpTime.day, hour = h, min = m, sec = s}

    return os.time(tmpTab)
end

-- 获得时间差 秒数 指定时间 "12:00:00" 距离现在的秒数
function DateUtil:getRemainTime4CurrentByDayTime( date )
    -- body
    local remainTime = dayTime2long(date) - os.time()
    if remainTime > 0 then
        return remainTime
    else
        return 0
    end
end