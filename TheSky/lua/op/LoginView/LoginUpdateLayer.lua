-- 登陆sso账号 --

local _layer

local loadingResProgressBg
local loadingResProgressTmp
local loadingNote
local smallVersion

local UpdateFileList = {}
local localFile
local diffFile

local updateCountTmp = 0
local downCountTmp = 0
local errorFileList
local successCount
local btnLightSche
local updateSuccFlag = true
local upUrl = ""


-- 名字不要重复
LoginUpdateOwner = LoginUpdateOwner or {}
ccb["LoginUpdateOwner"] = LoginUpdateOwner

if opPCL == IOS_VIETNAM_VI or opPCL == ANDROID_VIETNAM_VI then
    UpTxt = {
        stmp1 = "Đang kiểm tra phiên bản...",
        stmp3 = "Đang tải dữ liệu %0.2f%%",
        stmp4 = "Đã tải xong, đang vào game...",
        stmp5 = "Tải một số file thất bại, bạn có muốn thử lại không?",
        stmp6 = "Cập nhật hoàn tất. Vui lòng khởi động lại game.",
    }
elseif opPCL == IOS_GAMEVIEW_EN or opPCL == IOS_GVEN_BREAK or opPCL == ANDROID_GV_MFACE_EN or opPCL == IOS_VIETNAM_EN or opPCL == IOS_MOBNAPPLE_EN 
        or opPCL == ANDROID_VIETNAM_EN or opPCL == ANDROID_VIETNAM_EN_ALL or opPCL == ANDROID_GV_MFACE_EN_OUMEI or opPCL == ANDROID_GV_MFACE_EN_OUMEINEW
        or opPCL == IOS_VIETNAM_ENSAGA then
    UpTxt = {
        stmp1 = "Loading, please wait……",
        stmp3 = "Downloading update %0.2f%%",
        stmp4 = "Update complete, loading……",
        stmp5 = "Download error, please retry？",
        stmp6 = "Update is completed, please restart your game.",
    }
elseif opPCL == IOS_GAMEVIEW_TC or opPCL == ANDROID_GV_MFACE_TC or opPCL == ANDROID_GV_MFACE_TC_GP  or opPCL == ANDROID_JAGUAR_TC
        or opPCL == IOS_JAGUAR_TC or opPCL == IOS_TGAME_TC  or opPCL == ANDROID_TGAME_TC then
    UpTxt = {
        stmp1 = "遊戲資源更新檢查, 請稍候……",
        stmp3 = "正在加載資源 %0.2f%%",
        stmp4 = "資源加載完畢, 正在進入遊戲……",
        stmp5 = "部分文件下載錯誤，是否重試？",
        stmp6 = "更新完成，请重新启动游戏",
    }
elseif opPCL == IOS_TGAME_KR or opPCL == ANDROID_TGAME_KR or opPCL == ANDROID_TGAME_KRNEW then
    UpTxt = {
        stmp1 = "게임서버 확인 중, 잠시만 기다려 주세요...",
        stmp3 = "로딩 중 %0.2f%%",
        stmp4 = "로딩 완료 , 게임 바로 시작합니다...",
        stmp5 = "일부파일 다운실패, 재시도 하시겠습니까?",
        stmp6 = "업그레이드 완료, 재 로그인 하세요",
    }
elseif opPCL == IOS_MOB_THAI or opPCL == ANDROID_VIETNAM_MOB_THAI or opPCL == IOS_TGAME_TH  or opPCL == ANDROID_TGAME_THAI then
    UpTxt = {
        stmp1 = "ตรวจสอบข้อมูลการอัพเดทเกม, กรุณารอสักครู่……",
        stmp3 = "กำลังดาวน์โหลดข้อมูล %0.2f%%",
        stmp4 = "ดาวน์โหลดเรียบร้อย, กำลังเข้าสู่เกม……",
        stmp5 = "พบข้อผิดพลาดในการดาวน์โหลด，ลองอีกครั้งไหม？",
        stmp6 = "อัพเดทเรียบร้อย，กรุณาเข้าสู่เกมอีกครั้ง",
    }
