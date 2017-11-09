local _layer
local _conf

local payingItemName

YueKaViewOwner = YueKaViewOwner or {}
ccb["YueKaViewOwner"] = YueKaViewOwner

local currentGoldAmount = 0
-- 刷新UI
local function _refreshYueKa()

    for i=1,3 do
        local dic = _conf[tostring(i)]
        local desp = tolua.cast(YueKaViewOwner["desp"..i],"CCLabelTTF")
        if dic then
            local award = dic.dayAward[1]["amount"]
            desp:setString(HLNSLocalizedString("yueka.desp", award, dic.effectDays, award * dic.effectDays))
        else
            desp:setString("")
        end

        local buyBtn = tolua.cast(YueKaViewOwner["buyBtn"..i],"CCMenuItemImage")
        buyBtn:setTag(i)
        local buyLabel = tolua.cast(YueKaViewOwner["buyLabel"..i],"CCLabelTTF")

        local getBtn = tolua.cast(YueKaViewOwner["getBtn"..i],"CCMenuItemImage")
        getBtn:setTag(i)
        local getLabel = tolua.cast(YueKaViewOwner["getLabel"..i],"CCLabelTTF")
        local time = tolua.cast(YueKaViewOwner["time"..i],"CCLabelTTF")
        if userdata.monthCardData and ((type(userdata.monthCardData.itemId) == "table" 
            and tostring(userdata.monthCardData.itemId["0"]) == tostring(dic.itemId)) 
            or tostring(userdata.monthCardData.itemId) == tostring(dic.itemId))
            and userdata.monthCardData.beginTime + dic.effectDays * (3600 * 24) >= userdata.loginTime then
            -- print(" Print By lixq ---- shizhelime???????")
            buyBtn:setEnabled(false)
            getBtn:setEnabled(true)
            buyLabel:setVisible(false)
            buyBtn:setVisible(false)
            getBtn:setVisible(true)
            getLabel:setVisible(true)
            time:setVisible(true)
            -- local day
            -- 月卡开始当天零时 + 月卡有效期（一个月） - 用户登录当天零时，换算成秒
            -- local sec = DateUtil:beginDay(userdata.monthCardData.beginTime) + dic.effectDays * (3600 * 24) - DateUtil:beginDay(userdata.loginTime) 
            -- if userdata.monthCardData.lastTime and DateUtil:beginDay(userdata.monthCardData.lastTime) == DateUtil:beginDay(userdata.loginTime) then
            --     sec = sec - 3600 * 2428
            -- end
            -- 赵艳秋20150805：月卡剩余天数显示总是少一天，提示改为：第*天，剩余*天
            local curCardSec = DateUtil:beginDay(userdata.loginTime) - DateUtil:beginDay(userdata.monthCardData.beginTime)
            local curCardDay = math.modf(curCardSec / (3600 * 24)) + 1
            if curCardSec / (3600 * 24) + 1 - curCardDay >= 0.5 then
                curCardDay = curCardDay + 1
            end

            local restDays = dic.effectDays - curCardDay
            -- day = math.floor(sec / (3600 * 24))
            -- day = day > 1 and day or 0
            time:setString(string.format(HLNSLocalizedString("yueka.timeLast",curCardDay,restDays)))
        else
            buyBtn:setEnabled(true)
            getBtn:setEnabled(false)
            buyLabel:setVisible(true)
            buyBtn:setVisible(true)
            getBtn:setVisible(false)
            getLabel:setVisible(false)
            time:setVisible(false)
        end
    end

    if isPlatform(ANDROID_JAGUAR_TC) then
        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("ccbResources/fontPic_2.plist")
        local yueka1 = tolua.cast(YueKaViewOwner["firstyueka"], "CCSprite")
        yueka1:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("NT150.png"))
        
        local yueka2 = tolua.cast(YueKaViewOwner["secondyueka"], "CCSprite")
        yueka2:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("NT500.png")) 

        local yueka3 = tolua.cast(YueKaViewOwner["thirdyueka"], "CCSprite")
        yueka3:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("NT2000.png")) 

        -- local morePayBtn = tolua.cast(YueKaViewOwner["morePayBtn"],"CCMenuItemImage")
        -- local morePayLabel = tolua.cast(YueKaViewOwner["morePayLabel"],"CCLabelTTF")
        -- morePayBtn:setEnabled(true)
        -- morePayBtn:setVisible(true)
        -- morePayLabel:setVisible(true)
    end
   
end

local function buySuccFunc(  )
    _refreshYueKa()
end
local function refreshCallBack( url,rtnData )
    if rtnData.code == 200 then
        userdata:fromDictionary(rtnData.info)
        if userdata.monthCardData then 
            for k,v in pairs(_conf) do
                if tostring(userdata.monthCardData.itemId) == tostring(v.itemId) then
                    if userdata.monthCardData.beginTime + v.effectDays * (3600 * 24) >= userdata.loginTime then
                        local confirmCardLayer = getsimpleConfirmCardLayer()
                        if confirmCardLayer then
                            confirmCardLayer:removeAllChildrenWithCleanup(true)
                            confirmCardLayer = nil
                        end

                        local text = HLNSLocalizedString("yueka.buySucc")
                        CCDirector:sharedDirector():getRunningScene():addChild(createSimpleConfirCardLayer(text), 10000)
                        SimpleConfirmCard.confirmMenuCallBackFun = buySuccFunc
                        SimpleConfirmCard.cancelMenuCallBackFun = buySuccFunc
                    end
                end     
            end
        end
    end
