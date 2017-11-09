local _layer
local _titleId
local _uiType
local _priority


-- 名字不要重复
TitleInfoOwner = TitleInfoOwner or {}
ccb["TitleInfoOwner"] = TitleInfoOwner

TitleInfoCellOwner = TitleInfoCellOwner or {}
ccb["TitleInfoCellOwner"] = TitleInfoCellOwner

local function closeItemClick()
    popUpCloseAction( TitleInfoOwner,"infoBg",_layer )
end
TitleInfoOwner["closeItemClick"] = closeItemClick
TitleInfoCellOwner["closeItemClick"] = closeItemClick

local function allTitleTaped()
    if _uiType == 0 then
        CCDirector:sharedDirector():getRunningScene():addChild(createAllTitleInfoLayer(-142),130)
    elseif _uiType == 1 then
        popUpCloseAction( TitleInfoOwner,"infoBg",_layer )
    end
end
TitleInfoCellOwner["allTitleTaped"] = allTitleTaped

-- 刷新UI数据
local function _refreshData()
    local dic = titleData:getOneTitleByTitleId( _titleId )
    if dic == nil then 
        return
    end
    local nameLabel = tolua.cast(TitleInfoCellOwner["nameLabel"],"CCLabelTTF")
    nameLabel:setString(dic["conf"]["name"])

    
    local ownerState = tolua.cast(TitleInfoCellOwner["ownerState"],"CCLabelTTF")
    if dic["title"]["obtainFlag"]  == 2 then
        if dic.title.obtainTime == -1 then
            ownerState:setString(HLNSLocalizedString("title.notget"))
        else
            ownerState:setString(HLNSLocalizedString("title.passtime"))
        end
    else
        ownerState:setString(HLNSLocalizedString("title.alreadyget"))
    end

    local level = tolua.cast(TitleInfoCellOwner["level"], "CCLabelTTF")
    local levelBG = tolua.cast(TitleInfoCellOwner["levelBG"],"CCSprite")
    if dic["title"]["level"] > 0 then
        level:setString(HLNSLocalizedString("titleInfo.levelTitle")..dic["title"]["level"])
        levelBG:setVisible(true)
    else
        level:setVisible(false)
        levelBG:setVisible(false)
    end

    local attr = tolua.cast(TitleInfoCellOwner["attr"], "CCLabelTTF")
    if dic.conf.baseValue < 1 then
        if dic.title.level == 0 then
            attr:setString("+ "..(dic.conf.baseValue * 100).."%")
        else
            attr:setString("+ "..((dic.conf.baseValue + (dic.title.level - 1) * dic.conf.updateValue) * 100).."%")
        end
        
    else
        if dic.title.level == 0 then
            attr:setString("+ "..dic.conf.baseValue)
        else
            attr:setString("+ "..dic.conf.baseValue + (dic.title.level - 1) * dic.conf.updateValue)
        end
    end

    
    local haoxiangni = tolua.cast(TitleInfoCellOwner["haoxiangni"], "CCSprite")
    if haoxiangni then
        local texture = CCTextureCache:sharedTextureCache():addImage(equipdata:getEquipIconByEquipId( dic["title"].titleId ))
        if texture then
            haoxiangni:setVisible(true)
            haoxiangni:setTexture(texture)
        end  
    end

    local label1 = tolua.cast(TitleInfoCellOwner["label1"], "CCLabelTTF")
    local label2 = tolua.cast(TitleInfoCellOwner["label2"], "CCLabelTTF")
    local label3 = tolua.cast(TitleInfoCellOwner["label3"], "CCLabelTTF")
    local label4 = tolua.cast(TitleInfoCellOwner["label4"], "CCLabelTTF")
    local label5 = tolua.cast(TitleInfoCellOwner["label5"], "CCLabelTTF")
    local label6 = tolua.cast(TitleInfoCellOwner["label6"], "CCLabelTTF")
    local label7 = tolua.cast(TitleInfoCellOwner["label7"], "CCLabelTTF")
    local label8 = tolua.cast(TitleInfoCellOwner["label8"], "CCLabelTTF")
    local attrSprite = tolua.cast(TitleInfoCellOwner["attrSprite"], "CCSprite")
    -- print(""dic["conf"]["levelmax"])

    if dic["conf"]["ifUpdate"] == 1 then
        -- 可以升级
        if dic.title.level < dic["conf"]["levelmax"] then
        -- if dic["conf"]["levelmax"] < dic.title.level + 1 then
            label1:setVisible(true)
            label1:setString(HLNSLocalizedString("title.timeline"))
            label2:setVisible(true)
            if dic.conf.expire == 24 then
                label2:setString(DateUtil:formatTime(dic.title.obtainTime))
            else
                label2:setString(HLNSLocalizedString("title.longtime"))
            end
            label3:setVisible(true)
            label3:setString(HLNSLocalizedString("title.updateCondition"))
            label4:setVisible(true)
            label4:setString(dic.title.desc)
            attrSprite:setVisible(false)
            label5:setVisible(true)
            label5:setString(HLNSLocalizedString("title.updateqi"))
            label6:setVisible(true)
            if dic.conf.baseValue < 1 then
                label6:setString("+ "..((dic.conf.baseValue + dic.title.level * dic.conf.updateValue) * 100).."%")
            else
                label6:setString("+ "..(dic.conf.baseValue + dic.title.level * dic.conf.updateValue))
            end
            if dic["conf"]["illus"] then
                label7:setVisible(true)
                label7:setString(HLNSLocalizedString("title.insturction"))
                label8:setVisible(true)
                label8:setString(dic.conf.illus)
            else
                label7:setVisible(false)
                label8:setVisible(false)
            end
        else
            label1:setVisible(true)
            label1:setString(HLNSLocalizedString("title.timeline"))
            label2:setVisible(true)
            if dic.conf.expire == 24 then
                label2:setString(DateUtil:formatTime(dic.title.obtainTime))
            else
                label2:setString(HLNSLocalizedString("title.longtime"))
            end
            label3:setVisible(true)
            label3:setString(HLNSLocalizedString("title.getcondition"))
            label4:setVisible(true)
            label4:setString(dic.title.desc)
        end
    elseif dic["conf"]["ifUpdate"] == 2 then
        -- 不可升级
        label1:setVisible(true)
        label1:setString(HLNSLocalizedString("title.getTime"))
        label2:setVisible(true)
        if dic.conf.expire == 24 then
            label2:setString(DateUtil:formatTime(dic.title.obtainTime))
        else
            label2:setString(HLNSLocalizedString("title.longtime"))
        end
        label3:setVisible(true)
        label3:setString(HLNSLocalizedString("title.getcondition2"))
        label4:setVisible(true)
        label4:setString(dic.conf.desc)
        
        if dic["conf"]["illus"] then
            label7:setVisible(true)
            label7:setString(HLNSLocalizedString("title.insturction"))
            label8:setVisible(true)
            label8:setString(dic.conf.illus)
        else
            label7:setVisible(false)
            label8:setVisible(false)
        end
    end
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer

    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/TitleInfoView.ccbi",proxy, true,"TitleInfoOwner")

    _layer = tolua.cast(node,"CCLayer")
    
    _refreshData()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(TitleInfoOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction( TitleInfoOwner,"infoBg",_layer )
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
    local sv = tolua.cast(TitleInfoOwner["sv"], "CCScrollView") 
    sv:setTouchPriority(_priority - 2)
    local menu1 = tolua.cast(TitleInfoOwner["myCloseMenu"], "CCMenu")
    menu1:setHandlerPriority(_priority - 1)
    local menu2 = tolua.cast(TitleInfoCellOwner["menu"], "CCMenu")
    menu2:setHandlerPriority(_priority - 1)
end

-- 该方法名字每个文件不要重复
function getTitleInfoLayer()
	return _layer
end
-- uitype 0:点击全部称号只消失 1：添加全部称号层
function createTitleInfoLayer( titleId, uiType, priority)
    _titleId = titleId
    _uiType = uiType
    _priority = (priority ~= nil) and priority or -132
    _init()

    local function _onEnter()
        print("onEnter")
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.1), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        popUpUiAction( TitleInfoOwner,"infoBg" )
    end

    local function _onExit()
        print("WOQUonExit")
        _layer = nil
        _titleId = nil
        _priority = -132
        _uiType = nil
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end


    _layer:registerScriptTouchHandler(onTouch ,false ,_priority ,true )
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end