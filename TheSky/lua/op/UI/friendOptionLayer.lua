local _layer
local _priority

local editBox
local _name
local _uid

local _from

local _uiType    -- 0：好友页面   1：仇敌页面    2：关注页面

friendPopUpCallBackFun = {
    successFun = nil,
    unFollowFun = nil,
}


-- 名字不要重复
FriendOptionLayerOwner = FriendOptionLayerOwner or {}
ccb["FriendOptionLayerOwner"] = FriendOptionLayerOwner

local function closeItemClick(  )
    popUpCloseAction( FriendOptionLayerOwner,"infoBg",_layer ) 
end

local function sendMessageCallBack( url,rtnData )
    if rtnData["code"] == 200 then
        ShowText(HLNSLocalizedString("sendMessage.success"))
    end
end

local function actionTap1(  )
    -- if _uiType == 0 then
    --     getMainLayer():addChild(createLeaveMessageLayer(_name,_uid,-500))
    -- elseif _uiType == 1 then
    --     getMainLayer():addChild(createLeaveMessageLayer(_name,_uid,-500))
    -- elseif _uiType == 2 then
    -- end
    getMainLayer():addChild(createLeaveMessageLayer(_name,_uid,-500),50)
end

local function _getBattleInfoCallback(url,rtnData)
    if rtnData.code == 200 then
        playerBattleData:fromDic(rtnData.info)
        -- getMainLayer():getParent():addChild(createTeamCompLayer(userdata:getUserBattleInfo(), playerBattleData))
        getMainLayer():getParent():addChild(createTeamPopupLayer(-140))
        _layer:removeFromParentAndCleanup(true)
    end
end

local function actionTap2(  )
    if _uiType == 0 then
        --阵容
        doActionFun("ARENA_GET_BATTLE_INFO", {_uid}, _getBattleInfoCallback)
    elseif _uiType == 1 then
        --反击
        if _from == 0 then
            -- 前往论剑
            popUpCloseAction( FriendOptionLayerOwner,"infoBg",_layer )
            getMainLayer():gotoArena()
        elseif _from ==  1 then
            -- 前往残障
            popUpCloseAction( FriendOptionLayerOwner,"infoBg",_layer )
            getMainLayer():gotoAdventure()
        end
    elseif _uiType == 2 then
        --取消关注
        local function cancelFollowFriendCallBack( url,rtnData )
            if rtnData.code == 200 then
                ShowText(HLNSLocalizedString("fri.attent.cancel"))
                if friendPopUpCallBackFun.unFollowFun then
                    friendPopUpCallBackFun.unFollowFun()
                    popUpCloseAction( FriendOptionLayerOwner,"infoBg",_layer )
                end
            end
        end
        doActionFun("CANCEL_FOLLOW_FRIEND_URL",{ _uid },cancelFollowFriendCallBack)
    end
end
local function actionTap3(  )
    if _uiType == 0 then
        --删除好友
        local function deleteFriendCallBack( url,rtnData )
            if rtnData.code == 200 then
                if friendPopUpCallBackFun.successFun then
                    friendPopUpCallBackFun.successFun()
                    ShowText(HLNSLocalizedString("fri.del.succ"))
                    popUpCloseAction( FriendOptionLayerOwner,"infoBg",_layer )
                end
            end
        end
        doActionFun("DELETE_FRIEND_URL",{ _uid },deleteFriendCallBack)
    elseif _uiType == 1 then
        -- 关注
        local function followFriendCallBack( url,rtnData )
            if rtnData.code == 200 then
                ShowText(HLNSLocalizedString("fri.attent.succ"))
                popUpCloseAction( FriendOptionLayerOwner,"infoBg",_layer )
            end
        end
        doActionFun("FOLLOW_FRIEND_URL",{ _uid },followFriendCallBack)
    elseif _uiType == 2 then
    end
end
local function actionTap4(  )
    -- if _uiType == 0 then
    --     _layer:removeFromParentAndCleanup(true)
    -- elseif _uiType == 1 then
    --     _layer:removeFromParentAndCleanup(true)
    -- elseif _uiType == 2 then
    --     _layer:removeFromParentAndCleanup(true)
    -- end
    popUpCloseAction( FriendOptionLayerOwner,"infoBg",_layer )
end

local function onCancelTap(  )
    popUpCloseAction( FriendOptionLayerOwner,"infoBg",_layer )
end

