local _layer
local _heroId = nil

BreakLayerOwner = BreakLayerOwner or {}
ccb["BreakLayerOwner"] = BreakLayerOwner

local function onCancelClicked()
    print("onCancelClicked")
    if getMainLayer() ~= nil then
        getMainLayer():goToHeroes()
    end
end
BreakLayerOwner["onCancelClicked"] = onCancelClicked


-- 刷新UI
local function _updateBreakUI()
    -- UI上的label赋值
    local function _updateUILabel( key , value)
        local label = tolua.cast(BreakLayerOwner[key], "CCLabelTTF")
        if label then
            label:setString(value)
        end
    end


    local heroInfo = herodata:getHeroInfoById(_heroId)
    if heroInfo then
        -- 基本数值
        _updateUILabel("name", heroInfo.name)
        local rankSprite = tolua.cast(BreakLayerOwner["rank"], "CCSprite")
        if rankSprite then
            rankSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("rank_%d_icon.png", heroInfo.rank)))
        end
        _updateUILabel("lv", heroInfo.level)
        local bNow = tolua.cast(BreakLayerOwner["bNow"], "CCLabelBMFont")
        local bNext = tolua.cast(BreakLayerOwner["bNext"], "CCLabelBMFont")
        bNow:setString(heroInfo["break"])
        bNext:setString(heroInfo["break"] + 1)
        _updateUILabel("need", heroSoulData:getBreakNeedSoulCount(heroInfo.rank, heroInfo["break"], heroInfo["wake"]))
        _updateUILabel("have", heroSoulData:getSoulCountByHeroId( _heroId ))
        if heroSoulData:getBreakNeedSoulCount(heroInfo.rank, heroInfo["break"], heroInfo["wake"]) > heroSoulData:getSoulCountByHeroId( _heroId ) then
            -- 魂魄数不够，禁用按钮
            local breakBtn = tolua.cast(BreakLayerOwner["breakBtn"], "CCMenuItem")
            if breakBtn then
                breakBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn4_2.png"))
                -- breakBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn4_2.png"))
            end 
            local need = tolua.cast(BreakLayerOwner["need"], "CCLabelTTF")
            need:setColor(ccc3(255, 0, 0))
        end 
        -- 提示语
        -- _updateUILabel("tipInfo", HLNSLocalizedString("hero.break.tipInfo", heroSoulData:getBreakedPointByRank(heroInfo.rank)))
        local attr = herodata:getHeroBasicAttrsByHeroUId(heroInfo.id)
        _updateUILabel("hp", attr.hp)
        _updateUILabel("atk", attr.atk)
        _updateUILabel("def", attr.def)
        _updateUILabel("mp", attr.mp)
        _updateUILabel("point", heroInfo.point)
        local breakAttr = herodata:getHeroBreakAttrUp(_heroId, heroInfo.wake)
        local bHp = breakAttr.hp and breakAttr.hp or 0
        local bAtk = breakAttr.atk and breakAttr.atk or 0
        local bDef = breakAttr.def and breakAttr.def or 0
        local bMp = breakAttr.mp and breakAttr.mp or 0
        _updateUILabel("hpUp", string.format("+ %d", bHp))
        _updateUILabel("atkUp", string.format("+ %d", bAtk))
        _updateUILabel("defUp", string.format("+ %d", bDef))
        _updateUILabel("mpUp", string.format("+ %d", bMp))
        _updateUILabel("pointUp", string.format("+ %d", heroSoulData:getBreakedPointByRank(heroInfo.rank)))
    end

    -- avatar
    local avatar = tolua.cast(BreakLayerOwner["avatar"], "CCSprite")
    if avatar then
        herodata:getAvatarActionByHeroId(avatar, heroInfo.heroId )
    end 

end 

local function breakCallBack( url,rtnData )
    -- for k,v in pairs(rtnData["info"]) do
    --     if havePrefix(k, "hero") then
    --         PrintTable(v)
    --         herodata:addHeroByDic(v)
    --     end
    -- end 
    _updateBreakUI()
end 

-- 突破
local function onBreakClicked()
    print("onBreakClicked")
    local function breakCallBack( url,rtnData )

        local avatar = tolua.cast(BreakLayerOwner["avatar"], "CCSprite")

        -- renzhan
        HLAddParticleScale( "ccbResources/conv/effect_prt_500_1.plist", BreakLayerOwner["avatar"], ccp(avatar:getContentSize().width/2, avatar:getContentSize().height * 0.5), 4, 4, 4, 1/retina, 1/retina)
        HLAddParticleScale( "ccbResources/conv/eff_page_206_4_1.plist", getMainLayer(), ccp(winSize.width * 0.3, winSize.height * 1.2), 2, 1, 1 , 1, 1)
        -- 

        for k,v in pairs(rtnData["info"]) do
            if havePrefix(k, "hero") then
                herodata:addHeroByDic(v)
            end
        end 

        _updateBreakUI()

        ShowText(HLNSLocalizedString("hero.break.succ"))
    end 

    local heroInfo = herodata:getHeroInfoById(_heroId)
    if heroSoulData:getBreakNeedSoulCount(heroInfo.rank, heroInfo["break"], heroInfo["wake"]) > heroSoulData:getSoulCountByHeroId( _heroId ) then
        -- 魂魄数不够，提示魂魄数不够
        ShowText(HLNSLocalizedString("hero.break.soulNotEnough"))
        return
    end 
    doActionFun("BREAKHERO_URL", { _heroId}, breakCallBack) 
end
BreakLayerOwner["onBreakClicked"] = onBreakClicked

local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/BreakHeroView.ccbi",proxy, true,"BreakLayerOwner")
    _layer = tolua.cast(node,"CCLayer")

    _updateBreakUI()
end


function getBreakLayer()
    return _layer
end

function createBreakLayer(heroId)
    print("heroId =", heroId)
    _heroId = heroId
    _init()


    local function _onEnter()
        print("CultureLayer onEnter")
    end

    local function _onExit()
        print("CultureLayer onExit")
        _layer = nil
        _heroId = nil
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