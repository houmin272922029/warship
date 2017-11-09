-- 更新工具
-- HostTable.CDN_ROOT_OP2DXUP = "http://192.168.1.133/appstore/public/resource/op2dxUp/"     -- 测试用 更新资源下载地址
SmallVersion = nil
BigVersion = nil
local _updateScene
local UpdateFileList = {}     -- 更新文件列表
local localFile
local diffFile
local updateCountTmp = 0
local downCountTmp = 0
local loadingResProgressTmp
local loadingResProgressBg
local loadingNote
local confirmLayer
local smallVersion
local updateSuccFlag = true
local errorFileList = {}    -- 更新失败的文件列表
local successCount = 0
local btnLightSche

UpdateLayerOwner = UpdateLayerOwner or {}
ccb["UpdateLayerOwner"] = UpdateLayerOwner

local UpTxt = {}
if opPCL == IOS_VIETNAM_VI or opPCL == ANDROID_VIETNAM_VI then
UpTxt = {
    stmp1 = "Đang kiểm tra phiên bản...",
    stmp3 = "Đang tải dữ liệu %d/%d",
    stmp4 = "Đã tải xong, đang vào game...",
    stmp5 = "Tải một số file thất bại, bạn có muốn thử lại không?",
    stmp6 = "Cập nhật hoàn tất. Vui lòng khởi động lại game.",
}
elseif opPCL == IOS_GAMEVIEW_EN or opPCL == IOS_GVEN_BREAK or opPCL == WP_VIETNAM_EN or opPCL == ANDROID_GV_MFACE_EN or opPCL == IOS_VIETNAM_EN 
    or opPCL == IOS_MOBNAPPLE_EN or opPCL == ANDROID_VIETNAM_EN or opPCL == ANDROID_VIETNAM_EN_ALL or opPCL == ANDROID_GV_MFACE_EN_OUMEI 
    or opPCL == ANDROID_GV_MFACE_EN_OUMEINEW or opPCL == IOS_VIETNAM_ENSAGA then
UpTxt = {
    stmp1 = "Loading, please wait……",
    stmp3 = "Downloading update %d/%d",
    stmp4 = "Update complete, loading……",
    stmp5 = "Download error, please retry？",
    stmp6 = "Update completed. Please login and enjoy the game.",
}
elseif opPCL == IOS_GAMEVIEW_TC or opPCL == ANDROID_GV_MFACE_TC or opPCL == ANDROID_GV_MFACE_TC_GP or opPCL == ANDROID_JAGUAR_TC
        or opPCL == IOS_JAGUAR_TC or opPCL == IOS_TGAME_TC or opPCL == ANDROID_TGAME_TC then
UpTxt = {
    stmp1 = "遊戲資源更新檢查, 請稍候……",
    stmp3 = "正在加載資源 %d/%d",
    stmp4 = "資源加載完畢, 正在進入遊戲……",
    stmp5 = "部分文件下載錯誤，是否重試？",
    stmp6 = "更新完成，请重新进入游戏",
}
elseif opPCL == IOS_TGAME_KR or opPCL == ANDROID_TGAME_KR  or opPCL == ANDROID_TGAME_KRNEW then
UpTxt = {
    stmp1 = "게임서버 확인 중, 잠시만 기다려 주세요...",
    stmp3 = "로딩... %d/%d",
    stmp4 = "로딩 완료, 게임 시작합니다...",
    stmp5 = "일부파일 다운실패, 재시도 하시겠습니까?",
    stmp6 = "업그레이드 완료, 재 로그인 하세요",
}
elseif opPCL == IOS_TGAME_RUS then
UpTxt = {
    stmp1 = "Поиск обновлений, подождите...",
    stmp3 = "Инициализация ресурсо... %0.2f%%",
    stmp4 = "Вход в игру...",
    stmp5 = "Ошибка загрузки файлов, попробовать еще раз?",
    stmp6 = "Игра обновлена, пожалуйста перезайдите",
}
elseif opPCL == IOS_MOB_THAI or opPCL == ANDROID_VIETNAM_MOB_THAI or opPCL == IOS_TGAME_TH or opPCL == ANDROID_TGAME_THAI then
    UpTxt = {
        stmp1 = "ตรวจสอบข้อมูลการอัพเดทเกม, กรุณารอสักครู่……",
        stmp3 = "กำลังดาวน์โหลดข้อมูล %d/%d",
        stmp4 = "ดาวน์โหลดเรียบร้อย, กำลังเข้าสู่เกม……",
        stmp5 = "พบข้อผิดพลาดในการดาวน์โหลด，ลองอีกครั้งไหม？",
        stmp6 = "อัพเดทเรียบร้อย，กรุณาเข้าสู่เกมอีกครั้ง",
    }
