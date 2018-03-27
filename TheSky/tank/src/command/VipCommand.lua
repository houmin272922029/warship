--[[
	VIP指令
	Author: Aaron Wei
	Date: 2015-06-11 16:51:26
]]

local VipCommand = qy.class("VipCommand", qy.tank.command.BaseCommand)

function VipCommand:showAwardDialog()
	local service = qy.tank.service.VipService
    service:get(function(data)
    	service = nil
		-- qy.tank.model.VipModel:init()
		local dialog = qy.tank.view.vip.VipAwardDialog.new()
		dialog:show()
    end)
end

function VipCommand:showPrivilegeView(extend)
	local isRechargeView = false
	local index = -1
	if extend and extend.isRechargeView then
		isRechargeView = extend.isRechargeView
	end

	if extend and extend.index then
		index = extend.index
	end

	local service = qy.tank.service.VipService
	service:get(function(data)
		qy.tank.model.VipModel:init()
		local controller = qy.tank.controller.VipController.new({
			["isRechargeView"] = isRechargeView,
			["index"] = index,
		})
		self:startController(controller)
	end)
end

return VipCommand


