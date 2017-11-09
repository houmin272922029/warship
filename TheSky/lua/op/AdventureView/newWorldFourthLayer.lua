local _layer

-- ·名字不要重复
NewWorldFourthViewOwner = NewWorldFourthViewOwner or {}
ccb["NewWorldFourthViewOwner"] = NewWorldFourthViewOwner

local function addAwardCallback( url,rtnData )
    blooddata:fromDic(rtnData["info"]["bloodInfo"])
    runtimeCache.newWorldState = blooddata.data.flag
    getNewWorldLayer():showLayer()
end

local function getRewardItemClick()
    print("getRewardItemClick")
    doActionFun("NEWWORLD_ADD_AWARD", {}, addAwardCallback)
end
NewWorldFourthViewOwner["getRewardItemClick"] = getRewardItemClick

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/NewWorldFourthView.ccbi",proxy, true,"NewWorldFourthViewOwner")
    _layer = tolua.cast(node,"CCLayer")
end

local function _refreshData()
    local stageLabel = tolua.cast(NewWorldFourthViewOwner["stageLabel"], "CCLabelTTF") 
    stageLabel:setString(string.format(stageLabel:getString(), blooddata.data.outpostNum - 4, blooddata.data.outpostNum))
    local starLabel = tolua.cast(NewWorldFourthViewOwner["starLabel"], "CCLabelTTF")
    starLabel:setString(tostring(blooddata.data.thisRecord))
    local noRewardTitle = tolua.cast(NewWorldFourthViewOwner["noRewardTitle"], "CCLabelTTF")
    noRewardTitle:setString(string.format(noRewardTitle:getString(), blooddata.data.historyRecord))
    local perstar = tolua.cast(NewWorldFourthViewOwner["perstar"], "CCLabelTTF")
    perstar:setString(tostring(blooddata.data.awardConfig.perstar))
    if blooddata.data.thisRecord > blooddata.data.historyRecord then
        local rewardTitle1 = tolua.cast(NewWorldFourthViewOwner["rewardTitle1"], "CCLabelTTF")
        rewardTitle1:setVisible(true)
        local rewardTitle2 = tolua.cast(NewWorldFourthViewOwner["rewardTitle2"], "CCLabelTTF")
        rewardTitle2:setVisible(true)
        local award = userdata:getBloodAward()
        for i,v in ipairs(award) do
            local rewardIcon = tolua.cast(NewWorldFourthViewOwner["rewardIcon"..i], "CCSprite")
            local rewardCountLabel = tolua.cast(NewWorldFourthViewOwner["rewardCountLabel"..i], "CCSprite")
            local reward = tolua.cast(NewWorldFourthViewOwner["reward"..i], "CCSprite")
            local chipIcon = tolua.cast(NewWorldFourthViewOwner["chipIcon"..i],"CCSprite")
            local shadowContent = tolua.cast(NewWorldFourthViewOwner["shadowContent"..i], "CCLayer")
            -- local conf = wareHouseData:getItemResource(v.key)
            local conf = userdata:getExchangeResource(v.key)
            if havePrefix(v.key, "shadow") then
                CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/shadow.plist")
                rewardIcon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("s_frame.png"))
                if conf.icon then
                    playCustomFrameAnimation( string.format("yingzi_%s_",conf.icon),shadowContent,ccp(shadowContent:getContentSize().width / 2,shadowContent:getContentSize().height / 2),1,4,shadowData:getColorByColorRank( conf.rank ) )
                end
            elseif haveSuffix(v.key, "_shard") then
                rewardIcon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", conf.rank)))
                if conf.icon then
                    reward:setTexture(CCTextureCache:sharedTextureCache():addImage(string.format("ccbResources/icons/%s.png",conf.icon)))
                    reward:setVisible(true)
                end
                rewardIcon:setVisible(true)
                chipIcon:setVisible(true)
            else
                rewardIcon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", conf.rank)))
                if conf.icon then
                    reward:setTexture(CCTextureCache:sharedTextureCache():addImage(conf.icon))
                    reward:setVisible(true)
                end
                rewardIcon:setVisible(true)
            end
            -- rewardIcon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", conf.rank)))
            -- if conf.icon then
            --     reward:setTexture(CCTextureCache:sharedTextureCache():addImage(conf.icon))
            --     reward:setVisible(true)
            -- end
            -- rewardIcon:setVisible(true)
            rewardCountLabel:setVisible(true)
            rewardCountLabel:setString(tostring(v.value))
        end
    else
        noRewardTitle:setVisible(true)
    end
end


-- 该方法名字每个文件不要重复
function getNewWorldFourthLayer()
	return _layer
end

function createNewWorldFourthLayer()
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