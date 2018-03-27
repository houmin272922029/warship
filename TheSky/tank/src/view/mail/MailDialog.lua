--[[
    邮件
    Author: H.X.Sun
    Date: 2015-04-23
]]

local MailDialog = qy.class("MailDialog", qy.tank.view.BaseDialog, "view/mail/MailDialog")

local CELL_HEIGHT = 103

function MailDialog:ctor(delegate)
    MailDialog.super.ctor(self)
    -- 通用弹窗样式
    local style = qy.tank.view.style.DialogStyle2.new({
        size = cc.size(895,600),
        position = cc.p(0,0),
        offset = cc.p(0,0),
        titleUrl = "Resources/common/title/mail_title.png",

        ["onClose"] = function()
            self.model:setNoticeSendStatus(false)
            self:dismiss()
        end
    })
    self:addChild(style)

    -- 内容样式
    self.model = qy.tank.model.MailModel
    self.views = {}
    self:InjectView("panel")
    self:InjectView("notice")
    self:InjectView("message")
    self:InjectView("messageList")
    self:InjectView("wirteBg")
    self:InjectView("readBg")
    self:InjectView("readList")
    self:InjectView("listEmptyTips")
    self:InjectView("panel_c")
    -- self:InjectView("noticeList")
    self:InjectView("scrollView")
    ------------------------------------
    self:InjectView("senderName")
    self:InjectView("readList")
    self:InjectView("sendContent")
    -- self:InjectView("receiverName")
    -- 这里之前是用的TextFild控件 由于弹出的键盘挡住输入的文字 暂时换成EditBox
    self:InjectView("receiveContent")
    self:InjectView("wirteList")
    self:InjectView("sendTitle")
    self:InjectView("hasReceiveTip")
    self.hasReceiveTip:setVisible(false)
    ------------------------------------
    self:InjectView("newMessageBtn")
    self:InjectView("allOperationBtn")
    self:InjectView("delteleBtn")
    self:InjectView("replyBtn")
    ------------------------------------
    self:InjectView("new_msg_title")
    self:InjectView("all_op_title")
    self:InjectView("delete_title")
    self:InjectView("reply_title")
    ------------------------------------
    self.receiverName = ccui.EditBox:create(cc.size(300, 80), "Resources/common/bg/c_12.bg")
    self.receiverName:setPosition((qy.InternationalUtil:getMailDialogReceiverNameX()),264)
    self.receiverName:setAnchorPoint(0,0.5)
   	self.receiverName:setFontSize(qy.InternationalUtil:getMailDialogReceiverNameFontSize())
   	self.receiverName:setPlaceholderFontSize(qy.InternationalUtil:getMailDialogReceiverNameFontSize())
    self.receiverName:setPlaceHolder(qy.TextUtil:substitute(19001))
   	self.receiverName:setInputMode(6)
    if self.receiverName.setReturnType then
        self.receiverName:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    end
    self.wirteList:addChild(self.receiverName)

    -- self.receiveContent = ccui.EditBox:create(cc.size(390, 235), "Resources/common/bg/c_12.bg")
    -- self.receiveContent:setPosition(21,240)
    -- self.receiveContent:setAnchorPoint(0,1)
    -- self.receiveContent:setFontSize(qy.InternationalUtil:getMailDialogReceiverNameFontSize())
    -- self.receiveContent:setPlaceholderFontSize(qy.InternationalUtil:getMailDialogReceiverNameFontSize())
    -- self.receiveContent:setPlaceHolder("请输入内容")
    -- if self.receiveContent.setReturnType then
    --     self.receiveContent:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    -- end
    -- self.wirteList:addChild(self.receiveContent)

    self.receiveContent:setPlaceHolderColor(cc.c4b(94, 10, 9, 255))
    local function editboxEventHandler(event)
        if event.name == "ATTACH_WITH_IME" then
            -- 当编辑框获得焦点并且键盘弹出的时候被调用
            self:setPositionY(self:getPositionY() + 200)
            print("ATTACH_WITH_IME")
        elseif event.name == "DETACH_WITH_IME" then
            -- 当编辑框失去焦点并且键盘消失的时候被调用
            self:setPositionY(self:getPositionY() - 200)
            print("DETACH_WITH_IME")
        end
    end
    self.receiveContent:onEvent(editboxEventHandler)

    if delegate == nil or delegate.defaultIdx == nil then
        delegate = {}
        delegate.defaultIdx = 1
    end

    self.delegate = delegate

    self.tab = qy.tank.widget.TabButtonGroup.new("widget/TabButton1",{qy.TextUtil:substitute(19002), qy.TextUtil:substitute(19003), qy.TextUtil:substitute(19004), qy.TextUtil:substitute(19005)},cc.size(190,67),"h",function(idx)
        self:createContent(idx)
    end, delegate.defaultIdx)
    self.tab_2 = self.tab.btns[2]
    self.tab_4 = self.tab.btns[4]
    self.panel:setLocalZOrder(1)
    self.panel:setSwallowTouches(false)
    self.panel:addChild(self.tab)
    self.tab:setPosition(43,452)
    self.tab:setLocalZOrder(4)

    self.btnTab2 = self.tab.btns[2].button

    --领取\发送\回复
    self:OnClick("replyBtn", function (sendr)
        self:replyLogic(self)
    end)

    --重置\删除
    self:OnClick("delteleBtn", function (sendr)
        self:delegateLogic(self)
    end)

    --新建邮件
    self:OnClick("newMessageBtn", function (sendr)
        if self.curTab == 4 then
            self:changeBtnStatus(3)
            self:changeReplyBtnTouchProperty()
            self.notice:setVisible(false)
            self.notice:setLocalZOrder(2)
            self.message:setVisible(true)
            self.message:setLocalZOrder(3)
            self:messageMoveAnim(4)
            self.receiveContent:setString("")
        elseif self.replyAction ~= 2 then
            self.tab:switchTo(3)
        end
    end)

    --全部领取\全部删除
    self:OnClick("allOperationBtn", function (sendr)
        self:allOperationLogic(self)
    end)
