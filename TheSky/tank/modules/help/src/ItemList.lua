local ItemList = qy.class("ItemList", qy.tank.view.BaseView, "help.ui.ItemList")

local model = require("help.src.HelpModel")
function ItemList:ctor(delegate)
   	ItemList.super.ctor(self)

   	self:InjectView("Title")
    self:InjectView("Panel_1")
    self:InjectView("Image_1")
    self:InjectView("jiantou")
    
    self.Panel_1:setSwallowTouches(false)
    self.status = 0

    self.h = 75
    self.delegate = delegate
    -- -- self.Btn_check:setVisible(false)
    -- -- self.fightList = {}

    -- -- self.ResourceNum:setString(qy.tank.model.UserInfoModel.userInfoEntity.advanceMaterial)

   	self:OnClick("Image_1", function()
        self:update()
        delegate:update()
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})

    self.Image_1:setSwallowTouches(false)

    self.list = {}
	-- self:createlist(delegate.data)
end

-- 
function ItemList:render(title, data, key)
	self.Title:setString(title)
	self.data = data
	self.key = key
	self:update()
end

function ItemList:update()
	if self.status == 1 then
		self.Panel_1:setVisible(true)
		self:createlist(self.data)
	else
		self.Panel_1:setVisible(false)
		self.old_h = self.h
		self.h = 75
		self.Image_1:setPositionY(10)
	end

	self.status = self.status == 1 and 0 or 1

	self.jiantou:setFlippedY(self.status == 0)
end

function ItemList:createlist(data)
	local h = 0
	if table.nums(self.list) > 0 then
		h = table.nums(self.list) * 60
	else
		for i, v in pairs(data) do
			h = h + 60
		end
		for i, v in pairs(data) do
			local item = require("help.src.ItemList2").new({
					["id1"] = self.key,
					["id2"] = i,
					["onClose"] = function()
						self.delegate:removeSelf()
					end,
				})
			table.insert(self.list, item)
			item:render(v)
			item:setPositionY(h - i * 60)
			self.Panel_1:addChild(item)
		end
	end

	self.Panel_1:setContentSize(cc.size(415, h +10))
	self.Panel_1:setPositionY(0)
	self.Image_1:setPositionY(h + 10)

	self.h = h + 75
end

return ItemList
