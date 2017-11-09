local _layer
local _UnionMainView
local _info
local _free
local _gold
local _message
local count = 1
local POST_MAX = 3

unionJuanXianOwner = unionJuanXianOwner or {}
ccb["unionJuanXianOwner"] = unionJuanXianOwner

local function refreshMsg(  )
    -- body
    local gainLabel1 = tolua.cast(unionJuanXianOwner["gainLabel1"],"CCLabelTTF")
    local gainLabel2 = tolua.cast(unionJuanXianOwner["gainLabel2"],"CCLabelTTF")
    local gainLabel3 = tolua.cast(unionJuanXianOwner["gainLabel3"],"CCLabelTTF")
    local len = getMyTableCount(_message)
    local str = {}
    str[1] = ""
    str[2] = ""
    str[3] = ""
    if len <= POST_MAX then
        for i=1,len do
            if _message[tostring(i-1)] then
                str[i] = _message[tostring(i-1)].message 
            end
        end
    else
        str[1] = _message[tostring(math.mod(count + 1,len))].message
        str[2] = _message[tostring(math.mod(count,len))].message
        str[3] = _message[tostring(math.mod(count - 1,len))].message
    end
    gainLabel1:setString(str[1])
    gainLabel2:setString(str[2])
    gainLabel3:setString(str[3])
    count = count + 1
end

local function refreshJuanxian( )
    -- body
    print(_free,_gold)
    _UnionMainLayer:refreshData()
    local donate = tolua.cast(unionJuanXianOwner["donate"],"CCMenuItemImage")
    local superDonate = tolua.cast(unionJuanXianOwner["superDonate"], "CCMenuItemImage")
    if _free == 1 then
        donate:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("juanxian_btn_1.png"))
        -- donate:setEnabled(false)
    end
    if _gold == 1 then
        superDonate:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("chaoqiangjuanxian_btn_1.png"))
        -- superDonate:setEnabled(false)
    end
end

local function donateCallBack( url,rtnData )
    -- body
    _free = rtnData.info.contribution.free
    _message = rtnData.info.contribution.contributionMessages
    ShowText(string.format(HLNSLocalizedString("联盟经验增加100")))
    unionData:fromDic( rtnData.info )
    refreshJuanxian()
end

local function superDonateCallBack( url,rtnData )
    -- body
    _gold = rtnData.info.contribution.gold
    _message = rtnData.info.contribution.contributionMessages
    ShowText(string.format(HLNSLocalizedString("联盟经验增加300")))
    unionData:fromDic( rtnData.info )
    refreshJuanxian()
end
local function closeItemClick(  )
    _UnionMainView:gotoShowInner()
end

local function donateClick(  )
    if _free == 1 then
        ShowText(HLNSLocalizedString("今日您已成功为本盟贡献大量食品，\n请明日再来！"))
    else
        doActionFun("LEAGUE_DONATE",{ 1 },donateCallBack)
    end
end

local function superDonateClick(  )
    -- body
    if _gold == 1 then
        ShowText(HLNSLocalizedString("今日您已慷慨为本盟捐献大量财宝，\n不要忘了再接再厉，继续保持噢!"))
    else
        doActionFun("LEAGUE_DONATE",{ 2 },superDonateCallBack)
    end
end
unionJuanXianOwner["closeItemClick"] = closeItemClick
unionJuanXianOwner["donateClick"] = donateClick
unionJuanXianOwner["superDonateClick"] = superDonateClick


-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/unionJuanXianLayer.ccbi",proxy, true,"unionJuanXianOwner")
    _layer = tolua.cast(node,"CCLayer")
end

-- 该方法名字每个文件不要重复
function getUnionJuanXianLayer()
	return _layer
end

function createUnionJuanXianLayer( unionMainView )

    _UnionMainView = unionMainView
    _info = unionData.selfMemberInfo

    _init()
    

    local function donateInfoCallBack( url,rtnData )
        _free = rtnData.info.contribution.free
        _gold = rtnData.info.contribution.gold
        _message = rtnData.info.contribution.contributionMessages
        refreshJuanxian()
        refreshMsg()
    end

    local function _onEnter()

        doActionFun("LEAGUE_DONATE_INFO",{ },donateInfoCallBack)
        addObserver(NOTI_GOLD_CLICK_REFRESH_TIMER, refreshMsg)
    end

    local function _onExit()
        _layer = nil
        _info = nil
        _free = nil
        _gold = nil
        _message = nil
        count = 1
        removeObserver(NOTI_GOLD_CLICK_REFRESH_TIMER, refreshMsg)
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