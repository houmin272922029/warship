--[[--
--登录cell
--Author: H.X.Sun
--Date: 2015-07-28
--]]

local LoginCell = qy.class("LoginCell", qy.tank.view.BaseView, "view/login/LoginCell")

function LoginCell:ctor(delegate)
    LoginCell.super.ctor(self)

	self:InjectView("registerBtn")
	self:InjectView("container")
	self:InjectView("aList")

	self.aList:setLocalZOrder(30)
	for i = 1, 2 do
		self:InjectView("inputBg_"..i)
	end

	self.accountTxt = ccui.EditBox:create(cc.size(330, 80), "Resources/common/bg/c_12.bg")
   	self.accountTxt:setPosition(175,34)
   	self.accountTxt:setFontSize(30)
   	self.accountTxt:setPlaceholderFontSize(30)
   	self.accountTxt:setPlaceHolder(qy.TextUtil:substitute(18009))
   	self.accountTxt:setInputMode(6)
    self.accountTxt:setInputFlag(3)
    if self.accountTxt.setReturnType then
        self.accountTxt:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    end
   	self.inputBg_1:addChild(self.accountTxt)

   	self.passwordTxt = ccui.EditBox:create(cc.size(330, 80), "Resources/common/bg/c_12.bg")
   	self.passwordTxt:setPosition(175,34)
   	self.passwordTxt:setFontSize(30)
   	self.passwordTxt:setPlaceholderFontSize(30)
   	self.passwordTxt:setPlaceHolder(qy.TextUtil:substitute(18010))
   	self.passwordTxt:setInputFlag(0)
   	self.passwordTxt:setInputMode(6)
    if self.passwordTxt.setReturnType then
        self.passwordTxt:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    end
   	self.inputBg_2:addChild(self.passwordTxt)

	self._listOpen = false

	--快速注册
	self:OnClick("registerBtn", function()
		delegate.update(3)
		qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.REGISTER, {["update"] =delegate.update, ["action"] = 1})
	end, {["isScale"] = false})

	--返回
	self:OnClick("returnBtn", function()
		delegate.update(1)
	end)

	--登录
	self:OnClick("loginBtn", function()
		if not self:__inputCorrect() then return end
		local _account, _password = self:getInputTxt()
		local params = {["password"] = _password, ["username"] = _account}
		qy.tank.utils.QYSDK.registerOrLogin(2, params, function()
			delegate.update(2)
		end)
	end, {["isScale"] = false})

	--切换账号
	self:OnClick("accountBtn", function()
		self:__clickAccountLogic()
	end, {["isScale"] = false})
end

function LoginCell:__clickAccountLogic()
	if qy.tank.model.LoginModel:getUserAccountNun() < 1 then
		qy.hint:show(qy.TextUtil:substitute(18011))
	elseif self._listOpen then
		self._listOpen = false
		self.aList:removeChild(self.accountList)
		self.accountList = nil
	else
		self._listOpen = true
		self.accountList = qy.tank.view.login.AccountList.new({
			["updateData"] = function ()
				self:updateData()
				self:__clickAccountLogic()
			end
		})
		self.aList:addChild(self.accountList)
	end
end

function LoginCell:updateData()
	local player = qy.tank.model.LoginModel:getPlayerInfoEntity()
	if player and player.username then
		self.accountTxt:setText(player.username)
	end
	if player and player.password_ then
		self.passwordTxt:setText(player.password)
	end
end

--[[--
--输入正确
--]]
function LoginCell:__inputCorrect()
	local _account, _password = self:getInputTxt()
	if _account == nil or _account == "" then
		qy.hint:show(qy.TextUtil:substitute(18012))
		return false
	elseif _password == nil or _password == "" then
		qy.hint:show(qy.TextUtil:substitute(18013))
		return false
	else
		return true
	end
end

function LoginCell:getInputTxt()
	return self.accountTxt:getText(), self.passwordTxt:getText()
end

function LoginCell:show()
    self.accountTxt:setVisible(true)
    self.passwordTxt:setVisible(true)
    self:setVisible(true)
end

function LoginCell:hide()
    self.accountTxt:setVisible(false)
    self.passwordTxt:setVisible(false)
    self:setVisible(false)
end

return LoginCell
