--[[
    跨服多人副本
]]

local AllServersGroupBattlesModel = qy.class("AllServersGroupBattlesModel", qy.tank.model.BaseModel)

function AllServersGroupBattlesModel:init(_data)

    self.scene_list = {}
    self.scene_list1 = {}--困难模式
    self.totalscene_list = {}


    self.select_scene_id = 0
    self.modeltype = self.modeltype or 1 --模式 默认进去为普通

    local staticData = qy.Config.all_servers_group_battles_scene
    for i, v in pairs(staticData) do
        if v.is_hard == 0 then
            table.insert(self.scene_list, v)
        else
            table.insert(self.scene_list1, v)
        end
         table.insert(self.totalscene_list, v)
    end


    table.sort(self.scene_list,function(a,b)
        return tonumber(a.id) < tonumber(b.id)
    end)

    table.sort(self.scene_list1,function(a,b)
        return tonumber(a.id) < tonumber(b.id)
    end)

    table.sort(self.totalscene_list,function(a,b)
        return tonumber(a.id) < tonumber(b.id)
    end)



    self:update(_data)
    self:update1(_data)
end

function AllServersGroupBattlesModel:update1( _data )
     local data = _data

    if _data.activity_info then 
        data = _data.activity_info
    end
    if data.user_info.team_attack_scene_id then
        self.select_scene_id = data.user_info.team_attack_scene_id 
        if data.user_info.team_attack_scene_id > 4 then
            self.modeltype = 2
        end
    end
end

function AllServersGroupBattlesModel:update(_data)
    local data = _data

    if _data.activity_info then 
        data = _data.activity_info
    end

    -- if data.is_team == 100 or data.is_team == 200 then
    --     if data.is_team == 100 then
    --         self.status = 0
    --         if data.scene_list then
    --             self:updateSceneList(data.scene_list)
    --         end 
    --     end
    --     return
    -- end

    -- if data.status == 200 then
    --     return
    -- end

    -- if data.team_info then 
    --     self.team_info = data.team_info
    --     self:setCurrentSceneId(data.scene_id)

    --     if #self.team_info > 0 then
    --         self:sortTeamInfo()
    --     end

    --     if qy.tank.model.UserInfoModel.userInfoEntity.kid == self.team_info[1].kid then            
    --         self.status = 2
    --         print("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
    --         print(self.status)
    --     else 
    --         self.status = 1
    --         print("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
    --         print(self.status)
    --     end

    --     return
    -- elseif data.type ~= 600 then
    --     self.status = 0
    --     print("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
    --     print(self.status)
    -- end

    print(self.team_info)
    print(data.team_info)
    if data.list then
        self.team_list = data.list or self.team_list
        return   
    end


    self.today_scene_id = data.today_scene_id or self.today_scene_id
    -- print("----------------",self.select_scene_id)
    if #self.today_scene_id > 0 and self.select_scene_id == 0 then
        print(self.select_scene_id)
        self.select_scene_id = self.today_scene_id[1]
         -- print("----------------ppppp",self.select_scene_id)
    end

    self.user_info = data.user_info or self.user_info
    self.week = data.week or self.week


    self.team_info = data.team_info or self.team_info

    self.type = data.type

    if self.team_info and self.team_info.team_id ~= "" then
        self.select_scene_id = self.team_info.scene_id 
         -- print("----------------ooooooo",self.select_scene_id)
    end

end
function AllServersGroupBattlesModel:updatescecid(  )
     self.select_scene_id = self.today_scene_id[1]
end


function AllServersGroupBattlesModel:getTotalCheckPointsByIndex(_idx) 
    return self.total_checkpoint[tostring(_idx)]
end

function AllServersGroupBattlesModel:getTotalCheckPointSize()
    return self.checkpoint_size
end

function AllServersGroupBattlesModel:getCheckPointByIndex(_idx) 
    return self.checkpoint[_idx]
end

function AllServersGroupBattlesModel:getTotalNum() 
    return self.total_num
end


function AllServersGroupBattlesModel:setCurrentSceneId(id) 
    self.current_num = id or self.current_num or 1
end


function AllServersGroupBattlesModel:getCurrentSceneId() 
    return self.current_num
end


function AllServersGroupBattlesModel:getTeamListByCurrent()
    return self.scene_list[tostring(self.current_num)].team_list
end


function AllServersGroupBattlesModel:getStatus()

    return self.status
end


function AllServersGroupBattlesModel:getTeamInfo()
    return self.team_info
end


function AllServersGroupBattlesModel:getWeek()
    return self.week
end


function AllServersGroupBattlesModel:updateSceneList(scene_list)
    self.scene_list = scene_list or self.scene_list
    self:sortSceneList()

    if self.checkpoint then
        for i = 1, #self.checkpoint do
            self.checkpoint[i].join_num = self.scene_list[tostring(i)].join_num or self.checkpoint[i].join_num
            self.total_checkpoint[tostring(math.floor((#self.checkpoint - 1) / 2) + 1)][(i - 1) % 2 + 1].join_num = self.scene_list[tostring(i)].join_num or self.total_checkpoint[tostring(math.floor((#self.checkpoint - 1) / 2) + 1)][(i - 1) % 2 + 1].join_num
        end
    end

end


function AllServersGroupBattlesModel:updateTeamInfo(team_info)
    if team_info then
        self.team_info = team_info
        self:sortTeamInfo()
    end    
end

function AllServersGroupBattlesModel:updateStatus(status)
    self.status = status
end


function AllServersGroupBattlesModel:sortSceneList()
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

function AllServersGroupBattlesModel:sortTeamInfo()
    table.sort(self.team_info,function(a,b)
        return tonumber(a.order) > tonumber(b.order)
    end)
end


function AllServersGroupBattlesModel:showBattle(data)      
    self.timer = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
        qy.tank.service.AllServersGroupBattlesService:get(function()

        end)
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.timer)
    end,1,false)
    
    --qy.tank.service.AllServersGroupBattlesService:getUserResource()
    qy.tank.command.LegionCommand:viewRedirectByModuleType("WAR_GROUP1", data)
end


return AllServersGroupBattlesModel