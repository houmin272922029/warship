--[[--
--炮手训练dialog
--Author: lianyi
--Date: 2015-06-29
--]]--

local GunnerTrainDialog = qy.class("GunnerTrainDialog", qy.tank.view.BaseDialog, "view/operatingActivities/gunnerTrain/GunnerTrainDialog")

function GunnerTrainDialog:ctor()
    GunnerTrainDialog.super.ctor(self)
	self.model = qy.tank.model.OperatingActivitiesModel 
	--通用弹窗样式
	-- local style = qy.tank.view.style.DialogStyle2.new({
	-- 	size = cc.size(918,572),
	-- 	position = cc.p(0,0),
	-- 	offset = cc.p(0,0), 

	-- 	["onClose"] = function()
	-- 		self:dismiss()
	-- 	end
	-- })
	-- self:addChild(style, -1)
	
	-- self.userList = self.model:getGunnerTrainUserList()
	
	self:InjectView("item1")
	self:InjectView("item2")
	self:InjectView("item3")
	self:InjectView("item4")
	self:InjectView("item5")
	self:InjectView("item6")
	self:InjectView("item7")
	self:InjectView("item8")
	self:InjectView("aimingBtn")
	self:InjectView("fireBtn")
	self:InjectView("cannon")
	self:InjectView("areaBg")
	self:InjectView("btnContainer")
	self:InjectView("isEnd")
	self:InjectView("Update_btn")

	self:OnClick("Update_btn",function (  )
		local service = qy.tank.service.OperatingActivitiesService
		service:getInfo2("gunner_train",function (  )
			for i=1,8 do
				self["item"..i]:removeAllChildren(true)
			end
			self:create()
		end)
	end)

	self:OnClick("aimingBtn",function(sender)
		self:move()
	end)

	self:OnClick("fireBtn",function(sender)
		self:fire()
	end,{["audioType"] = qy.SoundType.T_FIRE_2, ["isScale"] = false})

	self:create()
end

function GunnerTrainDialog:create( )
	self.itemPosArr = {}
	self.itemList = {}
	self:initItems()
	self:updateItems()
	self:showFireBtnOrNot(false)
end

function GunnerTrainDialog:initItems()
	self.userList = self.model:getGunnerTrainUserList()

	for k,v in pairs(self.userList) do
		print("GunnerTrainDialog---01")
		print(k,v)
		-- local configData = self.model:getGunnerTrainConfigItemDataById(k)
		-- local awardItem = qy.tank.view.common.AwardItem.createAwardView(configData.award[1],1)
		-- local num = tonumber(k)%8 == 0 and 8 or tonumber(k)%8
		-- local itemContainer = self:findViewByName("item"..num)
		-- awardItem:setScale(1)
		-- itemContainer:addChild(awardItem)
		-- local obj = {}
		-- obj.x = itemContainer:getPositionX()
		-- obj.y = itemContainer:getPositionY()
		-- obj.width = awardItem:getWidth()*itemContainer:getScaleX()
		-- obj.height = awardItem:getHeight()*itemContainer:getScaleY()
		-- obj.id = tonumber(k)
		-- table.insert(self.itemPosArr , obj)

		-- self.itemList[tostring(k)] = awardItem
		self:addItem(k)
	end
	--print(qy.json.encode(self.itemPosArr))
end

function GunnerTrainDialog:updateItems()
	self.userList = self.model:getGunnerTrainUserList()
	print("GunnerTrainDialog---009",table.nums(self.userList))
	if tonumber(table.nums(self.userList)) <= 2 then
		self.Update_btn:setVisible(true)
	else
		self.Update_btn:setVisible(false)
	end
	for i, v in pairs(self.itemList) do
		v:setVisible(false)
	end

	for k,v in pairs(self.userList) do
		if self.itemList[tostring(k)] then
			self.itemList[tostring(k)]:setVisible(true)
		else
			-- local configData = self.model:getGunnerTrainConfigItemDataById(k)
			-- local awardItem = qy.tank.view.common.AwardItem.createAwardView(configData.award[1],1)
			-- local num = tonumber(k)%8 == 0 and 8 or tonumber(k)%8
			-- local itemContainer = self:findViewByName("item"..num)
			-- awardItem:setScale(1)
			-- itemContainer:addChild(awardItem)
			-- local obj = {}
			-- obj.x = itemContainer:getPositionX()
			-- obj.y = itemContainer:getPositionY()
			-- obj.width = awardItem:getWidth()*itemContainer:getScaleX()
			-- obj.height = awardItem:getHeight()*itemContainer:getScaleY()
			-- obj.id = tonumber(k)
			-- table.insert(self.itemPosArr , obj)

			-- self.itemList[tostring(k)] = awardItem
			self:addItem(k)
		end
	end
end

