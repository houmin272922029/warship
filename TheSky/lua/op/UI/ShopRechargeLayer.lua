local _layer
local _priority = -132
local _tableView
local _shopData
local haveMoreCell
local stagePhase
local payingItemName

local _bOtherPay = false
local _bOtherPayOption = 0
local otherPayOption = {
    alwaysOtherPay = 0,
    optionalOtherPay = 1
}

local currentGoldAmount = 0
local nowGoldAmount = 0
USER_DOUNIONPAY = 0    --用户进行银联支付
USER_DOCARDPAY = 1     --用户提交了卡类订单
USER_CLOSEVIEW = 2     --用户关闭了支付界面
USER_DOALIPAY = 3       --用户使用了支付宝wap

MorePayBtnTag = 9999

-- 名字不要重复
ShopChargePopUpOwner = ShopChargePopUpOwner or {}
ccb["ShopChargePopUpOwner"] = ShopChargePopUpOwner

-- 更新vip等级礼包领取状态
local function updateVipLevelReward()
    local labelCheckVipButton = tolua.cast(ShopChargePopUpOwner["checkvipprivilegebutton"],"CCMenuItemImage")
    local light = tolua.cast(labelCheckVipButton:getChildByTag(9888), "CCSprite")
    if vipdata:getVipLevel() >= 1 and ((vipdata:bHaveAward() and not light) or ((not vipdata.vipDailyItems or getMyTableCount(vipdata.vipDailyItems) <= 0)and not light)) then
        -- 需要加光环
        local light = CCSprite:createWithSpriteFrameName("lightingEffect_recruitBtn_1.png")
        local animFrames = CCArray:create()
        for j = 1, 3 do
            local frameName = string.format("lightingEffect_recruitBtn_%d.png",j)
            local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(frameName)
            animFrames:addObject(frame)
        end
        local animation = CCAnimation:createWithSpriteFrames(animFrames, 0.3)
        local animate = CCAnimate:create(animation)
        light:runAction(CCRepeatForever:create(animate))
        light:setPosition(ccp(labelCheckVipButton:getContentSize().width / 2, labelCheckVipButton:getContentSize().height / 2 + 2))
        labelCheckVipButton:addChild(light, 1, 9888)
    elseif not vipdata:bHaveAward() and light and (vipdata.vipDailyItems or getMyTableCount(vipdata.vipDailyItems) > 0) then
        -- 需要去掉光环
        light:stopAllActions()
        light:removeFromParentAndCleanup(true)
    end
end

local function refreshCallBack( url,rtnData )
    if rtnData.code == 200 then
        userdata:fromDictionary(rtnData.info)
        nowGoldAmount = userdata.gold

        if nowGoldAmount - currentGoldAmount > 0 then
            -- 添加获得金币的动画
            playEffect(MUSIC_SOUND_CURRENCY)
            local _scene = CCDirector:sharedDirector():getRunningScene()
            local goldNumber = nowGoldAmount - currentGoldAmount
            if goldNumber < 20 then
                HLAddParticleScale( "images/goldDrop_1.plist", _scene, ccp(winSize.width / 2,winSize.height), 1, 110, 1,1,1)
            elseif goldNumber >= 20 and goldNumber < 50 then
                HLAddParticleScale( "images/goldDrop_2.plist", _scene, ccp(winSize.width / 2,winSize.height), 1, 110, 1,1,1)
            elseif goldNumber >= 50 and goldNumber < 300 then
                HLAddParticleScale( "images/goldDrop_3.plist", _scene, ccp(winSize.width / 2,winSize.height), 1, 110, 1,1,1)
            else
                HLAddParticleScale( "images/goldDrop_4.plist", _scene, ccp(winSize.width / 2,winSize.height), 1, 110, 1,1,1)
            end 
            ShowText(HLNSLocalizedString("获得%s金币",goldNumber))
        end

        postNotification(NOTI_GOLD, nil)
        postNotification(NOTI_VIPSCORE, nil)
        postNotification(NOTI_REFLUSH_SHOP_RECHARGE_LAYER,nil)
        postNotification(NOTI_REFRESH_LOGUETOWN, nil)
        
        updateVipLevelReward()
        if getMainLayer() then
            getMainLayer():updateVipLevelReward()
        end
        
    end
end

local function callbackFun(url,params)
        -- print("============wy1233")
        --西班牙打开会飞
        --print(url)
        --PrintTable(params)
        --PrintTable(params.code)
        --PrintTable(params.info)
        if params.code == 200 then
            -- print("============wy123332323")
            --PrintTable(params.info)
            doActionFun("FLUSH_PLAYER_DATA",{}, refreshCallBack)
        end
end

local function checkOrderCallback(url, rtnData)
    -- 预留Mobgame支付完成
end

-- 快用用户支付过程中的一些操作
function ThirdPlatformPayUnsuccess( ... )
    -- body
    local function Pay360CallFun( ... )
        -- body
        currentGoldAmount = userdata.gold
        doActionFun("FLUSH_PLAYER_DATA", {}, refreshCallBack)
    end
    if onPlatform("TGAME")
    or isPlatform(ANDROID_HTC_ZH) then
        local errorCode = ...
        ShowText(errorCode)
    else
        userdata:subDCount()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(Pay360CallFun))
        _layer:runAction(seq)   
    end
end


local function payCardClose()

    if isPlatform(ANDROID_GV_MFACE_ZH) 
        or isPlatform(ANDROID_GV_MFACE_EN)
        or isPlatform(ANDROID_GV_MFACE_EN_OUMEI)
        or isPlatform(ANDROID_GV_MFACE_EN_OUMEINEW)
        or isPlatform(ANDROID_GV_XJP_ZH)
        or isPlatform(ANDROID_GV_MFACE_TC)
        or isPlatform(IOS_GAMEVIEW_TC)
        or isPlatform(IOS_GAMEVIEW_EN)
        or isPlatform(IOS_GVEN_BREAK)
        or isPlatform(ANDROID_GV_MFACE_TC_GP) then

        local function gv_mface_flush( ... )
            currentGoldAmount = userdata.gold
            doActionFun("FLUSH_PLAYER_DATA",{},refreshCallBack)
        end
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.3), CCCallFunc:create(gv_mface_flush))
        _layer:runAction(seq)

    else
        local function laterflush( ... )
            currentGoldAmount = userdata.gold
            doActionFun("FLUSH_PLAYER_DATA",{},refreshCallBack)
        end
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(1), CCCallFunc:create(laterflush))
        _layer:runAction(seq)
    end
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

function jaguarGPPaySucc(...)
    
    local orderId, itemId = ...
    local function callback(rtnData)
        PrintTable(rtnData)
    end
    doActionFun("ORDER_ADD_JAGUARGP",{orderId, itemId}, callback)
end

function jaguarMorePaySucc( ... )
    local function flush( ... )
        currentGoldAmount = userdata.gold
        doActionFun("FLUSH_PLAYER_DATA", {}, refreshCallBack)
    end
    local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.3), CCCallFunc:create(flush))
    _layer:runAction(seq)
end

