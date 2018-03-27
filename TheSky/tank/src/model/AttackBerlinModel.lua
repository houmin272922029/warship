--[[
    围攻柏林
    Author: lj
    Date: 2016年08月05日15:02:46
]]

local AttackBerlinModel = qy.class("AttackBerlinModel", qy.tank.model.BaseModel)

function AttackBerlinModel:init(_data)
    qy.Utils.preloadJPG("Resources/main_city/building/berlin_bg.jpg")
    self.checkpoint = {}
    self.total_checkpoint = {}
    self.checkpoint_size = 0
    self.current_num = 1
    self.status = 0 --0为未进入队伍  1为进入队伍   2为队长
    self.team_info = nil
    self.pay_num = 5
    self.vip_buy_times = 3

    self.scene_id = 0
    self.newcopy_id = 0

    self.chatinto = 0 --s是否从聊天进来的

    self.simplenums = 2 --简单攻打次数
    self.simplebuynums = 1 --最大购买次数 10 * x 每次递增10钻石

    self.commonnums = 1 --精英攻打次数
    self.commonbuynums = 1 --最大购买次数 30 * x 每次递增30钻石

    self.bossnums = 10 --boss攻打次数
    self.awardpower = 0 --分配奖励权限
    self.choosepower = _data.is_can_open --开本权限  
    self.totalflag = _data.is_open --是否开了本
    self.slectid = 0 --奖励分配

    self.checkpointlist1 = {}
    self.checkpointlist2 = {}
    self.checkpointlist3 = {}
    local staticData = qy.Config.attack_berlin_copy
    self.attack_berlin_elite_scene = qy.Config.attack_berlin_elite_scene--精英关卡
    self.attack_berlin_general_checkpoint = qy.Config.attack_berlin_general_checkpoint--普通关卡
    self.attack_berlin_personalaward = qy.Config.attack_berlin_personalaward --个人随机奖励
    self.attack_berlin_randomaward = qy.Config.attack_berlin_randomaward --击破表
    for i, v in pairs(staticData) do
        v.status = 0
        if v.map == 1 then
            table.insert(self.checkpointlist1,v)
        elseif v.map == 2 then
            table.insert(self.checkpointlist2,v)
        else
            table.insert(self.checkpointlist3,v)
        end
    end
    table.sort(self.checkpointlist1,function(a,b)
        return tonumber(a.id) < tonumber(b.id)
    end)
    table.sort(self.checkpointlist2,function(a,b)
        return tonumber(a.id) < tonumber(b.id)
    end)
    table.sort(self.checkpointlist3,function(a,b)
        return tonumber(a.id) < tonumber(b.id)
    end)
    self.attack_berlin_boss_scene = qy.Config.attack_berlin_boss_scene


end
function AttackBerlinModel:initdata(  )
    self.scene_id = 0
    self.newcopy_id = 0
end
function AttackBerlinModel:updateawardlist( data )
    self.is_leader  = data.is_leader
    self.my_awardslist = data.my_list
    self.total_awards = data.list
    self.cansendlist = data.can_send_list
    if #self.total_awards > 0 then
        self.slectid = 1
    else
        self.slectid = 0  
    end
end
function AttackBerlinModel:updateopen( data )
    self.choosepower = data.is_can_open --开本权限  
    self.totalflag = data.is_open --是否开了本
end
function AttackBerlinModel:init1( data )
    self.totalflag = 1
    self.conquer_copy_ids ={}
end
function AttackBerlinModel:init2( data )
    self.difficuty = data.open_difficulty
    self.conquer_copy_ids = data.conquer_copy_ids
    self:uptatecopyid()
end
function AttackBerlinModel:uptatecopyid(  )
    if self.difficuty ==1 then
        for k,v in pairs(self.checkpointlist1) do
            for m,n in pairs(self.conquer_copy_ids) do
                if n == v.id then
                    v.status = 1
                    break
                end 
            end
        end
    elseif self.difficuty == 2 then
       for k,v in pairs(self.checkpointlist2) do
            for m,n in pairs(self.conquer_copy_ids) do
                if n == v.id then
                    v.status = 1
                    break
                end 
            end
        end
    else
        for k,v in pairs(self.checkpointlist3) do
            for m,n in pairs(self.conquer_copy_ids) do
                if n == v.id then
                    v.status = 1
                    break
                end 
            end
        end
    end
