--[[--
    军团战model
    Author: H.X.Sun
--]]

local LegionWarModel = qy.class("LegionWarModel", qy.tank.model.BaseModel)

--赛段 0-休息/1-初赛/2-复赛/3-决赛
LegionWarModel.STAGE_REST = 0
LegionWarModel.STAGE_EARLY = 1
LegionWarModel.STAGE_SEMI = 2
LegionWarModel.STAGE_FINAL = 3

--行为 1-报名/2-进行中/3-排名/4-观战
LegionWarModel.ACTION_SIGN = 1
LegionWarModel.ACTION_PLAY = 2
LegionWarModel.ACTION_END = 3
LegionWarModel.ACTION_WATCH = 4

local userModel = qy.tank.model.UserInfoModel
local legionModel = qy.tank.model.legionModel
local NumberUtil = qy.tank.utils.NumberUtil

--暂时关闭军团战
function LegionWarModel:isClosedWar()
    return false
end

function LegionWarModel:setGuideInfo(legion_fight_is_guide)
    self.legion_fight_is_guide = legion_fight_is_guide or 0
end

function LegionWarModel:isNeedGuide()
    if self:isClosedWar() then
        return false
    end

    if self.legion_fight_is_guide == 1 then
        local isOtherDay = NumberUtil.isOtherDay(cc.UserDefault:getInstance():getStringForKey(userModel.userInfoEntity.kid .."_legion_war_time",0))
        if isOtherDay then
            cc.UserDefault:getInstance():setStringForKey(userModel.userInfoEntity.kid .."_legion_war_time", userModel.serverTime)
            return true
        end
    end

    return false
end

function LegionWarModel:init()
    self.infoEntity = qy.tank.entity.LeWarInfoEntity.new()
    self.combatList = {}
    self.combatNum = nil
    self.isHasCombat = false
end

function LegionWarModel:isDeadById(_kid)
    if self.dead_list and #self.dead_list then
        for i = 1, #self.dead_list do
            if self.dead_list[i] == _kid then
                return true
            end
        end
    end

    return false
end

function LegionWarModel:getMyLegionId()
    if self.legion_id then
        return self.legion_id
    else
        return 0
    end
end

function LegionWarModel:update(data)
    self.legion_id = data.legion_id
    self.infoEntity:update(data)
    self.resultsList = {}
    self.dead_list = data.dead_list
    if data.member_list then
        self:initMemberList(data.member_list)
    end
    self.member_len = data.member_len

    --进行中
    self.resultNum = nil
    self.resultsList[1] = {}--一轮数值
    if data.results_list then
        self.resultsList[1] = data.results_list
        self:setWatchCombatId(data.results_list)
    else
        self:setWatchCombatId(data)
    end
    self.open_time = data.open_time
    table.insert(self.resultsList[1],1,{["has_title"] = true,["title"]=self.open_time or 0})

    --结果
    self.legion_rank_list = data.legion_rank_list
    self.user_rank_list = data.user_rank_list

    --决赛
    self.final_results = data.final_results or {}
    --决赛前八
    self.legion_list = data.legion_list or {}
    if self.infoEntity:getGameAction() == self.ACTION_WATCH then
        self:dealWatchCombat()
    end

    self.data = data
end

function LegionWarModel:setWatchCombatId(data)
    self.watch_combat_id = 0

    if data and #data > 0 then
        local myKid = userModel.userInfoEntity.kid
        for i = 1, #data do
            if myKid == data[i].att_kid or myKid == data[i].def_kid then
                self.watch_combat_id = data[i].combat_id
            end
        end
        if self.watch_combat_id == 0 then
            self.watch_combat_id = data[1].att_kid
        end
    end
end

function LegionWarModel:getWatchCombatId()
    if self.watch_combat_id then
        return self.watch_combat_id
    else
        return 0
    end
end

function LegionWarModel:getLegionListForFinal()
    if #self.legion_list < 8 then
        for i = #self.legion_list + 1, 8 do
            local arr = {}
            arr.legion_id = 0
            arr.name = ""
            table.insert(self.legion_list,arr)
        end
    end
    return self.legion_list
