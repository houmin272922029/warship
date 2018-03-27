--[[--
--七天登陆礼包cell
--Author: H.X.Sun
--Date: 2015-06-24
--]]--

local HeroicRacingItem = qy.class("HeroicRacingItem", qy.tank.view.BaseView, "view/operatingActivities/heroicRacing/HeroicRacingItem")

function HeroicRacingItem:ctor(delegate)
    HeroicRacingItem.super.ctor(self)
	self.model = qy.tank.model.OperatingActivitiesModel
	self:InjectView("nameTxt")
	self:InjectView("awardTxt")
	self:InjectView("sceneTxt")
	self:InjectView("getBtn")
	self:InjectView("hasGot")
	self:InjectView("canNotGet")
	self:InjectView("diamond")
	self:InjectView("Image")
	self:InjectView("TitleBtn")


	self:OnClick("getBtn",function(sender)
		if self.index == 1 then
				qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.CHAPTER)
				self.data.dismiss()
		else
			local service = qy.tank.service.OperatingActivitiesService
			service:getCommonGiftAward(self.id, "heroic_racing",true, function(reData)

				self.model:setHeroicRacingStatusById(self.id , 2)
				self.status = 2
				self:updateStatus()
				delegate.callBack()
			end)
		end

	end)
end

function HeroicRacingItem:render(data)
	self.data = data
	self.status = data.itemData.status
	self.id = data.itemData.id
	self.index = data.itemData.index == nil and -1 or data.itemData.index

	local configData = self.model:getHeroicRacingConfigItemDataById(self.id)
	local checkpointData = self.model:getCheckpointConfigDataByCheckPointId(configData.checkpoint_id)
	local sceneName =  self.model:getSceneNameBySceneName(checkpointData.scene_id)
	self.nameTxt:setString(qy.TextUtil:substitute(63010).. " " ..string.gsub(checkpointData.show_no, "_", "-").." "..checkpointData.name)
	self.sceneTxt:setString(""..sceneName)
	self.awardTxt:setString(configData.award[1].num)
	local awardSize = self.awardTxt:getContentSize()
	-- self.diamond:setPosition(269.50 + awardSize.width +5, 39)
	self.Image:setTexture("Resources/campaign/" .. checkpointData.icon .. ".jpg")

	self:updateStatus()

end

function HeroicRacingItem:updateStatus( )
	self.hasGot:setVisible(false)
	self.getBtn:setVisible(false)
	if self.status == 0 then
		self.getBtn:setVisible(true)
		if self.index == 1 then
			self.getBtn:setEnabled(true)
			-- self.getBtn:setTitleText("前往")
			self.getBtn:loadTextureNormal("Resources/common/button/btn_3.png", 1)
			self.getBtn:loadTexturePressed("Resources/common/button/anniuhong02.png", 1)
			self.TitleBtn:setSpriteFrame("Resources/common/txt/qianwang.png")
		else
			self.getBtn:setEnabled(false)
			self.TitleBtn:setSpriteFrame("Resources/common/txt/weidacheng.png")
		end

	elseif self.status==1 then
		self.getBtn:setVisible(true)
		self.getBtn:loadTextureNormal("Resources/common/button/btn_4.png", 1)
		self.getBtn:loadTexturePressed("Resources/common/button/anniulan02.png", 1)
		self.TitleBtn:setSpriteFrame("Resources/common/txt/lingqu.png")
		-- self.getBtn:setTitleText("领取")
		self.getBtn:setEnabled(true)
	elseif self.status==2 then
		self.hasGot:setVisible(true)

	end
end

return HeroicRacingItem