end


--[[--
--全部领取\全部删除
--]]
function MailDialog:allOperationLogic()
    if self.model:isAllItemReceived() then
        --全部删除
        if #self.model.totalMailList == 0 then
            qy.hint:show(qy.TextUtil:substitute(19006))
        elseif self.curTab == 4 then
            local service = qy.tank.service.MailService
            service:deleteAllCustomerServiceMail(nil, function(data)
                self:aferDeleteMail(data,1)
            end)
        else
            local service = qy.tank.service.MailService
            service:deleteAllMails(self.curTab - 1, function(data)
                self:aferDeleteMail(data,1)
            end)
        end
    else
        --全部领取
        local service = qy.tank.service.MailService
        service:receiveAllMails(nil, function(data)
            self:aferReceiveMail(data)
        end)
    end
end

--[[--
--删除\重置
--]]
function MailDialog:delegateLogic()
    if self.delegateAction == 1 then
        --删除邮件
        if self.curTab == 4 then
            local service = qy.tank.service.MailService
            service:delOneCustomerServiceMail(self.curMainId, self.selectIdx + 1, function(data)
                self:aferDeleteMail(data,2)
            end)
        else
            local entity = self.model.totalMailList[self.selectIdx + 1]
            if #self.model.totalMailList == 0 then
                qy.hint:show(qy.TextUtil:substitute(19006))
            elseif entity.is_item == 1 and entity.status ~= 2 then
                qy.hint:show(qy.TextUtil:substitute(19007))
            else
                local service = qy.tank.service.MailService
                service:delOneMail(self.curMainId, self.selectIdx + 1, function(data)
                    self:aferDeleteMail(data,2)
                end)
            end
        end
    else
        --重置
        if self.curTab < 4 then
            --收信人
            self.receiverName:setText("")
        end
        --内容
        self.receiveContent:setString("")
    end