elseif opPCL == IOS_INFIPLAY_RUS or opPCL == ANDROID_INFIPLAY_RUS then
    UpTxt = {
        stmp1 = "Поиск обновлений, подождите...",
        stmp3 = "Загрузка ресурсов %0.2f%%",
        stmp4 = "Вход в игру...",
        stmp5 = "Ошибка загрузки файлов, попробовать еще раз?",
        stmp6 = "Игра обновлена, пожалуйста перезайдите",
    }
elseif opPCL == IOS_MOBGAME_SPAIN or opPCL == ANDROID_MOBGAME_SPAIN then
    UpTxt = {
        stmp1 = "Comprobando edición...",
        stmp3 = "Cargando %0.2f%%",
        stmp4 = "Cargado, entrando al juego...",
        stmp5 = "Ha fallido cargando algunas partes, Quiere reintentar?",
        stmp6 = "Actualizado. Reabra el juego.",
    }
elseif opPCL == WP_VIETNAM_VN then
    UpTxt = {
        stmp1 = "Đang kiểm tra phiên bản...",
        stmp3 = "Đang tải dữ liệu %0.2f%%",
        stmp4 = "Đã tải xong, đang vào game...",
        stmp5 = "Tải một số file thất bại, bạn có muốn thử lại không?",
        stmp6 = "Cập nhật hoàn tất. Vui lòng khởi động lại game.",
    }
elseif opPCL == WP_VIETNAM_EN then
    UpTxt = {
        stmp1 = "Loading, please wait……",
        stmp3 = "Downloading update %0.2f%%",
        stmp4 = "Update complete, loading……",
        stmp5 = "Download error, please retry？",
        stmp6 = "Update is completed, please restart your game.",
    }
else
    UpTxt = {
        stmp1 = "游戏资源更新检查, 请稍候……",
        stmp3 = "正在加载资源 %0.2f%%",
        stmp4 = "资源加载完毕, 正在进入游戏……",
        stmp5 = "部分文件下载错误，是否重试？",
        stmp6 = "更新完成，请重新启动游戏",
    }
end

local function transitionSchedule()
    local progress = loadingResProgressTmp:getPercentage()
    progress = progress + (1 / updateCountTmp * 100) / 10

    local nowPoint = (successCount + 1) / updateCountTmp * 100
    if progress > (nowPoint - (1 / updateCountTmp * 100) / 10) then
        progress = (nowPoint - (1 / updateCountTmp * 100) / 10)
    end
    if progress > 100 then
        progress = 100
    end
    if loadingResProgressTmp then
        loadingResProgressTmp:setPercentage(progress)
    end
end


local function loginGame()
    -- 发通知进游戏
    loadingResProgressTmp:setVisible(true)
    require "lua/util/reqUtil"
    reqFun()
    local function notice()
        postNotification(NOTI_LOGIN_GAME, nil)
    end
    local function fakeDownload()
        loadingNote:setVisible(true)
        loadingNote:setString(UpTxt.stmp4)
        loadingResProgressBg:setVisible(true)
        loadingResProgressTmp:setVisible(true)
        loadingResProgressTmp:runAction(CCProgressFromTo:create(0.5, 0, 100))
    end
    local array = CCArray:create()
    array:addObject(CCDelayTime:create(0.5))
    array:addObject(CCCallFunc:create(fakeDownload))
    array:addObject(CCDelayTime:create(0.5))
    array:addObject(CCCallFunc:create(notice))
    loadingResProgressTmp:runAction(CCSequence:create(array))
    return 
end

