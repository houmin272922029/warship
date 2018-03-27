--[[
	仓库服务
	Author: Aaron Wei
	Date: 2015-04-17 15:41:19
]]

local StorageService = qy.class("StorageService", qy.tank.service.BaseService)

StorageService.model = qy.tank.model.StorageModel

-- 获取仓库列表
function StorageService:getPropList(param, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "props.getPropsList",
        ["p"] = {}
    })):send(function(response, request)
        self.model:init(response.data.list)
        callback(response.data)
    end)
end

-- 出售道具
function StorageService:sell(id,num,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "props.sell",
        ["p"] = {["props_id"]=id,["num"]=num}
    })):send(function(response, request)
        -- self.model:update(response.data)
        if response.data then
            self.model:remove(tostring(id),num)
        end
        callback()
    end)
end

-- 使用道具
function StorageService:use(id,num,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "props.useprops",
        ["p"] = {["props_id"]=id,["num"]=num}
    })):send(function(response, request)
        -- self.model:update(response.data)
        -- self.model:remove(tostring(id),num)
        if response.data then
            self.model:remove(tostring(id),response.data.change)
            -- if response.data.recharge then
            --     qy.tank.model.UserInfoModel:updateRecharge(response.data.recharge)
            -- end
            qy.tank.command.AwardCommand:add(response.data.award)
            qy.tank.command.AwardCommand:show(response.data.award)
        end
        callback()
    end)
end
-- 使用道具改名卡
function StorageService:use3(id,num,name,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "props.useprops",
        ["p"] = {["props_id"]=id,["num"]=num,["nickname"] = name}
    })):send(function(response, request)
        if response.data then
            self.model:remove(tostring(id),response.data.change)
        end
        callback()
    end)
end


-- 使用道具
function StorageService:use2(id,num,select_id,callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "props.useprops",
        ["p"] = {["props_id"]=id,["num"]=num, ["select_id"]=select_id}
    })):send(function(response, request)
        -- self.model:update(response.data)
        -- self.model:remove(tostring(id),num)
        if response.data then
            self.model:remove(tostring(id),response.data.change)
            qy.tank.command.AwardCommand:add(response.data.award)
            qy.tank.command.AwardCommand:show(response.data.award)
        end
        callback()
    end)
end


return StorageService



