

local HistoryCell = qy.class("HistoryCell", qy.tank.view.BaseView, "newyear_redpacket/ui/HistoryCell")

function HistoryCell:ctor(delegate)
    HistoryCell.super.ctor(self)
	self:InjectView("name")
	self:InjectView("time")--领取时间
	self:InjectView("num")
    self:InjectView("type")--红包类型
 	self.types = delegate.value--1是已收到2是已发出
 	self.data = delegate.data
 

end
function HistoryCell:render(_idx)
	-- print("----------------",_idx)
	if self.types == 1 then
		self.name:setString(self.data[_idx].rsname)
		if self.data[_idx].rtype == 1 then
			self.type:setString("定额红包")
		elseif self.data[_idx].rtype == 2 then
			self.type:setString("拼手气红包")
		else
			self.type:setString("幸运红包")
		end
		
	else
		if self.data[_idx].type == 1 then
			self.name:setString("定额红包")
		elseif self.data[_idx].type == 2 then
			self.name:setString("拼手气红包")
		else
			self.name:setString("幸运红包")
		end
		self.type:setString(self.data[_idx].canyu)
	end
	self.time:setString(self:times(self.data[_idx].rtime))
	self.num:setString(self.data[_idx].rdiamond)
     
end
function HistoryCell:times( str )
	-- body
	local data = os.date("*t",str)
	return data.year.."-"..data.month.."-"..data.day
end
function HistoryCell:onEnter()
     
end

function HistoryCell:onExit()
  
end


return HistoryCell
