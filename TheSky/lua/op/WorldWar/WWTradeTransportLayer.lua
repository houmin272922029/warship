local _layer
local _tableView
local _data
local _priority = -132

-- 名字不要重复
WWTradeTransportOwner = WWTradeTransportOwner or {}
ccb["WWTradeTransportOwner"] = WWTradeTransportOwner

local function refresh()
    --海运剩余次数 haiyunCount  
    local haiyunCount = tolua.cast(WWTradeTransportOwner["haiyunCount"], "CCLabelTTF")
    haiyunCount:setString(_data.escort.remain .. '/' .. _data.escort.total)
    --劫镖剩余次数 RobCount
    local RobCount = tolua.cast(WWTradeTransportOwner["RobCount"], "CCLabelTTF")
    RobCount:setString(_data.robbery.remain .. '/' .. _data.robbery.total)
end

-- goto 我要海运 EscortItemClicked
local function EscortItemClicked()
    --海运界面
    getMainLayer():gotoEscortItem()
  
end
WWTradeTransportOwner["EscortItemClicked"] = EscortItemClicked

-- goto 我要劫镖 RobItemClicked
local function RobItemClicked()
    -- 我要劫镖 主界面
    getMainLayer():gotoRobItem()
    
end
WWTradeTransportOwner["RobItemClicked"] = RobItemClicked


--详情
local function descBtnTaped()
   --弹出帮助界面
    local desc = ConfigureStorage.delivery_help
    print("xiangqing")
    PrintTable(desc)
    local  function getMyDescription()
        -- body
        local temp = {}
            -- for k,v in pairs(desc) do
            --     table.insert(temp, v.desp)
            -- end

            for i=1,getMyTableCount(desc) do
                table.insert(temp, desc[tostring(i)].desp)
            end
            return temp
        end
    description = getMyDescription()
    print("lsf111 description")
    PrintTable(description )
    local contentLayer = MainSceneOwner["contentLayer"]
    getMainLayer():getParent():addChild(createCommonHelpLayer(description, -132))
end
WWTradeTransportOwner["descBtnTaped"] = descBtnTaped


-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    local proxy = CCBProxy:create()
    local node  = CCBReaderLoad("ccbResources/WWTradeTransportView.ccbi", proxy, true, "WWTradeTransportOwner")
    _layer = tolua.cast(node,"CCLayer")
    refresh()
end

-- 该方法名字每个文件不要重复
function getWWTradeTransportLayer()
	return _layer
end

function createWWTradeTransportLayer(data, priority)
    _priority = (priority ~= nil) and priority or -132
    _data = data
    _init()
    local function _onEnter()
        addObserver(NOTI_WW_REFRESH, refresh)
    end

    local function _onExit()
        removeObserver(NOTI_WW_REFRESH, refresh)
        _tableView = nil
        _data = nil
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