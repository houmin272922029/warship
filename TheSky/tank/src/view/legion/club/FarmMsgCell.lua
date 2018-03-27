--[[
	农场获得消息cell
	Author: H.X.Sun
]]

local FarmMsgCell = qy.class("FarmMsgCell", qy.tank.view.BaseView)

function FarmMsgCell:ctor(delegate)
    FarmMsgCell.super.ctor(self)
    self.model = qy.tank.model.LegionModel
end

function FarmMsgCell:update(data)
    if tolua.cast(self.richTxt,"cc.Node") then
        self.richTxt:getParent():removeChild(self.richTxt)
    end
    local font = qy.res.FONT_NAME
    local font_size = qy.InternationalUtil:getFarmMsgCellFontSize()

    local farmData = self.model:getFarmDataByIdx(data.tag)
    local get_color = self.model:getColorByIdx(2,data.tag)
    self.richTxt = ccui.RichText:create()
    self.richTxt:ignoreContentAdaptWithSize(false)
    self.richTxt:setContentSize(650,40)
    self.richTxt:setAnchorPoint(0,0.5)
    local stringTxt1 = ccui.RichElementText:create(1, cc.c3b(199,182,130), 255, data.nickname , font, font_size)
    self.richTxt:pushBackElement(stringTxt1)
    local stringTxt2 = ccui.RichElementText:create(2, cc.c3b(255,255,255), 255, qy.TextUtil:substitute(51017) , font, font_size)
    self.richTxt:pushBackElement(stringTxt2)
    local stringTxt3 = ccui.RichElementText:create(3, get_color, 255, farmData.name , font, font_size)
    self.richTxt:pushBackElement(stringTxt3)
    local stringTxt4 = ccui.RichElementText:create(4, cc.c3b(255,255,255), 255, qy.TextUtil:substitute(51018) , font, font_size)
    self.richTxt:pushBackElement(stringTxt4)

    if farmData.legion_exp > 0 then
        local stringTxt5 = ccui.RichElementText:create(5, cc.c3b(241,53,3), 255, farmData.legion_exp, font, font_size)
        self.richTxt:pushBackElement(stringTxt5)
        local stringTxt6 = ccui.RichElementText:create(6, cc.c3b(255,255,255), 255, qy.TextUtil:substitute(51019) , font, font_size)
        self.richTxt:pushBackElement(stringTxt6)
    end

    if farmData.contribution > 0 then
        local stringTxt7 = ccui.RichElementText:create(7, cc.c3b(241,53,3), 255, farmData.contribution, font, font_size)
        self.richTxt:pushBackElement(stringTxt7)
        local stringTxt8 = ccui.RichElementText:create(8, cc.c3b(255,255,255), 255, qy.TextUtil:substitute(51020) , font, font_size)
        self.richTxt:pushBackElement(stringTxt8)
    end

    self.richTxt:setPosition(0,5)
    self:addChild(self.richTxt)
end

return FarmMsgCell
