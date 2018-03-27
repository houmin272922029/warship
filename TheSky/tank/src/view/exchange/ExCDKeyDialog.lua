--[[
    CD key
	Author: H.X.Sun
    Data:2015-12-10
]]

local ExCDKeyDialog = qy.class("ExCDKeyDialog", qy.tank.view.BaseDialog, "view/exchange/ExCDKeyDialog")
-- local service = qy.tank.service.ExchangeService

function ExCDKeyDialog:ctor(delegate)
    ExCDKeyDialog.super.ctor(self)

    local style = qy.tank.view.style.DialogStyle1.new({
		size = cc.size(560,260),
		position = cc.p(0,0),
		offset = cc.p(0,0),
		titleUrl = "Resources/common/bg/c_12.bg",

		["onClose"] = function()
			self:dismiss()
		end
	})
    style.title_bg:setVisible(false)
	self:addChild(style, -1)

    self:InjectView("input_bg")

    self.inputTxt = ccui.EditBox:create(cc.size(400, 50), "Resources/common/bg/c_12.bg")
   	self.inputTxt:setPosition(215,28)
   	self.inputTxt:setFontSize(30)
   	self.inputTxt:setPlaceholderFontSize(30)
   	self.inputTxt:setPlaceHolder(qy.TextUtil:substitute(11001))
   	self.inputTxt:setInputMode(6)
    if self.inputTxt.setReturnType then
        self.inputTxt:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    end
   	self.input_bg:addChild(self.inputTxt)

    self:__bindingClickEvent()
end

function ExCDKeyDialog:__bindingClickEvent()
    local service = qy.tank.service.ExchangeService
    --清空
	self:OnClick("clear_btn",function(sender)
        self.inputTxt:setText("")
	end)

    --确认
    self:OnClick("confirm_btn",function(sender)
        local _str = string.gsub(self.inputTxt:getText(), "^%s*(.-)%s*$", "%1")
        if _str and _str ~= "" then
            service:exchangeCdkey(_str,function(data)
                self:dismiss()
                qy.tank.command.AwardCommand:show(data.award)
                -- qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.BIND_ACCOUNT)
            end)
        else
            qy.hint:show(qy.TextUtil:substitute(11002))
        end
	end)
end

return ExCDKeyDialog
