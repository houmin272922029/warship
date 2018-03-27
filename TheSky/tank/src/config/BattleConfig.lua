--[[
	战斗参数配置
	Author: Aaron Wei
	Date: 2015-01-20 11:24:43
]]

local BattleConfig = {}

BattleConfig.SERVER = nil
BattleConfig.SPEED = 150
BattleConfig.SHOOT_INTERVAL = 0.2

-- ==================================================阵型==================================================
BattleConfig.FORMATION_CELL_SIZE = cc.size(75,170)
 
BattleConfig.FORMATION_ANGLE1 = math.pi/4
BattleConfig.FORMATION_ANGLE2 = math.pi/3*2-0.1
BattleConfig.FORMATION_COLS = 3
BattleConfig.FORMATION_ROWS = 2
BattleConfig.FORMATION_ZORDER_TO_INDEX = {{1,4,2,5,3,6},{4,1,5,2,6,3}}
BattleConfig.FORMATION_INDEX_TO_ZORDER = {{1,3,5,2,4,6},{1,3,5,2,4,6}}
BattleConfig.FORMATION_SORT_TYPE = 1

-- ==================================================坦克==================================================
BattleConfig.TANK_SCALE = 1
BattleConfig.TANK_ROTATION = 0
BattleConfig.TANK_DESTROY_TIME = 7
-- 坦克队列原点坐标
-- BattleConfig.P1 = cc.p(qy.winSize.width*0.24,qy.winSize.height*0.6)
-- BattleConfig.P1 = cc.p(qy.winSize.width/2-math.ceil(qy.winSize.width/3.6),qy.winSize.height/2+70)
BattleConfig.P1 = cc.p(qy.winSize.width/5,430)
-- BattleConfig.P2 = cc.p(qy.winSize.width*0.5,qy.winSize.height*0.75)
-- BattleConfig.P2 = cc.p(qy.winSize.width/2+math.ceil(qy.winSize.width/13.5),qy.winSize.height/2+150)
BattleConfig.P2 = cc.p(qy.winSize.width/7*4,510)

-- ==================================================地图==================================================
BattleConfig.MAP_ANGLE = math.pi-BattleConfig.FORMATION_ANGLE1-BattleConfig.FORMATION_ANGLE2

-- BattleConfig.MAP_DURATION = BattleConfig.MAP_DISTANCE/BattleConfig.SPEED 
-- BattleConfig.MAP_MOVE_ANGLE = math.atan(math.abs((BattleConfig.MAP_START_P1.y - BattleConfig.MAP_END_P1.y)/(BattleConfig.MAP_START_P1.x - BattleConfig.MAP_END_P1.x))) 
-- BattleConfig.MAP_MOVE_ANGLE = math.atan(0.37)

-- BattleConfig.MAP_START_P1 = cc.p(0,0)
-- BattleConfig.MAP_END_P1 = cc.p(BattleConfig.MAP_START_P1.x-BattleConfig.MAP_OFFSET2.x,BattleConfig.MAP_START_P1.y-BattleConfig.MAP_OFFSET2.y)

-- BattleConfig.MAP_START_P2 = cc.p(qy.winSize.width-2039,qy.winSize.height-1116)
-- BattleConfig.MAP_END_P2 = cc.p(BattleConfig.MAP_START_P2.x+BattleConfig.MAP_OFFSET2.x,BattleConfig.MAP_START_P2.y+BattleConfig.MAP_OFFSET2.y)


BattleConfig.GROUND = {
	{
		["offset"] = cc.p(934,346),
		["size"] = cc.size(2039,1116),
		["start1"] = cc.p(0,0),
		["end1"] = cc.p(-934,-346),
		["start2"] = cc.p(qy.winSize.width-2039,qy.winSize.height-1116),
		["end2"] = cc.p(qy.winSize.width-2039+934,qy.winSize.height-1116+346)
	},
	{
		["offset"] = cc.p(944,334),
		["size"] = cc.size(2039,1116),
		["start1"] = cc.p(0,0), 
		["end1"] = cc.p(-944,-334),
		["start2"] = cc.p(qy.winSize.width-2039,qy.winSize.height-1116),
		["end2"] = cc.p(qy.winSize.width-2039+944,qy.winSize.height-1116+334)
	},
	{
		["offset"] = cc.p(983,379),
		["size"] = cc.size(2039,1116),
		["start1"] = cc.p(0,-50), 
		["end1"] = cc.p(-983,-379-50),
		["start2"] = cc.p(qy.winSize.width-2039+100,qy.winSize.height-1116),
		["end2"] = cc.p(qy.winSize.width-2039+100+983,qy.winSize.height-1116+379)
	},
	{
		["offset"] = cc.p(752,286),
		["size"] = cc.size(2039,1116),
		["start1"] = cc.p(0,0), 
		["end1"] = cc.p(-752,-286),
		["start2"] = cc.p(qy.winSize.width-2039,qy.winSize.height-1116),
		["end2"] = cc.p(qy.winSize.width-2039+752,qy.winSize.height-1116+286)
	},
	{
		["offset"] = cc.p(740,373),
		["size"] = cc.size(2039,1116),
		["start1"] = cc.p(0,0), 
		["end1"] = cc.p(-740,-373),
		["start2"] = cc.p(qy.winSize.width-2039+200,qy.winSize.height-1116),
		["end2"] = cc.p(qy.winSize.width-2039+740+200,qy.winSize.height-1116+373)
	},
	{
		["offset"] = cc.p(740,373),
		["size"] = cc.size(2039,1116),
		["start1"] = cc.p(0,0), 
		["end1"] = cc.p(-740,-373),
		["start2"] = cc.p(qy.winSize.width-2039+200,qy.winSize.height-1116),
		["end2"] = cc.p(qy.winSize.width-2039+740+200,qy.winSize.height-1116+373)
	},
	{
		["offset"] = cc.p(727,368),
		["size"] = cc.size(2039,1116),
		["start1"] = cc.p(0,0), 
		["end1"] = cc.p(-727,-368),
		["start2"] = cc.p(qy.winSize.width-2039+200,qy.winSize.height-1116),
		["end2"] = cc.p(qy.winSize.width-2039+727+200,qy.winSize.height-1116+368)
	},
	{
		["offset"] = cc.p(749,373),
		["size"] = cc.size(2039,1116),
		["start1"] = cc.p(0,0), 
		["end1"] = cc.p(-749,-373),
		["start2"] = cc.p(qy.winSize.width-2039+200,qy.winSize.height-1116),
		["end2"] = cc.p(qy.winSize.width-2039+749+200,qy.winSize.height-1116+373)
	}
}

return BattleConfig