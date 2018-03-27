--[[
    军团
    Author: H.X.Sun
]]

local LegionService = qy.class("LegionService", qy.tank.service.BaseService)

local model = qy.tank.model.LegionModel
local uModel = qy.tank.model.UserInfoModel
local AwardCommand = qy.tank.command.AwardCommand

function LegionService:getMainData(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Legion.main",
        ["p"] = {}
    })):send(function(response,request)
        model:init(response.data)
        callback(response.data)
    end)
end

--[[--
    获取军团列表
--]]
function LegionService:getLegionList(params, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Legion.legion_list",
        ["p"] = params,
    })):send(function(response, request)
        model:initLegionList(response.data)
        callback(response.data)
    end)
end

--[[--
    创建军团
--]]
function LegionService:createLegion(_name,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Legion.create",
        ["p"] = {["name"] = _name}
    })):send(function(response, request)
        model:initMemberList(response.data)
        callback(response.data)
    end)
end

--[[--
    解散军团
--]]
function LegionService:dismissLegion(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Legion.dismiss",
        ["p"] = {}
    })):send(function(response, request)
        callback(response.data)
    end)
end

--[[--
    申请加入
--]]
function LegionService:apply(entity,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Legion.apply",
        ["p"] = {["id"] = entity.id}
    })):send(function(response, request)
        entity:updateCount(response.data.user_count)
        model:updateApplyList(response.data)
        callback(response.data)
    end)
end

--[[--
    取消申请加入
--]]
function LegionService:applyCancel(entity,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Legion.apply_cancel",
        ["p"] = {["id"] = entity.id}
    })):send(function(response, request)
        entity:updateCount(response.data.user_count)
        model:updateApplyList(response.data)
        callback(response.data)
    end)
end

--[[--
    成员列表
--]]
function LegionService:getMemberList(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Legion.member_list",
        ["p"] = {}
    })):send(function(response, request)
        model:initMemberList(response.data)
        callback(response.data)
    end)
end

--[[--
    审核列表
--]]
function LegionService:getApplyList(_lid, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Legion.apply_list",
        ["p"] = {["id"] = _lid}
    })):send(function(response, request)
        model:initApplyList(response.data)
        callback(response.data)
    end)
end

--[[--
    通过申请
--]]
function LegionService:applyAgree(_kid, onSuccess,onError,ioError)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Legion.apply_agree",
        ["p"] = {["id"] = _kid}
    })):send(function(response, request)
        model:removeApplyData(_kid)
        model:setMListHasRefresh(true)
        onSuccess(response.data)
    end,function()
        model:removeApplyData(_kid)
        onError()
    end,ioError)
end

--[[--
    拒绝申请
--]]
function LegionService:applyRefuse(_kid,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Legion.apply_refuse",
        ["p"] = {["id"] = _kid}
    })):send(function(response, request)
        model:removeApplyData(_kid)
        callback(response.data)
    end)
end

--[[--
    调职(司令，副司令，参谋长)
--]]
function LegionService:changeJob(params,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Legion.change_job",
        ["p"] = params,
    })):send(function(response, request)
        model:initMemberList(response.data)
        callback(response.data)
    end)
end

--[[--
    修改公告
--]]
function LegionService:setNotice(_str,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Legion.set_notice",
        ["p"] = {["notice"] = _str}
    })):send(function(response, request)
        model:updateNotice(_str)
        callback(response.data)
    end)
end

--[[--
    T人
--]]
function LegionService:kick(params,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Legion.kick",
        ["p"] = params,
    })):send(function(response, request)
        model:removeMemberEntity(params.id)
        callback(response.data)
    end)
end

--[[--
    一键拒绝
--]]
function LegionService:applyRefuseAuto(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Legion.apply_refuse_auto",
        ["p"] = {},
    })):send(function(response, request)
        model:clearApplist()
        callback(response.data)
    end)
end

--[[--
    升职
--]]
function LegionService:postPk(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Legion.pk_shengzhi",
        ["p"] = {},
    })):send(function(response, request)
        model:initMemberList(response.data)
        if response.data.fight_result then
            qy.tank.model.BattleModel:init(response.data.fight_result)
            model:setPostPkStatus(response.data.fight_result["end"]["is_win"])
        else
            model:setPostPkStatus(2)
        end
        callback(response.data)
    end)
end

--[[--
    离开
--]]
function LegionService:leave(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Legion.leave",
        ["p"] = {},
    })):send(function(response, request)
        model:initLegionList(response.data)
        callback(response.data)
    end)
end

----------俱乐部----------------------------------------------------------------
--[[--
    获得农场基本信息
--]]
function LegionService:getFarmMain(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Legion.farm_main",
        ["p"] = {},
    })):send(function(response, request)
        model:initFarmData(response.data)
        callback(response.data)
    end)
end

