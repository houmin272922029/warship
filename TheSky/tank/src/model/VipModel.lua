--[[
	VIP数据模型
	Author: Your Name
	Date: 2015-06-13 15:04:55
]]

local VipModel = qy.class("VipModel", qy.tank.model.BaseModel)

VipModel.awardList = nil
VipModel.privilegeList = nil
VipModel.priceList = nil
VipModel.list = nil

local StringUtil = qy.tank.utils.String
local ColorMapUtil = qy.tank.utils.ColorMapUtil

function VipModel:init()
	self.awardList = {}
	for k,v in pairs(qy.Config.vip_award) do
		table.insert(self.awardList,v)
	end

	table.sort(self.awardList,function(a,b)
		return tonumber(a.vip_level) < tonumber(b.vip_level)
	end)

	self.priceList = {}
	for k,v in pairs(qy.Config.vip_price) do
		table.insert(self.priceList,v)
	end

	table.sort(self.priceList,function(a,b)
		return tonumber(a.vip_level) < tonumber(b.vip_level)
	end)

	self.privilegeList = {}
	for k,v in pairs(qy.Config.vip_privilege) do
		table.insert(self.privilegeList,v)
	end

	table.sort(self.privilegeList,function(a,b)
		return tonumber(a.vip_level) < tonumber(b.vip_level)
	end)

	self.list = {}
	for i=1,#self.privilegeList do
		local item = {}
		item.level = i
		item.price = self.priceList[i].amount
		item.diamond = self.priceList[i].diamond
		item.daily_award = self.awardList[i].daily_award
		item.gift_award = self.awardList[i].gift_award
		item.privilege = {}

		for j=1,6 do
			if self.privilegeList[i]["desc_"..j] then
				local privilege = {}
				privilege.type = self.privilegeList[i]["type_"..j]
				privilege.param = self.privilegeList[i]["param_"..j]
				privilege.desc = self:getDescInfoByStr(self.privilegeList[i]["desc_"..j])
				table.insert(item.privilege,privilege)
			end
		end
		table.insert(self.list,item)
	end
	self:initEnergyLimit()
	self:initTrainAreaOpenVipLevel()
	self:initTrainAreaUpgradeVipLevel()
	self:initExpeditionRaised()
	self:initBatchUpAlloyVipLevel()
	self:initSoldiersWarBuyTimes()
	self:initGroupBattlesBuyTimes()
	self:initTechnologyBuyTimes()
	self:initEndlessWarBuytimes()
end

--初始化一键升级和金的 vip 等级
function VipModel:initBatchUpAlloyVipLevel()
	self._batchUpAlloyVipLevel = 0
	for i=1,#self.privilegeList do
        for j = 1, 6 do
			--18： vip 特权开启一键合金
            if tonumber(self.privilegeList[i]["type_" .. j]) == 18 then
                self._batchUpAlloyVipLevel = i
            end
        end
    end
end


--初始化将士之战购买次数
function VipModel:initSoldiersWarBuyTimes()
	self._soldiersWarBuyTimes = {}
	self._soldiersWarBuyTimes[0] = 0
	for i=1,#self.privilegeList do
        for j = 1, 6 do
			--19： vip 将士之战购买次数
            if tonumber(self.privilegeList[i]["type_" .. j]) == 19 then
                self._soldiersWarBuyTimes[i] = self.privilegeList[i]["param_"..j]
            end
        end

        if i == 1 and self._soldiersWarBuyTimes[i] == nil then
        	self._soldiersWarBuyTimes[i] = 0
        elseif self._soldiersWarBuyTimes[i] == nil then
        	self._soldiersWarBuyTimes[i] = self._soldiersWarBuyTimes[i - 1]
        end
    end
end


function VipModel:getSoldierWarBuyTimes()
	return self._soldiersWarBuyTimes

end

