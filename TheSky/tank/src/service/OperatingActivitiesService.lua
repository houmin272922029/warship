--[[--
--运营活动 service
--Author: H.X.Sun
--Date: 2015-06-24
--]]

local OperatingActivitiesService = qy.class("OperatingActivitiesService", qy.tank.service.BaseService)

OperatingActivitiesService.model = qy.tank.model.OperatingActivitiesModel
local soulModel = qy.tank.model.SoulModel
local StorageModel = qy.tank.model.StorageModel

function OperatingActivitiesService:getList(callback)
	qy.Http.new(qy.Http.Request.new({
		["m"] = "Activity.getList",
		["p"] = {}
	})):send(function(response, request)
		self.model:initList(response.data)
		callback(response.data)
	end)
end

function OperatingActivitiesService:getInfo(name , callback)
	qy.Http.new(qy.Http.Request.new({
		["m"] = "Activity.getInfo",
		["p"] = {["activity_name"] = name}
	})):send(function(response, request)
		self.model:initInfo(name , response.data)
		callback(response.data)
	end)
end

function OperatingActivitiesService:getInfo2(name,callback)
	qy.Http.new(qy.Http.Request.new({
		["m"] = "Activity.reset_gunner_train"
		
	})):send(function(response, request)
		self.model:initInfo(name , response.data)
		callback(response.data)
	end)
end


-- showType：获得奖励显示类型。  默认 弹出获得窗口   none代表不弹窗 isAdd -- 不添加奖励
function OperatingActivitiesService:getCommonGiftAward(index,name, isShowLoading, callback, isShowAward, op, isAdd,category)
	local param = {}
	if type(index) == "table" then
		param = index
	else
		param = index == nil and   {["activity_name"] = name} or {["id"] = index, ["activity_name"] = name}
		if param == nil then
			param = {}
		end

		if op then  --精铁矿买用到
			param.op = op
		end
		if category then
			param.category = category
		end
	end
	-- param["ftue"] = qy.GuideModel:getCurrentBigStep()
	qy.Http.new(qy.Http.Request.new({
		["m"] = "Activity.getaward",
		["p"] = param

	}))
	:setShowLoading(isShowLoading)
	:send(function(response, request)
		local activity = qy.tank.view.type.ModuleType
		if name == activity.LOGIN_GIFT then
			self.model:updateLoginGiftStatus(response.data)
		elseif name == activity.OPEN_SERVER_GIFT_BAG then
			self.model:updateServerGiftStatus(response.data)
		elseif name == activity.ARNY_ASSAULT then
			if response.data.activity_info then
				self.model:updateArnyAssauktGiftStatus(response.data.activity_info.giftnum)
			end
			-- if response.data.weight then
			-- 	self.model:updateArnyAssauktGiftCrit(response.data.weight)
			-- end
		elseif name == activity.UP_FUND then
			self.model:initInfo(name , response.data, 1)
		elseif name == activity.PUB then
			self.model:updatePub(response.data)
		elseif name == activity.MARKET then
			--黑市
			if response.data.list then
				self.model:updateMarkData(response.data.list)
			end
		elseif name == activity.GUNNER_TRAIN then
			self.model:initInfo(name , response.data, 1)
		elseif name == activity.IRON_MINE then
			self.model:initInfo(name , response.data)
		elseif name == activity.LUCKY_CAT then
			self.model:initInfo(name , response.data)
		elseif name == activity.ASSEMBLY then
			self.model:updateAssembly(response.data)
		elseif name == activity.HEAD_TREASURE then
			self.model:updateHeadTreasure(response.data)
		elseif name == activity.ALL_RECHARGE then
			self.model:updateAllRecharge(response.data.all_recharge)
		elseif name == activity.OUTSTANDING then
			self.model:updateOutStanding(response.data.activity_info)
		elseif name == activity.SEARCH_TREASURE then
			self.model:updateSearchTreasure(response.data.search_treasure)
		elseif name == activity.QUIZ then
			self.model:updateQuiz(response.data.quiz)
		elseif name == activity.GROUPPURCHASE then
			self.model:updateGroupPurchase(response.data.grouppurchase)
		elseif name == activity.RECHARGE_DOYEN then
			self.model:updateRechargeDoyen(response.data)
		elseif name == activity.EARTH_SOUL then
			self.model:updateEarthSoul(response.data)
		elseif name == activity.ACHIEVE_SHARE then
			self.model:updateTempData(response.data.list)
		elseif name == activity.DISCOUNT_SALE then
			self.model:updateDiscountData(response.data.goodlist)
		elseif name == activity.LUCKY_INDIANA then
			self.model:updateLuckyIndianaData(response.data)
		end
		if isShowAward == nil then
			isShowAward = true
		end

		if response.data.award then
			if not isAdd then
				print("添加道具")
				qy.tank.command.AwardCommand:add(response.data.award)
			end
			self.model:setAward(response.data.award)
			if isShowAward then
				qy.tank.command.AwardCommand:show(response.data.award,{["critMultiple"] = response.data.weight})
			end
		end
		callback(response.data)
	end)
