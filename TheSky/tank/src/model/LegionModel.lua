--[[--
    军团model
    Author: H.X.Sun
--]]

local LegionModel = qy.class("LegionModel", qy.tank.model.BaseModel)
local StrongModel = qy.tank.model.StrongModel

local AwardUtils = qy.tank.utils.AwardUtils
local NumberUtil = qy.tank.utils.NumberUtil
local RedDotModel = qy.tank.model.RedDotModel

LegionModel.IS_OPERATE = 1 --加入（未加入军团）
LegionModel.IS_WATCH = 2 --查看（已加入军团）

LegionModel.TIPS_OP = 1 --操作提示
LegionModel.TIPS_DIS = 2 --解散
LegionModel.TIPS_MOD = 3 --修改公告
LegionModel.TIPS_BOSS = 4 --司令授予
LegionModel.TIPS_UP = 5 --升职
LegionModel.TIPS_LEAVE = 6 --离开（退出）军团

LegionModel.POST_PK_LOSE = 0 --挑战失败，军职不变
LegionModel.POST_PK_WIN = 1 --挑战胜利，成功升职
LegionModel.POST_PK_NONE = 2 --职位空缺，直接升职

LegionModel.NOT_OPEN_PARTY_TAG = 1--不用开启的宴会(人满就开启)

LegionModel.B_P_FORCED_TYPE = 1--霸王宴会
LegionModel.B_P_NORMAL_TYPE = 2--普通宴会

LegionModel.FARM_MAX_NUM = 50 --农场收获最大次

LegionModel.skillTypeNameList ={
    ["1"] = "攻击力",
    ["2"] = "防御力",
    ["3"] = "生命值",
    ["4"] = "穿深",
    ["5"] = "穿深抵抗",
    ["6"] = "暴击率",
    ["7"] = "暴击伤害",
    ["8"] = "初始士气",
    ["9"] = "命中",
    ["10"] = "闪避",
    ["11"] = "攻击百分比",
    ["12"] = "防御百分比",
    ["13"] = "生命百分比",
    ["14"] = "伤害减免"
}

function LegionModel:clear()
    self.commander = nil
    self.hisLegion = nil
end

function LegionModel:init(data)
    self:updateCommander(data)
    self:updateHisLegion(data)
    self.can_set_name_free = 0
    self.set_name_cost  = 5000
    if not self.commander:isJoin() then
        self:initLegionList(data)
    else
        self:initMemberList(data)
    end
    self:initClubData()
    if data.can_set_name_free then
        self.can_set_name_free = data.can_set_name_free 
        self.set_name_cost  = data.set_name_cost
    end
    if data.attack_berlin then
        qy.tank.model.AttackBerlinModel:updateopen(data.attack_berlin)
    end
end
function LegionModel:updatechangenum( data )
    if data.can_set_name_free then
        self.can_set_name_free = data.can_set_name_free 
        self.set_name_cost  = data.set_name_cost
    end
end

function LegionModel:initLegionList(data)
    -- self.legionArr = {}
    self.legionEntityArr = {}
    self.legionIndexArr = {}
    if data.list then
        for i = 1, #data.list do
            -- data.list[i].legion_id = data.legion_id ===
            local entity = qy.tank.entity.LegionEntity.new(data.list[i])
            table.insert(self.legionIndexArr,entity.id)
            self.legionEntityArr[tostring(entity.id)] = entity
        end
    end
    self:updateCommander(data)

    self:updatePageInfo(data)
end

function LegionModel:updateHisLegion(data)
    local _d = {}
    if data.legion_info then
        _d = data.legion_info
    else
        _d = data
    end
    if self.hisLegion then
        self.hisLegion:update(_d)
    else
        self.hisLegion = qy.tank.entity.LegionEntity.new(_d)
    end
end


--[[--
    指挥官所在的军团实体
--]]--
function LegionModel:getHisLegion()
    return self.hisLegion
end

function LegionModel:initApplyList(data)
    self.applyList = {}
    if data.list then
        for i = 1, #data.list do
            local entity = qy.tank.entity.LegionUserEntity.new(data.list[i])
            table.insert(self.applyList,entity)
        end
    end
