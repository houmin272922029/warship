--[[
	战斗通讯类
	Author: Aaron Wei
	Date: 2015-11-16 16:16:05
]]

local BattleCommand = qy.class("BattleCommand", qy.tank.command.BaseCommand)

function BattleCommand:addResources()
	-- tank特效
	-- ui特效
	qy.tank.utils.cache.CachePoolUtil.addArmatureFile("fx/".. qy.language .."/ui/ui_fx_duijue",nil)
	
	-- tank特效
	qy.tank.utils.cache.CachePoolUtil.addPlist("fx/".. qy.language .."/tank/crater",2) 
	qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync("fx/".. qy.language .."/tank/tank_fx_lvdaiyan",nil)
	qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync("fx/".. qy.language .."/tank/tank_fx_dust",nil)
	-- qy.tank.utils.cache.CachePoolUtil.addPlist("fx/tank/track",2) 
	-- qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync("fx/tank/shell")
	
	-- skill特效
	qy.tank.utils.cache.CachePoolUtil.addArmatureFile("fx/".. qy.language .."/skill/att_fx_1")
	qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync("fx/".. qy.language .."/skill/att_fx_10",nil)
	qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync("fx/".. qy.language .."/skill/att_fx_11",nil)

	qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync("fx/".. qy.language .."/skill/def_fx_1",nil)
	qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync("fx/".. qy.language .."/skill/def_fx_10",nil)
	qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync("fx/".. qy.language .."/skill/def_fx_11",nil)
	qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync("fx/".. qy.language .."/skill/def_fx_13",nil)
	
	qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync("fx/".. qy.language .."/skill/dz_fx_1",nil)
	qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync("fx/".. qy.language .."/skill/dz_fx_2",nil)
	qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync("fx/".. qy.language .."/skill/dz_fx_3",nil)
	qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync("fx/".. qy.language .."/skill/dz_fx_4",nil)
	
	qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync("fx/".. qy.language .."/buff/buff_fx_fangyu",nil)
	qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync("fx/".. qy.language .."/buff/buff_fx_jiaxue",nil)
	qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync("fx/".. qy.language .."/buff/buff_fx_jiaxueqs",nil)

	qy.tank.utils.cache.CachePoolUtil.addPlist("Resources/battle/battle",1)
end

function BattleCommand:removeResources()
	self.model = qy.tank.model.BattleModel

    -- tank avatar素材
	-- for i=1,58 do
	-- 	qy.tank.utils.cache.CachePoolUtil.removePlist("tank/avatar/t"..i)
	-- end

	-- 地图
	qy.tank.utils.cache.CachePoolUtil.removeTextureForKey(self.model:getBgURL())

	-- ui特效
	-- qy.tank.utils.cache.CachePoolUtil.removeArmatureFile("fx/ui/ui_fx_duijue")

	-- tank特效
	-- qy.tank.utils.cache.CachePoolUtil.removeArmatureFile("fx/tank/shell")
	-- qy.tank.utils.cache.CachePoolUtil.removeArmatureFile("fx/tank/tank_fx_lvdaiyan")
	-- qy.tank.utils.cache.CachePoolUtil.removeArmatureFile("fx/tank/tank_fx_dust")

	-- qy.tank.utils.cache.CachePoolUtil.removePlist("fx/tank/crater") 
	-- qy.tank.utils.cache.CachePoolUtil.removePlist("fx/tank/track") 
	
	-- skill特效
	-- qy.tank.utils.cache.CachePoolUtil.removeArmatureFile("fx/skill/att_fx_1")
	-- qy.tank.utils.cache.CachePoolUtil.removeArmatureFile("fx/skill/att_fx_10")
	-- qy.tank.utils.cache.CachePoolUtil.removeArmatureFile("fx/skill/att_fx_11")

	-- qy.tank.utils.cache.CachePoolUtil.removeArmatureFile("fx/skill/def_fx_1")
	-- qy.tank.utils.cache.CachePoolUtil.removeArmatureFile("fx/skill/def_fx_10")
	-- qy.tank.utils.cache.CachePoolUtil.removeArmatureFile("fx/skill/def_fx_11")
	-- qy.tank.utils.cache.CachePoolUtil.removeArmatureFile("fx/skill/def_fx_13")
	
	-- qy.tank.utils.cache.CachePoolUtil.removeArmatureFile("fx/skill/dz_fx_1")
	-- qy.tank.utils.cache.CachePoolUtil.removeArmatureFile("fx/skill/dz_fx_2")
	-- qy.tank.utils.cache.CachePoolUtil.removeArmatureFile("fx/skill/dz_fx_3")

	-- buff特效
	-- qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync("fx/buff/buff_fx_fangyu",nil)
	-- qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync("fx/buff/buff_fx_jiaxue",nil)
	-- qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync("fx/buff/buff_fx_jiaxueqs",nil)

	-- qy.tank.utils.cache.CachePoolUtil.removePlist("Resources/battle/battle")	
end

return BattleCommand