end

function LegionWarModel:getTotalRankData()
    return self.totalRankList
end

--决赛的赛段
function LegionWarModel:getStageForFinal()
    if self.final_results == nil then
        return 1
    end

    if #self.final_results == 0 or #self.final_results == 1 then
        --四强赛
        return 1
    elseif #self.final_results == 2 then
        --半决赛
        return 2
    else
        --决赛
        return 3
    end
end

function LegionWarModel:getFinalResultNum()
    if self.final_results then
        return #self.final_results
    else
        return 0
    end
end

function LegionWarModel:getResultForFinal()
    return self.final_results
end

function LegionWarModel:getMyFinalResultData(index)
    local data
    if self.legion_id then
        if self.final_results and self.final_results[index] then
            for i = 1, #self.final_results[index] do
                data = self.final_results[index][i]
                if data.att_legion_id == self.legion_id or data.def_legion_id == self.legion_id then
                    data.sIndex = i
                    return data
                end
            end
        end
    end

    return nil
end

function LegionWarModel:initMemberList(data)
    self.memberList = {}
    self.joinList = {}
    for i = 1, #data do
        local entity = qy.tank.entity.LegionUserEntity.new(data[i])
        table.insert(self.memberList,entity)
        --已报名 和 未死亡
        if entity:hasSignUp() and not self:isDeadById(self.memberList[i].kid) then
             table.insert(self.joinList,i)
        end
    end
end

function LegionWarModel:formattPoint(_score)
    if _score and _score > 0 then
        return qy.TextUtil:substitute(50020, _score)
    else
        return qy.TextUtil:substitute(50021)
    end
end

function LegionWarModel:formattScore(_rank, _stage)
    if _rank and _rank > 0 then
        if not _stage then
            return qy.TextUtil:substitute(50022, _rank)
        end
        if _stage == self.STAGE_FINAL then
            local data = qy.Config.legion_war_final_score
            return qy.TextUtil:substitute(50022, data[tostring(_rank)].score)
        else
            local data = qy.Config.legion_war_score
            for _k,_v in pairs(data) do
                if _v.front_rank <= _rank then
                    if _rank <= _v.post_rank or _v.post_rank == -1 then
                        if _stage == self.STAGE_EARLY then
                            return qy.TextUtil:substitute(50022, _v.one_score)
                        else
                            return qy.TextUtil:substitute(50022, _v.two_score)
                        end
                    end
                end
            end
        end
    end

    return qy.TextUtil:substitute(50021)
end

function LegionWarModel:formattRank(_rank)
    if _rank and _rank > 0 then
        return qy.TextUtil:substitute(50023, _rank)
    else
        return qy.TextUtil:substitute(50021)
    end
end

function LegionWarModel:getEndInfo()
    return self.data
end

function LegionWarModel:getLegionRankNum(_tab_idx)
    if _tab_idx then
        --排行 1-总排行/2-初赛排行/3-复赛排行/4-决赛排行
        if self.totalRankList then
            if _tab_idx == 1 then
                if self.totalRankList.sum and #self.totalRankList.sum.legion_rank_list > 0 then
                    return #self.totalRankList.sum.legion_rank_list
                end
            elseif _tab_idx == 2 then
                if self.totalRankList.one and #self.totalRankList.one.legion_rank_list > 0 then
                    return #self.totalRankList.one.legion_rank_list
                end
            elseif _tab_idx == 3 then
                if self.totalRankList.two and #self.totalRankList.two.legion_rank_list > 0 then
                    return #self.totalRankList.two.legion_rank_list
                end
            else
                if self.totalRankList.three and #self.totalRankList.three.legion_rank_list > 0 then
                    return #self.totalRankList.three.legion_rank_list
                end
            end
        end

        --默认三个虚位以待
        return 3
    else
        if self.legion_rank_list then
            --首页-排行(不超过3个)
            if #self.legion_rank_list > 3 then
                return 3
            else
                return #self.legion_rank_list
            end
        else
            return 0
        end
    end
