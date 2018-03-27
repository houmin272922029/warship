local SimpleCell = qy.class("SimpleCell", qy.tank.view.BaseView, "attack_berlin.ui.SimpleCell")


local model = qy.tank.model.AttackBerlinModel
local service = qy.tank.service.AttackBerlinService
function SimpleCell:ctor(delegate)
   	SimpleCell.super.ctor(self)
    self:InjectView("name")
    self:InjectView("AttackBt")
    self:InjectView("awardbg")
    self:InjectView("yijipo")
    self:InjectView("yicheli")
    self:InjectView("times")
   	self:OnClick("AttackBt", function()
       service:GeneralFight(self.data[self.index].copy_id,self.data[self.index].id,function (  )
         delegate:callback()
       end)
    end,{["isScale"] = false})
    self.data = delegate.data
end

function SimpleCell:render(_idx)
  self.index = _idx
	self.awardbg:removeAllChildren(true)
  local status = model:getGeneralstatus(self.data[_idx].id)
	self.yijipo:setVisible( status == "success")
	self.AttackBt:setVisible(status == "normal")
  self.yicheli:setVisible(status == "fail")
	self.name:setString(self.data[_idx].name)
  self.times:setString("剩余进攻次数："..model.complete_ids[_idx].last_can_attack_times)
	local award = self.data[_idx].award
	for i=1,#award do
		local item = qy.tank.view.common.AwardItem.createAwardView(award[i] ,1)
    	self.awardbg:addChild(item)
    	item:setPosition(80 + 100 * i, 50)
    	item:setScale(0.8)
    	item.fatherSprite:setSwallowTouches(false)
   	 	item.name:setVisible(false)
	end
	-- local items = require("attack_berlin.src.Awarditem").new({
 --          ["ids"] = self.data[_idx].award_id,
 --          ["types"] = 1,
 --    })
 --    self.awardbg:addChild(items)
 --    items:setPosition(80 + (#award+ 1) * 100,50)
    -- items:setScale(0.)
	
end


return SimpleCell
