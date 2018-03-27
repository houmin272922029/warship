local RankItem = qy.class("RankItem", qy.tank.view.BaseView, "earth_soul.ui.RankItem")

local model = qy.tank.model.OperatingActivitiesModel
local service = qy.tank.service.OperatingActivitiesService
function RankItem:ctor(delegate)
   	RankItem.super.ctor(self)
    -- self:InjectView("Day")
    self:InjectView("Rank")
    self:InjectView("Name")
    self:InjectView("Num")
    self:InjectView("Soul_num")
end

function RankItem:setData(data, idx)
    -- local staticData = qy.Config.earth_soul_rank
    local data2 = model.earthSoulRanklist[idx + 1]
    if data2 then
        self.Name:setString(data2.nickname)
        self.Num:setString(data2.times)
        
        
    else
        self.Name:setString(qy.TextUtil:substitute(45008))
        self.Num:setString(0)
    end
    self.Rank:setString(data.rank)
    self.Soul_num:setString(data.award[1].num)

    local color = (data2 and qy.tank.model.UserInfoModel.userInfoEntity.kid == data2.kid) and cc.c3b(42, 255, 72) or cc.c3b(255, 255, 255)
    self.Name:setTextColor(color)
    self.Rank:setTextColor(color)
    self.Num:setTextColor(color)
    self.Soul_num:setTextColor(color)
end

return RankItem