end

function LegionWarModel:getLegionRankData(_idx,_tab_idx)
    if _tab_idx then
        --排行 1-总排行/2-初赛排行/3-复赛排行/4-决赛排行
        if self.totalRankList then
            if _tab_idx == 1 then
                if self.totalRankList.sum and self.totalRankList.sum.legion_rank_list then
                    return self.totalRankList.sum.legion_rank_list[_idx]
                end
            elseif _tab_idx == 2 then
                if self.totalRankList.one and self.totalRankList.one.legion_rank_list then
                    return self.totalRankList.one.legion_rank_list[_idx]
                end
            elseif _tab_idx == 3 then
                if self.totalRankList.two and self.totalRankList.two.legion_rank_list then
                    return self.totalRankList.two.legion_rank_list[_idx]
                end
            else
                if self.totalRankList.three and self.totalRankList.three.legion_rank_list then
                    return self.totalRankList.three.legion_rank_list[_idx]
                end
            end
        end
    elseif self.legion_rank_list then
        --首页-排行
        return self.legion_rank_list[_idx]
    end
    return nil
end

function LegionWarModel:getUserRankNum(_tab_idx)
    if _tab_idx then
        --排行 1-总排行/2-初赛排行/3-复赛排行/4-决赛排行
        if self.totalRankList then
            if _tab_idx == 1 then
                if self.totalRankList.sum and self.totalRankList.sum.user_rank_list then
                    return #self.totalRankList.sum.user_rank_list
                end
            elseif _tab_idx == 2 then
                if self.totalRankList.one and self.totalRankList.one.user_rank_list then
                    return #self.totalRankList.one.user_rank_list
                end
            elseif _tab_idx == 3 then
                if self.totalRankList.two and self.totalRankList.two.user_rank_list then
                    return #self.totalRankList.two.user_rank_list
                end
            end
        end

    elseif self.user_rank_list then
        --首页排行（不超过3个）
        if #self.user_rank_list > 3 then
            return 3
        else
            return #self.user_rank_list
        end
    end
    return 0
end

function LegionWarModel:getUserRankData(_idx,_tab_idx)
    if _tab_idx then
        --排行 1-总排行/2-初赛排行/3-复赛排行/4-决赛排行
        if self.totalRankList then
            if _tab_idx == 1 then
                if self.totalRankList.sum and self.totalRankList.sum.user_rank_list then
                    return self.totalRankList.sum.user_rank_list[_idx]
                end
            elseif _tab_idx == 2 then
                if self.totalRankList.one and self.totalRankList.one.user_rank_list then
                    return self.totalRankList.one.user_rank_list[_idx]
                end
            elseif _tab_idx == 3 then
                if self.totalRankList.two and self.totalRankList.two.user_rank_list then
                    return self.totalRankList.two.user_rank_list[_idx]
                end
            end
        end
    elseif self.user_rank_list then
        return self.user_rank_list[_idx]
    end

    return nil
end

function LegionWarModel:getOpenTime()
    if self.open_time then
        return self.open_time
    else
        return 0
    end
end

function LegionWarModel:getResultNum()
    if not self.resultNum then
        self.resultNum = 0
        for i = 1, #self.resultsList do
            self.resultNum = self.resultNum + #self.resultsList[i]
        end
    end
    return self.resultNum
end

function LegionWarModel:getResultDataByIdx(_idx)
    local data
    if self._tab == 1 then
        data = self.resultsList
    else
        data = self.combatList
    end
    if data then
        for i = 1, #data do
            if #data[i] >= _idx then
                return data[i][_idx]
            else
                _idx = _idx - #data[i]
            end
        end
    end
    return nil
end

function LegionWarModel:join(data)
    self.infoEntity.status = 1
    if self.STAGE_FINAL == self.infoEntity:getGameStage() then
        self:initMemberList(data.member_list)
    else
        local _kid = userModel.userInfoEntity.kid
        for i = 1, #self.memberList do
            if self.memberList[i].kid == _kid then
                self.memberList[i].status = 1
                table.insert(self.joinList,i)
                return
            end
        end
    end
