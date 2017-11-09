local _layer
local _shareInfo = nil
local _priority = -132

function getAppkeyShareToWeiXin()
    local x = nil
    if isPlatform(IOS_KY_ZH) or isPlatform(IOS_KYPARK_ZH) then
        x = "wxf310159a19449639" -- 快用
    elseif isPlatform(IOS_APPLE_ZH)
        or isPlatform(IOS_APPLE2_ZH) then
        x = "wx46faea25fa0fcfbe" --苹果官方
    elseif isPlatform(IOS_91_ZH) then
        x = "wx679d354366caa372"
    elseif isPlatform(IOS_TBT_ZH) then
        x = "wx50e28600d450d3da"
    elseif isPlatform(IOS_PPZS_ZH) then
        x = "wxb5922a203ccfa1c2"
    else
        x = "wx46faea25fa0fcfbe"
    end
    return x
end

-- 微博和微信的文本
function getSentenceShareToWeiXin()
    local retText = _shareInfo.text.."http://www.hzdw.com"
     return retText
end
function getImageShareToWeiXin()
    local  retPic = _shareInfo.pic
    return retPic
end

-- weibo icon
function getImageShareToWeibo()
    local  retPic = _shareInfo.pic
    return retPic
end
function getUrlShareToWeiXin()
    local  y = "http://www.hzdw.com"
     return y
end
function getUrlShareToFacebook()
    local  y = "http://www.hzdw.com"
     return y
end
--**********************************************add weixin call back end

-- 名字不要重复
ShareOwner = ShareOwner or {}
ccb["ShareOwner"] = ShareOwner

local function closeItemClick()
    popUpCloseAction( ShareOwner,"infoBg",_layer )
end
ShareOwner["closeItemClick"] = closeItemClick

--提示用户先绑定微博页，点绑定按钮的处理方法
local function cardConfirmActionOfShare()
    
    setUDBool(UDefKey.Setting_WeiboShareButtonIsClicked, false)
    Global:instance():ShareTo(1)
    
end

local function onClickedWeibo()

    print("onClickedWeibo")
    print(fileUtil:fullPathForFilename("hero_000304_bust_1.png"))
    if userdata.weiboId ~= nil and userdata.weiboToken ~= nil and userdata.weiboId ~= "" and userdata.weiboToken ~= "" then
        Global:instance():ToShareWeibo()
    else
        print("onClickedWeiboonClickedWeibo")
        
        -- Global:instance():ShareTo(1,_shareInfo.size)
        _layer:addChild(createSimpleConfirCardLayer(Localizable["AlertToBindingToWeibo"]),100)
        SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmActionOfShare
        SimpleConfirmCard.cancelMenuCallBackFun = nil
    end
    
end
ShareOwner["onClickedWeibo"] = onClickedWeibo

-- 购买普通生命牌
local function onClickedWeixin()

    if isPlatform(ANDROID_GV_MFACE_ZH) 
        or isPlatform(ANDROID_GV_MFACE_EN)
        or isPlatform(ANDROID_GV_MFACE_EN_OUMEI)
        or isPlatform(ANDROID_GV_MFACE_EN_OUMEINEW)
        or isPlatform(ANDROID_GV_MFACE_TC) then

        local s = HostTable.CDN_ROOT_OP2DXUP.."1.1/"
        Global:instance():ShareToFacebook(getSentenceShareToWeiXin(),getImageShareToWeiXin(),getUrlShareToFacebook(),s)

    else
        Global:instance():ShareTo(2,_shareInfo.size)
    end
end
ShareOwner["onClickedWeixin"] = onClickedWeixin

local function _refreshUI()
    local sprite = tolua.cast(ShareOwner["sharePic"], "CCSprite")
    if sprite then
        local texture = CCTextureCache:sharedTextureCache():addImage(_shareInfo.pic)
        if texture then
            sprite:setTexture(texture)
        end     
    end 

    local text = tolua.cast(ShareOwner["shareInfo"], "CCLabelTTF")
    if text then 
        if isPlatform(IOS_91_ZH) 
            or isPlatform(ANDROID_91_ZH) then 

            text:setString(_shareInfo.text)

        else 
            text:setString(_shareInfo.text.."http://www.hzdw.com")
        end
    end

    -- tip
    local tipLabel = tolua.cast(ShareOwner["tip"], "CCLabelTTF")
    if tipLabel then
        local silverCount = userdata:getShareSilver()
        if silverCount > 0 then
            tipLabel:setString(HLNSLocalizedString("share.tip", silverCount))
        else 
            tipLabel:setVisible(false)
        end
    end 

    if isPlatform(ANDROID_AGAME_ZH) 
        or isPlatform(ANDROID_GV_MFACE_ZH) 
        or isPlatform(ANDROID_GV_MFACE_EN)
        or isPlatform(ANDROID_GV_MFACE_EN_OUMEI)
        or isPlatform(ANDROID_GV_MFACE_EN_OUMEINEW)
        or isPlatform(ANDROID_GV_MFACE_TC)
        or isPlatform(ANDROID_GV_MFACE_TC_GP) then

        local weiboBtn = tolua.cast(ShareOwner["weiboBtn"],"CCMenuItemImage")
        local weixinBtn = tolua.cast(ShareOwner["weixinBtn"],"CCMenuItemImage")
        local weixinLabel = tolua.cast(ShareOwner["weixinLabel"],"CCLabelTTF")
        local weiboLabel = tolua.cast(ShareOwner["weiboLabel"],"CCLabelTTF")
        weiboBtn:setVisible(false)
        local center = weixinBtn:getParent():getContentSize().width / 2
        weixinBtn:setPosition(ccp(center, weixinBtn:getPositionY()))
        weiboLabel:setVisible(false)
        weixinLabel:setPosition(ccp(center,weixinLabel:getPositionY()))

        if isPlatform(ANDROID_GV_MFACE_ZH) 
            or isPlatform(ANDROID_GV_MFACE_EN)
            or isPlatform(ANDROID_GV_MFACE_EN_OUMEI)
            or isPlatform(ANDROID_GV_MFACE_EN_OUMEINEW)
            or isPlatform(ANDROID_GV_MFACE_TC)
            or isPlatform(ANDROID_GV_MFACE_TC_GP) then

            weixinLabel:setString(HLNSLocalizedString("facebook"))
        end

    end
end 

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/ShareView.ccbi", proxy, true,"ShareOwner")
    _layer = tolua.cast(node,"CCLayer")

    _refreshUI()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(ShareOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then
        popUpCloseAction( ShareOwner,"infoBg",_layer )
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
    local menu1 = tolua.cast(ShareOwner["menu"], "CCMenu")
    menu1:setHandlerPriority(_priority-1)
end

-- 该方法名字每个文件不要重复
function getShareLayer()
    return _layer
end

function createShareLayer(shareInfo, priority)
    _priority = (priority ~= nil) and priority or -132
    _shareInfo = shareInfo
    _init()

    local function _onEnter()
        print("onEnter")
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
        popUpUiAction( ShareOwner,"infoBg" )
    end

    local function _onExit()
        print("onExit")
        _layer = nil
        _shareInfo = nil
        _priority = -132
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