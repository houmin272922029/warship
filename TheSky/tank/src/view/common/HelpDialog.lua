--[[
	统一帮助类
]]
local HelpDialog = qy.class("HelpDialog", qy.tank.view.BaseDialog, "view/common/HelpDialog")

function HelpDialog:ctor(delegate)
    HelpDialog.super.ctor(self)
	--通用弹窗样式
	local style = qy.tank.view.style.DialogStyle3.new({
		size = cc.size(860,520),
		position = cc.p(0,0),
		offset = cc.p(0,0),

		["onClose"] = function()
			self:dismiss()
		end
	})
	self:addChild(style, -1)
	self:InjectView("titleTxt")
	self:InjectView("scrollView")
	style.title_bg:setVisible(false)

    local helpData = {}
    if tonumber(delegate) then
        helpData = qy.tank.model.HelpTxtModel:getHelpDataByIndx(delegate)
    elseif type(helpData) == "table" then
        helpData = delegate
    else
        helpData = {
			["title"] = qy.TextUtil:substitute(8032),
			["content"] = "",
				}
    end

	self.contentTxt = cc.Label:createWithSystemFont(helpData.content,nil,22,cc.size(730,0),cc.TEXT_ALIGNMENT_LEFT,cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	self.contentTxt:setAnchorPoint(0,1)
	local h = self.contentTxt:getContentSize().height
	if h < 360 then
		h = 360
	end
	self.contentTxt:setPosition(25,h)
	self.scrollView:addChild(self.contentTxt)
	self.titleTxt:setString(helpData.title)
	-- self.contentTxt:setString(delegate.content)
	self.scrollView:setInnerContainerSize(cc.size(730,h))
end

return HelpDialog