end

function LegionWarModel:cancelJoin(data)
    self.infoEntity.status = 0
    self:initMemberList(data.member_list)
end

function LegionWarModel:getJoinNum()
    return #self.joinList
end

function LegionWarModel:getMemberNum()
    return #self.memberList
end

function LegionWarModel:getMemberByIdx(_idx)
    if self.infoEntity:getGameAction() == self.ACTION_PLAY or self.infoEntity:getGameStage() == self.STAGE_FINAL then
        local i = self.joinList[_idx]
        return self.memberList[i]
    else
        return self.memberList[_idx]
    end
end

function LegionWarModel:getLegionWarInfoEntity()
    return self.infoEntity
end

--------- 昨日战况数据 ------------
function LegionWarModel:dealCombatData(data,round,max_round,win_legion)
    local arr = {}
    local titleArr = {}
    for i = 1, #data do
        if data[i][1].round == round then
            arr = data[i]
        end
    end
    titleArr["has_title"] = true
    titleArr["title"] = qy.TextUtil:substitute(50025, round)
    titleArr["content"] = qy.TextUtil:substitute(50026)
    if #arr > 0 then
        if round ~= max_round then
            titleArr["content"] = qy.TextUtil:substitute(50027)
        elseif self.legion_id == win_legion then
            titleArr["content"] = qy.TextUtil:substitute(50028)
        else
            titleArr["content"] = qy.TextUtil:substitute(50029)
        end
    end
    table.insert(arr,1,titleArr)
    return arr
end

function LegionWarModel:dealLegionName(le_id,le_name)
    if le_name then
        if le_id == 0 then
            return qy.TextUtil:substitute(50030, le_name)
        else
            return le_name
        end
    else
        return qy.TextUtil:substitute(50024)
    end
end

function LegionWarModel:dealWatchCombat()
    if self.legion_list == nil then
        return
    end

    local _legion_list = {} --军团名字
    local _combat_list = {} -- 战报列表
    local legion_name
    local legion_id
    local sec_idx = 9
    local _angle_list = {} -- 角标列表
    local _crown_list = {} -- 冠军标识

    if self.final_results and #self.final_results > 0 then
        local def_num
        local data
        -- 有 final_results
        if self.final_results[1] then
            data = self.final_results[1]
            for i = 1, #data do
                def_num = sec_idx - i
                if data[i]["att_legion_id"] ~= 0 and data[i]["def_legion_id"] ~= 0 then
                    _combat_list[tostring(i)] = data[i]["att_legion_id"] .. "-" .. data[i]["def_legion_id"]
                end
                _legion_list[i] = self:dealLegionName(data[i]["att_legion_id"],data[i]["att_legion_name"])
                _legion_list[def_num] = self:dealLegionName(data[i]["def_legion_id"],data[i]["def_legion_name"])
                if data[i].is_win == 1 then
                    _angle_list[i] = 1
                    _angle_list[def_num] = 0
                else
                    _angle_list[i] = 0
                    _angle_list[def_num] = 1
                end
            end
        end

        if self.final_results[2] then
            data = self.final_results[2]

            for i = 1, #data do
                if data[i].is_win == 1 then
                    legion_name = data[i]["att_legion_name"]
                    legion_id = data[i]["att_legion_id"]
                else
                    legion_name = data[i]["def_legion_name"]
                    legion_id = data[i]["def_legion_id"]
                end

                _legion_list[sec_idx] = self:dealLegionName(legion_id,legion_name)
                _angle_list[sec_idx] = 1
                if data[i]["att_legion_id"] ~= 0 and data[i]["def_legion_id"] ~= 0 then
                    _combat_list[tostring(4+i)] = data[i]["att_legion_id"] .. "-" .. data[i]["def_legion_id"]
                end
                sec_idx = sec_idx + 1
            end
        end

        if self.final_results[3] then
            data = self.final_results[3]
            for i = 1, #data do
                if data[i].is_win == 1 then
                    legion_name = data[i]["att_legion_name"]
                    legion_id = data[i]["att_legion_id"]
                else
                    legion_name = data[i]["def_legion_name"]
                    legion_id = data[i]["def_legion_id"]
                end
                _legion_list[sec_idx] = self:dealLegionName(legion_id,legion_name)
                if data[i]["att_legion_id"] ~= 0 and data[i]["def_legion_id"] ~= 0 then
                    _combat_list[tostring(6+i)] = data[i]["att_legion_id"] .. "-" .. data[i]["def_legion_id"]
                end
                sec_idx = sec_idx + 1
            end
            _crown_list[1] = true
            if data[1].is_win == 1 then
                _crown_list[2] = true
                _crown_list[3] = false
            else
                _crown_list[2] = false
                _crown_list[3] = true
            end
            _crown_list[4] = true
        end

    else
        -- 没有 final_results
        for i = 1, #self.legion_list do
            legion_name = self:dealLegionName(self.legion_list[i].legion_id or 0,self.legion_list[i].name)
            table.insert(_legion_list,legion_name)
        end
    end

    self.watchCombatData = {}
    self.watchCombatData.legion_list = _legion_list
    self.watchCombatData.combat_list = _combat_list
    self.watchCombatData.angle_list = _angle_list
    self.watchCombatData.crown_list = _crown_list