end
function AttackBerlinModel:uptateGeneraldata( data )
    self.times1 = data.last_attack_times --剩余攻打次数
    self.complete_ids = data.list 
    self.buy_times = data.buy_times--购买次数
end
function AttackBerlinModel:uptateElitedata( data )
    self.times2 = data.last_attack_times --剩余攻打次数
    self.scene_list = data.scene_info 
    self.buy_times2 = data.buy_times--购买次数
    self.default_id  = data.default_id
    for k,v in pairs(self.scene_list) do
        if v.scene_id  == data.default_id then
            self:update(self.scene_list[k])
            break
        end
    end
end
function AttackBerlinModel:uptate5( data,copy_id )
    -- print("=========改变状态",json.encode(data))
    if self.newcopy_id == copy_id then
        self.scene_list = data.data.scene_info 
        self.default_id  = data.data.default_id
    end
end
function AttackBerlinModel:setnewcopyid( copy_id )
    -- print("==============设置选择的",copy_id)
    self.newcopy_id = copy_id
end
function AttackBerlinModel:updateChatdate( data )--聊天过来初始化
    self.copy_id = data.team.copy_id
    self.chatinto = 1
    self.difficuty = data.map_info.open_difficulty
    self.conquer_copy_ids = data.map_info.conquer_copy_ids
    self:uptatecopyid()
    self.times2 = data.copy_info.last_attack_times --剩余攻打次数
    self.scene_list = data.copy_info.scene_info 
    self.buy_times2 = data.copy_info.buy_times--购买次数
    self.default_id  = data.copy_info.default_id
    for k,v in pairs(self.scene_list) do
        if v.scene_id  == self.default_id then
            self:update(self.scene_list[k])
            break
        end
    end
end
function AttackBerlinModel:uptateGeneraldata1( copy_id,data )
    self.times1 = data.last_attack_times
    self.complete_ids = data.list
    -- self.is_conquer = data.complete.is_conquer --是否完成
    -- if self.difficuty ==1 then
    --     for k,v in pairs(self.checkpointlist1) do
    --         if copy_id == v.id then
    --             v.status = self.is_conquer
    --             break
    --         end 
    --     end
    -- elseif self.difficuty == 2 then
    --    for k,v in pairs(self.checkpointlist2) do
    --         if copy_id == v.id then
    --             v.status = self.is_conquer
    --             break
    --         end 
    --     end
    -- else
    --    for k,v in pairs(self.checkpointlist3) do
    --         if copy_id == v.id then
    --             v.status = self.is_conquer
    --             break
    --         end 
    --     end
    -- end
end
function AttackBerlinModel:uptateGeneraltimes( data )
    self.times1 = data.last_attack_times --剩余攻打次数
    self.buy_times = data.buy_times--购买次数
end
function AttackBerlinModel:uptateElitetimes( data )
    self.times2 = data.last_attack_times --剩余攻打次数
    self.buy_times2 = data.buy_times--购买次数
end
function AttackBerlinModel:getAttackstatus( id )
    local status = 0
    for i,v in ipairs(self.conquer_copy_ids) do
        if v == id then
            status = 1
            break
        end
    end
    return status
end
function AttackBerlinModel:updatemember( data )
    self.memberlist = data
end
function AttackBerlinModel:updateloglist( data )
    self.loglist = data.list
end
function AttackBerlinModel:getGeneralstatus( id )--简单
    local status = ""
    for i,v in ipairs(self.complete_ids) do
        if v.id == id then
            return v.status
        end
    end
end
function AttackBerlinModel:getElitestatus( id )--精英
    local status = "0"
    for i,v in ipairs(self.scene_list) do
        if v.scene_id  == id then
            return v.status
        end
    end
