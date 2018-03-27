local TipsDialog = qy.class("TipsDialog", qy.tank.view.BaseDialog, "inter_service_escort.ui.TipsDialog")

function TipsDialog:ctor(delegate)
   	TipsDialog.super.ctor(self)

   	self:InjectView("ContentBg")
   	-- self:InjectView("TankBg2")
   	-- self:InjectView("star1_1")

   	self:OnClick("Btn_cancel", function()
        self:dismiss()
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})

    self:OnClick("Btn_ok", function()
        self:dismiss()
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})
end

function TipsDialog:addList(params)
    local richText = ccui.RichText:create()

    local color = cc.c3b(203, 188, 153)
    for i, v in pairs(params) do
    	 richText:pushBackElement(self:makeText(v, color))
    end
    richText:setPosition(210, 45)
    richText:ignoreContentAdaptWithSize(false)
    richText:setContentSize(cc.size(380, 70))
    self.ContentBg:addChild(richText)
end

function TipsDialog:addRichText(data)
    local richText = ccui.RichText:create()

    richText:setPosition(210, 45)
    richText:ignoreContentAdaptWithSize(false)
    richText:setContentSize(cc.size(380, 70))

    if data.type == 1 then
        local info1 = self:makeText(qy.TextUtil:substitute(44040) .. data.num, cc.c3b(255, 255, 255))
        richText:pushBackElement(info1)
    elseif data.type == 2 then
        if data.is_win then
            local info1 = self:makeText(qy.TextUtil:substitute(90319), cc.c3b(255, 255, 255))
            local plunder_nickname = self:makeText(data.plunder_nickname, cc.c3b(244, 30, 29))
            local info2 = self:makeText(qy.TextUtil:substitute(90320), cc.c3b(255, 255, 255))

            richText:pushBackElement(info1)
            richText:pushBackElement(plunder_nickname)
            richText:pushBackElement(info2)
        else
            -- local plunder_nickname = self:makeText(data.plunder_nickname, cc.c3b(244, 30, 29))
            -- local info1 = self:makeText("打劫你的押运队伍失败，知难而退，点击押运记录查看战报！", cc.c3b(255, 255, 255))
            -- richText:pushBackElement(plunder_nickname)
            -- richText:pushBackElement(info1)
        end
    end

    self.ContentBg:addChild(richText)
end

function TipsDialog:makeText(text, color)
    return ccui.RichElementText:create(1, color or display.COLOR_WHITE, 255, text, qy.res.FONT_NAME, 22)
end

return TipsDialog
