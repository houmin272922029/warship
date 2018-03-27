--[[
    关卡机制  场景实体
]]

local UpFundEntity = qy.class("UpFundEntity", qy.tank.entity.BaseEntity)

function UpFundEntity:ctor(data)
    self:setproperty("diamond", data.diamond)
    self:setproperty("level", data.level) --0 进行中 1 已完成 
    self:setproperty("title_icon", "s" .. data.title_icon or "s1")
    self:setproperty("status", 0)
end

function UpFundEntity:levelEnough()
	return self.level <= qy.tank.model.UserInfoModel.userInfoEntity.level
end

return UpFundEntity