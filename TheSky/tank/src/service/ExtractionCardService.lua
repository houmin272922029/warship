local ExtractionCardService = qy.class("ExtractionCardService", qy.tank.service.BaseService)

ExtractionCardService.model = qy.tank.model.ExtractionCardModel

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
function ExtractionCardService:getMainData(param, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "recruit.get",
        ["p"] = {}
    })):send(function(response, request)
        self.model:init(response.data)
        callback(response.data)
    end)
end


function ExtractionCardService:getCardsType1(param, callback)

    qy.Http.new(qy.Http.Request.new({
        ["m"] = "recruit.battlefield",
        ["p"] = param
    })):send(function(response, request)
        if response.data and (not response.data.is_max_num or response.data.is_max_num < 1) then
            self.model:update(response.data)
            qy.tank.model.RedDotModel:reduceExtCardFreeTimes("battlefield")
        end
        callback(response.data)
    end)

end

function ExtractionCardService:getCardsType2(param, callback)
    param["ftue"] = qy.GuideModel:getCurrentBigStep()

    qy.Http.new(qy.Http.Request.new({
        ["m"] = "recruit.reinforce",
        ["p"] = param
    })):send(function(response, request)
        print(response.data, "response.data")
        if response.data and (not response.data.is_max_num or response.data.is_max_num < 1) then
            self.model:update(response.data)
            qy.tank.model.RedDotModel:reduceExtCardFreeTimes("reinforce")
        end
        callback(response.data)
    end)

end

-- 获取奖励
function ExtractionCardService:getChievementAwards(param, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "recruit.getChievementAward",
        ["p"] = param
    })):send(function(response, request)
        self.model:update(response.data)
        -- qy.tank.model.RedDotModel:reduceExtCardFreeTimes("getChievementAward")
        callback(response.data)
    end)

end

return ExtractionCardService