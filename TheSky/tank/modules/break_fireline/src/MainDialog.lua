

local MainDialog = qy.class("MainDialog", qy.tank.view.BaseDialog, "break_fireline/ui/MainDialog")

local service = qy.tank.service.BreakFireService

function MainDialog:ctor(delegate)
    MainDialog.super.ctor(self)
    self.model = qy.tank.model.BreakFireModel
	self:InjectView("closeBt")
	self:InjectView("time")--时间pa
	self:InjectView("awardbg")
	self:InjectView("frame")
	self:InjectView("goBt")
	self:InjectView("nums")
	self:InjectView("getBt")
	self:InjectView("getawardbg")
	self:InjectView("goendBt")
    self:OnClick("goBt",function ( sender )
    	service:Goone(function (  )
    		self:updateframe()
    		self:updateaward()
    		self:choose()
    	end)
    end)
    self:OnClick("goendBt",function ( sender )
    	service:Goend(function (  )
    		self:updateframe()
    		self:updateaward()
    		self:choose()
    	end)
    end)
    self:OnClick("getBt",function ( sender )
    	if self.model.settup == 30 and self.endaward == 0 then
    		qy.hint:show("请选择最终奖励后领取")
    		return
    	end
    	service:getAward(self.endaward,function (  )
    		self:updateframe()
    		self:updateaward()
    		self:choose()
    		print("+++++++++++傻")
    	end)
    end)

	self:OnClick("closeBt", function(sender)
        self:removeSelf()
    end)
    self._effert = nil
    self.endaward = 0
   	self:initaward()
   	self:updateframe()
   	self:updateaward()

end
function MainDialog:choose(  )
	if self.model.settup == 30 then
		require("break_fireline.src.Tip").new({
            ["types"] = 3,
            ["callback"] = function ( index )
            self.endaward = index
            local data
		 	if types == 2 then
		       data = self.model.crossfire_random
		    else
		       data = self.model.crossfire_final
		    end
			self.getawardbg:removeAllChildren(true)
			local item = qy.tank.view.common.AwardItem.createAwardView(data[index].award[1] ,1)
			item:setScale(0.75)
			item.name:setVisible(false)
			item:setPosition(cc.p(45,45))
			self.getawardbg:addChild(item)
            end
        }):show()
	end 
end
function MainDialog:updateframe(  )
	self.endaward = 0
	if  self._effert == nil then
		print("===========吃")
		self._effert = ccs.Armature:create("Flame")
	    self._effert:setScale(0.8)
	    self.awardbg:addChild(self._effert,999)
	    self._effert:setPosition(10000,10000)
	    self._effert:getAnimation():playWithIndex(0)
	end
	self.nums:setString(self.model.totalnums)
	self.goBt:setTouchEnabled(self.model.totalnums ~= 0 and self.model.settup ~= 30)
    self.goBt:setBright(self.model.totalnums ~= 0 and self.model.settup ~= 30)
    self.getBt:setTouchEnabled(self.model.settup ~= 0 )
    self.getBt:setBright(self.model.settup ~= 0 )
    if  self.model.totalnums >= (30 - self.model.settup) and self.model.settup ~= 30 then
  		self.goendBt:setTouchEnabled(true)
    	self.goendBt:setBright(true)
    else
    	self.goendBt:setTouchEnabled(false)
    	self.goendBt:setBright(false)
    end
	if self.model.settup ~= 0 then
		self._effert:setPosition(self.model.inPosition[tostring(self.model.settup)])
	else
		self._effert:setPosition(cc.p(100000,100000))
	end
end
function MainDialog:initaward(  )
	local nums = table.nums(self.model.crosscfg)
	for i=1,nums do
		local types = self.model.crosscfg[tostring(i)].type
		local item 
		if types == 1 then
			item = qy.tank.view.common.AwardItem1.createAwardView(self.model.crosscfg[tostring(i)].award[1] ,1)
    		item.name:setVisible(false)
    --     	item = require("break_fireline.src.Commonitem").new({
    --     		["data"] = self.model.crosscfg[tostring(i)].award[1],
				-- ["types"] = types
				-- })
		else
			item = require("break_fireline.src.Awarditem").new({
				["num"] = i,
				["types"] = types,
				["callback"] = function ( index )
					print("==============",index)
					self.endaward = index
					local data
				 	if types == 2 then
				       data = self.model:getlist(i)
				    else
				       data = self.model.crossfire_final
				    end
					self.getawardbg:removeAllChildren(true)
					local item = qy.tank.view.common.AwardItem.createAwardView(data[index].award[1] ,1)
					item:setScale(0.75)
    				item.name:setVisible(false)
    				item:setPosition(cc.p(45,45))
    				self.getawardbg:addChild(item)
				end
				})
		end
		item:setPosition(self.model.inPosition[tostring(i)])
		self.awardbg:addChild(item)
	end
end
function MainDialog:updateaward(  )
	self.getawardbg:removeAllChildren(true)
	if self.model.settup ~= 0 then
		local types = self.model.crosscfg[tostring(self.model.settup)].type
		if types==1 then
			local data = self.model.crosscfg[tostring(self.model.settup)].award[1]
			local item = qy.tank.view.common.AwardItem.createAwardView(data ,1)
			item:setScale(0.75)
			item.name:setVisible(false)
			item:setPosition(cc.p(45,45))
			self.getawardbg:addChild(item)
		elseif types == 2 then
			local item = qy.tank.view.common.AwardItem.createAwardView(self.model.lattice[1] ,1)
			item:setScale(0.75)
			item.name:setVisible(false)
			item:setPosition(cc.p(45,45))
			self.getawardbg:addChild(item)
		end
	end
	
end

function MainDialog:onEnter()
	if self.model.endtime - qy.tank.model.UserInfoModel.serverTime <= 0 then
         self.time:setString("活动已结束")
    else
    	self.time:setString(qy.tank.utils.DateFormatUtil:toDateString(self.model.endtime - qy.tank.model.UserInfoModel.serverTime, 7))
    	self.listener_1 = qy.Event.add(qy.Event.BONUS_TIME,function(event)
        self.time:setString(qy.tank.utils.DateFormatUtil:toDateString(self.model.endtime - qy.tank.model.UserInfoModel.serverTime, 7))
    end)
    end
 
    
end

function MainDialog:onExit()
    qy.Event.remove(self.listener_1)
  
end


return MainDialog
