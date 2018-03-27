local MainView = qy.tank.module.BaseUI.class("MainView", "csd.view.chat.MainView")

local Model = require("module.chat.Model")
local ChatUserInfoDialog = require("module.chat.UserInfoDialog")
local ChatBlockDialog = require("module.chat.BlockDialog")
local ChatInputNameDialog = require("module.chat.InputNameDialog")
local ColorMapUtil = qy.tank.utils.ColorMapUtil

local FONT_SIZE = 24
local LISTVIEW_WIDTH = 980
local LISTVIEW_HEIGHT = 437
local LISTVIEW_RECT = cc.rect((display.width - LISTVIEW_WIDTH) / 2, 125, LISTVIEW_WIDTH, LISTVIEW_HEIGHT)

local MOVE_INCH = 7.0/160.0
local function convertDistanceFromPointToInch(pointDis)
    local glview = cc.Director:getInstance():getOpenGLView()
    local factor = (glview:getScaleX() + glview:getScaleY())/2
    return pointDis * factor / cc.Device:getDPI()
end

function MainView:ctor()
    MainView.super.ctor(self)

    self:InjectView("Node_Container", "_container")
    self:InjectView("Node_channel")

    self:InjectView("Btn_world")
    self:InjectView("Btn_corps")
    self:InjectView("Btn_private")

    self.Node_channel:setVisible(false)

    self:setEditBox()

    self.tab_host = qy.tank.widget.TabHost.new({
        delegate = self,
        csd = "widget/TabButton3",
        tabs = {qy.TextUtil:substitute(69002), qy.TextUtil:substitute(69003), qy.TextUtil:substitute(69004), qy.TextUtil:substitute(69005), qy.TextUtil:substitute(69006), qy.TextUtil:substitute(90333)},
        size = cc.size(148,70),
        layout = "h",
        idx = 1,

        ["onCreate"] = function(tabHost, idx)
            if idx == 2 then
                if qy.tank.model.UserInfoModel.userInfoEntity.legionName ~= qy.TextUtil:substitute(90019) then
                    self:chatToLegion()
                else
                    qy.hint:show(qy.TextUtil:substitute(90020))
                end
            elseif idx == 6 then
                if qy.tank.model.ServerFactionModel.isfaction == 0 then
                    qy.hint:show("请先加入一个阵营")
                else
                    self:chatToCamp()
                end
            else
                self:chatToWorld()
            end
            return self:createContent(idx)
        end,

        ["onTabChange"] = function(tabHost, idx)
            if idx == 2 then
                if qy.tank.model.UserInfoModel.userInfoEntity.legionName ~= qy.TextUtil:substitute(90019) then
                    self:chatToLegion()
                else
                    qy.hint:show(qy.TextUtil:substitute(90020))
                end
            elseif idx == 6 then
                if qy.tank.model.ServerFactionModel.isfaction == 0 then
                    qy.hint:show("请先加入一个阵营")
                else
                    self:chatToCamp()
                end
            else
                self:chatToWorld()
            end
        end
    })
    self.tab_host:setPosition(5, self._container:getContentSize().height + 10)
    self.tab_host:addTo(self._container, -1)

    self._channel_id = 1
    
    
end

function MainView:setEditBox()
    -- ccui.EditBox:create argument #3 is 'ccui.Scale9Sprite'; 'string' expected.
    -- 不需要处理，原因是luaval_to_std_string
    -- local editBox = ccui.EditBox:create(cc.size(563, 40), ccui.Scale9Sprite:create())
    local editBox = ccui.EditBox:create(cc.size(563, 40), tolua.cast(ccui.Scale9Sprite:create(),"string"))
    editBox:setAnchorPoint(0, 0)
    editBox:setPosition(215.50, 44.50)
   	editBox:setFontSize(22)
    editBox:setPlaceHolder(qy.TextUtil:substitute(69007))
   	editBox:setPlaceholderFontSize(22)
   	editBox:setInputMode(6)
    if editBox.setReturnType then
        editBox:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    end
    editBox:addTo(self._container)

    self._editBox = editBox
end

function MainView:onShowChannelList(sender)
    qy.QYPlaySound.playEffect(qy.SoundType.COMMON_CLICK)
    local isvisible = self.Node_channel:isVisible()
    self.Node_channel:setVisible(not isvisible)
    self.ui.arraw:setRotation(isvisible and 0 or 180)
end

