--[[--
--矿区scene
--Author: H.X.Sun
--Date: 2015-05-25
--]]--

local MineScene = qy.class("MineScene", qy.tank.view.BaseView)

function MineScene:ctor(delegate)
    MineScene.super.ctor(self)

	self.children = {}
end

function MineScene:pushView(view)
	table.insert(self.children, view )
	self:updateCurrentView()
end

function MineScene:popView(view)
	for i = 1, # self.children do
		if view == self.children[i] then
			table.remove(self.children, i)
			break
		end
	end
	self:updateCurrentView()
end

function MineScene:onEnter()
	self.moduleType = qy.tank.view.type.ModuleType
	--更新矿区时间
	self.timeListener = qy.Event.add(qy.Runtime.TIMER_UPDATE,function(event)
            	if self.currentView then
            		self.currentView:updateMineTime()
            	end
        	end)
	--更新矿区用户资源
	self.userResourceDatalistener = qy.Event.add(qy.Event.USER_RESOURCE_DATA_UPDATE,function(event)
		if self.currentView then
			self.currentView:updateResource()
		end
	end)
	--更新用户油料
	self.mineOillistener = qy.Event.add(qy.Event.MINE_OIL_UPDATE,function(event)
		if self.currentView and self.currentView.oilList then
			self.currentView.oilList:updateOil()
		end
	end)
end

--[[--
--更新当前视图
--]]
function MineScene:updateCurrentView()
	self.currentView = self.children[#self.children]
end

function MineScene:onExit()
	qy.Event.remove(self.timeListener)
	qy.Event.remove(self.userResourceDatalistener)
	qy.Event.remove(self.mineOillistener)
end

return MineScene