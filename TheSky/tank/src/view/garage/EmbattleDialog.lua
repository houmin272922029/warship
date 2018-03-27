--[[
	车库坦克列表cell
	Author: Aaron Wei
	Date: 2015-03-23 15:56:08
]]

local EmbattleDialog = qy.class("EmbattleDialog", qy.tank.view.BaseDialog, "view/garage/EmbattleDialog")

function EmbattleDialog:ctor(data)
    EmbattleDialog.super.ctor(self)

	local style = qy.tank.view.style.DialogStyle1.new({
		size = cc.size(916,580),
       	position = cc.p(0,0),
		offset = cc.p(0,0),
		titleUrl = "Resources/common/title/embattle_title.png",

		["onClose"] = function()
			self:dismiss()
			qy.GuideManager:next(987)
        end
	})
	style.bg:loadTexture("Resources/common/bg/deploy_0006.jpg")
    self:addChild(style,-1)
    self.closeBtn = style.closeBtn

    self.model = qy.tank.model.GarageModel

	self.formation = data
	self.tankList = nil
	self.placeList = {}
	self.btnList = {}

	self:InjectView("panel")
	self:InjectView("placeNode")
	self:InjectView("goBtn")

	self:OnClick(self.goBtn, function(sender)
		self:dismissAll()
       local service = qy.tank.service.FightJapanService
       local param = {}
       --战斗
       param.defkid = qy.tank.model.FightJapanModel.currentIndex
       service:fight(param,function(data)
            qy.tank.model.BattleModel:init(data.fight_result)
            -- qy.tank.manager.ScenesManager:pushScene(qy.tank.view.scene.BattleScene.new())
            qy.tank.manager.ScenesManager:pushBattleScene()
        end)
    end)

	self.goBtn:setVisible(self:isForFightJapan())

	 for i=1,6 do
		 self:InjectView("p"..i)
		 self:InjectView("pTip_"..i)
	       	 self["p"..i].idx = i
	    	 table.insert(self.placeList,self["p"..i])
	    	 self:OnClick("p"..i, function(sender)
		    	 local place = self.placeList[i]
		    	 if place.status == -1 then
		    	 	local _level = self.model:getUnlockLevelByIndex(i)
		    	 	if _level then
		    	 		qy.hint:show(qy.TextUtil:substitute(14001).. qy.TextUtil:substitute(14002, _level),0.5)
		    	 	else
		    	 		qy.hint:show(qy.TextUtil:substitute(14003),0.5)
		    	 	end
		    	 elseif place.status == 0 then
		    		self:showTankSelectList(i)
		    		qy.GuideManager:next()
		    	 elseif place.status == 1 then
		    		-- qy.hint:show("替换坦克",0.5)
		    	 end
	    	 end,{["dribble"]=true,["isScale"]=false})
	    	 self["p"..i]:setSwallowTouches(false)
	 end

	 self:addTouchEvent()
	 self:render()
end