end

--[[--
--领取\发送\回复
--]]
function MailDialog:replyLogic(self)
    if self.replyAction == 1 then
        --领取奖品
        local service = qy.tank.service.MailService
        service:receiveOneMail(self.curMainId,self.selectIdx + 1,  function(data)
            self:aferReceiveMail(data)
            qy.GuideManager:next(123445)
        end)
    elseif self.replyAction == 2 then
        --发送消息
        local name = self.receiverName:getText()
        print("输入玩家姓名：".. name .. " [长度：".. string.len(name) .. "]")
        local content = self.receiveContent:getString()
        print("输入内容：".. content .. " [长度：".. string.len(content) .. "]")
        if string.len(name) == 0 then
            qy.hint:show(qy.TextUtil:substitute(19012))
        elseif string.len(content) == 0 then
            qy.hint:show(qy.TextUtil:substitute(19013))
        elseif string.len(name) > 14 * 3 then
            qy.hint:show(qy.TextUtil:substitute(19014))
        elseif string.len(content) > 230 * 3 then
            qy.hint:show(qy.TextUtil:substitute(19015))
        else
            if self.curTab == 4 then
                --发给客服
                local service = qy.tank.service.MailService
                service:toCustomerService(self.selectIdx + 1, content, function(data)
                    self:afterSendMail(data)
                end)
            elseif qy.tank.model.UserInfoModel.userInfoEntity.level >= 50 then
                --发给好友
                local service = qy.tank.service.MailService
                service:toFriendMail(name,content, function(data)
                    self:afterSendMail(data)
                end)
            else
                qy.hint:show(qy.TextUtil:substitute(90275, 50))
            end
        end
    elseif self.replyAction == 3 then
        --回复--跳到写信界面
        if self.animAction ~= 3 then
            self:messageMoveAnim(3)
        end
        self:changeTextProperty(self.entity, 2)
        self.replyAction = 2
    end
end

--[[--
--删除之后
--]]
function MailDialog:aferDeleteMail(data,nType)
    qy.hint:show(self.model:getTips())
    if data.result then
        if nType == 1 then
            self.selectIdx = -1
        else
            self.selectIdx = 0
        end
        self:reloadTableViewData(self.currentView)
    end
end