function ThirdPlatformPaySuccess( ... )
    print("============ThirdPlatformPaySuccess============")
    if isPlatform(IOS_KY_ZH)
        or isPlatform(IOS_KYPARK_ZH) 
        or isPlatform(IOS_ITOOLS)
        or isPlatform(IOS_ITOOLSPARK) 
        or isPlatform(IOS_91_ZH) 
        or isPlatform(ANDROID_91_ZH) 
        or isPlatform(IOS_GAMEVIEW_ZH) 
        or isPlatform(IOS_GAMEVIEW_EN)
        or isPlatform(IOS_GVEN_BREAK)
        or isPlatform(ANDROID_XIAOMI_ZH)
        or isPlatform(ANDROID_WDJ_ZH)
        or isPlatform(ANDROID_360_ZH)
        or isPlatform(IOS_TBT_ZH)
        or isPlatform(IOS_TBTPARK_ZH)
        or isPlatform(IOS_GAMEVIEW_TC)
        or isPlatform(IOS_IIAPPLE_ZH)
        or isPlatform(IOS_HAIMA_ZH)
        or isPlatform(IOS_AISIPARK_ZH)
        or isPlatform(IOS_DOWNJOYPARK_ZH) 
        or isPlatform(ANDROID_DOWNJOY_ZH)
        or isPlatform(IOS_XYZS_ZH) then
        

        -- 360支付在获得支付成功的回调后再弹出未到账请等待的提示框
        if isPlatform(ANDROID_360_ZH) then
            local seq = CCSequence:createWithTwoActions(CCDelayTime:create(1.5), CCCallFunc:create(_popupPayTipLayer))
            _layer:runAction(seq)
        end

        -- 新马苹果的支付未做屏蔽下层按钮所以需要自己加上touch屏蔽，在获得成功回调后去掉屏蔽
        if isPlatform(IOS_GAMEVIEW_ZH) 
            or isPlatform(IOS_GAMEVIEW_EN)
            or isPlatform(IOS_GVEN_BREAK)
            or isPlatform(IOS_GAMEVIEW_TC) then
            userdata:subDCount()
        end
        local function payFun( ... )
            currentGoldAmount = userdata.gold
            doActionFun("FLUSH_PLAYER_DATA",{}, refreshCallBack)
        end
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(payFun))
        _layer:runAction(seq)

    elseif isPlatform(ANDROID_INFIPLAY_RUS) then
            local a, b , c, d, e = ...
            local params = {a, c, d, b, "1"}
            -- PrintTable(params)
            local function gpcallFun( ... )
                local callbackFun = function(url,params)
                    if params.code == 200 then
                        doActionFun("FLUSH_PLAYER_DATA",{}, refreshCallBack)
                        local pDetailsArr = {}
                        table.insert(pDetailsArr, "itemdata")
                        table.insert(pDetailsArr, c)
                        table.insert(pDetailsArr, "sign")
                        table.insert(pDetailsArr, d)
                        --Global:consumeItem(pDetailsArr,table.getn(pDetailsArr))
                    end
                end
                doActionFun("ADD_GOOGLEPLAY_ORDER", {params}, callbackFun)
            end
            --local seq = CCSequence:createWithTwoActions(CCDelayTime:create(5), CCCallFunc:create(gpcallFun))
            --_layer:runAction(seq)
            gpcallFun()
    elseif isPlatform(IOS_VIETNAM_VI) 
        or isPlatform(IOS_VIETNAM_EN) 
        or isPlatform(IOS_VIETNAM_ENSAGA)
        or isPlatform(IOS_MOBNAPPLE_EN)
        or isPlatform(IOS_MOB_THAI)
        or isPlatform(ANDROID_VIETNAM_VI)
        or isPlatform(ANDROID_VIETNAM_EN)
        or isPlatform(ANDROID_VIETNAM_MOB_THAI)
        or isPlatform(ANDROID_VIETNAM_EN_ALL)
        or isPlatform(IOS_MOBGAME_SPAIN)
        or isPlatform(ANDROID_MOBGAME_SPAIN) then

        local a, b = ...
        local function mobPayCallFun( ... )
            -- body
            currentGoldAmount = userdata.gold
            local function errorCallback(  )
                doActionFun("FLUSH_PLAYER_DATA",{},refreshCallBack)
            end
            doActionFun("ADD_MOBGAME_ORDER", {a, b}, checkOrderCallback, errorCallback)
        end
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(1.5), CCCallFunc:create(mobPayCallFun))
        _layer:runAction(seq)

    elseif isPlatform(ANDROID_HTC_ZH) then

        local orderId, extInfo = ...
        --[[
        local function PayTGameCallFun( ... )
            currentGoldAmount = userdata.gold
            doActionFun("FLUSH_PLAYER_DATA",{},refreshCallBack)
        end
        --]]
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(1.0), CCCallFunc:create(_popupPayTipLayer))
        _layer:runAction(seq)
    -- elseif onPlatform("TGAME") then

    --     --Global:instance():TgameonPaymentSucc(tonumber(item.price.cash), item.itemId, "1")
    --     local seq = CCSequence:createWithTwoActions(CCDelayTime:create(1.0), CCCallFunc:create(_popupPayTipLayer))
    --     _layer:runAction(seq)
     end
end

-- 快用等待订单回调方法
local function getKYShopOrderKeyCallBack(url, rtnData)
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
        executePayFun(pTypeKY, array, "ThirdPlatformPaySuccess")
    else
        ShowText(HLNSLocalizedString("generateorder.field"))
    end
end

local function getItoolsShopOrderKeyCallBack(url, rtnData)
    if rtnData.code == 200 then
        local array = {}
        local content = rtnData["info"]
        array["productName"] = payingItemName
        array["itemId"] = content["custOrderId"]
        array["count"] = content["amount"]
        executePayFun(pTypeITOOLS, array, "ThirdPlatformPaySuccess")
    else
        ShowText(HLNSLocalizedString("generateorder.field"))
    end
end

-- pp助手订单回调方法
local function getPPShopOrderKeyCallBack(url, rtnData)
    if rtnData.code == 200 then
        local array = {}
        local content = rtnData.info
        array["price"] = content["amount"]
        array["billNo"] = content["billno"]
        array["billTitle"] = content["billno_title"]
        array["roldId"] = content["roleid"]
        array["zoneId"] = content["zooneId"]
        executePayFun(pTypePP, array, "ThirdPlatformPaySuccess", "")
        local text = HLNSLocalizedString("pay.notgetcoin")
        CCDirector:sharedDirector():getRunningScene():addChild(createSimpleConfirCardLayer(text), 100)
        SimpleConfirmCard.confirmMenuCallBackFun = payCardClose
        SimpleConfirmCard.cancelMenuCallBackFun = payCardClose
    else
        ShowText(HLNSLocalizedString("生成订单失败"))
    end
end

-- 同步推订单回调方法
local function getTBTShopOrderKeyCallBack(url, rtnData)
    if rtnData.code == 200 then
        local array = {}
        local content = rtnData["info"]
        array["order"] = content["orderNo"]
        array["rmb"] = tonumber(content["orderPrice"])
        array["des"] = content["subject"]
        executePayFun(pTypeTBT, array, "ThirdPlatformPaySuccess", nil)
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
        executePayFun(pTypeHAIMA, array, "ThirdPlatformPaySuccess", nil)
    else
        ShowText(HLNSLocalizedString("generateorder.field"))
    end
end
-- 91订单回调方法
local function get91ShopOrderKeyCallBack(url, rtnData)
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
        executePayFun(pType91pay, array, "ThirdPlatformPaySuccess", nil)
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(_popupPayTipLayer))
        _layer:runAction(seq)
    else
        ShowText(HLNSLocalizedString("generateorder.field"))
    end
end

-- 小米订单回调方法
local function getxiaomiShopOrderKeyCallBack(url, rtnData)
    if rtnData.code == 200 then
        local array = {}
        local content = rtnData["info"]
        array["order"] = content["cpOrderId"]
        array["price"] = tonumber(content["orderMoney"])
        array["description"] = content["productName"]
        executePayFun(pTypeXIAOMI, array, "ThirdPlatformPaySuccess", nil)
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(_popupPayTipLayer))
        _layer:runAction(seq)
    else
        ShowText(HLNSLocalizedString("generateorder.field"))
    end
end
-- oppo订单回调方法
local function getoppoShopOrderKeyCallBack(url, rtnData)
    if rtnData.code == 200 then
        local array = {}
        local content = rtnData["info"]
        array["order"] = content["order"]
        array["price"] = content["amount"]
        array["url"] = content["callbackUrl"]
        array["name"] = content["productName"]
        array["description"] = content["productDesc"]
        executePayFun(pTypeOPPO, array, "ThirdPlatformPaySuccess", nil)
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(_popupPayTipLayer))
        _layer:runAction(seq)
    else
        ShowText(HLNSLocalizedString("generateorder.field"))
    end
end

-- 爱贝 iAppPay 支付回调
local function getIAppPayShopOrderKeyCallBack(url, rtnData)
    if rtnData.code == 200 then
        local array = {}
        local content = rtnData["info"]
        array["waresid"] = content["waresid"]
        array["price"] = content["price"]
        array["exorderno"] = content["exorderno"]
        array["quantity"] = content["quantity"]
        executePayFun(pTypeIAPPPAY, array, "ThirdPlatformPaySuccess", nil)
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(_popupPayTipLayer))
        _layer:runAction(seq)
    else
        ShowText(HLNSLocalizedString("generateorder.field"))
    end
