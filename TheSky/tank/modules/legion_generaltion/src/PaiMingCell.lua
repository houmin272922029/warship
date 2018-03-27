--[[--
    
--]]--

local PaiMingCell = qy.class("PaiMingCell", qy.tank.view.BaseView, "legion_generaltion/ui/PaiMingCell")

function PaiMingCell:ctor(delegate)
    PaiMingCell.super.ctor(self)
    self.model = qy.tank.model.LegionGeneraltionModel
    self.service = qy.tank.service.LegionGeneraltionService
    self:InjectView("toReceiveBtn")
    self:InjectView("hasReceive")
    self:InjectView("Image_1")
    self:InjectView("name")
    self:InjectView("jifen")
    self:InjectView("mingci")

    local activity = qy.tank.view.type.ModuleType



end

function PaiMingCell:render(idx,data)
        
    local da = nil
    local daward = nil
    if data.mIndexShop == 1 then
        da = self.model.muser_rank[idx]
        da.name = da.nickname
        daward = self.model.PersonalRank[idx]
    else
        da = self.model.mlegion_rank[idx]
        da.name = da.legion_name
        daward = self.model.legionRank[idx]
    end


    self.name:setString(da.name)
    self.jifen:setString(da.hurt)
    self.mingci:setString(da.rank)

    
    if self.awardList then
        self:removeChild(self.awardList)
    end
    self.awardList = qy.AwardList.new({
        ["award"] = daward.award,
        ["itemSize"] = 3,
        ["len"] = 1, 
        ["type"] = 1,
        ["cellSize"] = cc.size(110,90)
    })
    self.awardList:setPosition(660,150)
    self:addChild(self.awardList)

 

end

return PaiMingCell