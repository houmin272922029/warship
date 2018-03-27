local MainDialog = qy.class("MainDialog", qy.tank.view.BaseDialog, "help.ui.MainDialog")

local model = require("help.src.HelpModel")
-- local service = require("help.src.AdvanceService")

function MainDialog:ctor(delegate)
   	MainDialog.super.ctor(self)

   	self:InjectView("BG")
    self:InjectView("ScrollView_1")

    -- self.Btn_check:setVisible(false)
    -- self.fightList = {}

    -- self.ResourceNum:setString(qy.tank.model.UserInfoModel.userInfoEntity.advanceMaterial)
    self.BG:setPositionX(display.width / 2)
   	self:OnClick("closeBtn", function()
        self:removeSelf()
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})

   	self.list = {}
    self:createList()
end

function MainDialog:createList()
	-- local h = 0
	for i = 1, table.nums(model.titleList1) do
		local item = require("help.src.ItemList").new(self)
		local data = model:atTitle2(i)
		item:render(model.titleList1[tostring(i)], data, i)
		table.insert(self.list, item)
		
		self.ScrollView_1:addChild(item)
	end
	self:update()
end

function MainDialog:update()
	local h = 0
	for i, v in pairs(self.list) do
		-- v:setPositionY(h)
		h = h + v.h
	end
	local height = h > 520 and h or 520
	self.ScrollView_1:setInnerContainerSize(cc.size(420, height))
	self.ScrollView_1:setContentSize(cc.size(420, 520))

	local h2 = 0
	for i, v in pairs(self.list) do
		h2 = h2 + v.h
		v:setPositionY(height - h2)
	end
end

return MainDialog
