local _layer

-- ·名字不要重复
NewWorldSecondViewOwner = NewWorldSecondViewOwner or {}
ccb["NewWorldSecondViewOwner"] = NewWorldSecondViewOwner

local function addFirstBuffCallback(url,rtnData)
    blooddata:fromDic(rtnData["info"]["bloodInfo"])
    runtimeCache.newWorldState = blooddata.data.flag
    getNewWorldLayer():showLayer()
end

local function attrItemClick(tag)
    print("attrItemClick", tag)
    local attr
    if tag == 1 then
        attr = "atk"
    elseif tag == 2 then
        attr = "def"
    elseif tag == 3 then
        attr = "hp"
    elseif tag == 4 then
        attr = "mp"
    end
    doActionFun("NEWWORLD_ADD_FIRSTBUFF", {attr}, addFirstBuffCallback)
end
NewWorldSecondViewOwner["attrItemClick"] = attrItemClick

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/NewWorldSecondView.ccbi",proxy, true,"NewWorldSecondViewOwner")
    _layer = tolua.cast(node,"CCLayer")
end

local function _refreshData()
    local secondStarLabel = tolua.cast(NewWorldSecondViewOwner["secondStarLabel"], "CCLabelTTF")
    secondStarLabel:setString(string.format(secondStarLabel:getString(), blooddata.data.firstBuffRecord))
    local attrLabel = tolua.cast(NewWorldSecondViewOwner["attrLabel"], "CCLabelTTF")
    attrLabel:setString(string.format(attrLabel:getString(), blooddata.data.firstBuff))
    local attrLabel_s = tolua.cast(NewWorldSecondViewOwner["attrLabel_s"], "CCLabelTTF")
    attrLabel_s:setString(string.format(attrLabel_s:getString(), blooddata.data.firstBuff))
end

-- 该方法名字每个文件不要重复
function getNewWorldSecondLayer()
	return _layer
end

function createNewWorldSecondLayer()
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