--初始化无尽战斗购买次数
function VipModel:initEndlessWarBuytimes()
	self._endlessrBuyTimes = {}
	self._endlessrBuyTimes[0] = 0
	for i=1,#self.privilegeList do
        for j = 1, 6 do
			--19： vip 将士之战购买次数
            if tonumber(self.privilegeList[i]["type_" .. j]) == 25 then
                self._endlessrBuyTimes[i] = self.privilegeList[i]["param_"..j]
            end
        end

        if i == 1 and self._endlessrBuyTimes[i] == nil then
        	self._endlessrBuyTimes[i] = 0
        elseif self._endlessrBuyTimes[i] == nil then
        	self._endlessrBuyTimes[i] = self._endlessrBuyTimes[i - 1]
        end
    end
end


function VipModel:getEndlessBuyTimes()
	return self._endlessrBuyTimes

end


--初始化科技武装次数
function VipModel:initTechnologyBuyTimes()
	self._kejiwuzhuang = {}
	self._kejiwuzhuang[0] = 0
	self._kejiwuzhuang_5 = 0
	self._kejiwuzhuang_10 = 0
	for i=1,#self.privilegeList do
        for j = 1, 6 do
			--24
            if tonumber(self.privilegeList[i]["type_" .. j]) == 24 then
                self._kejiwuzhuang[i] = self.privilegeList[i]["param_"..j]

                if self._kejiwuzhuang[i] == 5 then
                	self._kejiwuzhuang_5 = i
                elseif self._kejiwuzhuang[i] == 10 then
                	self._kejiwuzhuang_10 = i
                end
            end
        end

        if i == 1 and self._kejiwuzhuang[i] == nil then
        	self._kejiwuzhuang[i] = 0
        elseif self._kejiwuzhuang[i] == nil then
        	self._kejiwuzhuang[i] = self._kejiwuzhuang[i - 1]
        end
    end
end


function VipModel:getTechnologyBuyTimes()
	return self._kejiwuzhuang

end

function VipModel:getTechnology5Level()
	return self._kejiwuzhuang_5

end


function VipModel:getTechnology10Level()
	return self._kejiwuzhuang_10

end



--初始化多人副本购买次数
function VipModel:initGroupBattlesBuyTimes()
	self._groupBattlesBuyTimes = {}
	self._groupBattlesBuyTimes[0] = 0
	for i=1,#self.privilegeList do
        for j = 1, 6 do
			--23 vip 多人副本购买次数
            if tonumber(self.privilegeList[i]["type_" .. j]) == 23 then
                self._groupBattlesBuyTimes[i] = self.privilegeList[i]["param_"..j]
            end
        end

        if i == 1 and self._groupBattlesBuyTimes[i] == nil then
        	self._groupBattlesBuyTimes[i] = 0
        elseif self._groupBattlesBuyTimes[i] == nil then
        	self._groupBattlesBuyTimes[i] = self._groupBattlesBuyTimes[i - 1]
        end
    end
end


function VipModel:getGroupBattlesBuyTimes()
	return self._groupBattlesBuyTimes

end




function VipModel:getBatchUpAlloyVipLevel()
	return self._batchUpAlloyVipLevel
end

function VipModel:getMAxVipLevel()
	if self.list then
		return #self.list
	else
		return 0
	end
end

function VipModel:getDescInfoByStr(_str)
	local infoArr = {}

	local _arr = StringUtil.split(_str, "&")
	if _arr == nil or #_arr == 0 then
		return infoArr
	end

	infoArr.txt = {}
	infoArr.color = {}

	if #_arr == 1 then
		infoArr.type = 1
		-- print("_arr _arr _arr _arr _arr===",_arr[1])
		local _arr2 = StringUtil.split(_arr[1], "#")
		-- print("_arr2 _arr2 _arr2 _arr2 _arr2===",qy.json.encode(_arr2))
		infoArr.txt[1] = _arr2[1]
		infoArr.color[1] = ColorMapUtil.qualityMapColor(tonumber(_arr2[2]) or 1)
		-- print("color color color color color===",qy.json.encode(infoArr.color[1]))
	else
		infoArr.type = _arr[1]
		for i = 2, #_arr do
			-- print("_arr _arr _arr _arr _arr===",_arr[i])
			local _arr2 = StringUtil.split(_arr[i], "#")
			-- print("_arr2 _arr2 _arr2 _arr2 _arr2===",qy.json.encode(_arr2))
			infoArr["txt"][i-1] = _arr2[1]
			infoArr["color"][i-1] = ColorMapUtil.qualityMapColorFor3b(tonumber(_arr2[2]) or 1)
			-- print("color color color color color=self==",qy.json.encode(infoArr.color[i-1]))
		end
	end

	return infoArr