end

local function payCardClose()
    currentGoldAmount = userdata.gold
    doActionFun("FLUSH_PLAYER_DATA",{},refreshCallBack)
end

-- 支付提示弹框
local function _popupPayTipLayer(  )
    local text = HLNSLocalizedString("pay.notgetcoin")
    if isPlatform(ANDROID_91_ZH) then
        text = HLNSLocalizedString("pay.notgetcoin91")
    end
    CCDirector:sharedDirector():getRunningScene():addChild(createSimpleConfirCardLayer(text),100)
    SimpleConfirmCard.confirmMenuCallBackFun = payCardClose
    SimpleConfirmCard.cancelMenuCallBackFun = payCardClose
end

local function checkOrderCallback(url, rtnData)
    -- 预留Mobgame支付完成
end

local function JaguarMonthPaySuccess( ... )
    local orderId, itemId = ...
    -- local function callback(rtnData)
    --     PrintTable(rtnData)
    -- end
    doActionFun("ORDER_ADD_JAGUARGP",{orderId, itemId}, refreshCallBack)
end

function MonthCardThirdPlatformPayUnsuccess( ... )
    -- body
    local function Pay360CallFun( ... )
        -- body
        currentGoldAmount = userdata.gold
        doActionFun("FLUSH_PLAYER_DATA",{},refreshCallBack)
    end
    if onPlatform("TGAME")
    or onPlatform("HTC") then
        local errorCode = ...
        ShowText(errorCode)
    else
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(Pay360CallFun))
        _layer:runAction(seq)
    end
end
 function MonthCardThirdPlatformPaySuccess( ... )
    if isPlatform(IOS_KY_ZH) or isPlatform(IOS_KYPARK_ZH) then
        local array = ...
        if array == "2" then
            currentGoldAmount = userdata.gold
            doActionFun("FLUSH_PLAYER_DATA",{},refreshCallBack)
        end

    elseif isPlatform(IOS_VIETNAM_VI) 
        or isPlatform(IOS_VIETNAM_EN) 
        or isPlatform(IOS_VIETNAM_ENSAGA) 
        or isPlatform(IOS_MOBNAPPLE_EN)
        or isPlatform(IOS_MOB_THAI)
        or isPlatform(ANDROID_VIETNAM_MOB_THAI)
        or isPlatform(ANDROID_VIETNAM_VI)
        or isPlatform(ANDROID_VIETNAM_EN)
        or isPlatform(ANDROID_VIETNAM_EN_ALL)
        or isPlatform(IOS_MOBGAME_SPAIN)
        or isPlatform(ANDROID_MOBGAME_SPAIN)  then

        print("mobgamge pay callback")
        local a, b = ...
        doActionFun("ADD_MOBGAME_ORDER", {a, b}, checkOrderCallback)

    elseif isPlatform(IOS_91_ZH) 
        or isPlatform(ANDROID_91_ZH) 
        or isPlatform(IOS_ITOOLS)
        or isPlatform(IOS_ITOOLSPARK)
        or isPlatform(IOS_IIAPPLE_ZH) 
        or isPlatform(IOS_XYZS_ZH) 
        or isPlatform(ANDROID_XYZS_ZH)
        or isPlatform(IOS_HAIMA_ZH)
        or isPlatform(IOS_AISIPARK_ZH)
        or isPlatform(IOS_DOWNJOYPARK_ZH) 
        or isPlatform(ANDROID_DOWNJOY_ZH) then


        currentGoldAmount = userdata.gold
        doActionFun("FLUSH_PLAYER_DATA",{},refreshCallBack)

    elseif isPlatform(IOS_TBT_ZH) or isPlatform(IOS_TBTPARK_ZH) then

        currentGoldAmount = userdata.gold
        doActionFun("FLUSH_PLAYER_DATA",{},refreshCallBack)

    elseif isPlatform(ANDROID_WDJ_ZH) then

        local function wdjPayCallFun( ... )
            -- body
            currentGoldAmount = userdata.gold
            doActionFun("FLUSH_PLAYER_DATA",{},refreshCallBack)
        end
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(1.0), CCCallFunc:create(wdjPayCallFun))
        _layer:runAction(seq)

    elseif isPlatform(ANDROID_360_ZH)
            or isPlatform(ANDROID_HUAWEI_ZH) then

        print("android 360 pay")
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(1.5), CCCallFunc:create(_popupPayTipLayer))
        _layer:runAction(seq)
        local function Pay360CallFun( ... )
            -- body
            currentGoldAmount = userdata.gold
            doActionFun("FLUSH_PLAYER_DATA",{},refreshCallBack)
        end
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(1.0), CCCallFunc:create(Pay360CallFun))
        _layer:runAction(seq)
    elseif onPlatform("HTC") then

        local orderId, extInfo = ...
        --[[
        local function PayTGameCallFun( ... )
            currentGoldAmount = userdata.gold
            doActionFun("FLUSH_PLAYER_DATA", {}, refreshCallBack)
        end
        --]]
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(1.0), CCCallFunc:create(_popupPayTipLayer))
        _layer:runAction(seq)
    end 
end

