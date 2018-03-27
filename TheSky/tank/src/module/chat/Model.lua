local ChatModel = class("ChatModel", qy.tank.model.BaseModel)

local WebSocket = require("utils.WebSocket")
local LoginModel = qy.tank.model.LoginModel


ChatModel.Channels = {
    world   = {id = 1, name = qy.TextUtil:substitute(69013), color = cc.c3b(255, 225, 26)}, --世界
    legion  = {id = 2, name = qy.TextUtil:substitute(69014), color = cc.c3b(119, 196, 211)},--军团
    private = {id = 3, name = qy.TextUtil:substitute(69015), color = cc.c3b(185, 71, 217)}, --私聊
    report  = {id = 4, name = qy.TextUtil:substitute(69016), color = cc.c3b(255, 137, 0)},  --战报
    system  = {id = 5, name = qy.TextUtil:substitute(69017), color = cc.c3b(242, 48, 5)},    --系统
    camp    = {id = 6, name = qy.TextUtil:substitute(90333), color = cc.c3b(255, 153, 0)}    --系统
}

ChatModel.data = {
    channels         = {"world", "legion", "private", "report", "system","camp", "broadcast", "system_broadcast"},
    world            = {},
    legion           = {},
    private          = {},
    report           = {},
    system           = {},
    camp             = {},
    broadcast        = {},
    system_broadcast = {},
    observes         = {}
}

ChatModel.Event = {
    OPEN    = "ChatModel_EVENT_OPEN",
    MESSAGE = "ChatModel_EVENT_MESSAGE",
    CLOSE   = "ChatModel_EVENT_COLSE"
}

-- 弱表
setmetatable(ChatModel.data.observes, { __mode = "k" })

qy.Event.add(WebSocket.EVENT_OPEN, function()
    ChatModel:login()
end)

qy.Event.add(WebSocket.EVENT_MESSAGE, function(msg)
    ChatModel:handlerMessage(msg)
end)

qy.Event.add(WebSocket.EVENT_CLOSE, function()
    qy.Event.dispatch(ChatModel.Event.CLOSE)
end)

function ChatModel:connect()
    local host = LoginModel:getLastDistrictEntity().socket_host
    local port = LoginModel:getLastDistrictEntity().socket_port
    print("[ChatModel]", host, port)
    WebSocket:connect(host, port)
end

function ChatModel:login()
    
    local userEntity = qy.tank.model.UserInfoModel.userInfoEntity
    WebSocket:send({
        m = "Index.login",
        p = {
            id      = userEntity.kid,
            name    = userEntity.name,
            icon    = userEntity.headicon or "",
            sec     = LoginModel:getLastDistrictEntity().index,
            legionName = userEntity.legionName,
            legionId = userEntity.legionId,
            camp = qy.tank.model.ServerFactionModel.isfaction
        }
    })
end

