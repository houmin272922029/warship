HeroDetail_Clicked_HuoBan         = 0     -- 点击伙伴cell中的头像 (左按钮：传功  右按钮：关闭)
HeroDetail_Clicked_HunPo_Recruit  = 1     -- 点击魂魄Cell中的头像，这个英雄可以招募  (左按钮：招募  右按钮：关闭)
HeroDetail_Clicked_HunPo_Break    = 2     -- 点击魂魄Cell中的头像，这个英雄可以突破  (左按钮：突破  右按钮：关闭)
HeroDetail_Clicked_HunPo_Null     = 3     -- 点击魂魄Cell中的头像，这个英雄不可以突破也不可以招募  (左按钮：无  右按钮：关闭)
HeroDetail_Clicked_Team           = 4     -- 点击阵容中的英雄半身像
HeroDetail_Clicked_Handbook       = 5     -- 点击图鉴中的英雄头像
HeroDetail_Clicked_SelectHero     = 6     -- 点击选择英雄上阵或送别中的头像  (左按钮：无  右按钮：关闭)
HeroDetail_Clicked_ShowHero       = 7     -- 点击觉醒页面本次展示的觉醒头像 (点击弹出金色伙伴属性)

local _layer
local _hid
local _priority = -132
local _uiType = HeroDetail_Clicked_HuoBanCell      

-- 名字不要重复
HeroDetailOwner = HeroDetailOwner or {}
ccb["HeroDetailOwner"] = HeroDetailOwner

HeroDetailCellOwner = HeroDetailCellOwner or {}
ccb["HeroDetailCellOwner"] = HeroDetailCellOwner

local function closeItemClick()
    popUpCloseAction( HeroDetailOwner,"infoBg",_layer )
end
HeroDetailOwner["closeItemClick"] = closeItemClick
HeroDetailCellOwner["closeItemClick"] = closeItemClick

local function onLeftClicked()
    print("onLeftClicked")
    if _uiType == HeroDetail_Clicked_HuoBan then
        -- 送别
        if getMainLayer() ~= nil then
            getMainLayer():goToFarewell(_hid, nil, 0)
        end
    elseif _uiType == HeroDetail_Clicked_HunPo_Recruit then
        -- 招募
        if getHeroesLayer() then
            getHeroesLayer():recruitHero()
        end 
    elseif _uiType == HeroDetail_Clicked_HunPo_Break then
        -- 突破
        if getHeroesLayer() then
            getHeroesLayer():breakHero()
        end 
    elseif _uiType == HeroDetail_Clicked_HunPo_Null then
    elseif _uiType == HeroDetail_Clicked_Team then
        -- 送别
        if getMainLayer() ~= nil then
            getMainLayer():goToFarewell(_hid, nil, 0, 1)
        end
    elseif _uiType == HeroDetail_Clicked_Handbook then
        print("分享有奖")
        Global:instance():TDGAonEventAndEventData("share1")
        local dic = herodata:getHeroBasicInfoByHeroId(_hid)
        --5是分享英雄
        -- local shareInfo = {pic = herodata:getHeroBust1ByHeroId(dic.heroId), text = string.format(ConfigureStorage.Share[5]["content"],dic.name,dic.desp), size = 1}
        local shareInfo = {pic = fileUtil:fullPathForFilename(herodata:getHeroBust1ByHeroId(dic.heroId)), text = string.format(ConfigureStorage.Share[5]["content"],dic.name,dic.desp), size = 1}
        local sharelayer = createShareLayer(shareInfo, -137)
        CCDirector:sharedDirector():getRunningScene():addChild(sharelayer,100)
    elseif _uiType == HeroDetail_Clicked_ShowHero then
        if getMainLayer() ~= nil then
            getMainLayer():goToFarewell(_hid, nil, 0)
        end
    end 
    popUpCloseAction( HeroDetailOwner,"infoBg",_layer )
end
HeroDetailCellOwner["onLeftClicked"] = onLeftClicked

