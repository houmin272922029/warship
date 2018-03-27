--[[
	奖品信息工具类
	Author: H.X.Sun
	Date: 2015-04-29
	用于取默认图

	后端策划定义的type 1~ 100000 (大于0)
        	前端定义的type -1 ~ -10000 (小于0)
]]

local AwardUtils = {}

--[[--
--获取奖品icon
--@param #number nType 奖品类型   等价于AwardType
--@param # number _id, 物品ID：战车、装备、道具 需要ID
--@return 奖品icon路径
--]]
function AwardUtils.getAwardIconByType(nType, _id)
	if nType == 1 then
		--钻石
		if _id == 2 then
			return "Resources/common/icon/coin/1a.png"
		else
			return "Resources/common/icon/coin/1.png"
		end
	elseif nType == 2 then
		--体力
		return "Resources/common/icon/coin/2.png"
	elseif nType == 3 then
		--银币
		return "Resources/common/icon/coin/3.png"
	elseif nType == 4 then
		--战车经验卡
		return "Resources/common/icon/coin/4.png"
	elseif nType == 5 then
		--科技书
		return "Resources/common/icon/coin/5.png"
	elseif nType == 6 then
		--蓝铁
		return "Resources/common/icon/coin/6.png"
	elseif nType == 7 then
		--紫铁
		return "Resources/common/icon/coin/7.png"
	elseif nType == 8 then
		--橙铁
		return "Resources/common/icon/coin/8.png"
	elseif nType == 9 then
		--远征币
		return "Resources/common/icon/coin/9.png"
	elseif nType == 10 then
		--威士忌(军械箱)
		return "Resources/common/icon/coin/10.png"
	elseif nType == 11 then
		--战车
		local entity = qy.tank.entity.TankEntity.new(_id)
		return entity:getIcon()
	elseif nType == 12 then
		--装备
		local entity = qy.tank.entity.EquipEntity.new(_id)
		return entity:getIcon()
	elseif nType == 13 then
		--装备碎片
		local entity = qy.tank.entity.EquipEntity.new(_id)
		return entity:getIcon()
	elseif nType == 14 then
		--道具
		local entity = qy.tank.entity.PropsEntity.new(_id)
		return entity:getIcon()
	elseif nType == 20 then
		--进阶材料
		return "Resources/common/icon/coin/11.png"
	elseif nType == 21 then
		--进阶材料
		return "Resources/common/icon/coin/21.png"
	elseif nType == -1 then
		--指挥官经验
		return "Resources/common/icon/coin/user_exp_icon.png"
	elseif nType == 22 then
		-- return "Resources/common/icon/soul/soul1.png"
		return "res/soul/" .. _id.type .. "_" .. _id.quality .. ".png"
	elseif nType == 23 then
		return "Resources/common/icon/coin/soul2.png"
	elseif nType == 24 then
		--巅峰对决积分
		return "Resources/common/icon/coin/24.png"
	elseif nType == 25 then
		--乘员
        return "res/passenger/" .. _id.id .. "_" .. 1 .. ".png"

	elseif nType == 26 then
		--乘员碎片
		return "res/passenger/" .. _id.id .. "_" .. 1 .. ".png"
	elseif nType == 27 then
		-- 兑奖券
		return "Resources/common/icon/coin/27.png"
	elseif nType == 28 then
		-- 声望
		return "Resources/common/icon/coin/28.png"
	elseif nType == 29 then
		-- 暴打敌营积分
		return "Resources/common/icon/coin/29.png"
	elseif nType == 30 then
		-- 角斗币(最强之战积分)
		return "Resources/common/icon/coin/30.png"
	elseif nType == 31 then
		-- 军功
		return "Resources/common/icon/coin/31.png"
	elseif nType == 32 then
		-- 聚能拼合碎片1
		return "Resources/common/icon/coin/32.png"
	elseif nType == 33 then
		-- 聚能拼合碎片2
		return "Resources/common/icon/coin/33.png"
	elseif nType == 34 then
		-- 聚能拼合碎片3
		return "Resources/common/icon/coin/34.png"
	elseif nType == 35 then
		-- 聚能拼合碎片4
		return "Resources/common/icon/coin/35.png"
	elseif nType == 37 then
		-- 陶瓷装甲
		return "Resources/common/icon/coin/37.png"
	elseif nType == 38 then
		--聚变水晶
		return "Resources/common/icon/coin/38.png"
	elseif nType == 39 then
		--裂变水晶
		return "Resources/common/icon/coin/39.png"
	elseif nType == 40 then
		--VIP经验
		return "Resources/common/icon/coin/40.png"
	elseif nType == 41 then
		-- 勋章
		return "res/medal/" .. _id.foreign_id .. "_0" .. _id.position .. ".jpg"
	elseif nType == 42 then
		--重铸液
		return "Resources/common/icon/coin/42.png"
	elseif nType == 43 then
		--精铸液
		return "Resources/common/icon/coin/43.png"
	elseif nType == 44 then
		--日耀徽章
		return "Resources/common/icon/coin/44.png"
	elseif nType == 45 then
		--月华徽章
		return "Resources/common/icon/coin/45.png"
	elseif nType == 46 then
		--升级手册
		return "Resources/common/icon/coin/46.png"
	elseif nType == 47 then
		--精铁
		return "Resources/common/icon/coin/47.png"
	elseif nType == 48 then
		--熔炼积分
		return "Resources/common/icon/coin/48.png"
	elseif nType == 49 then
		--配件
		return  "res/fittings/part" .. _id ..".png"
	elseif nType == 50 then
		--洗练石
		return "Resources/common/icon/coin/50.png"
	elseif nType == 51 then
		--萃取器
		return "Resources/common/icon/coin/51.png"
	elseif nType == 52 then
		--突破石
		return "Resources/common/icon/coin/52.png"
    end
end

function AwardUtils.getSmallDiamond()
	return "Resources/common/icon/coin/1a.png"
end

--[[--
--获取奖品名称
--@param #number nType 奖品类型
--@return 奖品名
--]]
function AwardUtils.getAwardNameByType(nType , _id)
	if nType == 1 then
		return qy.TextUtil:substitute(70002)
	elseif nType == 2 then
		return qy.TextUtil:substitute(70003)
	elseif nType == 3 then
		return qy.TextUtil:substitute(70004)
	elseif nType == 4 then
		return qy.TextUtil:substitute(70005)
	elseif nType == 5 then
		return qy.TextUtil:substitute(70006)
	elseif nType == 6 then
		return qy.TextUtil:substitute(70007)
	elseif nType == 7 then
		return qy.TextUtil:substitute(70008)
	elseif nType == 8 then
		return qy.TextUtil:substitute(70009)
	elseif nType == 9 then
		return qy.TextUtil:substitute(70010)
	elseif nType == 10 then
		return qy.TextUtil:substitute(70011)
	elseif nType == 11 then
		--战车
		local entity = qy.tank.entity.TankEntity.new(_id)
		return entity.name
	elseif nType == 12 then
		--装备
		local entity = qy.tank.entity.EquipEntity.new(_id)
		return entity:getName()
	elseif nType == 13 then
		--装备碎片
		local entity = qy.tank.entity.EquipEntity.new(_id)
		return entity:getName() .. qy.TextUtil:substitute(70012)
	elseif nType == 14 then
		--道具
		local entity = qy.tank.entity.PropsEntity.new(_id)
		return entity.name
	elseif nType == -1 then
		return qy.TextUtil:substitute(70013)
    end
end

return AwardUtils
