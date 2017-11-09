local _layer
local _skillDic
local selectBtn1
local selectBtn2
local selectBtn3
local selectBtn4
local selectBtn5


-- ·名字不要重复
BreakSkillLayerOwner = BreakSkillLayerOwner or {}
ccb["BreakSkillLayerOwner"] = BreakSkillLayerOwner

local function updateTopLabel( flag,array )
    local tipLabel = tolua.cast(BreakSkillLayerOwner["topTipInfo"],"CCLabelTTF")
    local successRet = tolua.cast(BreakSkillLayerOwner["successRet"],"CCLabelTTF")
    
    tipLabel:setVisible(false)
    successRet:setVisible(false)
    
    if flag == 0 then
        -- 只显示一个提示
        tipLabel:setVisible(true)
    elseif flag == 1 then
        successRet:setVisible(true)
        
        successRet:setString(HLNSLocalizedString("成功概率：%s%%", math.floor(array[1] * 100) <= 100 and math.floor(array[1] * 100) or 100))
    end
end

local function updateFingerState(  )
    local fingerSprite = tolua.cast(BreakSkillLayerOwner["breakFinger"],"CCSprite")
    for i=1,5 do
        if i > getMyTableCount(runtimeCache.skillUpdateMaterialArray[_skillDic.id]) then
            local selectBtn = tolua.cast(BreakSkillLayerOwner[string.format("selectBtn%d",i)],"CCMenuItemImage")
            fingerSprite:setPosition(ccp(selectBtn:getPositionX(),selectBtn:getPositionY() + 70))
            break
        else
            if i == 5 then
                fingerSprite:setVisible(false)
            end
        end
    end

    if getMyTableCount(runtimeCache.skillUpdateMaterialArray[_skillDic.id]) > 0 then
        local allexp = 0
        for key,value in pairs(runtimeCache.skillUpdateMaterialArray[_skillDic.id]) do
            local skillContent = skilldata:getOneSkillByUniqueID( value.id )
            allexp = allexp + skillContent.skillConf.rank
        end
        local rank = _skillDic.skillConf.rank
        local needEXP = skilldata:getSkillEXPByRankAndLevel(rank,_skillDic.level)
        updateTopLabel( 1,{ allexp / needEXP,200 } )
    else
        updateTopLabel( 0 )
    end
end

local function updateStageContent(  )
    for i=1,5 do
        local stageIcon = tolua.cast(BreakSkillLayerOwner[string.format("stageIcon%d",i)],"CCSprite")
        local avatarIcon = tolua.cast(BreakSkillLayerOwner[string.format("avatarIcon%d",i)],"CCSprite")
        if  i <= getMyTableCount(runtimeCache.skillUpdateMaterialArray[_skillDic.id]) then
            local j = 1
            for key,value in pairs(runtimeCache.skillUpdateMaterialArray[_skillDic.id]) do
                if i == j then
                    stageIcon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%s.png", value.skillConf.rank)))
                    if avatarIcon then
                        local texture = CCTextureCache:sharedTextureCache():addImage(equipdata:getEquipIconByEquipId( value.skillId ))
                        if texture then
                            avatarIcon:setVisible(true)
                            avatarIcon:setTexture(texture)
                            if value.skillConf.rank == 4 then
                                HLAddParticleScale( "images/purpleEquip.plist", avatarIcon, ccp(avatarIcon:getContentSize().width / 2,avatarIcon:getContentSize().height / 2), 1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1 )
                            elseif value.skillConf.rank == 5 then
                                HLAddParticleScale( "images/goldEquip.plist", avatarIcon, ccp(avatarIcon:getContentSize().width / 2,avatarIcon:getContentSize().height / 2), 1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1 )
                            end
                        end
                    end
                    break
                end
                j = j + 1
            end
        else
            stageIcon:setVisible(false)
        end
    end
    local nameLabel = tolua.cast(BreakSkillLayerOwner["nameLabel"],"CCLabelTTF")
    nameLabel:setString(_skillDic.skillConf.name)
    local stageIcon = tolua.cast(BreakSkillLayerOwner["topFrame"],"CCSprite")
    local avatarIcon = tolua.cast(BreakSkillLayerOwner["topAvatar"],"CCSprite")
    stageIcon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%s.png", _skillDic.skillConf.rank)))

    local levelBg = BreakSkillLayerOwner["levelSprite"]
    levelBg:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("level_bg_%s.png",_skillDic.skillConf.rank)))
    local levelLabel = BreakSkillLayerOwner["levelLabel"]
    levelLabel:setString(_skillDic.level)

    if avatarIcon then
        local texture = CCTextureCache:sharedTextureCache():addImage(equipdata:getEquipIconByEquipId( _skillDic.skillId ))
        if texture then
            avatarIcon:setVisible(true)
            avatarIcon:setTexture(texture)
            if _skillDic.skillConf.rank == 4 then
                HLAddParticleScale( "images/purpleEquip.plist", avatarIcon, ccp(avatarIcon:getContentSize().width / 2,avatarIcon:getContentSize().height / 2), 1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1 )
            elseif _skillDic.skillConf.rank == 5 then
                HLAddParticleScale( "images/goldEquip.plist", avatarIcon, ccp(avatarIcon:getContentSize().width / 2,avatarIcon:getContentSize().height / 2), 1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1 )
            end
        end
    end
