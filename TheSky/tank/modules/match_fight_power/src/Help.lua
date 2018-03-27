--[[
	战力竞赛活动规则
	Author: 
	Date: 2016年07月20日15:37:08
]]

local Help = qy.class("Help", qy.tank.view.BaseView, "match_fight_power/ui/Help")

function Help:ctor(delegate)
    Help.super.ctor(self)

	self:InjectView("Help_txt")
    
	

	local helpData = qy.tank.model.HelpTxtModel:getHelpDataByIndx(23)
    self.Help_txt:setAnchorPoint(0,1)
    self.Help_txt:setPosition(15, 475)
    self.Help_txt:setString(helpData.content)
end

return Help                   