--[[[--
--领取奖励后
--]]
function MailDialog:aferReceiveMail(data)
    if data.result then
        self:reloadTableViewData(self.currentView)
    else
        qy.hint:show(self.model:getTips())
    end
end

--[[--
--发送信件成功
--]]
function MailDialog:afterSendMail(data)
    qy.hint:show(self.model:getTips())
    if data.result then
        self.selectIdx = 0
        self:reloadTableViewData(self.currentView)
        self:messageMoveAnim(2)
    end
end

function MailDialog:createContent(_idx)
    self.model:setNextPage(1)
    self.model:clearList()

    self.curTab = _idx
    if _idx == 1 then
        self.notice:setVisible(true)
        self.notice:setLocalZOrder(5)
        self.message:setVisible(false)
        self.message:setLocalZOrder(2)
        self:runAction(cc.Sequence:create(
            cc.DelayTime:create(0.1),
            cc.CallFunc:create(function()
                self:sendNoticeMsg()
            end)
        ))
    else
        if _idx == 3 or _idx == 4 then
            --发送个人\客服邮件
            self:changeBtnStatus(3)
        end
        self:changeReplyBtnTouchProperty()
        self.notice:setVisible(false)
        self.notice:setLocalZOrder(2)
        self.message:setVisible(true)
        self.message:setLocalZOrder(3)
        self:messageMoveAnim(_idx)
        self:sendListMsg(_idx, 1)
    end
end

--[--
--发送公告消息
--]
function MailDialog:sendNoticeMsg()
    if not self.model:isNoticeSend() then
        local service = qy.tank.service.MailService
        service:getNoticeList(nil,function(data)
            self.model:setNoticeSendStatus(true)
            self:createNoticeView()
        end)
    else
    end
end

function MailDialog:createNoticeView()
    if not tolua.cast(self.dynamic_c,"cc.Node") then
        self.dynamic_c = cc.Layer:create()
        self.dynamic_c:setAnchorPoint(0,1)
        self.dynamic_c:setTouchEnabled(false)
    end

    local X_1 = 400
    local X_2 = 0
    local X_3 = 800

    local h = 20
    -- local item = nil
    local titleBg = {}
    local titleTxt = {}
    local contentTxt = {}
    local inscribeTxt = {}
    local dateTxt = {}
    local line = {}

    local noticeList = self.model:getNoticeList()
    for i =1, #noticeList do
        titleBg[i] = cc.Sprite:createWithSpriteFrameName("Resources/mail/08.png")
        titleBg[i]:setPosition(X_1, -h -15)
        self.dynamic_c:addChild(titleBg[i])

        titleTxt[i] = ccui.Text:create(noticeList[i].title,qy.res.FONT_NAME,24)
        titleTxt[i]:setContentSize(0,0)
        titleTxt[i]:setPosition(X_1, -h)
        h = h + titleTxt[i]:getContentSize().height + 23
        titleTxt[i]:setAnchorPoint(0.5,1)
        self.dynamic_c:addChild(titleTxt[i])

        contentTxt[i] = ccui.Text:create(noticeList[i].content,qy.res.FONT_NAME_2,20)
        contentTxt[i]:ignoreContentAdaptWithSize(true)
        contentTxt[i]:getVirtualRenderer():setLineHeight(28)

        contentTxt[i]:getVirtualRenderer():setDimensions(800,0)
        local size = contentTxt[i]:getVirtualRenderer():getContentSize()
        contentTxt[i]:ignoreContentAdaptWithSize(false)
        contentTxt[i]:setContentSize(size)
        contentTxt[i]:setPosition(cc.p(X_2, -h))
        h = h + size.height + 13

        contentTxt[i]:setAnchorPoint(0,1)
        self.dynamic_c:addChild(contentTxt[i])

        inscribeTxt[i] = ccui.Text:create(noticeList[i].inscribe,qy.res.FONT_NAME,20)
        inscribeTxt[i]:setContentSize(0,0)
        inscribeTxt[i]:setPosition(X_3, -h)
        h = h + inscribeTxt[i]:getContentSize().height
        inscribeTxt[i]:setAnchorPoint(1,1)
        self.dynamic_c:addChild(inscribeTxt[i])

        dateTxt[i] = ccui.Text:create(noticeList[i].create_time,qy.res.FONT_NAME_2,20)
        dateTxt[i]:setContentSize(0,0)
        dateTxt[i]:setPosition(X_3, -h - 5)
        h = h + dateTxt[i]:getContentSize().height + 40
        dateTxt[i]:setAnchorPoint(1,1)
        self.dynamic_c:addChild(dateTxt[i])

        line[i] = cc.Sprite:createWithSpriteFrameName("Resources/mail/09.png")
        line[i]:setPosition(X_1, -h)
        self.dynamic_c:addChild(line[i])
        h = h + line[i]:getContentSize().height
    end

    self.dynamic_c:setContentSize(800,h)
    self.dynamic_c:setPosition(X_2,h)
    self.scrollView:addChild(self.dynamic_c)
    self.scrollView:setScrollBarEnabled(false)
    if h < 450 then
        local diss = 450 - h
        for i =1, #noticeList do
            titleBg[i]:setPosition(X_1,titleBg[i]:getPositionY()+ diss)
            titleTxt[i]:setPosition(X_1,titleTxt[i]:getPositionY()+ diss)
            contentTxt[i]:setPosition(X_2,contentTxt[i]:getPositionY()+ diss)
            inscribeTxt[i]:setPosition(X_3,inscribeTxt[i]:getPositionY()+ diss)
            dateTxt[i]:setPosition(X_3,dateTxt[i]:getPositionY()+ diss)
            line[i]:setPosition(X_1,line[i]:getPositionY()+ diss)
        end
        h = 450
    end
    self.scrollView:setInnerContainerSize(cc.size(800,h))
end

--[[--
--信息列表
--@param #number _idx tab下标
--]]
function MailDialog:showMessageInfo(_idx)
    local tableView = cc.TableView:create(cc.size(427,305))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(15,-10)
    tableView:setDelegate()
    if _idx == 2 then
        self.selectIdx = 0
    else
        self.selectIdx = -1
    end

    local function numberOfCellsInTableView(table)
        if #self.model.totalMailList == 0 then
            self.listEmptyTips:setVisible(true)
            self:changeTextProperty(nil, 3)
        else
            self.listEmptyTips:setVisible(false)
        end
        return self.model:getTotalMail()
    end

    local function tableCellTouched(table,cell)
        if self.model:getTotalMail() == (cell:getIdx() + 1) and self.model:isHasNextPage() then
            self:sendListMsg(2, 2)
            return
        end
        if tableView:cellAtIndex(self.selectIdx) then
            tableView:cellAtIndex(self.selectIdx).item:removeSelected()
        end
        self.selectIdx = cell:getIdx()
        self.curCell = cell
        self:showMailInfo(self.model.totalMailList[self.selectIdx + 1])
        cell.item:setSelected()
        if self.animAction ~= 2 then
            self:messageMoveAnim(2)
        end
        -- if _idx == 3 or _idx == 4 then
        --     if self.animAction ~= 2 then
        --         self:messageMoveAnim(2)
        --     end
        -- else
        --     if self.animAction ~= 2 then
        --         self:messageMoveAnim(2)
        --     end
        -- end
    end

    local function cellSizeForTable(tableView, idx)
        return 435, CELL_HEIGHT
    end

    local function tableCellAtIndex(table, idx)
        local cell = table:dequeueCell()
        local item = nil
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.mail.MailCell.new()
            cell:addChild(item)
            cell.item = item
        end
        if idx == self.selectIdx then
            cell.item:setSelected()
            self.curCell = cell
        else
            cell.item:removeSelected()
        end

        cell.item:render(self.model.totalMailList[idx + 1] , _idx)
        --tableView的偏移量为正时，则滑到最后
        -- if self.model:getListNum() > 10 then
        --     if not self.hasSendMsg and tableView:getContentOffset().y > 0  then
        --         if self.model:getNextPage() > 1 then
        --             self.hasSendMsg = true
        --             self:sendListMsg(_idx, 2)
        --         else
        --             qy.hint:show("没有更多的数据")
        --         end
        --     end
        -- end
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)

    tableView:reloadData()
    self:showMailInfo(self.model.totalMailList[self.selectIdx + 1])
    return tableView
