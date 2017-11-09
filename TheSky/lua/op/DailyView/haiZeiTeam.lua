local _layer
local _data = nil
local canGetFlag
local alreadyGet

HaiZeiTeamViewOwner = HaiZeiTeamViewOwner or {}
ccb["HaiZeiTeamViewOwner"] = HaiZeiTeamViewOwner

-- 刷新UI
local function _refreshUI()
    _data = dailyData:getFantasyTeamData()
    if not _data then
        return
    end
    canGetFlag = false
    alreadyGet = 0
    local heroCount = getMyTableCount(herodata:getHeroUIdArrByRank( 4 ))
    local bottmLabel1 = tolua.cast(HaiZeiTeamViewOwner["bottmLabel1"],"CCLabelTTF")
    local bottmLabel2 = tolua.cast(HaiZeiTeamViewOwner["bottmLabel2"],"CCLabelTTF")
    local bottmLabel3 = tolua.cast(HaiZeiTeamViewOwner["bottmLabel3"],"CCLabelTTF")
    local bottmLabel4 = tolua.cast(HaiZeiTeamViewOwner["bottmLabel4"],"CCLabelTTF")
    local bottmLabel5 = tolua.cast(HaiZeiTeamViewOwner["bottmLabel5"],"CCLabelTTF")
    local templabel = tolua.cast(HaiZeiTeamViewOwner["templabel"],"CCLabelTTF")
    bottmLabel1:enableStroke(ccc3(0,0,0), 1)
    bottmLabel2:enableStroke(ccc3(0,0,0), 1)
    bottmLabel3:enableStroke(ccc3(0,0,0), 1)
    bottmLabel4:enableStroke(ccc3(0,0,0), 1)
    bottmLabel5:enableStroke(ccc3(0,0,0), 1)
    bottmLabel1:setVisible(false)
    bottmLabel2:setVisible(false)
    bottmLabel3:setVisible(false)
    bottmLabel4:setVisible(false)
    bottmLabel5:setVisible(false)
    for i=4,1,-1 do
        local colorLayer = tolua.cast(HaiZeiTeamViewOwner["colorLayer"..i],"CCLayer")
        local btn = tolua.cast(HaiZeiTeamViewOwner["btn"..i],"CCMenuItemImage")
        local selectSpr = tolua.cast(HaiZeiTeamViewOwner["select"..i],"CCSprite")
        local frame = tolua.cast(HaiZeiTeamViewOwner["frame_"..i],"CCSprite")
        local nameLabel = tolua.cast(HaiZeiTeamViewOwner["nameLabel"..i],"CCLabelTTF")
        local chipIcon = tolua.cast(HaiZeiTeamViewOwner["chipIcon"..i],"CCSprite")
        local contentLayer = tolua.cast(HaiZeiTeamViewOwner["contentLayer"..i],"CCLayer")
        local get = tolua.cast(HaiZeiTeamViewOwner["get"..i],"CCSprite")
        local itemID
        local count
        for k,v in pairs(ConfigureStorage.Dreamgift[i].award) do
            itemID = k
            count = v
        end
        local res = userdata:getExchangeResource(itemID)
        if havePrefix(itemID,"shadow") then
            btn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("s_frame.png"))
            btn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("s_frame.png"))
            contentLayer:setPosition(ccp(contentLayer:getPositionX() - 2 * retina, contentLayer:getPositionY() + 2 * retina))
        else
            btn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", res.rank)))
            btn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", res.rank)))
        end

        if res.icon then
            
            -- if texture then
                if haveSuffix(itemID, "_shard") then
                    local texture = CCTextureCache:sharedTextureCache():addImage(string.format("ccbResources/icons/%s.png",res.icon))
                    chipIcon:setVisible(true)
                    frame:setVisible(true)
                    frame:setTexture(texture)
                elseif havePrefix(itemID,"shadow") then
                    frame:setVisible(false)
                    if res.icon then
                        playCustomFrameAnimation( string.format("yingzi_%s_",res.icon),contentLayer,ccp(contentLayer:getContentSize().width / 2,contentLayer:getContentSize().height / 2),1,4,shadowData:getColorByColorRank( res.rank ) )
                    end
                else
                    local texture = CCTextureCache:sharedTextureCache():addImage(res.icon)
                    frame:setVisible(true)
                    frame:setTexture(texture)
                end
                
            -- end
        end

        nameLabel:setString(res.name..count)

        -- 越南版
        if isPlatform(ANDROID_VIETNAM_VI)
            or isPlatform(ANDROID_VIETNAM_EN)
            or isPlatform(ANDROID_VIETNAM_EN_ALL)
            or isPlatform(ANDROID_VIETNAM_MOB_THAI)
            or isPlatform(IOS_VIETNAM_VI)
            or isPlatform(IOS_VIETNAM_EN) 
            or isPlatform(IOS_VIETNAM_ENSAGA) 
            or isPlatform(IOS_MOB_THAI)
            or isPlatform(IOS_MOBNAPPLE_EN)
            or isPlatform(IOS_MOBGAME_SPAIN)
            or isPlatform(ANDROID_MOBGAME_SPAIN)
            or isPlatform(WP_VIETNAM_EN) then
            nameLabel:setString("x "..count)
        end

        if ConfigureStorage.Dreamgift[i].amount <= heroCount then
            colorLayer:setVisible(false)
            -- 判断是否领过
            if _data.fantasyTeamState[tostring(i)] then
                if _data.fantasyTeamState[tostring(i)] == 2 then
                    -- 已领过
                    if havePrefix(itemID,"shadow") then
                        local shadowSprite = tolua.cast(contentLayer:getChildByTag(9888),"CCSprite")
                        if shadowSprite then
                            shadowSprite:setColor(ccc3(102,102,102))
                        end
                    else
                        colorLayer:setVisible(true)
                    end
                    get:setVisible(true)
                    alreadyGet = alreadyGet + 1
                else
                    
                end
            else
                -- 可以领
                get:setVisible(false)
                bottmLabel1:setVisible(false)
                bottmLabel2:setVisible(false)
                bottmLabel3:setVisible(false)
                bottmLabel4:setVisible(false)
                bottmLabel5:setVisible(true)
                canGetFlag = true
                bottmLabel5:setString(HLNSLocalizedString("你有奖励可以领"))
            end
        else
            bottmLabel1:setVisible(true)
            bottmLabel2:setVisible(true)
            bottmLabel3:setVisible(true)
            bottmLabel4:setVisible(true)
            bottmLabel5:setVisible(false)
            bottmLabel1:setString(tostring(ConfigureStorage.Dreamgift[i].amount))
            templabel:setString(ConfigureStorage.Dreamgift[i].amount - heroCount)
            bottmLabel2:setString(string.format(HLNSLocalizedString("还差%s名"),(ConfigureStorage.Dreamgift[i].amount - heroCount)))

            if isPlatform(ANDROID_VIETNAM_VI) 
                or isPlatform(ANDROID_VIETNAM_EN)
                or isPlatform(ANDROID_VIETNAM_EN_ALL)
                or isPlatform(ANDROID_VIETNAM_MOB_THAI)
                or isPlatform(IOS_VIETNAM_VI)
                or isPlatform(IOS_VIETNAM_EN) 
                or isPlatform(IOS_VIETNAM_ENSAGA) 
                or isPlatform(IOS_MOB_THAI)
                or isPlatform(IOS_MOBNAPPLE_EN)
                or isPlatform(IOS_MOBGAME_SPAIN)
                or isPlatform(ANDROID_MOBGAME_SPAIN)
                or isPlatform(WP_VIETNAM_EN) then

                bottmLabel1:setVisible(false)
                bottmLabel2:setVisible(false)
                bottmLabel3:setVisible(false)
                bottmLabel4:setVisible(false)
                bottmLabel5:setVisible(true)
                bottmLabel5:setString(string.format(HLNSLocalizedString("您需要拥有%d名S级伙伴即可领取奖励,还差%s名"), ConfigureStorage.Dreamgift[i].amount, ConfigureStorage.Dreamgift[i].amount - heroCount))
            end

            if havePrefix(itemID,"shadow") then
                local shadowSprite = tolua.cast(contentLayer:getChildByTag(9888),"CCSprite")
                if shadowSprite then
                    shadowSprite:setColor(ccc3(102,102,102))
                end
            else
                colorLayer:setVisible(true)
            end
            get:setVisible(false)
        end
    end