-- 快用等待订单回调方法
local function getKYShopOrderKeyCallBack( url,rtnData )
    if rtnData.code == 200 then
        local array = {}
        local content = rtnData["info"]
        array["itemId"] = content["itemId"]
        array["dealseq"] = content["dealseq"]
        array["game"] = content["game"]
        array["gamesvr"] = content["gamesvr"]
        array["signKey"] = content["signKey"]
        array["v"] = content["v"]
        array["paytype"] = content["paytype"]
        array["uid"] = content["uid"]
        array["subject"] = content["subject"]
        array["fee"] = content["fee"]
        array["subject"] = content["subject"]
        array["d"] = content["d"]
        array["sign"] = content["sign"]
        array["serverCode"] = userdata.serverCode
        executePayFun( pTypeKY, array,"MonthCardThirdPlatformPaySuccess")
    else
        ShowText(HLNSLocalizedString("generateorder.field"))
    end
end
-- pp助手订单回调方法
local function getPPShopOrderKeyCallBack( url,rtnData )
    if rtnData.code == 200 then
        local array = {}
        local content = rtnData.info
        array["price"] = content["amount"]
        array["billNo"] = content["billno"]
        array["billTitle"] = content["billno_title"]
        array["roldId"] = content["roleid"]
        array["zoneId"] = content["zooneId"]
        executePayFun( pTypePP, array,"MonthCardThirdPlatformPaySuccess","")
        local text = HLNSLocalizedString("pay.notgetcoin")
        CCDirector:sharedDirector():getRunningScene():addChild(createSimpleConfirCardLayer(text),100)
        SimpleConfirmCard.confirmMenuCallBackFun = payCardClose
        SimpleConfirmCard.cancelMenuCallBackFun = payCardClose
    else
        ShowText(HLNSLocalizedString("生成订单失败"))
    end
end

-- 同步推订单回调方法
local function getTBTShopOrderKeyCallBack( url,rtnData )
    if rtnData.code == 200 then
        local array = {}
        local content = rtnData["info"]
        array["order"] = content["orderNo"]
        array["rmb"] = tonumber(content["orderPrice"])
        array["des"] = content["subject"]
        executePayFun( pTypeTBT, array,"MonthCardThirdPlatformPaySuccess",nil)
        -- local text = HLNSLocalizedString("pay.notgetcoin")
        -- CCDirector:sharedDirector():getRunningScene():addChild(createSimpleConfirCardLayer(text),100)
        -- SimpleConfirmCard.confirmMenuCallBackFun = payCardClose
        -- SimpleConfirmCard.cancelMenuCallBackFun = payCardClose
    else
        ShowText(HLNSLocalizedString("generateorder.field"))
    end
end
-- 91订单回调方法
local function get91ShopOrderKeyCallBack( url,rtnData )
    if rtnData.code == 200 then
        local array = {}
        local content = rtnData["info"]
        array["order"] = content["CooOrderSerial"]
        array["id"] = content["GoodsId"]
        array["price"] = tonumber(content["NowMoney"])
        array["OriginalMoney"] = tonumber(content["OriginalMoney"])
        array["count"] = content["GoodsCount"]
        array["name"] = content["GoodsInfo"]
        array["description"] = userdata.serverCode
        executePayFun( pType91pay, array,"MonthCardThirdPlatformPaySuccess",nil)
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(_popupPayTipLayer))
        _layer:runAction(seq)
    else
        ShowText(HLNSLocalizedString("generateorder.field"))
    end
end
-- 小米订单回调方法
local function getxiaomiShopOrderKeyCallBack( url,rtnData )
    if rtnData.code == 200 then
        local array = {}
        local content = rtnData["info"]
        print("content")
        array["order"] = content["cpOrderId"]
        array["price"] = tonumber(content["orderMoney"])
        array["description"] = content["productName"]
        print(array["order"])
        executePayFun( pTypeXIAOMI, array,"MonthCardThirdPlatformPaySuccess",nil)
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(_popupPayTipLayer))
        _layer:runAction(seq)
    else
        ShowText(HLNSLocalizedString("generateorder.field"))
    end
end
-- oppo订单回调方法
local function getoppoShopOrderKeyCallBack( url,rtnData )
    if rtnData.code == 200 then
        local array = {}
        local content = rtnData["info"]
        array["order"] = content["order"]
        array["price"] = content["amount"]
        array["url"] = content["callbackUrl"]
        array["name"] = content["productName"]
        array["description"] = content["productDesc"]
        print(array["order"])
        executePayFun( pTypeOPPO, array,"MonthCardThirdPlatformPaySuccess",nil)
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(_popupPayTipLayer))
        _layer:runAction(seq)
    else
        ShowText(HLNSLocalizedString("generateorder.field"))
    end
end

-- 爱贝 iAppPay 支付回调
local function getIAppPayShopOrderKeyCallBack( url, rtnData )
    if rtnData.code == 200 then
        local array = {}
        local content = rtnData["info"]
        print(" Print By lixq ---- IAppPay detail")
        PrintTable(content)
        array["waresid"] = content["waresid"]
        array["price"] = content["price"]
        -- array["url"] = content["callbackUrl"]
        array["exorderno"] = content["exorderno"]
        array["quantity"] = content["quantity"]
        print(array["order"])
        executePayFun( pTypeIAPPPAY, array, "MonthCardThirdPlatformPaySuccess", nil)
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(_popupPayTipLayer))
        _layer:runAction(seq)
    else
        ShowText(HLNSLocalizedString("generateorder.field"))
    end
end


