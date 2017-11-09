local _layer
local _priority = -132
local _memberInfo
local maxMotion = 5

-- 名字不要重复
unionMemberMenuOwner = unionMemberMenuOwner or {}
ccb["unionMemberMenuOwner"] = unionMemberMenuOwner

local function refressMenus(  )
    -- body
    local upPos = tolua.cast(unionMemberMenuOwner["upPos"],"CCMenu")
    local downPos = tolua.cast(unionMemberMenuOwner["downPos"],"CCMenu")
    local upLabel = tolua.cast(unionMemberMenuOwner["upLabel"],"CCLabelTTF")
    local downLabel = tolua.cast(unionMemberMenuOwner["downLabel"],"CCLabelTTF")
    local closeLabel = tolua.cast(unionMemberMenuOwner["closeLabel"],"CCLabelTTF")
    local fireLabel = tolua.cast(unionMemberMenuOwner["fireLabel"],"CCLabelTTF")
    local nameLabel = tolua.cast(unionMemberMenuOwner["name"],"CCLabelTTF")
    -- 优化 新增转让为会长按钮
    local promotToPresidentBtn = tolua.cast(unionMemberMenuOwner["promotToPresidentBtn"],"CCMenu")
    local promotToPresidentLable = tolua.cast(unionMemberMenuOwner["promotToPresidentLable"],"CCLabelTTF")
    
    upPos:setVisible(true)
    downPos:setVisible(true)
    upLabel:setVisible(true)
    downLabel:setVisible(true)
    closeLabel:setVisible(true)
    fireLabel:setVisible(false)
    promotToPresidentBtn:setVisible(false)
    promotToPresidentLable:setVisible(false)

    if nameLabel then
        nameLabel:setString(_memberInfo.name)
    end
    -- 升降职到极限、没有权限，隐藏按钮
    if _memberInfo.duty <= unionData.selfMemberInfo.duty + 1 or _memberInfo.duty < unionData.selfMemberInfo.duty or (not unionData:IsPermitted(unionData.selfMemberInfo.duty, UNION_PROMOTE)) then
        upPos:setVisible(false)
        upLabel:setVisible(false)
    end
    -- 判断是否为会长 显示或隐藏 提升为会长信息
    if unionData.selfMemberInfo["duty"] == 1 then  -- 自己是会长
        -- 此时有权限决定是否提升对方为会长 再判断对方是否为副会长
        if _memberInfo.duty == 2 then
            promotToPresidentBtn:setVisible(true)
            promotToPresidentLable:setVisible(true)
        end
    end
    if _memberInfo.duty == maxMotion or _memberInfo.duty <= unionData.selfMemberInfo.duty or (not unionData:IsPermitted(unionData.selfMemberInfo.duty, UNION_DEMOTE)) then
        downPos:setVisible(false)
        downLabel:setVisible(false)
    end
    -- 成员为普通或见习，自己有权限
    if _memberInfo.duty >= 4 and unionData:IsPermitted(unionData.selfMemberInfo.duty, UNION_KICK) then
        closeLabel:setVisible(false)
        fireLabel:setVisible(true)
    end
end
-- 查看阵容
local function viewBattleInfo(url, rtnData)
    playerBattleData:fromDic(rtnData.info)
    -- getMainLayer():getParent():addChild(createTeamCompLayer(userdata:getUserBattleInfo(), playerBattleData), 100)
    getMainLayer():getParent():addChild(createTeamPopupLayer(-140))

    _layer:removeFromParentAndCleanup(true)
end
-- 邀请好友成功
local function inviteFriendCallBack( url, rtnData )
    -- PrintTable(rtnData)
    if rtnData.code == 200 then
        ShowText(HLNSLocalizedString("好友请求已发送"))
    end
end

local function upPosCallBack( url,rtnData )
    unionData:fromDic(rtnData.info)
    local duty = tostring(_memberInfo.duty)
    -- 更新该成员信息
    for k,v in pairs(unionData.members) do
        if v.name == _memberInfo.name then
            _memberInfo = v
        end
    end
    ShowText(string.format(HLNSLocalizedString("%s已经由%s升职为%s"), _memberInfo.name, ConfigureStorage.leagueDuty[duty].name, ConfigureStorage.leagueDuty[tostring(_memberInfo.duty)].name))
    unionMember_freshData()
    refressMenus()
end

local function downPosCallBack( url,rtnData )
    unionData:fromDic(rtnData.info)
    local duty = tostring(_memberInfo.duty)
    -- 更新该成员信息
    for k,v in pairs(unionData.members) do
        if v.name == _memberInfo.name then
            _memberInfo = v
        end
    end
    ShowText(string.format(HLNSLocalizedString("%s已经由%s降职为%s"), _memberInfo.name, ConfigureStorage.leagueDuty[duty].name, ConfigureStorage.leagueDuty[tostring(_memberInfo.duty)].name))
    unionMember_freshData()
    refressMenus()
end
local function fireCallBack( url,rtnData )
    -- body
    ShowText(string.format(HLNSLocalizedString("成员%s已被开除"),_memberInfo.name))
    unionData:fromDic(rtnData.info)
    unionMember_freshData()
    _layer:removeFromParentAndCleanup(true)