function EmbattleDialog:showTankSelectList(idx)
	-- command用法
	if self:isForFightJapan() then
    	qy.tank.command.GarageCommand:showFightJapanUnselectedTankListDialog(false,function(uid)
        local service = qy.tank.service.GarageService
		service:lineup(2,1,"p_"..idx,uid,function()
			if self.callback then
	        	self.callback()
			end
			self.formation = qy.tank.model.FightJapanGarageModel.formation
			self:update()
	        qy.tank.command.GarageCommand:hideTankListDialog()
			end,nil,nil)
    	end)
	else
		qy.tank.command.GarageCommand:showUnselectedTankListDialog(false,function(uid)
	        local service = qy.tank.service.GarageService
				service:lineup(1,1,"p_"..idx,uid,function(data)
	            qy.Event.dispatch(qy.Event.LINEUP_SUCCESS)
	            qy.GuideManager:next(908768)
				if self.callback then
		        	self.callback()
				end
				self.formation = qy.tank.model.GarageModel.formation
				self:update()
		        qy.tank.command.GarageCommand:hideTankListDialog()
	    		--qy.GuideManager:next(9807)
			end,nil,nil)
    	end)
	end

  --   qy.tank.command.GarageCommand:showUnselectedTankListDialog(false,function(uid)
  --       local service = qy.tank.service.GarageService
  --       if  self:isForFightJapan()   then
		-- 	service:lineup(2,1,"p_"..idx,uid,function()
		-- 		if self.callback then
	 --        		self.callback()
		-- 		end
		-- 		self.formation = qy.tank.model.FightJapanGarageModel.formation

		-- 		self:update()
	 --            qy.tank.command.GarageCommand:hideTankListDialog()
	 --            -- qy.GuideManager:next()
		-- 	end,nil,nil)
		-- else
		-- 	service:lineup(1,1,"p_"..idx,uid,function(data)
  --               qy.Event.dispatch(qy.Event.LINEUP_SUCCESS)
		-- 		if self.callback then
	 --        		self.callback()
		-- 		end
		-- 		self.formation = qy.tank.model.GarageModel.formation
		-- 		self:update()
	 --            qy.tank.command.GarageCommand:hideTankListDialog()
	 --            -- qy.GuideManager:next()
		-- 	end,nil,nil)
  --       end

  --   end)
end

function EmbattleDialog:addTouchEvent()
	self.listener = cc.EventListenerTouchOneByOne:create()
	local function onTouchBegan(touch, event)
		self.touchPoint = self.panel:convertToNodeSpace(touch:getLocation())
		return true
	end

	local function onTouchMoved(touch, event)
		self.touchPoint = self.panel:convertToNodeSpace(touch:getLocation())
		return true
	end

	local function onTouchEnded(touch, event)
		self.touchPoint = self.panel:convertToNodeSpace(touch:getLocation())
		if self.currentTank then
			self:jude()
			self:endDrag()
		end
		return true
	end

    self.listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN)
    self.listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED)
    self.listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED)
    self.eventDispatcher = self:getEventDispatcher()
    self.eventDispatcher:addEventListenerWithSceneGraphPriority(self.listener,self)
    -- eventDispatcher:addEventListenerWithFixedPriority(listener,-1)
end

function EmbattleDialog:removeTouchEvent()
	self.eventDispatcher:removeEventListenerWithSceneGraphPriority(self.listener,self)
end

function EmbattleDialog:render()
	self.tankList = {}
	for i=1,#self.formation do
		local place = self.placeList[i]
		local entity = self.formation[i]
		if entity == -1 then
			table.insert(self.tankList,-1)
			place:loadTexture("Resources/garage/ZC_1.png",1)
			place.status = -1
			self:showFormatTip(i,false)
		elseif entity == 0 then
			table.insert(self.tankList,0)
			place:loadTexture("Resources/garage/ZC_2.png",1)
			place.status = 0
			self:showFormatTip(i,true)
		else
			self:showFormatTip(i,false)
			print("+++++++++++++++++++778899",entity.quality,entity:getFontColor())
			local tank = qy.tank.view.garage.EmbattleTankImg.new({entity,1,i,
				["onChange"] = function(idx)
					self:showTankSelectList(idx)
				end
			})
			--显示tank远征额外状态
			self:showTankExtendStatus(tank , entity)

			tank:setPosition(place:getPosition())
			self.panel:addChild(tank)
	        tank:setTouchEnabled(true)
	        tank:setSwallowTouches(false)
    	    tank:addTouchEventListener(function(sender, eventType)
    	    	self.currentTank = tank
	            if eventType == ccui.TouchEventType.began then
	            	self:startDrag()
	            elseif eventType == ccui.TouchEventType.moved then
	            	tank:setPosition(self.touchPoint)
	            elseif eventType == ccui.TouchEventType.ended then
	            	-- 当滑动速度太快时，监听此事件判断drag结束不准，故禁用！！！
	            	-- self:jude()
	            end
	        end)
			table.insert(self.tankList,tank)
			place:loadTexture("Resources/garage/ZC_2.png",1)
			place.status = 1
		end
	end