end
function OperatingActivitiesService:getCommonGiftAwards(index,name, isShowLoading, callback, isShowAward, op, isAdd,category)
	local param = {}
	if type(index) == "table" then
		param = index
	else
		param = index == nil and   {["activity_name"] = name} or {["id"] = index, ["activity_name"] = name}
		if param == nil then
			param = {}
		end
	end
	if category then
		param.category = category
	end
	qy.Http.new(qy.Http.Request.new({
		["m"] = "Activity.getaward",
		["p"] = param

	}))
	:setShowLoading(isShowLoading)
	:send(function(response, request)
		if isShowAward == nil then
			isShowAward = true
		end
		if response.data.award then
			if not isAdd then
				qy.tank.command.AwardCommand:add(response.data.award)
			end
			self.model:setAward(response.data.award)
			if isShowAward then
				qy.tank.command.AwardCommand:show(response.data.award,{["critMultiple"] = response.data.weight})
			end
		end
		callback(response.data)
	end)
end
function OperatingActivitiesService:getaward( type,id ,callback)
	qy.Http.new(qy.Http.Request.new({
		["m"] = "Activity.getaward",
		["p"] = {
			["activity_name"] = "seven_days_happy",
			["type"] = type,
			["id"] = id,
		}
	})):send(function(response, request)
		qy.tank.command.AwardCommand:add(response.data.award)
		qy.tank.command.AwardCommand:show(response.data.award)
		self.model:updatechrismasdata(response.data)
		callback(response.data)
	end)
end
function OperatingActivitiesService:getsectionaward( cash,callback)
	qy.Http.new(qy.Http.Request.new({
		["m"] = "Activity.getaward",
		["p"] = {
			["activity_name"] = "recharge_section",
			["cash"] = cash
		}
	})):send(function(response, request)
		qy.tank.command.AwardCommand:add(response.data.award)
		qy.tank.command.AwardCommand:show(response.data.award)
		callback(response.data)
	end)
end
function OperatingActivitiesService:buyFund(callback)
	qy.Http.new(qy.Http.Request.new({
		["m"] = "Activity.buy_up_fund",
	})):send(function(response, request)
		self.model:updateFund(response.data)
		callback(response.data)
	end)
end

function OperatingActivitiesService:doWarAidAction(param,callback)
	-- type=1 是援助 id=1,2,3 分别对应陆海空，box=1,2,3,4 分别对应捐助1次 9次 99次 999次
	-- type=2 是开大礼 id=1,2,3 分别对应陆海空，num是开大礼的数量

	qy.Http.new(qy.Http.Request.new({
		["m"] = "Activity.getaward",
		["p"] = {
			["activity_name"] = "war_aid",
			["type"] = param.type,
			["id"] = param.id,
			["box"] = param.box,
			["num"] = param.num,
		}
	})):send(function(response, request)
		if param.type == 1 then
			StorageModel:remove(self.model.prop_id_list[param.box],1)
		else
			qy.tank.command.AwardCommand:add(response.data.award)
		end
		self.model:updateWarAidInfo(response.data)
		callback(response.data)
	end)
