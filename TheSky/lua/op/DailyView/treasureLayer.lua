local _layer

TreasureOwner = TreasureOwner or {}
ccb["TreasureOwner"] = TreasureOwner

-- 刷新UI
local function _refreshUI()
    local countLabel = tolua.cast(TreasureOwner["countLabel"], "CCLabelTTF")
    countLabel:setString(dailyData.daily[Daily_Treasure].times)
end

local function getInfoCallback(url, rtnData)
    dailyData:updateTreasureData(rtnData["info"])
    postNotification(NOTI_DAILY_STATUS, nil)
    getMainLayer():gotoTreasureMap()
end

-- 点击中午开吃按钮
local function enterClick()
    Global:instance():TDGAonEventAndEventData("lucky")
    doActionFun("GET_TREASURE_INFO", {}, getInfoCallback)
end
TreasureOwner["enterClick"] = enterClick

local function infoClick()
    getMainLayer():getParent():addChild(createTreasureInfoLayer()) 
end
TreasureOwner["infoClick"] = infoClick

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/TreasureFirstView.ccbi",proxy, true,"TreasureOwner")
    _layer = tolua.cast(node,"CCLayer")

    _refreshUI()
end

-- 该方法名字每个文件不要重复
function getTreasureLayer()
	return _layer
end

function createTreasureLayer()
    _init()

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