elseif opPCL == IOS_TGAME_RUS then
    UpTxt = {
        stmp1 = "Поиск обновлений, подождите...",
        stmp3 = "Инициализация ресурсов... %0.2f%%",
        stmp4 = "Вход в игру...",
        stmp5 = "Ошибка загрузки файлов, попробовать еще раз?",
        stmp6 = "Игра обновлена, пожалуйста перезайдите",
    }
elseif opPCL ==  IOS_MOBGAME_SPAIN or opPCL == ANDROID_MOBGAME_SPAIN then
    UpTxt = {
        stmp1 = "Đang kiểm tra phiên bản...",
        stmp3 = "Đang tải dữ liệu %d/%d",
        stmp4 = "Đã tải xong, đang vào game...",
        stmp5 = "Tải một số file thất bại, bạn có muốn thử lại không?",
        stmp6 = "Cập nhật hoàn tất. Vui lòng khởi động lại game.",
    }
else
    UpTxt = {
        stmp1 = "游戏资源更新检查, 请稍候……",
        stmp3 = "正在加载资源 %d/%d",
        stmp4 = "资源加载完毕, 正在进入游戏……",
        stmp5 = "部分文件下载错误，是否重试？",
        stmp6 = "更新完成，请重新进入游戏",
    }
end
-- stmp2 = "如果您是第一次打开游戏，加载文件较多，请耐心等待。",

local function transitionSchedule(  )
    local progress = loadingResProgressTmp:getPercentage()
    progress = progress + 5.54

    local nowPoint = (updateCountTmp - downCountTmp) / updateCountTmp * 100
    if progress > nowPoint then
        progress = nowPoint
    end
    if progress > 100 then
        progress = 100
    end
    if loadingResProgressTmp then
        loadingResProgressTmp:setPercentage(progress)
    end

    if loadingNote then
        -- "Loading......("..(updateCountTmp - downCountTmp).."/"..updateCountTmp..")"
        loadingNote:setString(string.format(UpTxt.stmp3, updateCountTmp - downCountTmp, updateCountTmp))
    end
end

local function transitionSchedule2(  )
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
        -- loadingResProgressTmp:stopAllActions()
        -- loadingResProgressTmp:runAction(CCProgressFromTo:create(1, loadingResProgressTmp:getPercentage(), progress))
        loadingResProgressTmp:setPercentage(progress)
    end
end

local function doUpdate(  )
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
        btnLightSche = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(transitionSchedule2, 1, false)
    
        local function updateProgressLabel(  )
            if loadingResProgressTmp then
                loadingResProgressTmp:setPercentage(successCount / updateCountTmp * 100)
            end

            if loadingNote then
                loadingNote:setString(string.format(UpTxt.stmp3, successCount, updateCountTmp))
            end 
        end

        updateProgressLabel(  )

        for i,fName in ipairs(UpdateFileList) do
            local function downloadCallbackFun( rtncode, fName )
                -- body
                downCountTmp = downCountTmp - 1
                if rtncode == 200 then
                    successCount = successCount + 1
                    localFile[fName] = diffFile[fName]
                    local file = io.open(CONF_PATH..VERSION_JSON, "w+")
                    local writeData = json.encode(localFile)
                    writeData = string.gsub(writeData, "\\", "")
                    file:write(writeData)
                    file:close()
                    updateProgressLabel(  )
                else 
                    print(" Print By lixq ---- errorFileList:", rtncode, fName)
                    table.insert( errorFileList, fName )  -- 插入没有成功下载的文件名
                    updateSuccFlag = false
                    uDefault:setBoolForKey("update_succ", updateSuccFlag)
                    uDefault:flush()
                end
                -- print(" ------ update file ---- ", (updateCountTmp - downCountTmp).."/"..updateCountTmp)
                if downCountTmp <= 0 then
                    if btnLightSche then
                        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(btnLightSche)
                    end
                    uDefault:setBoolForKey("update_succ", updateSuccFlag)
                    uDefault:flush()
                    if #errorFileList > 0 then
                        -- 如果出现下载失败的情况就弹出提示框让用户继续下载
                        local text = UpTxt.stmp5


                        local myConfirmLayer = UpdateLayerOwner["boxBg1"]
                        myConfirmLayer:setVisible(true)

                        local cardContent = UpdateLayerOwner["cardContent1"]
                        if cardContent:getChildByTag(3) then
                            cardContent:getChildByTag(3):removeFromParentAndCleanup(true)
                        end
                        local msgTTF = CCLabelTTF:create(text, "ccbResources/FZCuYuan-M03S", 30, CCSizeMake(cardContent:getContentSize().width - 100, 0), kCCTextAlignmentCenter)
                        msgTTF:setPosition(cardContent:getContentSize().width / 2, cardContent:getContentSize().height / 2 + 70)
                        msgTTF:setAnchorPoint(ccp(0.5, 0.5))
                        msgTTF:setColor(ccc3(255, 255, 255))
                        cardContent:addChild(msgTTF, 3,3)
                    else
                        require "lua/util/reqUtil"
                        reqFun()
                        local repScene = CCScene:create()
                        repScene:addChild(LoginLayer())
                        CCDirector:sharedDirector():replaceScene(repScene)
                    end
                end
            end
            downloadFile(HostTable.CDN_ROOT_OP2DXUP..smallVersion.."/"..fName, CONF_PATH..fName, downloadCallbackFun, false, fName)
        end
    else
        if loadingNote then
            loadingNote:setString(string.format(UpTxt.stmp4, updateCountTmp - downCountTmp, updateCountTmp))
        end
        require "lua/util/reqUtil"
        reqFun()
        local repScene = CCScene:create()
        repScene:addChild(LoginLayer())
        CCDirector:sharedDirector():replaceScene(repScene)
    end
