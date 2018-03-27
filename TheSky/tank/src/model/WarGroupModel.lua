--[[--
    群战model
    Author: H.X.Sun
--]]

local WarGroupModel = qy.class("WarGroupModel", qy.tank.model.BaseModel)

WarGroupModel.LEFT_KEY = "att"
WarGroupModel.RIGHT_KEY = "def"
WarGroupModel.TRACK_1 = 1
WarGroupModel.TRACK_2 = 2
WarGroupModel.TRACK_3 = 3

WarGroupModel.BATTLE_LEGION_WAR = 1     -- 军团战战斗类型
WarGroupModel.BATTLE_GROUP_BATTLES = 2  -- 多人副本战斗类型 围攻柏林精英也是这个
WarGroupModel.BATTLE_ATTACKBERLIN = 3 --围攻柏林BOSS

-- function WarGroupModel:initForLocal()
--     local data = [[{"att_member_list":[{"name":"佩鲁德斯","kid":13066,"level":80,"headicon":"head_1","last_login_t":109,"contribution":4770,"user_score":1,"status":1},{"name":"美好的一天","kid":13115,"level":36,"headicon":"head_1","last_login_t":6917,"contribution":0,"user_score":2,"status":1}],"def_member_list":[{"name":"汉妮·塞琳娜","kid":12051,"level":75,"headicon":"head_1","last_login_t":695083,"contribution":8740,"user_score":1,"status":1},{"name":"周杰伦","kid":12085,"level":66,"headicon":"head_1","last_login_t":8,"contribution":11600,"user_score":41,"status":1}],"att_legion_name":"勇者联盟","def_legion_name":"呵呵哒","is_win":1,"results_list":[{"1":[{"move":0,"round_user":1,"att_name":"佩鲁德斯","att_kid":13066,"att_blood":-1,"att_tank":{"1":78,"2":87,"3":75,"4":71,"5":77,"6":89},"def_kid":12051,"def_blood":-1,"def_name":"汉妮·塞琳娜","is_win":1,"combat_id":839,"fight_data":{"att_max_blood":7465116,"def_max_blood":480462,"fight":[{"att_hurt":1,"att_blood":7465115,"att_die":[],"def_hurt":480462,"def_blood":0,"def_die":[{"pos":1,"from":1},{"pos":4,"from":1},{"pos":5,"from":1},{"pos":6,"from":1},{"pos":2,"from":1},{"pos":3,"from":1}]}]},"def_tank":{"1":70,"2":78,"3":47,"4":38,"5":43,"6":39},"att_win_times":1,"def_win_times":0}],"2":[{"move":0,"round_user":2,"att_name":"美好的一天","att_kid":13115,"att_blood":-1,"att_tank":{"1":54,"2":53,"3":51,"4":50,"5":49,"6":48},"def_kid":12085,"def_blood":-1,"def_name":"周杰伦","is_win":0,"combat_id":840,"fight_data":{"att_max_blood":650396,"def_max_blood":3581144,"fight":[{"att_hurt":650396,"att_blood":0,"att_die":[{"pos":4,"from":0},{"pos":2,"from":0},{"pos":3,"from":0},{"pos":1,"from":0},{"pos":5,"from":0},{"pos":6,"from":0}],"def_hurt":25,"def_blood":3581119,"def_die":[]}]},"def_tank":{"1":47,"2":78,"3":55,"4":53,"5":86,"6":48},"att_win_times":0,"def_win_times":1}]},{"3":[{"move":2,"round_user":3,"att_name":"佩鲁德斯","att_kid":13066,"att_blood":7465115,"att_tank":{"1":78,"2":87,"3":75,"4":71,"5":77,"6":89},"def_kid":12085,"def_blood":3581119,"def_name":"周杰伦","is_win":1,"combat_id":841,"fight_data":{"att_max_blood":7465116,"def_max_blood":3581144,"fight":[{"att_hurt":136400,"att_blood":7328716,"att_die":[],"def_hurt":3581144,"def_blood":0,"def_die":[{"pos":1,"from":1},{"pos":3,"from":1},{"pos":4,"from":1},{"pos":5,"from":1},{"pos":2,"from":1},{"pos":6,"from":1}]}]},"def_tank":{"1":47,"2":78,"3":55,"4":53,"5":86,"6":48},"att_win_times":2,"def_win_times":1}]}],"win_max":6}]]
--     self:initWarData(qy.json.decode(data))
-- end

