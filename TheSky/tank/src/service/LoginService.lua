--[[
    登陆请求服务
]]

local LoginService = qy.class("LoginService", qy.tank.service.BaseService)

local md5 = require("utils.Md5Util")

local userDefault = cc.UserDefault:getInstance()
local system_name = userDefault:getStringForKey("system_name", "")
local system_version = userDefault:getStringForKey("system_version", "")
local uuid = userDefault:getStringForKey("uuid", "")
local device_model = userDefault:getStringForKey("device_model", "")

-- 手机平台
local platform = device.platform == "mac" and "ios" or device.platform
-- 渠道
local channel = qy.tank.utils.SDK:channel()
-- 渠道编号
local channelCode = qy.tank.utils.SDK:channelCode()

local loginModel =  qy.tank.model.LoginModel

function LoginService:login(onSuccess,onError,ioError)
    qy.Analytics:onEvent({["name"] = "ENTER_GAME"})
    self.userInfo = qy.tank.model.UserInfoModel
    local playerInfoEntity = loginModel:getPlayerInfoEntity()
    qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.SCENE_LOADING)

    local Uid
    if qy.tank.utils.SDK:channel() == "xiongmaowan" then
        Uid = playerInfoEntity.platform_user_id
    else
        Uid = playerInfoEntity.platform_user_id_:get()
    end
    local _params = {
            ["platform"] = platform,
            ["channel"] = channel,
            ["d"] = channelCode,
            ["uid"] = Uid,
            ["s"] = loginModel:getLastDistrictEntity().index,
            ["sessionid"] = playerInfoEntity.session_token,
            ["sign"] = md5.sumhexa(playerInfoEntity.platform_user_id .. qy.LoginConfig.keyForMd5 .. playerInfoEntity.session_token),
            ["os"] = system_name,
            ["os_version"] = system_version,
            ["mac"] = uuid,
            ["phone_model"] = device_model,
            ["idfa"] = require("utils.Analytics"):getIDFA(),
            ["is_visitor"] = loginModel:getPlayerInfoEntity().is_visitor,
        }
    if qy.tank.utils.SDK:channel() == "huawei" then 
        local extra = ""
        local session_token 
        local loginModel =  qy.tank.model.LoginModel
        local playerInfoEntity = loginModel:getPlayerInfoEntity()
        if  playerInfoEntity ~=null then
            session_token = qy.json.decode(playerInfoEntity.session_token)
            local extratable = qy.TextUtil:StringSplit(session_token["gameAuthSign"],"\n",false,false)
            for i=1,table.nums(extratable) do
               extra = extra..extratable[i]
            end
            session_token["gameAuthSign"] = extra
            _params["extra"] =  session_token
        end
    end

    qy.Http.new(qy.Http.Request.new({
        ["m"] = "System.login",
        ["p"] = _params
    }))
    :setShowLoading(false)
    :send(function(response, request)
        qy.isAudit = response.data.isChecking
        qy.LoginConfig.setCid(response.data.cid)
        qy.LoginConfig.setSign(response.data.sign)

        ------------user.main(主接口数据迁移)--------------------------------
        qy.tank.model.VipModel:init()
        self.userInfo:init(response.data.main)
        qy.tank.model.StrongModel:init()
        qy.tank.model.StorageModel:init(response.data.main)
        qy.tank.model.MilitaryRankModel:init(response.data.main.militaryrank,function()end)
        if response.data.main.medal then
            qy.tank.model.MedalModel:init(response.data.main.medal)
        end
        --战地宴会
        qy.tank.model.FieldBanquetModel:setInitData(response.data.main)
        qy.tank.model.ServerExerciseModel:initatt(response.data.main.title)
        qy.tank.model.GarageModel:init(response.data.main)
        qy.tank.model.FightJapanGarageModel:init(response.data.main)
        qy.tank.model.EquipModel:init(response.data.main)
        qy.tank.model.BattleRoomModel:initList(response.data.main)
        qy.tank.model.RedDotModel:init(response.data)
        qy.tank.model.SupplyModel:init(response.data.main)
        qy.tank.model.TaskModel:updateTask(response.data.main.task)
        qy.tank.model.SoulModel:init(response.data.main.soul)
        qy.tank.model.PassengerModel:Maininit(response.data.main)
        qy.tank.model.LegionModel:initSkillData(response.data.main)
        qy.tank.model.LegionWarModel:setGuideInfo(response.data.main.legion_fight_is_guide)
        qy.tank.model.FittingsModel:init(response.data.main)
        if response.data.main.attack_berlin then
            qy.tank.model.AttackBerlinModel:init(response.data.main.attack_berlin)
        end
        if response.data.game then
            qy.tank.model.GodWorshipModel:initGame(response.data.game)
        else
            qy.tank.model.GodWorshipModel:initGame("s")
        end
        qy.tank.model.GodWarModel:init(response.data.main)
        qy.RedDotCommand:init()
        qy.tank.model.CampaignModel:init()
        qy.tank.model.GuideModel:initData(response.data)

        qy.tank.model.BattleRoomModel:initList(response.data.main)
        qy.tank.model.OperatingActivitiesModel:initList(response.data.main)
        qy.tank.model.Tank918Model:init(response.data.main)
        -- print("======================= " .. qy.json.encode(response.data.main))
        qy.tank.model.ActivityIconsModel:initList(response.data.main)
        loginModel:setBindAccountStatus(response.data.main.bind_award)
        qy.tank.model.AchievementModel:init()
        qy.tank.model.AchievementModel:update(response.data.main, true)
        qy.tank.model.AlloyModel:init(response.data.main.alloy)

        --跨服战
        qy.tank.model.ServiceWarModel:SetAllAwardsList(response.data.main)

        --黑名单
        qy.tank.model.BlackModel:init(response.data.main.blacklist)
        qy.tank.model.ServerFactionModel:init(response.data.main)


        -- 更新科技（
        if response.data.main.technology then
            local technologyList = {}
            technologyList.list = {}
            for id, technologyData in pairs(response.data.main.technology) do
                table.insert(technologyList.list,technologyData)
            end
            qy.tank.model.TechnologyModel:init(technologyList)
        end
        qy.tank.model.TechnologyModel:init2(response.data.main)

        -- 先测试放在这里

        -- 统计
        require("utils.Analytics"):setInfo({
            ["accountid"] = playerInfoEntity.platform_user_id,
            ["nickname"] = playerInfoEntity.nickname,
            ["sec"] = loginModel:getLastDistrictEntity().index,
            ["sec_name"] = loginModel:getLastDistrictEntity().s_name .. " " .. loginModel:getLastDistrictEntity().name,
            ["kid"] = self.userInfo.userInfoEntity.kid,
            ["username"] = self.userInfo.userInfoEntity.name,
            ["level"] = self.userInfo.userInfoEntity.level,
            ["notify_url"] = response.data.notify_url,
            ["viplevel"] = self.userInfo.userInfoEntity.vipLevel
        })
        -----------------------------------------

        --延时初始化
        qy.tank.utils.Timer.new(0.3,1,function()
            qy.tank.model.RechargeModel:init()
        end):start()

        onSuccess(response.data)
        -- local data = response.data
        -- qy.tank.model.UserInfoModel:setSessionId(data.ss.sid)
        -- qy.tank.model.UserInfoModel:setUserId(data.d._id)
        -- self:userGet(callFunc)
    end,onError,ioError)
