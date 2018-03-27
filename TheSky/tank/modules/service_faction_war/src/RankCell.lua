

local RankCell = qy.class("RankCell", qy.tank.view.BaseView, "service_faction_war/ui/RankCell")

local model = qy.tank.model.ServerFactionModel
local service = qy.tank.service.ServerFactionService

function RankCell:ctor(delegate)
    RankCell.super.ctor(self)
    self.delegate = delegate
    self:InjectView("icon")
    self:InjectView("rank")
    self:InjectView("name")
    self:InjectView("score")
    
end

function RankCell:render(idx,data)
	self.name:setString(data.nickname)
	local level  = data.level
	local aa = model:getlevelByid(level)
	self.rank:setString(aa.name)
	self.score:setString("阵营贡献："..data.contribution)
	local png = "Resources/user/icon_"..data.headicon..".png"
	self.icon:setTexture(png)
end


return RankCell
