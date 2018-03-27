--[[--
--绑定账号 Dialog
--Author: H.X.Sun
--Date: 2015-09-01
--]]

local BindAccountDialog = qy.class("BindAccountDialog", qy.tank.view.BaseDialog, "view/login/BindAccountDialog")

function BindAccountDialog:ctor(delegate)
    BindAccountDialog.super.ctor(self)
	self:InjectView("accountTxt")
	self:InjectView("passwordTxt")
	self:InjectView("container")
	self:InjectView("finishTip")
	self:InjectView("bindInfo")
	self:InjectView("receiveBtn")
	self:InjectView("hasReceiveTip")
	for i = 1, 2 do
		self:InjectView("tick_"..i)
	end

	self.loginModel = qy.tank.model.LoginModel

	if self.loginModel:getPlayerInfoEntity().is_visitor == 1 then
		self.finishTip:setVisible(false)
		self.bindInfo:setVisible(true)
		self.receiveBtn:setEnabled(false)
		self.receiveBtn:setBright(false)
	else
		self.finishTip:setVisible(true)
		self.bindInfo:setVisible(false)
		self.receiveBtn:setEnabled(true)
		self.receiveBtn:setBright(true)
	end

	self:__showReceiveStatus()

	self.isAgree = true
	self.isShowPw = true

	self.accountTxt:setTextVerticalAlignment(1)
	self.passwordTxt:setTextVerticalAlignment(1)
	self.passwordTxt:setPasswordStyleText("*")

	self.containerPos = {["x"] = self.container:getPositionX(), ["y"] = self.container:getPositionY()}

	self:OnClick("closeBtn", function()
		self:dismiss()
	end)

	self.accountTxt:addEventListener(function(sender, eventType)
		if eventType == TEXTFIELD_EVENT_ATTACH_WITH_IME then
			--调用手机键盘
			self.container:setPosition(self.containerPos.x, self.containerPos.y + 100)
		elseif eventType == TEXTFIELD_EVENT_DETACH_WITH_IME then
			--退出手机键盘
			self.container:setPosition(self.containerPos.x, self.containerPos.y)
		end
	end)

	self.passwordTxt:addEventListener(function(sender, eventType)
		if eventType == TEXTFIELD_EVENT_ATTACH_WITH_IME then
			--调用手机键盘
			self.container:setPosition(self.containerPos.x, self.containerPos.y + 100)
		elseif eventType == TEXTFIELD_EVENT_DETACH_WITH_IME then
			--退出手机键盘
			self.container:setPosition(self.containerPos.x, self.containerPos.y)
		end
	end)

	--显示密码
	self:OnClick("showPWBtn", function()
		if self.isShowPw then
			self.isShowPw = false
			self.tick_1:setVisible(false)
			self.passwordTxt:setPasswordEnabled(true)
		else
			self.isShowPw = true
			self.tick_1:setVisible(true)
			self.passwordTxt:setPasswordEnabled(false)
		end
		self.passwordTxt:setString(self.passwordTxt:getString())
	end, {["isScale"] = false})

	--同意协议
	self:OnClick("agreeBtn", function()
		if self.isAgree then
			self.isAgree = false
			self.tick_2:setVisible(false)
			-- self.finishBtn:setEnabled(false)
			-- self.finishBtn:setBright(false)
		else
			self.isAgree = true
			self.tick_2:setVisible(true)
			-- self.finishBtn:setEnabled(true)
			-- self.finishBtn:setBright(true)
		end
	end, {["isScale"] = false})

	--协议弹框
	self:OnClick("agreeText", function()
		qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.QY_AGREE)
	end, {["isScale"] = false})

	self:OnClick("receiveBtn", function()
		qy.tank.service.LoginService:getBindAccountAward(function ()
			-- self:dismiss()
			self:__showReceiveStatus()
			self:showAnim(self.hasReceiveTip)
		end)
	end)

	self:OnClick("finishBtn", function()
		if not self.isAgree then
			qy.hint:show(qy.TextUtil:substitute(18001))
			return
		end
		if not self:__inputCorrect() then
			return
		end
		local _account, _password = self:getInputTxt()
		local params = {["password"] = _password, ["username"] = _account}

		qy.tank.utils.QYSDK.bindAccount(2,params, function ()
			-- self.finishTip:setVisible(true)
			self.receiveBtn:setEnabled(true)
			self.receiveBtn:setBright(true)
			self.bindInfo:setVisible(false)
			self:showAnim(self.finishTip)
		end)
	end)

	self:__createAward()
end

function BindAccountDialog:__showReceiveStatus()
	if self.loginModel:getBindAccountStatus() == 0 then
		self.hasReceiveTip:setVisible(false)
		self.receiveBtn:setVisible(true)
	else
		self.receiveBtn:setVisible(false)
		self.hasReceiveTip:setVisible(true)
	end
end

function BindAccountDialog:showAnim(targetUi)
	targetUi:setScale(5)
    targetUi:setVisible(true)
    local scaleAction =  cc.ScaleTo:create(0.2, 1)
    local ease = cc.EaseOut:create(scaleAction,0.2)
    targetUi:runAction(cc.Sequence:create(ease))
end

function BindAccountDialog:__createAward()
	-- local award = self.loginModel:getBindAccountAward()
	local awardList = qy.AwardList.new({
        ["award"] = {{["num"] = 50,["type"] = 1}},
        ["hasName"] = true,
        ["type"] = 1,
        ["cellSize"] = cc.size(240,180),
        ["itemSize"] = 2,
    })
    self.container:addChild(awardList)
    awardList:setPosition(0,-40)
end

--[[--
--输入正确
--]]
function BindAccountDialog:__inputCorrect()
	local _account, _password = self:getInputTxt()
	if _account == nil or _account == "" then
		qy.hint:show(qy.TextUtil:substitute(18002))
		return false
	elseif _password == nil or _password == "" then
		qy.hint:show(qy.TextUtil:substitute(18003))
		return false
	elseif string.len(_account) < 4 or string.len(_account) > 15 then
		qy.hint:show(qy.TextUtil:substitute(18004))
		return false
	elseif string.len(_password) < 6 or string.len(_password) > 20 then
		qy.hint:show(qy.TextUtil:substitute(18005))
		return false
	else
		return true
	end
end

function BindAccountDialog:getInputTxt()
	return self.accountTxt:getString(), self.passwordTxt:getString()
end

return BindAccountDialog
