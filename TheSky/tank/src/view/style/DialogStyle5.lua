--[[
	dialog边框样式5
	Author: H.X.Sun
	Date: 2015-05-22
]]

-- local DialogStyle5 = qy.class("DialogStyle5", qy.tank.widget.PopupWindowWrapper, "view/style/DialogStyle5")
local DialogStyle5 = qy.class("DialogStyle5", qy.tank.view.style.DialogBaseStyle, "view/style/DialogStyle5")

function DialogStyle5:ctor(params)
    DialogStyle5.super.ctor(self, params)

	-- self:OnClick(self.mask, function()
    --       	if params.onClose then
    --        		params.onClose()
    --        	end
    -- end, {["isScale"] = false})
	--背景
	self:InjectView("bg")
    self.bg:setContentSize(params.size.width,params.size.height)
    self.bg:setPosition(qy.winSize.width/2, qy.winSize.height/2)

	-- 框体
    self:InjectView("frame")
    self.frame:setSwallowTouches(false)
	self.frame:setPosition(qy.winSize.width/2, qy.winSize.height/2)
	self.frame:setContentSize(params.size.width + 9 ,params.size.height + 22)
end

return DialogStyle5
