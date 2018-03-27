--[[--
--邮件 model
--Author: H.X.Sun
--Date: 2015-04-24
--]]

local MailModel = qy.class("MailModel", qy.tank.model.BaseModel)

function MailModel:init(nCateId, nPage)
    -- if self.lastCateId == nil then
    -- 	self.lastCateId = 0
    -- end
    if self.totalMailList == nil or self.lastCateId ~= nCateId then
        self.totalMailList = {}
        self.lastCateId = nCateId
        self.remainItemNum = 0
        self.listNum = 0
    end
    self.nextPage = nPage
    --self.Noticeflag = false

end

function MailModel:clearList()
    self.totalMailList = {}
end
function MailModel:getNoticeflag()
    local date = cc.UserDefault:getInstance():getIntegerForKey(qy.tank.model.UserInfoModel.userInfoEntity.kid .."LOGIN_ANNOUNCE", 0)

    if date ~= tonumber(os.date("%d",qy.tank.model.UserInfoModel.serverTime)) then
        cc.UserDefault:getInstance():setIntegerForKey(qy.tank.model.UserInfoModel.userInfoEntity.kid .."LOGIN_ANNOUNCE", tonumber(os.date("%d",qy.tank.model.UserInfoModel.serverTime)))
        return false
    end
    return true
end
-- function MailModel:setNoticeflag( type )
--     self.Noticeflag  = type
-- end

--[[-- 
--获取邮件列表
--@param date 服务器数据
--@number cateId 行为 (1：收件箱、2：发件箱、3：客服)
--]]
function MailModel:getMaillist(data, cateId)
    self:init(cateId, data.nextpage)
    -- if data.result ~= nil and data.result.list ~= nil then
    if data ~= nil and data.list ~= nil then
        local mailData = data.list
        self.add_mail_num = #mailData
        self.listNum = self.listNum + self.add_mail_num
        for i = 1, self.add_mail_num do
            local entity = qy.tank.entity.MailEntity.new(mailData[i])
            table.insert(self.totalMailList, entity)
            if entity.is_item == 1 and entity.status ~= 2 then
                self.remainItemNum = self.remainItemNum + 1
            end
        end
    end
end

function MailModel:getAddMailNum()
    if (self.add_mail_num - 1) < 0 or self:isHasNextPage() then
        return self.add_mail_num
    else
        return self.add_mail_num - 1
    end
end

--[[--
--给好友发邮件
--@param #string sName 玩家昵称
--@param #string sContent 内容
--]]
function MailModel:toFriendMail(data, sName, sContent)
    local user = qy.tank.model.UserInfoModel.userInfoEntity
    if data.result then
        self.tips = qy.TextUtil:substitute(19022)
        self.curSelectIdx = 1
        local newData = {
            ["_id"]= data.id,["cate_id"]=2,["sub_cate_id"]=2,["sender_id"]=user.uid,["sender_name"]=user.name,
            ["receiver_id"]=0,["receiver_name"]=sName,["send_time"]=os.time(),
            ["content"]=sContent,["item"]={},["is_item"]=0,["status"]=1,["timelimit"]=0}
        local entity = qy.tank.entity.MailEntity.new(newData)
        table.insert(self.totalMailList, 1, entity)
    else
        self.tips = qy.TextUtil:substitute(19023)
    end
end

--[[--
--全部删除
--]]
function MailModel:deleteAllMails(data)
    if data.result then
        self.tips = qy.TextUtil:substitute(19024)
        self.totalMailList = {}
    else
        self.tips = qy.TextUtil:substitute(19025)
    end
end

--[[--
--删除一封邮件
--]]
function MailModel:delOneMail(data, nSelectIdx)
    if data.result then
        self.tips = qy.TextUtil:substitute(19024)
        table.remove(self.totalMailList, nSelectIdx)
    else
        self.tips = qy.TextUtil:substitute(19025)
    end
end

--[[--
--领取一个邮件
--]]
function MailModel:receiveOneMail(data, nSelectIdx)
    if data.result then
        self.tips = qy.TextUtil:substitute(19024)
        self:updateMailStatus(2, nSelectIdx)
        self.remainItemNum = self.remainItemNum - 1
    else
        self.tips = qy.TextUtil:substitute(19025)
    end
end

--[[--
--领取所有邮件
--]]
function MailModel:receiveAllMails(data)
    if data.result then
        self.tips = qy.TextUtil:substitute(19024)
        self.remainItemNum = 0
        for i = 1, #self.totalMailList do
            self:updateMailStatus(2, i)
        end
    else
        self.tips = qy.TextUtil:substitute(19025)
    end
end

function MailModel:hasRedDot()
    for i = 1, #self.totalMailList do
        if self.totalMailList[i].status == 1 then
            return true
        end
    end
    return false
end