end

local function getFantasyRewardCallBack( url,rtnData )
    if rtnData.code == 200 then
        dailyData:updateFantasyTeamData(rtnData["info"]["state"])
        _refreshUI()
        postNotification(NOTI_DAILY_STATUS, nil)
    end
end 

local function onItemTaped( tag,sender )
    local itemID
    local count
    for k,v in pairs(ConfigureStorage.Dreamgift[tag].award) do
        itemID = k
        count = v
    end
    if havePrefix( itemID,"item_" ) then
        getMainLayer():getParent():addChild(createItemDetailInfoLayer(itemID, -135, 1, 1), 100)
    elseif havePrefix( itemID,"book_" ) then
        getMainLayer():getParent():addChild(createHandBookSkillDetailLayer(itemID,-135), 100) 
    end
end

HaiZeiTeamViewOwner["onItemTaped"] = onItemTaped

-- 点击晚上开吃按钮
local function onGetTaped()
    Global:instance():TDGAonEventAndEventData("dream")
    if canGetFlag then
        doActionFun("GET_FANTASY_TEAM_REWARD", {}, getFantasyRewardCallBack)
    else
        if alreadyGet >= 4 then
            ShowText(HLNSLocalizedString("全部奖励已领取"))
        else
            local templabel = tolua.cast(HaiZeiTeamViewOwner["templabel"],"CCLabelTTF")
            ShowText(HLNSLocalizedString("再拥有%s个S级伙伴才可以领取奖励",templabel:getString()))
        end
    end
