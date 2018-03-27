--[[--
--服务器区entity
--Author: H.X.Sun
--Date: 2015-04-18
--]]
local DistrictEntity = qy.class("DistrictEntity", qy.tank.entity.BaseEntity)

function DistrictEntity:ctor(data)
	--名字 超级战神
	self:setproperty("name", data.name)
	--服务器 (1服)
	self:setproperty("s_name", data.s_name)
	--开服时间
	self:setproperty("start_t", data.start_t)
	--状态 1-即将开放,2-新服,3-火爆,4-维护
	self:setproperty("full", data.full)
	--服务器标识
	self:setproperty("index", data.index)
	--在这个服务器是是否有账号 1:有 0：没有
	self:setproperty("account", 0)

	self:setproperty("socket_host", data.socket_host)
	self:setproperty("socket_port", data.socket_port)
end

function DistrictEntity:isOpen()
	local _status = self.full
	if _status == 2 or _status == 3 then
		return true
	else
		return false
	end
end

function DistrictEntity:getStatusTxt()
	local _status = self.full
	if _status == 1 then
		--即将开放-黄色
		return qy.InternationalUtil:StatusTxt1()
	elseif _status == 2 then
		--新服-绿色
		return qy.InternationalUtil:StatusTxt2()
	elseif _status == 3 then
		--火爆-红色
		return qy.InternationalUtil:StatusTxt3()
	elseif _status == 4 then
		--维护-灰色
		return qy.InternationalUtil:StatusTxt4() 
	end
end

function DistrictEntity:getStatusColor()
	local _status = self.full
	if _status == 1 then
		--即将开放-黄色
		return cc.c4b(255, 211, 78,255)
	elseif _status == 2 then
		--新服-绿色
		return cc.c4b(33, 192, 76,255)
	elseif _status == 3 then
		--火爆-红色
		return cc.c4b(242, 48, 5,255)
	elseif _status == 4 then
		--维护-灰色
		return cc.c4b(123, 123, 123,255)
	end
end

function DistrictEntity:setAccount()
	self.account_:set(1)
end

function DistrictEntity:hasAccount()
	if self.account == 1 then
		return true
	else
		return false
	end
end

return DistrictEntity
