local _layer
local _allDic
local currentLavel

-- ·名字不要重复
EquipUpdateLayerOwner = EquipUpdateLayerOwner or {}
ccb["EquipUpdateLayerOwner"] = EquipUpdateLayerOwner

local function updateContent(  )
    local lavelLabel = EquipUpdateLayerOwner["lavelLabel"]
    lavelLabel:setString(_allDic.level)

    local nowLevel = EquipUpdateLayerOwner["nowLevel"]
    nowLevel:setString("LV   ".._allDic.level)

    local nextLevel = EquipUpdateLayerOwner["nextLevel"]
    nextLevel:setString("LV   "..(_allDic.level + 1))

    local nameLabel = EquipUpdateLayerOwner["namelabel"]
    nameLabel:setString(_allDic.name)

    local developAttrIcon = EquipUpdateLayerOwner["developAttrIcon"]
    local nowAttrIcon = EquipUpdateLayerOwner["nowAttrIcon"]
    local nextAttrIcon = EquipUpdateLayerOwner["nextAttrIcon"]
    local attrSprite = EquipUpdateLayerOwner["attrSprite"]


    developAttrIcon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(equipdata:getDisplayFrameByType(equipdata:getEquipAttrType( _allDic.id ))))
    nowAttrIcon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(equipdata:getDisplayFrameByType(equipdata:getEquipAttrType( _allDic.id ))))
    nextAttrIcon:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(equipdata:getDisplayFrameByType(equipdata:getEquipAttrType( _allDic.id ))))
    attrSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(equipdata:getDisplayFrameByType(equipdata:getEquipAttrType( _allDic.id ))))

    local levelBg = EquipUpdateLayerOwner["levelSprite"]
    levelBg:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("level_bg_%s.png",_allDic.rank)))

    -- local attrValue = EquipUpdateLayerOwner["attLabel"]
    -- attrValue:setString(string.format("%s",equipdata:getEquipAttrValue(_allDic.id)))

    local initAttrLabel = EquipUpdateLayerOwner["initAttrLabel"]
    local nowAttrLabel = EquipUpdateLayerOwner["nowAttrLabel"]
    local nextAttrLabel = EquipUpdateLayerOwner["nextAttrLabel"]
    local developBaseAttr = EquipUpdateLayerOwner["developBaseAttr"]
    local developTopAttr = EquipUpdateLayerOwner["developTopAttr"]

    -- local nowAttrValue = equipdata:getEquipAttrValue(_allDic.id)
    initAttrLabel:setString(string.format("%s",_allDic.initial))
    nowAttrLabel:setString(equipdata:getOneEquipAttrByLevelAndStage( _allDic.equipId,_allDic["level"],_allDic.stage ))
    nextAttrLabel:setString(equipdata:getOneEquipAttrByLevelAndStage( _allDic.equipId,_allDic["level"] + 1,_allDic.stage ))
    developBaseAttr:setString(_allDic.updateEffect)
    if _allDic.refine then
        developTopAttr:setString("+ "..(_allDic.stage * _allDic.refine))
    else
        developTopAttr:setVisible(false)
    end
    
    local selverLabel = EquipUpdateLayerOwner["selverLabel"]
    selverLabel:setString(_allDic.updateSilver)
end

local function updateCallBack( url,rtnData )
    if rtnData["code"] == 200 then

        playEffect(MUSIC_SOUND_WEAPON_REFINE)

        local avatar = tolua.cast(EquipUpdateLayerOwner["avatarFrame"], "CCSprite")
        HLAddParticleScale( "images/eff_refineEquip_1.plist", avatar, ccp(avatar:getContentSize().width / 2,avatar:getContentSize().height * 0.5), 1, 1, 1,2,2)
        HLAddParticleScale( "images/eff_refineEquip_2.plist", avatar, ccp(avatar:getContentSize().width / 2,avatar:getContentSize().height * 0.5), 1, 1, 1,4,4)

        
        local dic
        local uniqueId
        for k,v in pairs(rtnData["info"]["equips"]) do
            uniqueId = k
            dic = v
        end
        equipdata:updateEquipByUniqueId( uniqueId,dic )
        _allDic = equipdata:getEquip(uniqueId)

        -- renzhan////////

        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/fontPic.plist")
        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("images/fightingNumber.plist")

        local pic2 = CCSprite:createWithSpriteFrameName("hit_+.png")
        local pic3 = CCSprite:createWithSpriteFrameName("hit_".._allDic.level - currentLavel..".png")

        EquipUpdateLayerOwner["avatarFrame"]:addChild(pic2,144)
        EquipUpdateLayerOwner["avatarFrame"]:addChild(pic3,144)
        pic2:setScale(0.01)
        pic3:setScale(0.01)

        local function textAction(sender)
            local function removeLabel()
                sender:removeFromParentAndCleanup(true)
            end

            local array = CCArray:create()
            array:addObject(CCScaleBy:create(0.1,100))
            array:addObject(CCScaleBy:create(0.1,0.8))
            array:addObject(CCDelayTime:create(0.25))
            array:addObject(CCFadeOut:create(0.1))
            array:addObject(CCCallFunc:create(removeLabel))
            local seq = CCSequence:create(array)
            sender:runAction(seq)
        end

        if (_allDic.level - currentLavel) >= 2 then

            local pic1 = CCSprite:createWithSpriteFrameName("equip_cri.png")      
            EquipUpdateLayerOwner["avatarFrame"]:addChild(pic1,144)
            
            pic1:setPosition(ccp(EquipUpdateLayerOwner["avatarFrame"]:getContentSize().width * 0.5 - 40,EquipUpdateLayerOwner["avatarFrame"]:getContentSize().height * 0.5))
            pic2:setPosition(ccp(EquipUpdateLayerOwner["avatarFrame"]:getContentSize().width * 0.5 + 30,EquipUpdateLayerOwner["avatarFrame"]:getContentSize().height * 0.5))
            pic3:setPosition(ccp(EquipUpdateLayerOwner["avatarFrame"]:getContentSize().width * 0.5 + 60,EquipUpdateLayerOwner["avatarFrame"]:getContentSize().height * 0.5))
            pic1:setScale(0.01)
            -- 暴击的时候颜色改成红色的
            pic1:setColor(ccc3(255,0,0))
            pic2:setColor(ccc3(255,0,0))
            pic3:setColor(ccc3(255,0,0))
            textAction(pic1)
            textAction(pic2)
            textAction(pic3)

        else
            pic2:setPosition(ccp(EquipUpdateLayerOwner["avatarFrame"]:getContentSize().width * 0.5 - 15,EquipUpdateLayerOwner["avatarFrame"]:getContentSize().height * 0.5))
            pic3:setPosition(ccp(EquipUpdateLayerOwner["avatarFrame"]:getContentSize().width * 0.5 + 15,EquipUpdateLayerOwner["avatarFrame"]:getContentSize().height * 0.5))
            -- toto
            -- 跳字，不是暴击也要跳字
            textAction(pic2)
            textAction(pic3)
        end

        -- /////////
        currentLavel = _allDic.level
        updateContent()
    end
