local CampaignService = qy.class("CampaignService", qy.tank.service.BaseService)

CampaignService.model = qy.tank.model.CampaignModel

--[[
local service = qy.tank.service.CampaignService
local param = {}
param["chapter_id"] = self.chapterData.chapterId

service:toBattle(param,function(data)
qy.hint:show("111 领取成功")
self.getBtn:setVisible(false)
self.hasGot:setVisible(true)
self.canNotGet:setVisible(false)
end)
]]

-- 主接口
function CampaignService:getMainData(param, callback)
    -- print("--------service start--------" , os.time())
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "checkpoint.get",
        ["p"] = {}
    })):send(function(response, request)
    -- print("--------service end--------" , os.time())
    -- print("--------model init start--------" , os.time())
        self.model:update(response.data)
    -- print("--------model init end--------" , os.time())
        callback(response.data)
    end)
end

function CampaignService:getMainDataNoLoding(param, callback)
    -- print("--------service start--------" , os.time())
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "checkpoint.get",
        ["p"] = {}
    }))
    :setShowLoading(false)
    :send(function(response, request)
    -- print("--------service end--------" , os.time())
    -- print("--------model init start--------" , os.time())
        self.model:update(response.data)
    -- print("--------model init end--------" , os.time())
        callback(response.data)
    end)
end

--章节奖励领取
function CampaignService:getChapterAward(param, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "checkpoint.drawChapterAward",
        ["p"] = param
    })):send(function(response, request)
        callback(response.data)
    end)
end

--场景奖励领取
function CampaignService:getSceneAward(param, callback)
    if qy.GuideModel:getCurrentBigStep() ~= 26 then
        param["ftue"] = qy.GuideModel:getCurrentBigStep()
    end

    qy.Http.new(qy.Http.Request.new({
        ["m"] = "checkpoint.drawSceneAward",
        ["p"] = param
    })):send(function(response, request)
        callback(response.data)
    end)
end

--扫荡
function CampaignService:autoFight(param, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "checkpoint.raids",
        ["p"] = param
    })):send(function(response, request)
        for i, v in pairs(response.data.list) do
            qy.tank.command.AwardCommand:add(v.award)
        end
    
        callback(response.data)
    end)
end

--通关战报列表
function CampaignService:passReport(param, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "checkpoint.videoList",
        ["p"] = param
    })):send(function(response, request)
        callback(response.data.list)
    end)
end

--单个通关战报明细
function CampaignService:passReportDetail(param, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "checkpoint.video",
        ["p"] = param
    })):send(function(response, request)
        callback(response.data)
    end)
end

--关卡战斗
function CampaignService:toBattle(param, callback)
    print("走的是普通战斗")
    param["ftue"] = qy.GuideModel:getCurrentBigStep()

    qy.Http.new(qy.Http.Request.new({
        ["m"] = "checkpoint.attack",
        ["p"] = param
    }))
    -- :setShowLoading(false)
    :send(function(response, request)
        if response.data.checkpoint and response.data.fight_result then
            qy.Analytics:onLevel("levelid" .. response.data.checkpoint.current, response.data.fight_result["end"]["is_win"])
        end
        self.model:update(response.data)
        callback(response.data)
    end)
end

-- 获取敌方战力
function CampaignService:getPower(param, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "checkpoint.getFightPower",
        ["p"] = {
            ["checkpoint_id"] = param.checkpointId
        }
    }))
    -- :setShowLoading(false)
    :send(function(response, request)
        callback(response.data)
    end)
end
--困难模式
--主接口
function CampaignService:getHardMainData(param, callback)
    -- print("--------service start--------" , os.time())
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "hardcheckpoint.get",
        ["p"] = {}
    }))
    :setShowLoading(false)
    :send(function(response, request)
        self.model:update2(1,response.data)
        callback(response.data)
    end)
end

--主接口2
function CampaignService:getHardMainData2(param, callback)
    -- print("--------service start--------" , os.time())
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "hardcheckpoint.get",
        ["p"] = {}
    })):send(function(response, request)
        callback(response.data)
    end)
end

--关卡战斗
function CampaignService:hardtoBattle(param, callback)
    print("走的是困难战斗",param.checkpoint_id)
    param["ftue"] = qy.GuideModel:getCurrentBigStep()

    qy.Http.new(qy.Http.Request.new({
        ["m"] = "hardcheckpoint.attack",
        ["p"] = {["checkpoint_id"] = param.checkpoint_id}
    }))
    -- :setShowLoading(false)
    :send(function(response, request)
        if response.data.checkpoint and response.data.fight_result then
            qy.Analytics:onLevel("levelid" .. response.data.checkpoint.current, response.data.fight_result["end"]["is_win"])
        end
        self.model:update2(2,response.data)
        callback(response.data)
    end)
end

--场景奖励领取
function CampaignService:gethardSceneAward(scene_id, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "hardcheckpoint.drawSceneAward",
        ["p"] = scene_id
    })):send(function(response, request)
        callback(response.data)
    end)
end

-- 获取敌方战力
function CampaignService:gethardPower(checkpointId, callback)
    print("困难获取的战斗力")
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "hardcheckpoint.getFightPower",
        ["p"] = {
            ["checkpoint_id"] = checkpointId
        }
    }))
    -- :setShowLoading(false)
    :send(function(response, request)
        callback(response.data)
    end)
end

--通关战报列表
function CampaignService:passhardReport(checkpoint_id, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "hardcheckpoint.videoList",
        ["p"] = {
            ["checkpoint_id"] = checkpoint_id
        }
    })):send(function(response, request)
        callback(response.data.list)
    end)
end

--单个通关战报明细
function CampaignService:passhardReportDetail(checkpoint_id, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "hardcheckpoint.video",
        ["p"] = checkpoint_id
    })):send(function(response, request)
        callback(response.data)
    end)
end

--扫荡
function CampaignService:hardautoFight(checkpoint_id,times, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "hardcheckpoint.raids",
        ["p"] = {
            ["checkpoint_id"] = checkpoint_id,
            ["times"] = times
        }
    })):send(function(response, request)
        for i, v in pairs(response.data.list) do
            qy.tank.command.AwardCommand:add(v.award)
        end
    
        callback(response.data)
    end)
end

--章节奖励领取
function CampaignService:gethardChapterAward(chapter_id, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "hardcheckpoint.drawChapterAward",
        ["p"] = {
            ["chapter_id"] = chapter_id
        }
    })):send(function(response, request)
        callback(response.data)
    end)
end

return CampaignService