end

--[[--
--刷新数据
--]]
function MailDialog:reloadTableViewData(tableView)
    local offset = tableView:getContentOffset()
    tableView:reloadData()
    tableView:setBounceable(false)
    tableView:setContentOffset(offset, false)
    tableView:setBounceable(true)
    self:showMailInfo(self.model.totalMailList[self.selectIdx + 1])
end

--[[--
--邮件详情
--]]
function MailDialog:showMailInfo(entity)
    self.entity = entity
    self.replyBtn:setVisible(true)
    self.hasReceiveTip:setVisible(false)
    if entity then
        if self.curTab == 2 then
            --系统邮件
            if entity.is_item == 1 and entity.status ~= 2 then
                --有物品领取
                self:changeBtnStatus(1)

            elseif entity.sender_id == 0 then
                --没有物品领取
                self:changeBtnStatus(2)
            else
                --收信箱--个人
                self:changeBtnStatus(4)
            end
        else
            --查看收信箱/客服信箱
            self:changeBtnStatus(5)
        end

        self.curMainId = entity.id

        if self.curTab == 2 and entity.status == 0 then
            local service = qy.tank.service.MailService
            service:changeMailStatus(self.curMainId,self.selectIdx + 1, function(data)
                if self.curCell then
                    self.curCell.item:render(self.model.totalMailList[self.selectIdx + 1] , self.curTab)
                end
            end)
        elseif self.curTab == 4 and entity.status == 0 then
            local service = qy.tank.service.MailService
            service:changeCustomerMailStatus(self.curMainId,self.selectIdx + 1, function(data)
                if self.curCell then
                    self.curCell.item:render(self.model.totalMailList[self.selectIdx + 1] , self.curTab)
                end
            end)
        end
    else
        self:messageMoveAnim(3)
        self:changeBtnStatus(3)
    end
    self:changeReplyBtnTouchProperty()
    self:changeAllOperationBtnText()

    if entity then
        if self.curTab == 2 then
            --查看收信箱
            self:changeTextProperty(entity, 1)
            self:showItemInfo(entity)
        else
            --客服/收信查看
            self:changeTextProperty(entity, 4)
            self:showItemInfo(nil)
        end
    else
        if self.curTab == 4 then
            --客服--发信
            self:changeTextProperty(self.model.totalMailList[1], 5)
            self:showItemInfo(nil)
        else
            --收信箱-发信 --发信箱--发信
            self:changeTextProperty(nil, 3)
            self:showItemInfo(nil)
        end
    end
