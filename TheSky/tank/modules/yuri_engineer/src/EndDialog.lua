--[[
]]
local EndDialog = qy.class("EndDialog", qy.tank.view.BaseDialog, "yuri_engineer.ui.EndDialog")


function EndDialog:ctor(delegate)
    EndDialog.super.ctor(self)

    self.model = qy.tank.model.YuriEngineerModel
    self.service = qy.tank.service.YuriEngineerService

    local callback = delegate.callback
    local checkpoint = delegate.checkpoint

    self.style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(530,330),
        position = cc.p(0,0),
        offset = cc.p(0,0),
        bgShow = false,
        titleUrl = "yuri_engineer/res/7.png",


        ["onClose"] = function()
            callback()
            self:removeSelf()
        end
    })
    self:addChild(self.style , 1)

    self:InjectView("Bg")
    self:InjectView("Btn_share")
    self:InjectView("Btn_confrim")
    self:InjectView("Text_limit")
    self:InjectView("Text_checkpoint")
    self:InjectView("Text_silver")
    self:InjectView("Text_3")
    self:InjectView("Text_diamond") 

    if checkpoint <= 1 then
        self.Btn_share:setBright(false)
    end

    self:OnClick("Btn_confrim", function(sender)
        callback()
        self:removeSelf()
    end)

    self:OnClick("Btn_share", function(sender)
        if self.Btn_share:isBright() then
            self.service:share(function()
                qy.hint:show(qy.TextUtil:substitute(90303))
            end)
        end
    end)


    if self.model.award then
        for i = 1, #self.model.award do
            local _type = tostring(self.model.award[i].type)
            local num = self.model.award[i].num
            if _type == "1" then
                self.Text_diamond:setString(self.model.award[i].num)
            elseif _type == "3" then
                self.Text_silver:setString(self.model.award[i].num)
            elseif _type == "28" then
                self.Text_3:setString(self.model.award[i].num)
            end
        end
    end


    if self.model.upper_imit == 1 then
        self.Text_limit:setVisible(true)
    else
        self.Text_limit:setVisible(false)
    end

    self.Text_checkpoint:setString(self.model.level)
end


return EndDialog
