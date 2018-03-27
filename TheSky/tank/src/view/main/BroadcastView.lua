local BroadcastView = qy.class("BroadcastView", qy.tank.view.BaseView, "view/main/BroadcastView")

local Model = require("module.chat.Model")
local ColorMapUtil = qy.tank.utils.ColorMapUtil

local WIDTH = 538.00
local FONT_SIZE = 24

function BroadcastView:ctor()
    BroadcastView.super.ctor(self)

    self:InjectView("Panel_1")

    self._richTexts = {}
    self._isEnd = false
end

function BroadcastView:makeText(text, color)
    return ccui.RichElementText:create(1, color or display.COLOR_WHITE, 255, text, qy.res.FONT_NAME_2, FONT_SIZE)
end

function BroadcastView:show(content)
    local richText = ccui.RichText:create()
    richText:setAnchorPoint(0, 0.5)
    richText:setPosition(WIDTH, 19.5)
    richText:addTo(self.Panel_1)
    table.insert(self._richTexts, richText)
    local arr = string.split(content, "&")
    if arr then
        for _, v in ipairs(arr) do
            local cstr = string.split(v, "#")
            if cstr then
                richText:pushBackElement(self:makeText(cstr[1], ColorMapUtil.qualityMapColor(tonumber(cstr[2]) or 1)))
            else
                richText:pushBackElement(self:makeText(cstr))
            end
        end
    else
        richText:pushBackElement(self:makeText(content))
    end
    richText:formatText()
    local speed1 = (richText:getContentSize().width + WIDTH / 2) / 100.0
    local speed2 = (WIDTH / 2) / 100.0
    richText:runAction(cc.Sequence:create(
        cc.MoveBy:create(speed1, cc.p(-(richText:getContentSize().width + WIDTH / 2), 0)),
        cc.CallFunc:create(function()
            print("插放下一段")
            self:setMsg()
        end),
        cc.MoveBy:create(speed2, cc.p(-WIDTH / 2, 0)),
        cc.CallFunc:create(function(obj)
            obj:removeSelf()
            if self._isEnd then
                self:runAction(cc.Sequence:create(
                    cc.FadeOut:create(0.75),
                    cc.Hide:create()
                ))
                print("结束")
            end
        end)
    ))
end

function BroadcastView:setMsg()
    local msg = Model:getBroadcast()
    if msg then
        self._isEnd = false
        self:setVisible(true)
        self:setOpacity(255)
        self:show(msg.content)
    else
        self._isEnd = true
    end
end

function BroadcastView:onEnter()
    self._message_listener = qy.Event.add(Model.Event.MESSAGE, function(event)
        if self:isVisible() then
            return
        end
        self:setMsg()
    end)
end

function BroadcastView:onExit()
    self:setVisible(false)
    for _, richText in ipairs(self._richTexts) do
        if tolua.cast(richText,"cc.Node") then
            richText:removeSelf()
        end
    end
    if #self._richTexts > 0 then
        self._richTexts = {}
    end
end

function BroadcastView:onCleanup()
    if self._message_listener then
        qy.Event.remove(self._message_listener)
    end
end

return BroadcastView
