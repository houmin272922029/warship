local _UnionMainLayer

UnionMainViewOwner = UnionMainViewOwner or {}
ccb["UnionMainViewOwner"] = UnionMainViewOwner

local function _titleVisible(visible)
    local titleLayer = UnionMainViewOwner["titleLayer"] 
    titleLayer:setVisible(visible)
    local titleMenu = UnionMainViewOwner["titleMenu"]
    titleMenu:setVisible(visible)
end


-- 联盟信息
local function unionInfoClick()
    CCDirector:sharedDirector():getRunningScene():addChild(createUnionDetailInfoLayer())
end
UnionMainViewOwner["unionInfoClick"] = unionInfoClick

local function _clearUnionCententLayer()
    local UnionCententLayer = UnionMainViewOwner["UnionCententLayer"] 
    UnionCententLayer:removeAllChildrenWithCleanup(true)
end

-- 加入公会后的 初始页面
local function _showInner(  )
    _clearUnionCententLayer()
    local UnionCententLayer = UnionMainViewOwner["UnionCententLayer"]
    UnionCententLayer:addChild(createUnionInnerLayer(_UnionMainLayer))
end

-- 创建公会
local function _createUnion( )
    -- body
    print(" Print By lixq ---- _createUnion")
    local unionCreateLayer = createUnionCreateLayer(_UnionMainLayer, -135)
    getMainLayer():addChild(unionCreateLayer, 2000)
end

-- 加入公会
local function _joinUnion( )
    -- body
    print(" Print By lixq ---- _joinUnion")
    _clearUnionCententLayer()
    -- getMainLayer():TitleBgVisible(true)
    local UnionCententLayer = UnionMainViewOwner["UnionCententLayer"]
    UnionCententLayer:addChild(createUnionJoinLayer(_UnionMainLayer))
end

-- 活动方法
-----------------------------------------------
UnionActFun = {}

-- 活动1
UnionActFun[UnionActType.act1] = function ( )
    -- body
    print(" Print By lixq ---- UnionActType.act1")
end

-- 活动2
UnionActFun[UnionActType.act2] = function ( )
    -- body
    print(" Print By lixq ---- UnionActType.act2")
end

-- 活动3
UnionActFun[UnionActType.act3] = function ( )
    -- body
    print(" Print By lixq ---- UnionActType.act3")
end

-- 活动4
UnionActFun[UnionActType.act4] = function ( )
    -- body
    print(" Print By lixq ---- UnionActType.act4")
end

-- 捐献
UnionActFun[UnionActType.UNION_DONATE] = function ( )
    -- body
    print(" Print By lixq ---- UnionActType.UNION_DONATE")
    if unionData and unionData.detail and unionData.detail["level"] then
        if ConfigureStorage.leagueFuncOpen and ConfigureStorage.leagueFuncOpen["UNION_DONATE"] and ConfigureStorage.leagueFuncOpen["UNION_DONATE"]["level"] then
            if tonumber(unionData.detail["level"]) >= tonumber(ConfigureStorage.leagueFuncOpen["UNION_DONATE"]["level"]) then
                -- 进入方法
                _clearUnionCententLayer()
                -- getMainLayer():TitleBgVisible(true)
                local UnionCententLayer = UnionMainViewOwner["UnionCententLayer"]
                UnionCententLayer:addChild(createUnionJuanXianLayer(_UnionMainLayer))
            else
                ShowText(HLNSLocalizedString("union.needLevel", tonumber(ConfigureStorage.leagueFuncOpen["UNION_DONATE"]["level"])))
            end
        end
    end 
end
    
