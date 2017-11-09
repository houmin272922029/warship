local _layer

UnionContributionPopUpOwner = UnionContributionPopUpOwner or {}
ccb["UnionContributionPopUpOwner"] = UnionContributionPopUpOwner

local function closeItemClick(  )
    _layer:removeFromParentAndCleanup(true)
end

UnionContributionPopUpOwner["closeItemClick"] = closeItemClick

local function contributeCallBack( url,rtnData )
    if rtnData.code == 200 then
        ShowText(HLNSLocalizedString("捐献成功"))
    end
    unionData:fromDic(rtnData.info)
    getUnionMainLayer():refreshData()
end

UnionContributionPopUpOwner["onContributeTaped"] = function ( tag,sender )
    if tag == 1 then
        local needSilver = ConfigureStorage.leagueDonate["1"].cost
    else
        local needGold = ConfigureStorage.leagueDonate[tostring(tag)].cost
        if userdata.gold < needGold then
            local function cardConfirmAction(  )
                CCDirector:sharedDirector():getRunningScene():addChild(createShopRechargeLayer(-400), 100)
            end
            local function cardCancelAction(  )
                
            end 
            local text = HLNSLocalizedString("qingjiao.goldEnough")
            CCDirector:sharedDirector():getRunningScene():addChild(createSimpleConfirCardLayer(text), 100)
            SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
            SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
            return
        end
    end
    -- if unionData:isOneDonateCanUse( tag ) then
        doActionFun("UNION_CONTRIBUTE_ACTIONF", {tag}, contributeCallBack)
    -- else
    --     ShowText("你已超过捐献次数")
    -- end
end

local function updateLabel( labelName,string )
    print(labelName)
    local label = tolua.cast(UnionContributionPopUpOwner[labelName],"CCLabelTTF")
    label:setVisible(true)
    label:setString(string)
end

local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/UnionContributionPopUp.ccbi",proxy, true,"UnionContributionPopUpOwner")
    _layer = tolua.cast(node,"CCLayer")
    -- ConfigureStorage.leagueDonate
    for i=1,3 do
        local label = tolua.cast(UnionContributionPopUpOwner["despLabel"..i],"CCLabelTTF")
        local str = ConfigureStorage.leagueDonate[tostring(i)].state
        label:setString(str)
    end
end
local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(UnionContributionPopUpOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        _layer:removeFromParentAndCleanup(true)
        return true
    end
    return true
end

local function onTouchEnded(x, y)

end

local function onTouch(eventType, x, y)
    if eventType == "began" then   
        return onTouchBegan(x, y)
    elseif eventType == "moved" then
    else
        return onTouchEnded(x, y)
    end
end

local function setMenuPriority()
    local menu1 = tolua.cast(UnionContributionPopUpOwner["closeMenu"], "CCMenu")
    menu1:setHandlerPriority(_priority - 1)
end

function getUnionContributionLayer()
	return _layer
end

function createUnionContributionLayer( )
    _priority = (priority ~= nil) and priority or -132
    _init()


    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
        -- getUnionShopData()
    end

    local function _onExit()
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


    _layer:registerScriptTouchHandler(onTouch ,false ,_priority ,true )
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end