maildata = {
    mails = {}
}

--重置用户数据
function maildata:resetAllData()
    maildata.mails = {}
end


function maildata:fromDic(dic)
    if not maildata.mails then
        maildata.mails = {}
    end
    if dic then
        maildata.mails = dic
    end
end

-- 获取上次看邮件时间
function maildata:getCheckTime()
    local key = "mail_"..userdata.serverCode.."_"..userdata.userId
    local ts = getUDInteger(key)
    return ts
end

-- 获得最新邮件的时间戳
function maildata:getNewMailTime()
    local ts = maildata:getCheckTime()
    for k,v in pairs(maildata.mails) do
        if v.time > ts then
            ts = v.time
        end
    end
    return ts
end

-- 写入查看邮件时间
function maildata:setCheckTime(ts)
    local key = "mail_"..userdata.serverCode.."_"..userdata.userId
    setUDInteger(key, ts)
end

-- 获得新邮件
function maildata:getNewMail()
    local ts = maildata:getCheckTime()
    local count = 0
    for k,v in pairs(maildata.mails) do
        if v.position == 0 or v.position == 2 then
            -- 系统
            if v.time > ts then
                count = count + 1
            end
        elseif v.position == 1 then
            if v.state == 0 then
                count = count + 1
            end
        end
    end
    return count
end

-- 获得系统新邮件
function maildata:getSysNewMail(  )
    local ts = maildata:getCheckTime()
    local count = 0
    for k,v in pairs(maildata.mails) do
        if v.position == 0 then
            -- 系统
            if v.time > ts then
                count = count + 1
            end
        end
    end
    return count
end

-- 获得系统新邮件
function maildata:getAwardNewMail(  )
    local ts = maildata:getCheckTime()
    local count = 0
    for k,v in pairs(maildata.mails) do
        if v.position == 1 then
            if v.state == 0 then
                count = count + 1
            end
        end
    end
    return count
end

-- 获得留言新邮件
function maildata:getMesgNewMail(  )
    local ts = maildata:getCheckTime()
    local count = 0
    for k,v in pairs(maildata.mails) do
        if v.position == 2 then
            -- 系统
            if v.time > ts then
                count = count + 1
            end
        end
    end
    return count
end


function maildata:getMailList()
    local function getMailCallback(url, rtnData)
        if rtnData.info.result then
            for k,v in pairs(rtnData.info.result) do
                maildata.mails[k] = v
            end
            postNotification(NOTI_REFRESH_MAILCOUNT, nil)
        end
    end
    doActionNoLoadingFun("GET_MAIL_DATA", {maildata:getNewMailTime()}, getMailCallback)
end




