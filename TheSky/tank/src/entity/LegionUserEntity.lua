--[[
    军团 用户entity
    Author: H.X.Sun
]]
local LegionUserEntity = qy.class("LegionUserEntity", qy.tank.entity.BaseEntity)

local model = qy.tank.model.LegionModel
local UserResUtil = qy.tank.utils.UserResUtil
local userModel = qy.tank.model.UserInfoModel
-- local NumberUtil = qy.tank.utils.NumberUtil

function LegionUserEntity:ctor(data)
    --军团ID
    self:setproperty("legion_id",data.legion_id or 0)
    --排位
    if data.user_score == nil or data.user_score == 0 then
        self:setproperty("user_score",51)
    else
        self:setproperty("user_score",data.user_score)
    end
    --kid
    self:setproperty("kid",data.kid or 0)
    --贡献
    self:setproperty("contribution",data.contribution or 0)
    --最后登录时间
    self:setproperty("t",data.last_login_t or data.t or 0)
    --等级
    self:setproperty("level",data.level or 0)
    --名字
    self:setproperty("name",data.name or "")
    --头像
    self:setproperty("headicon",data.headicon or "head_1")
    --骰子信息
    self.diceData = {}
    --军团战报名状态
    self:setproperty("status",data.status or 0)
end

function LegionUserEntity:hasSignUp()
    if self.status == 1 then
        return true
    else
        return false
    end
end

function LegionUserEntity:getContributionStr()
   return qy.InternationalUtil:getResNumString(self.contribution)
end

function LegionUserEntity:getHeadIcon()
    return UserResUtil.getRoleIconByHeadType(self.headicon)
end

function LegionUserEntity:update(data)
    if data.legion_id then
        self.legion_id = data.legion_id
    end
    if data.user_score then
        if data.user_score > 0 then
            self.user_score = data.user_score
        else
            self.user_score = 51
        end
    end
    if data.contribution then
        self.contribution = data.contribution
    end
    if data.has_get_salay then
        self.has_get_salay = data.has_get_salay
    end
end

function LegionUserEntity:isJoin()
    if self.legion_id > 0 then
        return true
    else
        return false
    end
end

function LegionUserEntity:isCanPk()
    local status = qy.Config.legion_user_score[tostring(self.user_score - 1)].is_can_pk
    if status == 1 then
        return true
    else
        return false
    end
end

-- function LegionUserEntity:getSalary()
--     local le_level = model:getHisLegion().level
--     local ratio = qy.Config.legion_user_score[tostring(self.user_score)].ratio
--     local data = qy.Config.legion_level[tostring(le_level)]
--     return {
--         NumberUtil:getResNumString(data.money_base * ratio * userModel.userInfoEntity.level),
--         NumberUtil:getResNumString(data.exp_card_base * ratio),
--         NumberUtil:getResNumString(data.tech_base * ratio),
--     }
-- end

function LegionUserEntity:getPostName()
    if self.user_score == 0 then
        return qy.Config.legion_user_score[tostring(51)].name
    else
        local data = qy.Config.legion_user_score[tostring(self.user_score)]
        if data then
            return data.name
        else
            return qy.Config.legion_user_score[tostring(51)].name
        end
    end
end

function LegionUserEntity:getNextPostName()
    local data = qy.Config.legion_user_score[tostring(self.user_score - 1)]
    if data then
        return data.name
    else
        return qy.Config.legion_user_score[tostring(50)].name
    end
end

--[[
    是否有权限审核
--]]
function LegionUserEntity:canAudit()
    if self.user_score == 1 or self.user_score == 2 or self.user_score == 3 then
        return true
    else
        return false
    end
end

--[[
    是否有权限修改公告
--]]
function LegionUserEntity:canModify()
    if self.user_score == 1 or self.user_score == 2 then
        return true
    else
        return false
    end
end

---[[骰子信息]]-------
function LegionUserEntity:updataDiceData(data)
    if data.ago_score then
        self.d_ago_score = data.ago_score
    end
    if data.my_score then
        self.d_my_score = data.my_score
    end
    if data.use_times then
        self.d_use_times = data.use_times
    end
    if data.ago_rank_award ~= nil then
        self.d_ago_rank_award = data.ago_rank_award
    end
    if data.my_rank then
        self.d_my_rank = data.my_rank
        local cData = qy.Config.legion_dice_rank_award[tostring(data.my_rank)]
        if cData then
            self.d_my_dia_num = cData.num
        else
            self.d_my_dia_num = 0
        end
    end
    if data.ago_rank then
        self.d_ago_rank = data.ago_rank
        local cData = qy.Config.legion_dice_rank_award[tostring(data.ago_rank)]
        if cData then
            self.d_ago_dia_num = cData.num
        else
            self.d_ago_dia_num = 0
        end
    end
end

function LegionUserEntity:setInParty(_in_party)
    self.in_party = _in_party or false
end

function LegionUserEntity:isInParty()
    return self.in_party
end

function LegionUserEntity:setPartyMasterId(_mid)
    self.party_master_id = _mid
end

function LegionUserEntity:getPartyMasterId()
    return self.party_master_id
end

function LegionUserEntity:isPartyMaster()
    if userModel.userInfoEntity.kid == self.party_master_id then
        return true
    else
        return false
    end
end

return LegionUserEntity
