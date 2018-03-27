--[[
	开宴会cell
	Author: H.X.Sun
]]

local OpenPCell = qy.class("OpenPCell", qy.tank.view.BaseView)

function OpenPCell:ctor(delegate)
    OpenPCell.super.ctor(self)
    self.model = qy.tank.model.LegionModel

    local font = qy.res.FONT_NAME
    local font_size = qy.InternationalUtil:getOpenPCellFontSize()
    self.richTxt = ccui.RichText:create()
    self.richTxt:ignoreContentAdaptWithSize(false)
    self.richTxt:setContentSize(550,40)
    self.richTxt:setAnchorPoint(0,0.5)
    local stringTxt1 = ccui.RichElementText:create(1, cc.c3b(253,229,148), 255, qy.TextUtil:substitute(51022) , font, font_size)
    self.richTxt:pushBackElement(stringTxt1)
    local stringTxt2 = ccui.RichElementText:create(2, cc.c3b(241,49,4), 255, qy.TextUtil:substitute(51023) , font, font_size)
    self.richTxt:pushBackElement(stringTxt2)
    local stringTxt3 = ccui.RichElementText:create(3, cc.c3b(253,229,148), 255, qy.TextUtil:substitute(51024) , font, font_size)
    self.richTxt:pushBackElement(stringTxt3)
    local stringTxt4 = ccui.RichElementText:create(4, cc.c3b(241,49,4), 255, qy.TextUtil:substitute(51025) , font, font_size)
    self.richTxt:pushBackElement(stringTxt4)
    local stringTxt5 = ccui.RichElementText:create(5, cc.c3b(253,229,148), 255, qy.TextUtil:substitute(51026) , font, font_size)
    self.richTxt:pushBackElement(stringTxt5)
    local stringTxt6 = ccui.RichElementText:create(6, cc.c3b(241,49,4), 255, qy.TextUtil:substitute(51027) , font, font_size)
    self.richTxt:pushBackElement(stringTxt6)
    local stringTxt7 = ccui.RichElementText:create(7, cc.c3b(253,229,148), 255, qy.TextUtil:substitute(51028) , font, font_size)
    self.richTxt:pushBackElement(stringTxt7)
    local stringTxt8 = ccui.RichElementText:create(8, cc.c3b(241,49,4), 255, qy.TextUtil:substitute(51025) , font, font_size)
    self.richTxt:pushBackElement(stringTxt8)
    local stringTxt9 = ccui.RichElementText:create(9, cc.c3b(253,229,148), 255, qy.TextUtil:substitute(51030) , font, font_size)
    self.richTxt:pushBackElement(stringTxt9)
    self.richTxt:setPosition(0,50)
    self:addChild(self.richTxt)

    self.partyList = {}
    for i = 1, 3 do
        self.partyList[i] = qy.tank.view.legion.club.PartyItem.new({
            ["idx"] = i,
            ["callback"] = delegate.callback,
        })
        self.partyList[i]:setPosition(2,532 - 150 * i)
        self:addChild(self.partyList[i])
    end
end

return OpenPCell