end

local function exitBtnAction(  )
    if runtimeCache.equipFromeTeam == 0 then
        if getMainLayer() then
            getMainLayer():gotoEquipmentsLayer()
        end
    elseif runtimeCache.equipFromeTeam == 1 then
        if getMainLayer() then
            runtimeCache.equipFromeTeam = 0
            getMainLayer():gotoTeam()
        end
    end
end

local function updateEquipAction(  )
    if (_allDic.level >= 3 * userdata.level) then
        ShowText(HLNSLocalizedString("ERR_1601"))
        return
    end
    if _allDic.updateSilver > userdata.berry then
        ShowText(HLNSLocalizedString("ERR_1102"))
        return
    end
    Global:instance():TDGAonEventAndEventData("intensyfy1")
    doActionFun("UPDATE_EQUIP_URL",{_allDic.id},updateCallBack) 
end

EquipUpdateLayerOwner["exitBtnAction"] = exitBtnAction
EquipUpdateLayerOwner["updateEquipAction"] = updateEquipAction

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/EquipUpdateView.ccbi",proxy, true,"EquipUpdateLayerOwner")
    _layer = tolua.cast(node,"CCLayer")

    _allDic = equipdata:getEquip(_allDic.id)
    currentLavel = _allDic.level

    local avatarFrame = tolua.cast(EquipUpdateLayerOwner["avatarFrame"], "CCSprite") 
    avatarFrame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", _allDic.rank)))
    
    local equipIcon = tolua.cast(EquipUpdateLayerOwner["equipIcon"], "CCSprite") 
    if equipIcon then
        local texture = CCTextureCache:sharedTextureCache():addImage(equipdata:getEquipIconByEquipId( _allDic.icon ))
        if texture then
            equipIcon:setVisible(true)
            equipIcon:setTexture(texture)
            if _allDic.rank == 4 then
                HLAddParticleScale( "images/purpleEquip.plist", equipIcon, ccp(equipIcon:getContentSize().width / 2,equipIcon:getContentSize().height / 2), 1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1 )
            elseif _allDic.rank == 5 then
                HLAddParticleScale( "images/goldEquip.plist", equipIcon, ccp(equipIcon:getContentSize().width / 2,equipIcon:getContentSize().height / 2), 1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1 )    
            end
        end  
    end

    
    updateContent()
end


-- 该方法名字每个文件不要重复
function getEquipUpdateLayer()
	return _layer
end

function createEquipUpdateLayer( dic )
    _allDic = dic
    _init()

    -- 升级装备回调
    function _layer:updateCallBack( url,rtnData )
        updateCallBack(url, rtnData)
    end

	function _layer:refresh()
		
	end

    local function _onEnter()
        print("onEnter")
        -- 设置新手引导选择强化装备光圈
        if runtimeCache.bGuide and runtimeCache.guideStep + 1 == GUIDESTEP.updateEquip then
            local touchLayer = tolua.cast(GuideOwner["touch20"], "CCLayer")
            local ghLayer = tolua.cast(GuideOwner["ghLayer20"], "CCLayer")
            local updateBtn = tolua.cast(EquipUpdateLayerOwner["updateBtn"], "CCMenuItemImage")
            if touchLayer and ghLayer then
                touchLayer:setPosition(ccp(updateBtn:getPositionX(), updateBtn:getPositionY()))
                ghLayer:setPosition(ccp(updateBtn:getPositionX(), updateBtn:getPositionY()))
            end
        end
    end

    local function _onExit()
        print("onExit")
        _layer = nil
        _allDic = nil
        currentLavel = nil
        runtimeCache.equipFromeTeam = 0
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