--[[--
    农场收获
--]]
function LegionService:getFarmGet(_tag,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Legion.farm_get",
        ["p"] = {["id"] = _tag},
    })):send(function(response, request)
        model:initFarmData(response.data)
        model:updateHisLegion(response.data)
        callback(response.data)
    end)
end

--[[--
    骰子基本信息
--]]
function LegionService:getDiceMain(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Legion.dice_main",
    })):send(function(response, request)
        model:initDiceData(response.data)
        callback(response.data)
    end)
end

--[[--
    摇骰子
--]]
function LegionService:getDiceBegin(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Legion.dice_begin",
        ["p"] = {},
    })):send(function(response, request)
        model:initDiceData(response.data)
        callback(response.data)
    end)
end

--[[--骰子领奖--]]
function LegionService:getDiceAward(i,callback)
    local ser_n = ""
    local _score = nil
    if i < 3 then
        ser_n = "Legion.dice_award"
        local aData = model:getDiceAward()
        _score = aData[i].score
    else
        ser_n = "Legion.dice_rank_award"
    end

    qy.Http.new(qy.Http.Request.new({
        ["m"] = ser_n,
        ["p"] = {["score"] = _score},
    })):send(function(response, request)
        AwardCommand:add(response.data.award)
        AwardCommand:show(response.data.award)
        model:updateDiceAward(i,true)
        callback(response.data)
    end)
end

--[[--
    金库基本信息
--]]
function LegionService:getBankMain(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Legion.bank_main",
    })):send(function(response, request)
        model:updateBankData(response.data)
        callback(response.data)
    end)
end

--[[--
    金库捐献
--]]
function LegionService:getBankGiving(_type, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Legion.bank_giving",
        --type:1 钻石 2：银币
        ["p"] = {["type"] = _type}
    })):send(function(response, request)
        model:updateBankData(response.data)
        callback(response.data)
    end)
end

--[[--金库领奖--]]
function LegionService:getBankAward(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Legion.bank_award",
        ["p"] = {},
    })):send(function(response, request)
        AwardCommand:add(response.data.award)
        AwardCommand:show(response.data.award)
        model:updateCommander({["is_have_get_award"] = true})
        callback(response.data)
    end)
end

--[[--宴会基本信息--]]
function LegionService:getPartyMain(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Legion.party_main",
        ["p"] = {},
    })):send(function(response, request)
        if response.data.award then
            model:updatePartyForBegin(response.data)
        else
            model:updatePartyData(response.data)
        end
        callback(response.data)
    end)
end

--[[--创建宴会--]]
function LegionService:createParty(_tag,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Legion.party_create",
        ["p"] = {["id"] = _tag},
    })):send(function(response, request)
        local userData = {}
        userData[1] = {
            ["kid"] = uModel.userInfoEntity.kid,
            ["name"] = uModel.userInfoEntity.name,
            ["level"] = uModel.userInfoEntity.level,
        }
        model:updatePartyData({
            ["in_party"] = true,
            ["master_id"] = uModel.userInfoEntity.kid,
            ["tag"] = _tag,
            ["user_list"] = userData,
        })
        callback(response.data)
    end)
end

--[[--取消宴会--]]
function LegionService:cancelParty(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Legion.party_cancel",
        ["p"] = {},
    })):send(function(response, request)
        model:updatePartyData(response.data)
        callback(response.data)
    end)
end

--[[--加入宴会--]]
function LegionService:joinParty(data,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Legion.party_join",
        ["p"] = {["id"] = data.master_id},
    })):send(function(response, request)
        model:updatePartyForJoin(response.data, true)
        callback(response.data)
    end)
end

--[[--退出宴会--]]
function LegionService:outParty(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Legion.party_out",
        ["p"] = {},
    })):send(function(response, request)
        model:updatePartyData(response.data)
        callback(response.data)
    end)
end

--[[--开始宴会--]]
function LegionService:beginParty(_type, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Legion.party_begin",
        ["p"] = {["type"] = _type},
    })):send(function(response, request)
        model:updatePartyForBegin(response.data)
        callback(response.data)
    end)
end

--[[--军团技能--]]
function LegionService:getSkillMain(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "legion.legion_skill",
    })):send(function(response, request)
        model:initSkillData(response.data)
        callback()
    end)
end

--[[--军团技能升级--]]
function LegionService:skillUpGrade(data,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "legion.up_legion_skill",
        ["p"] = data,
    })):send(function(response, request)
        model:updataSkillData(response.data)
        callback(response.data)
    end)
end

--[[--发送邮件--]]
function LegionService:sendLegionMail(data, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "legion.send_mail_all",
        ["p"] = data,
    })):send(function(response, request)
        callback(response.data)
    end)
end

--[[--改名--]]
function LegionService:changeName(name, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Legion.set_name",
        ["p"] = {["name"] = name},
    })):send(function(response, request)
        model:updatechangenum(response.data)
        callback(response.data)
    end)
end

return LegionService
