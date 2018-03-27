--[[
	缓存池工具类
	Author: Aaron Wei
	Date: 2015-07-15 14:26:09
]]
local CachePoolUtil = {}

-- ======================================== plist ========================================
function CachePoolUtil.addPlist(name,_type)
	if _type == 1 then
    	cc.SpriteFrameCache:getInstance():addSpriteFrames(name ..".plist",name .. ".png")
	elseif _type == 2 then
    	cc.SpriteFrameCache:getInstance():addSpriteFrames(name ..".plist",name .. ".pvr.ccz")
	else
    	cc.SpriteFrameCache:getInstance():addSpriteFrames(name ..".plist",name .. ".pvr.ccz")
	end
end

function CachePoolUtil.addPlistAsync(name,_type,callback)
	if _type == 1 then
    	cc.Director:getInstance():getTextureCache():addImageAsync(name..".png",function()
    		cc.SpriteFrameCache:getInstance():addSpriteFrames(name ..".plist",name .. ".png")
    		callback()
    	end)
	elseif _type == 2 then
		cc.Director:getInstance():getTextureCache():addImageAsync(name..".pvr.ccz",function()
    		cc.SpriteFrameCache:getInstance():addSpriteFrames(name ..".plist",name .. ".pvr.ccz")
    		callback()
    	end)
	else
    	cc.SpriteFrameCache:getInstance():addSpriteFrames(name ..".plist",name .. ".pvr.ccz")
	end

end

function CachePoolUtil.removePlist(name,_type)
	cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile(name .. ".plist")
	if _type == 1 then
		cc.Director:getInstance():getTextureCache():removeTextureForKey(name .. ".png")
	elseif _type == 2 then
		cc.Director:getInstance():getTextureCache():removeTextureForKey(name .. ".pvr.ccz")
	else
		cc.Director:getInstance():getTextureCache():removeTextureForKey(name .. ".pvr.ccz")
	end
	-- cc.Director:getInstance():getTextureCache():removeUnusedTextures()
end

function CachePoolUtil.addPlistForKey(plist,texture)
    cc.SpriteFrameCache:getInstance():addSpriteFrames(plist,texture)
end

function CachePoolUtil.removePlistForKey(plist,texture)
	cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile(plist)
	cc.Director:getInstance():getTextureCache():removeTextureForKey(texture)
end	

-- ======================================== 龙骨动画 ========================================
function CachePoolUtil.addArmatureFile(name,suffix)
	local pvr = suffix and "res/"..name .. suffix or "res/"..name .. ".pvr.ccz"
	local plist = "res/"..name .. ".plist"
	local xml = "res/"..name .. ".xml"
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(pvr, plist, xml)
end

function CachePoolUtil.addArmatureFileAsync(name,callback,suffix)
	local pvr = suffix and "res/"..name .. suffix or "res/"..name .. ".pvr.ccz"
	local plist = "res/"..name .. ".plist"
	local xml = "res/"..name .. ".xml"
	if type(callback) == "function" then
		ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync(pvr, plist, xml,callback)
	else
		ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync(pvr, plist, xml,function()end)
	end
end

function CachePoolUtil.removeArmatureFile(name,suffix)
	local pvr = suffix and "res/"..name .. suffix or "res/"..name .. ".pvr.ccz"
	local plist = "res/"..name .. ".plist"
	local xml = "res/"..name .. ".xml"
	ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(xml)
	cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile(plist)
    cc.Director:getInstance():getTextureCache():removeTextureForKey(pvr)
    -- cc.Director:getInstance():getTextureCache():removeUnusedTextures()
end

-- ======================================== 模块化的龙骨动画 ========================================
function CachePoolUtil.addArmatureFileByModules(name)
	local pvr = name .. ".pvr.ccz"
	local plist = name .. ".plist"
	local xml = name .. ".xml"
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(pvr, plist, xml)
end

function CachePoolUtil.addArmatureFileAsyncByModules(name,callback)
	local pvr = name .. ".pvr.ccz"
	local plist = name .. ".plist"
	local xml = name .. ".xml"
	if type(callback) == "function" then
		ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync(pvr, plist, xml,callback)
	else
		ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync(pvr, plist, xml,function()end)
	end
end

function CachePoolUtil.removeArmatureFileByModules(name)
	local pvr = name .. ".pvr.ccz"
	local plist = name .. ".plist"
	local xml = name .. ".xml"
	ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(xml)
	cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile(plist)
    cc.Director:getInstance():getTextureCache():removeTextureForKey(pvr)
    -- cc.Director:getInstance():getTextureCache():removeUnusedTextures()
end

-- ======================================== 纹理 ========================================
function CachePoolUtil.addJPG(filepath)
    cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_RG_B565)
    cc.Director:getInstance():getTextureCache():addImage(filepath)
    cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_DEFAULT)
end

function CachePoolUtil.addPNG(filepath)
    cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A4444)
    cc.Director:getInstance():getTextureCache():addImage(filepath)
    cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_DEFAULT)
end

function CachePoolUtil.addJPGAsync(filepath,callback)
    cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_RG_B565)
    cc.Director:getInstance():getTextureCache():addImageAsync(filepath,callback)
    cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_DEFAULT)
end

function CachePoolUtil.addPNGAsync(filepath,callback)
    cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A4444)
    cc.Director:getInstance():getTextureCache():addImageAsync(filepath,callback)
    cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_DEFAULT)
end

function CachePoolUtil.removeTexture(texture)
	cc.Director:getInstance():getTextureCache():removeTexture(texture)
end

function CachePoolUtil.removeTextureForKey(key)
	cc.Director:getInstance():getTextureCache():removeTextureForKey(key)
end

function CachePoolUtil.removeAllTextures()
	cc.Director:getInstance():getTextureCache():removeAllTextures()
end

function CachePoolUtil.removeUnusedTextures()
	cc.Director:getInstance():getTextureCache():removeUnusedTextures()
end

return CachePoolUtil
