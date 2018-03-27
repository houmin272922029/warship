

--新年红包里的压岁红包实体


local RedPacketEntity = qy.class("RedPacketEntity", qy.tank.entity.BaseEntity)

function RedPacketEntity:ctor(data)
	self:setproperty("content", data.content)
	self:setproperty("id", data.id)
	self:setproperty("status", data.status)
	self:setproperty("type", data.type)
	self:setproperty("name", data.name)
	self:setproperty("total", data.total)
	self:setproperty("share_diamond",data.share_diamond)
	self:setproperty("headicon",data.headicon)

end

return RedPacketEntity