local _layer

-- ·名字不要重复
NewWorldFifthViewOwner = NewWorldFifthViewOwner or {}
ccb["NewWorldFifthViewOwner"] = NewWorldFifthViewOwner

local function rankItemClick()
    Global:instance():TDGAonEventAndEventData("adventure9")
    local layer = createNewWorldRankLayer(-134)
    getMainLayer():getParent():addChild(layer, 100)
end
NewWorldFifthViewOwner["rankItemClick"] = rankItemClick

local function addBuffCallback( url, rtnData )

    Global:instance():TDGAonEventAndEventData("adventure2")
    blooddata:fromDic(rtnData["info"]["bloodInfo"])
    runtimeCache.newWorldState = blooddata.data.flag
    getNewWorldLayer():showLayer()
end

local function attrItemClick(tag)
    Global:instance():TDGAonEventAndEventData("adventure"..tag+6)
    doActionFun("NEWWORLD_ADD_BUFF", {tag}, addBuffCallback)
end
NewWorldFifthViewOwner["attrItemClick"] = attrItemClick

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/NewWorldFifthView.ccbi",proxy, true,"NewWorldFifthViewOwner")
    _layer = tolua.cast(node,"CCLayer")
end

local function _refreshData()
    for k,v in pairs(blooddata.data.dayBuff) do
        local label = tolua.cast(NewWorldFifthViewOwner[k.."Label"], "CCLabelTTF")
        label:setString(string.format("+%d%%", v))
    end
    local passIslandLabel = tolua.cast(NewWorldFifthViewOwner["passIslandLabel"], "CCLabelTTF")
    passIslandLabel:setString(tostring(blooddata.data.best.bestOutpostNum))
    local totalStarLabel = tolua.cast(NewWorldFifthViewOwner["totalStarLabel"], "CCLabelTTF")
    totalStarLabel:setString(tostring(blooddata.data.best.bestRecord))
    local passLabel = tolua.cast(NewWorldFifthViewOwner["passLabel"], "CCLabelTTF")
    passLabel:setString(string.format(passLabel:getString(), runtimeCache.newWorldOutpostNum))
    local getStarLabel = tolua.cast(NewWorldFifthViewOwner["getStarLabel"], "CCLabelTTF")
    getStarLabel:setString(tostring(blooddata.data.recordAll))
    local leftLabel = tolua.cast(NewWorldFifthViewOwner["leftLabel"], "CCLabelTTF")
    leftLabel:setString(tostring(blooddata.data.recordAll - blooddata.data.recordUsed))
    for i=0,table.getTableCount(blooddata.data.buff) - 1 do
        for k,v in pairs(blooddata.data.buff[tostring(i)]) do
            local attrKeyLabel = tolua.cast(NewWorldFifthViewOwner["attrKeyLabel"..(i + 1)], "CCLabelTTF") 
            local attrBtn = tolua.cast(NewWorldFifthViewOwner["attrBtn"..(i + 1)], "CCMenuItemImage")
            if blooddata.data.recordAll - blooddata.data.recordUsed < v then
                attrBtn:setEnabled(false)
                attrBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("%s_btn_2.png", k)))
            else
                attrBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("%s_btn_0.png", k)))
            end
            attrKeyLabel:setString(HLNSLocalizedString(k))
            attrBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("%s_btn_1.png", k)))
        end
    end

end


-- 该方法名字每个文件不要重复
function getNewWorldFifthLayer()
	return _layer
end

function createNewWorldFifthLayer()
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