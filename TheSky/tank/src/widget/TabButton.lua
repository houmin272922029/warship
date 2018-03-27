--[[
	tab单个按钮
	Author: Aaron Wei
	Date: 2015-04-14 18:55:10
]]

local TabButton = qy.class("TabButton", qy.tank.view.BaseView)

function TabButton:ctor(csd,label,idx,callback)
    TabButton.super.ctor(self)

	self:InjectView("button")

    self:OnClick("button", function(sender)
    	if callback then
        	callback(self)
    	end
    end, {["audioType"] = qy.SoundType.SWITCH_TAB,["isScale"] = false})

    self.idx = idx
    self.button:setTitleText(label)
    self.button:setTitleFontName(qy.res.FONT_NAME)
    self.button:getTitleRenderer():enableOutline(cc.c4b(0,0,0,255),1)
end

function TabButton:setSelected(selected)
    self.button:setEnabled(not selected)
    self.button:setBright(not selected)
    -- self.button:setScale(selected and 1.05 or 1.0)
    -- self:setLocalZOrder(selected and 0 or -10)
end

function TabButton:setTitleText(label)
    self.button:setTitleText(label)
end
function TabButton:setTitleColor( color )
    self.button:setTitleColor(color)
end

return TabButton
