--[[--
--登录公告dialog
--Author: H.X.Sun
--Date: 2015-07-28
--]]

local AnnouncementDialog = qy.class("AnnouncementDialog", qy.tank.view.BaseDialog, "view/login/AnnouncementDialog")

function AnnouncementDialog:ctor(delegate)
    AnnouncementDialog.super.ctor(self)

    self:setBGOpacity(0)

	self.model = qy.tank.model.MailModel

	self:InjectView("scrollView")
	self:OnClick("confirmBtn", function()
        qy.ClientDotService:onEvent("watch_announce")
		self:dismiss()
	end, {["isScale"] = false})

	self:createNoticeView()
end

function AnnouncementDialog:createNoticeView()
    local ColorMapUtil = qy.tank.utils.ColorMapUtil
    --ColorMapUtil.getAnnounceColor(nType)

    if not tolua.cast(self.dynamic_c,"cc.Node") then
        self.dynamic_c = cc.Layer:create()
        self.dynamic_c:setAnchorPoint(0,1)
        self.dynamic_c:setTouchEnabled(false)
    end

    local h = 10
    local w = 680
    local bFontSize = 28
    local sFontSize = 26
    local cellH = 20
    local noticeList = self.model:getNoticeList()
    for i =1, 1 do
        local titleTxt = cc.Label:createWithSystemFont(noticeList[i].title,nil,bFontSize,cc.size(w,0),1,1)
        titleTxt:setPosition(0, -h)
        h = h + titleTxt:getContentSize().height + 13
        titleTxt:setAnchorPoint(0,1)
        self.dynamic_c:addChild(titleTxt)

        local contentTxt = cc.Label:createWithSystemFont(noticeList[i].content,nil,sFontSize,cc.size(w,0),0,0)
        contentTxt:setPosition(0, -h)
        h = h + contentTxt:getContentSize().height + 13
        contentTxt:setAnchorPoint(0,1)
        self.dynamic_c:addChild(contentTxt)

        local inscribeTxt = cc.Label:createWithSystemFont(noticeList[i].inscribe,nil,sFontSize,cc.size(w,0),2,2)
        inscribeTxt:setPosition(0, -h)
        h = h + inscribeTxt:getContentSize().height
        inscribeTxt:setAnchorPoint(0,1)
        self.dynamic_c:addChild(inscribeTxt)

        local dateTxt = cc.Label:createWithSystemFont(noticeList[i].create_time,nil,sFontSize,cc.size(w,0),2,2)
        dateTxt:setPosition(0, -h)
        h = h + dateTxt:getContentSize().height + 40
        dateTxt:setAnchorPoint(0,1)
        self.dynamic_c:addChild(dateTxt)
    end

    self.dynamic_c:setContentSize(w, h)
    if h < 250 then
        self.dynamic_c:setPosition(0,h + 100)
    else
        self.dynamic_c:setPosition(0,h)
    end
    self.scrollView:addChild(self.dynamic_c)

    if self.scrollView:getInnerContainerSize().height < h then
        self.scrollView:setInnerContainerSize(cc.size(w,h))
    end
end

return AnnouncementDialog
