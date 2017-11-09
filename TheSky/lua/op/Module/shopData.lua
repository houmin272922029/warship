shopData = {
	
}

-- 获得现金商城数据
function shopData:getCashShopData(  )
	local retArray = {}
	-- print("-------------ConfigureStorage.cashShop------------")
	-- PrintTable(ConfigureStorage.cashShop)
	for k,v in pairs(ConfigureStorage.cashShop) do
		table.insert(retArray, v)
	end
	local function sortFun( a,b )
		if a.sort and b.sort then
			return a.sort > b.sort
		end
		return a.gold > b.gold
	end
	table.sort( retArray,sortFun )

    if isPlatform(IOS_GAMEVIEW_TC) or isPlatform(ANDROID_GV_MFACE_TC_GP) then
        if (not userdata:getVipAuditState()) and isPlatform(IOS_GAMEVIEW_TC) then
	        retArray = {}
	        ConfigureStorage.cashShop = {}
	    else
	        local shopDataTmp = {}
	        for i,item in ipairs(retArray) do
	            if not wareHouseData:stringHasPrix( item.desp ,"MyCard" ) then
	                table.insert(shopDataTmp,item)
	            end
	        end
	        retArray = shopDataTmp
	    end
    end

    if isPlatform(ANDROID_JAGUAR_TC) then

	    local shopDataTmp = {}
	    for i,item in ipairs(retArray) do
	        if item.source == 1 then
	            table.insert(shopDataTmp,item)
	        end
	    end
	    retArray = shopDataTmp
	    ConfigureStorage.cashShop = retArray
    end
	return retArray
    
end

-- 
function shopData:getItemShopData(  )
	local goldShopConfig = ConfigureStorage.goldShop
	local itemsConfig = ConfigureStorage.item
	local retArray = {}
	for i=1,table.getTableCount(goldShopConfig) do
		local content = {}
		local itemContent = goldShopConfig[string.format("%d",i)]
		local itemId = itemContent["itemId"]
		local price = itemContent["price"]["gold"]
		local item = itemsConfig[itemId]
		content["sort"] = itemContent["sort"]
		content["item"] = item
		content["price"] = price
		table.insert(retArray,content)
	end
	local function sortFun( a,b )
		return a.sort < b.sort
	end
	table.sort( retArray,sortFun )
	return retArray
end

-- 根据道具id获取道具的价格
-- 参数：道具id
-- 返回：道具价格（如果商城中没有该道具出售则返回0）
function shopData:getItemPriceByItemId( itemId )
	local goldShopConfig = ConfigureStorage.goldShop
	for i=1,table.getTableCount(goldShopConfig) do
		local itemContent = goldShopConfig[string.format("%d",i)]
		if itemContent["itemId"] == itemId then
			return itemContent["price"]["gold"]
		end 
	end
	return 0
end

-- 根据id获得item的详细信息
function shopData:getItemByItemId( itemId )
	local itemsConfig = ConfigureStorage.item
	local retArray = {}
	local item = itemsConfig[itemId]
	retArray["item"] = item
	retArray["price"] = shopData:getItemPriceByItemId( itemId )
	return retArray
end

-- 获得最大充值额度
function shopData:getMaxRecharge()
	local array = {}
	for k,v in pairs(ConfigureStorage.cashShop) do
		table.insert(array, v)
	end
	local function sortFun(a, b)
		return a.gold > b.gold
	end
	table.sort( array, sortFun )
	return array[1]
end



