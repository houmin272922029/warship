local _layer

-- ·名字不要重复
NewWorldFirstViewOwner = NewWorldFirstViewOwner or {}
ccb["NewWorldFirstViewOwner"] = NewWorldFirstViewOwner

local function beginCallback(url, rtnData)

    blooddata:fromDic(rtnData["info"]["bloodInfo"])
    runtimeCache.newWorldState = blooddata.data.flag
    getNewWorldLayer():showLayer()
end

local function getBloodInfoCallback( url,rtnData )
    blooddata:fromDic(rtnData["info"]["bloodInfo"])
    runtimeCache.newWorldState = blooddata.data.flag
    getNewWorldLayer():showLayer()
end

local function errorCallback(url, rtnCode)
    doActionFun("GET_BLOOD_INFO", {}, getBloodInfoCallback)
end

local function adventureItemClick()
    if blooddata.data.count >= 3 then
        ShowText(HLNSLocalizedString("blood.count.limit"))
        return
    end
    doActionFun("BEGIN_BLOOD",{},beginCallback, errorCallback)
end
NewWorldFirstViewOwner["adventureItemClick"] = adventureItemClick

local function rankItemClick()
    Global:instance():TDGAonEventAndEventData("adventure9")
    local layer = createNewWorldRankLayer(-134)
    getMainLayer():getParent():addChild(layer, 100)
end
NewWorldFirstViewOwner["rankItemClick"] = rankItemClick

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/NewWorldFirstView.ccbi",proxy, true,"NewWorldFirstViewOwner")
    _layer = tolua.cast(node,"CCLayer")
end

local function _refreshData()
    local alreadyLabel = tolua.cast(NewWorldFirstViewOwner["alreadyLabel"], "CCLabelTTF")
    alreadyLabel:setString(tostring(blooddata.data.count))
    local leftLabel = tolua.cast(NewWorldFirstViewOwner["leftLabel"], "CCLabelTTF")
    leftLabel:setString(tostring(3 - blooddata.data.count))
    local islandLabel = tolua.cast(NewWorldFirstViewOwner["islandLabel"], "CCLabelTTF")
    islandLabel:setString(tostring(blooddata.data.best.bestOutpostNum))
    local starLabel = tolua.cast(NewWorldFirstViewOwner["starLabel"], "CCLabelTTF")
    starLabel:setString(tostring(blooddata.data.best.bestRecord))
    local rankLabel = tolua.cast(NewWorldFirstViewOwner["rankLabel"], "CCLabelTTF")
    if not blooddata.data.todayRank or blooddata.data.todayRank == "" then
        rankLabel:setString(HLNSLocalizedString("20开外"))
    else
        rankLabel:setString(tostring(blooddata.data.todayRank))
    end
    -- if blooddata.data.count >= 3 then
    --     local adventureItem = tolua.cast(NewWorldFirstViewOwner["adventureItem"], "CCMenuItem")
    --     adventureItem:setEnabled(false)
    -- end
end

-- 该方法名字每个文件不要重复
function getNewWorldFirstLayer()
	return _layer
end

function createNewWorldFirstLayer()
    _init()
    _refreshData()

    local function _onEnter()
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


    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end