-- 百度 四核 爱贝 iAppPay 支付回调
local function getBAIDUIAppPayShopOrderKeyCallBack( url, rtnData )
    if rtnData.code == 200 then
        local array = {}
        local content = rtnData["info"]
        print(" Print By lixq ---- IAppPay detail")
        PrintTable(content)
        array["waresid"] = content["waresid"]
        array["price"] = content["price"]
        -- array["url"] = content["callbackUrl"]
        array["exorderno"] = content["exorderno"]
        array["quantity"] = content["quantity"]
        print(array["order"])
        executePayFun( pTypeBAIDUIAPPPAY, array, "MonthCardThirdPlatformPaySuccess", nil)
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(_popupPayTipLayer))
        _layer:runAction(seq)
    else
        ShowText(HLNSLocalizedString("generateorder.field"))
    end
end

-- cool pay 支付回调
local function getCoolPayShopOrderKeyCallBack( url, rtnData )
    if rtnData.code == 200 then
        local array = {}
        local content = rtnData["info"]
        print(" Print By lixq ---- CoolpAY detail")
        PrintTable(content)
        array["waresid"] = content["waresid"]
        array["price"] = content["Price"]
        -- array["url"] = content["callbackUrl"]
        array["exorderno"] = content["Exorderno"]
        array["quantity"] = content["Quantity"]
        print(array["order"])
        executePayFun( pTypeCoolPay, array, "MonthCardThirdPlatformPaySuccess", nil)
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(_popupPayTipLayer))
        _layer:runAction(seq)
    else
        ShowText(HLNSLocalizedString("generateorder.field"))
    end
end

-- 支付宝 AliPay 支付回调
local function getAliPayShopOrderKeyCallBack( url, rtnData )
    if rtnData.code == 200 then
        local array = {}
        local content = rtnData["info"]
        local infos = ""
        array["info"] = infos
        -- array["waresid"] = content["waresid"]
        -- array["price"] = content["price"]
        -- -- array["url"] = content["callbackUrl"]
        -- array["exorderno"] = content["exorderno"]
        -- array["exorderno"] = content["exorderno"]
        -- print(array["order"])
        executePayFun( pTypeAliPay, array, "MonthCardThirdPlatformPaySuccess", nil)
        local text = HLNSLocalizedString("pay.notgetcoin")
        CCDirector:sharedDirector():getRunningScene():addChild(createSimpleConfirCardLayer(text),100)
        SimpleConfirmCard.confirmMenuCallBackFun = payCardClose
        SimpleConfirmCard.cancelMenuCallBackFun = payCardClose
    else
        ShowText(HLNSLocalizedString("generateorder.field"))
    end
end

-- 当乐 downjoy 支付回调
local function getDownJoyPayShopOrderKeyCallBack( url, rtnData )
    if rtnData.code == 200 then
        local array = {}
        local content = rtnData["info"]
        array["money"] = content["amount"]
        array["productName"] = content["productName"]
        array["productDescribe"] = content["productDesc"]
        array["extInfo"] = content["ext"]
        array["order"] = content["ext"] .. "|" .. content["order"]
        array["serverName"] = userdata.serverCode
        array["playerName"] = userdata.userId
        executePayFun( pTypeDownJoy, array, "MonthCardThirdPlatformPaySuccess", nil)
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(_popupPayTipLayer))
        _layer:runAction(seq)
    else
        ShowText(HLNSLocalizedString("generateorder.field"))
    end
end

local function getDOWNJOYShopOrderKeyCallBack(url, rtnData)
    if rtnData.code == 200 then
        local array = {}
        local content = rtnData["info"]
        array["money"] = content["amount"]
        array["productName"] = content["productName"]
        array["productDescribe"] = content["productDesc"]
        array["extInfo"] = content["ext"] .."|".. content["order"]
        executePayFun(pTypeDownJoy, array, "MonthCardThirdPlatformPaySuccess", nil)
    else
        ShowText(HLNSLocalizedString("generateorder.field"))
    end
end
-- uc订单回调方法
local function getucShopOrderKeyCallBack( url,rtnData )
    if rtnData.code == 200 then
        local array = {}
        local content = rtnData["info"]
        array["order"] = content["custOrderId"]
        array["price"] = content["amount"]
        array["id"] = content["productCode"]
        array["name"] = content["productName"]
        array["count"] = content["count"]
        executePayFun( pTypeUC, array,"ThirdPlatformPaySuccess",nil)
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(_popupPayTipLayer))
        _layer:runAction(seq)
    else
        ShowText(HLNSLocalizedString("generateorder.field"))
    end
end
-- MM订单回调方法
local function getMMShopOrderKeyCallBack( url,rtnData )
    if rtnData.code == 200 then
        local array = {}
        local content = rtnData["info"]
        array["paycode"] = content["productCode"]
        array["order"] = content["order"]
        PrintTable("paycode**************"..array["paycode"])
        executePayFun( pTypeMM, array,"ThirdPlatformPaySuccess",nil)
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(_popupPayTipLayer))
        _layer:runAction(seq)
    else
        ShowText(HLNSLocalizedString("generateorder.field"))
    end
end

