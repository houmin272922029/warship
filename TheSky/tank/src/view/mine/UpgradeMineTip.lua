--[[--
    升级训练位提示
    Author: H.X.Sun
    Date: 2015-06-24
--]]--
local UpgradeMineTip = qy.class("UpgradeMineTip", qy.tank.view.BaseView)

function UpgradeMineTip:ctor(delegate)
	UpgradeMineTip.super.ctor(self)

	local richTxt = ccui.RichText:create()
    richTxt:ignoreContentAdaptWithSize(false)
    local _w = 450
    local _h = 60
    local _fontSize = 22
    local _op = 255
    richTxt:setContentSize(_w, _h)
    richTxt:setAnchorPoint(0,0.5)
    local color1 = cc.c3b(255,255,255)
    local color2 = cc.c3b(249, 39, 111)

    local stringTxt1 = ccui.RichElementText:create(1, color1, _op, qy.TextUtil:substitute(21043) .. "  " , qy.res.FONT_NAME_2, _fontSize)
    richTxt:pushBackElement(stringTxt1)
   	local icon = ccui.RichElementImage:create(2,color1, _op, "Resources/common/icon/coin/1a.png")
    richTxt:pushBackElement(icon)

    if delegate.type == 1 then
        --生产力
        local stringTxt3 = ccui.RichElementText:create(3, color1, _op,delegate.entity:getUpgradeProductivityCost() .. "  "..qy.TextUtil:substitute(21045) , qy.res.FONT_NAME_2, _fontSize)
        richTxt:pushBackElement(stringTxt3)
        local stringTxt4 = ccui.RichElementText:create(4, delegate.entity:getProductivityColorFor3b(), _op, qy.TextUtil:substitute(21044) , qy.res.FONT_NAME_2, _fontSize)
        richTxt:pushBackElement(stringTxt4)
        local stringTxt5 = ccui.RichElementText:create(5, color1, _op,qy.TextUtil:substitute(21046) , qy.res.FONT_NAME_2, _fontSize)
        richTxt:pushBackElement(stringTxt5)
        local stringTxt6 = ccui.RichElementText:create(6, delegate.entity:getProductivityColorFor3b(), _op, delegate.percentTxt, qy.res.FONT_NAME_2, _fontSize)
        richTxt:pushBackElement(stringTxt6)
    else
        --掠夺力
        local stringTxt3 = ccui.RichElementText:create(3, color1, _op,delegate.entity:getUpgradePlunderCost() .. "  "..qy.TextUtil:substitute(21045) , qy.res.FONT_NAME_2, _fontSize)
        richTxt:pushBackElement(stringTxt3)
        local stringTxt4 = ccui.RichElementText:create(4, delegate.entity:getPlunderColorFor3b(), _op, qy.TextUtil:substitute(21044) , qy.res.FONT_NAME_2, _fontSize)
        richTxt:pushBackElement(stringTxt4)
        local stringTxt5 = ccui.RichElementText:create(5, color1, _op,qy.TextUtil:substitute(21048) , qy.res.FONT_NAME_2, _fontSize)
        richTxt:pushBackElement(stringTxt5)
        local stringTxt6 = ccui.RichElementText:create(6, delegate.entity:getPlunderColorFor3b(), _op, delegate.percentTxt, qy.res.FONT_NAME_2, _fontSize)
        richTxt:pushBackElement(stringTxt6)
    end

    self:addChild(richTxt)
    if qy.cocos2d_version ~= qy.COCOS2D_3_7_1 then
        richTxt:setPosition(-_w/2, -_h + 15)
    else
        richTxt:setPosition(-_w/2, -_h)
    end
end

return UpgradeMineTip