--[[--
--给客服发邮件
--@param #number nSelectIdx 选择的数组下标
--@param #string sContent 内容
--]]
function MailModel:toCustomerService(data, nSelectIdx, sContent)
    local user = qy.tank.model.UserInfoModel.userInfoEntity
    if data.result then
        self.tips = qy.TextUtil:substitute(19024)
        self.curSelectIdx = 1
        local newData = {
            ["_id"]= data.id,["cate_id"]=1,["sub_cate_id"]=1,["sender_id"]=user.uid,["sender_name"]=user.name,
            ["receiver_id"]=0,["receiver_name"]=qy.TextUtil:substitute(19021),["send_time"]=os.time(),
            ["content"]=sContent,["item"]={},["is_item"]=0,["status"]=1,["timelimit"]=0}
        local entity = qy.tank.entity.MailEntity.new(newData)
        table.insert(self.totalMailList, 1, entity)
    else
        self.tips = qy.TextUtil:substitute(19025)
    end
end

--[[--
--获取提示语
--]]
function MailModel:getTips()
    return self.tips
end


--[[--
--获取当前选择的下标
--]]
function MailModel:getCurSelectIdx()
    return self.curSelectIdx
end

--[[--
--获取是否有没领取的奖品
--]]
function MailModel:isAllItemReceived()
    if self.remainItemNum > 0 then
        return false
    else
        return true
    end
end

function MailModel:getNoticeNun()
    return #self.noticeList
end

function MailModel:getNoticeAndColor(str)
    -- print("MailModel:getNoticeAndColor ==" ..str)
    local function callBack(_subStr)
        local data = {}
        local p = string.find(_subStr, "&")
        if (not p) then
            data.str = _subStr
            data.color = 0
        else
            data.str = string.sub(_subStr, 1, p - 1)
            data.color = string.sub(_subStr, p + 1, #_subStr)
        end
        return data
    end

    local sub_str_tab = {}
    while (true) do
        local pos = string.find(str, "#")
        if (not pos) then
            sub_str_tab[#sub_str_tab + 1] = callBack(str)
            break
        end
        local sub_str = string.sub(str, 1, pos - 1)
        sub_str_tab[#sub_str_tab + 1] = callBack(sub_str)
        str = string.sub(str, pos + 1, #str)
    end

    return sub_str_tab
end

--[[--
--获取公告列表
--]]--
function MailModel:setNoticeList(data)
    -- self.noticeList = {}
    -- for i = 1, #data do
    --     local notice = {}
    --     notice["title"] = self:getNoticeAndColor(data[i]["title"])
    --     notice["content"] = self:getNoticeAndColor(data[i]["content"])
    --     notice["contentStr"] = data[i]["content"]
    --     -- notice["content"] = data[i]["content"]
    --     notice["create_time"] = self:getNoticeAndColor(data[i]["create_time"])
    --     -- notice["create_time"] = data[i]["create_time"]
    --     notice["inscribe"] = self:getNoticeAndColor(data[i]["inscribe"])
    --     -- notice["inscribe"] = data[i]["inscribe"]
    --     print("sender_name ==" .. qy.json.encode(notice))
    --     table.insert(self.noticeList, notice)
    -- end

    self.noticeList = data
end

function MailModel:setNoticeSendStatus(flag)
    self.noticeSendStatus = flag
end

function MailModel:isNoticeSend()
    return self.noticeSendStatus
end

--[[--
--获取公告内容
--]]
function MailModel:getNoticeList()
    -- self.noticeList = {}
    -- local notice = {}
    --  notice["title"] = "钢铁洪流！坦克战神封测开启公告"
    -- notice["content"] = "亲爱的玩家您好：\n        2015年战争策略游戏最强音《坦克战神》于7月15日正式开启封闭测试。汇聚中外名坦，体验硬派战争，各种坦克都有可以不同搭配的装备，同时你也可以尝试在实验室中为你的坦克研发新的科技，又或者收集各种坦克达成成就！无论是快速灵活的轻型坦克，还是火力强劲的重型坦克，包括远距离重炮狙杀的自行火炮，每种坦克都极具杀伤力，发挥你的能量，成为王牌指挥官指日可待！\n       封闭测试期间，暂不开放充值服务，但每天都将有大量钻石通过邮件奉送给各位玩家\n       客服QQ：9527"
    -- notice["inscribe"] = "《坦克战神》运营团队敬上"
    -- notice["date"] = "2015年7月15日"
    -- table.insert(self.noticeList, notice)
    return self.noticeList
end

--[[--
--更新收信箱邮件状态
--@param #number idx 所在数组的下标
--]]
function MailModel:updateMailStatus(data, idx)
    local entity = self.totalMailList[idx]
    if type(data) == "number" then
        entity.status = data
    elseif type(data) == "table" then
        entity.status = data.status
    end
end

--[[--
--获取下一页
--]]
function MailModel:getNextPage()
    if self.nextPage == nil then
        return 1
    else
        return self.nextPage
    end
end

function MailModel:isHasNextPage()
    if self.nextPage and self.nextPage > 0 then
        return true
    else
        return false
    end
end

function MailModel:getTotalMail()
    if self.nextPage and self.nextPage > 0 then
        return #self.totalMailList + 1
    else
        return #self.totalMailList
    end
end

--[[--
--获取list实体个数
--]]
function MailModel:getListNum()
    return self.listNum
end

--[[--
--设置下一页
--]]
function MailModel:setNextPage()
    self.nextPage = 1
end

return MailModel
