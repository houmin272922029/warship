local TipsDialog = qy.class("TipsDialog", qy.tank.view.BaseDialog, "service_faction_war/ui/TipsDialog")

function TipsDialog:ctor(delegate)
   	TipsDialog.super.ctor(self)

   	self:InjectView("ContentBg")

   	self:OnClick("Btn_cancel", function()
        self:dismiss()
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})

    self:OnClick("Btn_ok", function()
        self:dismiss()
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})
end
function TipsDialog:addRichText(data)
    local richText = ccui.RichText:create()

    richText:setPosition(210, 45)
    richText:ignoreContentAdaptWithSize(false)
    richText:setContentSize(cc.size(380, 70))

    if data then
        local info1 = self:makeText("您被", cc.c3b(255, 255, 255))
        local plunder_nickname = self:makeText("红色阵营,海军本部大将,狗蛋", cc.c3b(244, 30, 29))
        local plunder_num = self:makeText("999999", cc.c3b(244, 30, 29))
        local info2 = self:makeText("击败,收益减半,获得", cc.c3b(255, 255, 255))
        local info3 = self:makeText("功勋", cc.c3b(255, 255, 255))

        richText:pushBackElement(info1)
        richText:pushBackElement(plunder_nickname)
        richText:pushBackElement(info2)
        richText:pushBackElement(plunder_num)
        richText:pushBackElement(info3)
    else
    end
    self.ContentBg:addChild(richText)
end

function TipsDialog:makeText(text, color)
    return ccui.RichElementText:create(1, color or display.COLOR_WHITE, 255, text, qy.res.FONT_NAME, 22)
end

return TipsDialog