-- 阿游戏 AGame 支付回调
local function getAGamePayShopOrderKeyCallBack( url, rtnData )
    if rtnData.code == 200 then
        local array = {}
        local content = rtnData["info"]
        print(" Print By lixq ---- AGame detail")
        PrintTable(content)
        array["exorderid"] = content["order"]
        array["callbackUrl"] = content["url"]
        array["price"] = content["amount"]
        array["desp"] = content["productName"]
        -- print(array["order"])
        executePayFun( pTypeAGame, array, "MonthCardThirdPlatformPaySuccess", nil)
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(_popupPayTipLayer))
        _layer:runAction(seq)
    else
        ShowText(HLNSLocalizedString("generateorder.field"))
    end
end

local function getItoolsShopOrderKeyCallBack( url,rtnData )
    if rtnData.code == 200 then
        local array = {}
        local content = rtnData["info"]        
        array["productName"] = payingItemName
        array["itemId"] = content["custOrderId"]
        array["count"] = content["amount"]
        executePayFun( pTypeITOOLS, array,"MonthCardThirdPlatformPaySuccess")
    else
        ShowText(HLNSLocalizedString("generateorder.field"))
    end
end

--豌豆荚 支付回调
local function getWDJShopOrderKeyCallBack( url,rtnData )
    if rtnData.code == 200 then
        local array = {}
        local content = rtnData["info"]
        array["price"] = content["money"]
        array["productname"] = content["desc"]
        array["order"] = content["out_trade_no"]
        
        executePayFun( pTypeWDJ, array,"MonthCardThirdPlatformPaySuccess",nil)
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(_popupPayTipLayer))
        _layer:runAction(seq)
    else
        ShowText(HLNSLocalizedString("generateorder.field"))
    end
end
--360月卡支付回调
local function get360ShopOrderKeyCallBack( url,rtnData )
    if rtnData.code == 200 then
        local array = {}
        local content = rtnData["info"]
        array["token"] = content["accesstoken"]
        array["qihoouserid"] = SSOPlatform.GetUid()
        array["price"] = content["amount"]
        array["rate"] = content["rate"]
        array["productid"] = content["productId"]
        array["productname"] = content["productName"]
        array["notifyuri"] = content["notifyUri"]
        array["appname"] =  ""--content["appname"]
        array["appusername"] = content["appuserName"]
        array["appuserid"] = content["appuserId"]
        array["apporder"] = content["appOrderId"]

        executePayFun( pType360pay, array,"MonthCardThirdPlatformPaySuccess","MonthCardThirdPlatformPayUnsuccess")
        
    else
        ShowText(HLNSLocalizedString("generateorder.field"))
    end
end

local function getDKShopOrderKeyCallBack( url,rtnData )
    if rtnData.code == 200 then
        local array = {}
        local content = rtnData["info"]
        PrintTable(content)
        array["rate"] = content["rate"]
        if content["rate"] == "" or content["rate"] == nil then
            array["rate"] = 100
        end
        
        array["price"] = content["amount"]
        array["productname"] = content["gamebi_name"]
        array["order"] = content["ordered"]

        executePayFun( pTypeDK, array,"ThirdPlatformPaySuccess",nil)
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(_popupPayTipLayer))
        _layer:runAction(seq)
    else
        ShowText(HLNSLocalizedString("generateorder.field"))
    end
end

local function getMMYShopOrderKeyCallBack( url,rtnData )
    if rtnData.code == 200 then
        local array = {}
        local content = rtnData["info"]
        PrintTable(content)
        
        array["name"] = content["name"]
        array["price"] = content["price"]
        array["mount"] = content["mount"]
        array["paydesc"] = content["paydesc"]

        executePayFun(pTypeMMY, array,"MonthCardThirdPlatformPaySuccess","MonthCardThirdPlatformPayUnsuccess")
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(_popupPayTipLayer))
        _layer:runAction(seq)
    else
        ShowText(HLNSLocalizedString("generateorder.field"))
    end
end

local function getANFENGShopOrderKeyCallBack(url, rtnData)
    if rtnData.code == 200 then
        local array = {}
        local content = rtnData["info"]
        array["name"] = content["subject"]
        array["price"] = content["fee"]
        array["order"] = content["vorderid"]
        array["notifyurl"] = content["notify_url"]
        array["paydesc"] = content["body"]
        executePayFun(pTypeANFENG, array, "MonthCardThirdPlatformPaySuccess", "MonthCardThirdPlatformPayUnsuccess")
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(_popupPayTipLayer))
        _layer:runAction(seq)
    else
        ShowText(HLNSLocalizedString("generateorder.field"))
    end
end

local function getGioneePayShopOrderKeyCallBack( url, rtnData )
    if rtnData.code == 200 then
        local array = {}
        local content = rtnData["info"]
        PrintTable(content)
        
        array["apiKey"] = content["api_key"]
        array["outOrderNo"] = content["out_order_no"]
        array["submitTime"] = content["submit_time"]

        executePayFun(pTypeGionee, array,"MonthCardThirdPlatformPaySuccess","MonthCardThirdPlatformPayUnsuccess")
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(_popupPayTipLayer))
        _layer:runAction(seq)
    else
        ShowText(HLNSLocalizedString("generateorder.field"))
    end
end
-- 海马订单回调方法
local function getHAIMAShopOrderKeyCallBack(url, rtnData)
    if rtnData.code == 200 then
        print("----------海马订单----------")
        PrintTable(rtnData.info)
        local array = {}
        local content = rtnData["info"]
        array["orderId"] = content["out_trade_no"]
        array["productPrice"] = tonumber(content["total_fee"])
        array["productName"] = content["subject"]
        array["userParams"] = content["user_param"]
        executePayFun(pTypeHAIMA, array, "MonthCardThirdPlatformPaySuccess","MonthCardThirdPlatformPayUnsuccess")
    else
        ShowText(HLNSLocalizedString("generateorder.field"))
    end
