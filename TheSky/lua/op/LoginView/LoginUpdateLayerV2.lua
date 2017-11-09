-- 登陆sso账号 --

local _layer

local loadingResProgressBg
local loadingResProgressTmp
local loadingNote
local smallVersion

local UpdateFileList = {}
local localFile
local cdnFile

local updateCountTmp = 0
local downCountTmp = 0
local errorFileList
local successCount
local btnLightSche
local updateSuccFlag = true
local versionInfo


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
elseif opPCL == IOS_GAMEVIEW_EN or opPCL == IOS_GVEN_BREAK or opPCL == ANDROID_GV_MFACE_EN or opPCL == IOS_VIETNAM_EN 
    or opPCL == IOS_MOBNAPPLE_EN or opPCL == ANDROID_VIETNAM_EN or opPCL == ANDROID_VIETNAM_EN_ALL 
    or opPCL == ANDROID_GV_MFACE_EN_OUMEI or opPCL == ANDROID_GV_MFACE_EN_OUMEINEW or opPCL == IOS_VIETNAM_ENSAGA then
    UpTxt = {
        stmp1 = "Loading, please wait……",
        stmp3 = "Downloading update %0.2f%%",
        stmp4 = "Update complete, loading……",
        stmp5 = "Download error, please retry？",
        stmp6 = "Update is completed, please restart your game.",
    }
elseif opPCL == IOS_GAMEVIEW_TC or opPCL == ANDROID_GV_MFACE_TC or opPCL == ANDROID_GV_MFACE_TC_GP  or opPCL == ANDROID_JAGUAR_TC
        or opPCL == IOS_JAGUAR_TC or opPCL == IOS_TGAME_TC or opPCL == ANDROID_TGAME_TC then
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
elseif opPCL == IOS_MOB_THAI or opPCL == ANDROID_VIETNAM_MOB_THAI or opPCL == IOS_TGAME_TH or opPCL == ANDROID_TGAME_THAI then
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
else
    UpTxt = {
        stmp1 = "游戏资源更新检查, 请稍候……",
        stmp3 = "正在加载资源 %0.2f%%",
        stmp4 = "资源加载完毕, 正在进入游戏……",
        stmp5 = "部分文件下载错误，是否重试？",
        stmp6 = "更新完成",
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
            -- print("fname is " .. fName)
            local function downloadCallbackFun(rtncode, fName)
                -- body
                downCountTmp = downCountTmp - 1
                if rtncode == 200 then
                    successCount = successCount + 1
                    localFile[fName] = cdnFile[fName]
                    local file = io.open(TEMP_PATH .. VERSION_JSON, "w+")
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
                        local function downloadFinished()
                            local temp = string.sub(TEMP_PATH, 1, -1)
                            local conf = string.sub(CONF_PATH, 1, -1)
                            copyDirFile(temp, conf)
                            deleteFile(TEMP_PATH)
                        end

                        _layer:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(downloadFinished)))

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
            downloadFile(HostTable.CDN_ROOT_OP2DXUP .. smallVersion .. "/" .. fName, TEMP_PATH .. fName, downloadCallbackFun, false, fName)
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
    -- CCDirector:sharedDirector():endToLua()
    -- os.exit()
    if package.loaded["lua/start_v2"] then
        package.loaded["lua/start_v2"] = nil
    end
    require("lua/start_v2")
end
LoginUpdateOwner["errorConfirmBtnAction"] = confirmFun
LoginUpdateOwner["errorCancelBtnAction"] = cancelFun
LoginUpdateOwner["exitBtnAction"] = exitBtnAction

