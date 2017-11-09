local _layer = nil
local _priority = -132
local _itemsCost = nil
local _rewardShow = nil
local _sign = nil
local _rewardKey = nil
local _itemsCostForShow = nil
local _isCanFire = true
--local itemsConfig = ConfigureStorage.item

NewYearActivityOwner = NewYearActivityOwner or {}
ccb["ActivityOfNewYearOwner"] = NewYearActivityOwner

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/ActivityOfNewYear.ccbi",proxy,true,"ActivityOfNewYearOwner")
    _layer = tolua.cast(node,"CCLayer")
    --local bgColorLayer = tolua.cast(LoginActivityOwner["bgColorLayer"],"CCLayerColor")
    --bgColorLayer:runAction(CCFadeTo:create(0.3,80))

    local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
    cache:addSpriteFramesWithFile("ccbResources/shadow.plist")
end

local function _popupRewardDetail(itemId)
    
    if havePrefix(itemId, "weapon_") or havePrefix(itemId, "belt_") or havePrefix(itemId, "armor_") then
        -- 装备
        if haveSuffix(itemId, "_shard") then
            itemId = string.sub(itemId,1,-7)
        end
        getMainLayer():getParent():addChild(createEquipInfoLayer(itemId, 2, _priority - 2), 10)
    elseif havePrefix(itemId, "item") or havePrefix(itemId, "key") or havePrefix(itemId, "bag") 
        or havePrefix(itemId, "stuff") or havePrefix(itemId, "drawing") then
        -- 道具
        getMainLayer():getParent():addChild(createItemDetailInfoLayer(itemId, _priority - 2, 1, 1), 10)
    elseif havePrefix(itemId, "shadow") then
        -- 影子
        local dic = {}
        local item = shadowData:getOneShadowConf(itemId)
        dic.conf = item
        dic.id = itemId
        getMainLayer():getParent():addChild(createShadowPopupLayer(dic, nil, nil, _priority - 2, 1), 10)
    elseif havePrefix(itemId, "hero") then
        -- 魂魄
        getMainLayer():getParent():addChild(createHeroInfoLayer(itemId, HeroDetail_Clicked_Handbook, _priority - 2), 10)
    elseif havePrefix(itemId, "book") then
        -- 奥义
        getMainLayer():getParent():addChild(createHandBookSkillDetailLayer(itemId, _priority - 2), 10) 
    elseif havePrefix(itemId, "chapter_") then
        -- 残章
        local bookId = string.format("book_%s", string.split(itemId, "_")[2])
        getMainLayer():getParent():addChild(createHandBookSkillDetailLayer(bookId, _priority - 2), 10) 
    else
        -- 金币 银币
    end
end 

local function onItemClicked1()
    print("zjm click")
    if _rewardShow["0"] ~= "gold" and _rewardShow["0"] ~= "silver" then

        _popupRewardDetail(_rewardShow["0"])
        print("print by wuye============onItemClicked1",_rewardShow["0"])
    end
end
NewYearActivityOwner["viewFormClick_1"] = onItemClicked1
local function onItemClicked2()
    if _rewardShow["1"] ~= "gold" and _rewardShow["1"] ~= "silver" then
        _popupRewardDetail(_rewardShow["1"])
        print("print by wuye============onItemClicked2",_rewardShow["1"])
    end
end
NewYearActivityOwner["viewFormClick_2"] = onItemClicked2
local function onItemClicked3()
    if _rewardShow["2"] ~= "gold" and _rewardShow["2"] ~= "silver" then
        _popupRewardDetail(_rewardShow["2"])
        print("print by wuye============onItemClicked3",_rewardShow["2"])
    end
end
NewYearActivityOwner["viewFormClick_3"] = onItemClicked3
local function onItemClicked4()
    if _rewardShow["3"] ~= "gold" and _rewardShow["3"] ~= "silver" then
        _popupRewardDetail(_rewardShow["3"])
        print("print by wuye============onItemClicked4",_rewardShow["3"])
    end
