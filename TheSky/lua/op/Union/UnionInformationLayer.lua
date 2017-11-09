local _layer
local _priority = -132
local _infoNumber = 15

UnionInfomationViewOwner = UnionInfomationViewOwner or {}
ccb["UnionInfomationViewOwner"] = UnionInfomationViewOwner



    -- PrintTable(unionData.informations)
    -- local data = unionData.informations --获取动态
    -- local time = data["0"]["time"]      --取得时间
    -- local info = data["0"]["message"]   --取得动态内容
    -- print(DateUtil:formatTime(time))    --将获得的时间转换格式


local function closeItemClick()
    if _layer then
        _layer:removeFromParentAndCleanup(true)
    end
end
UnionInfomationViewOwner["closeItemClick"] = closeItemClick


-- 刷新UI数据
local function _refreshUI()

    local data = unionData.informations

    -- invisible news label
    for index = 1,_infoNumber do
        local infoLabel = tolua.cast(UnionInfomationViewOwner[string.format("message%d",index)],"CCLabelTTF")
        local timeLabel = tolua.cast(UnionInfomationViewOwner[string.format("timeLabel%d",index)],"CCLabelTTF")
        infoLabel:setVisible(false)
        timeLabel:setVisible(false)

    end

    --show union news
    for index = 1,_infoNumber do

        local i = string.format("%d",index-1)
        local tempData = data[i]
        if tempData then 
            local message = tempData["message"]
            local time = tempData["time"]
            local infoLabel = tolua.cast(UnionInfomationViewOwner[string.format("message%d",index)],"CCLabelTTF")
            local timeLabel = tolua.cast(UnionInfomationViewOwner[string.format("timeLabel%d",index)],"CCLabelTTF")
            infoLabel:setString(message)

            local t = userdata.loginTime - time
            print(DateUtil:secondGetdhms(t))
            local day, hour, min, sec = DateUtil:secondGetdhms(t)
           
            if day > 0 then 
                if day <7 then  --小于7天
                    timeLabel:setString(HLNSLocalizedString("union.information.daysbefore",day))
                else            --大于7天,直接显示7天前
                    timeLabel:setString(HLNSLocalizedString("union.information.daysbefore",7))
                end
            else
                if hour>0 then 
                    timeLabel:setString(HLNSLocalizedString("union.information.hoursbefore",hour))
                else
                    timeLabel:setString(HLNSLocalizedString("union.information.justbefore"))
                end
            end
            infoLabel:setVisible(true)
            timeLabel:setVisible(true)
        end
    end

end


local function _init()
    -- get layer from ccb file
    local  proxy = CCBProxy:create()
    --todo
    local  node  = CCBReaderLoad("ccbResources/UnionInformationView.ccbi", proxy, true,"UnionInfomationViewOwner")
    _layer = tolua.cast(node,"CCLayer")

    _refreshUI()
end

-- if the touch point is out of the content of this layer,we should remove layer from it's parent
local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(UnionInfomationViewOwner["infoBg"], "CCSprite")
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


--set touch priority for menu items
local function setMenuPriority()
    local menu = tolua.cast(UnionInfomationViewOwner["menu"], "CCMenu")
    menu:setHandlerPriority(_priority - 1)
end




--创建联盟动态层，priority为该层的触摸事件优先级
function createUnionInformationLayer(priority)

    _priority = (priority ~= nil) and priority or -132
    _init()

    local function _onEnter()
        print("onEnter")
        --设置图层内菜单按钮的触摸优先级
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
    end

    local function _onExit()
        print("onExit")
        _layer = nil
        _priority = -132
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