local _layer
local _data = nil
local avatarSpriteFrame

BluckSingViewOwner = BluckSingViewOwner or {}
ccb["BluckSingViewOwner"] = BluckSingViewOwner

local function onChoseClicked(  )
    if getMainLayer() then
        --获取S级英雄的数量
        local heroNumber = getMyTableCount(herodata:getHeroUIdArrByRank( 4 )) 
        if heroNumber> 0 then 
            getMainLayer():addChild(createSingHeroSelectLayer())
        else
            getMainLayer():addChild(createBluckToLuogeLayer(-135))
        end
    end
end

BluckSingViewOwner["onChoseClicked"] = onChoseClicked

local function onAvatarTaped(  )
    CCDirector:sharedDirector():getRunningScene():addChild(createItemDetailInfoLayer("item_011", -138, 1, 1), 100)
end 

BluckSingViewOwner["onAvatarTaped"] =onAvatarTaped

local function onChoseHuoBanAction(  )
    if getMainLayer() then
        getMainLayer():addChild(createSingHeroSelectLayer())
    end
end

BluckSingViewOwner["onChoseHuoBanAction"] = onChoseHuoBanAction


-- 刷新UI
local function _refreshUI()
    _data = dailyData:getBluckSingData()

    if _data == nil then
        return
    end 
    local choseFriendBtn = tolua.cast(BluckSingViewOwner["choseFriendBtn"],"CCMenuItemImage")
    local huanHuobanSprite = tolua.cast(BluckSingViewOwner["huanHuobanSprite"],"CCSprite")
    local avatarCellBg = tolua.cast(BluckSingViewOwner["avatarCellBg"],"CCSprite")
    local choseHuoBanBtn = tolua.cast(BluckSingViewOwner["choseHuoBanBtn"],"CCMenuItemImage")
    local singBtn = tolua.cast(BluckSingViewOwner["singBtn"],"CCMenuItemImage")
    local singSprite = tolua.cast(BluckSingViewOwner["singSprite"],"CCSprite")
    local yinBeiFrame = tolua.cast(BluckSingViewOwner["yinBeiFrame"],"CCSprite")
    local yinBeiFrame1 = tolua.cast(BluckSingViewOwner["yinBeiFrame1"],"CCMenuItemImage")
    -- vip*********
    local labelShowVip = tolua.cast(BluckSingViewOwner["vipfree"],"CCLabelTTF")
    labelShowVip:setVisible(not userdata:getVipAuditState())

    if not runtimeCache.singSelectHeroId then
        choseFriendBtn:setVisible(true)
        huanHuobanSprite:setVisible(true)
        yinBeiFrame:setVisible(false)
        yinBeiFrame1:setVisible(false)
        avatarCellBg:setVisible(false)
        
        choseHuoBanBtn:setVisible(false)
        
        singBtn:setVisible(false)
        
        singSprite:setVisible(false)
        local singCount = tolua.cast(BluckSingViewOwner["singCount"],"CCLabelTTF")
        singCount:setString(_data["wishNumbers"].."/"..(_data["freeTime"] + vipdata:getCanAddSingCount( userdata:getVipLevel())))
    else
        local hero = herodata:getHeroInfoByHeroUId( runtimeCache.singSelectHeroId ) 
        avatarCellBg:setVisible(true)
        
        choseHuoBanBtn:setVisible(true)
        
        singBtn:setVisible(true)
        
        singSprite:setVisible(true)

        choseFriendBtn:setVisible(false)
        huanHuobanSprite:setVisible(false)

        local avatarSprite = tolua.cast(BluckSingViewOwner["avatarSprite"],"CCSprite")
        local headSpr = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId(dailyData:getWishHeroIDbyId( hero.heroId )))
        if headSpr then
            avatarSpriteFrame = headSpr
            avatarSprite:setVisible(true)
            avatarSprite:setDisplayFrame(headSpr)
        end 

        local heroBust = tolua.cast(BluckSingViewOwner["heroBust"],"CCSprite")
        if heroBust then
            local texture = CCTextureCache:sharedTextureCache():addImage(herodata:getHeroBust1ByHeroId(hero.heroId))
            if texture then
                heroBust:setVisible(true)
                heroBust:setTexture(texture)
            end  
        end 

        local singCount = tolua.cast(BluckSingViewOwner["singCount"],"CCLabelTTF")
        singCount:setString(_data["wishNumbers"].."/"..(_data["freeTime"] + vipdata:getCanAddSingCount( userdata:getVipLevel())))

        if _data["wishNumbers"] >= _data["freeTime"] then
            yinBeiFrame:setVisible(true)
            yinBeiFrame1:setVisible(true)
            local yinbeiCount = tolua.cast(BluckSingViewOwner["yinbeiCount"],"CCLabelTTF")
            yinbeiCount:setString(wareHouseData:getItemCountById( "item_011" ))
        else
            yinBeiFrame:setVisible(false)
            yinBeiFrame1:setVisible(false)
        end
    end

    -- renzhan newAdd
    if _data["wishNumbers"] >= 1 then
        huanHuobanSprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("yinbeiduige_text.png"))
    end

