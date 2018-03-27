--[[
    邮件 entity
    Author: H.X.Sun
    Date: 2015-04-25
]]
local MailEntity = qy.class("MailEntity", qy.tank.entity.BaseEntity)

function MailEntity:ctor(data)
    self.data = data
    self.model = qy.tank.model.MailModel

    --ID
    self:setproperty("id", data._id)
    --类型 (1：收信箱，2：发信箱)
    self:setproperty("cate_id", data.cate_id)
    --子类型 (1：系统邮件 2：总部贺电 3：好友邮件)
    self:setproperty("sub_cate_id", data.sub_cate_id)
    --发件人ID(系统邮件为0)
    self:setproperty("sender_id", data.sender_id)
    --发件人昵称
    self:setproperty("sender_name", data.sender_name)
    --收件人ID
    self:setproperty("receiver_id", data.receiver_id)
    --收件人昵称
    self:setproperty("receiver_name", data.receiver_name)
    --发件时间
    self:setproperty("send_time", data.send_time)
    --标题
    self:setproperty("title", tostring(data.title))
    --内容
    self:setproperty("content", tostring(data.content))
    --礼品
    self:setproperty("item", data.item)
    --是否有礼品(0 :没有 1：有)
    self:setproperty("is_item", data.is_item)
    --状态 (0：未读 、1：已读、2：已领取)
    self:setproperty("status", data.status)
    --截止时间
    self:setproperty("timelimit", data.timelimit)
    --回复
    self:setproperty("response", data.response)
end

--[[--
--是否有红点
--]]
function MailEntity:hasRedDot()
    if self.status == 0 then
        return true
    elseif self.is_item == 1 and self.status == 1 then
        return true
    else
        return false
    end 
end

--[[--
--获取装换后的时间
--]]
function MailEntity:getForMatOfSendTime()
    local tab = os.date("*t", self.send_time:get())
    return tab.year .. "-" ..tab.month .. "-" .. tab.day .."  " .. tab.hour .. " : " .. tab.min .. " : " .. tab.sec
end

--[[--
--获取icon
--]]
function MailEntity:getIcon()
    if self.status == 0 then
        return "Resources/mail/05.png"
    else
        return "Resources/mail/04.png"
    end
end

--[[--
--获取昵称文字颜色
--]]
function MailEntity:getNameTextColor()
    if self.sender_id == 0 and self.status == 0 then
        return cc.c4b(224, 56, 57, 255)
    else
        return cc.c4b(255,255,255,255)
    end
end

--[[--
--获取内容昵称文字颜色
--]]
function MailEntity:getContentNameTextColor()
    if self.sender_id == 0 then
        return cc.c4b(255,0,0,255)
    else
        return cc.c4b(255,255,255,255)
    end
end

--[[--
--获取发件人的名字
--]]
function MailEntity:getSenderName()
    return self.sender_name
    -- if self.sub_cate_id == 1 then
    --     return "系统通知"
    -- elseif self.sub_cate_id == 2 then
    --     return "总部贺电"
    -- else
        
    -- end
end

--[[--
--获取标题内容
--]]
function MailEntity:getTitleContent()
    if self.sub_cate_id == 1 then
        return self.title
    elseif self.sub_cate_id == 2 then
        return self.title
    else
        return string.sub(self.content, 0 ,42 - string.len(self:getSenderName()))
    end
end

--[[--
--获取当前的内容
--]]
function MailEntity:getCurContent()
    if self.response and self.response.content then
        local tab = os.date("*t", self.response.response_time)
        return self.content .. "\n\n--" .. qy.TextUtil:substitute(19020) .. self.response.content.. "\n"..tab.year .. "/" ..tab.month .. "/" .. tab.day .."  " .. tab.hour .. ":" .. tab.min .. ":" .. tab.sec
    else
        return self.content
    end
end

--[[--
--获取接受人得名字
--]]
function MailEntity:getReceiverName()
    if self.receiver_name then
        return self.receiver_name
    else
        return qy.TextUtil:substitute(19021)
    end
end

return MailEntity