end

local function onSelectBtnTaped( tag,sender )
    print(tag)
    if getMainLayer() then
        getMainLayer():gotoSkillBreakSelectLayer(_skillDic.id,_skillDic)
    end
end

BreakSkillLayerOwner["onSelectBtnTaped"] = onSelectBtnTaped

local function breakCallBack( url,rtnData )
    local gotoType
    if rtnData["code"] == 200 then
        if rtnData.info.result == 0 then
            gotoType = "0"
        elseif rtnData.info.result == 1 then
            gotoType = "1"
        end
        local gainData = rtnData.info.gain
        --  更新升级信息
        for key,value in pairs(skilldata.skills) do
            if gainData.id == key then
                skilldata.skills[key] = gainData
            end
        end
        for k,hid in pairs(herodata.form) do
            local hero = herodata:getHero(herodata.heroes[hid])
            local id = hero.skill_default.id
            if id == gainData.id then
                herodata.heroes[hid].skill_default =  gainData
            end
        end

        local sevenForm = herodata.sevenForm
        for k,hid in pairs(sevenForm) do
            local hero = herodata.heroes[hid]
            if hero then
                local id = hero.skill_default.id
                if hero.wake and hero.wake > 0 then
                    id = herodata:getHeroConfig(hero.heroId, hero.wake).skill
                    hero.skill_default.skillId = herodata:getHeroConfig(hero.heroId, hero.wake).skill
                end
                if id == gainData.id then
                    herodata.heroes[hid].skill_default =  gainData
                end
            end
        end
        local offFormHero = herodata:getHeroOffForm()
        for i=1,getMyTableCount(offFormHero) do
            local hid = offFormHero[i]
            local hero = herodata.heroes[hid]
            local id = hero.skill_default.id
            if hero.wake and hero.wake > 0 then
                id = herodata:getHeroConfig(hero.heroId, hero.wake).skill
                hero.skill_default.skillId = herodata:getHeroConfig(hero.heroId, hero.wake).skill
            end
            if id == gainData.id then
                herodata.heroes[hid].skill_default =  gainData
            end
        end
        
        palyBreakAnimationOnNode(_skillDic,runtimeCache.skillUpdateMaterialArray[_skillDic.id],gotoType,getMainLayer())

        if getMainLayer() then
            runtimeCache.skillUpdateMaterialArray[_skillDic.id] = {}
            getMainLayer():gotoBreakSkillResultView(_skillDic,gotoType)
        end
    end
end

--突破
local function onFareWellClicked(  )
    Global:instance():TDGAonEventAndEventData("profound2")
    local array = {}
    if _skillDic.level < skilldata:getSkillBreakMaxLevel() then
        if getMyTableCount(runtimeCache.skillUpdateMaterialArray[_skillDic.id]) > 0 then
            for key,value in pairs(runtimeCache.skillUpdateMaterialArray[_skillDic.id]) do
                table.insert(array,key)
            end
            doActionFun("SKILL_BREAK_URL",{_skillDic.id,array},breakCallBack)
        else
            ShowText(HLNSLocalizedString("请选择奥义材料"))
        end 
    else
        ShowText(HLNSLocalizedString("奥义已达到突破上限"))
    end
end

-- 退出
local function onBackClicked()
    print("onBackClicked")
    runtimeCache.skillUpdateMaterialArray[_skillDic.id] = {}
    if runtimeCache.breakSkillType == 1 then
        getMainLayer():gotoTeam()
        runtimeCache.breakSkillType = 0
    else
        getMainLayer():gotoSkillViewLayer()
    end
end

BreakSkillLayerOwner["onFareWellClicked"] = onFareWellClicked
BreakSkillLayerOwner["onBackClicked"] = onBackClicked

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/BreakSkillVIewLayer.ccbi",proxy, true,"BreakSkillLayerOwner")
    _layer = tolua.cast(node,"CCLayer")
    -- local selectBtn2 = tolua.cast(BreakSkillLayerOwner["selectBtn2"],"CCMenuItemImage")
    updateFingerState()
    updateStageContent()
end


-- 该方法名字每个文件不要重复
function getBreakSkillViewLayer()
	return _layer
end

function createBreakSkillViewLayer(dic)
    _skillDic = dic
    _init()

	-- public方法写在每个layer的创建的方法内 调用时方法
	-- local layer = getLayer()
	-- layer:refresh()

	function _layer:refresh()
		
	end

    local function _onEnter()
        print("onEnter")
    end

    local function _onExit()
        print("onExit")
        _layer = nil
        _skillDic= nil
        selectBtn1 = nil
        selectBtn2 = nil
        selectBtn3 = nil
        selectBtn4 = nil
        selectBtn5 = nil
        
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