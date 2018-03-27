--[[
    酒馆实体
]]

local ServiceRankEntity = qy.class("ServiceRankEntity", qy.tank.entity.BaseEntity)

function ServiceRankEntity:ctor(data)
    self:setproperty("kid", data.kid)
    self:setproperty("nickname", data.nickname) --1 普通 2 至尊
    self:setproperty("servicename", data.servicename)
    self:setproperty("currentranking", data.currentranking)
    self:setproperty("is_bet", data.is_bet)
end

function ServiceRankEntity:update(data)
	if data.kid then
		self.kid = data.kid
	end

	if data.nickname then
		self.nickname = data.nickname
	end

	if data.servicename then
		self.servicename = data.servicename
	end

	if data.currentranking then
		self.currentranking = data.currentranking
	end

	if data.is_bet then
		self.is_bet = data.is_bet
	end
end

return ServiceRankEntity