local _layer = nil
local t

LoginServerOwner = LoginServerOwner or {}
ccb["LoginServerOwner"] = LoginServerOwner

-- 最近登陆行数
local function lastLoginCellCount()
    return table.getTableCount(userdata.serverCodes) % 2 == 0 and math.floor(table.getTableCount(userdata.serverCodes) / 2) 
        or math.floor(table.getTableCount(userdata.serverCodes) / 2) + 1
end

-- 服务器行数
local function serverCellCount()
    return #userdata.serverListArr % 2 == 0 and math.floor(#userdata.serverListArr / 2) or math.floor(#userdata.serverListArr / 2) + 1
end

local function serverClick(tag)
    local server
    if tag >= 10000 then
        server = userdata.serverList[userdata.serverCodes[tostring(tag - 10000)]]
    else
        server = userdata.serverListArr[tag].v
    end
    userdata.selectServer = server
    userdata.serverCode = server.id
    getLoginLayer():showMain()
    getLoginMainLayer():menuEnabled(true)
end

local function setServerIcon( sprite,status )
    local frameName
    if status == 1 then
        frameName = "server_hot_icon.png"
    elseif status == 2 then
        frameName = "server_new_icon.png"
    elseif status == 3 then
        frameName = "server_full_icon.png"
    elseif status == 4 then
        frameName = "server_maintain_icon.png"
    elseif status == 5 then
        frameName = "server_recom_icon.png"
    end
    sprite = tolua.cast(sprite,"CCSprite")
    sprite:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName))
end

local function addServerTable()
    local serverLayer = tolua.cast(LoginServerOwner["serverLayer"], "CCLayer")
    -- @param fn string Callback type
    -- @param table LuaTableView
    -- @param a1 & a2 mixed Difference means for every "fn"
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(serverLayer:getContentSize().width, 66)
        elseif fn == "cellAtIndex" then
            -- Return CCTableViewCell, a1 is cell index (zero based), a2 is dequeued cell (maybe nil)
            -- Do something to create cell and change the content
            
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            local offset = 0
            if userdata.serverCodes then
                offset = lastLoginCellCount() + 1
                if a1 == 0 then
                    local sp = CCSprite:createWithSpriteFrameName("lanchangtiao.png")
                    sp:setPosition(serverLayer:getContentSize().width / 2, 33)
                    a2:addChild(sp)
                    local text = CCSprite:createWithSpriteFrameName("zuijindenglu_text.png")
                    text:setPosition(serverLayer:getContentSize().width / 2, 33)
                    a2:addChild(text)
                elseif a1 <= lastLoginCellCount() then
                    local menu = CCMenu:create()
                    for i=0,1 do
                        local index = (a1 - 1) * 2 + i
                        local server = userdata.serverList[userdata.serverCodes[tostring(index)]]
                        if server then
                            local label = CCLabelTTF:create(server.serverName, "ccbResources/FZCuYuan-M03S.ttf", 30)
                            label:setColor(ccc3(184,45,18))
                            label:enableShadow(CCSizeMake(2,-2), 1, 0)
                            label:setHorizontalAlignment(kCCTextAlignmentLeft)
                            local hotSpr = CCSprite:createWithSpriteFrameName("server_hot_icon.png")
                            setServerIcon(hotSpr,server.status)

                            local norSp = CCSprite:createWithSpriteFrameName("server_btn_0.png")
                            local selSp = CCSprite:createWithSpriteFrameName("server_btn_1.png")
                            local item = CCMenuItemSprite:create(norSp, selSp)
                            item:addChild(label)
                            label:setAnchorPoint(ccp(0, 0.5))
                            label:setPosition(item:getContentSize().width * 0.29, item:getContentSize().height / 2)
                            item:setPosition(serverLayer:getContentSize().width / 4 * (i * 2 + 1), 30)
                            item:registerScriptTapHandler(serverClick)
                            menu:addChild(item, 0, index + 10000)
                            hotSpr:setPosition(hotSpr:getContentSize().width, item:getContentSize().height / 3 * 2)
                            item:addChild(hotSpr)
                        end
                    end
                    menu:setAnchorPoint(ccp(0, 0))
                    menu:setPosition(ccp(0, 0))
                    a2:addChild(menu)
                end
            end
            if a1 == offset then
                local sp = CCSprite:createWithSpriteFrameName("lanchangtiao.png")
                sp:setPosition(serverLayer:getContentSize().width / 2, 33)
                a2:addChild(sp)
                local text = CCSprite:createWithSpriteFrameName("suoyoufuwuqi_text.png")
                text:setPosition(serverLayer:getContentSize().width / 2, 33)
                a2:addChild(text)
            elseif a1 > offset and a1 <= offset + serverCellCount() then
                local menu = CCMenu:create()
                menu:setContentSize(CCSizeMake(serverLayer:getContentSize().width, 66))
                for i=1,2 do
                    local index = (a1 - offset - 1) * 2 + i
                    if userdata.serverListArr[index] then
                        local server = userdata.serverListArr[index].v
                        if server then
                            local label = CCLabelTTF:create(server.serverName, "ccbResources/FZCuYuan-M03S.ttf", 25)
                            label:setColor(ccc3(55,34,2))
                            label:enableShadow(CCSizeMake(2,-2), 1, 0)
                            label:setHorizontalAlignment(kCCTextAlignmentLeft)
                            local hotSpr = CCSprite:createWithSpriteFrameName("server_new_icon.png")
                            setServerIcon(hotSpr,server.status)

                            local norSp = CCSprite:createWithSpriteFrameName("server_btn_0.png")
                            local selSp = CCSprite:createWithSpriteFrameName("server_btn_1.png")
                            local item = CCMenuItemSprite:create(norSp, selSp)
                            item:addChild(label)
                            label:setAnchorPoint(ccp(0, 0.5))
                            label:setPosition(item:getContentSize().width * 0.29, item:getContentSize().height / 2)
                            item:setPosition(serverLayer:getContentSize().width / 4 * (i * 2 - 1), 30)
                            item:registerScriptTapHandler(serverClick)
                            menu:addChild(item, 0, index)
                            hotSpr:setPosition(hotSpr:getContentSize().width, item:getContentSize().height / 3 * 2)-- hotSpr:getContentSize().height / 2)
                            
                            item:addChild(hotSpr)
                        end
                    end
                end
                menu:setAnchorPoint(ccp(0, 0))
                menu:setPosition(ccp(0, 0))
                a2:addChild(menu)
            end
            r = a2
        elseif fn == "numberOfCells" then
            -- Return number of cells
            r = 0
            if userdata.serverCodes then
                r = lastLoginCellCount() + 1
            end 
            r = r + serverCellCount() + 1
        -- Cell events:
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
        elseif fn == "cellTouchBegan" then      -- A cell is touching, a1 is cell, a2 is CCTouch
        elseif fn == "cellTouchEnded" then      -- A cell was touched, a1 is cell, a2 is CCTouch
        elseif fn == "cellHighlight" then       -- A cell is highlighting, coco2d-x 2.1.3 or above
        elseif fn == "cellUnhighlight" then     -- A cell had been unhighlighted, coco2d-x 2.1.3 or above
        elseif fn == "cellWillRecycle" then     -- A cell will be recycled, coco2d-x 2.1.3 or above
        end
        return r
    end)
    
    local size = CCSizeMake(serverLayer:getContentSize().width, serverLayer:getContentSize().height * 0.98)
    t = LuaTableView:createWithHandler(h, size)
    t:setBounceable(true)
    t:setAnchorPoint(ccp(0,0))
    t:setPosition(ccp(0,0))
    t:setVerticalFillOrder(0)
    serverLayer:addChild(t)
    t:reloadData()
