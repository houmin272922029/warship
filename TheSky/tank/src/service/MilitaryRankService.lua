--军衔接口类

local MilitaryRankService = qy.class("MilitaryRankService", qy.tank.service.BaseService)

local model = qy.tank.model.MilitaryRankModel

function MilitaryRankService:init(callback)
	--入口
 	qy.Http.new(qy.Http.Request.new({
        ["m"] = "militaryrank.main",
    })):send(function(response, request)
        model:init(response.data,function()
            model:uplevel(2)
        	callback()
        end)
    end)
end
function MilitaryRankService:ReceiveSalary(callback )
	-- 领取薪资接口
	qy.Http.new(qy.Http.Request.new({
		["m"] = "militaryrank.getaward",
	})):send(function(response, request)
		qy.tank.command.AwardCommand:add(response.data.award)
		qy.tank.command.AwardCommand:show(response.data.award)
		callback(response.data)
	end)
end
function MilitaryRankService:uplevel(callback)
 	qy.Http.new(qy.Http.Request.new({
        ["m"] = "militaryrank.uplevel",
    })):send(function(response, request)
        model:init(response.data,function()
            model:uplevel(1)
        	callback(response.data)
        end)
    end)
end
function MilitaryRankService:uprank(callback)
 	qy.Http.new(qy.Http.Request.new({
        ["m"] = "militaryrank.uprank",
    })):send(function(response, request)
        model:init(response.data,function()
            model:uplevel(2)
        	callback(response.data)
        end)
        
    end)
end



return MilitaryRankService