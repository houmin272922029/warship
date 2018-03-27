--[[
    多人副本
    Author: fq
    Date: 2016年08月05日15:02:46
]]

local GroupBattlesModel = qy.class("GroupBattlesModel", qy.tank.model.BaseModel)

function GroupBattlesModel:init(_data)
    self.checkpoint = {}
    self.total_checkpoint = {}
    self.checkpoint_size = 0
    self.current_num = 1
    self.status = 0 --0为未进入队伍  1为进入队伍   2为队长
    self.team_info = nil
    self.pay_num = 5
    self.vip_buy_times = qy.tank.model.VipModel:getGroupBattlesBuyTimes()[qy.tank.model.UserInfoModel.userInfoEntity.vipLevel] or 0




    local staticData = qy.Config.group_battles_scene
    for i, v in pairs(staticData) do
        table.insert(self.checkpoint, v)
        if self.total_checkpoint[tostring(math.floor((i - 1) / 2) + 1)] == nil then
            self.total_checkpoint[tostring(math.floor((i - 1) / 2) + 1)] = {}
            self.checkpoint_size = self.checkpoint_size + 1
        end

        table.insert(self.total_checkpoint[tostring(math.floor((i - 1) / 2) + 1)], v)
    end



    for i = 1, math.floor((#self.checkpoint - 1) / 2) + 1 do
        table.sort(self.total_checkpoint[tostring(i)],function(a,b)
            return tonumber(a.scene_id) < tonumber(b.scene_id)
        end)
    end


    table.sort(self.checkpoint,function(a,b)
        return tonumber(a.scene_id) < tonumber(b.scene_id)
    end)



    self:update(_data)
end

function GroupBattlesModel:update(_data)
    local data = _data

    if _data.activity_info then 
        data = _data.activity_info
    end

    if data.is_team == 100 or data.is_team == 200 then
        if data.is_team == 100 then
            self.status = 0
            if data.scene_list then
                self:updateSceneList(data.scene_list)
            end 
        end
        return
    end

    if data.status == 200 then
        return
    end

    if data.team_info then 
        self.team_info = data.team_info
        self:setCurrentSceneId(data.scene_id)

        if #self.team_info > 0 then
            self:sortTeamInfo()
        end

        if qy.tank.model.UserInfoModel.userInfoEntity.kid == self.team_info[1].kid then            
            self.status = 2
            print("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
            print(self.status)
        else 
            self.status = 1
            print("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
            print(self.status)
        end

        return
    elseif data.type ~= 600 then
        self.status = 0
        print("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
        print(self.status)
    end


    self.pay_num = data.pay_num or self.pay_num
    self.join_num = data.join_num or self.join_num
    self.pay_join_num = data.pay_join_num or self.pay_join_num
    --self.scene_list = data.scene_list or self.scene_list
    self:updateSceneList(data.scene_list)
    self.week = data.week or self.week


    --self:sortSceneList()

end


function GroupBattlesModel:getTotalCheckPointsByIndex(_idx) 
    return self.total_checkpoint[tostring(_idx)]
end

function GroupBattlesModel:getTotalCheckPointSize()
    return self.checkpoint_size
end

function GroupBattlesModel:getCheckPointByIndex(_idx) 
    return self.checkpoint[_idx]
end

function GroupBattlesModel:getTotalNum() 
    return self.total_num
end


function GroupBattlesModel:setCurrentSceneId(id) 
    self.current_num = id or self.current_num or 1
end


function GroupBattlesModel:getCurrentSceneId() 
    return self.current_num
end


function GroupBattlesModel:getTeamListByCurrent()
    return self.scene_list[tostring(self.current_num)].team_list
end


function GroupBattlesModel:getStatus()

    return self.status
end


function GroupBattlesModel:getTeamInfo()
    return self.team_info
end


function GroupBattlesModel:getWeek()
    return self.week
end


function GroupBattlesModel:updateSceneList(scene_list)
    self.scene_list = scene_list or self.scene_list
    self:sortSceneList()

    if self.checkpoint then
        for i = 1, #self.checkpoint do
            self.checkpoint[i].join_num = self.scene_list[tostring(i)].join_num or self.checkpoint[i].join_num
            self.total_checkpoint[tostring(math.floor((#self.checkpoint - 1) / 2) + 1)][(i - 1) % 2 + 1].join_num = self.scene_list[tostring(i)].join_num or self.total_checkpoint[tostring(math.floor((#self.checkpoint - 1) / 2) + 1)][(i - 1) % 2 + 1].join_num
        end
    end

end


function GroupBattlesModel:updateTeamInfo(team_info)
    if team_info then
        self.team_info = team_info
        self:sortTeamInfo()
    end    
end

function GroupBattlesModel:updateStatus(status)
    self.status = status
end


function GroupBattlesModel:sortSceneList()
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

function GroupBattlesModel:sortTeamInfo()
    table.sort(self.team_info,function(a,b)
        return tonumber(a.order) > tonumber(b.order)
    end)
end


function GroupBattlesModel:showBattle(data)      
    self.timer = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
        qy.tank.service.GroupBattlesService:get(function()

        end)
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.timer)
    end,1,false)
    
    qy.tank.service.GroupBattlesService:getUserResource()
    qy.tank.command.LegionCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.WAR_GROUP, data)
end


return GroupBattlesModel