function MainView:chatToWorld()
    self._channel_id = 1
    self._channel_data = nil
    self._editBox:setPlaceHolder(qy.TextUtil:substitute(69007))
    self.ui.channel_name:setSpriteFrame("Resources/chat/shijie.png")
end

function MainView:chatToPrivate(user)
    self._channel_id = 3
    self._channel_data = user
    self._editBox:setPlaceHolder(qy.TextUtil:substitute(69008) .." " .. user.name .. " "..qy.TextUtil:substitute(69009))
    self.ui.channel_name:setSpriteFrame("Resources/chat/siliao.png")
end

function MainView:chatToLegion()
    self._channel_id = 2
    self._channel_data = nil
    self._editBox:setPlaceHolder(qy.TextUtil:substitute(69007))
    self.ui.channel_name:setSpriteFrame("Resources/chat/juntuan.png")
end
function MainView:chatToCamp()
    self._channel_id = 6
    self._channel_data = nil
    self._editBox:setPlaceHolder(qy.TextUtil:substitute(69007))
    self.ui.channel_name:setSpriteFrame("Resources/chat/zhenying.png")
end

function MainView:onEnter()
    local touchPoint = nil
    self.listener = cc.EventListenerTouchOneByOne:create()
    self.listener:setSwallowTouches(false);
    self.listener:registerScriptHandler(function(touch, event)
        touchPoint = touch:getLocation()
        self._touchMoved = not cc.rectContainsPoint(LISTVIEW_RECT, touchPoint)

        -- 频道列表显示隐藏
        if self.Node_channel:isVisible() then
            local rect = self.Node_channel:getBoundingBox()
            local pos = self._container:convertToWorldSpace(cc.p(rect.x, rect.y))
            rect.x = pos.x
            rect.y = pos.y
            if not cc.rectContainsPoint(rect, touchPoint) then
                -- 频道切换按钮
                rect = self.ui.Button_3:getBoundingBox()
                pos = self._container:convertToWorldSpace(cc.p(rect.x, rect.y))
                rect.x = pos.x
                rect.y = pos.y
                if not cc.rectContainsPoint(rect, touchPoint) then
                    self:onShowChannelList()
                end
            end
        end
        return not self._touchMoved
    end, cc.Handler.EVENT_TOUCH_BEGAN)
    self.listener:registerScriptHandler(function(touch, event)
        local moveDistance = touch:getLocation()
        moveDistance.x = moveDistance.x - touchPoint.x
        moveDistance.y = moveDistance.y - touchPoint.y
        local dis = math.sqrt(moveDistance.x * moveDistance.x + moveDistance.y * moveDistance.y)
        if math.abs(convertDistanceFromPointToInch(dis)) >= MOVE_INCH then
            self._touchMoved = true
        end
    end, cc.Handler.EVENT_TOUCH_MOVED)
    self:getEventDispatcher():addEventListenerWithFixedPriority(self.listener, -1)
end

function MainView:onExit()
    self:getEventDispatcher():removeEventListener(self.listener)

    Model:removeAllObserve()
end

function MainView:createContent(idx)
    local listView = ccui.ListView:create()
    listView:setDirection(ccui.ScrollViewDir.vertical)
    listView:setBounceEnabled(true)
    listView:setContentSize(LISTVIEW_WIDTH, LISTVIEW_HEIGHT)
    listView:setAnchorPoint(0, 1)
    listView:setPosition(0, -68)
    listView:setItemsMargin(8)
    listView:setSwallowTouches(false)
    listView:registerScriptHandler(function(event)
        if event == "enter" then
            listView:forceDoLayout()
            listView:jumpToBottom()
        end
    end)

    local list = Model.data[Model.data.channels[idx]]
    local blackList = qy.tank.model.BlackModel.blackList

    if  blackList and #blackList > 0 then
        for i=1,#list do
            for j=1,#blackList do
                if list[i] and list[i].from then
                    if list[i].from.id == blackList[j].kid then
                        table.remove(list, i)
                    end
                end
            end
        end
    end

    local max = 30
    local count = #list
    local start = count > max and count - max or 1
    for i = start, count do
        if list[i].from and #blackList > 0 then
            -- for j=1,#blackList do
            --     if list[i] and list[i].from then
                    -- if list[i].from.id ~= blackList[j].kid then
                        listView:pushBackCustomItem(self:makeItem(list[i]))
                    -- end
                -- end
            -- end
        else
            listView:pushBackCustomItem(self:makeItem(list[i]))
        end
    end

    Model:observe(idx, function(data)
        local blackList = qy.tank.model.BlackModel.blackList
        -- print("=====",json.encode(data.from))
        for k,v in pairs(data) do
            for j=1,#blackList do
                if k == "from" then
                    if v.id == blackList[j].kid then
                        return
                    end
                end
            end
        end
        
        if data.from and #blackList > 0 then
            -- for j=1,#blackList do
            --     if data and data.from then
            --         if data.from.id ~= blackList[j].kid then
                        listView:pushBackCustomItem(self:makeItem(data))
            --         end
            --     end
            -- end
        else
            listView:pushBackCustomItem(self:makeItem(data))
        end
        -- listView:pushBackCustomItem(self:makeItem(data))
        listView:forceDoLayout()
        listView:jumpToBottom()
    end)

    return listView