end

-- CoolPay 支付回调
local function getCoolPayShopOrderKeyCallBack( url, rtnData )
    if rtnData.code == 200 then
        local array = {}
        local content = rtnData["info"]
        print(" Print By lixq ---- IAppPay detail")
        PrintTable(content)
        array["waresid"] = content["waresid"]
        array["price"] = content["Price"]
        -- array["url"] = content["callbackUrl"]
        array["exorderno"] = content["Exorderno"]
        array["quantity"] = content["Quantity"]
        print(array["order"])
        executePayFun( pTypeCoolPay, array, "ThirdPlatformPaySuccess", nil)
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(_popupPayTipLayer))
        _layer:runAction(seq)
    else
        ShowText(HLNSLocalizedString("generateorder.field"))
    end
end

-- 爱贝 iAppPay 支付回调
local function getBAIDUIAppPayShopOrderKeyCallBack(url, rtnData)
    if rtnData.code == 200 then
        local array = {}
        local content = rtnData["info"]
        array["waresid"] = content["waresid"]
        array["price"] = content["price"]
        array["exorderno"] = content["exorderno"]
        array["quantity"] = content["quantity"]
        executePayFun(pTypeBAIDUIAPPPAY, array, "ThirdPlatformPaySuccess", nil)
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(_popupPayTipLayer))
        _layer:runAction(seq)
    else
        ShowText(HLNSLocalizedString("generateorder.field"))
    end
end

-- 支付宝 alipay 支付回调
local function getAliPayShopOrderKeyCallBack(url, rtnData)
    if rtnData.code == 200 then
        local array = {}
        local content = rtnData["info"]
        local infos = ""
        array["info"] = infos
        executePayFun(pTypeAliPay, array, "ThirdPlatformPaySuccess", nil)
        local text = HLNSLocalizedString("pay.notgetcoin")
        CCDirector:sharedDirector():getRunningScene():addChild(createSimpleConfirCardLayer(text), 100)
        SimpleConfirmCard.confirmMenuCallBackFun = payCardClose
        SimpleConfirmCard.cancelMenuCallBackFun = payCardClose
    else
        ShowText(HLNSLocalizedString("generateorder.field"))
    end
end

-- 当乐 downjoy 支付回调
local function getDownJoyPayShopOrderKeyCallBack(url, rtnData)
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
        executePayFun(pTypeDownJoy, array, "ThirdPlatformPaySuccess", nil)
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(_popupPayTipLayer))
        _layer:runAction(seq)
    else
        ShowText(HLNSLocalizedString("generateorder.field"))
    end
end
-- uc订单回调方法
local function getucShopOrderKeyCallBack(url, rtnData)
    if rtnData.code == 200 then
        local array = {}
        local content = rtnData["info"]
        array["order"] = content["custOrderId"]
        array["price"] = content["amount"]
        executePayFun(pTypeUC, array, "ThirdPlatformPaySuccess", nil)
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(_popupPayTipLayer))
        _layer:runAction(seq)
    else
        ShowText(HLNSLocalizedString("generateorder.field"))
    end
end
-- MM订单回调方法
local function getMMShopOrderKeyCallBack(url, rtnData)
    if rtnData.code == 200 then
        local array = {}
        local content = rtnData["info"]
        array["paycode"] = content["productCode"]
        array["order"] = content["order"]
        executePayFun(pTypeMM, array, "ThirdPlatformPaySuccess", nil)
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(_popupPayTipLayer))
        _layer:runAction(seq)
    else
        ShowText(HLNSLocalizedString("generateorder.field"))
    end
end

-- 阿游戏 AGame 支付回调
local function getAGamePayShopOrderKeyCallBack(url, rtnData)
    if rtnData.code == 200 then
        local array = {}
        local content = rtnData["info"]
        array["exorderid"] = content["order"]
        array["callbackUrl"] = content["url"]
        array["price"] = content["amount"]
        array["desp"] = content["productName"]
        executePayFun(pTypeAGame, array, "ThirdPlatformPaySuccess", nil)
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(_popupPayTipLayer))
        _layer:runAction(seq)
    else
        ShowText(HLNSLocalizedString("generateorder.field"))
    end
end
--360 支付回调
local function get360ShopOrderKeyCallBack(url, rtnData)
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
        array["appname"] =  " "--content["appname"]
        array["appusername"] = content["appuserName"]
        array["appuserid"] = content["appuserId"]
        array["apporder"] = content["appOrderId"]
        executePayFun( pType360pay, array,"ThirdPlatformPaySuccess","ThirdPlatformPayUnsuccess")
    else
        ShowText(HLNSLocalizedString("generateorder.field"))
    end
end
--豌豆荚 支付回调
local function getWDJShopOrderKeyCallBack(url, rtnData)
    if rtnData.code == 200 then
        local array = {}
        local content = rtnData["info"]
        array["price"] = content["money"]
        array["productname"] = content["desc"]
        array["order"] = content["out_trade_no"]
        executePayFun( pTypeWDJ, array,"ThirdPlatformPaySuccess",nil)
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(_popupPayTipLayer))
        _layer:runAction(seq)
    else
        ShowText(HLNSLocalizedString("generateorder.field"))
    end
end 

local function getDKShopOrderKeyCallBack(url, rtnData)
    if rtnData.code == 200 then
        local array = {}
        local content = rtnData["info"]
        array["rate"] = content["rate"]
        if content["rate"] == "" or content["rate"] == nil then
            array["rate"] = 100
        end
        array["price"] = content["amount"]
        array["productname"] = content["gamebi_name"]
        array["order"] = content["ordered"]
        executePayFun(pTypeDK, array, "ThirdPlatformPaySuccess", nil)
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(_popupPayTipLayer))
        _layer:runAction(seq)
    else
        ShowText(HLNSLocalizedString("generateorder.field"))
    end
end

local function getMMYShopOrderKeyCallBack(url, rtnData)
    if rtnData.code == 200 then
        local array = {}
        local content = rtnData["info"]
        array["name"] = content["productName"]
        array["price"] = content["productPrice"]
        array["mount"] = "1"
        array["paydesc"] = content["productDesc"]
        executePayFun(pTypeMMY, array, "ThirdPlatformPaySuccess", nil)
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(_popupPayTipLayer))
        _layer:runAction(seq)
    else
        ShowText(HLNSLocalizedString("generateorder.field"))
    end
end

local function getAISIShopOrderKeyCallBack(url, rtnData)
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
        executePayFun(pTypeAISI, array, "ThirdPlatformPaySuccess", nil)
        -- local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(_popupPayTipLayer))
        -- _layer:runAction(seq)
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
        executePayFun(pTypeDownJoy, array, "ThirdPlatformPaySuccess", nil)
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
        print("executePayFun")
        executePayFun(pTypeANFENG, array, "ThirdPlatformPaySuccess", nil)
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

        executePayFun(pTypeGionee, array, "ThirdPlatformPaySuccess", nil)
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

        executePayFun(pTypeHUAWEI, array, "ThirdPlatformPaySuccess", nil)
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(_popupPayTipLayer))
        _layer:runAction(seq)
    else
        ShowText(HLNSLocalizedString("generateorder.field"))
    end
end

