--[[
	坦克&怪物表适配类
	Author: Aaron Wei
	Date: 2015-06-10 16:27:09
]]

local MonsterConfig = {}

function MonsterConfig.getTable(type)
	if type == 0 then
		return qy.Config.tank -- 坦克表
	elseif type == 1 then
		-- return qy.Config.monster -- 关卡怪物表
		return
	elseif type == 2 then
		return qy.Config.classicbattle_monster -- 经典战役怪物表
	elseif type == 3 then
		return qy.Config.arena_monster -- 竞技场怪物表
	elseif type == 4 then
		return qy.Config.mining_monster -- 矿区怪物表
	elseif type == 5 then
		return qy.Config.expedition_monster -- 远征怪物表
	elseif type == 6 then
		return qy.Config.invade_monster -- 伞兵入侵怪物表
	elseif type == 7 then
		return qy.Config.guide_monster -- 新手引导怪物表
	elseif type == 8 then
		return qy.Config.soldier_battle_monster -- 将士之战怪物表
	end
end

function MonsterConfig.getItem(type,id)
	return MonsterConfig.getTable(type)[tostring(id)]
end

return MonsterConfig