end

function confirmFun(  )
    local myConfirmLayer = tolua.cast(UpdateLayerOwner["boxBg1"],"CCLayerColor") 
    myConfirmLayer:setVisible(false)
    UpdateFileList = deepcopy(errorFileList)
    doUpdate(  )
end
function cancelFun(  )
    CCDirector:sharedDirector():endToLua()
    os.exit()
end
UpdateLayerOwner["errorConfirmBtnAction"] = confirmFun
UpdateLayerOwner["errorCancelBtnAction"] = cancelFun

-- 检查更新
local function checkUpdate( jsonData )
    diffFile = jsonData
    -- body
    print(" ---- checkUpdate ---- ")
    -- PrintTable(jsonData)

    -- 本地 version 文件
    -- print(" Print By lixq version.json path --- ", fileUtil:fullPathForFilename(VERSION_JSON))
    local file = io.open(CONF_PATH..VERSION_JSON)
    local versionFile = file:read("*a")
    file:flush()
    file:close()
    -- print(" ---- local version file ---- ", versionFile)
    
    local function isJsonDecode( )
        -- body
        json.decode(versionFile)
    end

    if pcall(isJsonDecode) then
        print(" Print BY lixq ---- isJsonDecode true!!!!!!")
        localFile = json.decode(versionFile)
    else
        -- 如果 json 解析失败 重新获取 json 文件
        print(" Print By lixq ---- isJsonDecode false , copy version.json file")
        Global:instance():updateVersion()
        local file = io.open(CONF_PATH..VERSION_JSON)
        local versionFile = file:read("*a")
        file:flush()
        file:close()
        localFile = json.decode(versionFile)
    end
    
    -- localFile = json.decode(versionFile)
    -- for k,v in pairs(localFile) do
    --     print(k,v)
    -- end

    for fName,md5Str in pairs(diffFile) do
        -- print(fName,md5Str)
        if not localFile[fName] or localFile[fName] ~= md5Str then
            table.insert(UpdateFileList, fName)
        end
    end
    updateCountTmp = table.getn(UpdateFileList)
    downCountTmp = table.getn(UpdateFileList)
    -- 开始下载
    doUpdate()
end

