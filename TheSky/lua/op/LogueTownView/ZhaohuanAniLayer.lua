local _layer

ZhaohuanLayerOwner = ZhaohuanLayerOwner or {}
ccb["ZhaohuanLayerOwner"] = ZhaohuanLayerOwner

local function _addAnimation()
    HLAddParticle( "images/eff_page_725_1.plist", _layer, ccp(winSize.width/2, winSize.height/2), -1, 100, 5)
    -- HLAddParticle( "images/eff_page_700_3.plist", _layer, ccp(winSize.width/2, winSize.height/2), -1, 101, 6)
    HLAddParticle( "images/eff_page_725_2.plist", _layer, ccp(winSize.width/2, winSize.height/2), -1, 100, 5)
    HLAddParticleScale( "images/eff_page_700_2.plist", _layer, ccp(winSize.width/2, winSize.height/2), 2, 100, 6, 5, 5 )
end 

local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/ZhaoHuanAniView.ccbi",proxy, true,"ZhaohuanLayerOwner")
    _layer = tolua.cast(node,"CCLayer")

end

function getZhaohuanAniLayer()
	return _layer
end

function createZhaohuanAniLayer()
    _init()


    local function _onEnter()
        print("ZhaohuanAniLayer onEnter")
        _addAnimation()
    end

    local function _onExit()
        print("ZhaohuanAniLayer onExit")
        _layer = nil
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end


    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end