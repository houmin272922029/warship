
instructGroupLayer = class("instructGroupLayer", function()
    local proxy = CCBProxy:create()
    local node  = CCBReaderLoad("ccbResources/InstructHeroGView.ccbi",proxy, true,"InstructGroupOwner")
    local layer = tolua.cast(node,"CCLayer")
    return layer
end)

instructGroupLayer.data = nil
instructGroupLayer.timer = nil

InstructGroupOwner = InstructGroupOwner or {}
ccb["InstructGroupOwner"] = InstructGroupOwner

function instructGroupLayer:updateCD()
    local cd = math.max(self.data.instructTime + self.data.instructDuration - userdata.loginTime, 0)
    local resultLayer = tolua.cast(self:getChildByTag(102), "CCLayer")
    local resultMenu = tolua.cast(resultLayer:getChildByTag(100), "CCMenu")
    local cdLayer = tolua.cast(self:getChildByTag(101), "CCLayer")
    if cd == 0 then
        resultLayer:setVisible(true)
        resultMenu:setVisible(true)
        cdLayer:setVisible(false)
    else
        cdLayer:setVisible(true)
        resultLayer:setVisible(false)
        resultMenu:setVisible(false)
        local cdLabel = tolua.cast(cdLayer:getChildByTag(100), "CCLabelTTF")
        cdLabel:setString(DateUtil:second2hms(cd))
    end
end

function instructGroupLayer:refresh()

    local function instructHeroCallback(url, rtnData)
        getMainLayer():getParent():addChild(createIntructResultLayer(rtnData.info.gain.instruct, self.data.heroId, -134), 200)
        dailyData:getGroupInstructSucc(self.data.id)
        getDailyLayer():refreshDailyLayer()
    end

    local function _instructHero(bDouble)
        doActionFun("INSTRUCT_HERO", {self.data.id, "", bDouble and 1 or 0}, instructHeroCallback)
    end

    local function awardItemClick()
        Global:instance():TDGAonEventAndEventData("scoop")
        _instructHero(false)
    end

    local function doubleItemClick()
        Global:instance():TDGAonEventAndEventData("scoop1")
        local hour = math.floor(self.data.instructDuration / 3600)
        local need = ConfigureStorage.doubleExpCost[tostring(hour)].item
        local count = wareHouseData:getItemCountById(ConfigureStorage.extraItem)
        if count < need then
            text = HLNSLocalizedString("instruct.need", need - count, wareHouseData:getItemConfig(ConfigureStorage.extraItem).name)
            local function cardConfirmAction()
               getMainLayer():goToLogue() 
               getLogueTownLayer():gotoPageByType(1)
            end
            local function cardCancelAction()
                
            end
            getMainLayer():addChild(createSimpleConfirCardLayer(text), 100)
            SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
            SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
        else
            _instructHero(true)
        end
    end

    local awardItem = tolua.cast(InstructGroupOwner["awardItem"], "CCMenuItem")
    awardItem:registerScriptTapHandler(awardItemClick)
    local doubleItem = tolua.cast(InstructGroupOwner["doubleItem"], "CCMenuItem")
    doubleItem:registerScriptTapHandler(doubleItemClick)
    local frame = tolua.cast(InstructGroupOwner["frame"], "CCSprite")
    local conf = herodata:getHeroConfig(self.data.heroId)
    frame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", conf.rank)))
    local head = tolua.cast(InstructGroupOwner["head"], "CCSprite")
    local f = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId(self.data.heroId))
    if f then
        head:setVisible(true)
        head:setDisplayFrame(f)
    end
    local cdTips = tolua.cast(InstructGroupOwner["cdTips"], "CCLabelTTF")
    cdTips:setString(string.format(cdTips:getString(), self.data.instructExp))
    local cdSayLabel = tolua.cast(InstructGroupOwner["cdSayLabel"], "CCLabelTTF")
    cdSayLabel:setString(ConfigureStorage.dianbo[self.data.heroId].desp1)
    local resultSayLabel = tolua.cast(InstructGroupOwner["resultSayLabel"], "CCLabelTTF")
    resultSayLabel:setString(ConfigureStorage.dianbo[self.data.heroId].desp2)
    local expLabel = tolua.cast(InstructGroupOwner["expLabel"], "CCLabelTTF")
    expLabel:setString(string.format(expLabel:getString(), self.data.instructExp))
    local itemLabel = tolua.cast(InstructGroupOwner["itemLabel"], "CCLabelTTF")
    local hour = math.floor(self.data.instructDuration / 3600)
    itemLabel:setString(string.format(itemLabel:getString(), ConfigureStorage.doubleExpCost[tostring(hour)].item, wareHouseData:getItemConfig(ConfigureStorage.extraItem).name))
end

function createInsturctGroupLayer(data)
    local _instructGroupLayer = instructGroupLayer.new()
    _instructGroupLayer.data = data
    _instructGroupLayer:refresh()


    local function _onEnter()
    end

    local function _onExit()
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end

    _instructGroupLayer:registerScriptHandler(_layerEventHandler)

    return _instructGroupLayer
end