end

function MainView:makeItem(itemData)
    local richText = ccui.RichText:create()
    richText:ignoreContentAdaptWithSize(false)
    richText:setContentSize(LISTVIEW_WIDTH - 10, 0)
    richText:setVerticalSpace(3)

    if not itemData.content then
        itemData.content = '***' -- 容错处理
    end
    -- 处理频道
    self:handlerChannel(richText, itemData.channel)
    if itemData.channel.id == 1 or (itemData.channel.id == 2 and itemData.from) or itemData.channel.id == 6 then        
        --fq 2016年08月18日14:24:58
        if itemData.model_type then           
            if itemData.model_type == "medal_info" then
                self:handlerContent(richText, itemData.content.nickname)
                self:handlerContent(richText, ":")
                local data = itemData.content.medal_info
                local model = qy.tank.model.MedalModel
                local name = ""
                local medal_id = data.medal_id
                local medaldata = model.medalcfg[medal_id..""]
                name = medaldata.name
                local color = qy.tank.utils.ColorMapUtil.qualityMapColorFor3b(medaldata.medal_colour)
                richText:pushBackElement(self:makeButton("["..name.."]", function()
                     local tip  = qy.tank.view.tip.MedalTip.new({
                    ["data"] = data
                    })
                    tip:show()
                end, color))
            end
            if itemData.model_type == "group_battles" then
                self:handlerContent(richText, itemData.content)
                richText:pushBackElement(self:makeButton("[加入队伍]", function()
                    qy.tank.service.GroupBattlesService:joinTeam2(function(data)
                        if data.team_info then
                            self:onBack()
                        end
                    end, itemData.param.team_name, itemData.param.scene_id)
                end, cc.c3b(0, 255, 0)))
            end
            if itemData.model_type == "AttackBerlin.invite" then   
                self:handlerContent(richText, itemData.content.msg)
                richText:pushBackElement(self:makeButton("[加入队伍]", function()
                    qy.tank.service.AttackBerlinService:joinTeam2(function(data)
                            self:onBack()
                    end, itemData.content.team_id)
                end, cc.c3b(0, 255, 0)))
            end
            if itemData.model_type == "AttackBerlin.bossCombat" then  
                self:handlerContent(richText, itemData.content)
                richText:pushBackElement(self:makeButton("[查看战报]", function()
                    qy.tank.service.AttackBerlinService:showCombat(itemData.combat_id,function(data)
                          
                    end)
                end, cc.c3b(0, 255, 0)))
            end
            if itemData.model_type == "intruder_time" then
                self:handlerContent(richText, itemData.content)
                richText:pushBackElement(self:makeButton("[支援]", function()
                    qy.tank.service.IntruderTimeService:help(function(data)
                        qy.tank.model.BattleModel:init(data.fight_result)
                        qy.tank.manager.ScenesManager:pushBattleScene()
                    end, itemData.combat_id)
                end, cc.c3b(0, 255, 0)))
            end
        else 
            self:handlerUser(richText, itemData.from)
            self:handlerContent(richText, qy.TextUtil:substitute(69009).. " " .. itemData.content)
        end
    elseif itemData.channel.id == 3 then
        self:handlerUser(richText, itemData.from)
        if itemData.to then
            self:handlerContent(richText, qy.TextUtil:substitute(69008))
            self:handlerUser(richText, itemData.to)
        end
        self:handlerContent(richText, qy.TextUtil:substitute(69009) .. " " .. itemData.content)
    elseif itemData.channel.id == 4 then
        self:handlerUser(richText, itemData.from)
        self:handlerContent(richText, itemData.content)
        self:handlerUser(richText, itemData.to)
        richText:pushBackElement(self:makeButton(qy.TextUtil:substitute(69010), function()
            if itemData.model_type then
                print("类型是",itemData.model_type)
                if itemData.model_type == "exercise_battles" then
                    qy.tank.service.ServerExerciseService:WatchDetail(itemData.combat_id,function(data)
                        qy.tank.manager.ScenesManager:pushScene(qy.tank.view.scene.BattleScene.new())  
                    end)
                elseif itemData.model_type == "interservicearena" then
                    qy.tank.service.InterServiceArenaService:findbattle(function(data)
                        qy.tank.model.BattleModel:init(data.fight_result)
                        qy.tank.manager.ScenesManager:pushBattleScene()
                    end, itemData.combat_id)
                end                
            else
                Model:onWatchBattle(itemData.combat_id)
            end

        end, cc.c3b(0, 255, 0)))
    else
        if itemData.model_type then            
            if itemData.model_type == "group_battles" then
                self:handlerContent(richText, itemData.content)
                richText:pushBackElement(self:makeButton("[加入队伍]", function()
                    qy.tank.service.GroupBattlesService:joinTeam2(function(data)
                        if data.team_info then
                            self:onBack()
                        end
                    end, itemData.param.team_name, itemData.param.scene_id)
                end, cc.c3b(0, 255, 0)))
            end
            if itemData.model_type == "AttackBerlin.invite" then   
                self:handlerContent(richText, itemData.content.msg)
                richText:pushBackElement(self:makeButton("[加入队伍]", function()
                    qy.tank.service.AttackBerlinService:joinTeam2(function(data)
                            self:onBack()
                    end, itemData.content.team_id)
                end, cc.c3b(0, 255, 0)))
            end
            if itemData.model_type == "AttackBerlin.bossCombat" then  
                self:handlerContent(richText, itemData.content)
                richText:pushBackElement(self:makeButton("[查看战报]", function()
                    qy.tank.service.AttackBerlinService:showCombat(itemData.combat_id,function(data)
                          
                    end)
                end, cc.c3b(0, 255, 0)))
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