end

--[[--
--获取服务器列表
--]]
function LoginService:getDistrictList(onSuccess,onError,ioError)
    local playInfo = loginModel:getPlayerInfo()
    local playerInfoEntity = loginModel:getPlayerInfoEntity()
    
    local huaweiflag = cc.UserDefault:getInstance():getStringForKey("huaweiflag", "0")
    -- print("huaweiflag===========",huaweiflag)
    if huaweiflag ~= "1" and qy.tank.utils.SDK:channel() == "huawei" then
        qy.hint:show("如无法登录游戏，请确保华为关联启动权限处于开启状态或重启手机尝试。")
        cc.UserDefault:getInstance():setStringForKey("huaweiflag", "1")
    end
    qy.Http.new(qy.Http.Request.new({
            ["m"] = "system.getServer",
            ["p"] = {
                ["channel"] = channel,
                ["d"] = channelCode,
                ["uid"] = loginModel:getDistrictParams().uid,
                ["sessionid"] = playInfo.token,
                ["mac"] = uuid,
                ["sign"] = md5.sumhexa(playerInfoEntity.platform_user_id .. qy.LoginConfig.keyForMd5 .. playerInfoEntity.session_token),
                ["is_visitor"] = loginModel:getPlayerInfoEntity().is_visitor
            }
        }))
        :setShowLoading(false)
        :send(function(response, request)
            local userinfo = response.data.userinfo
            if userinfo and userinfo.uid then
                playerInfoEntity.platform_user_id = userinfo.uid
            end
            if userinfo and userinfo.nickname then
                playerInfoEntity.nickname = userinfo.nickname
            end
            loginModel:initDistrictList(response.data)
            loginModel:setLastDistrict(response.data.last)
            onSuccess()
        end,onError,ioError)
