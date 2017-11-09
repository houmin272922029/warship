local _layer

-- ·名字不要重复
VeiledSeaFirstViewOwner = VeiledSeaFirstViewOwner or {}
ccb["VeiledSeaFirstViewOwner"] = VeiledSeaFirstViewOwner

local function beginCallback(url, rtnData)
    if rtnData.code == 200 then 
        veiledSeaData:seaMistDataFromDic(rtnData["info"]["seaMist"])
        runtimeCache.veiledSeaState = veiledSeaData.data.flag
        -- getVeiledSeaLayer():changeState()
        showVeiledSea()
    end
end

local function adventureItemClick()
    runtimeCache.veiledSeaState = veiledSeaData.data.flag
    if runtimeCache.veiledSeaState == veiledSeaDataFlag.home then
        local todayFreeCount = veiledSeaData:dailyFreeCount()
        if todayFreeCount > 0 then
            doActionFun("SEALMIST_BEGIN",{},beginCallback)
        else
            local vipLavel = userdata:getVipLevel()
            local extraNum = vipdata:getVipSeaVeiledExtraLevel(vipLavel)
            local todayFreeCount = veiledSeaData:dailyFreeCount()
            if extraNum < veiledSeaData.data.playCount - todayFreeCount then
                ShowText(HLNSLocalizedString("veiledSea.noHaveChance"))
            else
                getMainLayer():getParent():addChild(createWWUseItemLayer(3, -133))
            end       
        end
    else
        runtimeCache.veiledSeaState = veiledSeaData.data.flag
        showVeiledSea()
    end   
end
VeiledSeaFirstViewOwner["adventureItemClick"] = adventureItemClick

local function rankItemClick()
    local layer = createVeiledSeaRankLayer(-134)
    getMainLayer():getParent():addChild(layer, 100)
end
VeiledSeaFirstViewOwner["rankItemClick"] = rankItemClick

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/VeiledSeaFirstView.ccbi",proxy, true,"VeiledSeaFirstViewOwner")
    _layer = tolua.cast(node,"CCLayer")
end

local function _refreshData()
    local freeCount = tolua.cast(VeiledSeaFirstViewOwner["freeCount"], "CCLabelTTF")
    local freeCountBg = tolua.cast(VeiledSeaFirstViewOwner["freeCountBg"], "CCLabelTTF")
    local eyeCount = tolua.cast(VeiledSeaFirstViewOwner["eyeCount"], "CCLabelTTF")
    local bestResultPass = tolua.cast(VeiledSeaFirstViewOwner["bestResultPass"], "CCLabelTTF")
    local yesterdayBestPass = tolua.cast(VeiledSeaFirstViewOwner["yesterdayBestPass"], "CCLabelTTF")
    local bestPass = tolua.cast(VeiledSeaFirstViewOwner["bestPass"], "CCLabelTTF")
    local yesterdayBestName = tolua.cast(VeiledSeaFirstViewOwner["yesterdayBestName"], "CCLabelTTF")
    local bsetName = tolua.cast(VeiledSeaFirstViewOwner["bsetName"], "CCLabelTTF")

    local todayFreeCount = veiledSeaData:dailyFreeCount()
    freeCount:setString(HLNSLocalizedString("todayFreeSeaCount",todayFreeCount))
    freeCountBg:setString(HLNSLocalizedString("todayFreeSeaCount",todayFreeCount))
    local syesNum = wareHouseData:getItemCountById(ConfigureStorage.SeaMiEyes[1].itemId)
    eyeCount:setString(tostring(syesNum))
    
    if veiledSeaData.myBest and veiledSeaData.myBest ~= "" and veiledSeaData.myBest.stage 
        and veiledSeaData.myBest.stage ~= "" then
        if tonumber(veiledSeaData.myBest.stage) > 0 then
            bestResultPass:setString(veiledSeaData.myBest.stage)
        else
            bestResultPass:setString("0")
        end
    else
        bestResultPass:setString("0")
    end
    if veiledSeaData.yesterdayBest and veiledSeaData.yesterdayBest ~= "" and veiledSeaData.yesterdayBest.stage 
        and veiledSeaData.yesterdayBest.stage ~= "" then
        if tonumber(veiledSeaData.yesterdayBest.stage) > 0 then
            yesterdayBestPass:setString(veiledSeaData.yesterdayBest.stage)
            yesterdayBestName:setString(veiledSeaData.yesterdayBest.name)
        else
            yesterdayBestPass:setString("0")
            yesterdayBestName:setString("")
        end
    else
        yesterdayBestPass:setString("0")
        yesterdayBestName:setString("")
    end
    if veiledSeaData.allBest and veiledSeaData.allBest ~= "" and veiledSeaData.allBest.stage 
        and veiledSeaData.allBest.stage ~= "" then
        if tonumber(veiledSeaData.allBest.stage) > 0 then
            bestPass:setString(veiledSeaData.allBest.stage)
            bsetName:setString(veiledSeaData.allBest.name)
        else
            bestPass:setString("0")
            bsetName:setString("")
        end
    else
        bestPass:setString("0")
        bsetName:setString("")
    end
end
local function beginCallback(url, rtnData)
    if rtnData["code"] == 200 then
        if rtnData["info"] then
            veiledSeaData:fromDic(rtnData["info"])
            _refreshData()
        end
    end
end

-- 该方法名字每个文件不要重复
function getVeiledSeaFirstLayer()
	return _layer
end

function createVeiledSeaFirstLayer()
    _init()

    function _layer:refreshLayer()
        doActionFun("SEALMIST_GETDATA",{}, beginCallback)
    end

    local function _onEnter()
        local veiledSea_bg = tolua.cast(VeiledSeaFirstViewOwner["veiledSea_bg"],"CCLayer")
        -- HLAddParticleScale( "images/fog_crosswise_first.plist", veiledSea_bg, ccp(veiledSea_bg:getContentSize().width / 2, veiledSea_bg:getContentSize().height), 1, 1000, 100, 1 / retina, 1 / retina, 1)
        -- HLAddParticleScale( "images/fog_crosswise_first.plist", veiledSea_bg, ccp(veiledSea_bg:getContentSize().width / 2, 0), 1, 1000, 100, 1 / retina, 1 / retina, 1)
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