local function doUpdate()
    -- body
    errorFileList = {}
    successCount = 0
    if table.getn(UpdateFileList) > 0 then
        loadingResProgressBg:setVisible(true)
        loadingResProgressTmp:setVisible(true)

        updateCountTmp = table.getn(UpdateFileList)
        downCountTmp = table.getn(UpdateFileList)

        if btnLightSche then
            CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(btnLightSche)
        end
        btnLightSche = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(transitionSchedule, 1, false)
    
        local function updateProgressLabel()
            if loadingResProgressTmp then
                loadingResProgressTmp:setPercentage(successCount / updateCountTmp * 100)
            end
            
            if loadingNote then
                loadingNote:setString(string.format(UpTxt.stmp3, successCount / updateCountTmp * 100))
            end 
        end

        updateProgressLabel()

        for i,fName in ipairs(UpdateFileList) do
            print("fname is " .. fName)
            local function downloadCallbackFun(rtncode, fName)
                -- body
                downCountTmp = downCountTmp - 1
                if rtncode == 200 then
                    successCount = successCount + 1
                    localFile[fName] = diffFile[fName]
                    local file = io.open(CONF_PATH .. VERSION_JSON, "w+")
                    local writeData = json.encode(localFile)
                    writeData = string.gsub(writeData, "\\", "")
                    file:write(writeData)
                    file:close()
                    updateProgressLabel()
                else 
                    table.insert(errorFileList, fName)  -- 插入没有成功下载的文件名
                    updateSuccFlag = false
                    uDefault:setBoolForKey("update_succ", updateSuccFlag)
                    uDefault:flush()
                end
                if downCountTmp <= 0 then
                    if btnLightSche then
                        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(btnLightSche)
                    end
                    uDefault:setBoolForKey("update_succ", updateSuccFlag)
                    uDefault:flush()
                    if #errorFileList > 0 then
                        -- 如果出现下载失败的情况就弹出提示框让用户继续下载
                        local text = UpTxt.stmp5

                        local myConfirmLayer = LoginUpdateOwner["boxBg1"]
                        myConfirmLayer:setVisible(true)

                        local errorConfirmBtn = tolua.cast(LoginUpdateOwner["errorConfirmBtn"], "CCMenuItem")
                        errorConfirmBtn:setVisible(true)
                        local errorCancelBtn = tolua.cast(LoginUpdateOwner["errorCancelBtn"], "CCMenuItem")
                        errorCancelBtn:setVisible(true)

                        local cardContent = LoginUpdateOwner["cardContent1"]
                        if cardContent:getChildByTag(3) then
                            cardContent:getChildByTag(3):removeFromParentAndCleanup(true)
                        end
                        local msgTTF = CCLabelTTF:create(text, "ccbResources/FZCuYuan-M03S", 30, CCSizeMake(cardContent:getContentSize().width - 100, 0), kCCTextAlignmentCenter)
                        msgTTF:setPosition(cardContent:getContentSize().width / 2, cardContent:getContentSize().height / 2 + 70)
                        msgTTF:setAnchorPoint(ccp(0.5, 0.5))
                        msgTTF:setColor(ccc3(255, 255, 255))
                        cardContent:addChild(msgTTF, 3, 3)
                    else 
                        print("update  ended")
                        local myConfirmLayer = LoginUpdateOwner["boxBg2"]
                        myConfirmLayer:setVisible(true)

                        local exitBtn = tolua.cast(LoginUpdateOwner["exitBtn"], "CCMenuItem")
                        exitBtn:setVisible(true)

                        local cardContent = LoginUpdateOwner["cardContent2"]
                        if cardContent:getChildByTag(3) then
                            cardContent:getChildByTag(3):removeFromParentAndCleanup(true)
                        end
                        local msgTTF = CCLabelTTF:create(UpTxt.stmp6, "ccbResources/FZCuYuan-M03S", 30, CCSizeMake(cardContent:getContentSize().width - 100, 0), kCCTextAlignmentCenter)
                        msgTTF:setPosition(cardContent:getContentSize().width / 2, cardContent:getContentSize().height / 2 + 70)
                        msgTTF:setAnchorPoint(ccp(0.5, 0.5))
                        msgTTF:setColor(ccc3(255, 255, 255))
                        cardContent:addChild(msgTTF, 3, 3)
                    end
                end
            end
            downloadFile(HostTable.CDN_ROOT_OP2DXUP .. smallVersion .. "/" .. fName, CONF_PATH .. fName, downloadCallbackFun, false, fName)
        end
    else
        loginGame()
    end
