--[[
    成就服务
    Author: Your Name
    Date: 2015-05-26 16:12:18
]]

local AchievementService = qy.class("AchievementService", qy.tank.service.BaseService)

-- 获取图鉴、成就列表
function AchievementService:getList(callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "User.handbook",
        -- ["p"] = {["pid"] = pid}
    })):send(function(response, request)
        -- qy.tank.model.AchievementModel:update(response.data)
        -- qy.tank.model.ArenaModel:init(response.data)
        callback()
    end)
end

-- 升级成就属性
function AchievementService:upgrade(entity, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "User.achieve_up",
        ["p"] = {
            ["achieve_id"] = entity.id,
        }
    })):send(function(response, request)    
        entity.level = response.data.star
        qy.tank.model.AchievementModel:update(response.data)
        -- qy.hint:show("战斗力增加 + " .. response.data.add_fight_power)
        qy.Event.dispatch(qy.Event.SCENE_TRANSITION_HIDE)
        qy.Event.dispatch(qy.Event.ACHIEVEMENT_RESCOURES_CHANGE)
        -- qy.tank.model.ArenaModel:init(response.data)
        callback(response.data)
    end)
end

-- 发表评论
function AchievementService:addComment(id, content, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "User.handbook_comment",
        ["p"] = {
            ["tank_id"] = id,
            ["comment"] = content,
        }
    })):send(function(response, request)
        -- -- qy.tank.model.AchievementModel:update(response.data)
        qy.hint:show(qy.TextUtil:substitute(1045))
        callback(response.data)
    end)
end

-- 评论列表
function AchievementService:getCommentList(tank_id, callback, page, entity)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "User.comment_list",
        ["p"] = {
            ["tank_id"] = tank_id,
            ["page"] = page
        }
    })):send(function(response, request)
        qy.tank.model.AchievementModel:updateComment(response.data, entity)
        callback()
    end)
end

-- 点赞 user.handbook_nice
function AchievementService:addNice(entity, callback)
    qy.Http.new(qy.Http.Request.new({
        ["m"] = "User.handbook_nice",
        ["p"] = {
            ["id"] = entity.id,
        }
    })):send(function(response, request)
        entity.niceNum = entity.niceNum + 1
        callback()
    end)
end

return AchievementService