end

function EmbattleDialog:clear()
	for i=1,#self.tankList do
		local tank = self.tankList[i]
		if tolua.cast(tank,"cc.Node") then
			tank:getParent():removeChild(tank)
		end
	end
end

function EmbattleDialog:update()
	self:clear()
	self:render()
end

-- [[--
-- 显示提示
-- @param ui 控件
-- ]]
function EmbattleDialog:showFormatTip(i,flag)
    if flag then
    	if self["pTip_" .. i] == nil then
    		self["pTip_" .. i] = cc.Sprite:createWithSpriteFrameName("Resources/garage/deploy_0007.png")
    		self["pTip_" .. i]:setPosition(75, 43)
    		self["p" .. i]:addChild(self["pTip_" .. i])
    	end

    	self["pTip_" .. i]:stopAllActions()
        local scaleSmall = cc.ScaleTo:create(1.2,0.9)
        local scaleBig = cc.ScaleTo:create(1.2,1)
        local FadeIn = cc.FadeTo:create(1.2, 255)
        local FadeOut = cc.FadeTo:create(1.2, 125)
        local spawn1 = cc.Spawn:create(scaleSmall,FadeOut)
        local spawn2 = cc.Spawn:create(scaleBig,FadeIn)
        local seq = cc.Sequence:create(spawn1, spawn2)
        self["pTip_" .. i]:runAction(cc.RepeatForever:create(seq))
    else
    	self["p" .. i]:removeChild(self["pTip_" .. i], true)
    	self["pTip_" .. i] = nil
    end
end

function EmbattleDialog:startDrag()
	-- local idx = self.currentTank.idx
	-- self.tankList[idx] = 0
	self.currentTank:startDrag()
	self.currentTank:setLocalZOrder(100)
end

function EmbattleDialog:endDrag()
	self.currentTank:setLocalZOrder(1)
	self.currentTank = nil
end

function EmbattleDialog:jude()
	local idx = self:matchAll(self.touchPoint)
	if idx ~= nil then
		-- 置于有效区域
		local t = self.tankList[idx]
		if t == -1 then
			-- 未解锁
			self:reset(self.currentTank)
			local _level = self.model:getUnlockLevelByIndex(idx)
		   	if _level then
		    	qy.hint:show(qy.TextUtil:substitute(14001).. qy.TextUtil:substitute(14002, _level),0.5)
		    else
		    	qy.hint:show(qy.TextUtil:substitute(14003),0.5)
		    end
			-- if idx == 5 then
			-- 	qy.hint:show("该阵位12级解锁",0.5)
			-- elseif idx == 6 then
			-- 	qy.hint:show("该阵位18级解锁",0.5)
			-- else
			-- 	qy.hint:show("该阵位未解锁",0.5)
			-- end
		elseif t == 0 then
			-- 空地
			self:moveTo(self.currentTank,idx)
		else
			-- 非空地
			if self.currentTank ~= t then
				self:swap(self.currentTank,t)
			else
				self:reset(self.currentTank)
			end
		end
	else
		-- 置于无效区域
		self:reset(self.currentTank)
		-- qy.hint:show("无效区域",0.5)
	end
end

function EmbattleDialog:matchAll(p)
	local function matchOne(node,p)
		local x,y = node:getPositionX(),node:getPositionY()
		local w,h = node:getContentSize().width,node:getContentSize().height
		local anchor = node:getAnchorPoint()
		local rect = {x=x-anchor.x*w,y=y-anchor.y*h,width=w,height=h}
		if p.x >= rect.x-20 and p.x <= rect.x+rect.width+20 and p.y >= rect.y-20 and p.y <= rect.y+rect.height+20 then
			return true
		else
			return false
		end
	end

	for i=1,6 do
		local place = self.placeList[i]
		if matchOne(place,p) then
			-- print("EmbattleDialog:matchAll",true)
			return i
		end
	end
	-- print("EmbattleDialog:matchAll",false)
	return nil