-- 检查更新
local function checkUpdate(updateFiles)
    -- PrintTable(jsonData)
    local isUpdateComplete = true
    if isFileExist(TEMP_PATH .. VERSION_JSON) then
        isUpdateComplete = false
    else
        -- 清除缓存目录
        deleteFile(TEMP_PATH)
        createDir(TEMP_PATH)
        -- 将资源拷贝到caches目录，准备更新
        local rtn = copyFile(CONF_PATH .. VERSION_JSON, TEMP_PATH .. VERSION_JSON)
        if not rtn then
            copyFile(VERSION_JSON, TEMP_PATH .. VERSION_JSON)
        end
    end

    local file = io.open(CONF_PATH .. VERSION_JSON)
    local versionFile = file:read("*a")
    file:flush()
    file:close()
    localFile = json.decode(versionFile)
    
    cdnFile = updateFiles

    -- 需下载列表
    local downloadFiles = {}
    for fileName, md5String in pairs(cdnFile) do
        if not localFile or not localFile[fileName] or localFile[fileName] ~= md5String then
            if isUpdateComplete or not isFileExist(TEMP_PATH .. fileName) then
                table.insert(UpdateFileList, fileName)
            end
        end
    end

    if table.getn(UpdateFileList) > 0 then
        doUpdate()
    else
        -- 无需更新
        deleteFile(TEMP_PATH .. VERSION_JSON)
        loginGame()
    end
end


local function notEnforceUpdateFun()
    UpdateFileList = {}
    localFile = nil
    cdnFile = nil
    HostTable.CDN_ROOT_OP2DXUP = versionInfo.cdnUrl
    local function downloadVersion()
        local requestItem = CCHttpRequest:open(HostTable.CDN_ROOT_OP2DXUP .. smallVersion .. "/" .. VERSION_JSON, kHttpGet)
        requestItem:sendWithHandler(
            function(res, hnd)        
                rtnRes = {data = res:getResponseData(), code = res:getResponseCode()}
                if rtnRes.code == 200 then
                    checkUpdate(json.decode(rtnRes.data))
                elseif rtnRes.code == 403 or rtnRes.code == 404 then
                    loginGame()
                else
                    downloadVersion()
                end
            end
        )
    end
    downloadVersion()
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

        if isSpringFestival and (isPlatform(ANDROID_GV_MFACE_EN) or isPlatform(ANDROID_GV_MFACE_EN_OUMEI) or isPlatform(ANDROID_GV_MFACE_EN_OUMEINEW) or isPlatform(IOS_GAMEVIEW_EN)
        or isPlatform(IOS_GVEN_BREAK)) then
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
        
    elseif isPlatform(ANDROID_GV_XJP_ZH)
        or isPlatform(ANDROID_GV_MFACE_TC)
        or isPlatform(IOS_GAMEVIEW_TC)
        or isPlatform(ANDROID_GV_MFACE_TC_GP) then

        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/mfaceLogo2.plist")
        logo:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("mfaceLogo2.png"))

    elseif isPlatform(IOS_IIAPPLE_ZH) or isPlatform(IOS_KYPARK_ZH) or isPlatform(ANDROID_KY_ZH) or isPlatform(IOS_TBTPARK_ZH) 
        or isPlatform(IOS_ITOOLSPARK) or isPlatform(IOS_HAIMA_ZH) or isPlatform(IOS_XYZS_ZH) or isPlatform(ANDROID_XYZS_ZH) or isPlatform(IOS_AISIPARK_ZH)
        or isPlatform(IOS_DOWNJOYPARK_ZH) or isPlatform(ANDROID_DOWNJOY_ZH) then

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
        local verA = tonumber(versA[i])
        local verB = tonumber(versB[i])
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
    Global:instance().openURL(versionInfo.updateSet.url)
    CCDirector:sharedDirector():endToLua()
    os.exit()
end
LoginUpdateOwner["confirmBtnAction"] = confirmBtnAction

local function cancelBtnAction()
    -- 进入下载
    local boxBg = tolua.cast(LoginUpdateOwner["boxBg"], "CCLayer")
    boxBg:setVisible(false)
    local confirmBtn = tolua.cast(LoginUpdateOwner["confirmBtn"], "CCMenuItem")
    confirmBtn:setVisible(false)
    local cancelBtn = tolua.cast(LoginUpdateOwner["cancelBtn"], "CCMenuItem")
    cancelBtn:setVisible(false)
    notEnforceUpdateFun()
