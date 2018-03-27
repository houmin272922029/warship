--[[--
--主角升级model
--Author: H.X.Sun
--Date: 2015-06-02
--]]--

local RoleUpgradeModel = qy.class("RoleUpgradeModel", qy.tank.model.BaseModel)

function RoleUpgradeModel:ctor()
end

local userModel = qy.tank.model.UserInfoModel
local loginModel = qy.tank.model.LoginModel
local StringUtil = qy.tank.utils.String
local ColorMapUtil = qy.tank.utils.ColorMapUtil

--[[--
--设置主角升级数据
--]]
function RoleUpgradeModel:setRoleUpgradeData(data)
    self.upgradeData = data.user_exp

    if #self.upgradeData.open_formation > 0 then
        qy.tank.model.GarageModel:openFormation(self.upgradeData.open_formation)
    end

    self.curRoleLevel = userModel.userInfoEntity.level
    self.lastEnergy = userModel.userInfoEntity.energy
    self.upgradeLevelNum = self.upgradeData.upgrade_level
    self.functionOpenData = self:getFunctionOpneData()
    self.awardData = {}

    for k, v in pairs(self.upgradeData.upgrade_level_list) do
        qy.tank.command.AwardCommand:add(self.upgradeData.upgrade_level_list[k].award)
        table.insert(self.awardData, self.upgradeData.upgrade_level_list[k].award)
    end

    if data.fight_result then
        --战斗升级，暂缓
        self:setRoleUpgrade(true)
    elseif data.award then
        if data.supply_num or data.strong_supply then
            --补给没有获得界面
            self:redirectRoleUpgrade()
        else
            print("RoleUpgradeModel:setRoleUpgrade================")
            --获得奖励（任务）
            self:setRoleUpgrade(true)
        end
    else
        self:redirectRoleUpgrade()
    end
    -- qy.RedDotCommand:initMainViewRedDot()
end

function RoleUpgradeModel:isRoleUpgrade()
    return self._hasUpgrade
end

function RoleUpgradeModel:setRoleUpgrade(flag)
    self._hasUpgrade = flag
end

--[[--
--获取功能描述
--]]
function RoleUpgradeModel:getFunctionInfo()
    return self.functionOpenData.introduce
end


--[[--
--主角升级
--]]
function RoleUpgradeModel:redirectRoleUpgrade()
    if self.upgradeLevelNum > 0 then
        -- self:findNextOpenData()
        self:updateUpgradeLevelNum()
        qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.ROLE_UPGRADE)
    elseif userModel.userInfoEntity.level == 14 then
        if loginModel:getPlayerInfoEntity().is_visitor == 1 then
            qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.BIND_ACCOUNT)
        end
    -- elseif not qy.isAudit and userModel.userInfoEntity.level == 30 and device.platform == "ios" and qy.product == "sina" then
        -- 30级-新浪-AppStore-不在审核模式-星级评价
        -- qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.SINA_APPSTORE_SCORE)
    else
        if self.functionOpenData then
            -- qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.FUNCTION_OPEN_TIP)
            qy.GuideManager:startTiggerGuide(self.functionOpenData[1])
        end
    end
end

--[[--
--更新升级等级数
--]]
function RoleUpgradeModel:updateUpgradeLevelNum()
    self.upgradeLevelNum = self.upgradeLevelNum - 1
end

--[[--
--获取提升的等级数
--]]
function RoleUpgradeModel:getUpgradeLevelNum()
    return self.upgradeLevelNum
end

--[[--
--更新升级前的等级
--]]
function RoleUpgradeModel:updateCurRoleLevel()
    self.curRoleLevel = self.curRoleLevel + 1
end

--[[--
--获取award
--]]
-- function RoleUpgradeModel:getUpgradeAward()
--     local award = self.awardData[1]
--     table.remove(self.awardData, 1)
--     return award
-- end

--[[--
--获取功能开启数据
--]]
function RoleUpgradeModel:getFunctionOpneData()
    for j =self.curRoleLevel + 1, self.curRoleLevel + self.upgradeLevelNum do
        local data = qy.GuideModel:getTriggerGuideData(j)
        if data then
            return data
        end
    end

    return nil
end

function RoleUpgradeModel:initFuncDataArr()
    local data = qy.Config.function_open
    self.funcDataArr = {}
    for _k, _v in pairs(data) do
        self.funcDataArr[_v["id"]] = _v
        self.funcDataArr[_v["id"]].desArr = self:getDescInfoByStr(_v.introduce2)
    end
    self.funcDataArr = self:sort(self.funcDataArr)
end

function RoleUpgradeModel:getOpenLevelByModule(_name)
    local data = qy.Config.function_open
    for _k, _v in pairs(data) do
        if data[_k].e_name == _name then
            return data[_k].open_level
        end
    end
    return 1
end
function RoleUpgradeModel:getOpenLevelById(id)
    local data = qy.Config.function_open
    for _k, _v in pairs(data) do
        if data[_k].id == id then
            return data[_k].open_level
        end
    end
    return 1
end
function RoleUpgradeModel:getOpenintroByModule(_name)
    local data = qy.Config.function_open
    for _k, _v in pairs(data) do
        if data[_k].e_name == _name then
            return data[_k].introduce
        end
    end
    return ""
end

function RoleUpgradeModel:sort(arr)
    table.sort(arr,function(a,b)
        if tonumber(a.open_level) == tonumber(b.open_level) then
            return false
        else
            -- 开启等级
            return tonumber(a.open_level) < tonumber(b.open_level)
        end
    end)
    return arr
end

function RoleUpgradeModel:getFuncDataArr()
    if self.funcDataArr == nil then
        self:initFuncDataArr()
    end
    return self.funcDataArr
end

function RoleUpgradeModel:getDescInfoByStr(_str)
    local infoArr = {}
    if _str == nil then
        return infoArr
    end

    local _arr = StringUtil.split(_str, "&")
    if _arr == nil or #_arr == 0 then
        return infoArr
    end

    infoArr.txt = {}
    infoArr.color = {}

    if #_arr == 1 then
        local _arr2 = StringUtil.split(_arr[1], "#")
        infoArr.txt[1] = _arr2[1]
        infoArr.color[1] = ColorMapUtil.qualityMapColorFor3b(tonumber(_arr2[2]) or 1)
    else
        for i = 1, #_arr do
            -- print("_arr _arr _arr _arr _arr===",_arr[i])
            local _arr2 = StringUtil.split(_arr[i], "#")
            -- print("_arr2 _arr2 _arr2 _arr2 _arr2===",qy.json.encode(_arr2))
            infoArr["txt"][i] = _arr2[1]
            infoArr["color"][i] = ColorMapUtil.qualityMapColorFor3b(tonumber(_arr2[2]) or 1)
            -- print("color color color color color=self==",qy.json.encode(infoArr.color[i-1]))
        end
    end

    return infoArr
end

function RoleUpgradeModel:findNextOpenData()
    if self.funcDataArr == nil then
        self:initFuncDataArr()
    end
    for i = 1, #self.funcDataArr do
            -- print("self.funcDataArr[i].open_level=====>>>>",self.funcDataArr[i].open_level)
        if userModel.userInfoEntity.level <= self.funcDataArr[i].open_level then
            -- print("userModel.userInfoEntity.level=====>>>>",userModel.userInfoEntity.level)
            return self.funcDataArr[i]
        end
    end

    return nil
end

return RoleUpgradeModel