end

function confirmFun()
    local myConfirmLayer = tolua.cast(LoginUpdateOwner["boxBg1"],"CCLayerColor") 
    myConfirmLayer:setVisible(false)
    local errorConfirmBtn = tolua.cast(LoginUpdateOwner["errorConfirmBtn"], "CCMenuItem")
    errorConfirmBtn:setVisible(false)
    local errorCancelBtn = tolua.cast(LoginUpdateOwner["errorCancelBtn"], "CCMenuItem")
    errorCancelBtn:setVisible(false)
    UpdateFileList = deepcopy(errorFileList)
    doUpdate()
end
function cancelFun()
    CCDirector:sharedDirector():endToLua()
    os.exit()
end
function exitBtnAction()
    CCDirector:sharedDirector():endToLua()
    os.exit()
end
LoginUpdateOwner["errorConfirmBtnAction"] = confirmFun
LoginUpdateOwner["errorCancelBtnAction"] = cancelFun
LoginUpdateOwner["exitBtnAction"] = exitBtnAction

-- 检查更新
local function checkUpdate( jsonData )
    diffFile = jsonData
    -- PrintTable(jsonData)

    -- 本地 version 文件
    local file = io.open(CONF_PATH .. VERSION_JSON)
    local versionFile = file:read("*a")
    file:flush()
    file:close()
    
    local function isJsonDecode()
        -- body
        json.decode(versionFile)
    end

    if pcall(isJsonDecode) then
        localFile = json.decode(versionFile)
    else
        -- 如果 json 解析失败 重新获取 json 文件
        Global:instance():updateVersion()
        local file = io.open(CONF_PATH .. VERSION_JSON)
        local versionFile = file:read("*a")
        file:flush()
        file:close()
        localFile = json.decode(versionFile)
    end

    for fName,md5Str in pairs(diffFile) do
        if not localFile[fName] or localFile[fName] ~= md5Str then
            table.insert(UpdateFileList, fName)
        end
    end
    updateCountTmp = table.getn(UpdateFileList)
    downCountTmp = table.getn(UpdateFileList)

    if updateCountTmp > 0 then
        -- 开始下载
        doUpdate()
    else
        loginGame()
    end
end


local function notEnforceUpdateFun()
    -- 如果 小版本一样 那么 跳过更新 直接登录
    UpdateFileList = {}
    localFile = nil
    diffFile = nil
    local requestItem = CCHttpRequest:open(HostTable.CDN_ROOT_OP2DXUP .. smallVersion .. "/" .. VERSION_JSON, kHttpGet)
    requestItem:sendWithHandler(
    function(res, hnd)
        
        rtnRes = {data = res:getResponseData(), code = res:getResponseCode()}
        if rtnRes.code == 200 then
            checkUpdate(json.decode(rtnRes.data))
        else
            loginGame()
        end
    end)
end