local function onRightClicked()
    print("onRightClicked")
    if _uiType == HeroDetail_Clicked_Team then
        -- 换伙伴
        getMainLayer():gotoOnForm()
    else
        -- 关闭
    end 
    popUpCloseAction( HeroDetailOwner,"infoBg",_layer )
end
HeroDetailCellOwner["onRightClicked"] = onRightClicked

local function onSkillClicked()
    if _uiType == HeroDetail_Clicked_HunPo_Recruit or _uiType == HeroDetail_Clicked_HunPo_Break or _uiType == HeroDetail_Clicked_HunPo_Null or _uiType == HeroDetail_Clicked_Handbook then
        local dic = herodata:getHeroBasicInfoByHeroId(_hid)
        if getMainLayer() then
            getMainLayer():getParent():addChild(createHandBookSkillDetailLayer(dic.skill,-400), 100) 
        end
    else 
        -- 要技能唯一信息
        local dic = herodata:getHeroInfoByHeroUId( _hid )
        if getMainLayer() then
            runtimeCache.breakSkillType = 1
            getMainLayer():getParent():addChild(createSkillDetailLayer(skilldata:getOneSkillByUniqueID( dic.skill_default.id ),0,-400), 100) 
        end
    end
end
HeroDetailCellOwner["onSkillClicked"] = onSkillClicked

local function setTabBtnSpriteFrame( sender,bool )
    if bool then
        sender:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("peopleDown.png"))
        sender:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("peopleDown.png"))
    else
        sender:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("peopleUp.png"))
        sender:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("peopleUp.png"))
    end
end

local function setTabSprite( flag )
    local infoBtn = tolua.cast(HeroDetailCellOwner["infoBtn"], "CCMenuItemImage")
    local propertyBtn = tolua.cast(HeroDetailCellOwner["propertyBtn"], "CCMenuItemImage")
    local briefNode = tolua.cast(HeroDetailCellOwner["briefNode"], "CCSprite")
    local propertyNode = tolua.cast(HeroDetailCellOwner["propertyNode"], "CCSprite")
    if flag then
        briefNode:setVisible(true)
        propertyNode:setVisible(false)
        setTabBtnSpriteFrame( infoBtn,true )
        setTabBtnSpriteFrame( propertyBtn,false )
    else
        briefNode:setVisible(false)
        propertyNode:setVisible(true)
        setTabBtnSpriteFrame( infoBtn,false )
        setTabBtnSpriteFrame( propertyBtn,true )
    end
end

local function onInfoTaped(  )
    setTabSprite(true)
end

HeroDetailCellOwner["onInfoTaped"] = onInfoTaped

local function onPropertyTaped(  )
    setTabSprite(false)
end

HeroDetailCellOwner["onPropertyTaped"] = onPropertyTaped

local function _updateLabelString(labelStr, string)
        local label = tolua.cast(HeroDetailCellOwner[labelStr], "CCLabelTTF")
        label:setString(string)
        label:setVisible(true)
        -- 给登记信息描边
        if labelStr == "levelLabel" then
            label:enableStroke(ccc3(0,0,0), 1)
        end 
    end