local function thirdPlatformPayAction(item, tag)

    if isPlatform(IOS_KY_ZH) or isPlatform(IOS_KYPARK_ZH) then

        doActionFun("GET_KYSHOP_ORDER_KEY", {item.itemId, 1, "iphone"}, getKYShopOrderKeyCallBack)

    elseif isPlatform(IOS_ITOOLS) or isPlatform(IOS_ITOOLSPARK) then
        payingItemName = item.name

        doActionFun("GET_ITOOLS_ORDER_KEY",{item.itemId, 1}, getItoolsShopOrderKeyCallBack)

    elseif isPlatform(IOS_PPZS_ZH) or isPlatform(IOS_PPZSPARK_ZH) then

        doActionFun("GET_PPSHOP_ORDER_KEY", {item.itemId, 1}, getPPShopOrderKeyCallBack)

    elseif isPlatform(IOS_TBT_ZH) or isPlatform(IOS_TBTPARK_ZH) then

        doActionFun("GET_TBTSHOP_ORDER_KEY", {item.itemId, 1}, getTBTShopOrderKeyCallBack)

    elseif isPlatform(IOS_HAIMA_ZH) then

        doActionFun("GET_HAIMASHOP_ORDER_KEY", {item.itemId, 1}, getHAIMAShopOrderKeyCallBack)
       
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

    elseif isPlatform(ANDROID_DK_ZH) then

        doActionFun("GET_DK_ORDER_KEY", {item.itemId, 1}, getDKShopOrderKeyCallBack)

    elseif isPlatform(ANDROID_360_ZH) then

        doActionFun("GET_360_ORDER_KEY", {item.itemId, 1}, get360ShopOrderKeyCallBack)

    elseif isPlatform(ANDROID_MMY_ZH) then

        doActionFun("GET_MMY_ORDER_KEY", {item.itemId, 1}, getMMYShopOrderKeyCallBack)

    elseif isPlatform(IOS_AISI_ZH) or isPlatform(IOS_AISIPARK_ZH) then

        doActionFun("GET_AISI_ORDER_KEY", {item.itemId, 1}, getAISIShopOrderKeyCallBack)

    elseif isPlatform(IOS_DOWNJOYPARK_ZH) then

        doActionFun("GET_DJPAY_ORDER_KEY", {item.itemId, 1}, getDOWNJOYShopOrderKeyCallBack)

    elseif isPlatform(ANDROID_ANFENG_ZH) then

        doActionFun("GET_ANFENG_ORDER_KEY", {item.itemId, 1}, getANFENGShopOrderKeyCallBack)

    elseif isPlatform(ANDROID_HUAWEI_ZH) then

        doActionFun("GET_HUAWEI_ORDER_KEY", {item.itemId, 1}, getHUAWEIPayShopOrderKeyCallBack)

    -- todo
    elseif isPlatform(ANDROID_GV_MFACE_ZH) 
        or isPlatform(ANDROID_GV_MFACE_EN) 
        or isPlatform(ANDROID_GV_MFACE_EN_OUMEI)
        or isPlatform(ANDROID_GV_MFACE_EN_OUMEINEW)
        or isPlatform(ANDROID_GV_XJP_ZH)
        or isPlatform(ANDROID_GV_MFACE_TC)
        or isPlatform(ANDROID_GV_MFACE_TC_GP) then
        local  function gv_mface_zh( ... )
            -- body
            local array = {}
            if userdata.serverCode then
                array["zoneId"] = userdata.serverCode
            end
            array["roleid"] = SSOPlatform.GetUid()
            array["moneynum"] = item.gold
            array["extra"] = item.itemId.."|"..userdata.userId.."|"..opPCLId
            executePayFun(pTypeMFACE, array, "ThirdPlatformPaySuccess", nil)
        end
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(gv_mface_zh))
        _layer:runAction(seq)
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(1.0), CCCallFunc:create(_popupPayTipLayer))
        _layer:runAction(seq)

    elseif isPlatform(IOS_GAMEVIEW_ZH) 
        or isPlatform(IOS_GAMEVIEW_EN)
        or isPlatform(IOS_GVEN_BREAK)
        or isPlatform(IOS_GAMEVIEW_TC) then
        local function gv_gameview_zh( ... )
            -- body
            local array = {}
            if userdata.serverCode then
                array["zoneId"] = userdata.serverCode
            end
            array["roleid"] = SSOPlatform.GetUid()
            if _bOtherPayOption == otherPayOption.alwaysOtherPay or (_bOtherPayOption == otherPayOption.optionalOtherPay and _bOtherPay and item== nil) then
                array["Paytype"] = "Molstore"
                array["moneynum"] = item.gold
                array["extra"] = item.itemId.."@"..userdata.userId.."@"..opPCLId
                if not userdata:getVipAuditState() then
                    local text = HLNSLocalizedString("pay.notgetcoin")
                    CCDirector:sharedDirector():getRunningScene():addChild(createSimpleConfirCardLayer(text),100)
                    SimpleConfirmCard.confirmMenuCallBackFun = payCardClose
                    SimpleConfirmCard.cancelMenuCallBackFun = payCardClose
                end
            else
                array["moneynum"] = item.gold
                array["extra"] = item.itemId.."|"..userdata.userId.."|"..opPCLId
                array["Paytype"] = "Apple"
            end
            array["Merchant"] = "merchant"
            executePayFun(pTypeGV, array, "ThirdPlatformPaySuccess", "ThirdPlatformPayUnsuccess")
        end
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(gv_gameview_zh))
        _layer:runAction(seq)
        if not isPlatform(IOS_GVEN_BREAK) then
            userdata:addDCount()
        end

    elseif isPlatform(ANDROID_JAGUAR_TC) then
            --第三方
        if tag == MorePayBtnTag then
            local array = {}
            array["serverID"] = userdata.serverCode
            array["payload"] = userdata.serverCode .."|" .. opPCLId 
            array["source"] = "2"
            executePayFun(pTypeJAGUAR, array, "jaguarMorePaySucc", "ThirdPlatformPayUnsuccess")
        else
            --GP
            local array = {}
            array["serverID"] = userdata.serverCode
            array["productId"] = item.itemId
            array["productName"] = item.name
            array["payload"] = userdata.serverCode .. "|".. userdata.userId .."|" .. opPCLId .. "|1|1"
            array["source"] = "1"
            executePayFun(pTypeJAGUAR, array, "jaguarGPPaySucc", "ThirdPlatformPayUnsuccess")            
        end
        --todo

    elseif isPlatform(ANDROID_WDJ_ZH) then

        doActionFun("GET_WDJ_ORDER_KEY", {item.itemId, 1}, getWDJShopOrderKeyCallBack)

    elseif isPlatform(IOS_APPLE_ZH) then
            -- 9158 使用支付宝        
        if userdata:getVipAuditState() then
            local array = {}
            array["productId"] = item.itemId
            array["count"] = "1"
            executePayFun( pTypeAppleIAP, array, "iapPaySucc","iapPayFail")
            userdata:addDCount()
        else

            local function alipay()
                local url = HostTable.DEFAULT_HOST .. "/alipay/alipayapi.php?aid=" .. opPCLId .. "&sid=" .. 
                    userdata.sessionId .. "&serverId=" .. userdata.serverCode ..  "&itemId=" .. item.itemId .. 
                    "&amount=1"
                Global:instance().openURL(url)
                local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(_popupPayTipLayer))
                _layer:runAction(seq) 
            end
            alipay()
        end

    elseif isPlatform(IOS_APPLE2_ZH)
        or isPlatform(IOS_INFIPLAY_RUS) then

        local array = {}
        array["productId"] = item.itemId
        array["count"] = "1"
        runtimeCache.payCashAmount = string.format("%0.2f", item.price.cash)
        executePayFun( pTypeAppleIAP, array, "iapPaySucc","iapPayFail")
        userdata:addDCount()

    elseif isPlatform(ANDROID_INFIPLAY_RUS) then

        local array = {}
        array["productId"] = item.itemId
        array["count"] = "1"
        runtimeCache.payCashAmount = string.format("%0.2f", item.price.cash)
        executePayFun( pTypeGoogleIAB, array, "googlePaySuccess")
        -- userdata:addDCount()

    elseif isPlatform(IOS_VIETNAM_VI) 
        or isPlatform(IOS_VIETNAM_EN) 
        or isPlatform(IOS_VIETNAM_ENSAGA)
        or isPlatform(IOS_MOBNAPPLE_EN)
        or isPlatform(IOS_MOB_THAI)
        or isPlatform(ANDROID_VIETNAM_VI)
        or isPlatform(ANDROID_VIETNAM_EN)
        or isPlatform(ANDROID_VIETNAM_MOB_THAI)
        or isPlatform(ANDROID_VIETNAM_EN_ALL)
        or isPlatform(IOS_MOBGAME_SPAIN)
        or isPlatform(ANDROID_MOBGAME_SPAIN) then

        executePayFun(pTypeMobgamePay, {}, "ThirdPlatformPaySuccess")

        currentGoldAmount = userdata.gold
        if not userdata:getVipAuditState() then
            local text = HLNSLocalizedString("pay.notgetcoin")
            CCDirector:sharedDirector():getRunningScene():addChild(createSimpleConfirCardLayer(text),10000)
            SimpleConfirmCard.confirmMenuCallBackFun = payCardClose
            SimpleConfirmCard.cancelMenuCallBackFun = payCardClose
        end
    elseif isPlatform(IOS_XYZS_ZH) then
        local array = {}
        array["amount"] = item.price.cash
        -- array["amount"] = "0.01"
        array["serverId"] = userdata.serverCode
        array["extra"] = opPCLId.."|"..userdata.serverCode.."|"..item.itemId.."|"..userdata.userId

        executePayFun(pTypeXYZS, array, "ThirdPlatformPaySuccess", "ThirdPlatformPayUnsuccess")
        -- local text = HLNSLocalizedString("pay.notgetcoin")
        -- CCDirector:sharedDirector():getRunningScene():addChild(createSimpleConfirCardLayer(text),10000)
        -- SimpleConfirmCard.confirmMenuCallBackFun = payCardClose
        -- SimpleConfirmCard.cancelMenuCallBackFun = payCardClose
    

    elseif isPlatform(ANDROID_COOLPAY_ZH) then

        doActionFun("GET_COOLPAY_ORDER_KEY", {item.itemId, 1}, getCoolPayShopOrderKeyCallBack)

    elseif isPlatform(ANDROID_BAIDU_ZH) then
        -- 其他支付方式
        doActionFun("GET_IAPPPAY_ORDER_KEY", {item.itemId, 1}, getIAppPayShopOrderKeyCallBack)

    elseif isPlatform(ANDROID_BAIDUIAPPPAY_ZH) then

        doActionFun("GET_IAPPPAY_ORDER_KEY", {item.itemId, 1}, getBAIDUIAppPayShopOrderKeyCallBack)

    elseif isPlatform(ANDROID_DOWNJOY_ZH) then

        doActionFun("GET_DJPAY_ORDER_KEY", {item.itemId, 1}, getDownJoyPayShopOrderKeyCallBack)

    elseif isPlatform(ANDROID_AGAME_ZH) then

        doActionFun("GET_AGAME_ORDER_KEY", {item.itemId, 1}, getAGamePayShopOrderKeyCallBack)

    elseif onPlatform("TGAME")
        or isPlatform(ANDROID_HTC_ZH) then

        local array = {}
        array["productId"] = item.itemId
        array["buyNum"] = 1
        array["realPrice"] = item.price.cash
        array["productName"] = item.name
        array["extInfo"] = userdata.serverCode .. "|" .. userdata.userId .. "|" .. opPCLId
        executePayFun(pTypeTGame, array, "ThirdPlatformPaySuccess", "ThirdPlatformPayUnsuccess")
        if onPlatform("TGAME") and not userdata.getVipAuditState() then
            local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(_popupPayTipLayer))
            _layer:runAction(seq)
        end   
    elseif isPlatform(ANDROID_GIONEE_ZH) then

        doActionFun("GET_GIONEE_ORDER_KEY", {item.itemId, 1}, getGioneePayShopOrderKeyCallBack)

    elseif isPlatform(WP_VIETNAM_VN) then
        -- doActionFun("GET_GIONEE_ORDER_KEY", {item.itemId, 1}, getGioneePayShopOrderKeyCallBack)
        print("rechage begin~")
        CCDirector:sharedDirector():getRunningScene():addChild(createVNRechargeLayer(moneynum, _priority - 10))
    elseif isPlatform(WP_VIETNAM_EN) then
        -- doActionFun("GET_GIONEE_ORDER_KEY", {item.itemId, 1}, getGioneePayShopOrderKeyCallBack)
        print("rechage begin~")
        CCDirector:sharedDirector():getRunningScene():addChild(createVNRechargeLayer(moneynum, _priority - 10))

    elseif isPlatform(IOS_IIAPPLE_ZH) then

        local array = {}
        array["amount"] = item.price.cash
        array["productName"] = item.name
        array["extInfo"] = opPCLId .. "|" .. userdata.serverCode .. "|" .. item.itemId .. "|" .. userdata.userId
        executePayFun(pTypeIIAPPLE, array, "ThirdPlatformPaySuccess", "ThirdPlatformPayUnsuccess")
    else
        local urlstr = userdata.selectServer["url"].."/alipay/alipayapi.php?amount=".."1".."&aid="..opPCLId.."&serverId="..
            userdata.serverCode.."&sid="..userdata.sessionId.."&itemId="..item.itemId
        Global:instance():AlixPayweb(urlstr)
        local text = HLNSLocalizedString("pay.notgetcoin")
        CCDirector:sharedDirector():getRunningScene():addChild(createSimpleConfirCardLayer(text),100)
        SimpleConfirmCard.confirmMenuCallBackFun = payCardClose
        SimpleConfirmCard.cancelMenuCallBackFun = payCardClose        
    end
