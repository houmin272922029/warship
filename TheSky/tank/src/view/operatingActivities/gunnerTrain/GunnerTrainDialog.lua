--[[--
--炮手训练dialog
--Author: lianyi
--Date: 2015-06-29
--]]--

local GunnerTrainDialog = qy.class("GunnerTrainDialog", qy.tank.view.BaseDialog)

function GunnerTrainDialog:ctor()
    GunnerTrainDialog.super.ctor(self)
	self.model = qy.tank.model.OperatingActivitiesModel 
	--通用弹窗样式
	local style = qy.tank.view.style.DialogStyle1.new({
		size = cc.size(880,540),
		position = cc.p(0,0),
		offset = cc.p(0,0), 
		titleUrl = "Resources/common/title/paoshouxunlian.png",

		["onClose"] = function()
			self:dismiss()
		end
	})
	self:addChild(style, -1)
	

	local view = qy.tank.view.operatingActivities.gunnerTrain.GunnerTrainDialog2.new(self)

	local winSize = cc.Director:getInstance():getWinSize()
    local fix = (winSize.width - 1080) / 2
	view:setPosition(-110 - fix, -80)
	style.bg:addChild(view)
	-- self.userList = self.model:getGunnerTrainUserList()
	
	-- self:InjectView("item1")
	-- self:InjectView("item2")
	-- self:InjectView("item3")
	-- self:InjectView("item4")
	-- self:InjectView("item5")
	-- self:InjectView("item6")
	-- self:InjectView("item7")
	-- self:InjectView("item8")
	-- self:InjectView("aimingBtn")
	-- self:InjectView("fireBtn")
	-- self:InjectView("cannon")
	-- self:InjectView("areaBg")E
	-- self:InjectView("btnContainer")
	-- self:InjectView("isEnd")

	-- self:OnClick("aimingBtn",function(sender)
	-- 	self:move()
	-- end)

	-- self:OnClick("fireBtn",function(sender)
	-- 	self:fire()
	-- end)

	-- self:create()
end

return GunnerTrainDialog