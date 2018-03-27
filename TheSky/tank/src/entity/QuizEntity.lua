--[[
    -- 知识竞赛
    Date: 2016-06-21
]]

local QuizEntity = qy.class("QuizEntity", qy.tank.entity.BaseEntity)

function QuizEntity:ctor(data)
	self:setproperty("correct", data.correct)
	self:setproperty("question", data.question)
	self:setproperty("answer1", data.answer1)
	self:setproperty("answer2", data.answer2)
	self:setproperty("answer3", data.answer3)
	self:setproperty("id", data.id)
end

return QuizEntity