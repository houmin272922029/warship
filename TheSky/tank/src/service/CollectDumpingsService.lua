--[[
	
	Author: 
]]

local CollectDumpingsService = qy.class("CollectDumpingsService", qy.tank.service.BaseService)

local model = qy.tank.model.CollectDumpingsModel
local StorageModel = qy.tank.model.StorageModel


function CollectDumpingsService:Attack(id,propid, callback)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "Activity.getaward",
       ["p"] = {["activity_name"] = "collect_dumplings", ["type"] = "a", ["id"] = id}
    })):send(function(response, request)
        if response.data.fight_result then
            qy.tank.model.BattleModel:init(response.data.fight_result)
            qy.tank.manager.ScenesManager:pushBattleScene()
        end
        if response.data.award then
          qy.tank.command.AwardCommand:add(response.data.award)
        end
        if response.data.list then
          model:updatelist(id,response.data.list)
        end
        if response.data.props then
          self:updatenums(propid,response.data.props)
        end
        callback()
    end)
end
function CollectDumpingsService:saodang( times,id,propid,callback )
  qy.Http.new(qy.Http.Request.new({
       ["m"] = "Activity.getaward",
       ["p"] = {["activity_name"] = "collect_dumplings", ["type"] = "s", ["id"] = id,["times"] = times}
    })):send(function(response, request)
        if response.data.award then
          qy.tank.command.AwardCommand:add(response.data.award)
          qy.tank.command.AwardCommand:show(response.data.award)
        end
        if response.data.list then
          model:updatelist(id,response.data.list)
        end
        if response.data.props then
          self:updatenums(propid,response.data.props)
        end
        callback()
    end)
end
function CollectDumpingsService:updatenums( propid,data )
    local Num1 = StorageModel:getPropNumByID(propid)
    if Num1 ~= 0 then
      local Num1_1 = 0
      if data[tostring(propid)] then
          Num1_1 = data[tostring(propid)].num
      end
      StorageModel:remove(tostring(propid),Num1-Num1_1)
    end
end


function CollectDumpingsService:buyProp( id ,num,callback )
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "Activity.getaward",
       ["p"] = {["activity_name"] = "collect_dumplings", ["type"] = "b", ["id"] = id, ["times"] = num}
    })):send(function(response, request)
            qy.tank.command.AwardCommand:add(response.data.award)
            qy.tank.command.AwardCommand:show(response.data.award)
        callback()
    end)
end
function CollectDumpingsService:exchange( id ,callback )
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "Activity.getaward",
       ["p"] = {["activity_name"] = "collect_dumplings", ["type"] = "e", ["id"] = id}
    })):send(function(response, request)
          qy.tank.command.AwardCommand:add(response.data.award)
          qy.tank.command.AwardCommand:show(response.data.award)
          if response.data.props then
              self:updatenums2(id,response.data.props)
          end
        callback()
    end)
end
function CollectDumpingsService:updatenums2(id, data )
    local need = model.shoplist[tostring(id)].award_need
    for k,v in pairs(need) do
        local id = v.id
        local num2 = v.num
        StorageModel:remove(tostring(id),num2)
    end
end


return CollectDumpingsService



