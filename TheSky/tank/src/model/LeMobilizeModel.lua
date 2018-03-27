--[[--
    军团动员model
    Author: H.X.Sun
--]]

local LeMobilizeModel = qy.class("LeMobilizeModel", qy.tank.model.BaseModel)

local UserInfoModel = qy.tank.model.UserInfoModel
local NumberUtil = qy.tank.utils.NumberUtil

LeMobilizeModel.CAN_CREATE_JOIN = 1 --可发起/参加(没有参加过该类型的动员)
LeMobilizeModel.ONLY_JOIN = 2 --不能发起，只能参加(已存在该类型的更高品质)
LeMobilizeModel.NOT_CREATE_JOIN = 3 --不可发起/参加(已参加该类型)

LeMobilizeModel.REFRESH_TIPS_QUALITY = 5 --刷新会有提示的品质

function LeMobilizeModel:getMobiOpenLevel()
    local data = qy.Config.legion_open_gongneng["7"]
    return data.open_level
end

function LeMobilizeModel:init(data)
    self.mobiList = {}
    self.joinList = {}
    for _k, _v in pairs(data.list) do
        _v.unique_id = _k
        local entity = qy.tank.entity.LeMobilizeEntity.new(_v)
        table.insert(self.mobiList, entity)
        if entity:isJoin() then
            table.insert(self.joinList, entity.id)
        end
    end
    self:sort(self.mobiList)
    self:updateInitiate(data)
end

function LeMobilizeModel:updateForCreate(_new_id)
    local _sameTypeId = self:getSameTypeId()
    local entity = qy.tank.entity.LeMobilizeEntity.new({
        ["unique_id"] = 0,
        ["id"] = _new_id,
        ["name"] = UserInfoModel.userInfoEntity.name,
        ["status"] = 1,
        ["headicon"] = UserInfoModel.userInfoEntity.headicon,
    })
    table.insert(self.mobiList,1,entity)

    self:updateJoinId(_new_id)
end

function LeMobilizeModel:updateForJoin(_new_uid)
    -- local _sameTypeId = self:getSameTypeId()
    local _new_id = 0
    for i = 1, #self.mobiList do
        if self.mobiList[i].unique_id == _new_uid then
            self.mobiList[i].status = 1
            _new_id = self.mobiList[i].id
        end
    end
    if _new_id > 0 then
        self:updateJoinId(_new_id)
    end
    self:sort(self.mobiList)
end

function LeMobilizeModel:removeOneMobi(uid)
    for i = 1, #self.mobiList do
        if self.mobiList[i].unique_id == uid then
            table.remove(self.mobiList,i)
            break
        end
    end
end

function LeMobilizeModel:updateInitiate(data)
    if data.is_free ~= nil then
        self.is_free = data.is_free
    end
    -- self.join_id = data.join_id
    self.initiate = data.initiate
end

function LeMobilizeModel:hasRefreshTips()
    for i = 1, #self.initiate do
        if self:getConfigById(self.initiate[i]).quality >= self.REFRESH_TIPS_QUALITY then
            return true
        end
    end
    return false
end

--是否可以创建
function LeMobilizeModel:getCreateStatus(_id)
    local new_data = self:getConfigById(_id)
    if #self.joinList > 0 then
        for i = 1, #self.joinList do
            local old_data = self:getConfigById(self.joinList[i])
            if new_data.type == old_data.type then
                --如果已加入该类型动员，则不能再发起动员
                return self.NOT_CREATE_JOIN
            end
        end
    end

    for i = 1, #self.mobiList do
        if self.mobiList[1].status ~= 2 then
            local old_data = self:getConfigById(self.mobiList[i].id)
            if new_data.type == old_data.type then
                if new_data.quality > old_data.quality then
                    --如果新动员的品质高于已存在的动员，则可以发起
                    return self.CAN_CREATE_JOIN
                else
                    --如果不高于存在动员的品质，则只可以加入老动员
                    return self.ONLY_JOIN
                end
            end
        end
    end
    --如果不存在该类型的动员，则可以发起
    return self.CAN_CREATE_JOIN
end

--是否可以加入
function LeMobilizeModel:getJoinStatus(_id)
    local new_data = self:getConfigById(_id)
    if #self.joinList > 0 then
        for i = 1, #self.joinList do
            local old_data = self:getConfigById(self.joinList[i])
            if new_data.type == old_data.type then
                --如果已存在该类型动员，则不能再加入动员
                return self.NOT_CREATE_JOIN
            end
        end
    end

    return self.ONLY_JOIN
end

function LeMobilizeModel:updateJoinId(_new_id)
    table.insert(self.joinList,_new_id)
end

function LeMobilizeModel:getSameTypeId()
    if self.sameTypeId then
        return self.sameTypeId
    else
        return 0
    end
end

function LeMobilizeModel:isFree()
    return self.is_free
end

function LeMobilizeModel:getEntityByIdx(_idx)
    return self.mobiList[_idx]
end

function LeMobilizeModel:getConfigById(_id)
    local data = qy.Config.legion_sport[tostring(_id)]
    --等级升高后，乘以data.create_money的最高项（54000）的结果会大于1000万，通过getResNumString返回结果会返回字符串XXXXW，下面用%d时会报错
    -- data.create_silver = qy.InternationalUtil:getResNumString(UserInfoModel.userInfoEntity.level * data.create_money)
    -- data.join_silver = qy.InternationalUtil:getResNumString(UserInfoModel.userInfoEntity.level * data.join_money)
    data.create_silver = UserInfoModel.userInfoEntity.level * data.create_money
    data.join_silver = UserInfoModel.userInfoEntity.level * data.join_money
    return data
end

function LeMobilizeModel:getInitiateDataByIdx(_idx)
    if self.initiate[_idx] then
        local data = self:getConfigById(self.initiate[_idx])
        return data
    else
        return nil
    end
end

function LeMobilizeModel:sort(arr)
    table.sort(arr,function(a,b)
		if a.status == b.status then
            if a.quality == b.quality then
                return false
            else
                --品质高低
                return a.quality > b.quality
            end
		else
            -- 2:可领奖 > 1:进行中 > 0:可参与
			return a.status > b.status
		end
	end)
	return arr
end

function LeMobilizeModel:getListNum()
    return #self.mobiList
end

return LeMobilizeModel
