--[[
    邮件
    Author: H.X.Sun
    Date: 2015-04-24
]]

local MailCell = qy.class("MailCell", qy.tank.view.BaseView, "view/mail/MailCell")

function MailCell:ctor(delegate)
    MailCell.super.ctor(self)
    self:InjectView("light")
    self:InjectView("icon")
    self:InjectView("title")
    self:InjectView("content")
    self:InjectView("bg")
    self:InjectView("msg_node")
    self:InjectView("more_msg")

    if self.redDot == nil then
        self.redDot = qy.tank.view.common.RedDot.new({})
        self.msg_node:addChild(self.redDot)
        self.redDot:setPosition(81, 62)
    end
    self.redDot:update(true)
end

function MailCell:render(entity, nIdx)
    if entity then
        self.msg_node:setVisible(true)
        self.more_msg:setVisible(false)
        self.icon:setSpriteFrame(entity:getIcon())
        self.title:setTextColor(entity:getNameTextColor())
        self.content:setString(entity.content)
        if nIdx == 2 then
            self.title:setString("["..entity:getSenderName() .. "]")
        else
            self.title:setString("["..entity:getReceiverName() .. "]")
        end
        local titleSize = self.title:getContentSize()
        self.content:setPosition(self.title:getPositionX()+ titleSize.width + 10, self.title:getPositionY())
        local contentWidth = 270 - titleSize.width
        qy.tank.utils.TextUtil:autoChangeLine(self.content , cc.size(contentWidth , 25))

        self.content:setVisible(qy.InternationalUtil:isShowMailContents())

        if entity:hasRedDot() then
            self.redDot:setVisible(true)
        else
            self.redDot:setVisible(false)
        end
    else
        self.msg_node:setVisible(false)
        self.more_msg:setVisible(true)
        self.redDot:setVisible(false)
    end
end

function MailCell:setSelected()
    self.light:setVisible(true)
end

function MailCell:removeSelected()
    self.light:setVisible(false)
end

return MailCell