end

--[[--
--显示物品
--]]
function MailDialog:showItemInfo(entity)
      if self.itemView then
        self.readList:removeChild(self.itemView)
        self.itemView = nil
    end
    if entity then
        local award = entity.item

        if award and #award > 0 then
            self.itemView = qy.AwardList.new({
                ["award"] = award,
                ["itemSize"] = 2,
                ["cellSize"] = cc.size(130,180),
                ["type"] = 1,
                })
            self.itemView:setPosition(80, 223)
            self.readList:addChild(self.itemView)

            if entity.status == 2 then
                self.replyBtn:setVisible(false)
                self.hasReceiveTip:setVisible(true)
            else
                self.hasReceiveTip:setVisible(false)
            end
        end

        -- :createMsgContent(entity)
    end
end

--[[--
--改变全部操作按钮文字
--]]
function MailDialog:changeAllOperationBtnText()
    cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/common/txt/common_txt.plist")
    if self.model:isAllItemReceived() then
        self.all_op_title:setSpriteFrame("Resources/common/txt/quanbushanchu.png")
    else
        self.all_op_title:setSpriteFrame("Resources/common/txt/quanbulingqu.png")
    end
end

--[[--
--改变Reply按钮点击属性
--]]
function MailDialog:changeReplyBtnTouchProperty()
    if self.replyAction == 4 then
        self.replyBtn:setEnabled(false)
        self.replyBtn:setBright(false)
    else
        self.replyBtn:setEnabled(true)
        self.replyBtn:setBright(true)
    end
end

--[[--
--移动动画
--]]
function MailDialog:messageMoveAnim(animAction)
    self.wirteBg:stopAllActions()
    self.animAction = animAction
    local _h = 145
    if animAction == 2 then
        self.readBg:setVisible(true)
        self.wirteBg:setVisible(false)
        self.readBg:setPosition(708, _h)
        self.readBg:runAction(cc.MoveTo:create(0.5, cc.p(201, _h)))
    elseif animAction == 3 then
        self.readBg:setVisible(false)
        self.wirteBg:setVisible(true)
        self.wirteBg:setPosition(708, _h)
        self.wirteBg:runAction(cc.MoveTo:create(0.5, cc.p(201,_h)))
    elseif animAction == 4 then
        self.readBg:setVisible(false)
        self.wirteBg:setVisible(true)
        self.wirteBg:setPosition(708, _h)
        self.wirteBg:runAction(cc.MoveTo:create(0.5, cc.p(201,_h)))
    end
end