end
NewYearActivityOwner["viewFormClick_4"] = onItemClicked4
local function onItemClicked5()
    if _rewardShow["4"] ~= "gold" and _rewardShow["4"] ~= "silver" then
        _popupRewardDetail(_rewardShow["4"])
        print("print by wuye============onItemClicked5",_rewardShow["4"])
    end
end
NewYearActivityOwner["viewFormClick_5"] = onItemClicked5

local function smallViewFormClick_1()
    print("print by wuye =================",getCostItemId(1))
    if getCostItemId(1) ~= "gold" and getCostItemId(1) ~= "silver" then
        getMainLayer():addChild(createItemDetailInfoLayer(getCostItemId(1), -141, 1, 1),100)
        --print("print by wuye============onItemClicked5",_rewardShow["4"])
    end
end
NewYearActivityOwner["smallViewFormClick_1"] = smallViewFormClick_1
local function smallViewFormClick_2()
    print("print by wuye =================",getCostItemId(2))
    if getCostItemId(2) ~= "gold" and getCostItemId(2) ~= "silver" then
        getMainLayer():addChild(createItemDetailInfoLayer(getCostItemId(2), -141, 1, 1),100)
        --print("print by wuye============onItemClicked5",_rewardShow["4"])
    end
end
NewYearActivityOwner["smallViewFormClick_2"] = smallViewFormClick_2
local function smallViewFormClick_3()
    print("print by wuye =================",getCostItemId(3))
    if getCostItemId(3) ~= "gold" and getCostItemId(3) ~= "silver" then
        getMainLayer():addChild(createItemDetailInfoLayer(getCostItemId(3), -141, 1, 1),100)
        --print("print by wuye============onItemClicked5",_rewardShow["4"])
    end
end
NewYearActivityOwner["smallViewFormClick_3"] = smallViewFormClick_3
local function smallViewFormClick_4()
    print("print by wuye =================",getCostItemId(4))
    if getCostItemId(4) ~= "gold" and getCostItemId(4) ~= "silver" then
        getMainLayer():addChild(createItemDetailInfoLayer(getCostItemId(4), -141, 1, 1),100)
        --print("print by wuye============onItemClicked5",_rewardShow["4"])
    end
end
NewYearActivityOwner["smallViewFormClick_4"] = smallViewFormClick_4





local function setMenuPriority()
    
    local menu1 = tolua.cast(NewYearActivityOwner["menu"], "CCMenu")
    menu1:setHandlerPriority(_priority - 2)
    
    -- local tableLayer = tolua.cast(ShopChargePopUpOwner["tableLayer"], "CCLayer")
    -- tableLayer:setTouchPriority(_priority - 2)

    -- local sv = tolua.cast(_tableView, "LuaTableView") 
    -- sv:setTouchPriority(_priority - 2)
end

