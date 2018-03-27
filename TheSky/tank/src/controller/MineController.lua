--[[--
--矿区controller
--Author: H.X.Sun
--Date: 2015-05-11
--]]--
local MineController = qy.class("MineController", qy.tank.controller.BaseController)

function MineController:ctor(params)
    MineController.super.ctor(self)

	if params == nil then
		params = {["moduleType"] = qy.tank.view.type.ModuleType.MINE_MAIN_VIEW}
	end
	self.viewStack = qy.tank.widget.ViewStack.new()
	self.viewStack:addTo(self)
	self.scene = qy.tank.view.mine.MineScene.new()
	self.viewStack:push(self.scene)
	
	self.moduleType = qy.tank.view.type.ModuleType

	self:__createViewByModuleType(params.moduleType)
end

--[[--
--根据moduleType创建视图
--@param #string sModuleType 模块类型
--]]
function MineController:__createViewByModuleType(sModuleType)
	if sModuleType == self.moduleType.MINE_MAIN_VIEW then
		--矿区主界面
		self:__createMineView()
	elseif sModuleType == self.moduleType.MINE_PLUNDER_VIEW then
		--掠夺列表界面
		self:__createPlunderView()
	elseif sModuleType == self.moduleType.MINE_RARE_MINE_VIEW then
		--稀有矿区
		self:__createRareMineView()
	end
end

--[[--
--创建矿区主界面
--]]
function MineController:__createMineView()
	self.mineView = qy.tank.view.mine.MineView.new({
		["dismiss"] = function()
			self.scene:popView(self.mineView)
			self.viewStack:removeFrom(self)
			self:finish()
		end,
		["enterRareMineView"] = function()
			self:__createRareMineView(function ()
				self.mineView:setRareMineRedDot()
			end)
		end,
		["enterPlunderView"] = function()
			self:__createPlunderView()
		end,
	})
	self.scene:addChild(self.mineView)
	self.scene:pushView(self.mineView)
end

--[[--
--创建掠夺列表界面
--]]
function MineController:__createPlunderView()
	local service = qy.tank.service.MineService
        	service:getPlunderList(function(data)
		self.plunderView = qy.tank.view.mine.PlunderView.new({
			["dismiss"] = function()
				self.scene:popView(self.plunderView)
				self.scene:removeChild(self.plunderView)
				self.plunderView = nil
				if self.mineView == nil then
					self:finish()
				else
					self.mineView:updateResource()
				end
			end,
		})
		self.scene:addChild(self.plunderView)
		self.scene:pushView(self.plunderView)
	end)
end

--[[--
--创建掠夺列表界面
--]]
function MineController:__createRareMineView()
	local service = qy.tank.service.MineService
        	service:getRareMineList(nil, function(data)
		self.rareMineView = qy.tank.view.mine.RareMineView.new({
			["dismiss"] = function()
				self.scene:popView(self.rareMineView)
				self.scene:removeChild(self.rareMineView)
				self.rareMineView = nil
				if self.mineView == nil then
					self:finish()
				else
					self.mineView:updateResource()
				end
			end,
			["closeCallBack"] = function ()
				self.mineView:setRareMineRedDot()
			end
		})
		self.scene:addChild(self.rareMineView)
		self.scene:pushView(self.rareMineView)
	end)
end

return MineController