local _layer

local _pageNumb

local TrainViewBtn
local TrainWaveBtn
local TrainBoxBtn
local LogueTitleLayer
local TrainShadowContentLayer

TrainShadowViewOwner = TrainShadowViewOwner or {}
ccb["TrainShadowViewOwner"] = TrainShadowViewOwner

local function setSpriteFrame( sender,bool )
    if bool then
        sender:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_1.png"))
        sender:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_1.png"))
    else
        sender:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_0.png"))
        sender:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_1.png"))
    end
end

local function TrainShadowAction( tag,sender )
    TrainShadowContentLayer:removeAllChildrenWithCleanup(true)
    TrainShadowContentLayer:addChild(createTrainView())
    setSpriteFrame(TrainViewBtn,true)
    setSpriteFrame(TrainWaveBtn,false)
    setSpriteFrame(TrainBoxBtn,false)
end

local function shadowWaveAction(  )
    Global:instance():TDGAonEventAndEventData("prop")
    TrainShadowContentLayer:removeAllChildrenWithCleanup(true)
    TrainShadowContentLayer:addChild(createShadowWaveLayer())
    setSpriteFrame(TrainViewBtn,false)
    setSpriteFrame(TrainWaveBtn,true)
    setSpriteFrame(TrainBoxBtn,false)
end

local function shadowBoxAction(  )
    Global:instance():TDGAonEventAndEventData("gift")
    TrainShadowContentLayer:removeAllChildrenWithCleanup(true)
    TrainShadowContentLayer:addChild(createShadowBoxLayer())
    setSpriteFrame(TrainViewBtn,false)
    setSpriteFrame(TrainWaveBtn,false)
    setSpriteFrame(TrainBoxBtn,true)
end

local function changeShadowAction(  )
    if getMainLayer() then
        getMainLayer():gotoTeam()
    end
end

TrainShadowViewOwner["TrainShadowAction"] = TrainShadowAction
TrainShadowViewOwner["shadowWaveAction"] = shadowWaveAction
TrainShadowViewOwner["shadowBoxAction"] = shadowBoxAction
TrainShadowViewOwner["changeShadowAction"] = changeShadowAction

local function gotoPageByNumb( pageNumb )
    TrainShadowContentLayer:removeAllChildrenWithCleanup(true)
    if pageNumb == 0 then
        TrainShadowContentLayer:addChild(createTrainView())
        setSpriteFrame(TrainViewBtn,true)
        setSpriteFrame(TrainWaveBtn,false)
        setSpriteFrame(TrainBoxBtn,false)
    elseif pageNumb == 1 then
        TrainShadowContentLayer:addChild(createShadowWaveLayer())
        setSpriteFrame(TrainViewBtn,false)
        setSpriteFrame(TrainWaveBtn,true)
        setSpriteFrame(TrainBoxBtn,false)
    elseif pageNumb == 2 then
        TrainShadowContentLayer:addChild(createShadowBoxLayer())
        setSpriteFrame(TrainViewBtn,false)
        setSpriteFrame(TrainWaveBtn,false)
        setSpriteFrame(TrainBoxBtn,true)
    end

end
-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/TrainShadowView.ccbi",proxy, true,"TrainShadowViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    TrainShadowContentLayer = tolua.cast(TrainShadowViewOwner["TrainShadowContentLayer"],"CCLayer")

    -- _updatePackageCount()

    TrainViewBtn = tolua.cast(TrainShadowViewOwner["TrainViewBtn"],"CCMenuItemImage")
    TrainWaveBtn = tolua.cast(TrainShadowViewOwner["TrainWaveBtn"],"CCMenuItemImage")
    
    TrainBoxBtn = tolua.cast(TrainShadowViewOwner["TrainBoxBtn"],"CCMenuItemImage")
    gotoPageByNumb( _pageNumb )
end

local function setMenuPriority()
    local menu1 = tolua.cast(TrainShadowViewOwner["myCCMenu"], "CCMenu")
    menu1:setHandlerPriority(-129)
end

function getTrainShadowLayer()
    return _layer
end
-- 0 开始
function createTrainShadowView(pageNumb)
    _pageNumb = pageNumb and pageNumb or 0
    -- if pageNumb then
    --     _pageNumb = pageNumb
    -- end
    _init()

    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
    end

    local function _onExit()
        _pageNumb = nil
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