--[[
	提示
	Author: H.X.Sun
]]

local TipsDialog = qy.class("TipsDialog", qy.tank.view.BaseDialog, "legion/ui/basic/TipsDialog")

function TipsDialog:ctor(delegate)
    TipsDialog.super.ctor(self)
    local dis = 0
    if delegate and tonumber(delegate.height) then
        dis = delegate.height
    end

    local style = qy.tank.view.style.DialogStyle5.new({
        size = cc.size(500,270 + dis),
        position = cc.p(0,0),
        offset = cc.p(0,0),
    })
    self:addChild(style,-1)

    self:InjectView("cancel_btn")
    self:InjectView("confirm_btn")
    self:InjectView("titleBg")
    self:InjectView("title")
    self:InjectView("co_bg")
    self:InjectView("tip_1")
    self:InjectView("tip_2")
    self:InjectView("container")

    for i = 1, 4 do
        self:InjectView("txt_" .. i)
    end

    local service = qy.tank.service.LegionService
    local model = qy.tank.model.LegionModel

    self:OnClick("cancel_btn", function()
        self:dismiss()
    end)

    self:OnClick("confirm_btn", function()
        if model.TIPS_LEAVE == delegate.type then
            service:leave(function()
                qy.hint:show(qy.TextUtil:substitute(50060))
                qy.tank.manager.ScenesManager:getRunningScene():disissAllDialog()
                qy.tank.manager.ScenesManager:getRunningScene():disissAllView()
                qy.tank.model.UserInfoModel.userInfoEntity:clearLegionName()
                self:dismiss()
            end)
        elseif model.TIPS_OP == delegate.type then
            --操作提示
            self:dismiss()
            qy.tank.view.legion.basic.TipsDialog.new({
                ["type"] = qy.tank.model.LegionModel.TIPS_DIS,
            }):show(true)
        elseif model.TIPS_DIS == delegate.type then
            --解散
            -- qy.hint:show("解散军团")
            service:dismissLegion(function()
                qy.hint:show(qy.TextUtil:substitute(50061))
                -- delegate:callback()
                qy.tank.manager.ScenesManager:getRunningScene():disissAllDialog()
                qy.tank.manager.ScenesManager:getRunningScene():disissAllView()
                self:dismiss()
            end)
        elseif model.TIPS_MOD == delegate.type then
            --修改公告
            local val = self.notice:getString()
            if string.trim(val) == "" then
                qy.hint:show(qy.TextUtil:substitute(50062))
                return
            end
            service:setNotice(val, function()
                qy.hint:show(qy.TextUtil:substitute(50063))
                delegate:callback()
                self:dismiss()
            end)
        elseif model.TIPS_BOSS == delegate.type then
            --司令授予
            delegate.callback()
            self:dismiss()
        elseif model.TIPS_UP == delegate.type then
            delegate.callback()
            self:dismiss()
        end
    end)

    if model.TIPS_LEAVE == delegate.type or model.TIPS_OP == delegate.type then
        --操作提示
        self.tip_1:setVisible(true)
        self.tip_2:setVisible(false)
        self.title:setSpriteFrame("legion/res/basic/caozuotishi.png")
        self.txt_2:setString(delegate.entity.name)
        local w = 0
        local wArr = {}
        for i = 1, 3 do
            wArr[i] = self["txt_" .. i]:getContentSize().width
            w = w + wArr[i]
        end
        if qy.language == "cn" then
          self.txt_1:setPosition(-w/2,17)
        end
        self.txt_2:setPosition(-w/2 +  wArr[1], 17)
        self.txt_3:setPosition(-w/2 +  wArr[1] + wArr[2], 17)
        if model.TIPS_LEAVE == delegate.type then
            self.txt_1:setString(qy.TextUtil:substitute(50064))
            self.txt_4:setString(qy.TextUtil:substitute(50065))
        else
            self.txt_1:setString(qy.TextUtil:substitute(50066))
            self.txt_4:setString(qy.TextUtil:substitute(50067))

        end
    elseif model.TIPS_DIS == delegate.type then
        --解散
        self.tip_1:setVisible(false)
        self.tip_2:setVisible(true)
        self.title:setSpriteFrame("legion/res/basic/jiesan1.png")
    elseif model.TIPS_MOD == delegate.type then
        --修改公告
        self.tip_1:setVisible(false)
        self.tip_2:setVisible(false)
        self.title:setSpriteFrame("legion/res/basic/xiugaigonggao.png")
        self.co_bg:setContentSize(cc.size(430,90 + dis))
        self.co_bg:setPosition(0,15)
        self.titleBg:setPosition(0,99 + dis / 2)
        self.cancel_btn:setPosition(-93,-90- dis / 2)
        self.confirm_btn:setPosition(93,-90 - dis / 2)

        self.notice = ccui.TextField:create()
        self.notice:ignoreContentAdaptWithSize(false)
        self.notice:setFontSize(22)
        self.notice:setPlaceHolder(qy.TextUtil:substitute(50068))
        self.notice:setTouchEnabled(true)
        self.notice:setAnchorPoint(0, 1)
        self.notice:setPosition(20,180)
        self.notice:setContentSize(cc.size(400, 50 + dis))
        self.co_bg:addChild(self.notice)
        local noticeStr = model:getHisLegion().notice
        if string.trim(noticeStr) ~= "" then
            self.notice:setString(noticeStr)
        end

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
        self.notice:onEvent(inputEventHandler)
    elseif model.TIPS_BOSS == delegate.type then
        self.tip_1:setVisible(false)
        self.tip_2:setVisible(false)
        self.title:setSpriteFrame("legion/res/basic/caozuotishi.png")

        local richTxt = ccui.RichText:create()
        richTxt:ignoreContentAdaptWithSize(false)
        richTxt:setContentSize(380, 80)
        richTxt:setAnchorPoint(0,0.5)
        local stringTxt1 = ccui.RichElementText:create(1, cc.c3b(255,255,255), 255, qy.TextUtil:substitute(50069) , qy.res.FONT_NAME_2, 24)
        richTxt:pushBackElement(stringTxt1)
        local stringTxt2 = ccui.RichElementText:create(2, cc.c3b(255,0,0), 255, qy.TextUtil:substitute(50070) , qy.res.FONT_NAME_2, 24)
        richTxt:pushBackElement(stringTxt2)
        local stringTxt3 = ccui.RichElementText:create(3, cc.c3b(255,255,255), 255, qy.TextUtil:substitute(50071) , qy.res.FONT_NAME_2, 24)
        richTxt:pushBackElement(stringTxt3)
        local stringTxt4 = ccui.RichElementText:create(4, cc.c3b(255,0,0), 255, delegate.name , qy.res.FONT_NAME_2, 24)
        richTxt:pushBackElement(stringTxt4)
        local stringTxt5 = ccui.RichElementText:create(5, cc.c3b(255,255,255), 255, qy.TextUtil:substitute(50072) , qy.res.FONT_NAME_2, 24)
        richTxt:pushBackElement(stringTxt5)
        richTxt:setPosition(-190,5)
        self.container:addChild(richTxt)
    elseif model.TIPS_UP == delegate.type then
        self.tip_1:setVisible(false)
        self.tip_2:setVisible(false)
        local richTxt = ccui.RichText:create()
        richTxt:ignoreContentAdaptWithSize(false)
        richTxt:setContentSize(380, 80)
        richTxt:setAnchorPoint(0,0.5)
        local stringTxt1 = ccui.RichElementText:create(1, cc.c3b(255,255,255), 255, qy.TextUtil:substitute(50073) , qy.res.FONT_NAME_2, 24)
        richTxt:pushBackElement(stringTxt1)
        local stringTxt2 = ccui.RichElementText:create(2, cc.c3b(252,224,0), 255, delegate.post, qy.res.FONT_NAME_2, 24)
        richTxt:pushBackElement(stringTxt2)
        local stringTxt3 = ccui.RichElementText:create(3, cc.c3b(255,255,255), 255, qy.TextUtil:substitute(50074) , qy.res.FONT_NAME_2, 24)
        richTxt:pushBackElement(stringTxt3)
        richTxt:setPosition(-160,-6)
        self.container:addChild(richTxt)
    end

end

return TipsDialog