-- 更新界面
local function _refresh()
    local updateLayer = tolua.cast(LoginUpdateOwner["updateLayer"], "CCLayer")

    loadingResProgressBg = LoginUpdateOwner["resUpProgressBg"]
    local loadingResProgressBgPoint = {x = loadingResProgressBg:getPositionX(), y = loadingResProgressBg:getPositionY()}

    local resUpProgressSpr = CCSprite:createWithSpriteFrameName("resUpProgress.png")
    loadingResProgressTmp = CCProgressTimer:create(resUpProgressSpr)
    updateLayer:addChild(loadingResProgressTmp, 4, 0)
    loadingResProgressTmp:setAnchorPoint(ccp(0.5, 0.5))
    loadingResProgressTmp:setPosition(loadingResProgressBgPoint.x, loadingResProgressBgPoint.y)
    loadingResProgressTmp:setType(kCCProgressTimerTypeBar) --kCCProgressTimerTypeHorizontalBarLR
    loadingResProgressTmp:setMidpoint(CCPointMake(0, 0))
    loadingResProgressTmp:setBarChangeRate(CCPointMake(1, 0))

    confirmLayer = LoginUpdateOwner["boxBg"]
    confirmLayer:setVisible(false)

    loadingNote = CCLabelTTF:create(UpTxt.stmp1, "ccbResources/FZCuYuan-M03S.ttf", 25, CCSizeMake(0, 0), kCCTextAlignmentCenter)
    updateLayer:addChild(loadingNote, 0, 0)
    loadingNote:setAnchorPoint(ccp(0.5, 0.5))
    loadingNote:setPosition(loadingResProgressBgPoint.x, loadingResProgressBgPoint.y + 30)
    loadingNote:setColor(ccc3(255, 255, 255))

    -- 开始隐藏 进度条
    loadingResProgressBg:setVisible(false)
    loadingResProgressTmp:setVisible(false)

    -- 按钮文字
    local okMenu = tolua.cast(LoginUpdateOwner["confirmBtn"], "CCMenuItem")
    if okMenu then
        local okLabel = CCLabelTTF:create("OK", "ccbResources/FZCuYuan-M03S.ttf", 30)
        okLabel:setAnchorPoint(ccp(0.5, 0.5))
        okLabel:setPosition(okMenu:getContentSize().width / 2, okMenu:getContentSize().height/2)
        okMenu:addChild(okLabel)
    end 
    local cancelMenu = tolua.cast(LoginUpdateOwner["cancelBtn"], "CCMenuItem")
    if cancelMenu then
        local cancelLabel = CCLabelTTF:create("Cancel", "ccbResources/FZCuYuan-M03S.ttf", 30)
        cancelLabel:setAnchorPoint(ccp(0.5, 0.5))
        cancelLabel:setPosition(cancelMenu:getContentSize().width / 2, cancelMenu:getContentSize().height / 2)
        cancelMenu:addChild(cancelLabel)
    end 

    local okMenu = tolua.cast(LoginUpdateOwner["errorConfirmBtn"], "CCMenuItem")
    if okMenu then
        local okLabel = CCLabelTTF:create("OK", "ccbResources/FZCuYuan-M03S.ttf", 30)
        okLabel:setAnchorPoint(ccp(0.5, 0.5))
        okLabel:setPosition(okMenu:getContentSize().width / 2, okMenu:getContentSize().height / 2)
        okMenu:addChild(okLabel)
    end 
    local cancelMenu = tolua.cast(LoginUpdateOwner["errorCancelBtn"], "CCMenuItem")
    if cancelMenu then
        local cancelLabel = CCLabelTTF:create("Cancel", "ccbResources/FZCuYuan-M03S.ttf", 30)
        cancelLabel:setAnchorPoint(ccp(0.5, 0.5))
        cancelLabel:setPosition(cancelMenu:getContentSize().width / 2, cancelMenu:getContentSize().height / 2)
        cancelMenu:addChild(cancelLabel)
    end 

    local exitBtn = tolua.cast(LoginUpdateOwner["exitBtn"], "CCMenuItem")
    if exitBtn then
        local okLabel = CCLabelTTF:create("OK", "ccbResources/FZCuYuan-M03S.ttf", 30)
        okLabel:setAnchorPoint(ccp(0.5, 0.5))
        okLabel:setPosition(exitBtn:getContentSize().width / 2, exitBtn:getContentSize().height / 2)
        exitBtn:addChild(okLabel)
    end
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/LoginUpdateView.ccbi", proxy, true,"LoginUpdateOwner")
    _layer = tolua.cast(node,"CCLayer")

    local logo = tolua.cast(LoginUpdateOwner["logo"], "CCSprite")
    if isPlatform(IOS_APPLE2_ZH) 
        or isPlatform(IOS_KY_ZH)
        or isPlatform(IOS_ITOOLS) 
        or isPlatform(IOS_PPZS_ZH) 
        or isPlatform(IOS_PPZSPARK_ZH)
        or isPlatform(ANDROID_AGAME_ZH) 
        or isPlatform(IOS_91_ZH) 
        or isPlatform(ANDROID_91_ZH) 
        or isPlatform(ANDROID_360_ZH) 
        or isPlatform(ANDROID_WDJ_ZH) 
        or isPlatform(ANDROID_MMY_ZH)
        or isPlatform(ANDROID_HUAWEI_ZH)
        or isPlatform(IOS_TBT_ZH)
        or isPlatform(IOS_AISI_ZH)
        or isPlatform(ANDROID_COOLPAY_ZH)
        or isPlatform(ANDROID_GIONEE_ZH)
        or isPlatform(ANDROID_MYEPAY_ZH)
        or isPlatform(ANDROID_HTC_ZH) then

        if isSpringFestival then
            CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/springLogo.plist")
            logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("springLogo.png"))         
        else
            CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/tiantianLogo.plist")
            logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("tiantianLogo.png"))
        end

    elseif isPlatform(ANDROID_XIAOMI_ZH) 
        or isPlatform(ANDROID_OPPO_ZH) then
        if isSpringFestival then
            CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/springLogo.plist")
            logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("springLogo.png"))         
        else
            CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/daLogo.plist")
            logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("daLogo.png"))
        end

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
        
    elseif isPlatform(IOS_MOBNAPPLE_EN) or isPlatform(ANDROID_VIETNAM_EN_ALL) or isPlatform(ANDROID_VIETNAM_EN) then
        if isSpringFestival then
            CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/springLogo.plist")
            logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("pfSpringLogo.png"))         
        else
            -- CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/login.plist")
            logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("logo_1.png"))
        end
     
     elseif isPlatform(ANDROID_JAGUAR_TC) then
        --todo
        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/lbLogo.plist")
        --local logo = tolua.cast(LoginLoginOwner["logo"], "CCSprite")
        logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("lbLogo.png")) 
           
    elseif isPlatform(ANDROID_GV_XJP_ZH)
        or isPlatform(ANDROID_GV_MFACE_TC)
        or isPlatform(IOS_GAMEVIEW_TC)
        or isPlatform(ANDROID_GV_MFACE_TC_GP) then

        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/mfaceLogo2.plist")
        logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("mfaceLogo2.png"))
    else
        if isSpringFestival then
            CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/springLogo.plist")
            logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("springLogo.png"))         
        end
    end
        
    local loading_icon = tolua.cast(LoginUpdateOwner["loading_icon"], "CCSprite")
    local animFrames = CCArray:create()
    for j = 1, 6 do
        local frameName = string.format("loading_%d.png",j)
        local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName)
        animFrames:addObject(frame)
    end
    
    local animation = CCAnimation:createWithSpriteFrames(animFrames, 0.1)
    local animate = CCAnimate:create(animation)
    loading_icon:runAction(CCRepeatForever:create(animate))
    _refresh()
