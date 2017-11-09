local _layer
local _skillId
local _priority = -132

-- 名字不要重复
SkillHandBookDetailOwner = SkillHandBookDetailOwner or {}
ccb["SkillHandBookDetailOwner"] = SkillHandBookDetailOwner


SkillHandBookDetailCellOwner = SkillHandBookDetailCellOwner or {}
ccb["SkillHandBookDetailCellOwner"] = SkillHandBookDetailCellOwner

local function closeItemClick()
    popUpCloseAction( SkillHandBookDetailOwner,"infoBg",_layer )
end
SkillHandBookDetailOwner["closeItemClick"] = closeItemClick
SkillHandBookDetailCellOwner["closeItemClick"] = closeItemClick

local function _updateLabelString(labelStr, string)
    local label = tolua.cast(SkillHandBookDetailCellOwner[labelStr], "CCLabelTTF")
    label:setString(string)
    label:setVisible(true)
end
local function breakSkillTaped( tag,sender )
    Global:instance():TDGAonEventAndEventData("share3")
    if isPlatform(IOS_VIETNAM_VI) 
        or isPlatform(IOS_VIETNAM_EN) 
        or isPlatform(IOS_VIETNAM_ENSAGA)
        or isPlatform(IOS_MOBNAPPLE_EN)
        or isPlatform(IOS_MOB_THAI)
        or isPlatform(ANDROID_VIETNAM_VI)
        or isPlatform(ANDROID_VIETNAM_EN)
        or isPlatform(ANDROID_VIETNAM_MOB_THAI)
        or isPlatform(ANDROID_VIETNAM_EN_ALL)
        or isPlatform(IOS_MOBGAME_SPAIN)
        or isPlatform(ANDROID_MOBGAME_SPAIN)  then
        local params = {
            ["link"] = "https://itunes.apple.com/cn/app/zhong-shen-wu-shuang/id579212649",
            ["name"] = "Hải Tặc",
            ["caption"] = "Hải Tặc",
            ["description"] = string.format(ConfigureStorage.Share[6]["content"], dic.name, dic.intro1),
            ["picture"] = "http://www.friendsmash.com/images/logo_large.jpg",
        }
        executeFBShare(params, "fbShareSuccCallback", "fbShareUnsuccCallback")
        return
    end
    if getMainLayer() ~= nil then
        local dic = skilldata:getSkillConfig(_skillId)
        --6是分享奥义
        local shareInfo = {pic = fileUtil:fullPathForFilename(wareHouseData:getItemResource(_skillId).icon), 
            text = string.format(ConfigureStorage.Share[6]["content"], dic.name, dic.intro1), size = 1}
        local sharelayer = createShareLayer(shareInfo, -137)
        getMainLayer():addChild(sharelayer)

        sharelayer:setZOrder(_layer:getZOrder()+1)
    end
    if _layer then
        _layer:removeFromParentAndCleanup(true)
    end
end
SkillHandBookDetailCellOwner["breakSkillTaped"] = breakSkillTaped

local function refreshData()
    local dic = skilldata:getSkillConfig(_skillId)
    _updateLabelString("nameLabel", dic.name)
    _updateLabelString("despLabel", dic.intro1)

    local itemBg = tolua.cast(SkillHandBookDetailCellOwner["itemBg"], "CCSprite")
    itemBg:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("itemInfoBg_2_%d.png", dic.rank)))

    local rankSprite = tolua.cast(SkillHandBookDetailCellOwner["rankSprite"], "CCSprite")
    rankSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("rank_%d_icon.png",dic.rank)))

    local attrSprite = tolua.cast(SkillHandBookDetailCellOwner["attrSprite"],"CCSprite")
    local myType
    local myAttrValue
    for key,value in pairs(dic.attr) do
        myType = key
        myAttrValue = value
    end

    attrSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("%s_icon.png",(myType == "mp") and "int" or myType)))
    local attrLabel = tolua.cast(SkillHandBookDetailCellOwner["attrLabel"],"CCLabelTTF")
    if myAttrValue < 1 and myAttrValue > 0 then
        attrLabel:setString(string.format("+ %d%%",myAttrValue * 100))
    elseif myAttrValue >= 1 then
        attrLabel:setString(string.format("+ %d",myAttrValue))
    elseif myAttrValue <= 0 and myAttrValue >= -1 then
        attrLabel:setString(string.format("- %d%%",0 - myAttrValue * 100))
    elseif myAttrValue < -1 then
        attrLabel:setString(string.format("- %d",0 - myAttrValue * 100))
    end

    local addLabel = tolua.cast(SkillHandBookDetailCellOwner["addLabel"],"CCLabelTTF")
    
    local attString
    
    if myAttrValue < 1 and myAttrValue > 0 then
        attString = myAttrValue * 100
    elseif myAttrValue >= 1 then
        attString = myAttrValue
    elseif myAttrValue <= 0 and myAttrValue >= -1 then
        attString = 0 - myAttrValue * 100
    elseif myAttrValue < -1 then
        attString = 0 - myAttrValue
    end
    addLabel:setString(string.format(dic.intro2,attString))
    local avatarSprite = tolua.cast(SkillHandBookDetailCellOwner["avatarSprite"],"CCSprite")

    local res = wareHouseData:getItemResource(_skillId)
    if res.icon then
        local texture = CCTextureCache:sharedTextureCache():addImage(res.icon)
        if texture then
            avatarSprite:setVisible(true)
            avatarSprite:setTexture(texture)
        end
    end   
    local priceLabel = tolua.cast(SkillHandBookDetailCellOwner["priceLabel"],"CCLabelTTF")
    priceLabel:setString(skilldata:getSkillPriceConfig(_skillId))

    if not isOpenShare(  ) then
        local shareBtn = tolua.cast(SkillHandBookDetailCellOwner["qianghuaItem"], "CCMenuItemImage")
        local sharefont = tolua.cast(SkillHandBookDetailCellOwner["fengxiangItemSprite"], "CCSprite")
        shareBtn:setVisible(false)
        sharefont:setVisible(false)
    end
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/SkillHandBookDetailInfoView.ccbi", proxy, true,"SkillHandBookDetailOwner")
    _layer = tolua.cast(node,"CCLayer")
    refreshData()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(SkillHandBookDetailOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction( SkillHandBookDetailOwner,"infoBg",_layer )
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
    local sv = tolua.cast(SkillHandBookDetailOwner["sv"], "CCScrollView") 
    sv:setTouchPriority(_priority-2)
    local menu1 = tolua.cast(SkillHandBookDetailOwner["menu"], "CCMenu")
    menu1:setHandlerPriority(_priority-1)
    local menu2 = tolua.cast(SkillHandBookDetailCellOwner["menu"], "CCMenu")
    menu2:setHandlerPriority(_priority-1)
end

-- 该方法名字每个文件不要重复
function getHandBookSkillDetailLayer()
	return _layer
end

function createHandBookSkillDetailLayer(skillId,priority)
    _skillId = skillId
    _priority = (priority ~= nil) and priority or -132
    _init()

    local function _onEnter()
        print("onEnter")
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        popUpUiAction( SkillHandBookDetailOwner,"infoBg" )
    end

    local function _onExit()
        print("onExit")
        _layer = nil
        _priority = nil
        _skillId = nil
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