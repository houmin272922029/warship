VipShopData = {
	data = {},
}

function VipShopData:fromDic(dic)
    VipShopData.data = dic
end

-- 得到所有礼包信息
function VipShopData:gdata()
	local tableArray = {}
	for k,v in pairs(VipShopData.data) do
		local vipBag = 	ConfigureStorage.vip_shop[k]	
		if v.canBuyNum and v.canBuyNum ~= 0 then
			vipBag["canBuyNum"] = v.canBuyNum
			table.insert(tableArray, vipBag)
		end
	end
	return tableArray
end


--重置用户数据
function VipShopData:resetAllData()
	VipShopData.data = {}
end