-- 猜拳
UnionActFun[UnionActType.UNION_GUESSING] = function ( )
    -- body
    print(" Print By lixq ---- UnionActType.UNION_GUESSING")
    if unionData and unionData.detail and unionData.detail["level"] then
        if ConfigureStorage.leagueFuncOpen and ConfigureStorage.leagueFuncOpen["UNION_GUESSING"] and ConfigureStorage.leagueFuncOpen["UNION_GUESSING"]["level"] then
            if tonumber(unionData.detail["level"]) >= tonumber(ConfigureStorage.leagueFuncOpen["UNION_GUESSING"]["level"]) then
                -- 进入方法
                _clearUnionCententLayer()
                -- getMainLayer():TitleBgVisible(true)
                local UnionCententLayer = UnionMainViewOwner["UnionCententLayer"]
                UnionCententLayer:addChild(createUnionFingerGuessingLayer(_UnionMainLayer))
            else
                ShowText(HLNSLocalizedString("union.needLevel", tonumber(ConfigureStorage.leagueFuncOpen["UNION_GUESSING"]["level"])))
            end
        end
    end
end
-----------------------------------------------

-- 修改公告
local function _showChangeTitle()
    -- body
    print(" Print By lixq ---- _showChangeTitle")
    getMainLayer():getParent():addChild(createUnionTitleChangeLayer(_UnionMainLayer))
end

-- 修改公告
local function unionTitleClick(  )
    -- body
    if getTeamPopupLayer() then
        return
    end
    if unionData:IsPermitted(unionData.selfMemberInfo.duty, UNION_CHANGENOTICE ) then
        _showChangeTitle()
    else
        ShowText(HLNSLocalizedString("会长和副会长可修改联盟公告"))
    end
end
UnionMainViewOwner["unionTitleClick"] = unionTitleClick

-- 活动跳转方法
local function _showActivity( tag )
    -- body
    print(" Print By lixq ---- _showActivity ", tag)
    UnionActFun[tag]()
end

-- 管理
local function _showManage( )
    -- body
    print(" Print By lixq ---- _showManage")
    _clearUnionCententLayer()
    -- getMainLayer():TitleBgVisible(true)
    local UnionCententLayer = UnionMainViewOwner["UnionCententLayer"]
    UnionCententLayer:addChild(createUnionManageLayer(_UnionMainLayer))
end

-- 成员
local function _showMember( )
    -- body
    print(" Print By lixq ---- _showMember")
    _clearUnionCententLayer()
    -- getMainLayer():TitleBgVisible(true)
    local UnionCententLayer = UnionMainViewOwner["UnionCententLayer"]
    UnionCententLayer:addChild(createUnionMemberLayer(_UnionMainLayer))
end

-- 聊天
local function _showChat( )
    -- body
    print(" Print By lixq ---- _showChat")
    -- _clearUnionCententLayer()
    getMainLayer():TitleBgVisible(true)
    getMainLayer():gotoChatLayer(ChatType.uniteChat,true)
end

-- 排行
local function _showRank( )
    -- body
    print(" Print By lixq ---- UnionCententLayer()_showRank")
    _clearUnionCententLayer()
    -- getMainLayer():TitleBgVisible(true)
    local UnionCententLayer = UnionMainViewOwner["UnionCententLayer"]
    UnionCententLayer:addChild(createUnionRankLayer(_UnionMainLayer))
end

-- 战利品
local function _showAward( )
    -- body
    print(" Print By lixq ---- _showAward")
    ShowText(HLNSLocalizedString("component.close"))
    -- _clearUnionCententLayer()
    -- getMainLayer():TitleBgVisible(true)
end

-- 本盟动态
local function _showInformation( )
    -- body
    print(" Print By lixq ---- _showInformation")
    -- ShowText(HLNSLocalizedString("component.close"))
    -- _clearUnionCententLayer()
    CCDirector:sharedDirector():getRunningScene():addChild(createUnionInformationLayer(-132), 100)

end

-- 没有加入公会
local function _showOuter( )
    -- body
    print(" Print By lixq ---- _showOuter")
    _clearUnionCententLayer()
    -- getMainLayer():TitleBgVisible(true)
    local UnionCententLayer = UnionMainViewOwner["UnionCententLayer"]
    UnionCententLayer:addChild(createUnionOuterLayer(_UnionMainLayer))