end

local function makeWishCallBack( url,rtnData )

    if rtnData.code == 200 then
        runtimeCache.responseData = rtnData.info
        if rtnData.info.gain["heroes_soul"] then
            for k,v in pairs(rtnData.info.gain["heroes_soul"]) do

                local heroId = herodata:getHeroIdByUId( runtimeCache.singSelectHeroId )
                local heroHead = herodata:getHeroHeadByHeroId( heroId )
                local heroFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(heroHead)

                local heroConfig = herodata:getHeroConfig(heroId)

                SingOfRotate_LayerOwner = SingOfRotate_LayerOwner or {}
                ccb["SingOfRotate_LayerOwner"] = SingOfRotate_LayerOwner
                local function onRotatingStops()
                    if k == heroId then
                        SingOfRotate_LayerOwner["hero1"]:setDisplayFrame(heroFrame)
                        SingOfRotate_LayerOwner["hero1Shadow"]:setDisplayFrame(heroFrame)
                        SingOfRotate_LayerOwner["hero1Frame"]:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", heroConfig.rank)))
                        SingOfRotate_LayerOwner["hero1ShadowFrame"]:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", heroConfig.rank)))
                        SingOfRotate_LayerOwner["hero3"]:setDisplayFrame(avatarSpriteFrame)
                        SingOfRotate_LayerOwner["hero3Shadow"]:setDisplayFrame(avatarSpriteFrame)
                        SingOfRotate_LayerOwner["hero3Frame"]:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", heroConfig.rank)))
                        SingOfRotate_LayerOwner["hero3ShadowFrame"]:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", heroConfig.rank)))
                    end
                end
                SingOfRotate_LayerOwner["onRotatingStops"] = onRotatingStops

                -- get layer
                local  proxy = CCBProxy:create()
                local  node  = CCBReaderLoad("ccbResources/SingOfRotate.ccbi",proxy,true,"SingOfRotate_LayerOwner")
                local bg = SingOfRotate_LayerOwner["blackBg"]
                getMainLayer():addChild(node)
                node:setPosition(0, 0)

                local function onTouchBegan(x, y)
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
                bg:registerScriptTouchHandler(onTouch ,false ,-145 ,true )
                bg:setTouchEnabled(true)

                SingOfRotate_LayerOwner["hero1"]:setDisplayFrame(avatarSpriteFrame)
                SingOfRotate_LayerOwner["hero1Shadow"]:setDisplayFrame(avatarSpriteFrame)
                SingOfRotate_LayerOwner["hero1Frame"]:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", heroConfig.rank)))
                SingOfRotate_LayerOwner["hero1ShadowFrame"]:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", heroConfig.rank)))
                
                for i = 2, 4 do
                    SingOfRotate_LayerOwner["hero"..i]:setDisplayFrame(heroFrame)
                    SingOfRotate_LayerOwner["hero"..i.."Shadow"]:setDisplayFrame(heroFrame)
                    SingOfRotate_LayerOwner["hero"..i.."Frame"]:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", heroConfig.rank)))
                    SingOfRotate_LayerOwner["hero"..i.."ShadowFrame"]:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", heroConfig.rank)))
                end

                local function showTableView(  )   
                    node:removeFromParentAndCleanup(true)
                    bg:removeFromParentAndCleanup(true)
            
                    -- userdata:popUpGain(runtimeCache.responseData["gain"], true)
                    if getMainLayer() then
                        getMainLayer():addChild(createSingSongSuccessLayer( k,v,-150 ))
                    end

                end 

                local action = CCArray:create()
                action:addObject(CCDelayTime:create(3))
                action:addObject(CCCallFunc:create(showTableView))
                local seq = CCSequence:create(action)
                bg:runAction(seq)
            end 
        end
        dailyData:updateBluckSingData( rtnData.info.wish.wishNumbers )
        postNotification(NOTI_DAILY_STATUS, nil)
        _refreshUI()
    end