end

function OperatingActivitiesService:pubAchieveReward(id, callback)
	qy.Http.new(qy.Http.Request.new({
		["m"] = "Activity.pub_achieve",
		["p"] = {
			["id"] = id,
		}
	})):send(function(response, request)
		callback(response.data)
	end)
end

function OperatingActivitiesService:refreshMarket(sPos , callback)
	qy.Http.new(qy.Http.Request.new({
		["m"] = "Activity.refresh_market",
		["p"] = {["pos"] = sPos}
	})):send(function(response, request)
		if response.data.list then
			self.model:updateMarkData(response.data.list)
		end
		self.model:updateFreeRefreshTimes(response.data)
		callback(response.data)
	end)
end

function OperatingActivitiesService:getSevenDayAward(callback)
	qy.Http.new(qy.Http.Request.new({
		["m"] = "Activity.seven_day_end",
		["p"] = {}
	})):send(function(response, request)
		self.model:updateGetTankStatus(2)
		qy.tank.command.AwardCommand:show(response.data.award)
		callback(response.data)
	end)
end

function OperatingActivitiesService:getTenCheers(callback)
	qy.Http.new(qy.Http.Request.new({
		["m"] = "Activity.many_jiuguan",
	})):send(function(response, request)
		self.model:updatePub(response.data)
		qy.tank.command.AwardCommand:add(response.data.award)
		qy.tank.command.AwardCommand:show(response.data.award)
		callback(response.data)
	end)

end

function OperatingActivitiesService:getStartQuiz(status,titleId,answerId,callback)
	qy.Http.new(qy.Http.Request.new({
		["m"] = "Activity.quiz",
		["p"] = {
			["status"] = status,
			["titleid"] = titleId,
			["answerid"] = answerId,
		}
	}))
	:setShowLoading(false)
	:send(function(response, request)
		self.model:updateQuizData(response.data)
		qy.tank.command.AwardCommand:add(response.data.award)

		callback(response.data)
	end)

end

function OperatingActivitiesService:getGroupPurchase(goodid,callback)
	qy.Http.new(qy.Http.Request.new({
		["m"] = "Activity.grouppurchase",
		["p"] = {
			["goodid"] = goodid,
		}
	}))
	:setShowLoading(true)
	:send(function(response, request)
		self.model:updateGroupPurchase(response.data)
		qy.tank.command.AwardCommand:add(response.data.award)
		qy.tank.command.AwardCommand:show(response.data.award)
		callback(response.data)
	end)

end
function OperatingActivitiesService:setAchieveSharestatus(id,callback)
	qy.Http.new(qy.Http.Request.new({
		["m"] = "activity.achieveshare",
		["p"] = {
			["id"] = id,
		}
	})):send(function(response, request)
		self.model:updateTempData(response.data.list)
		callback(response.data.list)
	end)

end

function OperatingActivitiesService:doMilitaryAction(param,callback)
	-- type 1累计登录 2充值豪礼 3整备行动 4超值折扣 5军资商店
	-- id 配置表的id
	qy.Http.new(qy.Http.Request.new({
		["m"] = "Activity.getaward",
		["p"] = {
			["activity_name"] = "military_supply",
			["type"] = param.type,
			["id"] = param.id,
		}
	})):send(function(response, request)
		qy.tank.command.AwardCommand:add(response.data.award)
		self.model:updateMilitaryData(response.data,param.type)
		callback(response.data)
	end)
end
function OperatingActivitiesService:BuyDicountSale( id,callback )
	-- 折扣贩售接口 id表示第几个
	qy.Http.new(qy.Http.Request.new({
		["m"] = "activity.discount_pay",
		["p"] = {
			["good_id"] = id,
		}
	})):send(function(response, request)
		self.model:updateDiscountData(response.data.goodlist)
		qy.tank.command.AwardCommand:add(response.data.award)
		qy.tank.command.AwardCommand:show(response.data.award)
		callback(response.data)
	end)
end

return OperatingActivitiesService