end

function LegionWarModel:getWatchCombatData()
    if self.watchCombatData == nil then
        self:dealWatchCombat()
    end

    return self.watchCombatData
end

function LegionWarModel:initCombatList(data)
    self.isHasCombat = true
    self.combatType = data.type
    if data.final_results then
        --决赛
        self.final_results = data.final_results
        --决赛前八
        self.legion_list = data.legion_list
        self:dealWatchCombat()
    else
        self.combatList = {}
        self.combatNum = nil
        if data.results_list then
            local arr
            local list_num = #data.results_list
            local max_round = data.results_list[1][1].round
            for i = 1 ,max_round do
                arr = self:dealCombatData(data.results_list,i,max_round,data.win_legion)
                table.insert(self.combatList,1,arr)
            end
        end
    end
end

function LegionWarModel:isFinalStageCombat()
    if self.combatType and self.combatType == "three" then
        if self.infoEntity:getGameStage() ~= self.STAGE_EARLY then
            return true
        end
    end

    return false
end

function LegionWarModel:getCombatTitle()
    if self.combatType then
        if self.combatType == "one" then
            return qy.TextUtil:substitute(50031)
        elseif self.combatType == "two" then
            return qy.TextUtil:substitute(50032)
        else
            return qy.TextUtil:substitute(50033)
        end
    else
        return ""
    end
end

function LegionWarModel:getCombatNum()
    if not self.combatNum then
        self.combatNum = 0
        for i = 1, #self.combatList do
            self.combatNum = self.combatNum + #self.combatList[i]
        end
    end
    return self.combatNum
end

-------------排行------------------------
function LegionWarModel:initRankList(data)
    if data.sum then
        data.sum["s_my_rank"] = self:formattRank(data.sum.my_rank)
        data.sum["s_my_legion_rank"] = self:formattRank(data.sum.my_legion_rank)
        data.sum["s_my_legion_score"] = self:formattScore(data.sum.my_legion_score)
        data.sum["s_my_legion_point"] = ""
    end
    if data.one then
        data.one["s_my_legion_score"] = self:formattScore(data.one.my_legion_rank,self.STAGE_EARLY)
        data.one["s_my_rank"] = self:formattRank(data.one.my_rank)
        data.one["s_my_legion_rank"] = self:formattRank(data.one.my_legion_rank)
        data.one["s_my_legion_point"] = ""
    end

    if data.two then
        data.two["s_my_legion_point"] = self:formattPoint(data.two.my_legion_score)
        data.two["s_my_legion_score"] = self:formattScore(data.two.my_legion_rank,self.STAGE_SEMI)
        data.two["s_my_rank"] = self:formattRank(data.two.my_rank)
        data.two["s_my_legion_rank"] = self:formattRank(data.two.my_legion_rank)
    end
    if data.three then
        data.three["s_my_legion_score"] = self:formattScore(data.three.my_legion_rank,self.STAGE_FINAL)
        data.three["s_my_rank"] = self:formattRank(data.three.my_rank)
        data.three["s_my_legion_rank"] = self:formattRank(data.three.my_legion_rank)
        data.three["s_my_legion_point"] = ""
    end

    self.totalRankList = data