function MainView:handlerChannel(richText, channel)
    richText:pushBackElement(self:makeText("【" .. channel.name .. "】 ", channel.color))
end

function MainView:handlerUser(richText, user)
    if not user then
        return
    end

    self._userInfoDialogListener = self._userInfoDialogListener or {
        onPrivate = function(user)
            self:chatToPrivate(user)
        end,
        onEmail = function(user)
            qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.MAIL, {
                ["defaultIdx"] = 3,
                ["uid"] = user.id,
                ["name"] = user.name
            })
        end,
        onInfo = function(user)
            qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.EXAMINE, user.id)
        end,
        onBlock = function(user)
            ChatBlockDialog.new(function()
                local BlackListService = qy.tank.service.BlackListService
                local BlackModel = qy.tank.model.BlackModel
                if user.id then
                    BlackListService:getBlackList(
                        user.id, 100,function(reData)
                            BlackModel:init(reData.list)
                            qy.hint:show(qy.TextUtil:substitute(90035))
                            -- print(json.encode(reData.list))
                            -- self:refreshLayer()
                    end)
                end
                -- user.id
            end):show()
        end,
        onBattle = function(user)
            Model:onBattle(user)
        end
    }

    local userEntity = qy.tank.model.UserInfoModel.userInfoEntity
    if user.name then
        if user.id ~= 0 and user.id ~= userEntity.kid then
            richText:pushBackElement(self:makeButton(" " .. user.name, function()
                ChatUserInfoDialog.new(user, self._userInfoDialogListener):show()
            end))
        else
            richText:pushBackElement(self:makeText(" " .. user.name, cc.c3b(216, 197, 157)))
        end
    end

    if user.title and string.len(user.title) > 0 then
        richText:pushBackElement(self:makeText("(" .. user.title .. ")"))
    end
end

function MainView:handlerContent(richText, content)
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
            print(qy.json.encode(content))
            if type(v) == "string" then
                richText:pushBackElement(self:makeText((i == 1 and " " or "") .. v))
            else
                -- 带id可点击
                if v.id then
                    richText:pushBackElement(self:makeButton(" " .. v.text, function()
                        qy.hint:show(qy.TextUtil:substitute(69011))
                    end, cc.c3b(unpack(string.split(v.color, ",")))))
                else
                    richText:pushBackElement(self:makeText(v.text, cc.c3b(unpack(string.split(v.color, ",")))))
                end
            end
        end
    end
end

function MainView:makeText(text, color)
    return ccui.RichElementText:create(1, color or display.COLOR_WHITE, 255, text, qy.res.FONT_NAME_2, FONT_SIZE)
