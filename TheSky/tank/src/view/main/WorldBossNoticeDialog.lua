--[[
	世界BOSS消息引导
	Author: Aaron Wei
	Date: 2015-12-12 16:40:42
]]

local WorldBossNoticeDialog = qy.class("WorldBossNoticeDialog", qy.tank.view.BaseDialog, "view/main/WorldBossNoticeDialog")

function WorldBossNoticeDialog:ctor(delegate, node)
    WorldBossNoticeDialog.super.ctor(self)
    self.delegate = delegate
    self:setCanceledOnTouchOutside(true)
    self:InjectView("title")
    self:InjectView("description")
    self:InjectView("award")

    self:setTitle(delegate.title)
    self.description:setString(delegate.description)
    self.award:setString(delegate.award)

     -- 通用弹窗样式
    local style = qy.tank.view.style.DialogStyle5.new({
        size = cc.size(460,360),
        position = cc.p(0,0),
        offset = cc.p(0,0),
        -- ["onClose"] = function()
        --     self:dismiss()
        -- end
    })
    self:addChild(style, -1)

    self:OnClick("cancelBtn", function(sendr)
    	self:dismiss()
    end)

    self:OnClick("gotoBtn", function(sendr)
    	self:dismiss()
    	-- qy.tank.command.ActivitiesCommand:showActivity("boss")
        delegate.callback()
    end)
end

-- 改变title
function WorldBossNoticeDialog:setTitle(url)
    if cc.SpriteFrameCache:getInstance():getSpriteFrame(url) then
        self.title:setSpriteFrame(url)
    else
        self.title:setTexture(url)
    end
end

return WorldBossNoticeDialog