--[[--
--发送消息
--@param #number nType 1 重新请求 2 下一页请求
--]]
function MailDialog:sendListMsg(idx, nType)
    if idx == 2 or idx == 3 then
        local service = qy.tank.service.MailService
        service:getMaillist(idx - 1,function(data)
            self:switchContentTo(idx, nType)
            qy.GuideManager:next(123432)
        end)
    else
        local service = qy.tank.service.MailService
        service:getCustomServiceList(1,function(data)
            self:switchContentTo(idx, nType)
        end)
    end
end

function MailDialog:switchContentTo(idx, nType)
    if nType == 1 then
        -- 移除当前视图
        if self.currentView then
            self.messageList:removeChild(self.currentView)
        end
        -- 显示新视图
        self.currentView = self:showMessageInfo(idx)
        self.currentView:retain()
        self.messageList:addChild(self.currentView)
    else
        local listCurY = self.currentView:getContentOffset().y - self.model:getAddMailNum() * CELL_HEIGHT
        self.currentView:reloadData()
        self.currentView:setContentOffset(cc.p(0,listCurY))
    end
    self.hasSendMsg = false
end

function MailDialog:createMsgContent(entity)
    -- if self.msgContainer then
    --     self.sendContent:removeChild(self.msgContainer)
    --     self.msgContainer = nil
    -- end
    -- self.sendContent:removeAllChildren()

    local width = 400
    local height = 158

    local award = entity.item
    if award and #award > 0 then
        self.sendContent:setContentSize(width, height)
    else
        height = 260
        self.sendContent:setContentSize(width, height)
    end

    -- if not tolua.cast(self.msgContainer,"cc.Node") then
    --     self.msgContainer = cc.Layer:create()
    --     self.msgContainer:setAnchorPoint(0,1)
    --     self.msgContainer:setTouchEnabled(false)
    -- end
    if self.contentTxt == nil then
        self.contentTxt = cc.Label:createWithSystemFont(entity:getCurContent() ,nil,20,cc.size(width,0),cc.TEXT_ALIGNMENT_LEFT,cc.VERTICAL_TEXT_ALIGNMENT_TOP)
        self.sendContent:addChild(self.contentTxt)
        self.contentTxt:setTextColor(cc.c4b(27,27,27,255))
        self.contentTxt:setAnchorPoint(0,1)
    end
    self.contentTxt:setString(entity:getCurContent())

    local h = self.contentTxt:getContentSize().height
    -- self.contentTxt:setPosition(0,h)

    -- self.panel_c:setContentSize(width,h)
    -- self.msgContainer:setPosition(0,300)
    -- self.sendContent:addChild(self.msgContainer)
    if height < h then
        self.sendContent:setInnerContainerSize(cc.size(width,h))
        self.contentTxt:setPosition(0,h)
    else
        self.sendContent:setInnerContainerSize(cc.size(width,height))
        self.contentTxt:setPosition(0,height)
    end
end

--[[--
--更改文本框属性
--]]
function MailDialog:changeTextProperty(entity, nAction)
    if entity then
        self.senderName:setTextColor(entity:getContentNameTextColor())
    end
    if nAction == 1 then
        --收信箱--查看
        -- self.sendContent:setString(entity:getCurContent())
        self:createMsgContent(entity)
        self.senderName:setString(entity:getSenderName())
        self.sendTitle:setString(qy.TextUtil:substitute(19016))
    elseif nAction == 2 then
        --收信箱--回复
        self.receiveContent:setPlaceHolder("")
        self.receiverName:setTouchEnabled(false)
        self.receiverName:setText(entity:getSenderName())
        -- self.sendContent:setString(entity:getCurContent())
        self.senderName:setString(entity:getReceiverName())
        self.sendTitle:setString(qy.TextUtil:substitute(19017))
    elseif nAction == 3 then
        --新建邮邮件 --发信箱发邮件
        self.receiveContent:setPlaceHolder("")
        self.receiveContent:setString("")
        self.receiverName:setTouchEnabled(true)
        self.receiverName:setText("")
        if self.delegate.name then
            self.receiverName:setText(self.delegate.name)
        end
    elseif nAction == 4 then
        --客服查看--发信箱查看
        -- self.sendContent:setString(entity:getCurContent())
        self:createMsgContent(entity)
        self.senderName:setString(entity:getReceiverName())
        self.sendTitle:setString(qy.TextUtil:substitute(19010))
    elseif nAction == 5 then
        --发给客服邮件
        self.receiveContent:setPlaceHolder(qy.TextUtil:substitute(19018))--\n客服QQxxxxxxxx  \n官方微信账号 XXXXXX
        self.receiverName:setTouchEnabled(false)
        self.receiverName:setText(qy.TextUtil:substitute(19019))
    end
