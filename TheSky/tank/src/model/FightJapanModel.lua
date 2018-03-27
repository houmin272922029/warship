--[[
    抗日远征model
    add by lianyi
]]
local FightJapanModel = qy.class("FightJapanModel", qy.tank.model.BaseModel)

--鼓舞数据
local encourageInfo = nil
local encourageConfig = nil
local exchangeInfo = nil
FightJapanModel.buyWhiskyCountCurrent = 1
FightJapanModel.buyWhiskyCountMax = 25
FightJapanModel.autoOpen = ""


-----------------------远征鼓舞相关-----------------------------
--更新鼓舞数据
function FightJapanModel:updateEncourage(data)
    encourageInfo = data.encourageInfo
    encourageConfig = data.config
end

--获取鼓舞数据
function FightJapanModel:getEncourageInfo()
	return encourageInfo
end

--获取远征配置数据
function FightJapanModel:getEncourageConfig()
	return encourageConfig
end


-----------------------远征商店相关-----------------------------
--更新商店数据
function FightJapanModel:updateExchange( data )
    exchangeInfo = data.shopInfo
end

--获取商店数据
function FightJapanModel:getExchangeInfo(  )
	return exchangeInfo
end

--获取商店配置数据总长度
function  FightJapanModel:getExchangeConfigDataLength( )
	local count = 0
	for tempId,itemData in pairs(self.exchageConfigData) do
		count = count +1
	end
	return count
end

--通过id获取某一商店配置数据
function  FightJapanModel:getExchangeItemConfigDataById(id)
	for tempId,itemData in pairs(self.exchageConfigData) do
		if tonumber(tempId) == tonumber(id) then
			return itemData
		end
	end

	return nil
end

function  FightJapanModel:getExchangeItemUserDataById(id)
	if exchangeInfo == nil or #exchangeInfo<1 then return nil end
	local itemData = nil
	for i=1,#exchangeInfo do

		itemData = exchangeInfo[i]
		if tonumber(itemData.id) == tonumber(id) then
			return itemData
		end
	end
	return nil
end

----------------------远征商店-----------------------------------------
function FightJapanModel:initExpeditionGoods()
	local data = qy.Config.expedition_shop
	if self.expeditionGoodsList == nil or #self.expeditionGoodsList < 1 then
		self.expeditionGoodsList = {}
		for _k, _v in pairs(data) do
			local _goodsId = data[_k].id
			self.expeditionGoodsList[_goodsId] = data[_k]
			self.expeditionGoodsList[_goodsId].remain_times = 1
		end
	end
end

function FightJapanModel:getExpeditionGoodsNum()
	if self.expeditionGoodsList then
		return #self.expeditionGoodsList
	end
end

function FightJapanModel:updateExGoodsByData(data)
	-- TODO shopInfo type
	local _goodsId = data.id
	if self.expeditionGoodsList and self.expeditionGoodsList[_goodsId] then
		self.expeditionGoodsList[_goodsId].remain_times = data.remain_times
	end
end

function FightJapanModel:updateExpeditionGoodsList(data)
	if self.expeditionGoodsList == nil or #self.expeditionGoodsList < 1 then
		self:initExpeditionGoods()
	end
	if data.shopInfo and #data.shopInfo > 0 then
		for i = 1, #data.shopInfo do
			self:updateExGoodsByData(data.shopInfo[i])
		end
	end
end

function FightJapanModel:getExGoodsByIndex(_i)
	return self.expeditionGoodsList[_i]
end

---------------------远征地图-----------------------------------

function FightJapanModel:updateExDataByIdx(_i)
	if self.expeEnemyList and self.expeEnemyList[_i] then
		self.expeEnemyList[_i].is_pass = 1
		if self.expeEnemyList[_i + 1] then
			self.expeEnemyList[_i + 1].is_open = 1
			self.currentIndex = _i + 1
		else
			self.currentIndex = -1
		end
	end
end

function FightJapanModel:initExpeData(data)
    self.RaisedNum = data.fuhuo_times
	self.remainTimes = data.remain_times
	self.expeEnemyList = {}
	self.enemyIndex = 0
	self.currentIndex = -1
	for i = 1, #data.expedition_index_list do
		if data.expedition_index_list[i] == 0 then
			self.enemyIndex = self.enemyIndex + 1
		end
		local entity = qy.tank.entity.ExpeEnemyEntity.new(data.expedition_index_list[i], data.checkpoint_list[i], self.enemyIndex)
		table.insert(self.expeEnemyList, entity)
		if entity.is_open == 1 and entity.is_pass == 0 then
			self.currentIndex = i
		end
	end
end

function FightJapanModel:updateRaisedNum(_num)
    self.RaisedNum = _num
end

function FightJapanModel:getRaisedNum()
    return self.RaisedNum
end

function FightJapanModel:getDiamondByQuality(_qua)
	if _qua == 7 then
		return 100
    elseif _qua == 6 then
        return 100
    elseif _qua == 5 then
        return 50
    elseif _qua == 4 then
        return 20
    elseif _qua == 3 then
        return 5
    else
        return 0
    end
end

function FightJapanModel:getExpeEnemyList()
	return self.expeEnemyList
end

function FightJapanModel:getCurrentIndex()
	return self.currentIndex
end

function FightJapanModel:getExpeEnemyNum()
	return #self.expeEnemyList
end

function FightJapanModel:getExpeEnemyDataByIdx(idx)
	-- print("FightJapanModel:getExpeEnemyDataByIdx ==", idx)
	-- print("FightJapanModel: expeEnemyList ==", #self.expeEnemyList)
	return self.expeEnemyList[tonumber(idx)]
end

function FightJapanModel:getChestAwardById(id)
	local data = qy.Config.expedition_chest
	for _k, _v in pairs(data) do
		if data[_k].id == id then
			-- print("fixed_award ===", data[_k].fixed_award)
			return data[_k].fixed_award[1].num
		end
	end

	return 0
end

function FightJapanModel:getTotalEnemyNum()
	return self.enemyIndex
end

function FightJapanModel:getFormationById(tankUid, index)
	local fm = self.expeEnemyList[index]["formation"]
	for i = 1, 6 do
		if fm["p_"..i] == tankUid then
			return i
		end
	end
	return -1
end

return FightJapanModel