end
function AttackBerlinModel:getHardstatus( diff )
    local status = 1
    local data = {}
    if self.difficuty ==1 then
        data = self.checkpointlist1
    elseif self.difficuty == 2 then
        data = self.checkpointlist2 
    else
        data = self.checkpointlist3 
    end
    for k,v in pairs(data) do
        if v.difficulty == diff then
            if v.status ~= 1 then
                status = 0 
                break
            end
        end
    end
    return status
end
function AttackBerlinModel:getpower(  )
    local x = 0
    local user_score = qy.tank.model.LegionModel:getCommanderEntity().user_score
    if (user_score == 1 or user_score == 2 or user_score == 3) then
        x = 1
    end
    return x
end
function AttackBerlinModel:getListBysceneid( id )--获取普通
    local list = {}
    for k,v in pairs(self.attack_berlin_general_checkpoint) do
       if id == v.copy_id then
        table.insert(list,v)
       end
    end
    table.sort(list,function(a,b)
        return tonumber(a.id) < tonumber(b.id)
    end)
   return list
end
function AttackBerlinModel:getListBysceneid1( id )--获取精英
    local list = {}
    for k,v in pairs(self.attack_berlin_elite_scene) do
       if id == v.copy_id then
        table.insert(list,v)
       end
    end
    table.sort(list,function(a,b)
        return tonumber(a.id) < tonumber(b.id)
    end)
   return list
end
function AttackBerlinModel:getBossByid( id )--获取boss
    local list = {}
    for k,v in pairs(self.attack_berlin_boss_scene) do
       if id == v.copy_id then
        table.insert(list,v)
       end
    end
    table.sort(list,function(a,b)
        return tonumber(a.id) < tonumber(b.id)
    end)
   return list
end
function AttackBerlinModel:getPersonalAwardByid( id )
    local list = {}
    for k,v in pairs(self.attack_berlin_personalaward) do
       if id == v.args then
        table.insert(list,v)
       end
    end
    table.sort(list,function(a,b)
        return tonumber(a.id) < tonumber(b.id)
    end)
   return list
end
function AttackBerlinModel:getjipoAwardByid( id )--击破奖励
    local list = {}
    for k,v in pairs(self.attack_berlin_randomaward) do
       if id == v.args then
        table.insert(list,v)
       end
    end
    table.sort(list,function(a,b)
        return tonumber(a.id) < tonumber(b.id)
    end)
   return list
end

