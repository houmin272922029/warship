--[[--
--运营活动列表dialog
--Author: H.X.Sun
--Date: 2015-06-24
--]]--

local ActivitiesList = qy.class("ActivitiesList", qy.tank.view.BaseDialog, "view/operatingActivities/ActivitiesList1")

function ActivitiesList:ctor(delegate)
    ActivitiesList.super.ctor(self)

    cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/operatingActivities/icon/activityIcon.plist")
    self.isPopup = false
	self:InjectView("bg")
	self:InjectView("list")--
	self:InjectView("listBg")
	self:InjectView("listBg2")
	self:InjectView("panel_1")
	self:InjectView("listbgs")
	self.panel_1:setScale(0.1)
	-- self.list:setSwallowTouches(false)
	self.bg:setContentSize(qy.winSize)
	self.model = qy.tank.model.OperatingActivitiesModel
	local aType = qy.tank.view.type.ModuleType


    
	self:__createList()

	self:OnClick("bg",function(sender)
		self:dismiss()
	end)

	self:OnClick("closeBtn",function(sender)
		self:dismiss()
	end,{["isScale"] = false})

	-- for i = 1, #self.btnList do
	-- 	self.btnList[i].bg:setPosition(self.btnList[i]:getPosition())
	-- 	self:OnClick(self.btnList[i],function(sender)
	-- 		print("------------------------",self.touchType)
	-- 		if self.touchType == true then
	-- 		local name = self.model:getActivityIndex()[i]
	-- 			qy.tank.command.ActivitiesCommand:showActivity(name,{["callBack1"] = function ()
	-- 				self:dismiss()
	-- 			end})
	-- 		end
	-- 	end)
	self:setBGOpacity(0)
end

function ActivitiesList:__createList()
	self.btnList = {}
	self.actIndexArr = clone(self.model:getActivityIndex())

	local len = 3
	if #self.actIndexArr > 6 then
		len = 4
	end
	local cellW = 135
	local cellH = 125
	local x = cellW / 2
	local listH = cellH * math.ceil(#self.actIndexArr / len)
	local y = listH + cellH / 2
	local listW = cellW * len
    local btn



	for i = 1, #self.actIndexArr do
		if cc.SpriteFrameCache:getInstance():getSpriteFrame("Resources/operatingActivities/icon/"..self.actIndexArr[i]..".png") then
			-- btn = ccui.ImageView:create("Resources/operatingActivities/icon/"..self.actIndexArr[i]..".png",ccui.TextureResType.plistType)
			btn = qy.tank.view.operatingActivities.ActivityItem.new({
				["data"] = self.actIndexArr[i],
				["callBack"] = function ()
					self:dismiss()
				end
			})
            table.insert(self.btnList,btn)
            -- self.btn:setSwallowTouches(true)
   --          local bg = cc.Sprite:createWithSpriteFrameName("Resources/main_city/16.png")
			-- self.btn.bg = bg
			-- self.listBg:addChild(bg)
			self.listbgs:addChild(btn)
		else
			if qy.DEBUG then
				print("出错 " .. self.actIndexArr[i])
				qy.hint:show("ActivitiesList"..qy.TextUtil:substitute(63036) .. "  " .. self.actIndexArr[i])
			end
            self.model:removeNoIconActivity(self.actIndexArr[i])
		end
	end

	qy.tank.utils.TileUtil.arrange(self.btnList, len, cellW ,cellH,cc.p(x,y),1)
	print("宽"..listW.."高"..listH.."个数",#self.actIndexArr)
	self.list:setInnerContainerSize(cc.size(listW,listH))
	self.listbgs:setContentSize(listW, listH)
	self.listbgs:setPosition(cc.p(listW,listH))
	if #self.actIndexArr > 12 then
		if self.list.setScrollBarEnabled then
        	self.list:setScrollBarEnabled(true)
    	end
   		self.list:setScrollBarColor(cc.c3b(245, 139, 12))
   	 	self.list:setScrollBarOpacity(180)
    	self.list:setScrollBarAutoHideEnabled(false)
		local listH1 = 3 * 125 + 60
		self.listBg:setContentSize(listW+20, listH1+20)
		self.list:setPosition(405, 240)
		-- self.listBg:setPosition(cc.p(listW,listH1))
		self.list:setContentSize(cc.size(listW+23,listH1))
		self.listBg2:setContentSize(listW + 5, listH1+10)
	else
		if self.list.setScrollBarEnabled then
        	self.list:setScrollBarEnabled(false)
    	end
		self.list:setContentSize(cc.size(listW,listH))
		self.listBg2:setContentSize(listW - 15, listH +10)
		self.listBg:setContentSize(listW, listH+20)
		self.list:setPosition(402, 240)
		-- self.listBg:setPosition(cc.p(listW,listH))
    end
    self.list:jumpToTop()

	
end

function ActivitiesList:onEnter()
	local _uiTable = {}
	for i = 1, #self.btnList do
		_uiTable[self.actIndexArr[i]] = self.btnList[i]
	end
	qy.RedDotCommand:addSignal(_uiTable)
	qy.RedDotCommand:initActivitiesRedDot()

	self.panel_1:runAction(cc.ScaleTo:create(0.2, 1))

end

function ActivitiesList:onExit()
	qy.RedDotCommand:removeSignal({qy.RedDotType.A})
	qy.tank.model.RedDotModel:updateOpActivityRedDot()
end

return ActivitiesList