local function onTouchBegan(x, y)
  local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(NewYearActivityOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction( NewYearActivityOwner,"infoBg",_layer )
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

function refreshCostLabel()
    local costItemIndex = 0
    for k,v in pairs(_itemsCost) do
        print(k,v)
        local resDic = userdata:getExchangeResource(k)
        local costItemLabel = tolua.cast(NewYearActivityOwner["res_Lable_"..costItemIndex], "CCLabelTTF")
        costItemLabel:setString(v.."/"..resDic.count)
        costItemIndex = costItemIndex + 1
    end
end

local function litFireCallBack( url, rtnData )
    PrintTable(rtnData)
    refreshCostLabel()
    
end 

local sendFireMsg = function ()
    doActionFun("ACTIVITY_LITFIREWORKS",{FreeFestivalUid,"1"},litFireCallBack)
    _isCanFire = true
end

local showFireEffFun = function ()
    local seq = CCSequence:createWithTwoActions(CCDelayTime:create(1), CCCallFunc:create(sendFireMsg))
    _layer:runAction(seq)
    HLAddParticleScale( "images/eff_gongneng.plist", NewYearActivityOwner["infoBg"], ccp(450*retina , 400*retina), 5, 100, 100, 0.75/retina, 0.75/retina )
end

local function litFireClicked()
    if _isCanFire == true then
        _isCanFire = false 
        local position_index_y = 0
        for k,v in pairs(_itemsCost) do
            position_index_y = position_index_y + 1
            local oriPositionY = 580*retina
            local fixPositionY = 90*retina
            HLAddParticleScale( "images/eff_fire.plist", NewYearActivityOwner["infoBg"], ccp(250*retina , oriPositionY - fixPositionY*position_index_y), 5, 100, 100, 0.75/retina, 0.75/retina )
            if position_index_y == 1 then
                 local seq = CCSequence:createWithTwoActions(CCDelayTime:create(1), CCCallFunc:create(showFireEffFun))
                _layer:runAction(seq)
            end
        end
    end
end
NewYearActivityOwner["litFireClicked"] = litFireClicked

local function litFireCallBack( url, rtnData )
    PrintTable(rtnData)
    refreshCostLabel()
    --_isCanFire = true
end 

local sendTenFireMsg = function ()
    print("烟花十次")
    doActionFun("ACTIVITY_LITFIREWORKS",{FreeFestivalUid,"10"},litFireCallBack)
    _isCanFire = true
end

local showTenFireEffFun = function ()
   
    local seq = CCSequence:createWithTwoActions(CCDelayTime:create(1), CCCallFunc:create(sendTenFireMsg))
    _layer:runAction(seq)
    HLAddParticleScale( "images/eff_gongneng.plist", NewYearActivityOwner["infoBg"], ccp(450*retina, 400*retina), 5, 100, 100, 0.75/retina, 0.75/retina )
    
end

local function litFireTenClicked()
     --doActionFun("ACTIVITY_LITFIREWORKS",{FreeFestivalUid,"10"},litFireCallBack)
    if _isCanFire == true then
        _isCanFire = false 
        local position_index_y = 0
        for k,v in pairs(_itemsCost) do
            position_index_y = position_index_y + 1
            local oriPositionY = 580*retina
            local fixPositionY = 90*retina
            HLAddParticleScale( "images/eff_fire.plist", NewYearActivityOwner["infoBg"], ccp(250*retina , oriPositionY - fixPositionY*position_index_y), 5, 100, 100, 0.75/retina, 0.75/retina )
            if position_index_y == 1 then
                 local seq = CCSequence:createWithTwoActions(CCDelayTime:create(1), CCCallFunc:create(showTenFireEffFun))
                _layer:runAction(seq)
            end
        end
    end
end
NewYearActivityOwner["litFireTenClicked"] = litFireTenClicked


local function rankClickedCallback( url, rtnData )
    PrintTable(rtnData)
    local rankList = rtnData["info"]["freeFestival"]["rankList"]
    local isBtnShow = rtnData["info"]["freeFestival"]["isBtnShow"]
    if getMainLayer() then
        print("number by wuye ",#rankList)
        PrintTable(rankList)
        print("number by wuye 1", table.getTableCount(rankList))
       
        getMainLayer():addChild(createNewYearRankingListLayer(-140,rankList,isBtnShow), 100)
    end
end

local function rankClicked()
    doActionFun("ACTIVITY_GETRANKLISTFORCLIENT",{FreeFestivalUid},rankClickedCallback)
end
NewYearActivityOwner["rankClicked"] = rankClicked

local function introClicked()
    --doActionFun("ACTIVITY_GETRANKLISTFORCLIENT",{FreeFestivalUid},rankClickedCallback)
    if getMainLayer() then
        getMainLayer():addChild(createNewYearActivityIntroView(-140,_sign), 100)
    end

end
NewYearActivityOwner["introClicked"] = introClicked


local function closeItemClick()
    popUpCloseAction(NewYearActivityOwner, "infoBg", _layer)
end
NewYearActivityOwner["closeItemClick"] = closeItemClick

local function _closeView(  )
    _layer:removeFromParentAndCleanup(true) 
end

function getNewYearActivityLayer(  )
    return _layer
end

function setRewardShow(rewardShow)
    print("=============rewardShow")        

    -- for i=0,4 do

    --     local rewardIcon = tolua.cast(NewYearActivityOwner["avatarSprite"..i], "CCSprite")
    --     rewardIcon:setVisible(false)
    -- end

    local rewardIndex = 0

    for k,v in pairs(rewardShow) do
        print(k,v)
        rewardIndex = rewardIndex + 1
        local resDic = userdata:getExchangeResource(v)
        PrintTable(resDic)
        local rewardIcon = tolua.cast(NewYearActivityOwner["avatarSprite"..k], "CCSprite")
        local rankFrame = tolua.cast(NewYearActivityOwner["rankFrame"..k], "CCSprite")
        local contentLayer = tolua.cast(NewYearActivityOwner["contentLayer"..k],"CCLayer")
        local bigSprite = tolua.cast(NewYearActivityOwner["bigSprite"..k],"CCSprite")
        local littleSprite = tolua.cast(NewYearActivityOwner["littleSprite"..k],"CCSprite")

        if havePrefix(resDic.id, "weapon_") or havePrefix(resDic.id, "belt_") or havePrefix(resDic.id, "armor_") then
            -- 装备
            bigSprite:setVisible(true)
            local texture
            if haveSuffix(resDic.id, "_shard") then
                -- chipIcon:setVisible(true)
                texture = CCTextureCache:sharedTextureCache():addImage(string.format("ccbResources/icons/%s.png", resDic.icon))
            else
                texture = CCTextureCache:sharedTextureCache():addImage(resDic.icon)
            end
            if texture then
                bigSprite:setVisible(true)
                bigSprite:setTexture(texture)
            end

        elseif havePrefix(resDic.id, "item") then
            -- 道具
            bigSprite:setVisible(true)
            local texture = CCTextureCache:sharedTextureCache():addImage(resDic.icon)
            if texture then
                bigSprite:setVisible(true)
                bigSprite:setTexture(texture)
            end
        elseif havePrefix(resDic.id, "shadow") then
            -- 影子
            rankFrame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("s_frame.png"))
            rankFrame:setPosition(ccp(rankFrame:getPositionX() + 5,rankFrame:getPositionY() - 5))
            if resDic.icon then
                playCustomFrameAnimation(string.format("yingzi_%s_", resDic.icon), contentLayer, 
                    ccp(contentLayer:getContentSize().width / 2,contentLayer:getContentSize().height / 2), 1, 4,
                    shadowData:getColorByColorRank(resDic.rank))
            end
        elseif havePrefix(resDic.id, "hero") then
            -- 魂魄
            littleSprite:setVisible(true)
            littleSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(resDic.icon))

        elseif havePrefix(resDic.id, "book") then
            -- 奥义
            bigSprite:setVisible(true)
            local texture = CCTextureCache:sharedTextureCache():addImage(resDic.icon)
            if texture then
                bigSprite:setVisible(true)
                bigSprite:setTexture(texture)
            end
        else
            -- 金币 银币
            bigSprite:setVisible(true)
            local texture = CCTextureCache:sharedTextureCache():addImage(resDic.icon)
            if texture then
                bigSprite:setVisible(true)
                bigSprite:setTexture(texture)
            end
        end
        if not havePrefix(resDic.id, "shadow") then
            rankFrame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", resDic.rank)))
        end

        -- NewYearActivityOwner["viewForm_"..tostring(rewardIndex)]:setVisible(true)
    end
