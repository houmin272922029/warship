
--[[
    用户信息model
    addby lianyi
]]

local UserInfoModel = qy.class("UserInfoModel", qy.tank.model.BaseModel)

UserInfoModel.sid = nil -- sid
UserInfoModel.uid = nil -- sid
UserInfoModel.kid = nil -- sid
UserInfoModel.sound = true
UserInfoModel.effect = true
UserInfoModel.sec = false
UserInfoModel.isInFightJapan = false

UserInfoModel.pid = cc.UserDefault:getInstance():getStringForKey("uuid", "abcdefg")

local _vipModel = qy.tank.model.VipModel

function UserInfoModel:init(data)
    self.rechargeModel = qy.tank.model.RechargeModel
    self.uid = data.baseinfo.uid
    self.kid = data.baseinfo.kid
    local ud = cc.UserDefault:getInstance()
    ud:setIntegerForKey("tank_default_kid",self.kid)
    ud:flush()
    self.userInfoEntity = qy.tank.entity.UserInfoEntity.new(data)
    -- 更新充值数据
    if data.recharge then
        self.rechargeModel:updateRechargeInfo(data.recharge)
    end

    if self.timeListener == nil then
        self.timeListener = qy.Event.add(qy.Runtime.TIMER_UPDATE,function(event)
            self.serverTime = self.serverTime+ 1
            -- print("serverTime ===" .. self.serverTime)

            local _t = self.serverTime - self.userInfoEntity.energy_uptime
            -- print("距离下一次更新体力时间：" .. (240 -  _t % 240))

            if _t % 240 == 0 then
                print("现有体力："..self.userInfoEntity.energy_:get())
                print("当前等级拥有的体力上限："..self:getEnergyLimitByVipLevel())
                if self.userInfoEntity.energy_:get() < self:getEnergyLimitByVipLevel() then
                    local curEnery = self.userInfoEntity.energy_server + math.floor(_t / 240)
                    if curEnery > self:getEnergyLimitByVipLevel() then
                        --超过体力上限
                        self.userInfoEntity.energy_:set(self:getEnergyLimitByVipLevel())
                    else
                        --不超过体力上限
                        self.userInfoEntity.energy_:set(curEnery)
                    end
                    qy.Event.dispatch(qy.Event.CLIENT_ENERGY_UPDATE)
                end
            end

            --新手引导提交步骤逻辑：30秒一次
            qy.GuideModel:submitGuideStepLogic(self.serverTime)
            qy.Event.dispatch(qy.Event.RACING_TIME)
            qy.Event.dispatch(qy.Event.BONUS_TIME)
        end)
    end

    -- 世界boss消息
    local worldBossModel = qy.tank.model.WorldBossModel
    worldBossModel.boss_is_guide = data.boss_is_guide
    worldBossModel.time = data.constant.boss

    -- 军团boss消息
    local legionBossModel = qy.tank.model.LegionBossModel
    legionBossModel.boss_is_guide = data.legion_boss_is_guide
    legionBossModel.time = data.constant.legion_boss
end

function UserInfoModel:getRoleIcon()
    if self.userInfoEntity and self.userInfoEntity.headicon_ then
        return qy.tank.utils.UserResUtil.getRoleIconByHeadType(self.userInfoEntity.headicon_:get())
    else
        return "Resources/user/icon_head_1.png"
    end
end

function UserInfoModel:getRoleImg()
    if self.userInfoEntity and self.userInfoEntity.headicon_ then
        return qy.tank.utils.UserResUtil.getRoleImgByHeadType(self.userInfoEntity.headicon_:get())
    else
        return "Resources/user/img_head_1.png"
    end
end

--更新用户基本信息
function UserInfoModel:updateBaseInfo(baseInfo)
    if self.userInfoEntity == nil then
        print("UserInfoModel  －－  > userInfoEntity 还未初始化！")
    return end

    self.userInfoEntity:updateBaseInfo(baseInfo)
    qy.Event.dispatch(qy.Event.USER_BASE_INFO_DATA_UPDATE)
end

--更新资源信息
function UserInfoModel:updateResource(resource)
    print("updateResource====",qy.json.encode(resource))
    if self.userInfoEntity == nil then
        print("UserInfoModel  －－  > userInfoEntity 还未初始化！")
    return end

    self.userInfoEntity:updateResource(resource)
    qy.Event.dispatch(qy.Event.USER_RESOURCE_DATA_UPDATE)
end