local function _refreshData()
    local dic = nil 
    local attrArray = nil
    if _uiType == HeroDetail_Clicked_HuoBan or _uiType == HeroDetail_Clicked_Team or _uiType == HeroDetail_Clicked_SelectHero then
        dic = herodata:getHeroInfoByHeroUId( _hid )        
        attrArray = herodata:getHeroAttrsAndAddByHeroUId( _hid ) 
    elseif _uiType == HeroDetail_Clicked_HunPo_Recruit or _uiType == HeroDetail_Clicked_HunPo_Break 
        or _uiType == HeroDetail_Clicked_HunPo_Null or _uiType == HeroDetail_Clicked_Handbook then
        dic = herodata:getHeroBasicInfoByHeroId(_hid)
        attrArray = dic.attr
    elseif _uiType == HeroDetail_Clicked_ShowHero then
        dic = herodata:getHeroConfig( _hid, 2)
        attrArray = dic.attr
    end
    if dic == nil then
        return
    end 
    
    _updateLabelString("hp", HLNSLocalizedString("hp").." :")
    _updateLabelString("atk", HLNSLocalizedString("atk").." :")
    _updateLabelString("def", HLNSLocalizedString("def").." :")
    _updateLabelString("mp", HLNSLocalizedString("mp").." :")
    _updateLabelString("hit", HLNSLocalizedString("hit").." :")
    _updateLabelString("cri", HLNSLocalizedString("cri").." :")
    _updateLabelString("cnt", HLNSLocalizedString("cnt").." :")
    _updateLabelString("dod", HLNSLocalizedString("dod").." :")
    _updateLabelString("resi", HLNSLocalizedString("resi").." :")
    _updateLabelString("parry", HLNSLocalizedString("parry").." :")

    _updateLabelString("label21", attrArray.hp)
    _updateLabelString("label22", attrArray.atk)
    _updateLabelString("label23", attrArray.def)
    _updateLabelString("label24", attrArray.mp)
    _updateLabelString("label25", attrArray.hit)
    _updateLabelString("label26", attrArray.cri)
    _updateLabelString("label27", attrArray.cnt)
    _updateLabelString("label28", attrArray.dod)
    _updateLabelString("label29", attrArray.resi)
    _updateLabelString("label2t", attrArray.parry)
    local trainLevel = 0
    if _uiType == HeroDetail_Clicked_ShowHero then
    else
        trainLevel = herodata:getOneHeroTrainLevel( dic.id )
    end
    local attrHeroArray = herodata:getTrainArrByHeroIdAndlevel( dic.heroId,trainLevel )


    local heroTrainLevel = tolua.cast(HeroDetailCellOwner["heroTrainLevel"],"CCLabelTTF")
    local heroTrainBg = tolua.cast(HeroDetailCellOwner["heroTrainBg"],"CCSprite")
    heroTrainLevel:setString(trainLevel)
    if attrHeroArray.type then
        local attrLabel = tolua.cast(HeroDetailCellOwner[attrHeroArray["type"]],"CCLabelTTF")
        heroTrainBg:setPosition(ccp(heroTrainBg:getPositionX(),attrLabel:getPositionY()))
    end
    _updateLabelString("nameLabel", dic.name)
    local rankSprite = tolua.cast(HeroDetailCellOwner["rankSprite"], "CCSprite")
    local rank = _uiType == HeroDetail_Clicked_ShowHero and 5 or dic.rank
    if _uiType == HeroDetail_Clicked_Handbook and herodata:getHeroInfoById(_hid) then
        rank = herodata:getHeroInfoById(_hid).rank
    end
    rankSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("rank_%d_icon.png", rank)))
    
    if _uiType == HeroDetail_Clicked_HuoBan or _uiType == HeroDetail_Clicked_Team or _uiType == HeroDetail_Clicked_SelectHero then
        local breakLevel = tolua.cast(HeroDetailCellOwner["break"],"CCSprite")
        local breakFnt = tolua.cast(HeroDetailCellOwner["breakFnt"], "CCLabelBMFont")
        local breakValue = dic["break"]
        if breakLevel and breakValue ~= 0 then 
            breakLevel:setVisible(true)
            breakFnt:setString(breakValue)
        end 
    end

    local rankBg = tolua.cast(HeroDetailCellOwner["rankBg"], "CCSprite")
    rankBg:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("hero_bg_%d.png", rank)))
    -- 半身像
    local bustSpr = tolua.cast(HeroDetailCellOwner["bust"], "CCSprite")
    if bustSpr then 
        local texture = CCTextureCache:sharedTextureCache():addImage(herodata:getHeroBust1ByHeroId(dic.heroId))
        if texture then
            bustSpr:setTexture(texture)
        end     
    end 

    -- 简介
    local desp = tolua.cast(HeroDetailCellOwner["despLabel"], "CCLabelTTF")
    if desp then
        desp:setString(dic.desp)
    end 

    -- 技能
    local heroId = _hid
    local wake
    if _uiType == HeroDetail_Clicked_HuoBan or _uiType == HeroDetail_Clicked_Team or _uiType == HeroDetail_Clicked_SelectHero then
        heroId = herodata:getHeroIdByUId(_hid)
        wake = herodata:getHeroInfoById( heroId ).wake 
    else
        for k,v in pairs(herodata.sevenForm) do
            if herodata.heroes[v].heroId == heroId then
                wake = herodata.heroes[v].wake
            end
        end
    end 
    local skillBasicInfo = skilldata:getHeroInnateSkillByHeroId( heroId,wake )
    local skillName = tolua.cast(HeroDetailCellOwner["skillName"], "CCLabelTTF")
    if skillName then
        skillName:setString(skillBasicInfo.name)
    end 
    local skillBtn = tolua.cast(HeroDetailCellOwner["skillBtn"], "CCMenuItemImage")
    if skillBtn then
        skillBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", skillBasicInfo.rank)))
    end 
    local skillIcon = tolua.cast(HeroDetailCellOwner["skillIcon"], "CCSprite")
    if skillIcon then
        local texture = CCTextureCache:sharedTextureCache():addImage(string.format("ccbResources/icons/%s.png", skillBasicInfo.icon))
        if texture then
            skillIcon:setTexture(texture)
        end
    end 

    -- ui
    if _uiType == HeroDetail_Clicked_HuoBan or _uiType == HeroDetail_Clicked_Team or _uiType == HeroDetail_Clicked_SelectHero then
        _updateLabelString("levelLabel", string.format("LV:%d", dic.level))
        _updateLabelString("priceLabel", herodata:getHeroAttrPrice(_hid))
        local attr = herodata:getHeroAttrsByHeroUId(_hid)
        _updateLabelString("hpLabel", attr.hp)
        _updateLabelString("atkLabel", attr.atk)
        _updateLabelString("defLabel", attr.def)
        _updateLabelString("mpLabel", attr.mp)

        -- 经验
        local progressBg = tolua.cast(HeroDetailCellOwner["progressBg"], "CCSprite")
        progressBg:setVisible(true)
        local progress = CCProgressTimer:create(CCSprite:create("images/bluePro.png"))
        progress:setType(kCCProgressTimerTypeBar)
        progress:setMidpoint(CCPointMake(0, 0))
        progress:setBarChangeRate(CCPointMake(1, 0))
        progress:setPosition(progressBg:getPositionX(), progressBg:getPositionY())
        -- progress:setScale(retina)
        progressBg:getParent():addChild(progress)
        progress:setPercentage(dic.exp_now / dic.expMax * 100)

    elseif _uiType == HeroDetail_Clicked_HunPo_Recruit or _uiType == HeroDetail_Clicked_HunPo_Break or _uiType == HeroDetail_Clicked_HunPo_Null or _uiType == HeroDetail_Clicked_Handbook then
        _updateLabelString("levelLabel", "")
        _updateLabelString("priceLabel", herodata:getHeroPriceConfig(_hid))            
        local attr = dic.attr
        _updateLabelString("hpLabel", attr.hp)
        _updateLabelString("atkLabel", attr.atk)
        _updateLabelString("defLabel", attr.def)
        _updateLabelString("mpLabel", attr.mp)
    elseif _uiType == HeroDetail_Clicked_ShowHero then
        _updateLabelString("levelLabel", "")
        _updateLabelString("priceLabel", herodata:getHeroPriceConfig(_hid , 2))            
        local attr = dic.attr
        _updateLabelString("hpLabel", attr.hp)
        _updateLabelString("atkLabel", attr.atk)
        _updateLabelString("defLabel", attr.def)
        _updateLabelString("mpLabel", attr.mp)
    end 

    -- 按钮状态
    local leftBtn = tolua.cast(HeroDetailCellOwner["leftBtn"], "CCMenuItemImage")
    local leftBtnText = tolua.cast(HeroDetailCellOwner["leftBtnText"], "CCSprite")
    local rightBtnText = tolua.cast(HeroDetailCellOwner["rightBtnText"], "CCSprite")
    if _uiType == HeroDetail_Clicked_HuoBan then

    elseif _uiType == HeroDetail_Clicked_HunPo_Recruit then
        leftBtnText:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("zhaomu_title.png"))
    elseif _uiType == HeroDetail_Clicked_HunPo_Break then
        leftBtnText:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tupo_title.png"))
    elseif _uiType == HeroDetail_Clicked_HunPo_Null or _uiType == HeroDetail_Clicked_SelectHero then
        leftBtn:setVisible(false)
        leftBtnText:setVisible(false)
    elseif _uiType == HeroDetail_Clicked_Team then
        rightBtnText:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("change_hero_text.png"))
    elseif _uiType == HeroDetail_Clicked_Handbook then
        if not isOpenShare(  ) then
            leftBtn:setVisible(false)
            leftBtnText:setVisible(false)
        end
        leftBtnText:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("fenxiangyoujiang_text.png"))
        rightBtnText:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("guanbi_text.png"))
    elseif _uiType == HeroDetail_Clicked_ShowHero then
        leftBtn:setVisible(false)
        leftBtnText:setVisible(false)
    end
    local awake
    if _uiType == HeroDetail_Clicked_HuoBan or _uiType == HeroDetail_Clicked_Team 
        or _uiType == HeroDetail_Clicked_SelectHero then
        awake = herodata.heroes[_hid].wake
    elseif _uiType == HeroDetail_Clicked_Handbook and herodata:getHeroInfoById(_hid) then
        if herodata:getHeroInfoById(_hid).rank == 5 then
            awake = 2 
        end
    elseif _uiType == HeroDetail_Clicked_ShowHero then
        awake = 2
    end
    local combo = herodata:getComboInfoByHeroId(heroId, awake)
    local comboLabel = tolua.cast(HeroDetailCellOwner["comboLabel"], "CCLabelTTF")
    comboLabel:setString(combo)
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/HeroDetailView.ccbi", proxy, true,"HeroDetailOwner")
    _layer = tolua.cast(node,"CCLayer")
    local sv = tolua.cast(HeroDetailOwner["sv"], "CCScrollView") 

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

        sv:setContentOffset(ccp(0, -60))
        
    else
        sv:setContentOffset(ccp(0, -60))
    end
    _refreshData()
    setTabSprite(true)
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(HeroDetailOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction( HeroDetailOwner,"infoBg",_layer )
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

local function setMenuPriority()
    local sv = tolua.cast(HeroDetailOwner["sv"], "CCScrollView") 
    sv:setTouchPriority(_priority-2)
    local menu1 = tolua.cast(HeroDetailOwner["menu"], "CCMenu")
    menu1:setHandlerPriority(_priority-1)
    local menu2 = tolua.cast(HeroDetailCellOwner["menu"], "CCMenu")
    menu2:setHandlerPriority(_priority-1)
    local menu3 = tolua.cast(HeroDetailCellOwner["menu3"], "CCMenu")
    menu3:setHandlerPriority(_priority-1)
end

-- 该方法名字每个文件不要重复
function getHeroInfoLayer()
	return _layer
end

function createHeroInfoLayer(hid, uiType, priority)
    _hid = hid
    _uiType = uiType
    _priority = (priority ~= nil) and priority or -132
    _init()

    

    local function _onEnter()
        print("onEnter")
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.1), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        popUpUiAction( HeroDetailOwner,"infoBg" )
    end

    local function _onExit()
        print("onExit")
        _layer = nil
        _hid = nil
        _priority = nil
        _uiType = HeroDetail_Clicked_HuoBanCell
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end


    _layer:registerScriptTouchHandler(onTouch ,false , _priority ,true )
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end