end

function LegionModel:clearApplist()
    self.applyList = {}
end

function LegionModel:removeApplyData(_kid)
    for i = 1, #self.applyList do
        if self.applyList[i].kid and self.applyList[i].kid == _kid then
            table.remove(self.applyList,i)
            break
        end
    end
    RedDotModel:setLegionApplyRed(#self.applyList)
end

function LegionModel:updatePageInfo(data)
    self.curPage = data.page or 1
    self.countPage = data.count_page or 1
end

function LegionModel:getPageInfo()
    if self.countPage and self.curPage then
        return self.curPage .. "/" .. self.countPage
    else
        return "1/1"
    end
end

function LegionModel:hasLastPage()
    if self.curPage and self.curPage - 1 > 0 then
        return true
    else
        return false
    end
end

function LegionModel:setMListHasRefresh(_flag)
    self.mListHasRefresh = _flag
end

function LegionModel:getMListHasRefresh()
    return self.mListHasRefresh
end

function LegionModel:hasNextPage()
    if self.curPage and self.countPage and self.countPage - self.curPage > 0 then
        return true
    else
        return false
    end
end

function LegionModel:initMemberList(data)
    self.memberList = {}
    if data.list then
        for i = 1, #data.list do
            local entity = qy.tank.entity.LegionUserEntity.new(data.list[i])
            table.insert(self.memberList,entity)
        end
    end
    self:updateHisLegion(data)
    self:updateCommander(data)
    --红点
    RedDotModel:setLegionApplyRed(data.red_apply)
end

function LegionModel:addMember(data)
    if data and self.memberList then
        local entity = qy.tank.entity.LegionUserEntity.new(data)
        table.insert(self.memberList,entity)
    end
end

function LegionModel:removeMemberEntity(_kid)
    for i = 1, #self.memberList do
        if self.memberList[i].kid == _kid then
            table.remove(self.memberList,i)
            return
        end
    end
end

function LegionModel:updateCommander(data)
    if self.commander then
        self.commander:update({
            ["legion_id"] = data.legion_id,
            ["user_score"] = data.user_score,
            ["contribution"] = data.contribution,
            ["has_get_salay"] = data.is_have_get_award,
        })
    else
        self.commander = qy.tank.entity.LegionUserEntity.new({
            ["legion_id"] = data.legion_id,
            ["user_score"] = data.user_score,
            ["contribution"] = data.contribution,
        })
    end
end

function LegionModel:updateApplyList(data)
    for _k, _v in pairs(self.legionEntityArr) do
        self.legionEntityArr[_k]:updateApply(false)
    end

    local entity
    for i = 1, #data.apply_list do
        entity = self.legionEntityArr[tostring(data.apply_list[i])]
        if entity then
            entity:updateApply(true)
        end
    end
end

function LegionModel:getLegionNum()
    return #self.legionIndexArr
end

function LegionModel:getMemberNum()
    return #self.memberList
end

function LegionModel:getApplyNum()
    return #self.applyList
end

function LegionModel:getApplyEntityByIndex(_idx)
    if self.applyList and self.applyList[_idx] then
        return self.applyList[_idx]
    else
        return nil
    end
end

function LegionModel:getLegionEntityByIndex(_idx)
    if self.legionIndexArr and self.legionIndexArr[_idx] then
        return self.legionEntityArr[tostring(self.legionIndexArr[_idx])]
    else
        return nil
    end
end

function LegionModel:getMemberEntityByIndex(_idx)
    if self.memberList and self.memberList[_idx] then
        return self.memberList[_idx]
    else
        return nil
    end
end

--[[--
    指挥官的军团用户数据
--]]--
function LegionModel:getCommanderEntity()
    return self.commander
end

function LegionModel:updateNotice(_str)
    self:updateHisLegion({
        ["notice"] = _str
    })
end

--[[--
    职位挑战状态
    _tag=1 : _tag初始值
    _tag=0 :挑战失败，军职不变
    _tag=1 :挑战胜利，成功升职
    _tag=2 :职位空缺，直接升职
--]]
function LegionModel:setPostPkStatus(_tag)
    self.postPkTag = _tag
end

function LegionModel:getPostPkStatus()
    if self.postPkTag then
        return self.postPkTag
    else
        return -1
    end
end

function LegionModel:canNotPkPostDes()
    local data = qy.Config.legion_user_score
    return qy.TextUtil:substitute(50002, data["1"].name, data["2"].name, data["3"].name, data["1"].name)
end

-----------------俱乐部-----------------------------------------------
function LegionModel:initClubData()
    self.clubList = {}
    local data = qy.Config.legion_open_gongneng
    for _k, _v in pairs(data) do
        if _v.index_club > 0 then
            self.clubList[_v.index_club] = _v
        end
    end
end

function LegionModel:getClubDataByIdx(_idx)
    if self.clubList and self.clubList[_idx] then
        return self.clubList[_idx]
    else
        return nil
    end
end

function LegionModel:getClubNum()
    return #self.clubList
end

--[[--农场--]]---
function LegionModel:initFarmData(data)
    self.farmNum = data.farm_num
    self.isGetFarm = data.is_get

    self.getMsgList = {}
    local _num = #data.msg_list
    for i = 1 , _num do
        if #self.getMsgList >= 7 then
            return
        end
        if data.msg_list[_num - i + 1].tag ~= 1 then
            table.insert(self.getMsgList,data.msg_list[_num - i + 1])
        end
    end
end

function LegionModel:getFarmMsgByIdx(_idx)
    if self.getMsgList and self.getMsgList[_idx] then
        return self.getMsgList[_idx]
    else
        return nil
    end
end

function LegionModel:getFarmMsgNum()
    if self.getMsgList then
        return #self.getMsgList
    else
        return 0
    end
end

function LegionModel:getRemainNum()
    if tonumber(self.farmNum) then
        return self.FARM_MAX_NUM - self.farmNum
    else
        return 0
    end
end

function LegionModel:getMsgNum()
    if self.getMsgList then
        return #self.getMsgList
    else
        return 0
    end
end

function LegionModel:getFarmDataByIdx(_idx)
    local data = qy.Config.legion_farm
    if data then
        return data[tostring(_idx)]
    else
        return nil
    end
end

function LegionModel:getColorByIdx(_type,_idx)
    if _type == 1 then
        --cc.c4b
        if _idx == 1 then
            return cc.c4b(251,253,84,255)
        elseif _idx == 2 then
            return cc.c4b(64,177,255,255)
        else
            return cc.c4b(238,91,255,255)
        end
    else
        --cc.c3b
        if _idx == 1 then
            return cc.c3b(251,253,84)
        elseif _idx == 2 then
            return cc.c3b(64,177,255)
        else
            return cc.c3b(238,91,255)
        end
    end
end

function LegionModel:initDiceData(data)
    self.diceRankList = data.rank_list or {}
    self.rand_ret = data.rand_ret or {}
    self.commander:updataDiceData(data)
    if data.award then
        if self.diceAward == nil then
            self.diceAward = {}
            local _idx = 1
            for _k, _v in pairs(data.award) do
                self.diceAward[_idx] = _v
                self.diceAward[_idx].score = tonumber(_k)
                _idx = _idx + 1
            end
            table.sort(self.diceAward,function(a,b)
        		return tonumber(a.score) > tonumber(b.score)
        	end)
        end
    end
end

function LegionModel:updateDiceAward(i,flag)
    if i == 3 then
        self.commander:updataDiceData({["ago_rank_award"] = flag})
    else
        self.diceAward[i].have_get = flag
    end
end

function LegionModel:getDiceAward()
    return self.diceAward
end

function LegionModel:getDiceRankNum()
    if self.diceRankList then
        return #self.diceRankList
    else
        return 0
    end
end

function LegionModel:getDiceRankByIndex(_idx)
    local sData = self.diceRankList[_idx]

    if sData then
        local cData = qy.Config.legion_dice_rank_award[tostring(sData.rank)]
        if cData then
            sData.dia_num = cData.num
        else
            sData.dia_num = 0
        end
    end
    return sData
end

function LegionModel:getDiceResult()
    return self.rand_ret
end

function LegionModel:canGetDiceAward(i)
    if i < 3 then
        if self.diceAward[i].have_get then
            -- print("self.diceAward[i].have_get======>>>>>",i)
            return false
        elseif self.commander.d_my_score < self.diceAward[i].score then
            -- print("self.commander.d_my_score====>>>"..i .. "=====",self.commander.d_my_score)
            -- print("self.diceAward["..i.."].score====>>>",self.diceAward[i].score)
            return false
        else
            return true
        end
    else
        if self.commander.d_ago_rank_award or self.commander.d_ago_dia_num == 0 then
            return false
        else
            return true
        end
    end
end

function LegionModel:getDiceNotAwardMsg(i)
    if i < 3 then
        if self.diceAward[i].have_get then
            return qy.TextUtil:substitute(50004, self.diceAward[i].score)
        else
            return qy.TextUtil:substitute(50006, self.diceAward[i].score)
        end
    else
        if self.commander.d_ago_rank_award then
            return qy.TextUtil:substitute(50008)
        elseif self.commander.d_ago_dia_num == 0 then
            return qy.TextUtil:substitute(50009)
        end
    end
end

function LegionModel:updateBankData(data)
    if data.legion_id then
        self:updateCommander(data)
    end
    if data.legion_info then
        self:updateHisLegion(data)
    end
    self.bankLog = data.list
    self.salay = data.award
    self.bank_cost_arr = data.cost_arr
end

function LegionModel:getBankLogNum()
    return #self.bankLog
end

function LegionModel:getBankLogDataByIndex(_idx)
    return self.bankLog[_idx]
end

function LegionModel:getSalary()
    for i = 1, #self.salay do
        self.salay[i].icon = AwardUtils.getAwardIconByType(self.salay[i].type)
        self.salay[i].s_num = qy.InternationalUtil:getResNumString(self.salay[i].num)
    end
    return self.salay
end

function LegionModel:getBankCostArr()
    return self.bank_cost_arr
end

--宴会
function LegionModel:updatePartyData(data)
    self.commander:setInParty(data.in_party)
    self.partyTimes = data.times or self.partyTimes
    self.openPartyList = {}
    if data.in_party then
        self.commander:setPartyMasterId(data.master_id)
        self.partyUserList = data.user_list
        self.openPartyList[1] = {
            ["tag"] = data.tag,
            ["len"] = #self.partyUserList,
            ["name"] = self:getPartyMasterName(data.master_id),
        }
    else
        self.openPartyList = data.list
    end
end

function LegionModel:getPartyTimes()
    if tonumber(self.partyTimes) then
        return self.partyTimes
    else
        return 0
    end
end

function LegionModel:getPartyMasterName(_mid)
    for i = 1, #self.partyUserList do
        if self.partyUserList[i].kid == _mid then
            return self.partyUserList[i].name
        end
    end
    return ""
end

function LegionModel:getOpenPartyNum()
    return #self.openPartyList
end

function LegionModel:getOpenPartyDataByIndex(_idx)
    local data = self.openPartyList[_idx]
    if data then
        data.color = self:getColorByIdx(1,data.tag)
        data.party_data = self:getPartyDescByIdx(data.tag)
        return data
    else
        return nil
    end
end

function LegionModel:getPartyDescByIdx(_idx)
    local data = qy.Config.legion_party
    if data then
        return data[tostring(_idx)]
    else
        return nil
    end
end

function LegionModel:getPWaitMsgDataByIndex(_idx)
    return self.partyUserList[_idx]
end

function LegionModel:getPWaitMsgNum()
    local need_num = self:getPartyDescByIdx(self.openPartyList[1].tag).need_num
    if #self.partyUserList == need_num then
        return #self.partyUserList
    else
        return #self.partyUserList + 1
    end
end

function LegionModel:isOpenParty()
    if self._in_party == false then
        return true
    else
        return false
    end
end

function LegionModel:updatePartyForJoin(data)
    self._in_party = true
    if data.legion_exp ~= nil then
        self:updateHisLegion(data.legion_info)
        self.partyAward = {
            data.award[1].num,
            data.legion_exp,
        }
        self._in_party = false
    end
    data.in_party = self._in_party
    self:updatePartyData(data)
end

function LegionModel:updatePartyForBegin(data)
    self:updateHisLegion(data.legion_info)
    self.partyAward = {
        data.award[1].num,
        data.legion_exp,
    }
    data.in_party = false
    self:setHasPartyAward(true)
    self:updatePartyData(data)
end

function LegionModel:setHasPartyAward(_flag)
    self.hasPartyAward = _flag
end

function LegionModel:getHasPartyAward()
    return self.hasPartyAward
end

function LegionModel:getPartyAward()
    return self.partyAward
end

function LegionModel:initSkillData(data)
    local skillList = data.legion_skill and data.legion_skill.skill_list or nil
    local cfg = qy.Config.legion_skill
    if skillList then
        for i=1, table.nums(skillList) do
            self["skillLevel" .. i] = skillList[i..""].level or 0
        end
    else
        for i=1, 4 do
            self["skillLevel" .. i] = 0
        end
    end
    self.contribution_skill = data.legion_skill and data.legion_skill.contribution or nil
    self.contributions = data.contribution
    self:updateLegionAddData()
    self:updateLegionNextAddData()
end

function LegionModel:updataSkillData(data)
    local skillList = data.legion_skill and data.legion_skill.skill_list or nil
    local cfg = qy.Config.legion_skill
    if skillList then
        for i=1, table.nums(skillList) do
            self["skillLevel" .. i] = skillList[i..""].level or 0
        end
    else
        for i=1, 4 do
            self["skillLevel" .. i] = 0
        end
    end
    self.contribution_skill = data.legion_skill and data.legion_skill.contribution or nil
    self:updateLegionAddData()
    self:updateLegionNextAddData()
end

function LegionModel:updateLegionAddData()
    local cfg = qy.Config.legion_skill
    self.finalReturn = {}
    self.finalReturn["1"] = self.skillLevel1 == 0 and 0 or math.floor(cfg["1"].val * (self.skillLevel1 + 2) + cfg["1"].val * self.skillLevel1^1.3)
    self.finalReturn["2"] = self.skillLevel2 == 0 and 0 or math.floor(cfg["2"].val * (self.skillLevel2 + 2) + cfg["2"].val * self.skillLevel2^1.3)
    self.finalReturn["3"] = self.skillLevel3 == 0 and 0 or math.floor(cfg["3"].val * (self.skillLevel3 + 2) + cfg["3"].val * self.skillLevel3^1.3)
    self.finalReturn["4"] = self.skillLevel4 == 0 and 0 or (cfg["4"].val * (self.skillLevel4))/10

    -- 更新变强数据
    self:updateStrong()
end

function LegionModel:updateStrong()
    local x = 0
    for k,v in pairs(StrongModel.StrongFcList) do
        x = x + 1
        if v.id == 9 then
            table.remove(StrongModel.StrongFcList, x)
        end
    end
    local level = qy.tank.model.UserInfoModel.userInfoEntity.level
    local totalLevel = 0
    for i=1, 4 do
        totalLevel = totalLevel + self["skillLevel" .. i]
    end
    local list = {["id"] = 9 , ["progressNum"] = (totalLevel / level * 4 * 0.8)}
    table.insert(StrongModel.StrongFcList,list)
end

function LegionModel:updateLegionNextAddData()
    local cfg = qy.Config.legion_skill
    self.nextAddList = {}
    self.nextAddList["1"] = math.floor(cfg["1"].val * (self.skillLevel1 + 3) + cfg["1"].val * (self.skillLevel1 + 1)^1.3)
    self.nextAddList["2"] = math.floor(cfg["2"].val * (self.skillLevel2 + 3) + cfg["2"].val * (self.skillLevel2 + 1)^1.3)
    self.nextAddList["3"] = math.floor(cfg["3"].val * (self.skillLevel3 + 3) + cfg["3"].val * (self.skillLevel3 + 1)^1.3)
    self.nextAddList["4"] = (cfg["4"].val * (self.skillLevel4 + 1))/10
end

return LegionModel