function ChatModel:handlerMessage(msg)
    local json = qy.json.decode(msg._usedata)
    if json.code ~= "OK" then
        qy.hint:show(json.msg)
    else
        local blackList = qy.tank.model.BlackModel.blackList

        if json.m == "Index.login" then
            print("[ChatModel]", "登录成功")
            qy.Event.dispatch(self.Event.OPEN)

            -- 处理历史记录
            if #self.data.world == 0 then
                local count = #json.history
                local data = nil
                local list = nil
                local channel = nil

                

                for i = count, 1, -1 do
                    data = json.history[i]
                    for j=1,#blackList do
                        if data and data.from then
                            if data.from.id == blackList[j].kid then
                                table.remove(data, i)
                            end
                        end
                    end

                    channel = data.channel == "system_broadcast" and "system" or data.channel
                    data.channel = self.Channels[channel]
                    if data.channel then
                        list = self.data[channel]
                        if list then
                            table.insert(list, data)
                        end
                        -- 非世界频道的数据，同时回到世界频道中
                        if channel ~= self.data.channels[1] and channel ~= self.data.channels[7] then
                            table.insert(self.data.world, data)
                        end
                    end

                end
            end
            qy.Event.dispatch(self.Event.MESSAGE, self.data.world)
        elseif json.m == "Index.message" then
            local data = json.data
            local oldchannel = data.channel
            local channel = data.channel == "system_broadcast" and "system" or data.channel

            -- channel改变对象
            data.channel = self.Channels[channel]

            local list = self.data[channel]

            if list then
                table.insert(list, data)
            end

            for i=1,#list do
                for j=1,#blackList do
                    if list[i] and list[i].from then
                        if list[i].from.id == blackList[j].kid then
                            table.remove(self.data[channel], i)
                        end
                    end
                end
            end
            
            if oldchannel == self.data.channels[8] then
                table.insert(self.data.broadcast, data)
            end

            -- 私聊to

            local userEntity = qy.tank.model.UserInfoModel.userInfoEntity
            if channel == self.data.channels[3] and not data.to then
                data.to = {
                    id = userEntity.kid,
                    name = userEntity.name
                }
            end

            -- 非世界，并且非广播
            if channel ~= self.data.channels[1] and channel ~= self.data.channels[7] then
                table.insert(self.data.world, data)

                local observe = self.data.observes[self.data.channels[1]]
                if observe then
                    observe(data)
                end
            end

            local observe = self.data.observes[channel]
            if observe then
                observe(data)
            end

            qy.Event.dispatch(self.Event.MESSAGE, data)
        elseif json.m == "Groupbattles.group_battles_list" then -- 多人副本使用长连接，与聊天连接相同
            local model = qy.tank.model.GroupBattlesModel
            model:updateSceneList(json.data.content.scene_list)
            if json.data.content.msg then
                qy.hint:show(json.data.content.msg)
            end
            qy.Event.dispatch(qy.Event.GROUP_BATTLES)
        elseif json.m == "Groupbattles.group_battles_team_info" then
            local model = qy.tank.model.GroupBattlesModel

            if json.data.content.team_info then
                model:updateTeamInfo(json.data.content.team_info)
            elseif json.data.content.type == 400 then
                model:updateStatus(0)
            elseif json.data.content.type == 500 then
                model:updateStatus(0)
                qy.tank.model.WarGroupModel:setBattleAward(json.data.content.award)
                model:showBattle(json.data.content.battle)
            end

            if json.data.content.msg then
                qy.hint:show(json.data.content.msg)
            end
            qy.Event.dispatch(qy.Event.GROUP_BATTLES)
        elseif json.m == "AllServersGroupBattles.team_info" then -- 跨服多人副本
            local model = qy.tank.model.AllServersGroupBattlesModel
            model:update(json.data)
            if json.data.msg then
                qy.hint:show(json.data.content.msg)
            end
            qy.Event.dispatch(qy.Event.ALL_SERVERS_GROUP_BATTLES)

            if json.data.result then
                qy.tank.service.AllServersGroupBattlesService:showCombat(json.data.result.combat_id,function(data)
                    qy.tank.model.WarGroupModel:setBattleAward(json.data.result.award)
                    model:showBattle(data.combat)
                end)
            end
        elseif json.m == "AttackBerlin.team" then -- 围攻柏林
            local model = qy.tank.model.AttackBerlinModel
            if json.data.type == 500 or json.data.type == 200 or json.data.type == 300 or json.data.type == 400 then
                -- print("===========json.data.type离队",json.data)
                if json.data.data.scene_id then
                     model:uptate3(json.data,tonumber(json.data.data.scene_id))
                else
                     model:uptate3(json.data)
                end
                qy.Event.dispatch(qy.Event.ATTACKBERLIN)
            elseif json.data.type == 100 then
                -- print("创建了啊",json.data.data.scene_id)
                model:uptate4(json.data,tonumber(json.data.data.scene_id))
                qy.Event.dispatch(qy.Event.ATTACKBERLIN)
            elseif json.data.type == 700  then
                qy.tank.service.AttackBerlinService:showCombat1(json.data.data.combat_id,function(data)
                    qy.tank.model.WarGroupModel:setBattleAward(json.data.data.award)
                    model:showBattle(data.combat,tonumber(json.data.data.copy_id))    
                end)
            elseif json.data.type == 800 then
                model:uptate5(json.data,tonumber(json.data.data.copy_id))
                qy.Event.dispatch(qy.Event.ATTACKBERLIN3)
            end
        elseif json.m == "CampWar.city" then -- 阵营战
            local model = qy.tank.model.ServerFactionModel
            model:initOneCamp(json.data.data)
            qy.Event.dispatch(qy.Event.REFRESHCITY)
        end
    end
end

-- 发送信息
-- channel: 频道
-- message: 消息
-- ---data: 私聊对象
function ChatModel:send(channel, data, message, name)
    local userEntity = qy.tank.model.UserInfoModel.userInfoEntity
    local isPrivate = isPrivate or false
    local params = {
        m = "Index.message",
        p = {
            channel = self.data.channels[channel],
            content = message,
            legionName = userEntity.legionName,
            name = name
        }
    }

    if channel == 3 then
        params.p.to_id = data.id

        local userEntity = qy.tank.model.UserInfoModel.userInfoEntity
        self:handlerMessage({_usedata = qy.json.encode({
            m = "Index.message",
            code = "OK",
            data = {
                channel = "private",
                from = {
                    id = userEntity.kid,
                    name = userEntity.name,
                    legionName = userEntity.legionName
                },
                to = data,
                content = message
            }
        })})
    end

    WebSocket:send(params)
end

function ChatModel:observe(channel, func)
    self.data.observes[self.data.channels[channel]] = func
end

function ChatModel:removeAllObserve()
    for _, channel_name in ipairs(self.data.channels) do
        self.data.observes[channel_name] = nil
    end
end

-- 获取第一条公告，如果没有了则为空
function ChatModel:getBroadcast()
    return table.remove(self.data.broadcast, 1)
end

function ChatModel:onBattle(user)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "user.compare",
        ["p"] = {
            ["defKid"] = user.id
        }
    }))
    :send(function(response, request)
        qy.tank.model.BattleModel:init(response.data.fight_result)
        qy.tank.manager.ScenesManager:pushBattleScene()
    end)
end

function ChatModel:onWatchBattle(id)
    if id ~= nil then
        qy.tank.service.MineService:showCombat(id, function(data)
            qy.tank.manager.ScenesManager:pushBattleScene()
        end)
    end
end

return ChatModel
