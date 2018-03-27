--[[
    玩家信息entity
    Author: H.X.Sun
    Date: 2015-07-09
]]
local PlayerInfoEntity = qy.class("PlayerInfoEntity", qy.tank.entity.BaseEntity)


function PlayerInfoEntity:ctor()
	--是否是游客 0:否 1：是
	self:setproperty("is_visitor", 0)
end

function PlayerInfoEntity:setRegisterData(data)
	print("PlayerInfoEntity:setRegisterData",data.nickname)
	self:setproperty("platform_user_id", data.platform_user_id)
	self:setproperty("session_token", data.session_token)
	self:setproperty("nickname", data.nickname)
	self.nickname = data.nickname
end

function PlayerInfoEntity:setAccountData(data)
	self:setproperty("password", data.password)
	self:setproperty("username", data.username) 
end

function PlayerInfoEntity:updateVisitorStatus(nType)
	self.is_visitor_:set(nType)
end

function PlayerInfoEntity:setCid(_cid)
	self:setproperty("cid", _cid)
end

return PlayerInfoEntity