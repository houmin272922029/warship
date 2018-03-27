--[[
    邮件 service
    Author: H.X.Sun
    Date: 2015-04-25
]]


local MailService = qy.class("MailService", qy.tank.service.BaseService)

MailService.model = qy.tank.model.MailModel

--[[--
--获取邮件列表
--@number cateId 界面行为 (1：收件箱、2：发件箱)
--]]
function MailService:getMaillist(cateId, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "mail.action",
        ["p"] = {["sub_act"] = "getlist", ["page"] = self.model:getNextPage(), ["cate_id"] = cateId,["ftue"] = qy.GuideModel:getCurrentBigStep()}
    })):send(function(response, request)
        self.model:getMaillist(response.data, cateId)
        callback(response.data)
    end) 
end

--[[--
--给好友发邮件
--@param #string sName 玩家昵称
--@param #string sContent 内容
--]]
function MailService:toFriendMail(sName, sContent, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "mail.action",
        ["p"] = {sub_act = "addFriendMail", receiver_name = sName,  content = sContent}
    })):send(function(response, request)
        self.model:toFriendMail(response.data, sName, sContent)
        callback(response.data)
    end)
end

--[[--
--删除所有邮件
--@number cateId 界面行为 (1：收件箱、2：发件箱)
--]]
function MailService:deleteAllMails(nCateId, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "mail.action",
        ["p"] = {sub_act = "delAllMails", cate_id = nCateId}
    })):send(function(response, request)
        self.model:deleteAllMails(response.data)
        callback(response.data)
    end)
end

--[[--
--删除一封邮件
--@param #number nMailId 邮件ID
--@param #number nSelectIdx 选择的数组下标
--]]
function MailService:delOneMail(nMailId, nSelectIdx, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "mail.action",
        ["p"] = {sub_act = "delOneMail", mail_id = nMailId}
    })):send(function(response, request)
        self.model:delOneMail(response.data, nSelectIdx)
        callback(response.data)
    end)
end

--[[--
--全部领取
--]]
function MailService:receiveAllMails(param, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "mail.action",
        ["p"] = {sub_act = "receiveAllMail"}
    })):send(function(response, request)
        self.model:receiveAllMails(response.data)
         if response.data.result then
            qy.tank.command.AwardCommand:add(response.data.award)
            qy.tank.command.AwardCommand:show(response.data.award)
        end
        if response.data.red_point then
            qy.tank.model.RedDotModel:updateMailRedDot(response.data.red_point)
        end
        callback(response.data)
        qy.RedDotCommand:emitSignal(qy.RedDotType.M_TAB,false)
    end)
end

--[[--
--领取一个奖励
--]]
function MailService:receiveOneMail(nMailId, nSelectIdx, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "mail.action",
        ["p"] = {["sub_act"] = "receiveOneMail", ["mail_id"] = nMailId,["ftue"] = qy.GuideModel:getCurrentBigStep()}
    })):send(function(response, request)
        self.model:receiveOneMail(response.data, nSelectIdx)
        if response.data.result then
            qy.tank.command.AwardCommand:add(response.data.award)
            qy.tank.command.AwardCommand:show(response.data.award)
        end
        if response.data.red_point then
            qy.tank.model.RedDotModel:updateMailRedDot(response.data.red_point)
        end
        callback(response.data)
        qy.RedDotCommand:emitSignal(qy.RedDotType.M_TAB,self.model:hasRedDot(),true)
    end)
end

--[[--
--获取客服邮件列表
--@number cateId 界面行为 (1：客服)
--]]
function MailService:getCustomServiceList(nCateId, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "mail.gmaction",
        ["p"] = {sub_act = "getlist", page = self.model:getNextPage(), cate_id = cateId}
    })):send(function(response, request)
        self.model:getMaillist(response.data, 3)
        callback(response.data)
    end)
end

--[[--
--给客服发邮件
--@param #number nSelectIdx 选择的数组下标
--@param #string sContent 内容
--]]
function MailService:toCustomerService(nSelectIdx, sContent, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "mail.gmaction",
        ["p"] = {sub_act = "sendMail",title = "", content = sContent}
    })):send(function(response, request)
        self.model:toCustomerService(response.data,nSelectIdx, sContent)
        callback(response.data)
    end)
end

--[[--
--打开邮件
--@param #number nMailId 邮件ID
--]]
function MailService:changeMailStatus(nMailId, nSelectIdx, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "mail.action",
        ["p"] = {sub_act = "setStatus",mail_id = nMailId}
    }))
    :setShowLoading(false)
    :send(function(response, request)
        self.model:updateMailStatus(response.data,nSelectIdx, sContent)
        if response.data.red_point then
            qy.tank.model.RedDotModel:updateMailRedDot(response.data.red_point)
        end
        callback(response.data)
    end)
end

--[[--
--删除一封客服邮件
--@param #number nMailId 邮件ID
--@param #number nSelectIdx 选择的数组下标
--]]
function MailService:delOneCustomerServiceMail(nMailId, nSelectIdx, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "mail.gmaction",
        ["p"] = {sub_act = "delOneMail", mail_id = nMailId}
    })):send(function(response, request)
        self.model:delOneMail(response.data, nSelectIdx)
        callback(response.data)
    end)
end

--[[--
--删除所有客服邮件
--@number cateId 界面行为 (1：收件箱、2：发件箱)
--]]
function MailService:deleteAllCustomerServiceMail(param, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "mail.gmaction",
        ["p"] = {sub_act = "delAllMails"}
    })):send(function(response, request)
        self.model:deleteAllMails(response.data)
        callback(response.data)
    end)
end

--[[--
--获取公告列表
--]]
function MailService:getNoticeList(param, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Announcement.getList",
        ["p"] = {}
    })):send(function(response, request)
        self.model:setNoticeList(response.data.list)
        callback(response.data.list)
    end)
end

function MailService:changeCustomerMailStatus(nMailId, nSelectIdx,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Mail.gmAction",
        ["p"] = {sub_act = "setStatus",mail_id = nMailId}
    }))
    -- :setShowLoading(false)
    :send(function(response, request)
        self.model:updateMailStatus(response.data,nSelectIdx, sContent)
        if response.data.red_point then
            qy.tank.model.RedDotModel:updateMailRedDot(response.data.red_point)
        end
        callback(response.data)
    end)
end


return MailService
