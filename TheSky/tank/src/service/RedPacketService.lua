--[[
	
	Author: 
	Date: 2016年07月13日15:08:24
]]

local RedPacketService = qy.class("RedPacketService", qy.tank.service.BaseService)

local model = qy.tank.model.RedPacketModel
-- 获取
function RedPacketService:get(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "Activity.getInfo",
        ["p"] = {["activity_name"] = "red_packet"}
    })):send(function(response, request)
        model:init(response.data)
        callback(response.data)
    end)
end


function RedPacketService:getAward(id,op,callback)
    local param = {}
    param.activity_name = "red_packet"
    param.op = op
    param.id =  id
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "Activity.getaward",
       ["p"] = param
    })):send(function(response, request)
        if op == "p" then
            model:initRankList(response.data)
        end
        qy.tank.command.AwardCommand:add(response.data.award)
        qy.tank.command.AwardCommand:show(response.data.award)
        callback(response.data)
    end)
end
function RedPacketService:shuaxin( range,op,callback )
    local param = {}
    param.activity_name = "red_packet"
    param.op = op
    param.range =  range
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "Activity.getaward",
       ["p"] = param
    })):send(function(response, request)
        model:update(response.data,range)
        callback(response.data)
    end)
end
function RedPacketService:openredpacket( range,type,red_id,callback )
    local param = {}
    param.activity_name = "red_packet"
    param.op = "c"
    param.range =  range
    param.red_id = red_id
    param.type = type
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "Activity.getaward",
       ["p"] = param
    })):send(function(response, request)
    if response.data.add_diamond ~= 0 and response.data.add_diamond ~= nil then
        local award = {}
        award.num = response.data.add_diamond
        award.type = 1
        award.id = 0
        local aa = {}
        table.insert(aa,award)
        print(json.encode(award))
        qy.tank.command.AwardCommand:add(aa)
        qy.tank.command.AwardCommand:show(aa)
    end
        callback(response.data)
    end)
end
function RedPacketService:openluckyredpacket( range,type,red_id,cost,callback )
    local param = {}
    param.activity_name = "red_packet"
    param.op = "c"
    param.range =  range
    param.red_id = red_id
    param.type = 3
    param.cost = cost
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "Activity.getaward",
       ["p"] = param
    })):send(function(response, request)
    if response.data.add_diamond ~= 0 and response.data.add_diamond ~= nil then
        local award = {}
        award.num = response.data.add_diamond
        award.type = 1
        award.id = 0
        local aa = {}
        table.insert(aa,award)
        print(json.encode(award))
        qy.tank.command.AwardCommand:add(aa)
        qy.tank.command.AwardCommand:show(aa)
    end
        callback(response.data)
    end)
end
function RedPacketService:fahongbao( range,type,content,total,copies,callback )
    local param = {}
    param.activity_name = "red_packet"
    param.op = "f"
    param.range = range
    param.type = type
    param.copies = copies
    param.total = total
    param.content = content
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "Activity.getaward",
       ["p"] = param
    })):send(function(response, request)
        model:update(response.data,range)
        callback(response.data)
    end)
end

function RedPacketService:getRankAward( callback )
    local param = {}
    param.activity_name = "red_packet"
    param.op = "p"
    param.id =  1
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "Activity.getaward",
       ["p"] = param
    })):send(function(response, request)
        qy.tank.command.AwardCommand:add(response.data.award)
        qy.tank.command.AwardCommand:show(response.data.award)
        callback(response.data)
    end)
end

function RedPacketService:getRankList(op,page,callback)
    qy.Http.new(qy.Http.Request.new({
       ["m"] = "Activity.getaward",
       ["p"] = {["activity_name"] = "red_packet", ["op"] = op, ["page"] = page}
    })):send(function(response, request)
       callback(response.data)
    end)
end




return RedPacketService