end
local function getAISIPayShopOrderKeyCallBack( url, rtnData )

    if rtnData.code == 200 then
        local array = {}
        local content = rtnData["info"]
        print("getAISIShopOrderKeyCallBack")
        PrintTable(content)
        array["price"] = content["amount"]
        array["orderId"] = content["billno"]
        array["name"] = content["billno_title"]
        array["role"] = content["role"]
        array["zone"] = content["zone"]
        executePayFun(pTypeAISI, array, "MonthCardThirdPlatformPaySuccess","MonthCardThirdPlatformPayUnsuccess")
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(_popupPayTipLayer))
        _layer:runAction(seq)
    else
        ShowText(HLNSLocalizedString("generateorder.field"))
    end
end

local function getHUAWEIPayShopOrderKeyCallBack( url, rtnData )
    if rtnData.code == 200 then
        local array = {}
        local content = rtnData["info"]
        PrintTable(content)
        
        array["amount"] = content["amount"]
        array["appId"] = content["applicationID"]
        array["productDesc"] = content["productDesc"]
        array["requestId"] = content["requestId"]
        array["userId"] = content["userID"]
        array["extReserved"] = content["extReserved"]
        array["productName"] = content["productName"]
        array["sign"] = content["sign"]
        array["accesstoken"] = SSOPlatform.GetToken()

        executePayFun(pTypeHUAWEI, array, "MonthCardThirdPlatformPaySuccess","MonthCardThirdPlatformPayUnsuccess")
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(_popupPayTipLayer))
        _layer:runAction(seq)
    else
        ShowText(HLNSLocalizedString("generateorder.field"))
    end
end