end

function getCostItemId(index)
    local costItemIndex = 0
    for k,v in pairs(_itemsCost) do
        costItemIndex = costItemIndex + 1
        if costItemIndex == index then
            return k
        end
    end
end

function setItemCost( itemsCost )
    for i=0,3 do
        local costItemIcon = tolua.cast(NewYearActivityOwner["smallSprite"..i], "CCSprite")
        costItemIcon:setVisible(false)
        local costItemLabel = tolua.cast(NewYearActivityOwner["res_Lable_"..i], "CCLabelTTF")
        --costItemLabel:setString(string.format("%d/%d", resDic.name, v.value))
        costItemLabel:setString("")
    end
    
    local costItemIndex = 0
    for k,v in pairs(itemsCost) do
        print(k,v)
        local resDic = userdata:getExchangeResource(k)
        local costItemIcon = tolua.cast(NewYearActivityOwner["smallSprite"..costItemIndex], "CCSprite")
        local texture = CCTextureCache:sharedTextureCache():addImage(resDic.icon)
        if texture then
            costItemIcon:setTexture(texture)
        end
        costItemIcon:setVisible(true)

        print("===============ww",resDic.count)
        print("===============vv",v)
        local costNumber = v
        local ownNumber = resDic.count
        local costItemLabel = tolua.cast(NewYearActivityOwner["res_Lable_"..costItemIndex], "CCLabelTTF")
        costItemLabel:setString(v.."/"..resDic.count)

        costItemIndex = costItemIndex + 1
        NewYearActivityOwner["smallViewForm_"..tostring(costItemIndex)]:setVisible(true)
    end