-- 更新界面
local function updateUtilUi(  )
    -- body
    print(" Print By lixq ---- update ui print  ")

    local proxy = CCBProxy:create()
    local node  = CCBReaderLoad("ccbResources/UpdateView.ccbi", proxy, true, "UpdateLayerOwner")
    local _layer = tolua.cast(node, "CCLayer")

    local bg = UpdateLayerOwner["bg"]
    -- if isPlatform(IOS_APPLE_ZH) then
    --     local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
    --     cache:addSpriteFramesWithFile("ccbResources/appstore_replace.plist")
    --     bg:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("resUpBg_appstore.jpg"))
    -- end

    loadingResProgressBg = UpdateLayerOwner["resUpProgressBg"]
    loadingResProgressBgPoint = {x = loadingResProgressBg:getPositionX(), y = loadingResProgressBg:getPositionY()}

    local resUpProgressSpr = CCSprite:createWithSpriteFrameName("resUpProgress.png")
    loadingResProgressTmp = CCProgressTimer:create(resUpProgressSpr)
    bg:addChild(loadingResProgressTmp, 4, 0)
    loadingResProgressTmp:setAnchorPoint(ccp(0.5, 0.5))
    loadingResProgressTmp:setPosition(loadingResProgressBgPoint.x, loadingResProgressBgPoint.y)
    loadingResProgressTmp:setType(kCCProgressTimerTypeBar) --kCCProgressTimerTypeHorizontalBarLR
    loadingResProgressTmp:setMidpoint(CCPointMake(0, 0))
    loadingResProgressTmp:setBarChangeRate(CCPointMake(1, 0))

    confirmLayer = UpdateLayerOwner["boxBg"]
    confirmLayer:setVisible(false)

    loadingNote = CCLabelTTF:create(UpTxt.stmp1, "ccbResources/FZCuYuan-M03S.ttf", 25, CCSizeMake(0, 0), kCCTextAlignmentCenter)
    bg:addChild(loadingNote, 0, 0)
    loadingNote:setAnchorPoint(ccp(0.5, 0.5))
    loadingNote:setPosition(loadingResProgressBgPoint.x, loadingResProgressBgPoint.y + 30)
    loadingNote:setColor(ccc3(255, 255, 255))

    -- 开始隐藏 进度条
    loadingResProgressBg:setVisible(false)
    loadingResProgressTmp:setVisible(false)

    -- 按钮文字
    local okMenu = tolua.cast(UpdateLayerOwner["confirmBtn"], "CCMenuItem")
    if okMenu then
        local okLabel = CCLabelTTF:create("OK", "ccbResources/FZCuYuan-M03S.ttf", 30)
        okLabel:setAnchorPoint(ccp(0.5, 0.5))
        okLabel:setPosition(okMenu:getContentSize().width/2, okMenu:getContentSize().height/2)
        okMenu:addChild(okLabel)
    end 
    local cancelMenu = tolua.cast(UpdateLayerOwner["cancelBtn"], "CCMenuItem")
    if cancelMenu then
        local cancelLabel = CCLabelTTF:create("Cancel", "ccbResources/FZCuYuan-M03S.ttf", 30)
        cancelLabel:setAnchorPoint(ccp(0.5, 0.5))
        cancelLabel:setPosition(cancelMenu:getContentSize().width/2, cancelMenu:getContentSize().height/2)
        cancelMenu:addChild(cancelLabel)
    end 

    local okMenu = tolua.cast(UpdateLayerOwner["errorConfirmBtn"], "CCMenuItem")
    if okMenu then
        local okLabel = CCLabelTTF:create("OK", "ccbResources/FZCuYuan-M03S.ttf", 30)
        okLabel:setAnchorPoint(ccp(0.5, 0.5))
        okLabel:setPosition(okMenu:getContentSize().width/2, okMenu:getContentSize().height/2)
        okMenu:addChild(okLabel)
    end 
    local cancelMenu = tolua.cast(UpdateLayerOwner["errorCancelBtn"], "CCMenuItem")
    if cancelMenu then
        local cancelLabel = CCLabelTTF:create("Cancel", "ccbResources/FZCuYuan-M03S.ttf", 30)
        cancelLabel:setAnchorPoint(ccp(0.5, 0.5))
        cancelLabel:setPosition(cancelMenu:getContentSize().width/2, cancelMenu:getContentSize().height/2)
        cancelMenu:addChild(cancelLabel)
    end 

    _updateScene:addChild(_layer)

    loadingResProgressTmp:setVisible(false)
end

function notEnforceUpdateFun()
    -- body
    -- 如果 小版本一样 那么 跳过更新 直接登录
    print(" Print By lixq ---- notEnforceUpdateFun", smallVersion, opVersion)
    if uDefault:getBoolForKey("update_succ") and tostring(smallVersion) == tostring(opVersion) then
        print(" Print By lixq ---- xiao ban ben yi yang !!! ")
        require "lua/util/reqUtil"
        reqFun()
        local repScene = CCScene:create()
        repScene:addChild(LoginLayer())
        CCDirector:sharedDirector():replaceScene(repScene)
        return
    end

    UpdateFileList = {}
    localFile = nil
    diffFile = nil
    -- print(" ---- version.json url ---- ", HostTable.CDN_ROOT_OP2DXUP..smallVersion.."/"..VERSION_JSON)
    local requestItem = CCHttpRequest:open(HostTable.CDN_ROOT_OP2DXUP..smallVersion.."/"..VERSION_JSON, kHttpGet)
    requestItem:sendWithHandler(
    function(res, hnd)
        
        rtnRes = {data = res:getResponseData(), code = res:getResponseCode()}
        -- print("++++++++++"..rtnRes.code)
        -- HTTP code check

        if rtnRes.code == 200 then
            checkUpdate(json.decode(rtnRes.data))
        else
            require "lua/util/reqUtil"
            reqFun()
            local repScene = CCScene:create()
            repScene:addChild(LoginLayer())
            CCDirector:sharedDirector():replaceScene(repScene)
        end
    end)
