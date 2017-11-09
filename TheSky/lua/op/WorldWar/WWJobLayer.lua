local _layer
local _groupIndex = 1
local _endTime

local FONT_PIC = {
    {
        "haizeiwang_text.png",
        "sihuang_text.png",
        "sihuang_text.png",
        "chaoxinxing_text.png",
        "chaoxinxing_text.png",
        "chaoxinxing_text.png",
        "chaoxinxing_text.png",
    },
    {
        "yuanshuai_text.png",
        "dajiang_text.png",
        "dajiang_text.png",
        "zhongjiang_text.png",
        "zhongjiang_text.png",
        "zhongjiang_text.png",
        "zhongjiang_text.png",
    },
    {
        "siling_text.png",
        "canmouzhang_text.png",
        "canmouzhang_text.png",
        "xianfeng_text.png",
        "xianfeng_text.png",
        "xianfeng_text.png",
        "xianfeng_text.png",
    },
}

-- 名字不要重复
WWJobOwner = WWJobOwner or {}
ccb["WWJobOwner"] = WWJobOwner

local function refreshTime()
     if _endTime then
        local tips2 = tolua.cast(WWJobOwner["tips2"], "CCLabelTTF")
        tips2:setString(DateUtil:second2hms(math.max(0, _endTime - userdata.loginTime)))
    end
end

local function refresh()
    local jobLayer = tolua.cast(WWJobOwner["jobLayer"], "CCLayer")
    jobLayer:setVisible(true)

    for i=1,3 do
        local badge = tolua.cast(WWJobOwner["badge"..i], "CCMenuItem")
        if i == _groupIndex then
            badge:setColor(ccc3(255, 255, 255))
            badge:setScale(0.4)
        else
            badge:setColor(ccc3(150, 150, 150))
            badge:setScale(0.3)
        end
    end

    local tips1 = tolua.cast(WWJobOwner["tips1"], "CCLabelTTF")
    tips1:setString(HLNSLocalizedString("ww.job.tips", HLNSLocalizedString("ww.job.lord.".._groupIndex)))
    local flag = false
    for i=1,7 do
        local job = tolua.cast(WWJobOwner["job"..i], "CCSprite")
        job:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(FONT_PIC[_groupIndex][i]))
        local name = tolua.cast(WWJobOwner["name"..i], "CCLabelTTF")
        local vip = tolua.cast(WWJobOwner["vip"..i], "CCLabelTTF")
        if worldwardata.leaderInfo and worldwardata.leaderInfo[string.format("camp_%02d", _groupIndex)] 
            and worldwardata.leaderInfo[string.format("camp_%02d", _groupIndex)][tostring(i - 1)] then
            local dic = worldwardata.leaderInfo[string.format("camp_%02d", _groupIndex)][tostring(i - 1)]
            if dic then
                name:setVisible(true)
                vip:setVisible(true)
                name:setString(dic.name)
                vip:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("VIP_%d.png", dic.vip)))
                if not flag then
                    flag = i <= 3 and dic.id == userdata.userId
                end
            else
                name:setVisible(false)
                vip:setVisible(false)
            end
        else
            name:setVisible(false)
            vip:setVisible(false)
        end
    end
    local changeText = tolua.cast(WWJobOwner["changeText"], "CCSprite")
    local changeItem = tolua.cast(WWJobOwner["changeItem"], "CCMenuItem")
    changeItem:setVisible(flag)
    changeText:setVisible(flag)

    refreshTime()
end

local function changeItemClick()
    getMainLayer():getParent():addChild(createWWJobChangeLayer(worldwardata.leaderInfo[string.format("camp_%02d", _groupIndex)], -133))
end
WWJobOwner["changeItemClick"] = changeItemClick

local function helpItemClick()
    local array = {}
    for i,v in ipairs(ConfigureStorage.WWHelp3) do
        table.insert(array, v.desp)
    end
    getMainLayer():getParent():addChild(createCommonHelpLayer(array, -133))
end
WWJobOwner["helpItemClick"] = helpItemClick

local function badgeItemClick(tag)
    if tag == _groupIndex then
        return
    end 
    _groupIndex = tag
    refresh()
end
WWJobOwner["badgeItemClick"] = badgeItemClick

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/WWJobView.ccbi",proxy, true,"WWJobOwner")
    _layer = tolua.cast(node,"CCLayer")
end

local function refreshJob()
    local function callback(url, rtnData)
        worldwardata:fromDic(rtnData.info)
        _endTime = rtnData.info.endTime
        _groupIndex = tonumber(string.split(worldwardata.playerData.countryId, "_")[2])
        postNotification(NOTI_WW_REFRESH, nil)
    end
    doActionFun("WW_GET_LEADERS", {}, callback)
end


-- 该方法名字每个文件不要重复
function getWWJobLayer()
	return _layer
end

function createWWJobLayer()
    _init()

    local function _onEnter()
        addObserver(NOTI_TICK, refreshTime)
        addObserver(NOTI_WW_REFRESH, refresh)
        refreshJob()
    end

    local function _onExit()
        removeObserver(NOTI_TICK, refreshTime)
        removeObserver(NOTI_WW_REFRESH, refresh)
        _layer = nil
        _groupIndex = 1
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