function GunnerTrainDialog:addItem(k)
	local configData = self.model:getGunnerTrainConfigItemDataById(k)
	local awardItem = qy.tank.view.common.AwardItem.createAwardView(configData.award[1],1)
	local num = tonumber(k)%8 == 0 and 8 or tonumber(k)%8
	local itemContainer = self:findViewByName("item"..num)
	awardItem:setScale(1)
	itemContainer:addChild(awardItem)
	local obj = {}
	obj.x = itemContainer:getPositionX()
	obj.y = itemContainer:getPositionY()
	obj.width = awardItem:getWidth()*itemContainer:getScaleX()
	obj.height = awardItem:getHeight()*itemContainer:getScaleY()
	obj.id = tonumber(k)
	table.insert(self.itemPosArr , obj)

	self.itemList[tostring(k)] = awardItem
end

function GunnerTrainDialog:showFireBtnOrNot( show )
	self.aimingBtn:setVisible(not show)
	self.fireBtn:setVisible(show)
	self:checkDone()
end

function GunnerTrainDialog:move( )
	self:showFireBtnOrNot(true)
	local cannon = self.cannon
	local maxX = self.areaBg:getContentSize().width/2 - 20
	local maxY = self.areaBg:getContentSize().height/2 - 40
	local prepoint = cc.p(0,0)
	function getRandom( )
		return (100*math.random()>50 and 1 or -1)*math.random()
	end
	function toMove()
        local bezier ={
            prepoint,--起始点
            cc.p(maxX*getRandom(), maxY*getRandom()),--控制点
            cc.p(maxX*getRandom() , maxY*getRandom())--结束点
        }
        local bezierTo = cc.BezierTo:create(.25, bezier)
        local seq = cc.Speed:create(cc.Sequence:create(bezierTo , cc.CallFunc:create(function()
        	prepoint = cc.p(cannon:getPositionX() , cannon:getPositionY())
            toMove()
        end)) , .2)
        cannon:runAction(seq)
      end
      toMove()
end

function GunnerTrainDialog:stop(  )
	self.cannon:stopAllActions()
	self:showFireBtnOrNot(false)
end

function GunnerTrainDialog:fire()
	self:stop()
	self:__showEffert()
	function getHitItem()
		local x,y
		x = self.cannon:getPositionX()
		y = self.cannon:getPositionY()
		local  minDistance = 9999999999999
		local currentItem = nil
		for i=1,#self.itemPosArr do
			local itemData = self.itemPosArr[i]
			
			local tempDis = math.pow(x - itemData.x , 2 ) + math.pow(y - itemData.y , 2)
			if tempDis < minDistance then
				minDistance = tempDis
				currentItem = itemData
			end
		end

		local xOk = math.abs(x - currentItem.x) <= currentItem.width/2 and true or false
		local yOk = math.abs(y - currentItem.y) <= currentItem.height/2 and true or false
		if xOk and yOk then
			return currentItem
		end
		return nil
	end

	local currentItem = getHitItem()

	if currentItem == nil then
		-- local service = qy.tank.service.OperatingActivitiesService
		-- service:getCommonGiftAward(0, "gunner_train", true, function(reData)
			
		-- end)
		qy.hint:show(qy.TextUtil:substitute(70052))	
		return
	end 

	local moveTo = cc.MoveTo:create(.2, cc.p(currentItem.x , currentItem.y))
	local seq = cc.Sequence:create(moveTo,cc.CallFunc:create(function()
        local service = qy.tank.service.OperatingActivitiesService
		local id = currentItem.id
		service:getCommonGiftAward(id, "gunner_train",true, function(reData)
			-- self.model:setGunnerTrainStatusById(id , 1)
			-- self.model:updateGunnerTrainUptime(reData.activity_info.free_times)
			self:updateItems()
			self:checkDone()
		end)	
    end))
    self.cannon:runAction(seq)
	
end

function GunnerTrainDialog:__showEffert()
	if self.currentEffert == nil then
    	self.currentEffert = ccs.Armature:create("ui_fx_tongyongbaozha")
    	self.cannon:addChild(self.currentEffert,-1)
    	self.currentEffert:setPosition(0,0)
    end
    self.currentEffert:getAnimation():playWithIndex(0)
end

function GunnerTrainDialog:checkDone()
	local done = not self.model:canGunnerFire()
	self.btnContainer:setVisible(false)
	self.isEnd:setVisible(false)
	if done then 
		self.isEnd:setVisible(true)
	else
		self.btnContainer:setVisible(true)
	end
end

function GunnerTrainDialog:onEnter()
	qy.tank.utils.cache.CachePoolUtil.addArmatureFile(qy.ResConfig.GENERAL_EXPLOSION)
end

function GunnerTrainDialog:onExit()
	qy.tank.utils.cache.CachePoolUtil.removeArmatureFile(qy.ResConfig.GENERAL_EXPLOSION)
	self.currentEffert = nil
	-- cc.Director:getInstance():getTextureCache():removeAllTextures()
end

return GunnerTrainDialog