function WarGroupModel:initWarData(data)
    self.user_formation = {
        [self.LEFT_KEY] = {0,0,0},
        [self.RIGHT_KEY] = {0,0,0}
    }
    self.round_list = {0,0,0}
    self.field_num = 1

    self.results_list = data.results_list

    self.stop_status = {false,false,false}
    self.def_member_list = data.def_member_list
    self.att_member_list = data.att_member_list
    self.att_legion_name = data.att_legion_name
    self.def_legion_name = data.def_legion_name
    if data.is_win == 1 then
        self.is_att_win = true
        self.win_legion_name = self.att_legion_name
    else
        self.is_att_win = false
        self.win_legion_name = self.def_legion_name
    end

    -- 战斗类型 1：军团战 2:多人副本 3:围攻柏林BOSS
    self.battle_type = self.BATTLE_LEGION_WAR
    if data.ext and data.ext.battle_type then
        self.battle_type = data.ext.battle_type
    end
    if self.battle_type == self.BATTLE_LEGION_WAR then
        self.win_max = data.win_max
    elseif self.battle_type == self.BATTLE_ATTACKBERLIN then
        self.win_max = data.win_max
    else
        self.win_max = 100
    end
end

function WarGroupModel:isAttackWin()
    return self.is_att_win
end

function WarGroupModel:getWinMax()
    return self.win_max
end

function WarGroupModel:setStopStatusByIndex(_track,status)
    self.stop_status[_track] = status
end

function WarGroupModel:getStopStatusByIndex(_track)
    return self.stop_status[_track]
end

function WarGroupModel:isBattleEnded()
    for i = 1,3 do
        if not self.stop_status[i] then
            return false
        end
    end
    return true
end

function WarGroupModel:getBattleType()
    return self.battle_type
end

function WarGroupModel:getUserFormation(index)
    return {
        [self.LEFT_KEY] = self.user_formation[self.LEFT_KEY][index],
        [self.RIGHT_KEY] = self.user_formation[self.RIGHT_KEY][index]
    }
end

function WarGroupModel:exchangeUserFormation(_prefix,source_index,target_index)
    -- self.user_formation[_prefix][target_index] = self.user_formation[_prefix][source_index]
    self.user_formation[_prefix][source_index] = 0
end

function WarGroupModel:formatBattleData(data,format_index)
    if data then
        if data.att_blood == -1 then
            data.att_blood = data.fight_data.att_max_blood
        end
        if data.def_blood == -1 then
            data.def_blood = data.fight_data.def_max_blood
        end
    end
    return data
end

-- function WarGroupModel:isPlaying(_prefix,kid)
--     for i = 1, #self.user_formation[_prefix] do
--         if self.user_formation[_prefix][i] == kid then
--             if _prefix == self.LEFT_KEY then
--                 if self.user_formation[self.RIGHT_KEY][i] == 0 then
--                     return false
--                 else
--                     return true
--                 end
--             else
--                 if self.user_formation[self.LEFT_KEY][i] == 0 then
--                     return false
--                 else
--                     return true
--                 end
--             end
--         end
--     end
--
--     return false
-- end

-- function WarGroupModel:__chooseFirstData()
--     for i = 1, #self.results_list do
--         local flag1 = self:isPlaying(self.LEFT_KEY,self.results_list[i]["att_kid"])
--         if not flag1 then
--             local flag2 = self:isPlaying(self.RIGHT_KEY,self.results_list[i]["def_kid"])
--             if not flag2 then
--                 return table.remove(self.results_list,i)
--             end
--         end
--     end
--     return nil
-- end