end

-- 联盟建设
local function _showBuild()
    print("open _showBuild")
    _clearUnionCententLayer()
    -- getMainLayer():TitleBgVisible(true)
    local UnionCententLayer = UnionMainViewOwner["UnionCententLayer"]
    UnionCententLayer:addChild(createUnionUpgrateLayer())
end

local function _showDisCandy(  )
    _clearUnionCententLayer()
    -- getMainLayer():TitleBgVisible(true)
    local UnionCententLayer = UnionMainViewOwner["UnionCententLayer"]
    UnionCententLayer:addChild(createUnionCandyLayer())
end

-- 联盟战争
local function _showBattle()
    _titleVisible(false)
    if ConfigureStorage.leagueFuncOpen and ConfigureStorage.leagueFuncOpen["UNION_WAR"] and ConfigureStorage.leagueFuncOpen["UNION_WAR"]["level"] then
        if tonumber(unionData.detail["level"]) >= tonumber(ConfigureStorage.leagueFuncOpen["UNION_WAR"]["level"]) then
            _clearUnionCententLayer()
            local UnionCententLayer = UnionMainViewOwner["UnionCententLayer"]
            UnionCententLayer:addChild(createUnionBattleLayer())
        else
            ShowText(HLNSLocalizedString("union.needLevel", tonumber(ConfigureStorage.leagueFuncOpen["UNION_WAR"]["level"])))
        end
    end
end

-- 联盟商城
local function _showShop()
    print(" Print By cyg ---- _showMember")
    _clearUnionCententLayer()
    -- getMainLayer():TitleBgVisible(true)
    local UnionCententLayer = UnionMainViewOwner["UnionCententLayer"]
    UnionCententLayer:addChild(createUnionShopLayer())
end

-- 联盟跨服竞速战
-- 1、入口
local function _showRacingBattle()
    local function getUnionRacingBattleDataCallBack( ... )
        -- body
    
        print("联盟竞速战斗入口")
        _clearUnionCententLayer()
        -- getMainLayer():TitleBgVisible(true)
        local UnionCententLayer = UnionMainViewOwner["UnionCententLayer"]
        UnionCententLayer:addChild(createUnionRacingBattleViewLayer())
    end

    local function errorCallback()
        -- body
        ShowText(HLNSLocalizedString("ERR_7010"))
    end
    doActionFun("CROSSSERVERRACEBATTLE_GETMAININFO",{},getUnionRacingBattleDataCallBack ,errorCallback)
end
-- 2、战斗开始
local function _showRacingBattleStart()
    _titleVisible(false)
    local function callBack( url,rtnData )
        local data = rtnData.info
        _clearUnionCententLayer()
        print("清除原有layer")
        local UnionCententLayer = UnionMainViewOwner["UnionCententLayer"]
        UnionCententLayer:addChild(createUnionRacingBattleStartViewLayer(data))
    end
    doActionFun("CROSSSERVERRACEBATTLE_BEGIN",{},callBack)

end
-- 3、参赛服务器
local function _showRacingBattleServerList()
    local function getUnionRacingBattleDataCallBack( url,rtnData )
        local data = rtnData.info
        -- _clearUnionCententLayer()
        -- getMainLayer():TitleBgVisible(true)
        local UnionCententLayer = UnionMainViewOwner["UnionCententLayer"]
        UnionCententLayer:addChild(createUnionRacingBattleServerListLayer(data))
    end
    doActionFun("CROSSSERVERRACEBATTLE_GETMAININFO",{},getUnionRacingBattleDataCallBack)
end
-- 4、查看奖励
local function _showRacingBattleReward()
    _titleVisible(false)
    _clearUnionCententLayer()
    -- getMainLayer():TitleBgVisible(true)
    local UnionCententLayer = UnionMainViewOwner["UnionCententLayer"]
    UnionCententLayer:addChild(createUnionRacingBattleRewardViewLayer())