end
HaiZeiTeamViewOwner["onGetTaped"] = onGetTaped

local function updateTimeLabel(  )
    local endTime = tolua.cast(HaiZeiTeamViewOwner["endTime"],"CCLabelTTF")
    endTime:enableStroke(ccc3(0,0,0), 1)
    endTime:setString(string.format(HLNSLocalizedString("活动结束时间：%s"),dailyData:getFantasyTeamEndTime()))
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/HaiZeiTeamView.ccbi",proxy, true,"HaiZeiTeamViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    for i=1,4 do
        local btn = tolua.cast(HaiZeiTeamViewOwner["btn"..i],"CCMenuItemImage")
        local nameLabel = tolua.cast(HaiZeiTeamViewOwner["nameLabel"..i],"CCLabelTTF")
        local frame = tolua.cast(HaiZeiTeamViewOwner["frame_"..i],"CCSprite") 

    end
    _refreshUI()
end

-- 该方法名字每个文件不要重复
function getHaiZeiTeamLayer()
	return _layer
end

function createHaiZeiTeamLayer()
    _init()

    local function _onEnter()
    	-- _changeState(runtimeCache.newWorldState)
        -- addObserver(NOTI_EAT_CD, _updateUIStatus)

        canGetFlag = false
        _refreshUI()
        addObserver(NOTI_FANTASY_END_TIMER, updateTimeLabel)
    end

    local function _onExit()
        _layer = nil
        _data = nil
        -- removeObserver(NOTI_EAT_CD, _updateUIStatus)
        canGetFlag = false
        alreadyGet = nil
        removeObserver(NOTI_FANTASY_END_TIMER, updateTimeLabel)
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