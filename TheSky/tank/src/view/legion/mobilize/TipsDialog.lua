--[[
	提示
	Author: H.X.Sun
]]

local TipsDialog = qy.class("TipsDialog", qy.tank.view.BaseDialog, "legion/ui/mobilize/TipsDialog")

local ColorMapUtil = qy.tank.utils.ColorMapUtil

function TipsDialog:ctor(delegate)
    TipsDialog.super.ctor(self)
    local style = qy.tank.view.style.DialogStyle5.new({
        size = cc.size(500,290),
        position = cc.p(0,0),
        offset = cc.p(0,0),
    })
    self:addChild(style,-1)
    local model = qy.tank.model.LeMobilizeModel
    self:InjectView("container")

    self:OnClick("cancel_btn", function()
        self:dismiss()
    end)

    self:OnClick("confirm_btn", function()
        delegate.callBack()
        self:dismiss()
    end)

    local old_data = model:getConfigById(model:getSameTypeId())
    local new_data = model:getConfigById(delegate.id)

    local font_name = qy.res.FONT_NAME_2
    local font_size = 22
    local richTxt = ccui.RichText:create()
    richTxt:ignoreContentAdaptWithSize(false)
    richTxt:setContentSize(348, 100)
    richTxt:setAnchorPoint(0,0.5)
    local stringTxt1 = ccui.RichElementText:create(1, cc.c3b(255,255,255), 255, qy.TextUtil:substitute(52020) , font_name, font_size)
    richTxt:pushBackElement(stringTxt1)
    local stringTxt2 = ccui.RichElementText:create(2, ColorMapUtil.qualityMapColorFor3b(old_data.quality), 255, old_data.title, font_name, font_size)
    richTxt:pushBackElement(stringTxt2)
    local stringTxt3 = ccui.RichElementText:create(3, cc.c3b(255,255,255), 255, qy.TextUtil:substitute(52021) , font_name, font_size)
    richTxt:pushBackElement(stringTxt3)
    local stringTxt4 = ccui.RichElementText:create(4, ColorMapUtil.qualityMapColorFor3b(new_data.quality), 255, new_data.title, font_name, font_size)
    richTxt:pushBackElement(stringTxt4)
    local stringTxt5 = ccui.RichElementText:create(5, cc.c3b(255,255,255), 255, "?" , font_name, font_size)
    richTxt:pushBackElement(stringTxt5)
    richTxt:setPosition(-170,16)
    self.container:addChild(richTxt)
end

return TipsDialog