end

--===============================

function LegionWarModel:getColorByRank(_i)
    if _i == 1 then
        return cc.c4b(247, 171, 78, 255)
    elseif _i == 2 then
        return cc.c4b(232, 70, 210, 255)
    elseif _i == 3 then
        return cc.c4b(81, 165, 254, 255)
    else
        return cc.c4b(255,255,255,255)
    end
end

function LegionWarModel:setLastTab(_tab)
    self._tab = _tab
end

function LegionWarModel:getLastTab()
    return self._tab or 1
end

function LegionWarModel:intAwardList(_stage)
    self.AwardList[_stage] = {}
    local data,title
    if _stage == self.STAGE_EARLY then
        data = qy.Config.legion_war_early_award
    elseif _stage == self.STAGE_SEMI then
        data = qy.Config.legion_war_semi_award
    else
        data = qy.Config.legion_war_final_award
    end

    for _k, _v in pairs(data) do
        if _v["post_rank"] == -1 then
            title = qy.TextUtil:substitute(50034, _v["front_rank"])
        elseif _v["front_rank"] == _v["post_rank"] then
            title = qy.TextUtil:substitute(50035, _v["front_rank"])
        else
            title = qy.TextUtil:substitute(50007, _v["front_rank"], _v["post_rank"])
        end
        self.AwardList[_stage][_v.id] = _v
        self.AwardList[_stage][_v.id]["title"] = title
    end
end

function LegionWarModel:initWarAward()
    self.AwardList = {}
    self:intAwardList(self.STAGE_EARLY)
    self:intAwardList(self.STAGE_SEMI)
    self:intAwardList(self.STAGE_FINAL)
end

function LegionWarModel:getAwardDataByStageAndIdx(_stage,_idx)
    return self.AwardList[_stage][_idx]
end

function LegionWarModel:getAwardNumByStage(_stage)
    if self.AwardList == nil then
        self:initWarAward()
    elseif self.AwardList[_stage] == nil then
        self:intAwardList(_stage)
    end
    return #self.AwardList[_stage]
end

function LegionWarModel:initShopList(data)
    self.shopList = {}
    local configData
    local t_arr
    for i = 1, #data.list do
        configData = qy.Config.legion_shop[tostring(data.list[i]["id"])]
        t_arr = {
            ["award"] = {configData.exchange_award[1],configData.award[1]},
            ["label"] = configData.label,
            ["max_num"] = configData.max_num,
            ["id"] = configData.id,
            ["remain_num"] = configData.max_num - data.list[i]["num"]
        }
        table.insert(self.shopList,t_arr)
    end
    self.shopEndTime = data.end_time
end

function LegionWarModel:getShopNum()
    if self.shopList then
        return #self.shopList
    else
        return 0
    end
end

function LegionWarModel:getShopDataByIdx(_index)
    if self.shopList then
        return self.shopList[_index]
    else
        return nil
    end
end

function LegionWarModel:getShopEndTime()
    if self.shopEndTime then
        return self.shopEndTime
    else
        return -1
    end
end

function LegionWarModel:dealShopBuy(index)
    local reduceAward
    if self.shopList and self.shopList[index] then
        reduceAward = clone(self.shopList[index].award[1])
        reduceAward.num = - reduceAward.num
        self.shopList[index].remain_num = self.shopList[index].remain_num - 1
        qy.tank.command.AwardCommand:add({reduceAward})
    end

end

return LegionWarModel