end

local function enforceUpdateFun( upMsg, upUrl )
    -- 强制更新 清除数据
    Global:instance():updateVersion()

    -- 弹出框
    print(" Print By lixq ---- upMsg ", upMsg, upUrl)
    confirmLayer:setVisible(true)

    local cardContent = UpdateLayerOwner["cardContent"]

    local msgTTF = CCLabelTTF:create(upMsg, "ccbResources/FZCuYuan-M03S", 30, CCSizeMake(cardContent:getContentSize().width - 100, 0), kCCTextAlignmentCenter)
    msgTTF:setPosition(cardContent:getContentSize().width / 2, cardContent:getContentSize().height / 2 + 70)
    msgTTF:setAnchorPoint(ccp(0.5, 0.5))
    msgTTF:setColor(ccc3(255, 255, 255))
    cardContent:addChild(msgTTF, 1)

    -- _updateScene:addChild(bg)
end

-- 返回版本号a是否大于b
-- @params a x.xx
local function verGreater(a, b)
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
    local flag = false
    for i=1,#versA do
        local verA = versA[i]
        if i <= #versB then
            local verB = versB[i]
            flag = tonumber(verA) > tonumber(verB)
        else
            break
        end
        if flag then
            break
        end
    end
    return flag
end

local function getLastVersionCallBack( url, rtnData )
    -- body
    -- print(" Print By lixq ---- getLastVersion ---- ", url)
    -- print(" Print By lixq ---- getLastVersionCallBack ", json.encode(rtnData))
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
    upUrl = ""

    local upFlag = false
    print("CFBundleVersion = ", uDefault:getStringForKey(opPCL.."_ver"))
    if rtnData and rtnData["info"] then
        local versionInfo = rtnData["info"]["appVersionInfo"]
        if versionInfo then
            smallVersion = versionInfo["smallVersion"]
            if versionInfo["bigVersion"] and versionInfo["bigVersion"] ~= "" then
                -- 官方平台
                local CFBundleVersion = uDefault:getStringForKey(opPCL.."_ver")
                if verGreater(tostring(versionInfo["bigVersion"]), CFBundleVersion) then
                    -- 需要强制更新
                    SmallVersion = tostring(opVersion)
                    BigVersion = tostring(versionInfo["bigVersion"])
                    print("version is"..tostring(versionInfo["bigVersion"]), tostring(opVersion))    
                    local cancelBtn = UpdateLayerOwner["cancelBtn"]
                    if cancelBtn then
                        cancelBtn:setEnabled(false)
                    end
                    if versionInfo["bigVersionUrl"] then
                        upFlag = true
                        upUrl = versionInfo["bigVersionUrl"]
                    end
                    upMsg = versionInfo["bigVersionContent"]
                end
            end
        end
    end   

    if upFlag then
        -- 强制更新操作
        print(" Print By lixq ---- enforceUpdateFun ")
        enforceUpdateFun( upMsg, upUrl )
    else
        print(" Print By lixq ---- notEnforceUpdateFun ")
        -- 非强制更新 自动更新启动
        notEnforceUpdateFun()
    end
end

function updateErrorFun( )
    -- body
    require "lua/util/reqUtil"
    reqFun()
    local repScene = CCScene:create()
    repScene:addChild(LoginLayer())
    CCDirector:sharedDirector():replaceScene(repScene)
end

function getLatestVersion()
    doActionNoLoadingFun("GET_LASTEST_VERSION", {opVersion}, getLastVersionCallBack, SERVERCODE.SSO)
end

-- 更新方法
function updateUtilFun(  )
    -- body
    _updateScene = CCScene:create()
    updateUtilUi()

    if opPCL ~= IOS_KY_ZH and opPCL ~= IOS_KYPARK_ZH then
        -- 非第三方平台 获取是否更新
        -- 第三方平台等待自动更新回调之后再调用
        getLatestVersion()
    end

    return _updateScene
end

local function confirmBtnAction()
    -- 强制更新 点击对号 直接跳转
    Global:instance().openURL(upUrl)
end
UpdateLayerOwner["confirmBtnAction"] = confirmBtnAction

local function cancelBtnAction()
    -- 非强制更新 点击对号 开始自动更新
    confirmLayer:removeFromParentAndCleanup(true)
    notEnforceUpdateFun()
end
UpdateLayerOwner["cancelBtnAction"] = cancelBtnAction