end

function MainView:makeButton(text, callback, color)
    local textButton = ccui.Button:create()
    textButton:ignoreContentAdaptWithSize(true)
    textButton:setTouchEnabled(true)
    textButton:setSwallowTouches(false)
    textButton:setTitleText(text)
    textButton:setTitleFontName(qy.res.FONT_NAME)
    textButton:setTitleFontSize(FONT_SIZE)
    textButton:setTitleColor(color or cc.c3b(216, 197, 157))
    textButton:getTitleRenderer():enableOutline(cc.c4b(0,0,0,255),1)
    textButton:setZoomScale(0)
    textButton:getTitleRenderer():setAnchorPoint(0.5, 0.4)
    textButton:addTouchEventListener(function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
        elseif eventType == ccui.TouchEventType.moved then
            if self._touchMoved then
                sender:setBrightStyle(ccui.BrightStyle.normal)
            end
        else
            if not self._touchMoved and callback then
                callback()
            end
        end
    end)
    local size = textButton:getContentSize()
    local line = ccui.Scale9Sprite:createWithSpriteFrameName("Resources/chat/line.png")
    line:setAnchorPoint(0.5, 0)
    line:setPosition(size.width / 2 + 3, 0)
    line:setCapInsets(cc.rect(2, 0, 2, 0))
    line:setContentSize(size.width - 5, 16)
    line:setColor(color or cc.c3b(216, 197, 157))
    textButton:addChild(line, -1)
    return ccui.RichElementCustomNode:create(1, cc.c3b(255, 255, 255), 255, textButton)
end

function MainView:onSend(sender)
    if qy.tank.model.UserInfoModel.userInfoEntity.level >= 30 or self._channel_id ~= 1 then
        qy.QYPlaySound.playEffect(qy.SoundType.COMMON_CLICK)
        local msg = self._editBox:getText()
        if string.len(msg) > 0 then
            if qy.language == "cn" then
                if qy.tank.model.UserInfoModel.userInfoEntity.vipLevel < 15 then
                    for i=1,#msg do
                        local curByte = string.byte(msg, i)
                        if curByte == 35 then
                            qy.hint:show("信息中包含有非法字符，请重新输入！")
                            return
                        end
                    end
                end
            end
            if qy.tank.model.UserInfoModel.userInfoEntity.legionName == qy.TextUtil:substitute(90019) and self._channel_id == 2 then
                qy.hint:show(qy.TextUtil:substitute(90020))
            elseif qy.tank.model.ServerFactionModel.isfaction == 0 and self._channel_id == 6 then
                qy.hint:show("请先加入一个阵营")
            else
                self._editBox:setText("")
                Model:send(self._channel_id, self._channel_data, msg, self.playName)
            end
        else
            qy.hint:show(qy.TextUtil:substitute(69007))
        end
    else
        qy.hint:show(qy.TextUtil:substitute(90257))
    end
end

function MainView:onBack(sender)
    qy.QYPlaySound.playEffect(qy.SoundType.BTN_CLOSE)
    qy.tank.controller.BaseController:finish()
end

function MainView:onWorld(sender)
    qy.QYPlaySound.playEffect(qy.SoundType.COMMON_CLICK)
    self:onShowChannelList()
    self:chatToWorld()
end

function MainView:onCorps(sender)
    qy.QYPlaySound.playEffect(qy.SoundType.COMMON_CLICK)
    self:onShowChannelList()
    self:chatToLegion()
end
function MainView:onCamp(sender)
    qy.QYPlaySound.playEffect(qy.SoundType.COMMON_CLICK)
    self:onShowChannelList()
    self:chatToCamp()
end

function MainView:onPrivate(sender)
    qy.QYPlaySound.playEffect(qy.SoundType.COMMON_CLICK)
    ChatInputNameDialog.new(function(message)
        -- co(function()
        --     return yield(function(next)
        --         next(qy.TextUtil:substitute(69012))
        --     end)
        -- end, function(err, res)
        --     if err then
        --         qy.hint:show(err)
        --     else
        --     end
        -- end)
        -- 之前代码没有对私聊作处理 只弹出 “不存在”

        self._channel_id = 3
        local to = {}
        to.name = message
        self.playName = message
        self._channel_data = to
        self._editBox:setPlaceHolder(qy.TextUtil:substitute(69008) .." " .. message .. " "..qy.TextUtil:substitute(69009))
        self.ui.channel_name:setSpriteFrame("Resources/chat/siliao.png")
    end):show()
end

return MainView
