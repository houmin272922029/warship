--[[
    -- 评论
]]

local CommentEntity = qy.class("CommentEntity", qy.tank.entity.BaseEntity)

function CommentEntity:ctor(data)
    self:setproperty("id", data._id)
    self:setproperty("tankId", data.tank_id)
    self:setproperty("status", data.status)
    self:setproperty("comment", data.comment)
    self:setproperty("sec", data.sec)
    self:setproperty("sendId", data.send_id)
    self:setproperty("nickname", data.nickname)
    self:setproperty("niceNum", data.nice_num)
    self:setproperty("time", data.t)
end

function CommentEntity:update(data)
    if data.nice_num then
        self.niceNum = data.nice_num
    end
end

return CommentEntity