end

local function setCanShow()
    if vipdata:isFirstRecharge() then
        -- 是在首充活动充值阶段
        -- 显示一个奖品页面
        haveMoreCell = true
        stagePhase = 0
    else
        -- 得到领奖阶段
        local stage = vipdata:returnRchargePhase( )
        if stage == 1 then
            haveMoreCell = true
        elseif stage == 2 then
            haveMoreCell = true
        elseif stage == 3 then
            haveMoreCell = true
        elseif stage == 4 then
            haveMoreCell = false
        end
        stagePhase = stage
    end
end

local function refreshData()
    -- vip*********
    if userdata:getVipAuditState() then
    else
        local _vipLevel = vipdata:getVipLevel()
        local vipLabel = tolua.cast(ShopChargePopUpOwner["vipLabel"],"CCLabelTTF")
        local str = HLNSLocalizedString("vip.full")

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
            or isPlatform(ANDROID_MOBGAME_SPAIN) 
            or isPlatform(IOS_INFIPLAY_RUS)
            or isPlatform(ANDROID_INFIPLAY_RUS)
            or isPlatform(IOS_TGAME_KR)
            or isPlatform(IOS_TGAME_TC)
            or isPlatform(IOS_TGAME_TH)
            or isPlatform(ANDROID_TGAME_KR)
            or isPlatform(ANDROID_TGAME_KRNEW)
            or isPlatform(ANDROID_TGAME_THAI) 
            or isPlatform(ANDROID_TGAME_TC) then 

            if vipdata:getNextVipNeedGold() ~= -1 then
                str = HLNSLocalizedString("vip.need", _vipLevel, vipdata:getNextVipNeedGold(), _vipLevel + 1)
            end 
        else 
            if vipdata:getVipRMB() ~= -1 then

                if isPlatform(ANDROID_GV_MFACE_ZH)
                    or isPlatform(ANDROID_GV_MFACE_EN) 
                    or isPlatform(ANDROID_GV_MFACE_EN_OUMEI)
                    or isPlatform(ANDROID_GV_MFACE_EN_OUMEINEW)
                    or isPlatform(IOS_GAMEVIEW_ZH) 
                    or isPlatform(IOS_GAMEVIEW_EN) 
                    or isPlatform(IOS_GVEN_BREAK)
                    or isPlatform(ANDROID_GV_XJP_ZH)
                    or isPlatform(ANDROID_GV_MFACE_TC)
                    or isPlatform(IOS_GAMEVIEW_TC)
                    or isPlatform(ANDROID_GV_MFACE_TC_GP) 
                    or isPlatform(IOS_TGAME_TC)
                    or isPlatform(IOS_TGAME_TH)
                    or isPlatform(ANDROID_JAGUAR_TC) 
                    or isPlatform(ANDROID_TGAME_TC) then

                    str = HLNSLocalizedString("mfacevip.need", _vipLevel, vipdata:getVipRMB() * 10, _vipLevel + 1)

                else
                    str = HLNSLocalizedString("vip.need", _vipLevel, vipdata:getVipRMB(), _vipLevel + 1)
                end
                if isPlatform(IOS_91_ZH) or isPlatform(ANDROID_91_ZH) then

                    str = HLNSLocalizedString("vip.need.91", _vipLevel, vipdata:getVipRMB(), _vipLevel + 1)
                end
            end
        end

        vipLabel:setString(str)
    end
end

local function refreshUI()
    setCanShow()
    refreshData()
    _tableView:reloadData()
end

local function closeItemClick()
    popUpCloseAction(ShopChargePopUpOwner, "infoBg", _layer)