end
-- 5、战绩
local function _showRacingBattleRecord()
    
    local function getUnionRacingBattleDataCallBack( url,rtnData )
        local data = rtnData.info
        _clearUnionCententLayer()
        -- getMainLayer():TitleBgVisible(true)
        local UnionCententLayer = UnionMainViewOwner["UnionCententLayer"]
        UnionCententLayer:addChild(createUnionRacingBattleRecordViewLayer(data))
    end
    doActionFun("CROSSSERVERRACEBATTLE_GETMARKRANK",{},getUnionRacingBattleDataCallBack)

end

local function _refreshData()
    -- 角色名
    local roleNameTTF = UnionMainViewOwner["RoleNameTTF"]
    roleNameTTF:setString(userdata.name)
    -- roleNameTTF:enableShadow(CCSizeMake(2, -2), 1, 0)
    -- roleNameTTF:enableStroke(ccc3(0, 0, 0), 0.5)

    -- 角色等级
    local roleLevelTTF = UnionMainViewOwner["RoleLevelTTF"]
    roleLevelTTF:setString(HLNSLocalizedString("LV:%d", userdata.level))
    -- roleLevelTTF:enableStroke(ccc3(0, 0, 0), 0.5)

    -- 联盟等级
    local unionLevelTTF = UnionMainViewOwner["UnionLevelTTF"]
    -- 联盟名称
    local unionNameTTF = UnionMainViewOwner["UnionNameTTF"]
    -- 联盟人数
    local unionMemberCountTTF = UnionMainViewOwner["UnionMemberCountTTF"]
    -- 联盟经验
    local unionExpDetailTTF = UnionMainViewOwner["UnionExpDetailTTF"]
    -- 联盟公告
    local unionBulletinTTF = UnionMainViewOwner["UnionBulletinTTF"]
    -- 角色糖果
    local RoleGandyTTF = UnionMainViewOwner["RoleGandyTTF"]
    -- 联盟糖果
    local UnionCandyTTF = UnionMainViewOwner["UnionCandyTTF"]

    if unionData:isHaveUnion() then
        unionLevelTTF:setString(unionData.detail["level"])
        unionLevelTTF:setVisible(true)
        unionNameTTF:setString(unionData.detail["name"])
        unionNameTTF:setVisible(true)
        unionMemberCountTTF:setString(table.getTableCount(unionData.detail["members"]).."/"..unionData.detail["memberMax"])
        unionMemberCountTTF:setVisible(true)
        unionExpDetailTTF:setString(unionData.detail["expNow"].."/"..unionData.detail["expUpdate"])
        unionExpDetailTTF:setVisible(true)
        unionBulletinTTF:setString(unionData.detail["notice"]) 
        unionBulletinTTF:setVisible(true)
        if unionData.selfMemberInfo.sweetCount then
            RoleGandyTTF:setString(unionData.selfMemberInfo.sweetCount)
        else
            RoleGandyTTF:setString(0)
        end
        RoleGandyTTF:setVisible(true)
        if unionData.depot.sweetCount then
            UnionCandyTTF:setString(unionData.depot.sweetCount)
        else
            UnionCandyTTF:setString("0")
        end
        UnionCandyTTF:setVisible(true)
    else
        unionLevelTTF:setVisible(false)
        unionNameTTF:setVisible(false)
        unionMemberCountTTF:setVisible(false)
        unionExpDetailTTF:setVisible(false)
        unionBulletinTTF:setVisible(false)
        RoleGandyTTF:setVisible(false)
        UnionCandyTTF:setVisible(false)
        _titleVisible(false)
    end
end

function getUnionMainLayer()
    return _UnionMainLayer
end

local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/UnionMainView.ccbi", proxy, true, "UnionMainViewOwner")
    _UnionMainLayer = tolua.cast(node, "CCLayer")
end