-- function WarGroupModel:__getBattleData(_track,_prefix,kid)
--     if #self.results_list > 0 then
--         if _prefix == nil then
--             local data = self:__chooseFirstData()
--             return self:formatBattleData(data,_track)
--         end
--
--         for i = 1, #self.results_list do
--             if self.results_list[i][_prefix .. "_kid"] == kid then
--                 if _prefix == self.LEFT_KEY then
--
--                     if self:isPlaying(self.RIGHT_KEY,self.results_list[i][self.RIGHT_KEY .. "_kid"]) then
--                         return nil
--                     else
--                         return self:formatBattleData(table.remove(self.results_list,i),_track)
--                     end
--                 else
--                     if self:isPlaying(self.RIGHT_KEY,self.results_list[i][self.RIGHT_KEY .. "_kid"]) then
--                         return nil
--                     else
--                         return self:formatBattleData(table.remove(self.results_list,i),_track)
--                     end
--                 end
--             end
--         end
--         local data = self:__chooseFirstData()
--         return self:formatBattleData(data,_track)
--     end
--
--     return nil
-- end

function WarGroupModel:dealFieldEnd(_track)
    if self:isBattleEnded() then
        self.field_num = self.field_num+1
        -- print("self.field_num======>>>",self.field_num)
        if self.field_num > #self.results_list then
            --结束
            -- print("qy.Event.dispatch(qy.Event.WAR_GROUP_END)")
            qy.Event.dispatch(qy.Event.WAR_GROUP_END)
        else
            --开始下一场
            self:setStopStatusByIndex(self.TRACK_1,false)
            self:setStopStatusByIndex(self.TRACK_2,false)
            self:setStopStatusByIndex(self.TRACK_3,false)
            -- print("qy.Event.dispatch(qy.Event.WAR_GROUP_FIELD)")
            qy.Event.dispatch(qy.Event.WAR_GROUP_FIELD)
        end
    end
end

--打完一场，搜索下一场，如果是6胜，则清空
--如果不是6胜，清除输的一方
function WarGroupModel:getBattleDataByIndex(_track)
    local resultsData = self.results_list[self.field_num]

    if resultsData[tostring(_track)] then
        if #resultsData[tostring(_track)] > 0 then
            local data = table.remove(resultsData[tostring(_track)],1)
            self:setUserFormation(self.LEFT_KEY,_track,data.att_kid)
            self:setUserFormation(self.LEFT_KEY,_track,data.def_kid)
            -- print("self.results_list==>>",qy.json.encode(self.results_list))
            return self:formatBattleData(data,_track)
        else
            self:setStopStatusByIndex(_track,true)
            self:dealFieldEnd(_track)
            return nil
        end
    else
        self:setStopStatusByIndex(_track,true)
        return nil
    end
end

function WarGroupModel:setUserFormation(_prefix,_track,value)
    if self.user_formation == nil then
        self.user_formation = {}
    end
    if self.user_formation[_prefix] == nil then
        self.user_formation[_prefix] = {}
    end
    self.user_formation[_prefix][_track] = value
end

function WarGroupModel:getIndexByUserFormation(_prefix,value)
    if self.user_formation == nil then
        return 0
    end
    if self.user_formation[_prefix] == nil then
        return 0
    end
    if  #self.user_formation[_prefix] > 0 then
        for i = 1, #self.user_formation[_prefix] do
            if self.user_formation[_prefix][i] == value then
                return i
            end
        end
        return 0
    else
        return 0
    end
end

function WarGroupModel:getMemberNumByPrefix(prefix)
    if self[prefix.."_member_list"] then
        return #self[prefix.."_member_list"]
    else
        return 0
    end
end

function WarGroupModel:getMemberDataByIdx(prefix,index)
    if self[prefix.."_member_list"] then
        return self[prefix.."_member_list"][index]
    else
        return nil
    end
end

function WarGroupModel:removeFromMemberList(prefix,kid)
    if self[prefix.."_member_list"] then
        for i = 1, #self[prefix.."_member_list"] do
            if self[prefix.."_member_list"][i].kid == kid then
                table.remove(self[prefix.."_member_list"],i)
                return
            end
        end
    end
end

function WarGroupModel:setTrackRound(_track,round)
    self.round_list[_track] = round
end

function WarGroupModel:getTrackRound(_track)
    return self.round_list[_track]
end

function WarGroupModel:setBattleAward(_data)
    self.battleAward = _data
end

function WarGroupModel:getBattleAward()
    return self.battleAward
end

return WarGroupModel