local function thirdPlatformPayAction( item )

    if isPlatform(IOS_KY_ZH) or isPlatform(IOS_KYPARK_ZH) then

        doActionFun("GET_KYSHOP_ORDER_KEY", {item.itemId, 1}, getKYShopOrderKeyCallBack)

    elseif isPlatform(IOS_ITOOLS) or isPlatform(IOS_ITOOLSPARK) then
        payingItemName = item.name

        doActionFun("GET_ITOOLS_ORDER_KEY", {item.itemId, 1}, getItoolsShopOrderKeyCallBack)

    elseif isPlatform(IOS_PPZS_ZH) or isPlatform(IOS_PPZSPARK_ZH) then

        doActionFun("GET_PPSHOP_ORDER_KEY", {item.itemId, 1}, getPPShopOrderKeyCallBack)

    elseif isPlatform(IOS_TBT_ZH) or isPlatform(IOS_TBTPARK_ZH) then

        doActionFun("GET_TBTSHOP_ORDER_KEY", {item.itemId, 1}, getTBTShopOrderKeyCallBack)
       

    elseif isPlatform(ANDROID_360_ZH) then

        doActionFun("GET_360_ORDER_KEY", {item.itemId, 1}, get360ShopOrderKeyCallBack)

    elseif isPlatform(IOS_91_ZH) 
        or isPlatform(ANDROID_91_ZH) then

        doActionFun("GET_91SHOP_ORDER_KEY", {item.itemId, 1}, get91ShopOrderKeyCallBack)

    elseif isPlatform(ANDROID_XIAOMI_ZH) then

        doActionFun("GET_XIAOMISHOP_ORDER_KEY", {item.itemId, 1}, getxiaomiShopOrderKeyCallBack)

    elseif isPlatform(ANDROID_OPPO_ZH) then

        doActionFun("GET_OPPO_ORDER_KEY", {item.itemId, 1}, getoppoShopOrderKeyCallBack)

    elseif isPlatform(ANDROID_UC_ZH) then

        doActionFun("GET_UC_ORDER_KEY", {item.itemId, 1}, getucShopOrderKeyCallBack)

    elseif isPlatform(ANDROID_MM_ZH) then

        doActionFun("GET_MM_ORDER_KEY", {item.itemId, 1}, getMMShopOrderKeyCallBack)

    elseif isPlatform(ANDROID_WDJ_ZH) then

        doActionFun("GET_WDJ_ORDER_KEY", {item.itemId, 1}, getWDJShopOrderKeyCallBack)

    elseif isPlatform(ANDROID_DK_ZH) then

        doActionFun("GET_DK_ORDER_KEY", {item.itemId, 1}, getDKShopOrderKeyCallBack)

    elseif isPlatform(ANDROID_MMY_ZH) then

        doActionFun("GET_MMY_ORDER_KEY", {item.itemId, 1}, getMMYShopOrderKeyCallBack)

    elseif isPlatform(ANDROID_ANFENG_ZH) then

        doActionFun("GET_ANFENG_ORDER_KEY", {item.itemId, 1}, getANFENGShopOrderKeyCallBack)

    elseif isPlatform(ANDROID_HUAWEI_ZH) then

        doActionFun("GET_HUAWEI_ORDER_KEY", {item.itemId, 1}, getHUAWEIPayShopOrderKeyCallBack)

    elseif isPlatform(IOS_APPLE_ZH)
        or isPlatform(IOS_APPLE2_ZH)
        or isPlatform(IOS_INFIPLAY_RUS) then

        local array = {}
        array["productId"] = item.itemId
        array["count"] = "1"
        executePayFun( pTypeAppleIAP, array, "iapPaySucc","iapPayFail")
        userdata:addDCount()

    elseif isPlatform(IOS_VIETNAM_VI) 
        or isPlatform(IOS_VIETNAM_EN) 
        or isPlatform(IOS_VIETNAM_ENSAGA) 
        or isPlatform(IOS_MOBNAPPLE_EN)
        or isPlatform(IOS_MOB_THAI)
        or isPlatform(ANDROID_VIETNAM_MOB_THAI)
        or isPlatform(ANDROID_VIETNAM_VI)
        or isPlatform(ANDROID_VIETNAM_EN)
        or isPlatform(ANDROID_VIETNAM_EN_ALL)
        or isPlatform(IOS_MOBGAME_SPAIN)
        or isPlatform(ANDROID_MOBGAME_SPAIN)  then

        executePayFun(pTypeMobgamePay, {}, "MonthCardThirdPlatformPaySuccess")

    elseif isPlatform(IOS_XYZS_ZH) then
        local array = {}
        array["amount"] = item.price.cash
        array["serverId"] = userdata.serverCode
        array["extra"] = opPCLId.."|"..userdata.serverCode.."|"..item.itemId.."|"..userdata.userId
        executePayFun(pTypeXYZS, array, "MonthCardThirdPlatformPaySuccess")

    elseif isPlatform(ANDROID_BAIDU_ZH) then
        -- 其他支付方式
            doActionFun("GET_IAPPPAY_ORDER_KEY", {item.itemId, 1}, getIAppPayShopOrderKeyCallBack)

    elseif isPlatform(ANDROID_COOLPAY_ZH) then

        doActionFun("GET_COOLPAY_ORDER_KEY", {item.itemId, 1}, getCoolPayShopOrderKeyCallBack)

    elseif isPlatform(ANDROID_BAIDUIAPPPAY_ZH) then

        doActionFun("GET_IAPPPAY_ORDER_KEY", {item.itemId, 1}, getBAIDUIAppPayShopOrderKeyCallBack)

    elseif isPlatform(IOS_HAIMA_ZH) then
        
        doActionFun("GET_HAIMASHOP_ORDER_KEY", {item.itemId, 1}, getHAIMAShopOrderKeyCallBack)
    
    elseif isPlatform(IOS_AISI_ZH) or isPlatform(IOS_AISIPARK_ZH) then

        doActionFun("GET_AISI_ORDER_KEY", {item.itemId, 1}, getAISIPayShopOrderKeyCallBack)

    elseif isPlatform(ANDROID_DOWNJOY_ZH) then

        doActionFun("GET_DJPAY_ORDER_KEY", {item.itemId, 1}, getDownJoyPayShopOrderKeyCallBack)

    elseif isPlatform(IOS_DOWNJOYPARK_ZH) then

        doActionFun("GET_DJPAY_ORDER_KEY", {item.itemId, 1}, getDOWNJOYShopOrderKeyCallBack)

    elseif isPlatform(ANDROID_GV_MFACE_ZH)
        or isPlatform(ANDROID_GV_MFACE_TC) 
        or isPlatform(ANDROID_GV_MFACE_TC_GP) then

        local array = {}
        array["zoneId"] = "aaaa"
        array["roleid"] = "ssss"
        array["moneynum"] = gv_gold_number
        array["extra"] = item.itemId
        executePayFun(pTypeMFACE, array, "MonthCardThirdPlatformPaySuccess", "MonthCardThirdPlatformPayUnsuccess")
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(_popupPayTipLayer))
        _layer:runAction(seq)

    elseif isPlatform(ANDROID_JAGUAR_TC) then
        local array = {}
        array["serverID"] = userdata.serverCode
        array["productId"] = item.itemId
        array["productName"] = item.name
        array["payload"] = userdata.serverCode .. "|" .. userdata.userId .. "|" .. opPCLId .. "|1|2"
        array["source"] = "1"
        executePayFun(pTypeJAGUAR, array, "JaguarMonthPaySuccess", "MonthCardThirdPlatformPayUnsuccess")            
        
    elseif isPlatform(ANDROID_AGAME_ZH) then

        doActionFun("GET_AGAME_ORDER_KEY", {item.itemId, 1}, getAGamePayShopOrderKeyCallBack)
    elseif isPlatform(ANDROID_GIONEE_ZH) then

        doActionFun("GET_GIONEE_ORDER_KEY", {item.itemId, 1}, getGioneePayShopOrderKeyCallBack)
    elseif onPlatform("TGAME")
        or onPlatform("HTC") then

        local array = {}
        array["productId"] = item.itemId
        array["buyNum"] = 1
        array["realPrice"] = item.price.cash
        array["productName"] = item.name
        array["extInfo"] = userdata.serverCode .. "|" .. userdata.userId .. "|" .. opPCLId
        executePayFun(pTypeTGame, array, "MonthCardThirdPlatformPaySuccess", "MonthCardThirdPlatformPayUnsuccess")
        if onPlatform("TGAME") and not userdata.getVipAuditState() then
            local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(_popupPayTipLayer))
            _layer:runAction(seq)
        end   

    elseif isPlatform(IOS_IIAPPLE_ZH) then

        local array = {}
        array["amount"] = item.price.cash
        array["productName"] = item.name
        array["extInfo"] = opPCLId .. "|" .. userdata.serverCode .. "|" .. item.itemId .. "|" .. userdata.userId
        executePayFun(pTypeIIAPPLE, array, "MonthCardThirdPlatformPaySuccess", "MonthCardThirdPlatformPayUnsuccess")
    else
        local urlstr = userdata.selectServer["url"].."/alipay/alipayapi.php?amount=".."1".."&aid="..opPCLId.."&serverId="..userdata.serverCode.."&sid="..userdata.sessionId.."&itemId=".._itemId
        Global:instance():AlixPayweb(urlstr)
        local text = HLNSLocalizedString("pay.notgetcoin")
        CCDirector:sharedDirector():getRunningScene():addChild(createSimpleConfirCardLayer(text), 100)
        SimpleConfirmCard.confirmMenuCallBackFun = payCardClose
        SimpleConfirmCard.cancelMenuCallBackFun = payCardClose
    end