end



local function init()
    local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
    cache:addSpriteFramesWithFile("ccbResources/login.plist")
    cache:addSpriteFramesWithFile("ccbResources/fontPic.plist")

    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/LoginServerView.ccbi",proxy,true,"LoginServerOwner")
    _layer = tolua.cast(node,"CCLayer")    

    local serverLayer = tolua.cast(LoginServerOwner["serverLayer"], "CCLayer")
    local grayBg = CCScale9Sprite:create("ccbResources/grayBg.png")
    grayBg:setContentSize(CCSizeMake(serverLayer:getContentSize().width * 0.98, serverLayer:getContentSize().height * 0.98))
    grayBg:setAnchorPoint(ccp(0.5, 0.5))
    grayBg:setPosition(ccp(serverLayer:getContentSize().width/2, serverLayer:getContentSize().height/2))
    serverLayer:addChild(grayBg, -1)
    addServerTable()

    local logo = tolua.cast(LoginServerOwner["logo"], "CCSprite")
    if isPlatform(IOS_APPLE2_ZH) 
        or isPlatform(IOS_KY_ZH) 
        or isPlatform(IOS_ITOOLS) 
        or isPlatform(IOS_PPZS_ZH) 
        or isPlatform(ANDROID_AGAME_ZH) 
        or isPlatform(IOS_91_ZH) 
        or isPlatform(ANDROID_91_ZH) 
        or isPlatform(ANDROID_360_ZH)
        or isPlatform(IOS_TBT_ZH)
        or isPlatform(ANDROID_COOLPAY_ZH)
        or isPlatform(ANDROID_GIONEE_ZH)
        or isPlatform(ANDROID_HTC_ZH) then

        if isSpringFestival then
            CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/springLogo.plist")
            logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("springLogo.png"))         
        else
            CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/tiantianLogo.plist")
            logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tiantianLogo.png"))
        end

    elseif isPlatform(ANDROID_BAIDU_ZH) 
        or isPlatform(ANDROID_BAIDUIAPPPAY_ZH) 
        or isPlatform(ANDROID_MM_ZH) 
        or isPlatform(ANDROID_XIAOMI_ZH) 
        or isPlatform(ANDROID_OPPO_ZH) 
        or isPlatform(ANDROID_UC_ZH) then

        if isSpringFestival then
            CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/springLogo.plist")
            logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("springLogo.png"))         
        else
            CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/daLogo.plist")
            logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("daLogo.png"))
        end

    elseif isPlatform(ANDROID_JAGUAR_TC) then
        --todo
        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/lbLogo.plist")
        --local logo = tolua.cast(LoginLoginOwner["logo"], "CCSprite")
        logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("lbLogo.png")) 
        
    elseif isPlatform(ANDROID_GV_MFACE_ZH) 
        or isPlatform(ANDROID_GV_MFACE_EN) 
        or isPlatform(ANDROID_GV_MFACE_EN_OUMEI)
        or isPlatform(ANDROID_GV_MFACE_EN_OUMEINEW)
        or isPlatform(IOS_GAMEVIEW_EN)
        or isPlatform(IOS_GVEN_BREAK) 
        or isPlatform(IOS_GAMEVIEW_ZH) then

        if isSpringFestival and (isPlatform(ANDROID_GV_MFACE_EN) or isPlatform(ANDROID_GV_MFACE_EN_OUMEI) or isPlatform(ANDROID_GV_MFACE_EN_OUMEINEW) or isPlatform(IOS_GAMEVIEW_EN) or isPlatform(IOS_GVEN_BREAK)) then
            CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/springLogo.plist")
            logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("gvSpringLogo.png"))         
        else
            CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/mfaceLogo.plist")
            logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("mfaceLogo.png"))
        end

    elseif isPlatform(IOS_MOBNAPPLE_EN) or isPlatform(ANDROID_VIETNAM_EN)
    or isPlatform(ANDROID_VIETNAM_EN_ALL) then
        if isSpringFestival then
            CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/springLogo.plist")
            logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("pfSpringLogo.png"))         
        else
            -- CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/login.plist")
            logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("logo_1.png"))
        end

    elseif isPlatform(ANDROID_GV_XJP_ZH)
        or isPlatform(ANDROID_GV_MFACE_TC)
        or isPlatform(IOS_GAMEVIEW_TC)
        or isPlatform(ANDROID_GV_MFACE_TC_GP) then

        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/mfaceLogo2.plist")
        logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("mfaceLogo2.png"))

    elseif isPlatform(IOS_IIAPPLE_ZH) or isPlatform(IOS_KYPARK_ZH) or isPlatform(ANDROID_KY_ZH) or isPlatform(IOS_ITOOLSPARK)
        or isPlatform(IOS_PPZSPARK_ZH) or isPlatform(IOS_TBTPARK_ZH) or isPlatform(IOS_HAIMA_ZH) or isPlatform(IOS_AISIPARK_ZH) or isPlatform(IOS_XYZS_ZH)
        or isPlatform(ANDROID_XYZS_ZH) or isPlatform(IOS_DOWNJOYPARK_ZH) or isPlatform(ANDROID_DOWNJOY_ZH) then

        if isSpringFestival then
            CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/springLogo.plist")
            logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("springLogo.png"))         
        else
            CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/iappleLogo.plist")
            logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("iapple_logo.png"))
        end
    elseif isPlatform(IOS_TGAME_TC) or isPlatform(ANDROID_TGAME_TC) then
        if isSpringFestival then
            CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/springLogo.plist")
            logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("springLogo.png"))         
        else
            CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/tgTcLogo.plist")
            logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tgTcLogo.png"))
        end
    elseif isPlatform(IOS_TGAME_TH) or isPlatform(ANDROID_TGAME_THAI) then
        if isSpringFestival then
            CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/springLogo.plist")
            logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("springLogo.png"))         
        else
            CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/tgthaiLogo.plist")
            logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tgthaiLogo.png"))
        end
    else
        if isSpringFestival then
            CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/springLogo.plist")
            logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("springLogo.png"))         
        end
    end
end


function createLoginServerLayer()
    init()
    local function _onEnter()
    end

    local function _onExit()
        print("onExit")
        _layer = nil
        t = nil
    end

    --onEnter onExit
    local function layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end
    -- addTestTable()
    _layer:registerScriptHandler(layerEventHandler)

    return _layer
end
