--[[--
--黑市dialog
--Author: H.X.Sun
--Date: 2015-10-13
--]]--

local MarketDialog = qy.class("MarketDialog", qy.tank.view.BaseDialog, "market/ui/MainView")

function MarketDialog:ctor()
	MarketDialog.super.ctor(self)
	-- self:InjectView("container")
	self:InjectView("blue_iron")
	self:InjectView("purple_iron")
	self:InjectView("orange_iron")
	self:InjectView("time")
	self:InjectView("re_icon")
	self:InjectView("refresh_btn")
	self.userEntity = qy.tank.model.UserInfoModel.userInfoEntity
	self.model = qy.tank.model.OperatingActivitiesModel

	self:OnClick("refresh_btn", function(sender)
		print("刷新 refresh_btn")
		local _str = self:getRefreshList()
		if self.hasSecTips then
			qy.alert:show(
            	{qy.TextUtil:substitute(57004) ,{255,255,255} } ,
            	{{id=1,color={255,255,255},alpha=255,text=qy.TextUtil:substitute(57005),font="Arial",size=24}} ,
            		cc.size(533 , 260) ,{{qy.TextUtil:substitute(57006) , 4} , {qy.TextUtil:substitute(57007) , 5} } ,
            	function(flag)
                	if qy.TextUtil:substitute(57007) == flag then
                		self:setRefreshLogic(_str)
                	end
            end)
		else
			self:setRefreshLogic(_str)
		end
    end)

    self:OnClick("closeBtn", function(sender)
    	self:removeSelf()
    end)

	self.cell_arr = {}
	local arr = self.model:getTickVisible()
    for i = 1, 3 do
    	self:InjectView("container_"..i)
    	self.cell_arr[i] = require("market.src.MarketCell").new({["idx"] = i})
    	self["container_"..i]:addChild(self.cell_arr[i])
    	self.cell_arr[i]:setTickShowOrNot(arr[i] or false)
    end
    self:updateRefreshBtn()
    -- self:__updateTick()
end

-- function MarketDialog:__updateTick()
	
-- 	for i = 1, #self.cell_arr do
-- 		self.cell_arr[i]:setTickShowOrNot(arr[i] or false)
-- 	end

-- end

function MarketDialog:updateRefreshBtn()
	local free_times = self.model:getFreeRefreshTimes()
	if free_times > 0 then
		self.re_icon:setVisible(false)
		self.refresh_btn:setTitleText(qy.TextUtil:substitute(57008).. free_times .. qy.TextUtil:substitute(57009))
	else
		self.re_icon:setVisible(true)
		self.refresh_btn:setTitleText(qy.TextUtil:substitute(57010))
	end
end

function MarketDialog:setRefreshLogic(_str)
	qy.tank.service.OperatingActivitiesService:refreshMarket(_str,function (data)
		self:updateList()
		self:updateRefreshBtn()
	end)
end

function MarketDialog:updateList()
	for i = 1, #self.cell_arr do
		self.cell_arr[i]:update(i)
	end
end

function MarketDialog:getRefreshList()
	self.hasSecTips = false 
	local _str = ""
	for i = 1, #self.cell_arr do
		if not self.cell_arr[i]:isTickShow() then
			if self.cell_arr[i]:isLowDiscount() then
				self.hasSecTips = true
			end
			if _str ~= "" then
				_str = _str .. "-"
			end
			_str = _str .. i
		end
	end
	return _str
end

function MarketDialog:updateResource()
	self.blue_iron:setString(self.userEntity:getBlueIronStr())
	self.purple_iron:setString(self.userEntity:getPurpleIronStr())
	self.orange_iron:setString(self.userEntity:getOrangeIronStr())
end

function MarketDialog:updateTime()
	self.time:setString(self.model:getMarketPayRemainTime())
end

function MarketDialog:onEnter()
	self:updateResource()
    self:updateTime()
	--用户资源数据更新
    if self.userResourceDatalistener == nil then
        self.userResourceDatalistener = qy.Event.add(qy.Event.USER_RESOURCE_DATA_UPDATE,function(event)
            self:updateResource()
        end)
    end
	self.timeListener = qy.Event.add(qy.Runtime.TIMER_UPDATE,function(event)
		self:updateTime()
	end)
end

function MarketDialog:onExit()
	qy.Event.remove(self.userResourceDatalistener)
	qy.Event.remove(self.timeListener)
	self.userResourceDatalistener = nil
	self.timeListener = nil
end

return MarketDialog