end
local function LookUpVipDetail()
    Global:instance():TDGAonEventAndEventData("recharge9")
    if getMainLayer() then
        getMainLayer():getParent():addChild(createVipDetailLayer(_priority - 2), 100) 
        _layer:removeFromParentAndCleanup(true)
    end
end
ShopChargePopUpOwner["closeItemClick"] = closeItemClick
ShopChargePopUpOwner["LookUpVipDetail"] = LookUpVipDetail


local function _addTableView()
    -- 得到数据
    local tableViewLayer = ShopChargePopUpOwner["tableLayer"]

    ShopRechageBottomCellOwner = ShopRechageBottomCellOwner or {}
    ccb["ShopRechageBottomCellOwner"] = ShopRechageBottomCellOwner

    ShopRechargeTopCellOwner = ShopRechargeTopCellOwner or {}
    ccb["ShopRechargeTopCellOwner"] = ShopRechargeTopCellOwner

    _shopData = shopData:getCashShopData()
    -- print("AFTrackerEvent GPpay")
    -- PrintTable(_shopData)

    local function onRechargeBtnTap(tag, sender)
        local item = _shopData[tag]
        if item then
            Global:instance():TDGAonEventAndEventData("recharge_cash_"..item.price.cash)
    
        end
        
        local max = shopData:getMaxRecharge()

        if isPlatform(IOS_TEST_ZH) 
            or isPlatform(ANDROID_TEST_ZH) 
            or isPlatform(IOS_APPLE_ZH)
            or isPlatform(IOS_APPLE2_ZH)
            or isPlatform(IOS_INFIPLAY_RUS)
            or isPlatform(ANDROID_INFIPLAY_RUS)
            or isPlatform(IOS_TW_ZH)
            or isPlatform(ANDROID_TW_ZH) then

            if SSOPlatform.IsTourist() then
                getMainLayer():getParent():addChild(createRegisterLayer(_priority - 5),100)
                return 
            end
        end
        if not (isPlatform(IOS_VIETNAM_VI) 
            or isPlatform(IOS_VIETNAM_EN) 
            or isPlatform(IOS_VIETNAM_ENSAGA)
            or isPlatform(IOS_MOBNAPPLE_EN)
            or isPlatform(IOS_MOB_THAI)
            or isPlatform(ANDROID_VIETNAM_VI)
            or isPlatform(ANDROID_VIETNAM_EN)
            or isPlatform(ANDROID_VIETNAM_MOB_THAI)
            or isPlatform(ANDROID_VIETNAM_EN_ALL)
            or isPlatform(IOS_MOBGAME_SPAIN)
            or isPlatform(ANDROID_MOBGAME_SPAIN)
            or isPlatform(WP_VIETNAM_VN)
            or isPlatform(WP_VIETNAM_EN)) then

            if not userdata:bFirstCashAward() and item and item.gold < max.gold then
                getMainLayer():getParent():addChild(createFirstPurchaseTipsLayer(item, max, _priority - 5), 100)
                return
            end

        end
        -- 调用第三方支付接口
        -- PrintTable(item)
        thirdPlatformPayAction(item, tag)
    end
    ShopRechageBottomCellOwner["onRechargeBtnTap"] = onRechargeBtnTap


    local function firstCashAward(url, rtnData)
        if rtnData.info["firstCashAward2"] then
            vipdata.firstCashAward2 = rtnData.info["firstCashAward2"]
        end
        if rtnData.info["firstCashAward1"] then
            vipdata.firstCashAward1 = rtnData.info["firstCashAward1"]
        end
        refreshUI()
    end

    local function onGetBtnTaped()
        if stagePhase == 1 then
            -- 领金币
            doActionFun("RECHARGE_DOUBLE_GET1", {}, firstCashAward)
        elseif stagePhase == 2 then
            -- 领物品
            doActionFun("RECHARGE_DOUBLE_GET2", {}, firstCashAward)
        end
    end
    ShopRechargeTopCellOwner["onGetBtnTaped"] = onGetBtnTaped

    local function onRefoundTap()
        popUpCloseAction(ShopChargePopUpOwner, "infoBg", _layer)

        if not getMainLayer() then
            CCDirector:sharedDirector():replaceScene(mainSceneFun())
        end
        runtimeCache.dailyPageNum = Daily_PurchaseAward
        getMainLayer():gotoDaily()
    end
    ShopRechargeTopCellOwner["onRefoundTap"] = onRefoundTap
    
    local function onAvatarTaped(tag, sender)
        local item = ConfigureStorage.firstCashAward2[tostring(vipdata:getFirstRechargeKey())].items[tonumber(tag)]
        if item.itemId ~= "silver" and item.itemId ~= "gold" then
            local itemID = item.itemId
            if havePrefix(itemID, "item_") then
                CCDirector:sharedDirector():getRunningScene():addChild(createItemDetailInfoLayer(itemID, _priority - 5, 1, 1), 100)
            elseif havePrefix(itemID, "book") then
                CCDirector:sharedDirector():getRunningScene():addChild(createHandBookSkillDetailLayer(itemID, -140), 100) 
            else
                CCDirector:sharedDirector():getRunningScene():addChild(createEquipInfoLayer(itemID, 2, _priority - 5),100)
            end
        end
    end
    ShopRechargeTopCellOwner["onAvatarTaped"] = onAvatarTaped

    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            if haveMoreCell and a1 == 0 then
                r = CCSizeMake(600, 340)
            else
                r = CCSizeMake(600, 120)
            end
        elseif fn == "cellAtIndex" then
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            --单条数据
            local offset = haveMoreCell and 0 or 1
            local onItem = _shopData[tonumber(a1 + offset)]
            local  proxy = CCBProxy:create()
            local  _hbCell 
            if haveMoreCell and a1 == 0 then
                _hbCell  = tolua.cast(CCBReaderLoad("ccbResources/ShopRechargeTopCell.ccbi", proxy, true, "ShopRechargeTopCellOwner"), "CCLayer")
                local FirstTitle = tolua.cast(ShopRechargeTopCellOwner["FirstTitle"], "CCSprite")
                local getBtn = tolua.cast(ShopRechargeTopCellOwner["getBtn"], "CCMenuItemImage")
                local menu1 = tolua.cast(ShopRechargeTopCellOwner["menu"], "CCMenu")
                if menu1 then
                    menu1:setTouchPriority(_priority - 3)
                end
                local getSprite = tolua.cast(ShopRechargeTopCellOwner["getSprite"], "CCSprite")
                if stagePhase == 0 then
                    -- 仅显示一个奖励页面
                    local goldLabel = tolua.cast(ShopRechargeTopCellOwner["goldLabel"], "CCLabelTTF")
                    local frame = tolua.cast(ShopRechargeTopCellOwner["frame0"], "CCSprite")
                    local avatarSprite0 = tolua.cast(ShopRechargeTopCellOwner["avatarSprite0"], "CCSprite")
                    
                    avatarSprite0:setVisible(true)
                    frame:setVisible(true)
                    goldLabel:setVisible(true)
                    goldLabel:setString(string.format(goldLabel:getString(), userdata:getFirstAwardGoldMult()))
                    for i,v in ipairs(ConfigureStorage.firstCashAward2[tostring(vipdata:getFirstRechargeKey())].items) do
                        local frame = tolua.cast(ShopRechargeTopCellOwner["frame"..i], "CCMenuItemImage")
                        frame:setVisible(true)
                        local avatarSprite = tolua.cast(ShopRechargeTopCellOwner["avatarSprite"..i], "CCSprite")
                        local nameLabel = tolua.cast(ShopRechargeTopCellOwner["nameLabel"..i], "CCLabelTTF")
                        nameLabel:setVisible(true)
                        nameLabel:setString(v.name)
                        local itemId = v.itemId
                        local res = wareHouseData:getItemResource(itemId)
                        frame:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", res.rank)))
                        frame:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", res.rank)))
                        if res.icon then
                            local texture = CCTextureCache:sharedTextureCache():addImage(res.icon)
                            if texture then
                                avatarSprite:setVisible(true)
                                avatarSprite:setTexture(texture)

                            else
                                avatarSprite:setVisible(false)
                            end
                        end
                    end
                elseif stagePhase == 1 then
                    -- 金币未领界面
                    local goldLabel = tolua.cast(ShopRechargeTopCellOwner["goldLabel2"], "CCLabelTTF")
                    local frame = tolua.cast(ShopRechargeTopCellOwner["frame4"], "CCSprite")
                    frame:setVisible(true)
                    goldLabel:setVisible(true)
                    goldLabel:setString(string.format(goldLabel:getString(), userdata:getFirstAwardGoldMult()))
                    getBtn:setVisible(true)
                    getSprite:setVisible(true)
                elseif stagePhase == 2 then
                    -- item未领界面
                    for i,v in ipairs(ConfigureStorage.firstCashAward2[tostring(vipdata:getFirstRechargeKey())].items) do
                        local num = i + 4
                        local frame = tolua.cast(ShopRechargeTopCellOwner["frame"..num], "CCSprite")
                        frame:setVisible(true)
                        local avatarSprite = tolua.cast(ShopRechargeTopCellOwner["avatarSprite"..num], "CCSprite")
                        local nameLabel = tolua.cast(ShopRechargeTopCellOwner["nameLabel"..num], "CCLabelTTF")
                        nameLabel:setVisible(true)
                        nameLabel:setString(v.name)
                        local itemId = v.itemId
                        local res = wareHouseData:getItemResource(itemId)
                        frame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", res.rank)))
                        if res.icon then
                            local texture = CCTextureCache:sharedTextureCache():addImage(res.icon)
                            if texture then
                                avatarSprite:setTexture(texture)
                            else
                                avatarSprite:setVisible(false)
                            end
                        end
                    end
                    getBtn:setVisible(true)
                    getSprite:setVisible(true)
                elseif stagePhase == 3 then
                    -- 有充值返利活动
                    local refoundBtn = tolua.cast(ShopRechargeTopCellOwner["refoundBtn"],"CCMenuItemImage") 
                    local lookSprite = tolua.cast(ShopRechargeTopCellOwner["lookSprite"],"CCSprite")
                    local refoundLabelDesp = tolua.cast(ShopRechargeTopCellOwner["refoundLabelDesp"],"CCLabelTTF")
                    local refondTitle = tolua.cast(ShopRechargeTopCellOwner["refondTitle"],"CCSprite")
                    refondTitle:setVisible(true)
                    refoundBtn:setVisible(true)
                    lookSprite:setVisible(true)
                    refoundLabelDesp:setVisible(true)
                    FirstTitle:setVisible(false)
                elseif stagePhase == 4 then
                    -- 神马也没有
                end
            else 
                _hbCell = tolua.cast(CCBReaderLoad("ccbResources/ShopRechargeBottomCell.ccbi",proxy,true,"ShopRechageBottomCellOwner"),"CCLayer")
                local menu1 = tolua.cast(ShopRechageBottomCellOwner["menu"], "CCMenu")
                if menu1 then
                    menu1:setTouchPriority(_priority - 2)
                end
                local reChargeBtn = tolua.cast(ShopRechageBottomCellOwner["reChargeBtn"],"CCMenuItemImage")
                reChargeBtn:setTag(a1 + offset)

                local label1 = tolua.cast(ShopRechageBottomCellOwner["label1"],"CCLabelTTF")

                if isPlatform(IOS_91_ZH) 
                    or isPlatform(ANDROID_91_ZH) then

                    label1:setString(HLNSLocalizedString("shop.cash.91", onItem.price.cash, onItem.gold))

                elseif isPlatform(ANDROID_GV_MFACE_ZH) 
                    or isPlatform(ANDROID_GV_MFACE_EN) 
                    or isPlatform(ANDROID_GV_MFACE_EN_OUMEI)
                    or isPlatform(ANDROID_GV_MFACE_EN_OUMEINEW)
                    or isPlatform(IOS_GAMEVIEW_ZH) 
                    or isPlatform(IOS_GAMEVIEW_EN) 
                    or isPlatform(IOS_GVEN_BREAK)
                    or isPlatform(ANDROID_GV_XJP_ZH)
                    or isPlatform(ANDROID_GV_MFACE_TC_GP) then
                    label1:setString(HLNSLocalizedString("mfaceshop.cash", onItem.price.cash, onItem.gold))
                    
                elseif isPlatform(IOS_TGAME_TC) or isPlatform(IOS_TGAME_TH) or isPlatform(ANDROID_TGAME_THAI) or isPlatform(ANDROID_TGAME_TC) then
                    label1:setString(HLNSLocalizedString("tgametc.cash", onItem.price.cash, onItem.gold))

                elseif isPlatform(ANDROID_GV_MFACE_TC)
                    or isPlatform(IOS_GAMEVIEW_TC)
                    or isPlatform(ANDROID_GV_MFACE_TC_GP) then
                    label1:setString(onItem.desp)

                elseif isPlatform(ANDROID_JAGUAR_TC) then
                    label1:setString(HLNSLocalizedString("shopJaguar.cash", onItem.price.cash, onItem.gold))
                else
                    label1:setString(HLNSLocalizedString("shop.cash", onItem.price.cash, onItem.gold))
                end

                local label2 = tolua.cast(ShopRechageBottomCellOwner["label2"],"CCLabelTTF")
                if onItem.isSend == 1 then
                    label2:setVisible(true)
                    label2:setString(HLNSLocalizedString("shop.cash.send", onItem.sendAmount))
                end
                if isPlatform(IOS_VIETNAM_VI) 
                    or isPlatform(IOS_VIETNAM_EN) 
                    or isPlatform(IOS_VIETNAM_ENSAGA)
                    or isPlatform(IOS_MOBNAPPLE_EN)
                    or isPlatform(ANDROID_VIETNAM_VI)
                    or isPlatform(IOS_MOB_THAI)
                    or isPlatform(ANDROID_VIETNAM_EN)
                    or isPlatform(ANDROID_VIETNAM_MOB_THAI)
                    or isPlatform(ANDROID_VIETNAM_EN_ALL) 
                    or isPlatform(IOS_MOBGAME_SPAIN)
                    or isPlatform(ANDROID_MOBGAME_SPAIN) then
                    label1:setVisible(false)
                    label2:setVisible(false)
                    reChargeBtn:setPosition(_hbCell:getContentSize().width / 2, _hbCell:getContentSize().height * 0.45)
                end
            end

            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            r = a2
        elseif fn == "numberOfCells" then
            -- Return number of cells
            -- r = 5
            if haveMoreCell then

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

                    r = 2

                else
                    r = getMyTableCount(_shopData) + 1
                end
            else
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

                    r = 1

                else
                    r = getMyTableCount(_shopData)
                end
            end
            --猎豹支付显示UI,当玩家等级达到5时，开启更多支付方式
            -- if isPlatform(ANDROID_JAGUAR_TC) and userdata.level >= 5 then

            --     r = r + 1 
            -- end 
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
    local _mainLayer = getMainLayer()
    local x = 1
    if _mainLayer then

        local tablePosH = 0

        if (isPlatform(IOS_GAMEVIEW_TC) and userdata.level >= 5 or isPlatform(IOS_GVEN_BREAK)) and _bOtherPayOption == otherPayOption.optionalOtherPay and _bOtherPay then
            tablePosH = 120
            
            local  proxy = CCBProxy:create()

            local otherPayCell = tolua.cast(CCBReaderLoad("ccbResources/ShopRechargeBottomCell.ccbi", proxy,true,"ShopRechageBottomCellOwner"),"CCLayer")
            local menu2 = tolua.cast(ShopRechageBottomCellOwner["menu"], "CCMenu")
            if menu2 then
                menu2:setTouchPriority(_priority - 2)
            end
            local reChargeBtnOtherPay = tolua.cast(ShopRechageBottomCellOwner["reChargeBtn"],"CCMenuItemImage")
            reChargeBtnOtherPay:setTag(MorePayBtnTag)
            ShopRechageBottomCellOwner["onRechargeBtnTap"] = onRechargeBtnTap

            local otherPayLabel1 = tolua.cast(ShopRechageBottomCellOwner["label1"],"CCLabelTTF")
            local otherPayLabel2 = tolua.cast(ShopRechageBottomCellOwner["label2"],"CCLabelTTF")

            reChargeBtnOtherPay:setPosition(300, 120 * 0.45)
            reChargeBtnOtherPay:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn3_0.png"))
            reChargeBtnOtherPay:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn3_1.png"))
            reChargeBtnOtherPay:setScaleX(1.5)
            if not _shopData or getMyTableCount(_shopData) <= 0 then                
                otherPayLabel2:setString(HLNSLocalizedString("shop.mface.onlyOtherPay"))
            else
                otherPayLabel2:setString(HLNSLocalizedString("shop.mface.otherPay"))
            end
            otherPayLabel2:setAnchorPoint(ccp(0.5,0.5))
            otherPayLabel2:setPosition(300, 120 * 0.45)
            otherPayLabel2:setHorizontalAlignment(kCCTextAlignmentCenter)
            if not _shopData or getMyTableCount(_shopData) <= 0 then                
                otherPayLabel1:setString(HLNSLocalizedString("shop.mface.onlyOtherPay"))
            else
                otherPayLabel1:setString(HLNSLocalizedString("shop.mface.otherPay"))
            end
            otherPayLabel1:setAnchorPoint(ccp(0.5,0.5))
            otherPayLabel1:setPosition(300, 120 * 0.45)
            otherPayLabel1:setHorizontalAlignment(kCCTextAlignmentCenter)

            otherPayCell:setAnchorPoint(ccp(0,0))
            otherPayCell:setPosition(0,0)
            tableViewLayer:addChild(otherPayCell, 1000)
        end

        local size = CCSizeMake(tableViewLayer:getContentSize().width, tableViewLayer:getContentSize().height * 99 / 100 - tablePosH)  -- 这里是为了在tableview上面显示一个小空出来
        _tableView = LuaTableView:createWithHandler(h, size)
        _tableView:setBounceable(true)
        _tableView:setAnchorPoint(ccp(0,0))
        _tableView:setPosition(0,tablePosH)
        _tableView:setVerticalFillOrder(0)
        tableViewLayer:addChild(_tableView, 1000)
    end
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- if isPlatform(ANDROID_INFIPLAY_RUS) then
    --         local itemListStr = ""
    --         local shopData = shopData:getCashShopData()
    --         PrintTable(shopData)
    --         for i,v in ipairs(shopData) do
    --             --print(i,v)
    --             print(v["itemId"])
    --             -- table.insert(itemList,v["itemId"])

    --             itemListStr = itemListStr..v["itemId"]..","
    --             print("=======123=========="..itemListStr)
    --         end
    --         local pDetailsArr = {}
    --         table.insert(pDetailsArr, "itemList")
    --         table.insert(pDetailsArr, itemListStr)
    --         Global:CheckItemList(pDetailsArr,table.getn(pDetailsArr))
    -- end
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/ShopChargePopUp.ccbi", proxy, true, "ShopChargePopUpOwner")
    _layer = tolua.cast(node,"CCLayer")

    _bOtherPayOption = otherPayOption.optionalOtherPay
    _bOtherPay = true
    if isPlatform(IOS_GVEN_BREAK) then
        _bOtherPayOption = otherPayOption.alwaysOtherPay
        _bOtherPay = false
    end
    if userdata:getVipAuditState() then
        _bOtherPayOption = otherPayOption.optionalOtherPay
        _bOtherPay = false
    end


    refreshData()
    updateVipLevelReward()
    if userdata:getVipAuditState() then
        local labelBewitch = tolua.cast(ShopChargePopUpOwner["bewitch"],"CCLabelTTF")
        labelBewitch:setVisible(not userdata:getVipAuditState())
        local labelCheckVip = tolua.cast(ShopChargePopUpOwner["checkvipprivilegelabel"],"CCLabelTTF")
        labelCheckVip:setVisible(not userdata:getVipAuditState())
        local labelCheckVipButton = tolua.cast(ShopChargePopUpOwner["checkvipprivilegebutton"],"CCMenuItemImage")
        labelCheckVipButton:setVisible(not userdata:getVipAuditState())
    end
