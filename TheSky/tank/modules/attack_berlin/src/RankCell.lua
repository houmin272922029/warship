

local RankCell = qy.class("RankCell", qy.tank.view.BaseView, "attack_berlin.ui.RankCell")

local model = qy.tank.model.AttackBerlinModel
local service = qy.tank.service.AttackBerlinService
local moduleType = qy.tank.view.type.ModuleType

function RankCell:ctor(delegate)
   	RankCell.super.ctor(self)

    self:InjectView("rank")
   	self:InjectView("name")
   	self:InjectView("score")
    self:InjectView("fenpeiBt")
    
    self:OnClick("fenpeiBt", function()
        if model.slectid == 0 then
            qy.hint:show("暂无奖励可分配")
            return
        end
        local memid  = self.data[self.index].kid
        service:SendAward(model.total_awards[model.slectid].award_id,memid,function (  )
          delegate:callback()
          qy.Event.dispatch(qy.Event.ATTACKBERLIN1)
        end)

    end,{["isScale"] = false})
    self.data = delegate.data
end



function RankCell:render(_idx)
	self.index = _idx
	self.name:setString(self.data[_idx].nickname)
	self.rank:setString(_idx)
  self.score:setString(self.data[_idx].score)
  self.fenpeiBt:setVisible(self.data[_idx].is_can_send == 1 and model.is_leader == 1 )
end

return RankCell