end

--[[--
--更改按钮状态
--]]
function MailDialog:changeBtnStatus(nStatus)
    cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/common/txt/common_txt.plist")
    if nStatus == 1 then
        --[收信箱-系统-有奖励]--
        self.delete_title:setSpriteFrame("Resources/common/txt/shanchu.png")
        self.delegateAction = 1--删除(delteleBtn)
        self.reply_title:setSpriteFrame("Resources/common/txt/lingqu.png")
        self.replyAction = 1--领取(replyBtn)

    elseif nStatus == 2 then
        --[收信箱-系统-无奖励]--
        -- self.delteleBtn:setTitleText("删除")
        self.delete_title:setSpriteFrame("Resources/common/txt/shanchu.png")
        self.delegateAction = 1--删除(delteleBtn)
        -- self.replyBtn:setTitleText("领取")
        self.reply_title:setSpriteFrame("Resources/common/txt/lingqu.png")
        self.replyAction = 4--不可点(replyBtn)

    elseif nStatus == 3 then
        --[收信箱-个人-回复]-[发信箱-写信]-[客服-写信]-[新建信件]--
        -- self.delteleBtn:setTitleText("重置")
        self.delete_title:setSpriteFrame("Resources/common/txt/chongzhi.png")
        self.delegateAction = 2--重置(delteleBtn)
        -- self.replyBtn:setTitleText("发送")
        self.reply_title:setSpriteFrame("Resources/common/txt/fasong.png")
        self.replyAction = 2--发送(replyBtn)

    elseif nStatus == 4 then
        --[收信箱-个人-查看]
        -- self.delteleBtn:setTitleText("删除")
        self.delete_title:setSpriteFrame("Resources/common/txt/shanchu.png")
        self.delegateAction = 1--删除(delteleBtn)
        -- self.replyBtn:setTitleText("回复")
        self.reply_title:setSpriteFrame("Resources/common/txt/huifu.png")
        self.replyAction = 3--回复(replyBtn)

    elseif nStatus == 5 then
        --[客服-查看]-[发信息-查看]--
        -- self.delteleBtn:setTitleText("删除")
        self.delete_title:setSpriteFrame("Resources/common/txt/shanchu.png")
        self.delegateAction = 1--删除(delteleBtn)
        -- self.replyBtn:setTitleText("回复")
        self.reply_title:setSpriteFrame("Resources/common/txt/huifu.png")
        self.replyAction = 4--不可点(replyBtn)
    end
end

function MailDialog:onEnter()
    qy.RedDotCommand:addSignal({
        [qy.RedDotType.M_TAB] = self.tab_2,
        [qy.RedDotType.M_TAB_4] = self.tab_4,
    })
    qy.RedDotCommand:emitSignal(qy.RedDotType.M_TAB, qy.tank.model.RedDotModel:isMailTab2HasDot(), true)
    qy.RedDotCommand:emitSignal(qy.RedDotType.M_TAB_4, qy.tank.model.RedDotModel:isMailTab4HasDot(), true)
end

function MailDialog:onExit()
    qy.RedDotCommand:removeSignal({
        qy.RedDotType.M_TAB,qy.RedDotType.M_TAB_4,
    })
end

return MailDialog
