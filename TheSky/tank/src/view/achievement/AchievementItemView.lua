--[[
	图鉴
	Author: mingming
--]]

local AchievementItemView = qy.class("AchievementItemView", qy.tank.view.BaseView, "view/achievement/AchievementItemView")

local model = qy.tank.model.AchievementModel
function AchievementItemView:ctor(delegate)
    AchievementItemView.super.ctor(self)
    self.delegate = delegate

    self:InjectView("Actack")
    self:InjectView("Defense")
    self:InjectView("Blood")
    self:InjectView("Name")
    self:InjectView("Bg")
    self:InjectView("BZ_1_1")
    self:InjectView("Quality")
    self:InjectView("Btn_upgrade")

    for i = 1, 6 do
    	self:InjectCustomView("Item" .. i, qy.tank.view.common.TankItem3, {})
    	self["Item" .. i]:setVisible(false)
    end

    self:OnClick("Btn_Attruite", function()
        qy.tank.view.achievement.AttributeListDialog.new(self.entity):show()
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})

    self:OnClick("Btn_upgrade", function()
        --qy.QYPlaySound.stopMusic()
        if self.entity.level > 0 then
        	if model:testUpgade(self.entity) then
		       	qy.tank.view.achievement.UpgradeDescDialog.new({
		       		["upgrade"] = function(sender)
		       			if model:testCoinEnough(self.entity) then
			       			if delegate and delegate.onUpgrade then
			       				delegate.onUpgrade(self, sender)
			       			end
		       			else
				       		qy.hint:show(qy.TextUtil:substitute(1001))
				       	end
		       		end,
		       		["entity"] = self.entity,
		       		}):show()
	       	else
	       		qy.hint:show(qy.TextUtil:substitute(1002))
	       	end
       	else
       		qy.hint:show(qy.TextUtil:substitute(1003))
       	end
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})
end

function AchievementItemView:setData(data, height)
	self.entity = data
	self:setStype(data, height)
	self:update(data)
	self.Name:setString(data.name)
	if model:testUpgade(data) then
		self.Btn_upgrade:setBright(true)
	else
		self.Btn_upgrade:setBright(false)
	end
end

function AchievementItemView:update()
	local level = self.entity.level < 1 and 1 or self.entity.level
	local data = model:getAttributeByLevel(self.entity.id, level)
	if data then
		if data.shuxing1_type ~= 0 then
			if data.shuxing1_type == 6 or data.shuxing1_type == 7 or data.shuxing1_type == 9 or data.shuxing1_type == 10  or data.shuxing1_type == 14 then
				self.Actack:setString(model.attrTypes[tostring(data.shuxing1_type)] .. "+" .. data.shuxing1_val / 10 .. "%")
			else
				self.Actack:setString(model.attrTypes[tostring(data.shuxing1_type)] .. "+" .. data.shuxing1_val)
			end
			
		else
			self.Actack:setString("")
		end
		if data.shuxing2_type ~= 0 then
			if data.shuxing2_type == 6 or data.shuxing2_type == 7 or data.shuxing2_type == 9 or data.shuxing2_type == 10 or data.shuxing2_type == 14 then
				self.Defense:setString(model.attrTypes[tostring(data.shuxing2_type)] .. "+" .. data.shuxing2_val / 10 .. "%")
			else
				self.Defense:setString(model.attrTypes[tostring(data.shuxing2_type)] .. "+" .. data.shuxing2_val)
			end
		else
			self.Defense:setString("")
		end
		if data.shuxing3_type ~= 0 then
			if data.shuxing3_type == 6 or data.shuxing3_type == 7 or data.shuxing3_type == 9 or data.shuxing3_type == 10 or data.shuxing3_type == 14 then
				self.Blood:setString(model.attrTypes[tostring(data.shuxing3_type)] .. "+" .. data.shuxing3_val / 10 .. "%")
			else
				self.Blood:setString(model.attrTypes[tostring(data.shuxing3_type)] .. "+" .. data.shuxing3_val)
			end
		else
			self.Blood:setString("")
		end
	else
		self.Actack:setString(qy.TextUtil:substitute(1004))
		self.Defense:setString(qy.TextUtil:substitute(1005))
		self.Blood:setString(qy.TextUtil:substitute(1006))
	end

	self.Quality:setString(qy.TextUtil:substitute(1007, model.attrLevels[tostring(self.entity.level)]))

	self.Btn_upgrade:setBright(self.entity.level > 0)

	local colorId = self.entity.level > 5 and 5 or self.entity.level
	local color = qy.tank.utils.ColorMapUtil.qualityMapColor(tostring(colorId))
	self.Actack:setTextColor(color)
	self.Defense:setTextColor(color)
	self.Blood:setTextColor(color)
	self.Quality:setTextColor(color)
	self.Name:setTextColor(color)
end

-- 调整样式
function AchievementItemView:setStype(data, height)
	local num = 7
	for i = 1, 6 do
		if not data["tank" .. i] or data["tank" .. i] == "" then
			num = i
			break
		else
			self["Item" .. i]:setVisible(true)
			local data_i = model:atPic(data["tank" .. i])
			-- data_i.scale = 0.95
			data_i.callback = function(entity)
				self.delegate.callback(data_i.entity)
			end
			self["Item" .. i]:setData(data_i)
		end
	end

	-- 没有的隐藏
	for i = num, 6 do
		self["Item" .. i]:setVisible(false)
	end

	-- 小于等于 四 一行排列，大于 4 第一排 3 个排列
	if num - 1 <= 4 then
		for i = 1, 4 do
			self["Item" .. i]:setPosition(40 + (i - 1) * 200, 70)
		end
		self.BZ_1_1:setPositionY(200)
	else
		for i = 1, 3 do
			self["Item" .. i]:setPosition(40 + (i - 1) * 200, 196)
		end

		for i = 4, 6 do
			self["Item" .. i]:setPosition(40 + (i - 4) * 200, 70)
		end

		self.BZ_1_1:setPositionY(310)
	end

	self.Bg:setContentSize(860, height)
end

return AchievementItemView