giftBagData = {
	allGiftBags = {},
	timeGift = {},
	nowShowGiftBags = {},
	vipCards = {},
}
-- ConfigureStorage.vipShop
function getItemWithItemID( itemId )
	if ConfigureStorage.item[string.format("%s",itemId)] then
		return ConfigureStorage.item[string.format("%s",itemId)]
	end
	return nil
end

function vipBagIsBuyed( vipId )
	for vipBagId,count in pairs(giftBagData.vipCards) do
		
		if vipId == vipBagId then
			if count >= giftBagData.allGiftBags[vipBagId]["amount"] then
				return true
			else
				return false
			end
		end
	end
	return false
end

-- 得到所有礼包信息
function giftBagData:getAllGiftBagInfo(  )
	for key,value in pairs(ConfigureStorage.vipShop) do
		local retArray = {}
		local content = value
		local itemId = content["itemId"]
		local item = getItemWithItemID(itemId)
		retArray["item"] = item
		if content["show"] then
			retArray["specialPrice"] = content["show"]
		else
			retArray["specialPrice"] = 0
		end
		if content["price"] then
			retArray["price"] = content["price"]
		else
			retArray["price"] = 0
		end
		if content["amount"] then
			retArray["amount"] = content["amount"]
		else
			retArray["amount"] = 0
		end
		if content["vipLevel"] then
			retArray["vipLevel"] = content["vipLevel"]
		else
			retArray["vipLevel"] = 0
		end
		giftBagData.allGiftBags[itemId] = retArray
	end
end

-- 返回限时礼包的数据
function giftBagData:getTimeGifts(  )
	-- PrintTable(giftBagData.timeGift)
	local retArray = {}
	for k,v in pairs(giftBagData.timeGift) do
		local tempArray = v
		tempArray["id"] = k
		table.insert(retArray,tempArray)
	end
	local function sortFun( a,b )
		return a.number > b.number
	end
	table.sort( retArray,sortFun )
	return retArray
end

--返回显示的vip背包内容
function giftBagData:getShowGiftBags(  )
	giftBagData:getAllGiftBagInfo(  )
	local retArray = {}
	local vipLavel = vipdata:getVipLevel()
	local canGetLavel
	if vipLavel >= 0 and vipLavel <= 4 then
		canGetLavel = 5
	else
		canGetLavel = vipLavel + 1
	end
	-- retArray.timeGift = giftBagData.timeGift
	local j = 1
	for i=1,canGetLavel do
		if giftBagData.allGiftBags[string.format("vip_%03d",i)] then
			if not vipBagIsBuyed(string.format("vip_%03d",i)) then
				retArray[string.format("%d",j)] = giftBagData.allGiftBags[string.format("vip_%03d",i)]
				j = j + 1
			end
		end
	end
	return retArray
end


--重置用户数据
function giftBagData:resetAllData()
	giftBagData.allGiftBags = {}
	giftBagData.timeGift = {}
	giftBagData.nowShowGiftBags = {}
	giftBagData.vipCards = {}
end