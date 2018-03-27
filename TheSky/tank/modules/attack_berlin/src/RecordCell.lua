local RecordCell = qy.class("RecordCell", qy.tank.view.BaseView, "attack_berlin.ui.RecordCell")


local model = qy.tank.model.AttackBerlinModel
local service = qy.tank.service.AttackBerlinService
function RecordCell:ctor(delegate)
   	RecordCell.super.ctor(self)
    self:InjectView("name")
    self:InjectView("level")
    self:InjectView("awardbg")
    self:InjectView("fenpeiBt")
    self:OnClick("fenpeiBt", function()
        local memid  =self.data[self.index].kid
        service:SendAward(delegate.award_id,memid,function (  )
        	delegate:callback()
        	if self.types == 3 then
        		qy.Event.dispatch(qy.Event.ATTACKBERLIN1)
        	end
        end)
    end,{["isScale"] = false})
   	self.types = delegate.types
   	self.data = delegate.data
   	-- print("================pppppp",json.encode(self.data))
end

function RecordCell:render(_idx)
	self.index = _idx
	self.awardbg:removeAllChildren(true)
	self.fenpeiBt:setVisible(self.types == 3)
	self.awardbg:setVisible(self.types == 1)
	self.name:setString(self.data[_idx].nickname)
	self.level:setString("LV."..self.data[_idx].level)
	if self.types == 1 then
		local award = self.data[_idx].awards
		for i=1,#award do
			local item = qy.tank.view.common.AwardItem.createAwardView(award[i] ,1)
	    	self.awardbg:addChild(item)
	    	item:setPosition(-60 + 90 * i, 43)
	    	item:setScale(0.7)
	    	item.fatherSprite:setSwallowTouches(false)
	   	 	item.name:setVisible(false)
		end
	end
end


return RecordCell