--更新recharge相关
function UserInfoModel:updateRecharge(recharge)
    if self.userInfoEntity == nil then
        print("UserInfoModel  －－  > userInfoEntity 还未初始化！")
        return end

    self.userInfoEntity:updateRecharge(recharge)
    qy.Event.dispatch(qy.Event.USER_RECHARGE_DATA_UPDATE)
end

--更新服务器时间
function UserInfoModel:updateServerTime(serverTime)
    self.serverTime = serverTime
end

function UserInfoModel:setSessionId(sid)
    self.sid = sid
end

function UserInfoModel:getSessionId()
    return self.sid
end

function UserInfoModel:setUserArea(data)
    self.area = data
end

function UserInfoModel:setUserSec(sec)
    self.sec = sec
end

-- 设置用户最后一次登陆信息
function UserInfoModel:setUserLastLogin(data)
    cc.UserDefault:getInstance():setStringForKey("local_start", data.start)
    cc.UserDefault:getInstance():setStringForKey("local_title", data.title)
    cc.UserDefault:getInstance():setStringForKey("local_sec", data.sec)
    cc.UserDefault:getInstance():flush()
end

-- 设置用户声音信息
function UserInfoModel:setUserSound()
    self.sound = self.sound == false and true or false
    cc.UserDefault:getInstance():setBoolForKey("local_MusicOn", self.sound)
    cc.UserDefault:getInstance():flush()
    qy.M:setMusiceOn(self.sound)

    if self.sound then
        qy.M.playMusic("sound/s1.mp3")
    end
end

function UserInfoModel:setUserId(uid)
    self.uid = uid
end

--[[--
--根据指挥官等级获得坦克等级上限
--@param #number nLevel 用户等级，nil时默认为当前用户等级
--]]
function UserInfoModel:getMaxTankLevelByUserLevel(nLevel)
    if nLevel then
        return nLevel
    else
        return self.userInfoEntity.level
    end
end

--[[--
--根据指挥官等级获得装备强化上限
--@param #number nLevel 用户等级，nil时默认为当前用户等级
--]]
function UserInfoModel:getMaxEquipLevelByUserLevel(nLevel)
    if nLevel then
        return nLevel * 2
    else
        return self.userInfoEntity.level * 2
    end
end

function UserInfoModel:updateUserInfo(data)
     --清除之前更新的数据纪录
    self:clearUpdateResourceType()

    -- 更新用户基础数据
    if data.baseinfo then
        self:updateBaseInfo(data.baseinfo)
    end

    -- 更新充值数据
    if data.recharge then
        self:updateRecharge(data.recharge)
        self.rechargeModel:updateRechargeInfo(data.recharge)
    end

    -- 更新资源数据
    if data.resource then
        self:updateResource(data.resource)
    end
end

--[[--
--根据指挥官等级获得科技强化上限
--@param #number nLevel 用户等级，nil时默认为当前用户等级
--]]
function UserInfoModel:getMaxTechnologyLevelByUserLevel(nLevel)
    if nLevel then
        return nLevel
    else
        return self.userInfoEntity.level
    end
end

function UserInfoModel:clearUpdateResourceType()
    self.addResourceType = {}
    self.subtractResourceType = {}
end

--[[--
--增加的资源
--]]
function UserInfoModel:getAddResourceType()
    return self.addResourceType
end

--[[--
--减少
--]]
function UserInfoModel:getSubtractResourceType()
    return self.subtractResourceType
end

--[[--
--升到下一级需要的经验数
--]]
function UserInfoModel:toNextLevelNeedExp(_curLevel)
    if _curLevel == nil then
        _curLevel = self.userInfoEntity.level
    end
    if qy.Config.level[tostring(_curLevel)] then
        return qy.Config.level[tostring(_curLevel)].exp
    else
        return 0
    end
end

--[[--
    当前经验在这等级的百分比
--]]
function UserInfoModel:getUserExpPercent()
    local _curExp = self.userInfoEntity.exp
    return  math.floor(_curExp/self:toNextLevelNeedExp() * 1000 + 0.5) / 10
end

--[[--
    根据vip等级获得体力上限，_curLevel为nil，则获取当前VIP的体力
--]]
function UserInfoModel:getEnergyLimitByVipLevel(_curVip)
    if _curVip == nil then
        _curVip = self.userInfoEntity.vipLevel
    end

    return _vipModel:getEnergyLimitByVipLevel(_curVip)
end

--[[
    开发服，选择后端的分支名字
]]--
function UserInfoModel:setDevelopBranch(_branch)
    self.hasSetBranch = true
    qy.SERVER_VERSION = _branch
    qy.tank.utils.Http.seturl()
end

function UserInfoModel:isSetDevelopBranch()
    return self.hasSetBranch
end

return UserInfoModel