end
LoginUpdateOwner["cancelBtnAction"] = cancelBtnAction

local function enforceUpdateFun(popUpFlag)

    -- 弹出框
    local boxBg = tolua.cast(LoginUpdateOwner["boxBg"], "CCLayer")
    boxBg:setVisible(true)
    local confirmBtn = tolua.cast(LoginUpdateOwner["confirmBtn"], "CCMenuItem")
    confirmBtn:setVisible(true)
    local y = confirmBtn:getPositionY()
    if popUpFlag == 0 then
        confirmBtn:setPosition(ccp(boxBg:getContentSize().width / 2, y))
    end
    local cancelBtn = tolua.cast(LoginUpdateOwner["cancelBtn"], "CCMenuItem")
    cancelBtn:setVisible(popUpFlag == 1)

    local cardContent = LoginUpdateOwner["cardContent"]

    local msgTTF = CCLabelTTF:create(versionInfo.updateSet.notice, "ccbResources/FZCuYuan-M03S", 30, CCSizeMake(cardContent:getContentSize().width - 100, 0), kCCTextAlignmentCenter)
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
        
        -- local function getVersion()

            local function callback(url, rtnData)
                -- body
                --[[
                    appVersionInfo = {
                        bigVersion = 3.0, --需要强制更新的版本号，若大于当前版本号则需要强制更新
                        bigVersionUrl = "http://xxxxx", --强制更新 版本下载地址
                        bigVersionContent = "最新更新内容", -- 强制更新 版本更新内容
                        smallVersion = 3.1,
                    }
                    新版的返回是
                    {"appVersionInfo" : {
                        "bigVersion_online" : "1.0.0",
                        "smallVersion" : "10000",
                        "cdnUrl" : "http:\/\/god.cdn.tainengmiao.com\/onepiece\/Apple\/",
                        "updateSet" : {
                            "flag" : "1",
                            "notice" : "\u8fd9\u662f1.0.0\u66f4\u65b0\u7684\u516c\u544a",
                            "url" : "http:\/\/www.baidu.com"
                            }
                        }
                    }
                ]]
                -- 是否强制更新

                --print("return GET_LASTEST_VERSION data : ")
                 --PrintTable(rtnData)

                if rtnData and rtnData["info"] then
                    versionInfo = rtnData["info"]["appVersionInfo"]
                    if versionInfo then
                        smallVersion = versionInfo["smallVersion"]
                        local bigVersion = versionInfo["bigVersion_online"]
                        if bigVersion and bigVersion ~= "" then
                            -- 官方平台
                            local x = compareVersion(CFBundleVersion, tostring(bigVersion))
                            if -1 == x then -- 有大版本更新
                                if tonumber(versionInfo.updateSet.flag) > 0 then
                                    local popUpFlag = 0
                                    if versionInfo.updateSet.flag == "1" then -- 强制更新
                                        popUpFlag = 0
                                    elseif versionInfo.updateSet.flag == "2" then -- 非强制更新
                                        popUpFlag = 1
                                    end
                                    enforceUpdateFun(popUpFlag)
                                end
                            else
                                notEnforceUpdateFun()
                            end
                        end
                    end
                end   
            end



            local params = {CFBundleVersion}
            if isPlatform(IOS_INFIPLAY_RUS) 
                or isPlatform(ANDROID_INFIPLAY_RUS)
                or isPlatform(IOS_TEST_ZH) 
                or isPlatform(IOS_APPLE_ZH) then
                table.insert(params, SSOPlatform.m_guid)
            else
                table.insert(params, SSOPlatform.GetUid())
            end

            doActionNoLoadingFun("GET_LASTEST_VERSION_V2", params, callback, SERVERCODE.SSO, true)
        -- end
        -- getVersion()

        CCSpriteFrameCache:sharedSpriteFrameCache():removeUnusedSpriteFrames()
        CCTextureCache:sharedTextureCache():removeUnusedTextures()
        
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