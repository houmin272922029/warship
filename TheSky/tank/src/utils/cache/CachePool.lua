--[[
	缓存池
	Author: Aaron Wei
	Date: 2015-07-15 14:49:41
]]

local CachePool = class("CachePool")

function CachePool.ctor()
	self.utils = qy.tank.utils.cache.CachePoolUtil
end

function CachePool.getSpriteFrame(source,name)
	if not cc.SpriteFrameCache:getInstance():getSpriteFrame(name) then
		-- cc.Sprite:createWithSpriteFrameName(name) 
		qy.utils.addPlist(source)
	end
	
end


return CachePool