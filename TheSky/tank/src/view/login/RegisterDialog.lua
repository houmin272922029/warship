--[[--
--注册dialog
--Author: H.X.Sun
--Date: 2015-07-28
--]]

local RegisterDialog = qy.class("RegisterDialog", qy.tank.view.BaseDialog, "view/login/RegisterDialog")

function RegisterDialog:ctor(delegate)
    RegisterDialog.super.ctor(self)

	self.delegate = delegate
	self.action = self.delegate.action
	self.isAgree = true
	self.isShowPw = true

	--初始化ui
	self:__initView()
	--绑定点击事件
	self:__bindingClickEvent()
end

function RegisterDialog:__initView()
	self:InjectView("container")
	self:InjectView("title")
	self:InjectView("finishBtn")
	self:InjectView("finishTxt")

	for i = 1, 2 do
		self:InjectView("inputBg_"..i)
	end

	self.accountTxt = ccui.EditBox:create(cc.size(330, 80), "Resources/common/bg/c_12.bg")
    self.accountTxt:setPosition(175,34)
   	self.accountTxt:setFontSize(30)
   	self.accountTxt:setPlaceholderFontSize(30)
    self.accountTxt:setPlaceHolder(qy.TextUtil:substitute(18014))
   	self.accountTxt:setInputMode(6)
    if self.accountTxt.setReturnType then
        self.accountTxt:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    end
    self.inputBg_1:addChild(self.accountTxt)

    self.passwordTxt = ccui.EditBox:create(cc.size(330, 80), "Resources/common/bg/c_12.bg")
    self.passwordTxt:setPosition(175,34)
   	self.passwordTxt:setFontSize(30)
   	self.passwordTxt:setPlaceholderFontSize(30)
    self.passwordTxt:setPlaceHolder(qy.TextUtil:substitute(18015))
   	self.passwordTxt:setInputFlag(0)
   	self.passwordTxt:setInputMode(6)
    if self.passwordTxt.setReturnType then
        self.passwordTxt:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    end
    self.inputBg_2:addChild(self.passwordTxt)

	for i = 1, 2 do
		self:InjectView("tick_"..i)
	end

	if self.action == 1 then
		--注册
		self.title:setString(qy.TextUtil:substitute(18016))
		self.finishTxt:setString(qy.TextUtil:substitute(18017))
	else
		--绑定
		self.title:setString(qy.TextUtil:substitute(18018))
		self.finishTxt:setString(qy.TextUtil:substitute(18019))
	end
end

function RegisterDialog:__bindingClickEvent()
	--返回
	self:OnClick("returnBtn", function()
		if self.delegate.update then
			if self.action == 1 then
				--注册
				self.delegate.update(4)
			else
				--绑定
				self.delegate.update(2)
			end
		end
		self:dismiss()
	end, {["isScale"] = false})

	--完成注册
	self:OnClick("finishBtn", function()
		if not self:__inputCorrect() then return end
		local _account, _password = self:getInputTxt()
		local params = {["password"] = _password, ["username"] = _account}

		if self.action == 1 then
			--注册
			qy.tank.utils.QYSDK.registerOrLogin(1,params, function ()
				if self.delegate.update then
					self.delegate.update(2)
				end
				self:dismiss()
			end)
		else
			--绑定
			qy.tank.utils.QYSDK.bindAccount(1,params, function ()
				if self.delegate.update then
					self.delegate.update(2)
				end
				self:dismiss()
			end)
		end
	end, {["isScale"] = false})

	--显示密码
	self:OnClick("showPWBtn", function()
		local _pwTxt = self.passwordTxt:getText()

		if self.isShowPw then
			self.isShowPw = false
			self.tick_1:setVisible(false)
			self.passwordTxt:setInputFlag(0)
		else
			self.isShowPw = true
			self.tick_1:setVisible(true)
			self.inputBg_2:removeChild(self.passwordTxt)
			self.passwordTxt = nil

			self.passwordTxt = ccui.EditBox:create(cc.size(330, 80), "Resources/common/bg/c_12.bg")
		   	self.passwordTxt:setPosition(175,34)
           	self.passwordTxt:setFontSize(30)
           	self.passwordTxt:setPlaceholderFontSize(30)
            self.passwordTxt:setPlaceHolder(qy.TextUtil:substitute(18020))
           	self.passwordTxt:setInputMode(6)
            if self.passwordTxt.setReturnType then
                self.passwordTxt:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
            end
		   	self.inputBg_2:addChild(self.passwordTxt)
		end

		self.passwordTxt:setText(_pwTxt)
	end, {["isScale"] = false})

	--同意协议
	self:OnClick("agreeBtn", function()
		if self.isAgree then
			self.isAgree = false
			self.tick_2:setVisible(false)
			self.finishBtn:setEnabled(false)
			self.finishBtn:setBright(false)
		else
			self.isAgree = true
			self.tick_2:setVisible(true)
			self.finishBtn:setEnabled(true)
			self.finishBtn:setBright(true)
		end
	end, {["isScale"] = false})

	--协议弹框
	self:OnClick("agreeText", function()
		qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.QY_AGREE)
	end, {["isScale"] = false})
end

--[[--
--输入正确
--]]
function RegisterDialog:__inputCorrect()
	local _account, _password = self:getInputTxt()
	if _account == nil or _account == "" then
		qy.hint:show(qy.TextUtil:substitute(18021))
		return false
	elseif _password == nil or _password == "" then
		qy.hint:show(qy.TextUtil:substitute(18022))
		return false
	elseif string.len(_account) < 4 or string.len(_account) > 15 then
		qy.hint:show(qy.TextUtil:substitute(18023))
		return false
	elseif string.len(_password) < 6 or string.len(_password) > 20 then
		qy.hint:show(qy.TextUtil:substitute(18024))
		return false
	else
		return true
	end

end

function RegisterDialog:getInputTxt()
	return self.accountTxt:getText(), self.passwordTxt:getText()
end

return RegisterDialog