end

--初始化体力上限
function VipModel:initEnergyLimit()
	self.energyLimit = {}
	for i=1,#self.privilegeList do
        for j = 1, 6 do
            if self.privilegeList[i]["type_" .. j] == 1 then
                local num = self.privilegeList[i]["param_" .. j]
                self.energyLimit[i] = num
            end
        end
        if self.energyLimit[i] == nil then
        	self.energyLimit[i] = self.energyLimit[i - 1]
        end
    end
end

function VipModel:getEnergyLimitByVipLevel(_level)
	if self.energyLimit[_level] then
		return self.energyLimit[_level]
	else
		return 190
	end
end

--初始化远征复活次数
function VipModel:initExpeditionRaised()
	self.expeRaised = {}
	local index = 1
	for i=1,#self.privilegeList do
        for j = 1, 6 do
            if self.privilegeList[i]["type_" .. j] == 6 then
                index = self.privilegeList[i]["param_" .. j]
            end
        end
		self.expeRaised[i] = index
		-- print("self.expeRaised[" ..i .. "]====>>>>",self.expeRaised[i])
    end
end

function VipModel:getRaisedNumByVipLevel(_vipLevel)
	if _vipLevel == nil then
		_vipLevel = qy.tank.model.UserInfoModel.userInfoEntity.vipLevel
	end
	-- print("_vipLevel=======>>>>",_vipLevel)
	return self.expeRaised[_vipLevel]
end

--初始化训练位开启等级
function VipModel:initTrainAreaOpenVipLevel()
	self.openTrainAreaVipLevel = {0,0,0,0,0,0,0}
	for i=1,#self.privilegeList do
        for j = 1, 6 do
            if self.privilegeList[i]["type_" .. j] == 3 then
                local index = self.privilegeList[i]["param_" .. j]
                self.openTrainAreaVipLevel[index] = self.privilegeList[i].vip_level
            end
        end
    end
end

function VipModel:getTrainAreaOpenVipLevelByIndex(_idx)
	return self.openTrainAreaVipLevel[tonumber(_idx)]
end

--初始化训练位升级VIP
function VipModel:initTrainAreaUpgradeVipLevel()
	self.upgradeTrainAreaVipLevel = {}
	for i=1,#self.privilegeList do
        for j = 1, 6 do
            if self.privilegeList[i]["type_" .. j] == 4 then
                local index = self.privilegeList[i]["param_" .. j]
                self.upgradeTrainAreaVipLevel[index .. ""] = self.privilegeList[i].vip_level
            end
        end
    end
end

function VipModel:getUpgradeTrainAreaVipLevelByIndex(index)
	if self.upgradeTrainAreaVipLevel[index .. ""] then
		return self.upgradeTrainAreaVipLevel[index .. ""]
	else
		return 0
	end
end

--[[--
	vip特权显示的index
	规则：例如现在是vip5
	如果现在vip5的奖励没领，则停在vip5，如果已领取，则看vip4是否yilingq
	如果vip1~vip5都领取了，则停留在vip6
--]]
function VipModel:getShowPrivileIndex()
	local max_num = #self.privilegeList
	local u_entity = qy.tank.model.UserInfoModel.userInfoEntity
	local re_index = 0
	local get_index = 0
	for i=1, max_num do
		if (u_entity.payment_diamond_added) / 10 >= self.list[max_num - i + 1]["price"] then
			--可领取
			if re_index == 0 then
				re_index = max_num - i + 1
			end
			if u_entity.gift[tostring(self.list[max_num - i + 1]["level"])] == nil then
				return max_num - i + 1
			end
		end
	end
	if re_index < max_num then
		return re_index + 1
	else
		return max_num
	end
end

return VipModel
