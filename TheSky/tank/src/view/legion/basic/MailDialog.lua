--[[
	军团邮件
]]

local MailDialog = qy.class("MailDialog", qy.tank.view.BaseDialog, "legion/ui/basic/MailDialog")

function MailDialog:ctor(delegate)
    MailDialog.super.ctor(self)
    self.delegate = delegate
    local h = 440
    if delegate.selectIdx == 2 then
        h = 480
    end

    local style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(660,h),
        position = cc.p(0,0),
        offset = cc.p(0,0),
        titleUrl = "legion/res/basic/mail_title_"..delegate.selectIdx..".png",
        ["onClose"] = function()
            self:dismiss()
        end
    })
    self:addChild(style, -1)

    self:InjectView("content")
    self:InjectView("content_bg")
    self:InjectView("send_bg")
    self.content:setPlaceHolder("点击此处，开始输入（最多输入200汉字）")
    self.content:setPlaceHolderColor(cc.c4b(245, 236, 206, 255))
    local service = qy.tank.service.LegionService
    local pos = self:getPositionY()

    local function inputEventHandler(event)
        if event.name == "ATTACH_WITH_IME" then
            -- 当编辑框获得焦点并且键盘弹出的时候被调用
            self:setPositionY(self:getPositionY() + 80)
            print("ATTACH_WITH_IME")
        elseif event.name == "DETACH_WITH_IME" then
            -- 当编辑框失去焦点并且键盘消失的时候被调用
            self:setPositionY(self:getPositionY() - 80)
            print("DETACH_WITH_IME")
        end
    end
    self.content:onEvent(inputEventHandler)

    -- if not tolua.cast(self.content,"cc.Node") then
    --     self.content = ccui.EditBox:create(cc.size(490, 207), "Resources/common/bg/c_12.bg")
    --     self.content:setPosition(265,223)
    --     self.content:setFontSize(22)
    --     self.content:setPlaceHolder("点击此处，开始输入（最多输入200汉字）")
    --     self.content:setPlaceholderFontColor(cc.c4b(245, 236, 206, 255))
    --     self.content:setPlaceholderFontSize(22)
    --     self.content:setInputMode(6)
    --     if self.content.setReturnType then
    --         self.content:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    --     end
    --     self.content_bg:addChild(self.content)
    -- end

    if delegate.selectIdx == 1 then
        self.send_bg:setVisible(false)
    else
        self.send_bg:setVisible(true)
        self.send_bg:setLocalZOrder(100)
        self.content_bg:setPosition(0,0)
        if not tolua.cast(self.name,"cc.Node") then
            self.name = ccui.EditBox:create(cc.size(400, 80), "Resources/common/bg/c_12.bg")
            self.name:setPosition(215,26)
           	self.name:setFontSize(22)
            self.name:setPlaceHolder("点击此处输入军团名称")
            self.name:setPlaceholderFontColor(cc.c4b(245, 236, 206, 255))
           	self.name:setPlaceholderFontSize(22)
           	self.name:setInputMode(6)
            if self.name.setReturnType then
                self.name:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
            end
            self.send_bg:addChild(self.name)
        end
    end

    local content,legion,send_type
    self:OnClick("send_btn",function()
        content = self.content:getString()
        if delegate.selectIdx == 2 then
            legion = self.name:getText()
            send_type = 200 -- 其他军团
        else
            send_type = 100 -- 本军团
            legion = nil
        end
        if self:__canBeNextStep(content,legion) then
            service:sendLegionMail({
                ["type"] = send_type,
                ["content"] = content,
                ["legion_name"] = legion,
            },function()
                self:dismiss()
                qy.hint:show("发送成功")
            end)
        end
    end)
end

function MailDialog:__canBeNextStep(content,legion)
    local content_str = string.trim(content)
    if self.delegate.selectIdx == 2 then
        local legion_str = string.trim(legion)
        if legion_str == nil or legion_str == "" then
            qy.hint:show("请输入军团名称")
            return false
        end
    end

    if content_str == nil or content_str == "" then
        qy.hint:show(qy.TextUtil:substitute(19013))
        return false
    else
        return true
    end
end

return MailDialog
