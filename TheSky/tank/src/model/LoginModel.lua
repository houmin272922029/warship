--[[--
--登录 model
--Author: H.X.Sun
--Date: 2015-04-24
--]]

local LoginModel = qy.class("LoginModel", qy.tank.model.BaseModel)

function LoginModel:init()
    self:__getUserDefaultData()
    self.player = qy.tank.entity.PlayerInfoEntity.new()
    if self.userAccountData ~= nil and #self.userAccountData > 0 then
        self:saveAccountData(self.userAccountData[1])
    end
end

function LoginModel:__getUserDefaultData()
    local username = ""
    local password = ""
    self.userAccountData = {}
    for i = 1, 5 do
        username = cc.UserDefault:getInstance():getStringForKey("qiyo_username_" .. i, "")
        password = cc.UserDefault:getInstance():getStringForKey("qiyo_password_" .. i, "")
        if not (username == nil or username == "" or password == nil or password == "") then
            table.insert(self.userAccountData, {["username"] = username, ["password"] = password})
        end
    end
end

function LoginModel:getUserAccountData()
    return self.userAccountData
end

function LoginModel:saveUserDefaultData(data)
    if self.userAccountData == nil then
        self.userAccountData = {}
    end
    for i=1,#self.userAccountData do
        if tostring(self.userAccountData[i].username) == tostring(data.username) then
            table.remove(self.userAccountData, i)
            break
        end
    end
    table.insert(self.userAccountData,1, data)

    for i = 1, self:getUserAccountNun() do
        cc.UserDefault:getInstance():setStringForKey("qiyo_username_" .. i, self.userAccountData[i].username)
        cc.UserDefault:getInstance():setStringForKey("qiyo_password_" .. i, self.userAccountData[i].password)
    end
end

function LoginModel:getUserAccountNun()
    if #self.userAccountData > 5 then
        return 5
    else
        return #self.userAccountData
    end
end

function LoginModel:getPlayerInfoEntity()
    return self.player
end

function LoginModel:getPlayerInfo()
    local data = {}
    if self.player and self.player.platform_user_id_ then
        data.signInfo = self.player.platform_user_id_:get() .. qy.LoginConfig.keyForMd5 .. self.player.session_token_:get()
        data.token = self.player.session_token_:get()
    else
        data.signInfo = "0" .. qy.LoginConfig.keyForMd5
        data.token = ""
    end

    return data
end

function LoginModel:saveRegisterData(data)
    self.player:setRegisterData(data)
end

function LoginModel:saveAccountData(data)
    self.player:setAccountData(data)
    self:saveUserDefaultData(data)
end

function LoginModel:getDistrictParams()
    local data = {}
    if self.player and self.player.platform_user_id_ then
        data["uid"] = self.player.platform_user_id_:get()
    else
        data["uid"] = 0
    end
    return data
end

function LoginModel:initDistrictList(data)
    self.districtList = {}
    self.districtIndex = {}
    local entity = nil
    local index = ""
    for _, d in ipairs(data.list) do
        entity = qy.tank.entity.DistrictEntity.new(d)
        index = entity.index
        self.districtList[index] = entity
        table.insert(self.districtIndex, index)
    end
    self:setLastDistrict(data.last)
    -- for i = 1, #data.last do
    --     index = data.last[i]
    --     self.districtList[index]:setAccount()
    -- end
    -- if #data.last > 0 then
    --     self.lastDistrictIdx = data.last[1]
    -- else
    --     self.lastDistrictIdx = self.districtIndex[1]
    -- end
end

--[--获取服务详情--]
function LoginModel:getDistrictInfo()
    return self.districtList
end

function LoginModel:setLastDistrict(data)
    for i = 1, #data do
        index = data[i]
        self.districtList[index]:setAccount()
    end
    if #data > 0 then
        self.lastDistrictIdx = data[1]
    else
        for i = 1, #self.districtIndex do
            if self.districtList[self.districtIndex[i]]:isOpen() then

                self.lastDistrictIdx = self.districtIndex[i]
                return
            end
        end
        self.lastDistrictIdx = self.districtIndex[1]
    end
end

function LoginModel:getDistrictEntityByKey(_k)
    if _k > 0 and _k <= #self.districtIndex then
        local index = self.districtIndex[_k]
        return self.districtList[index]
    else
        return nil
    end
end

function LoginModel:getDistrictById(Id)
    return self.districtList[Id]
end

function LoginModel:getDistrictNun()
    return #self.districtIndex
end

function LoginModel:setLastDistrictIdx(_k)
    self.lastDistrictIdx = _k
end

function LoginModel:setCid(_cid)
    self.player:setCid(_cid)
end

--[[--
--获取最近登录服务器
--]]
function LoginModel:getLastDistrictEntity()
    if self.districtList then
        return self.districtList[self.lastDistrictIdx]
    else
        return nil
    end
end

function LoginModel:updateVisitorStatus(_status)
    cc.UserDefault:getInstance():setStringForKey("qiyo_visitor_", _status)
    self.player:updateVisitorStatus(_status)
end

function LoginModel:hasVistorAccount()
    local _status = tonumber(cc.UserDefault:getInstance():getStringForKey("qiyo_visitor_", ""))
    return _status == 1
end

function LoginModel:hasSDKAccount()
    local _status = tonumber(cc.UserDefault:getInstance():getStringForKey("qiyo_visitor_", ""))
    return _status == 2
end

function LoginModel:hasAccount()
    local _status = tonumber(cc.UserDefault:getInstance():getStringForKey("qiyo_visitor_", ""))
    return _status == 1 or _status == 2  
end

function LoginModel:emptyAccount()
    local _status = tonumber(cc.UserDefault:getInstance():getStringForKey("qiyo_visitor_", ""))
    return _status == 0
end

function LoginModel:updateNickName(_nickname)
    print("创建角色名字：" .. _nickname)
    self.player.nickname_:set(_nickname)
end

-- function LoginModel:getBindAccountAward()
--     local data = qy.Config.one_times_task["21"].award
--     return data
-- end

function LoginModel:setBindAccountStatus(data)
    if type(data) == "table" then
        self.bindAccountStatus = data.is_ok
    else
        self.bindAccountStatus = data
    end
end

function LoginModel:getBindAccountStatus()
    if self.bindAccountStatus then
        return self.bindAccountStatus
    else
        return 0
    end
end

return LoginModel