end

-- 返回版本号a是否大于b
-- @params a x.xx
local function compareVersion(a, b)
    local function strSplit( szFullString, szSeparator )
        local nSplitArray = {}
        string.gsub(szFullString, '[^'..szSeparator..']+',
            function(rtnStr)
                table.insert(nSplitArray, rtnStr)
            end
        )
        return nSplitArray
    end
    local versA = strSplit(a, ".")
    local versB = strSplit(b, ".")
    local maxLen = math.max(#versA, #versB)
    for i=1, maxLen do
        local verA = versA[i]
        local verB = versB[i]
        if not verA then
            return -1
        end
        if not verB then
            return 1
        end
        if verA > verB then
            return 1
        end
        if verA < verB then
            return -1
        end
    end
    return 0
end

-- 强制更新
local function confirmBtnAction()
    Global:instance().openURL(upUrl)
end
LoginUpdateOwner["confirmBtnAction"] = confirmBtnAction

local function cancelBtnAction()
    CCDirector:sharedDirector():endToLua()
    os.exit()
end
LoginUpdateOwner["cancelBtnAction"] = cancelBtnAction

local function enforceUpdateFun(upMsg, upUrl)
    -- 强制更新 清除数据
    Global:instance():updateVersion()

    -- 弹出框
    local boxBg = tolua.cast(LoginUpdateOwner["boxBg"], "CCLayer")
    boxBg:setVisible(true)
    local confirmBtn = tolua.cast(LoginUpdateOwner["confirmBtn"], "CCMenuItem")
    confirmBtn:setVisible(true)
    local y = confirmBtn:getPositionY()
    confirmBtn:setPosition(ccp(boxBg:getContentSize().width / 2, y))
    local cancelBtn = tolua.cast(LoginUpdateOwner["cancelBtn"], "CCMenuItem")
    cancelBtn:setVisible(false)

    local cardContent = LoginUpdateOwner["cardContent"]

    local msgTTF = CCLabelTTF:create(upMsg, "ccbResources/FZCuYuan-M03S", 30, CCSizeMake(cardContent:getContentSize().width - 100, 0), kCCTextAlignmentCenter)
    msgTTF:setPosition(cardContent:getContentSize().width / 2, cardContent:getContentSize().height / 2 + 70)
    msgTTF:setAnchorPoint(ccp(0.5, 0.5))
    msgTTF:setColor(ccc3(255, 255, 255))
    cardContent:addChild(msgTTF, 1)
end
-- 强制更新结束

function createLoginUpdateLayer()
    _init()

    local function _onEnter()

        local CFBundleVersion = uDefault:getStringForKey(opPCL.."_ver")
        
        local function getVersion()

            local function callback(url, rtnData)
                -- body
                --[[
                    appVersionInfo = {
                        bigVersion = 3.0, --需要强制更新的版本号，若大于当前版本号则需要强制更新
                        bigVersionUrl = "http://xxxxx", --强制更新 版本下载地址
                        bigVersionContent = "最新更新内容", -- 强制更新 版本更新内容
                        smallVersion = 3.1,
                    }
                ]]
                -- 是否强制更新
                local upMsg = ""

                local upFlag = false

                print("return GET_LASTEST_VERSION data : ")
                PrintTable(rtnData)

                if rtnData and rtnData["info"] then
                    local versionInfo = rtnData["info"]["appVersionInfo"]
                    upMsg = versionInfo["bigVersionContent"]
                    upUrl = versionInfo["bigVersionUrl"]
                    if versionInfo then
                        smallVersion = versionInfo["smallVersion"]
                        if versionInfo["bigVersion"] and versionInfo["bigVersion"] ~= "" then
                            -- 官方平台
                            print(tostring(versionInfo["bigVersion"]), CFBundleVersion, compareVersion(tostring(versionInfo["bigVersion"]), CFBundleVersion))
                            if compareVersion(tostring(versionInfo["bigVersion"]), CFBundleVersion) == 1 then
                                -- 需要强制更新
                                if versionInfo["bigVersionUrl"] then
                                    upFlag = true
                                end
                            end
                        end
                    end
                end   

                if upFlag then
                    -- 强制更新操作
                    enforceUpdateFun(upMsg)
                else
                    -- 非强制更新 自动更新启动
                    -- notEnforceUpdateFun()
                    notEnforceUpdateFun()
                end
            end
            local params = {CFBundleVersion}
            if isPlatform(IOS_INFIPLAY_RUS)  or isPlatform(ANDROID_INFIPLAY_RUS) then
                table.insert(params, SSOPlatform.m_guid)
            elseif isPlatform(WP_VIETNAM_VN) then
                table.insert(params, SSOPlatform.m_guid)
            elseif isPlatform(WP_VIETNAM_EN) then
                table.insert(params, SSOPlatform.m_guid)
            else
                table.insert(params, SSOPlatform.GetUid())
            end

            doActionNoLoadingFun("GET_LASTEST_VERSION", params, callback, SERVERCODE.SSO, true)
        end
        getVersion()
    end

    local function _onExit()
        _layer = nil
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