end

function EmbattleDialog:add()

end

function EmbattleDialog:replace()

end

-- function EmbattleDialog:moveTo(target,idx)
-- 	local x,y = self.placeList[idx]:getPosition()
-- 	print("EmbattleDialog:moveTo","idx="..idx,"x="..x,"y="..y)
-- 	local act = cc.MoveTo:create(0.1,cc.p(x,y))
-- 	local seq = cc.Sequence:create(act,cc.CallFunc:create(function()
-- 		self.tankList[target.idx] = 0
-- 		self.formation[target.idx] = 0
-- 		self.placeList[target.idx].status = 0

-- 		self.tankList[idx] = target
-- 		self.formation[idx] = target.entity
-- 		self.placeList[idx].status = 1
-- 		target:setIdx(idx)
-- 		target:endDrag()
-- 	end))
-- 	target:runAction(seq)
-- end
function EmbattleDialog:__moveTo(target,idx,callback,isTween)
	local x,y = self.placeList[idx]:getPosition()
	print("EmbattleDialog:moveTo","idx="..idx,"x="..x,"y="..y)
	if isTween then
		local act = cc.MoveTo:create(0.1,cc.p(x,y))
		local seq = cc.Sequence:create(act,cc.CallFunc:create(function()
			-- local idx_before = target.idx
			self.tankList[target.idx] = 0
			self.formation[target.idx] = 0
			self.placeList[target.idx].status = 0

			self.tankList[idx] = target
			self.formation[idx] = target.entity
			self.placeList[idx].status = 1
			target:setIdx(idx)
			target:endDrag()

			if callback then
				callback()
			end
		end))
		target:runAction(seq)
	else
		target:setPosition(x,y)

		self.tankList[target.idx] = 0
		self.formation[target.idx] = 0
		self.placeList[target.idx].status = 0

		self.tankList[idx] = target
		self.formation[idx] = target.entity
		self.placeList[idx].status = 1
		target:setIdx(idx)
		target:endDrag()
	end
end

function EmbattleDialog:moveTo(target,idx)
	local idx_before = target.idx
	self:__moveTo(target, idx,function()
		function onSuccess()
			self:showFormatTip(idx,false)
			self:showFormatTip(idx_before,true)
			qy.Event.dispatch(qy.Event.LINEUP_SUCCESS)
		end

		function onError()
			self:__moveTo(target, idx_before)
		end

		function ioError()
			self:__moveTo(target, idx_before)
		end

		local p1,p2 = "p_"..idx_before,"p_"..idx
		local service = qy.tank.service.GarageService
		if self:isForFightJapan()  then
			service:lineup(2,2,p1,p2,onSuccess,onError,ioError)
		else
			service:lineup(1,2,p1,p2,onSuccess,onError,ioError)
		end

	end,true)
end

function EmbattleDialog:__swap(target1,target2,callback,isTween)
	print("EmbattleDialog:__swap",target1,target2)
	local idx1,idx2 = target1.idx,target2.idx
	self.tankList[idx1] = target2
	self.tankList[idx2] = target1
	self.formation[idx1] = target2.entity
	self.formation[idx2] = target1.entity
	target1:setIdx(idx2)
	target2:setIdx(idx1)

	local x1,y1 = self.placeList[idx1]:getPosition()
	if isTween then
		local act1 = cc.MoveTo:create(0.1,cc.p(x1,y1))
		local seq1 = cc.Sequence:create(act1,cc.CallFunc:create(function()
			target2:endDrag()
		end))
		target2:startDrag()
		target2:runAction(seq1)
	else
		target2:setPosition(x1,y1)
	end

	local x2,y2 = self.placeList[idx2]:getPosition()
	if isTween then
		local act2 = cc.MoveTo:create(0.1,cc.p(x2,y2))
		local seq2 = cc.Sequence:create(act2,cc.CallFunc:create(function()
			target1:endDrag()
			if callback then
				callback()
			end
		end))
		target1:startDrag()
		target1:runAction(seq2)
	else
		target1:setPosition(x2,y2)
	end
