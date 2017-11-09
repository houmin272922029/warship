local _layer

local AllEquipsBtn
local WeaponsBtn
local ClothingBtn
local DecoBtn
local RuneBtn
local equipMentsContentLayer

-- ·名字不要重复
EquipmentsViewOwner = EquipmentsViewOwner or {}
ccb["EquipmentsViewOwner"] = EquipmentsViewOwner

local function setSpriteFrame( sender,bool )
    if bool then
        sender:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_1.png"))
        sender:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_1.png"))
    else
        sender:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_0.png"))
        sender:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tab_btn_1.png"))
    end
end

local function _allEquipBtnAction(  )
    equipMentsContentLayer:removeAllChildrenWithCleanup(true)
    equipMentsContentLayer:addChild(createAllEquipsLayer())
    setSpriteFrame(AllEquipsBtn,true)
    setSpriteFrame(WeaponsBtn,false)
    setSpriteFrame(ClothingBtn,false)
    setSpriteFrame(DecoBtn,false)
    setSpriteFrame(RuneBtn,false)
    runtimeCache.equipPageNum = 0
end

local function _WeaponsBtnAction(  )
    Global:instance():TDGAonEventAndEventData("equipment1")
    equipMentsContentLayer:removeAllChildrenWithCleanup(true)
    equipMentsContentLayer:addChild(createWeaponsLayer())
    setSpriteFrame(AllEquipsBtn,false)
    setSpriteFrame(WeaponsBtn,true)
    setSpriteFrame(ClothingBtn,false)
    setSpriteFrame(DecoBtn,false)
    setSpriteFrame(RuneBtn,false)
    runtimeCache.equipPageNum = 1
end

local function _ClothingBtnAction(  )
    Global:instance():TDGAonEventAndEventData("equipment2")
    equipMentsContentLayer:removeAllChildrenWithCleanup(true)
    equipMentsContentLayer:addChild(createClothingLayer())
    setSpriteFrame(AllEquipsBtn,false)
    setSpriteFrame(WeaponsBtn,false)
    setSpriteFrame(ClothingBtn,true)
    setSpriteFrame(DecoBtn,false)
    setSpriteFrame(RuneBtn,false)
    runtimeCache.equipPageNum = 2
end

local function _DecoBtnAction(  )
    Global:instance():TDGAonEventAndEventData("equipment3")
    equipMentsContentLayer:removeAllChildrenWithCleanup(true)
    equipMentsContentLayer:addChild(createDecorationsLayer())
    setSpriteFrame(AllEquipsBtn,false)
    setSpriteFrame(WeaponsBtn,false)
    setSpriteFrame(ClothingBtn,false)
    setSpriteFrame(DecoBtn,true)
    setSpriteFrame(RuneBtn,false)
    runtimeCache.equipPageNum = 3
end

local function _RuneBtnAction(  )
    Global:instance():TDGAonEventAndEventData("equipment4")
    equipMentsContentLayer:removeAllChildrenWithCleanup(true)
    equipMentsContentLayer:addChild(createRunesLayer())
    setSpriteFrame(AllEquipsBtn,false)
    setSpriteFrame(WeaponsBtn,false)
    setSpriteFrame(ClothingBtn,false)
    setSpriteFrame(DecoBtn,false)
    setSpriteFrame(RuneBtn,true)
    runtimeCache.equipPageNum = 4
end

EquipmentsViewOwner["_allEquipBtnAction"] = _allEquipBtnAction
EquipmentsViewOwner["_WeaponsBtnAction"] = _WeaponsBtnAction
EquipmentsViewOwner["_ClothingBtnAction"] = _ClothingBtnAction
EquipmentsViewOwner["_DecoBtnAction"] = _DecoBtnAction
EquipmentsViewOwner["_RuneBtnAction"] = _RuneBtnAction

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer 
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/EquipmentsView.ccbi",proxy, true,"EquipmentsViewOwner")
    _layer = tolua.cast(node,"CCLayer")

    equipMentsContentLayer = tolua.cast(EquipmentsViewOwner["equipMentsContentLayer"],"CCLayer")

    AllEquipsBtn = tolua.cast(EquipmentsViewOwner["AllEquipsBtn"],"CCMenuItemImage")
    WeaponsBtn = tolua.cast(EquipmentsViewOwner["WeaponsBtn"],"CCMenuItemImage")
    ClothingBtn = tolua.cast(EquipmentsViewOwner["ClothingBtn"],"CCMenuItemImage")
    DecoBtn = tolua.cast(EquipmentsViewOwner["DecoBtn"],"CCMenuItemImage")
    RuneBtn = tolua.cast(EquipmentsViewOwner["RuneBtn"], "CCMenuItemImage")
    setSpriteFrame(AllEquipsBtn,true)
    setSpriteFrame(WeaponsBtn,false)
    setSpriteFrame(ClothingBtn,false)
    setSpriteFrame(DecoBtn,false)
    setSpriteFrame(RuneBtn,false)

end

local function setMenuPriority()
    local menu1 = tolua.cast(EquipmentsViewOwner["myCCMenu"], "CCMenu")
    menu1:setHandlerPriority( -130 )
end


-- 该方法名字每个文件不要重复
function getEquipmentsLayer()
	return _layer
end

function createEquipmentsLayer()
    _init()

	function _layer:refresh()
		
	end

    local function _onEnter()
        if runtimeCache.equipPageNum == 0 then
            _allEquipBtnAction()
        elseif runtimeCache.equipPageNum == 1 then
            _WeaponsBtnAction()
        elseif runtimeCache.equipPageNum == 2 then
            _ClothingBtnAction()
        elseif runtimeCache.equipPageNum == 3 then 
            _DecoBtnAction()
        elseif runtimeCache.equipPageNum == 4 then 
            _RuneBtnAction()
        end
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
    end

    local function _onExit()
        _layer = nil
        AllEquipsBtn = nil
        WeaponsBtn = nil
        ClothingBtn = nil
        DecoBtn = nil
        RuneBtn = nil
        equipMentsContentLayer = nil
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