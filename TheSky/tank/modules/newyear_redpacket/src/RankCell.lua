

local RankCell = qy.class("RankCell", qy.tank.view.BaseView, "newyear_redpacket/ui/RankCell")

local model = qy.tank.model.RedPacketModel

function RankCell:ctor(delegate)
    RankCell.super.ctor(self)
	self:InjectView("name")
	self:InjectView("num")
    self:InjectView("rank")
    self:InjectView("awardnum")
    self.data = delegate.data

end
function RankCell:render(_idx)
    if _idx <= 3 then
    	self.num:setColor(cc.c3b(245, 139, 12))
    	self.name:setColor(cc.c3b(245, 139, 12))
    	self.rank:setColor(cc.c3b(245, 139, 12))
    	self.awardnum:setColor(cc.c3b(245, 139, 12))
    else
    	self.num:setColor(cc.c3b(255, 255, 255))
    	self.name:setColor(cc.c3b(255, 255, 255))
    	self.rank:setColor(cc.c3b(255, 255, 255))
    	self.awardnum:setColor(cc.c3b(255, 255, 255))
    end
    self.rank:setString(_idx)
    self.awardnum:setString(model.rankcfg[tostring(_idx)].award[1].num)
    self.name:setString(self.data[_idx].nickname)
    self.num:setString(self.data[_idx].share)
    if self.data[_idx].kid == qy.tank.model.UserInfoModel.kid then
        self.num:setColor(cc.c3b(0, 200, 12))
        self.name:setColor(cc.c3b(0, 200, 12))
        self.rank:setColor(cc.c3b(0, 200, 12))
        self.awardnum:setColor(cc.c3b(0, 200, 12))
    end
end
function RankCell:onEnter()
     
end

function RankCell:onExit()
  
end


return RankCell