FriendOptionLayerOwner["closeItemClick"] = closeItemClick
FriendOptionLayerOwner["actionTap1"] = actionTap1
FriendOptionLayerOwner["actionTap2"] = actionTap2
FriendOptionLayerOwner["actionTap3"] = actionTap3
FriendOptionLayerOwner["actionTap4"] = actionTap4
-- 刷新UI数据
local function _refreshData()
    local btn1 = tolua.cast(FriendOptionLayerOwner["btn1"],"CCMenuItemImage")
    local btn2 = tolua.cast(FriendOptionLayerOwner["btn2"],"CCMenuItemImage")
    local btn3 = tolua.cast(FriendOptionLayerOwner["btn3"],"CCMenuItemImage")
    local btn4 = tolua.cast(FriendOptionLayerOwner["btn4"],"CCMenuItemImage")

    local title1 = tolua.cast(FriendOptionLayerOwner["title1"],"CCSprite")
    local title2 = tolua.cast(FriendOptionLayerOwner["title2"],"CCSprite")
    local title3 = tolua.cast(FriendOptionLayerOwner["title3"],"CCSprite")
    local title4 = tolua.cast(FriendOptionLayerOwner["title4"],"CCSprite")

    local function setAllDisVisible(  )
        title1:setVisible(false)
        title2:setVisible(false)
        title3:setVisible(false)
        title4:setVisible(false)

        btn1:setVisible(false)
        btn2:setVisible(false)
        btn3:setVisible(false)
        btn4:setVisible(false)
    end

    if _uiType == 0 then
        setAllDisVisible()

        title1:setVisible(true)
        title2:setVisible(true)
        title3:setVisible(true)
        title4:setVisible(true)

        title1:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("liuyan_title.png"))
        title2:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("zhenrong_text.png"))
        title3:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("shanchuhaoyou_text.png"))
        title4:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("guanbi_text.png"))

        btn1:setVisible(true)
        btn2:setVisible(true)
        btn3:setVisible(true)
        btn4:setVisible(true)

        -- frame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", info.rank)))
    elseif _uiType == 1 then
        setAllDisVisible()

        title1:setVisible(true)
        title2:setVisible(true)
        title3:setVisible(true)
        title4:setVisible(true)

        title1:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("liuyan_title.png"))
        if _from then
            if _from == 0 then
                title2:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("juedou_title.png"))
            else
                title2:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("fanji_title.png"))
            end
        else
            title2:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("fanji_title.png"))
        end
        
        title3:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("guanzhu_title.png"))
        title4:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("guanbi_text.png"))

        btn1:setVisible(true)
        btn2:setVisible(true)
        btn3:setVisible(true)
        btn4:setVisible(true)
    elseif _uiType == 2 then
        setAllDisVisible()

        title1:setVisible(true)
        title2:setVisible(true)
        title3:setVisible(false)
        title4:setVisible(true)

        title1:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("liuyan_title.png"))
        title2:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("quxiaoguanzhu_title.png"))
        -- title3:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("shanchuhaoyou_text.png"))
        title4:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("guanbi_text.png"))

        btn1:setVisible(true)
        btn2:setVisible(true)
        btn3:setVisible(false)
        btn4:setVisible(true)
    end
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer

    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/FriendOptionLayer.ccbi",proxy, true,"FriendOptionLayerOwner")
    _layer = tolua.cast(node,"CCLayer")

    _refreshData()

    local titleLabel = tolua.cast(FriendOptionLayerOwner["titleLabel"],"CCLabelTTF") 
    titleLabel:setString(_name)
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(FriendOptionLayerOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction( FriendOptionLayerOwner,"infoBg",_layer )
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
    local menu1 = tolua.cast(FriendOptionLayerOwner["closeMenu"], "CCMenu")
    menu1:setHandlerPriority(_priority - 1)
    -- local edixBg = LeaveMessageOwner["edixBg"]
    -- editBox:setTouchPriority(_priority - 1)
end

-- 该方法名字每个文件不要重复
function getFriendOptionLayer()
	return _layer
end

function createFriendOptionLayer( name,uid,uitype,priority,from)
    _name = name
    _uid = uid
    _from = from
    _uiType = uitype
    _priority = (priority ~= nil) and priority or -132
    _init()

    local function _onEnter()
        print("onEnter")
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        popUpUiAction( FriendOptionLayerOwner,"infoBg" )
    end

    local function _onExit()
        print("WOQUonExit")
        _layer = nil
        _titleId = nil
        _priority = -132
        _uiType = nil
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