--[[
--消息 Dialog
--Author: mingming
--Date: 2015.08
]]

local MessageDialog = qy.class("MessageDialog", qy.tank.view.BaseView, "view/main/MessageDialog")

function MessageDialog:ctor(delegate, node)
    MessageDialog.super.ctor(self)

    self.delegate = delegate

    self:InjectView("Content")
    self:InjectView("Time")
    self:InjectView("ScrollView_1")

    self.Content:getVirtualRenderer():setMaxLineWidth(550)
    self.Content:setString(qy.tank.utils.TextUtil:format(delegate.data.content))
    -- self.Title:setSpriteFrame("Resources/main_city/war_report_000".. titleType ..".png")

    local height = self.Content:getContentSize().height + self.Time:getContentSize().height + 200

    self.Content:setPositionY(height - 25)
    self.Time:setString(os.date("%y-%m-%d %H:%M", delegate.data.uptime))

    self.ScrollView_1:setInnerContainerSize(cc.size(570, height))
    self.ScrollView_1:setScrollBarEnabled(false)

    self.Time:setPositionY(50)

    self:OnClick("Next", function(sendr)
        delegate.next(self)
    end)

    self:OnClick("Check", function(sendr)
        delegate.check(node, delegate.mType_.mType)
    end)

    qy.Event.dispatch(qy.Event.MESSAGE_UPDATE, {["mType"] = delegate.mType_.mType, ["flag"] = false})

    local messages = qy.tank.model.RedDotModel.messages
    local index = table.keyof(messages, delegate.mType_.mType)
    table.remove(qy.tank.model.RedDotModel.messages, index)
end

function MessageDialog:setData(data)
    self.Content:setString(qy.tank.utils.TextUtil:format(data.content))

    self.Time:setString(os.date("%y-%m-%d %H:%M", data.uptime))

    local height = self.Content:getContentSize().height + self.Time:getContentSize().height + 200
    self.Content:setPositionY(height - 25)
    self.ScrollView_1:setInnerContainerSize(cc.size(570, height))
end

return MessageDialog