--[[
--消息 Dialog
--Author: mingming
--Date: 2015.08
]]

local MessageDialog = qy.class("MessageDialog", qy.tank.view.BaseDialog)

function MessageDialog:ctor(delegate)
    MessageDialog.super.ctor(self)

    self.delegate = delegate
    self:setCanceledOnTouchOutside(true)

    -- self:InjectView("Title")

    local style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(655, 559),   
        position = cc.p(0, 0),
        offset = cc.p(0, 0),
        titleUrl = "Resources/common/title/shuxingyulan.png",
        
        ["onClose"] = function()
            self:dismiss()
        end
    })
    self:addChild(style)
    style:setLocalZOrder(-1)

     local winSize = cc.Director:getInstance():getWinSize()
    local x = (winSize.width - 1080) / 2 
    local view = qy.tank.view.main.MessageDialog2.new(delegate, self)
    view:setPosition(-225 -x, -90)
    style.bg:addChild(view)

    local titleType = delegate.mType_.mType == 1 and 2 or 3
    local titie = titleType == 2 and "zongbuhedian" or "qianxianzhanbao"
    style:setTitle("Resources/common/title/" .. titie .. ".png")
end

return MessageDialog