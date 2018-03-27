--[[
	军团战-帮助
	Author: H.X.Sun
]]

local HelpList = qy.class("HelpList", qy.tank.view.BaseView)

function HelpList:ctor(params)
    HelpList.super.ctor(self)

    local head = qy.tank.view.legion.war.HelpCell.new(params)
    self:addChild(head)
    head:setPosition(0,-10)

    local helpData = qy.tank.model.HelpTxtModel:getHelpDataByIndx(3)
    self.contentTxt = cc.Label:createWithTTF(helpData.content,qy.res.FONT_NAME_2, 22.0,cc.size(880,0),0)
    self.contentTxt:setAnchorPoint(0,1)
	self.h = self.contentTxt:getContentSize().height
    self:addChild(self.contentTxt)
    self.contentTxt:setPosition(60,-66)
end

function HelpList:getHight()
    return self.h + 66
end


return HelpList
