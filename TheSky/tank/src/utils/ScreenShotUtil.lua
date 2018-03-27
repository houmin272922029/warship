--[[
	截屏类
]]

local ScreenShotUtil = {}

ScreenShotUtil.potoList = {}
-- setmetatable(ScreenShotUtil.potoList, {__mode = “kv”})
--[[
	截屏
	potoName   	站片儿名
	isRetain   	true代表保持，  false代表不保持
]]
function ScreenShotUtil:takePoto(potoName , isRetain , isCaptrued)
  --截屏回调方法
  function afterCaptured(succeed, outputFile)
	    if succeed then
	      	local sp = cc.Sprite:create(outputFile)
	      	if isRetain ==nil  or isRetain == true  then
				ScreenShotUtil.potoList[potoName] = sp
			end
			isCaptrued(sp)
	    else
	    	return nil
	    end
  end

	-- 移除纹理缓存
    fileName = potoName..".png"  
    -- 截屏
    cc.utils:captureScreen(afterCaptured, fileName)
end

function ScreenShotUtil:getPotoByName( potoName )
	return cc.Director:getInstance():getTextureCache():getTextureForKey(potoName)
end

function ScreenShotUtil:removePoto( potoName)
	cc.Director:getInstance():getTextureCache():removeTextureForKey(potoName)
	ScreenShotUtil.potoList[potoName] = nil
end

function ScreenShotUtil:clearAll()
	ScreenShotUtil.potoList = {}
end
return ScreenShotUtil