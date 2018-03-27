--[[
    成就 升级属性预览表
    Author: mingming
    Date: 2015-08-21 16:28:15
]]

local CommentDialog = qy.class("CommentDialog", qy.tank.view.BaseDialog)

local model = qy.tank.model.AchievementModel
function CommentDialog:ctor(entity)
    CommentDialog.super.ctor(self)

    -- 通用弹窗样式
    local style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(875, 540),   
        position = cc.p(0, 0),
        offset = cc.p(0, 0),
        titleUrl = "Resources/common/title/zhanchejianshang.png",
        
        ["onClose"] = function()
            self:dismiss()
        end
    })
    self:addChild(style)
    style:setLocalZOrder(-1)
    self.style = style

    local view = qy.tank.view.achievement.CommentDialog2.new(entity)
    self.view = view
    local winSize = cc.Director:getInstance():getWinSize()
    local x = (winSize.width - 1080) / 2 
    view:setPosition(-100 - x, -100)
    style.bg:addChild(view)
end

return CommentDialog


