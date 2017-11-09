local _layer
local _skillDic
local _gotoType
local _currentDic

-- ·名字不要重复
BreakSkillResultOwner = BreakSkillResultOwner or {}
ccb["BreakSkillResultOwner"] = BreakSkillResultOwner

local function ontExitBtnTaped(  )
    local _mainLayer = getMainLayer()
    if _mainLayer then
        if runtimeCache.breakSkillType == 1 then
            _mainLayer:gotoTeam()
            runtimeCache.breakSkillType = 0
        else
            _mainLayer:gotoSkillViewLayer()
        end
    end
end

local function onGoonBtnClicked(  )
    local _mainLayer = getMainLayer()
    if _mainLayer then
        _mainLayer:gotoBreakSkillView(_skillDic)
    end
end

BreakSkillResultOwner["onGoonBtnClicked"] = onGoonBtnClicked
BreakSkillResultOwner["ontExitBtnTaped"] = ontExitBtnTaped

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/BreakSkillResult.ccbi",proxy, true,"BreakSkillResultOwner")
    _layer = tolua.cast(node,"CCLayer")

    local nameLabel = tolua.cast(BreakSkillResultOwner["nameLabel"],"CCLabelTTF")
    nameLabel:setString(_skillDic.skillConf.name)

    local rankFrame = tolua.cast(BreakSkillResultOwner["rankFrame"],"CCSprite")
    rankFrame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%s.png", _skillDic.skillConf.rank)))

    local levelLabel = tolua.cast(BreakSkillResultOwner["levelLabel"],"CCLabelTTF")
    levelLabel:setString(string.format("LV:%s",_skillDic.level))

    local attrLabel = tolua.cast(BreakSkillResultOwner["attrLabel"],"CCLabelTTF")
    attrLabel:setString(_skillDic.skillConf.name)
    
    local rankSprite = tolua.cast(BreakSkillResultOwner["rankSprite"],"CCSprite")
    rankSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("rank_%d_icon.png", _skillDic.skillConf.rank)))

    local avatarIcon = tolua.cast(BreakSkillResultOwner["avatarIcon"],"CCSprite")
    local res = wareHouseData:getItemResource(_skillDic.skillId)
    if res.icon then
        local texture = CCTextureCache:sharedTextureCache():addImage(res.icon)
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
    local attrSprite = tolua.cast(BreakSkillResultOwner["attrSprite"],"CCSprite")
    local myType
    local myAttrValue
    for key,value in pairs(_skillDic.attr) do
        myType = key
        myAttrValue = value
    end
    attrSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("%s_icon.png",(myType == "mp") and "int" or myType)))
    
    local attrLabel = BreakSkillResultOwner["attrLabel"]
    attrLabel:setString(skilldata:getSkillAttrValueByUid( _skillDic.id ))

    local resultSprite = tolua.cast(BreakSkillResultOwner["resultSprite"],"CCSprite")
    if _gotoType == "1" then
        resultSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tupochenggong_text.png"))
        
        local nowLevelLabel = tolua.cast(BreakSkillResultOwner["nowLevelLabel"],"CCLabelTTF")
        nowLevelLabel:setString(string.format("LV:%s",_currentDic.level))

        local nowAttrSprite = tolua.cast(BreakSkillResultOwner["nowAttrSprite"],"CCSprite")
        for key,value in pairs(_currentDic.attr) do
            myType = key
            myAttrValue = value
        end
        local attrString
        if myAttrValue < 1 and myAttrValue > 0 then
            attrString = string.format("+ %d%%",myAttrValue * 100)
        elseif myAttrValue >= 1 then
            attrString = string.format("+ %d",myAttrValue)
        elseif myAttrValue <= 0 and myAttrValue >= -1 then
            attrString = string.format("- %d%%",0 - myAttrValue * 100)
        elseif myAttrValue < -1 then
            attrString = string.format("- %d",0 - myAttrValue * 100)
        end
        nowAttrSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("%s_icon.png",(myType == "mp") and "int" or myType)))
        -- nowAttrSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(equipdata:getDisplayFrameByType(myType)))

        local nowAttrValueLabel = BreakSkillResultOwner["nowAttrValueLabel"]
        nowAttrValueLabel:setString(attrString)

        local nextLevelLabel = tolua.cast(BreakSkillResultOwner["nextLevelLabel"],"CCLabelTTF")
        nextLevelLabel:setString(string.format("LV:%s",_skillDic.level))

        local nextAttrSprite = tolua.cast(BreakSkillResultOwner["nextAttrSprite"],"CCSprite")
        for key,value in pairs(skilldata:getSkillAttrByLevelAndUID( _skillDic.level,_skillDic.id)) do
            myType = key
        end
        nextAttrSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("%s_icon.png",(myType == "mp") and "int" or myType)))

        local nextAttrValueLabel = BreakSkillResultOwner["nextAttrValueLabel"]
        nextAttrValueLabel:setString(skilldata:getSkillAttrValueByUid( _skillDic.id ))
    else
        resultSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tuposhibai_text.png"))

        local nowLevelLabel = tolua.cast(BreakSkillResultOwner["nowLevelLabel"],"CCLabelTTF")
        nowLevelLabel:setString(string.format("LV:%s",_skillDic.level))

        local nowAttrSprite = tolua.cast(BreakSkillResultOwner["nowAttrSprite"],"CCSprite")
        for key,value in pairs(skilldata:getSkillAttrByLevelAndUID( _skillDic.level,_skillDic.id)) do
            myType = key
            myAttrValue = value
        end
        nowAttrSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("%s_icon.png",(myType == "mp") and "int" or myType)))

        local nowAttrValueLabel = BreakSkillResultOwner["nowAttrValueLabel"]
        nowAttrValueLabel:setString(skilldata:getSkillAttrValueByUid( _skillDic.id ))

        local nextLevelLabel = tolua.cast(BreakSkillResultOwner["nextLevelLabel"],"CCLabelTTF")
        nextLevelLabel:setString(string.format("LV:%s",_skillDic.level))

        local nextAttrSprite = tolua.cast(BreakSkillResultOwner["nextAttrSprite"],"CCSprite")
        for key,value in pairs(skilldata:getSkillAttrByLevelAndUID( _skillDic.level,_skillDic.id)) do
            myType = key
            myAttrValue = value
        end
        nextAttrSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("%s_icon.png",(myType == "mp") and "int" or myType)))

        local nextAttrValueLabel = BreakSkillResultOwner["nextAttrValueLabel"]
        nextAttrValueLabel:setString(skilldata:getSkillAttrValueByUid( _skillDic.id ))
    end

end


-- 该方法名字每个文件不要重复
function getSkillBreakResultLayer()
	return _layer
end

function createSkillBreakResultLayer( dic,gotoType )
    _currentDic = dic
    _skillDic = skilldata:getOneSkillByUniqueID( dic.id )
    _gotoType = gotoType
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
        _skillDic = nil
        _gotoType = nil
        _currentDic = nil
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