end

function LoginService:getAnnounce()
    qy.Http
        .new(qy.Http.Request.new({["m"] = "system.getAnnounce"}))
        :setShowLoading(false)
        :send(function(response, request)
            qy.isAudit = response.data.isChecking
            qy.tank.model.MailModel:setNoticeList(response.data.announce)
        end)
end

function LoginService:getBindAccountAward(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "User.bind_award",
        ["p"] = {}
    })):send(function(response, request)
        qy.tank.command.AwardCommand:show(response.data.award)
        loginModel:setBindAccountStatus(1)
        callback(response.data)
    end)
end

--[[
    Facebook账号绑定
]]
function LoginService:bindFacebookAccount(onSuccess,onError,ioError)
    local playInfo = loginModel:getPlayerInfo()
    local playerInfoEntity = loginModel:getPlayerInfoEntity()
    local sdk = qy.tank.utils.SDK
    qy.Http.new(qy.Http.Request.new({
            ["m"] = "system.bindAccount",
            ["p"] = {
                ["channel"] = channel,
                ["d"] = channelCode,
                ["uid"] = sdk.loginData.uid,
                ["sessionid"] = sdk.loginData.token,
                ["mac"] = uuid,
                -- ["sign"] = md5.sumhexa(playerInfoEntity.platform_user_id .. qy.LoginConfig.keyForMd5 .. playerInfoEntity.session_token),
                ["sign"] = md5.sumhexa(uuid .. qy.LoginConfig.keyForMd5 .. uuid),
                ["is_visitor"] = loginModel:getPlayerInfoEntity().is_visitor
            }
        }))
        :setShowLoading(true)
        :send(function(response, request)
            -- LoginModel:saveRegisterData(response.data)
            -- LoginModel:saveAccountData(params)
            loginModel:updateVisitorStatus(2)

            -- local userinfo = response.data.userinfo
            -- if userinfo and userinfo.uid then
            --     playerInfoEntity.platform_user_id = userinfo.uid
            -- end
            -- if userinfo and userinfo.nickname then
            --     playerInfoEntity.nickname = userinfo.nickname
            -- end
            -- loginModel:initDistrictList(response.data)
            -- loginModel:setLastDistrict(response.data.last)
            onSuccess()
        end,onError,ioError)
end


-- 游戏评分
function LoginService:gameScore()
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "user.praise",
    }))
    :setShowLoading(false)
    :send(function(response, request)
    end)
end

return LoginService
