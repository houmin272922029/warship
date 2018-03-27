local Widget = qy.class("Widget", qy.tank.view.BaseView)

local ChatController = require("module.chat.Controller")
local ColorMapUtil = qy.tank.utils.ColorMapUtil

local MOVE_INCH = 7.0/160.0
local function convertDistanceFromPointToInch(pointDis)
    local glview = cc.Director:getInstance():getOpenGLView()
    local factor = (glview:getScaleX() + glview:getScaleY())/2
    return pointDis * factor / cc.Device:getDPI()
end

-- 消息通知事件
local message_listener = nil

local Model = require("module.chat.Model")
local FONT_SIZE = 18

function Widget:ctor()
    Widget.super.ctor(self)

    self:setCascadeColorEnabled(true)
    self:setCascadeOpacityEnabled(true)

    local touchMoved = false
    local background = ccui.Layout:create()
    background:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
    background:setBackGroundColor(cc.c3b(0, 0, 0))
    background:setBackGroundColorOpacity(100)
    background:setContentSize(305, 80)
    background:setAnchorPoint(0, 0)
    background:setPosition(0, 117.5)
    background:setTouchEnabled(true)
    background:addTouchEventListener(function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            qy.QYPlaySound.playEffect(qy.SoundType.COMMON_CLICK)
            touchMoved = false
        elseif eventType == ccui.TouchEventType.moved then
            local touchPoint = sender:getTouchBeganPosition()
            local moveDistance = sender:getTouchMovePosition()
            moveDistance.x = moveDistance.x - touchPoint.x
            moveDistance.y = moveDistance.y - touchPoint.y
            local dis = math.sqrt(moveDistance.x * moveDistance.x + moveDistance.y * moveDistance.y)
            if math.abs(convertDistanceFromPointToInch(dis)) >= MOVE_INCH then
                touchMoved = true
            end
        else
            if not touchMoved then
                ChatController:startController(ChatController.new())
            end
        end
    end)
    self:addChild(background)

    local listView = ccui.ListView:create()
    listView:setDirection(ccui.ScrollViewDir.vertical)
    listView:setBounceEnabled(true)
    listView:setContentSize(300, 75)
    listView:setAnchorPoint(0, 0)
    listView:setPosition(0, 120)
    listView:setItemsMargin(5)
    listView:setTouchEnabled(false)
    listView:registerScriptHandler(function(event)
        if event == "enter" then
            listView:forceDoLayout()
            listView:jumpToBottom()
        end
    end)
    self:addChild(listView)

    if message_listener then
        qy.Event.remove(message_listener)
    end

    message_listener = qy.Event.add(Model.Event.MESSAGE, function(event)
        local dolayout = false
        local data = event._usedata

        local blackList = qy.tank.model.BlackModel.blackList
        
        if #data == 0 then
            for k=1,20 do
                if  blackList  and #blackList > 0 then
                    for k,v in pairs(data) do
                        for j=1,#blackList do
                            if k == "from" then
                                if v.id == blackList[j].kid then
                                    data = nil
                                    return
                                end
                            end
                        end
                    end
                end
            end
        end
        for k=1,20 do
            if  blackList  and #blackList > 0 then
                for i=1,#data do
                    for j=1,#blackList do
                        if data[i] and data[i].from then
                            if data[i].from.id == blackList[j].kid then
                                table.remove(data, i)
                            end
                        end
                    end
                end
            end
        end
        if not data.content then
            -- 只读取3条记录
            local start = math.max(#data - 2, 1)
            for i = start, #data do
                if data[i].channel then
                    if data[i].from  and #blackList > 0 then
                        -- for j=1,#blackList do
                        --     if data[i] and data[i].from then
                        --         if data[i].from.id ~= blackList[j].kid then
                                    listView:pushBackCustomItem(self:makeItem(data[i]))
                                    dolayout = true
                        --         end
                        --     end
                        -- end
                    else
                        listView:pushBackCustomItem(self:makeItem(data[i]))
                        dolayout = true
                    end
                end
            end
        else
            -- 只读取3条记录
            if #listView:getItems() >= 3 then
                if data.channel and data.from and #blackList > 0 then
                    -- for j=1,#blackList do
                    --     if data and data.from then
                    --         if data.from.id ~= blackList[j].kid then
                                listView:removeItem(0)
                    --         end
                    --     end
                    -- end
                else
                    listView:removeItem(0)
                end
            end
            if data.channel then
                if data.from and #blackList > 0 then
                    -- for j=1,#blackList do
                    --     if data and data.from then
                    --         if data.from.id ~= blackList[j].kid then
                                listView:pushBackCustomItem(self:makeItem(data))
                                dolayout = true
                    --         end
                    --     end
                    -- end
                else
                    listView:pushBackCustomItem(self:makeItem(data))
                    dolayout = true
                end
            end
        end
        if dolayout then
            listView:forceDoLayout()
            listView:jumpToBottom()
        end
    end)

    -- 链接聊天服务器
    self:runAction(cc.Sequence:create(cc.DelayTime:create(0.1), cc.CallFunc:create(function()
        Model:connect()
    end)))
end

function Widget:makeItem(itemData)
    if not itemData.content then -- 容错处理
        itemData.content = '***'
    end
    local richText = ccui.RichText:create()

    -- 处理频道
    self:handlerChannel(richText, itemData.channel)
    if itemData.channel.id == 1 or (itemData.channel.id == 2 and itemData.from) or itemData.channel.id == 6 then
        --fq 2016年08月18日14:24:58
        if itemData.model_type then            
            if itemData.model_type == "group_battles" then
                self:handlerContent(richText, itemData.content)
            end
            if itemData.model_type == "medal_info" then
                self:handlerContent(richText, itemData.content.nickname)
                local data = itemData.content.medal_info
                local model = qy.tank.model.MedalModel
                local name = ""
                local medal_id = data.medal_id
                local medaldata = model.medalcfg[medal_id..""]
                name = medaldata.name
                local color = qy.tank.utils.ColorMapUtil.qualityMapColorFor3b(medaldata.medal_colour)
                richText:pushBackElement(self:makeText("[" .. name .. "]", color))
            end
            if itemData.model_type == "intruder_time" then
                self:handlerContent(richText, itemData.content)
            end
        else 
            self:handlerUser(richText, itemData.from)
            self:handlerContent(richText, qy.TextUtil:substitute(69009).. " " .. itemData.content)
        end
    elseif itemData.channel.id == 3 then
        self:handlerUser(richText, itemData.from)
        if itemData.to and itemData.to.name then
            self:handlerContent(richText, qy.TextUtil:substitute(69008))
            self:handlerUser(richText, itemData.to)
        end
        self:handlerContent(richText, qy.TextUtil:substitute(69009) .. " " .. itemData.content)
    elseif itemData.channel.id == 4 then
        self:handlerUser(richText, itemData.from)
        self:handlerContent(richText, itemData.content)
        if itemData.to and itemData.to.name then
            self:handlerUser(richText, itemData.to)
        end
    else
        if itemData.model_type then            
            if itemData.model_type == "group_battles" then
                self:handlerContent(richText, itemData.content)
            end
            if itemData.model_type == "AttackBerlin.invite" then   
                self:handlerContent(richText, itemData.content.msg)
            end
            if itemData.model_type == "AttackBerlin.bossCombat" then  
                self:handlerContent(richText, itemData.content)
            end
        else     
            self:handlerUser(richText, itemData.from)
            self:handlerContent(richText, itemData.content)
        end
    end

    richText:setAnchorPoint(0, 1)
    richText:setPosition(0, 0)
    richText:formatText()

    return richText
end

function Widget:handlerChannel(richText, channel)
    richText:pushBackElement(self:makeText("【" .. channel.name .. "】", channel.color))
end

function Widget:handlerUser(richText, user)
    if not user then
        return
    end
    richText:pushBackElement(self:makeText(" " .. user.name, cc.c3b(216, 197, 157)))
    if user.title and string.len(user.title) > 0 then
        richText:pushBackElement(self:makeText("(" .. user.title .. ")"))
    end
end

function Widget:handlerContent(richText, content)
    if type(content) ~= "table" then
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
            richText:pushBackElement(self:makeText(" " .. content))
        end
    else
        for i,v in ipairs(content) do
            if type(v) == "string" then
                richText:pushBackElement(self:makeText((i == 1 and " " or "") .. v))
            else
                -- 带id可点击
                if v.id then
                    richText:pushBackElement(self:makeText(" " .. v.text, cc.c3b(unpack(string.split(v.color, ",")))))
                else
                    richText:pushBackElement(self:makeText(v.text, cc.c3b(unpack(string.split(v.color, ",")))))
                end
            end
        end
    end
end

function Widget:makeText(text, color)
    return ccui.RichElementText:create(1, color or display.COLOR_WHITE, 255, text, qy.res.FONT_NAME, FONT_SIZE)
end

return Widget