function createUnionMainLayer()
    _init()

    -- 加入公会首页
    function _UnionMainLayer:gotoShowInner()
        _showInner()
    end

    -- 没有加入公会
    function _UnionMainLayer:gotoShowOuter()
        _showOuter()
    end

    -- 修改公告
    function _UnionMainLayer:gotoChangeTitle( )
        -- body
        _showChangeTitle()
    end
    -- 活动方法
    function _UnionMainLayer:gotoShowActivity( tag )
        -- body
        _showActivity(tag)
    end

    -- 管理
    function _UnionMainLayer:gotoShowManage( )
        -- body
        _showManage()
    end

    -- 成员
    function _UnionMainLayer:gotoShowMember( )
        -- body
        _showMember()
    end

    -- 聊天
    function _UnionMainLayer:gotoShowChat( )
        -- body
        _showChat()
    end

    -- 排行
    function _UnionMainLayer:gotoShowRank( )
        -- body
        _showRank()
    end

    -- 战利品
    function _UnionMainLayer:gotoShowAward( )
        -- body
        _showAward()
    end

    -- 本盟动态
    function _UnionMainLayer:gotoShowInformation( )
        -- body
        _showInformation()
    end

    -- 创建公会
    function _UnionMainLayer:gotoCreate( )
        -- body
        _createUnion()
    end

    -- 加入公会
    function _UnionMainLayer:gotoJoin( )
        -- body
        _joinUnion()
    end

    -- 联盟建设
    function _UnionMainLayer:gotoBuild()
        _showBuild()
    end

    -- 联盟战争
    function _UnionMainLayer:gotoBattle()
        _showBattle()
    end

    function _UnionMainLayer:gotoCandyLayer(  )
        _showDisCandy()
    end

    -- 联盟商城
    function _UnionMainLayer:gotoShop()
        _showShop()
    end

    -- 联盟跨服竞速战
    -- 1、人口
    function _UnionMainLayer:gotoRacingBattle()
        _showRacingBattle()
    end
    -- 2、战斗开始
    function _UnionMainLayer:gotoRacingBattleStart()
        _showRacingBattleStart()
    end
    -- 3、参赛服务器
    function _UnionMainLayer:gotoRacingBattleServerList()
        _showRacingBattleServerList()
    end
    -- 4、查看奖励
    function _UnionMainLayer:gotoRacingBattleReward()
        _showRacingBattleReward()
    end
    -- 5、战绩
    function _UnionMainLayer:gotoRacingBattleRecord()
        _showRacingBattleRecord()
    end

    -- 刷新联盟主界面
    function _UnionMainLayer:refreshUnion( )
        -- body
        if unionData:isHaveUnion() then
            _showInner()
        else
            _showOuter()
        end
        _refreshData()
    end
    
    -- 刷新联盟数据
    function _UnionMainLayer:refreshData()
        _refreshData()
    end

    function _UnionMainLayer:titleVisible(visible)
        _titleVisible(visible)
    end

    local function _onEnter()
        getMainLayer():TitleBgVisible(false)
        local function showUnionCallBack( url, rtnData )
            -- body
            unionData:fromDic(rtnData.info)
            if unionData:isHaveUnion() then
                _showInner()
            else
                _showOuter()
            end
            _refreshData()
        end
        
        if runtimeCache.unionRacingBattleBack then
            -- 战斗回来
            _refreshData()
            if runtimeCache.responseData.bossData.curStep == "finish" then
                _showRacingBattle()
                runtimeCache.unionRacingBattleBack = false
            else
                _showRacingBattleStart()
                runtimeCache.unionRacingBattleBack = false
            end
            
        else
            doActionFun("GET_UNION_MAIN_INFO", {}, showUnionCallBack)
        end
    end

    local function _onExit()
        print("onExit")
        _UnionMainLayer = nil
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end


    _UnionMainLayer:registerScriptHandler(_layerEventHandler)

    return _UnionMainLayer
end