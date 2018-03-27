

local SystemCell = qy.class("SystemCell", qy.tank.view.BaseView, "newyear_redpacket/ui/SystemCell")

function SystemCell:ctor(delegate)
    SystemCell.super.ctor(self)
	self:InjectView("name")
	self:InjectView("num")
	self:InjectView("lucky")
    self.data = delegate.data
    self.type = delegate.type
    self.flag = delegate.flag
 

end
function SystemCell:render(_idx)
   if _idx <= 3 then
    	self.num:setColor(cc.c3b(245, 139, 12))
    	self.name:setColor(cc.c3b(245, 139, 12))
    else
    	self.num:setColor(cc.c3b(255, 255, 255))
    	self.name:setColor(cc.c3b(255, 255, 255))
    end
    self.name:setString(self.data[_idx].name)
    self.num:setString(self.data[_idx].diamond)
    if self.type == 2 and self.flag then
	    if _idx == 1 then
	    	self.lucky:setVisible(true)
	    else
	    	if self.data[_idx].diamond == self.data[1].diamond then
	    		self.lucky:setVisible(true)
			else
				self.lucky:setVisible(false)
			end
	    end
    else
    	self.lucky:setVisible(false)
    end
    if self.data[_idx].ckid == qy.tank.model.UserInfoModel.kid then
        self.num:setColor(cc.c3b(0, 200, 12))
        self.name:setColor(cc.c3b(0, 200, 12))
    end

end
function SystemCell:onEnter()
     
end

function SystemCell:onExit()
  
end


return SystemCell