end

-- 苹果iap成功，这时要去后端验证订单
local function IAP_Succ(receipt)
    print("IAP_Succ")
    local function addAppleOrderCallBack( url,rtnData )
        Global:finishIAP()
        if rtnData.info.monthCardData then
            userdata.monthCardData = rtnData.info.monthCardData
        end
        local confirmCardLayer = getsimpleConfirmCardLayer()
        if confirmCardLayer then
            confirmCardLayer:removeAllChildrenWithCleanup(true)
            confirmCardLayer = nil
        end
        _refreshYueKa()
    end 
    doActionFun("ADDAPPLEORDER_URL", {receipt}, addAppleOrderCallBack)
end 

-- 苹果iap失败
local function IAP_Fail(  )
    
end 

local function GetCallBack( url,rtnData )
    -- body
    userdata.monthCardData = rtnData.info.monthCardData
    _refreshYueKa()
    -- if false then -- 最后一次领取
    --     CCDirector:sharedDirector():getRunningScene():addChild(createYuekaSajiaoLayer(), 100)
    -- end
end

local function onGetBtnClick( tag )
    print("onGetBtnClick")
    doActionFun("GET_YUEKA_REWARD", {}, GetCallBack)
end

local function BuyCallBack( url,rtnData )
    -- body
end

local function onBuyBtnClick( tag )
    if isPlatform(ANDROID_MM_ZH) and tag ~= 1 then

        ShowText(HLNSLocalizedString("yueka.TemporaryDnotSupport", ConfigureStorage.levelOpen.league.level))

    else

        -- 验证是否已经购买过月卡
        local bought = false
        for i=1,3 do
            local dic = _conf[tostring(i)]
            if userdata.monthCardData and ((type(userdata.monthCardData.itemId) == "table" 
                and tostring(userdata.monthCardData.itemId["0"]) == tostring(dic.itemId)) 
                or tostring(userdata.monthCardData.itemId) == tostring(dic.itemId))
                and userdata.monthCardData.beginTime + dic.effectDays * (3600 * 24) >= userdata.loginTime then
                bought = true
                break
            end
        end
        if bought then
            ShowText(HLNSLocalizedString("yueka.bought"))
            return
        end

        print("onBuyBtnClick")
        local item = _conf[tostring(tag)]

        if isPlatform(IOS_TEST_ZH) 
            or isPlatform(ANDROID_TEST_ZH) 
            or isPlatform(IOS_APPLE_ZH) 
            or isPlatform(IOS_APPLE2_ZH) 
            or isPlatform(IOS_TW_ZH) 
            or isPlatform(ANDROID_TW_ZH)
            or isPlatform(IOS_INFIPLAY_RUS)
            or isPlatform(ANDROID_INFIPLAY_RUS) then

            if SSOPlatform.IsTourist() then
                getMainLayer():getParent():addChild(createRegisterLayer(_priority - 5),100)
                return 
            end

        end
        -- 调用第三方支付接口
        thirdPlatformPayAction(item)
    end
    
end
YueKaViewOwner["onGetBtnClick"] = onGetBtnClick
YueKaViewOwner["onBuyBtnClick"] = onBuyBtnClick

local function onMorePayBtnClick()
    local array = {}
    array["serverID"] = userdata.serverCode
    array["source"] = "2"
    executePayFun(pTypeJAGUAR, array, "MonthCardThirdPlatformPaySuccess", "MonthCardThirdPlatformPayUnsuccess")
end

YueKaViewOwner["onMorePayBtnClick"] = onMorePayBtnClick

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local proxy = CCBProxy:create()
    local node  = CCBReaderLoad("ccbResources/DailyYuekaView.ccbi", proxy, true,"YueKaViewOwner")
    _layer = tolua.cast(node,"CCLayer")
end

-- 该方法名字每个文件不要重复
function getYueKaLayer()
    return _layer
end

function createYueKaLayer()

    _init()
    _conf = dailyData:getMonthCardConf( )
    _refreshYueKa()

    local function _onEnter()
        addObserver(NOTI_APPLE_IAP_SUCC, IAP_Succ)
        addObserver(NOTI_APPLE_IAP_FAIL, IAP_Fail)
    end

    local function _onExit()
        _layer = nil
        _conf = nil
        payingItemName = nil
        removeObserver(NOTI_APPLE_IAP_SUCC, IAP_Succ)
        removeObserver(NOTI_APPLE_IAP_FAIL, IAP_Fail)
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