function AttackBerlinModel:update(_data)
    local data = _data
    -- print("水岸线",json.encode(_data))
    self.status = 0
    self.isteam = data.is_team
    if data.team_info.member_info then 
        self.leader_kid = data.team_info.leader_kid
        self.team_id =  data.team_info.team_id
        self.team_info = data.team_info.member_info
        for k,v in pairs(self.team_info) do
            if v.user_info.kid == qy.tank.model.UserInfoModel.userInfoEntity.kid then
                self.status = 1
                break
            end
        end
        if qy.tank.model.UserInfoModel.userInfoEntity.kid == data.team_info.leader_kid then            
            self.status = 2
        end
        if #self.team_info == 0 then
            self.status = 0
        end
        print("------------------",#self.team_info)
    end
    -- print("最终的涨停",self.status)
end
function AttackBerlinModel:uptate1( data ,scene_id)
    for k,v in pairs(self.scene_list) do
        if v.scene_id  == scene_id then
            v.team_info = data.team
            -- print("pppppppppppp",json.encode(v))
            self:update(v)
            break
        end
    end
end
function AttackBerlinModel:uptate2( data )
    for k,v in pairs(self.scene_list) do
        if v.team_info.team_id then
            if v.team_info.team_id == data.team.team_id then
                v.team_info = data.team
                -- print("pppppppppppp1111",json.encode(v))
                self:update(v)
                break
            end
        end
    end
end
function AttackBerlinModel:uptate3( data ,scene_id)
     -- print("=====聊天的啊",json.encode(data))
    if self.scene_list then
        for k,v in pairs(self.scene_list) do
            if v.team_info.team_id then
                if v.team_info.team_id == data.data.team_id then
                    v.team_info = data.data
                    -- print("pppppppppppp1111",json.encode(v))
                    if scene_id == self.scene_id then
                        self:update(v)
                    end
                    break
                end
            end
        end
    end
end
function AttackBerlinModel:uptate4( data,scene_id )
     -- print("=====聊天的啊222",json.encode(data))
    if self.scene_list then
        for k,v in pairs(self.scene_list) do
            if v.scene_id  == scene_id then
                v.team_info = data.data
                if scene_id == self.scene_id then
                    self:update(v)
                end
                break
            end
        end
    end
end
function AttackBerlinModel:setscenceid( scene_id )
    print("设置选择的啊",scene_id)
    self.scene_id = scene_id
end
function AttackBerlinModel:uptateteam( _idx )
    for k,v in pairs(self.scene_list) do
        if v.scene_id  == _idx then
            self:update(v)
            break
        end
    end
end
function AttackBerlinModel:uptateBossdata( data )
    self.bosstimes = data.last_attack_times 
    -- print("boss打完",json.encode(data.scene_info[1]))
    self.bossis_conquer = data.scene_info[1].is_conquer
     
     -- print("+++++++++",self.bossis_conquer)
    self.combatlist = data.combat
    if self.difficuty == 1 then
        for k,v in pairs(self.checkpointlist1) do
            if v.difficulty == 3 then
                v.status = self.bossis_conquer
            end
        end
    elseif self.difficuty == 2 then
           for k,v in pairs(self.checkpointlist2) do
            if v.difficulty == 3 then
                v.status = self.bossis_conquer
            end
        end
    else
           for k,v in pairs(self.checkpointlist3) do
            if v.difficulty == 3 then
                v.status = self.bossis_conquer
            end
        end
    end
end

function AttackBerlinModel:getTotalCheckPointsByIndex(_idx) 
    return self.total_checkpoint[tostring(_idx)]
end

function AttackBerlinModel:getTotalCheckPointSize()
    return self.checkpoint_size
end

function AttackBerlinModel:getCheckPointByIndex(_idx) 
    return self.checkpoint[_idx]
end

function AttackBerlinModel:getTotalNum() 
    return self.total_num
end


function AttackBerlinModel:setCurrentSceneId(id) 
    self.current_num = id or self.current_num or 1
end


function AttackBerlinModel:getCurrentSceneId() 
    return self.current_num
end


function AttackBerlinModel:getTeamListByCurrent(current_num)
    -- print("============current_num",current_num)
    local list = {}
     for i,v in ipairs(self.scene_list) do
        if v.scene_id  == current_num then
            if v.team_info.member_info then
                list = v.team_info.member_info
                break
                -- table.insert(list,v.team_info.member_info)
            end
        end
    end
    return list
end


function AttackBerlinModel:getStatus()
    return self.status
end


function AttackBerlinModel:getTeamInfo()
    return self.team_info
end


function AttackBerlinModel:getWeek()
    return self.week
end
function AttackBerlinModel:updateTeamInfo(team_info)
    if team_info then
        self.team_info = team_info
        self:sortTeamInfo()
    end    
end

function AttackBerlinModel:updateStatus(status)
    self.status = status
end


function AttackBerlinModel:sortSceneList()
    if self.checkpoint and self.scene_list then
        for i = 1, #self.checkpoint do
            if self.scene_list[tostring(i)] and #self.scene_list[tostring(i)].team_list > 0 then
                table.sort(self.scene_list[tostring(i)].team_list,function(a,b)
                    return tonumber(a.order) > tonumber(b.order)
                end)
            end
        end
    end
end

function AttackBerlinModel:sortTeamInfo()
    table.sort(self.team_info,function(a,b)
        return tonumber(a.order) > tonumber(b.order)
    end)
end


function AttackBerlinModel:showBattle(data,copy_id)
    -- print("战斗数据",json.encode(data))
    -- print("++++++++++++++pppppppp",copy_id)      
    self.timer = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
        qy.tank.service.AttackBerlinService:inToElite(copy_id,function()
        end)
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.timer)
    end,1,false)
    self.timer1 = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
        qy.tank.service.AttackBerlinService:get(function()
        end)
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.timer1)
    end,2,false)
    
    -- qy.tank.service.GroupBattlesService:getUserResource()
    qy.tank.command.LegionCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.WAR_GROUP, data)
end


return AttackBerlinModel