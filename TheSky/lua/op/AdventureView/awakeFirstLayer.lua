local _layer

awakeFirstViewOwner = awakeFirstViewOwner or {}
ccb["awakeFirstViewOwner"] = awakeFirstViewOwner

-- 详情
local function infoClick()
    local awave_help1 = ConfigureStorage.awave_help1
    local temp = {}
    local decc = {}
    local  function getMyDescription()
        for k,v in pairs(awave_help1) do
            table.insert(decc,k)
        end
        for i=1,#decc do
            table.insert(temp,awave_help1[tostring(i)].said)
        end
        return temp
    end
    description = getMyDescription()
    getMainLayer():getParent():addChild(createCommonHelpLayer(description, -132))
end
awakeFirstViewOwner["infoClick"] = infoClick

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/awakeFirstLayer.ccbi",proxy, true,"awakeFirstViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    local timeLabel = tolua.cast(awakeFirstViewOwner["timeLabel"],"CCLabelTTF")
    local titleLabel = tolua.cast(awakeFirstViewOwner["titleLabel"],"CCLabelTTF")
    local insLabel = tolua.cast(awakeFirstViewOwner["insLabel"],"CCLabelTTF")
    local decLabel = tolua.cast(awakeFirstViewOwner["decLabel"],"CCLabelTTF")
    local goMenuIem = tolua.cast(awakeFirstViewOwner["goMenuIem"],"CCMenuItemImage")
    local awakeOpen = ConfigureStorage.levelOpen.awave.level
    local heroOpen = ConfigureStorage.awave_heropen[tostring(1)].open
    decLabel:setString(HLNSLocalizedString("adventure.awake.dec",awakeOpen,heroOpen))
end

-- 该方法名字每个文件不要重复
function getawakeFirstLayer()
    return _layer
end

--点击进入觉醒的回调方法 请求网络数据到awakedata表中
local function onEnterCallBack( url,rtnData )
    if rtnData["code"] == 200 then
        print("觉醒callback-----")
        PrintTable(rtnData["info"])
        awakedata:fromDic(rtnData["info"]["wakeUp"])
        _layer:removeAllChildrenWithCleanup(true);
        _layer:addChild(createAwakeSecondLayer())
    end
end

local function onEnterClick()
    if getAwakeSecondLayer() ~= nil then
        return
    end
    doActionFun("AWAKEN_MAIN",{},onEnterCallBack)
end
awakeFirstViewOwner["onEnterClick"] = onEnterClick

function createawakeFirstViewLayer()    
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
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)
    return _layer
end