--[[
    处理各种item的command
    使用：qy.tank.command.AwardCommand:add(award)
]]

local AwardCommand = qy.class("AwardCommand", qy.tank.command.BaseCommand)
AwardCommand.storeModel = qy.tank.model.StorageModel
AwardCommand.achieveModel = qy.tank.model.AchievementModel

local AwardType = qy.tank.view.type.AwardType
local AlloyModel = qy.tank.model.AlloyModel


--增加item数据
function AwardCommand:add(data)
	if type(data) ~= "table" then
		return
	end
	local isTankNeedToSort = false --坦克列表是否需要排序
	local isEquipNeedToSort = false --装备列表是否需要排序
	local isFragmentNeedToSort = false --装备碎片列表是否需要排序
	local isStorageNeedToSort = false --道具列表是否需要排序
	local isAlloyNeedToSort = {} --合金列表是否需要排序
	-- local achieveDatat = self.achieveModel:getPicAddList()

	for i = 1, #data do
		

		if data[i].type == AwardType.TANK then
			--战车
			if self.achieveModel:isTankInPicAddList(data[i].tank.tank_id) then				
				qy.tank.model.GarageModel:addTank(data[i].tank, true)
				qy.RedDotCommand:emitSignal(qy.RedDotType.M_GARAGE, true, true)
				-- qy.tank.model.RedDotModel:setGarageHasNew(true)
			else
				qy.tank.model.GarageModel:addTank(data[i].tank, false)
			end

			isTankNeedToSort = true
		elseif data[i].type == AwardType.EQUIP then
			--装备
			data[i].equip.isNew = true
			qy.tank.model.EquipModel:add(data[i].equip, 1)
			qy.RedDotCommand:emitSignal(qy.RedDotType.M_EQUIP, true, true)
			isEquipNeedToSort = true
		elseif data[i].type == AwardType.EQUIP_FRAGMENT then
			--装备碎片
			qy.tank.model.EquipModel:add(data[i], 2)
			isFragmentNeedToSort = true
		elseif data[i].type == AwardType.STORAGE then
			--道具
			qy.tank.model.StorageModel:add(data[i].id , data[i].num)
			isStorageNeedToSort = true
		elseif data[i].type == AwardType.ALLOY_1 or data[i].type == AwardType.ALLOY_2 or data[i].type == AwardType.ALLOY_3 then
			--合金
			qy.tank.model.AlloyModel:add(data[i])
			isAlloyNeedToSort[data[i].alloy.alloy_id] = true
		elseif data[i].type == AwardType.TYPE_SOUL then --军魂
			qy.tank.model.SoulModel:addSoul(data[i].soul)
		elseif data[i].type == AwardType.PASSENGER then --乘员
			qy.tank.model.PassengerModel:addPassenger(data[i].passenger)
		elseif data[i].type == AwardType.MEDAL then --勋章
			qy.tank.model.MedalModel:addMedal(data[i].medal)
		elseif data[i].type == AwardType.FITTINGS then --配件
			qy.tank.model.FittingsModel:addFittings(data[i].fittings)
	    elseif data[i].type == AwardType.TANK_FRAGMENT then --坦克碎片
	    	qy.tank.model.GarageModel:addTankFragment(data[i])
	    end
	end

	if isTankNeedToSort then
		isTankNeedToSort = false
		qy.tank.model.GarageModel:sort(qy.tank.model.GarageModel.totalTanks)
		qy.tank.model.GarageModel:sort(qy.tank.model.GarageModel.unselectedTanks)
		qy.tank.model.GarageModel:sortTankFragment()
	end

	if isEquipNeedToSort then
		isEquipNeedToSort = false
		qy.tank.model.EquipModel:sort()
	end

	if isFragmentNeedToSort then
		isFragmentNeedToSort = false
		qy.tank.model.EquipModel:sortFragment()
	end

	if isStorageNeedToSort then
		isStorageNeedToSort = false
		--TODO
	end

	AlloyModel:sortAlloyList(isAlloyNeedToSort)
	isAlloyNeedToSort = {}

end

--[[
	显示奖励
	params
		_data: 奖励数据
		extend: 拓展参数
		extend.isShowHint 是否显示 hint，当且仅有一种奖励，且奖励不是坦克、装备、装备碎片时，
						isShowHint == false 时，显示弹窗奖励；
						isShowHint == true 时，显示飘出来的奖励，默认为 true
	用法：qy.tank.command.AwardCommand:show(award,{["isShowHint"]=false})

]]--
function AwardCommand:show(_data,extend)
	if _data == nil or #_data<1 then
		return
	end
	local data = {}
	--过滤负数
	for i = 1, #_data do
		if _data[i].num > 0 then
			table.insert(data, _data[i])
		end
	end

	local _showHint = false

	if #data == 0 then
		return
	end

	if extend == nil then
		extend = {}
	end
	if extend.isShowHint == nil then
		extend.isShowHint = true
	end

	if #data == 1 then
		-- if data[1].type == awardType.DIAMOND or data[1].type == awardType.ENERGY or data[1].type == awardType.SILVER or
		-- data[1].type == awardType.BLUE_IRON or data[1].type == awardType.PURPLE_IRON or data[1].type == awardType.ORANGE_IRON or
		-- data[1].type == awardType.EXPEDITION_COINS or data[1].type == awardType.USER_EXP or data[1].type == awardType.TECHNOLOGY_HAMMER or
		-- data[1].type == awardType.TYPE_SOUL_FRAGMENT  or data[1].type == awardType.REPUTATION then

		--奖励只有一个，且是钻石\体力\银币\蓝铁\紫铁\橙铁\远征币\指挥官经验，用hint
		--
			-- _showHint = true
		-- end
		if data[1].type ~= AwardType.TANK and data[1].type ~= AwardType.TANK_FRAGMENT and data[1].type ~= AwardType.EQUIP and data[1].type ~= AwardType.EQUIP_FRAGMENT then
			-- 单个奖励 且不属于 坦克、装备、装备碎片
			_showHint = extend.isShowHint
		end
	else
		_showHint = false
	end

	if _showHint then
		extend.award = qy.tank.view.common.AwardItem.getItemData(_data[1])
		qy.hint:show(extend)
        if extend.callback then
            extend.callback()
        end
	else
		qy.QYPlaySound.playEffect(qy.SoundType.GET_AWARD)
		qy.tank.view.common.AwardGetDialog.new({
        	["award"] = data,
        	["callback"] = extend.callback,
        	["isPub"] = extend.isPub,
    	}):show(true)
	end
end
function AwardCommand:show1(_data,extend)
	if _data == nil or #_data<1 then
		return
	end
	local data = {}
	--过滤负数
	for i = 1, #_data do
		if _data[i].num > 0 then
			table.insert(data, _data[i])
		end
	end

	local _showHint = false

	if #data == 0 then
		return
	end

	if extend == nil then
		extend = {}
	end
	if extend.isShowHint == nil then
		extend.isShowHint = true
	end

	if _showHint then
		extend.award = qy.tank.view.common.AwardItem.getItemData(_data[1])
		qy.hint:show(extend)
        if extend.callback then
            extend.callback()
        end
	else
		qy.QYPlaySound.playEffect(qy.SoundType.GET_AWARD)
		qy.tank.view.common.AwardGetDialog.new({
        	["award"] = data,
        	["callback"] = extend.callback,
        	["isPub"] = extend.isPub,
    	}):show(true)
	end
end

return AwardCommand