end

-- renzhan newAdd
local function infoClick()
    getMainLayer():getParent():addChild(createBluckSingHelp()) 
end
BluckSingViewOwner["infoClick"] = infoClick

local function onSingBtnAction(  )
    -- if wareHouseData:getItemCountById( "item_011" ) <= 0 then
    --     if getMainLayer() then
    --         getMainLayer():addChild(createSingSongNotEnoughLayer( -135))
    --     end
    -- end
    print("音贝次数",_data["wishNumbers"],_data["freeTime"])
    if _data["wishNumbers"] >= (_data["freeTime"] + vipdata:getCanAddSingCount( userdata:getVipLevel())) then
        if getMainLayer() then
            getMainLayer():addChild(createSingSongNotEnoughLayer( -135))
        end
    elseif _data["wishNumbers"] >= _data["freeTime"] then
        if wareHouseData:getItemCountById( "item_011" ) > 0 then
            doActionFun("MAKE_WISH_URL",{ herodata:getHeroIdByUId( runtimeCache.singSelectHeroId ) },makeWishCallBack) 
        else
            local text 
            local function cardCancelAction(  )
                
            end

            if userdata.level >= 17 then
                text = HLNSLocalizedString("船长，您的音贝数量不足，前往【幸运卡牌】有机会获得哦，快去试试运气吧！")
                local function cardConfirmAction(  )
                    -- 前往幸运卡牌
                    if not getMainLayer() then
                        CCDirector:sharedDirector():replaceScene(mainSceneFun())
                    end
                    runtimeCache.dailyPageNum = Daily_Treasure
                    --getMainLayer():gotoDaily()
                    getDailyLayer():refreshDailyLayer()
                    -- getMainLayer():gotoDaily()
                    -- getDailyLayer():gotoDailyByName( Daily_Treasure )
                end
                getMainLayer():addChild(createSimpleConfirCardLayer(text), 100)
                SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
                SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction

            else
                text = HLNSLocalizedString("船长，您的音贝数量不足，【幸运卡牌】（17级开启）将有机会获得，快些升级吧！")
                local function cardConfirmAction(  )
                    -- 前往幸运卡牌
                    if userdata.level >= 17 then
                        if not getMainLayer() then
                            CCDirector:sharedDirector():replaceScene(mainSceneFun())
                        end

                        runtimeCache.dailyPageNum = Daily_Treasure
                        --getMainLayer():gotoDaily()
                        getDailyLayer():refreshDailyLayer()
                        -- getDailyLayer():gotoDailyByName( Daily_Treasure )
                    else
                        ShowText(HLNSLocalizedString("luckyCard.level.notEnough"))
                    end
                end
                getMainLayer():addChild(createSimpleConfirCardLayer(text), 100)
                SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
                SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
            end
            
        end
    else
        doActionFun("MAKE_WISH_URL",{ herodata:getHeroIdByUId( runtimeCache.singSelectHeroId ) },makeWishCallBack) 
    end
end

BluckSingViewOwner["onSingBtnAction"] = onSingBtnAction

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/DailyBluckSing.ccbi",proxy, true,"BluckSingViewOwner")
    _layer = tolua.cast(node,"CCLayer")

    
    _refreshUI()
end

-- 该方法名字每个文件不要重复
function getBluckSingLayer()
	return _layer
end

function createBluckSingLayer()
    _init()

    function _layer:refresh(  )
        _refreshUI()
    end

    local function _onEnter()
    end

    local function _onExit()
        _layer = nil
        _data = nil
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