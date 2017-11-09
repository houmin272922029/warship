local _layer

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/VeiledSeaFirstView.ccbi",proxy, true,"VeiledSeaFirstViewOwner")
    _layer = tolua.cast(node,"CCLayer")
end

local function _changeVeiledSeaState()
    local state = runtimeCache.veiledSeaState
    _layer:removeAllChildrenWithCleanup(true)
    if state == veiledSeaDataFlag.home then
        showVeiledSea()
    elseif state == veiledSeaDataFlag.selectEnemy then
        _layer:addChild(createVeiledSeaSelectEnemyLayer())
    elseif state == veiledSeaDataFlag.challenge then
        _layer:addChild(createSeiledSeaChallengeLayer())
    elseif state == veiledSeaDataFlag.reward then
        _layer:addChild(createVeiledSeaSelectAwardLayer())
    elseif state == veiledSeaDataFlag.lose then
        _layer:addChild(createVeiledSeaLoseLayer())
    end
end

-- 该方法名字每个文件不要重复
function getVeiledSeaLayer()
	return _layer
end

function createVeiledSeaLayer()
    _init()

    function _layer:changeState()
        _changeVeiledSeaState()
    end

    local function _onEnter()
        runtimeCache.veiledState = veiledSeaData.data.flag
        _changeVeiledSeaState()
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