end


local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(ShopChargePopUpOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction( ShopChargePopUpOwner,"infoBg",_layer )
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
    
    local menu1 = tolua.cast(ShopChargePopUpOwner["menu"], "CCMenu")
    menu1:setHandlerPriority(_priority - 2)
    
    local tableLayer = tolua.cast(ShopChargePopUpOwner["tableLayer"], "CCLayer")
    tableLayer:setTouchPriority(_priority - 2)

    local sv = tolua.cast(_tableView, "LuaTableView") 
    sv:setTouchPriority(_priority - 2)
end

-- 该方法名字每个文件不要重复
function getShpRechargeLayer()
    return _layer
end

-- 苹果iap成功，这时要去后端验证订单
local function IAP_Succ(receipt)
    local function addAppleOrderCallBack( url,rtnData )
        if rtnData.code == 200 then
            Global:finishIAP()
            userdata.firstCashAward1 = rtnData.info.firstCashAward1
            userdata.firstCashAward2 = rtnData.info.firstCashAward2
            vipdata.firstCashAward1 = rtnData.info["firstCashAward1"]
            vipdata.firstCashAward2 = rtnData.info["firstCashAward2"]
            postNotification(NOTI_GOLD, nil)
            postNotification(NOTI_VIPSCORE, nil)
            postNotification(NOTI_REFLUSH_SHOP_RECHARGE_LAYER,nil)
            postNotification(NOTI_REFRESH_LOGUETOWN, nil)
        end 
    end 
    doActionFun("ADDAPPLEORDER_URL",{receipt}, addAppleOrderCallBack)
end 

-- 苹果iap失败
local function IAP_Fail(  )
    
end 


function googlePaySuccess( ... )
    if isPlatform(ANDROID_INFIPLAY_RUS) or isPlatform(ANDROID_JAGUAR_TC) then
        if vipdata:isFirstRecharge() then
            Global:instance():AFTrackEvent("firstPaySucceed","isFirstPay")
        end
        if isPlatform(ANDROID_INFIPLAY_RUS) then
            Global:instance():ADjustEvent("purchase",runtimeCache.payCashAmount)
        else
            Global:instance():AFTrackEvent("GooglePlayPaySucceed",runtimeCache.payCashAmount)
        end
        runtimeCache.payCashAmount = 0.00
        Global:instance():GATrackEvent("GooglePlay","Pay","recharge",1)

    end
    local a, b , c, d, e = ...
    local params = {a, c, d, b, "1"}
    local function gpcallFun( ... )
       local layer = addSwallowLayer()
        local callbackFun = function(url,params)
            if params.code == 200 then
                -- local function refreshCallBack( url,rtnData )
                --     --print("zjm gpsuccess")
                --     --PrintTable(rtnData)
                --     userdata:fromDictionary(rtnData.info)
                --     postNotification(NOTI_GOLD, nil)
                    
                --     if layer then
                --         layer:removeFromParentAndCleanup(true)
                --         layer = nil
                --     end
                -- end
                doActionFun("FLUSH_PLAYER_DATA",{}, refreshCallBack)
                local pDetailsArr = {}
                table.insert(pDetailsArr, "itemdata")
                table.insert(pDetailsArr, c)
                table.insert(pDetailsArr, "sign")
                table.insert(pDetailsArr, d)
                Global:consumeItem()
            end
        end
        doActionNoLoadingFun("ADD_GOOGLEPLAY_ORDER", {params}, callbackFun)
    end
    gpcallFun()
end

function createShopRechargeLayer(priority)
    _priority = (priority ~= nil) and priority or -138
    _init()

    function _layer:updateVipLevelReward()
        updateVipLevelReward()
    end

    function _layer:thirdPlatformPayAction( item)
        thirdPlatformPayAction( item )
    end

    local function _onEnter()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
        setCanShow()
        _addTableView()
        addObserver(NOTI_REFLUSH_SHOP_RECHARGE_LAYER, refreshUI)
        addObserver(NOTI_APPLE_IAP_SUCC, IAP_Succ)
        addObserver(NOTI_APPLE_IAP_FAIL, IAP_Fail)

        popUpUiAction( ShopChargePopUpOwner,"infoBg" )
    end

    local function _onExit()
        print("退出")
        _layer = nil
        _tableView = nil
        _priority = nil
        _shopData = nil
        _bOtherPay = nil
        _bOtherPayOption = nil
        payingItemName = nil
        removeObserver(NOTI_REFLUSH_SHOP_RECHARGE_LAYER, refreshUI)
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


    _layer:registerScriptTouchHandler(onTouch ,false , _priority ,true )
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end