end

function createNewYearActivityView(y,rewardShow,itemsCost,sign)  
    _init()
    PrintTable(rewardShow)
    PrintTable(itemsCost)
   
    setItemCost(itemsCost)

    _itemsCost = itemsCost
    _rewardShow = rewardShow

    _sign = sign

    local rankBtn = tolua.cast(NewYearActivityOwner["acceptThePrize"],"CCMenuItem")
    local rankText = tolua.cast(NewYearActivityOwner["acceptThePrize_Lable"],"CCLabelTTF")
    local fireUpBtn = tolua.cast(NewYearActivityOwner["fireUpBtn"],"CCMenuItem")
    local fireUp_Lable = tolua.cast(NewYearActivityOwner["fireUp_Lable"],"CCLabelTTF")
    local fireDownBtn = tolua.cast(NewYearActivityOwner["fireDownBtn"],"CCMenuItem")
    local fireDown_Lable = tolua.cast(NewYearActivityOwner["fireDown_Lable"],"CCLabelTTF")

    --IsRankOpen = 0

    if IsRankOpen == 1 then
        -- fireUpBtn:setPositionX( 320*retina)
        -- fireUp_Lable:setPositionX( 320*retina)
        -- fireDownBtn:setPositionX( 320*retina)
        -- fireDown_Lable:setPositionX( 320*retina)
        -- rankBtn:setVisible(true)
        -- rankText:setVisible(true)
    else
        fireUpBtn:setPositionX(rankBtn:getPositionX())
        fireUp_Lable:setPositionX(rankText:getPositionX())
        fireDownBtn:setPositionX(rankBtn:getPositionX())
        fireDown_Lable:setPositionX(rankText:getPositionX())
        rankBtn:setVisible(false)
        rankText:setVisible(false)
    end

    _priority = (priority ~= nil) and priority or -132

    function _layer:refresh(  )
        -- refreshContentView()
    end

    function _layer:closeView(  )
        _closeView()
    end

    local function _onEnter()
        -- local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        -- _layer:runAction(seq)
        -- _addTableView()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
        --setCanShow()
        --_addTableView()
        --addObserver(NOTI_REFLUSH_SHOP_RECHARGE_LAYER, refreshUI)
        --addObserver(NOTI_APPLE_IAP_SUCC, IAP_Succ)
        --addObserver(NOTI_APPLE_IAP_FAIL, IAP_Fail)

        popUpUiAction( NewYearActivityOwner,"infoBg" )
    end

    local function _onExit()
        _layer = nil
        _priority = -132
        _tableView = nil
        allActivity = nil
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

    setRewardShow(rewardShow)
    
    return _layer
end