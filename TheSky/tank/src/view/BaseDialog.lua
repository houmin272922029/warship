--[[
    说明: 弹窗基类, 自带半透明背景, 所有继承的弹窗不需要再增加透明背景

    用法：
        qy.tank.view.campaign.CheckpointAwardDialog.new():show(true)

    类示例：
        local CheckpointAwardDialog = class("CheckpointAwardDialog", function()
            return qy.tank.view.BaseDialog.new("view/campaign/CheckpointAwardDialog")
        end)

        function CheckpointAwardDialog:ctor(delegate)
    CheckpointAwardDialog.super.ctor(self)

            -- 通用弹窗样式
            local style = qy.tank.view.style.DialogStyle2.new({
                size = cc.size(560,280),
                position = cc.p(0,0),
                offset = cc.p(0,0),

                ["onClose"] = function()
                    self:dismiss()
                end
            })
            self:addChild(style)
        end

        return CheckpointAwardDialog
]]

local BaseDialog = qy.class("BaseDialog", qy.tank.widget.PopupWindowWrapper)

function BaseDialog:ctor()
    BaseDialog.super.ctor(self)
    self.isPopup = true

    self:setContentSize(qy.winSize.width, qy.winSize.height)
end
--注册边框样式，  zIndex为z轴深度，zIndex如果不填，则边框添加到内容的最上面
--可以注册多个styleBorder
function BaseDialog:registStyleBorder(styleBorder , zIndex)
    if styleBorder ~=nil then
        if zIndex ==nil then
            self:addChild(styleBorder)
        else
            self:addChild(styleBorder , zIndex)
        end

    end
end

function BaseDialog:show(hideButton)
    if hideButton and self.closeButton then
        self:removeView(self.closeButton)
    end
    qy.tank.manager.ScenesManager:getRunningScene():showDialog(self)
    if self.isPopup then
        self:toShowPopupEffert()
    end
end

function BaseDialog:dismiss()
    qy.tank.manager.ScenesManager:getRunningScene():dismissDialog()
end

function  BaseDialog:dismissAll()
    qy.tank.manager.ScenesManager:getRunningScene():disissAllDialog()
end

function BaseDialog:isShowing()

end

function BaseDialog:setOnDismissListener(listener)
    self._dismissListener = listener
end

return BaseDialog