end
local function cardCancelAction(  )
    
end
local function cardConfirmAction(  )
    -- 开除成员
    doActionFun("LEAGUE_FIRED", {_memberInfo.playerId}, fireCallBack)
end
local function closeBtnClick()
    if unionData:IsPermitted(unionData.selfMemberInfo.duty, UNION_KICK) and _memberInfo.duty >= 4 then
        _layer:addChild(createSimpleConfirCardLayer(HLNSLocalizedString("确定开除此成员？")))
        SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
        SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
    else
        _layer:removeFromParentAndCleanup(true)
    end
end

local function closeItemClick(  )
    _layer:removeFromParentAndCleanup(true) 
end
local function tacticClicked(  )
    Global:instance():TDGAonEventAndEventData("check")
    doActionFun("ARENA_GET_BATTLE_INFO", {_memberInfo.playerId}, viewBattleInfo)
end
local function leaveMsgClicked(  )
    getMainLayer():addChild(createLeaveMessageLayer(_memberInfo.name, _memberInfo.playerId, -500))
end
local function addFriendClicked(  )
    doActionFun("INVITE_FRIEND_URL",{ _memberInfo.playerId },inviteFriendCallBack)
end

-- 转让会长回调函数
local function promotToPresidentCallBack( url,rtnData )
    unionData:fromDic(rtnData.info)
    
    ShowText( HLNSLocalizedString("union.promotToPresidentSuc") ) 
    
    unionMember_freshData()
    refressMenus()
end
-- 转让为会长
local function promotToPresidentClicked(  )
    
    local function promotToPresidentConfirmClick()

        doActionFun("LEAGUEABDICATE",{_memberInfo.playerId},promotToPresidentCallBack) -- 转让为会长
    end
    
    local text = HLNSLocalizedString("union.transferCDR")
    CCDirector:sharedDirector():getRunningScene():addChild(createSimpleConfirCardLayer(text))
    SimpleConfirmCard.confirmMenuCallBackFun = promotToPresidentConfirmClick
    SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction 

end

local function upPosClicked(  )
    if unionData:IsPermitted(unionData.selfMemberInfo.duty, UNION_PROMOTE) and _memberInfo.duty > unionData.selfMemberInfo.duty then
        if unionData:IsDutyFull(_memberInfo.duty - 1) then
            ShowText(string.format(HLNSLocalizedString("联盟最多拥有%d个%s"),unionData:getMaxNumberByDuty(_memberInfo.duty - 1),unionData:getNameByDuty(_memberInfo.duty - 1)))
        else
            doActionFun("LEAGUE_CHANGEPOS",{ _memberInfo.playerId, -1},upPosCallBack) -- -1 升职
        end
    else
        ShowText(HLNSLocalizedString("您的权限不足"))
    end
end

local function downPosClicked(  )
    if unionData:IsPermitted(unionData.selfMemberInfo.duty, UNION_DEMOTE) and _memberInfo.duty > unionData.selfMemberInfo.duty then
        if unionData:IsDutyFull(_memberInfo.duty + 1) then
            ShowText(string.format(HLNSLocalizedString("联盟最多拥有%d个%s"),unionData:getMaxNumberByDuty(_memberInfo.duty + 1),unionData:getNameByDuty(_memberInfo.duty + 1)))
        else
            doActionFun("LEAGUE_CHANGEPOS",{ _memberInfo.playerId, 1},downPosCallBack) -- 1 降职
        end
    else
        ShowText(HLNSLocalizedString("您的权限不足"))
    end
end

unionMemberMenuOwner["closeItemClick"] = closeItemClick     -- 关闭
unionMemberMenuOwner["closeBtnClick"] = closeBtnClick     -- 关闭或开除
unionMemberMenuOwner["tacticClicked"] = tacticClicked   -- 阵容
unionMemberMenuOwner["leaveMsgClicked"] = leaveMsgClicked       -- 留言
unionMemberMenuOwner["addFriendClicked"] = addFriendClicked     -- 加好友
unionMemberMenuOwner["upPosClicked"] = upPosClicked      -- 升职
unionMemberMenuOwner["downPosClicked"] = downPosClicked  -- 降职
unionMemberMenuOwner["promotToPresidentClicked"] = promotToPresidentClicked      -- 转让为会长


-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/unionMemberMenu.ccbi",proxy, true,"unionMemberMenuOwner")
    _layer = tolua.cast(node,"CCLayer")
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(unionMemberMenuOwner["infoBg"], "CCSprite")
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
    local menu1 = tolua.cast(unionMemberMenuOwner["closeMenu"], "CCMenu")
    menu1:setHandlerPriority(_priority - 1)
end

-- 该方法名字每个文件不要重复
function getUnionMemberMenu()
	return _layer
end

function createUnionMemberMenu( info,priority)
    _priority = (priority ~= nil) and priority or -132
    _memberInfo = info
    _init()

    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
        refressMenus()
    end

    local function _onExit()
        _layer = nil
        _priority = -132
        _memberInfo = nil
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