end

function EmbattleDialog:swap(target1,target2)
	self:__swap(target1, target2,function()
		function onSuccess()
			qy.Event.dispatch(qy.Event.LINEUP_SUCCESS)
		end

		function onError()
			if tolua.cast(self,"cc.Node") then
				self:__swap(target1,target2)
			end
		end

		function ioError()
			if tolua.cast(self,"cc.Node") then
				self:__swap(target1,target2)
			end
		end

		local p1,p2 = "p_"..target1.idx,"p_"..target2.idx
		local service = qy.tank.service.GarageService
		if self:isForFightJapan()  then
			service:lineup(2,2,p1,p2,onSuccess,onError,ioError)
		else
			service:lineup(1,2,p1,p2,onSuccess,onError,ioError)
		end
	end,true)
end

function EmbattleDialog:reset(target)
	local x,y = self.placeList[target.idx]:getPosition()
	print("EmbattleDialog:reset","id="..target.idx,"x="..x,"y="..y)
	local act = cc.MoveTo:create(0.1,cc.p(x,y))
	local seq = cc.Sequence:create(act,cc.CallFunc:create(function()
		-- self.tankList[target.idx] = target
		target:endDrag()
	end))
	target:runAction(seq)
end

-- 判断是否为抗日远征专属
function EmbattleDialog:isForFightJapan()
	return qy.tank.model.UserInfoModel.isInFightJapan
end

function  EmbattleDialog:showTankExtendStatus(tank , entity)

	if not self:isForFightJapan() then return end --如果当前布阵不隶属于远征则，不处理

	local expeGaraModel = qy.tank.model.FightJapanGarageModel
	local tankExData = expeGaraModel:getTankExtendDataByTankUId(entity.unique_id)
	local totalMorale= expeGaraModel:getTotalMorale()
	local isDied = false
	if tankExData == nil then
		tank:showBloodAndMorale(true , isDied)
		tank:updateMorale(0 , 4)
	else
		isDied = tankExData.status == 1 and true or false
		tank:showBloodAndMorale(true , isDied)
		tank:updateHp(tankExData.current_blood, 1)
		tank:updateMorale(tankExData.morale , 4)
	end
end

function EmbattleDialog:createEffert(_target)
    local _effert = ccs.Armature:create("yuanzhengjiantou")
    _target:addChild(_effert,999)
    _effert:setPosition(170,80)
    _effert:getAnimation():playWithIndex(0)
    return _effert
end

function EmbattleDialog:onEnter()
	EmbattleDialog.super.onEnter(self)
	-- self.panel:setTouchEnabled(true)
	-- self.panel:setSwallowTouches(true)

	if self:isForFightJapan() then
		self:createEffert(self.goBtn)
	end
	--新手引导：注册控件
	qy.GuideCommand:addUiRegister({
		{["ui"] = self.p3, ["step"] = {"SG_62"}},
		{["ui"] = self.closeBtn, ["step"] = {"SG_65"}},
	})

end

function EmbattleDialog:onExit()
	--新手引导：移除控件注册
	qy.GuideCommand:removeUiRegister({"SG_62","SG_65"})
end

function EmbattleDialog:onCleanup()
	print("EmbattleDialog:onCleanup")
	-- tank avatar素材
	-- local delay = qy.tank.utils.Timer.new(2,1,function()
	-- 	for i=1,58 do
	-- 		qy.tank.utils.cache.CachePoolUtil.removePlist("tank/avatar/t"..i)
	-- 	end
	-- end)
	-- delay:start()
    -- qy.tank.utils.cache.CachePoolUtil.removePlist("Resources/garage/garage",1)
end

return EmbattleDialog
