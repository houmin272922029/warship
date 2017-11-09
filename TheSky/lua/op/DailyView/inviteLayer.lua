local _layer
local _data = nil

local boxidTable = nil   --存储每个宝箱对应的领取奖励的类型，例如，成功邀请5个，10个人、、、
local showBoxNum = 4     --显示宝箱的数量
local editBox = nil

local isQuest = false

InviteViewOwner = InviteViewOwner or {}
ccb["InviteViewOwner"] = InviteViewOwner

-- 刷新UI
local function _refreshUI()

    boxidTable = {}

    local selfCodeLabel = tolua.cast(InviteViewOwner["selfCode"],"CCLabelTTF")

    --显示自己的邀请码
    if selfCodeLabel then
        local selfCode = _data["selfCode"]
        selfCodeLabel:setString(selfCode)
    end

    --显示邀请人数
    local invitedNum = _data["invitedNum"]
    local inviteNumLabel = tolua.cast(InviteViewOwner["invitedNum"],"CCLabelTTF")
    if inviteNumLabel then
        inviteNumLabel:setString(HLNSLocalizedString("已邀请: %d",invitedNum))
    end



    local acceptInviteLabel = tolua.cast(InviteViewOwner["acceptInviteLabel"],"CCLabelTTF")
    local chat_Bg = InviteViewOwner["eidtBoxPos"]
    local receiveInviteBtn = tolua.cast(InviteViewOwner["receiveInviteBtn"],"CCMenuItemImage")
    local receiveInviteLabel = tolua.cast(InviteViewOwner["receiveInviteLabel"],"CCLabelTTF")

    --被邀请
    local isInvited = _data["invited"]
    if isInvited>=1 then
        acceptInviteLabel:setVisible(false)
        chat_Bg:setVisible(false)
        receiveInviteBtn:setVisible(false)
        receiveInviteLabel:setVisible(false)
        if editBox then         --如果存在才设置不可见
            editBox:setVisible(false)
        end
    else
        acceptInviteLabel:setVisible(true)
        if not editBox then     --因为editeBox是全局变量，所以只有为空的时候才需要重新创建一个
            local layerBg = tolua.cast(InviteViewOwner["layerBg"],"CCLayer")
            local editBg = CCScale9Sprite:create("images/grayBg.png")
            editBox = CCEditBox:create(CCSize(chat_Bg:getContentSize().width,chat_Bg:getContentSize().height),editBg)
            editBox:setPosition(ccp(chat_Bg:getPositionX(),chat_Bg:getPositionY()))
            editBox:setAnchorPoint(ccp(0.5, 0.5))
            editBox:setFont("ccbResources/FZCuYuan-M03S.ttf",18*retina)
            layerBg:addChild(editBox)
        end
    end


    -- if isInvited<=0 then

    --     local layerBg = tolua.cast(InviteViewOwner["layerBg"],"CCLayer")
    --     local editBg = CCScale9Sprite:createWithSpriteFrameName("chat_bg.png")
    --     editBox = CCEditBox:create(CCSize(chat_Bg:getContentSize().width,chat_Bg:getContentSize().height),editBg)
    --     editBox:setPosition(ccp(chat_Bg:getPositionX(),chat_Bg:getPositionY()))
    --     editBox:setAnchorPoint(ccp(0.5, 0.5))
    --     editBox:setFont("AmericanTypewriter",18*retina)
    --     layerBg:addChild(editBox)
    -- end

    --获取领取奖励的MenuItem
    local box1 = tolua.cast(InviteViewOwner["boxBtn1"],"CCMenuItemImage")
    local box2 = tolua.cast(InviteViewOwner["boxBtn2"],"CCMenuItemImage")
    local box3 = tolua.cast(InviteViewOwner["boxBtn3"],"CCMenuItemImage")
    local box4 = tolua.cast(InviteViewOwner["boxBtn4"],"CCMenuItemImage")

    --邀请几人标签
    local inviteNumTip1 = tolua.cast(InviteViewOwner["inviteNumTip1"],"CCLabelTTF")
    local inviteNumTip2 = tolua.cast(InviteViewOwner["inviteNumTip2"],"CCLabelTTF")
    local inviteNumTip3 = tolua.cast(InviteViewOwner["inviteNumTip3"],"CCLabelTTF")
    local inviteNumTip4 = tolua.cast(InviteViewOwner["inviteNumTip4"],"CCLabelTTF")

    --领取标签
    local getRewardTips1 = tolua.cast(InviteViewOwner["lingqu_1"],"CCSprite")
    local getRewardTips2 = tolua.cast(InviteViewOwner["lingqu_2"],"CCSprite")
    local getRewardTips3 = tolua.cast(InviteViewOwner["lingqu_3"],"CCSprite")
    local getRewardTips4 = tolua.cast(InviteViewOwner["lingqu_4"],"CCSprite")

    --仅差几人标签
    local jincha_1 = tolua.cast(InviteViewOwner["jincha_1"],"CCLabelTTF")
    local jincha_2 = tolua.cast(InviteViewOwner["jincha_2"],"CCLabelTTF")
    local jincha_3 = tolua.cast(InviteViewOwner["jincha_3"],"CCLabelTTF")
    local jincha_4 = tolua.cast(InviteViewOwner["jincha_4"],"CCLabelTTF")

    --仅差几人背景
    local jincha_bg1 = tolua.cast(InviteViewOwner["jincha_bg1"],"CCSprite")
    local jincha_bg2 = tolua.cast(InviteViewOwner["jincha_bg2"],"CCSprite")
    local jincha_bg3 = tolua.cast(InviteViewOwner["jincha_bg3"],"CCSprite")
    local jincha_bg4 = tolua.cast(InviteViewOwner["jincha_bg4"],"CCSprite")


    --先把所有元素设置不可见，之后根据需求设置可见

    --4个宝箱
    box1:setVisible(false)
    box2:setVisible(false)
    box3:setVisible(false)
    box4:setVisible(false)
    --4个宝箱对应的需要邀请多少人提示
    inviteNumTip1:setVisible(false)
    inviteNumTip2:setVisible(false)
    inviteNumTip3:setVisible(false)
    inviteNumTip4:setVisible(false)
    --“领取”文字
    getRewardTips1:setVisible(false)
    getRewardTips2:setVisible(false)
    getRewardTips3:setVisible(false)
    getRewardTips4:setVisible(false)

    --仅差几人背景文本作为子节点加入到仅差几人背景Sprite中，所以只需要将背景Sprite设置为不可见即可
    jincha_bg1:setVisible(false)
    jincha_bg2:setVisible(false)
    jincha_bg3:setVisible(false)
    jincha_bg4:setVisible(false)


    local _invatationList = _data["invatationList"]
    --根据Table数据的currentTypeAwardInfo["key"]的值进行筛选，规则如下：
    --只有未领取的将会进行记录，并进行显示，显示个数的由showBoxNum决定
    --其中对应的currentTypeAwardInfo["key"]值，即需要邀请多少才能领取奖励，如1、5、10、15等，
    --都将存放于boxidTable,当点击相应按钮时，可读取boxidTable中的数据进行判断
    
    --用于存储要显示多少个宝箱
    local currentIndex = 0    

    --排序后遍历
    for k,currentTypeAwardInfo in pairs(table.sortKey(_invatationList, true)) do
        
        local value = currentTypeAwardInfo["value"]
        if currentIndex <showBoxNum then
        
            if value["taken"]>0 then --已经领取
            else      --不可领取则添加到显示
                if value["canTake"]>0 then
                    --可领取
                else
                    --不可领取
                end
                table.insert(boxidTable,currentTypeAwardInfo["key"])
                -- boxidTable[currentIndex] = k
                currentIndex = currentIndex +1
            end
        end
    end
    --根据currentIndex数值显示相应数量的按钮

    if currentIndex >= 1 then   --显示第一个宝箱
        box1:setVisible(true)
        inviteNumTip1:setString(HLNSLocalizedString("邀请%d人",boxidTable[1]))
        inviteNumTip1:setVisible(true)
        if  _invatationList[boxidTable[1]]["canTake"]>0 then
            getRewardTips1:setVisible(true)
        else
            jincha_bg1:setVisible(true)
            jincha_1:setString(string.format("%d",boxidTable[1]-invitedNum))  
            jincha_1:enableStroke(ccc3(0,0,0), 1)
        end
    end
    if currentIndex >= 2 then   --显示第二个宝箱
        box2:setVisible(true)
        inviteNumTip2:setString(HLNSLocalizedString("邀请%d人",boxidTable[2]))
        inviteNumTip2:setVisible(true)
        if  _invatationList[boxidTable[2]]["canTake"]>0 then
            getRewardTips2:setVisible(true)
        else
            jincha_bg2:setVisible(true)
            jincha_2:setString(string.format("%d",boxidTable[2]-invitedNum))  
            jincha_2:enableStroke(ccc3(0,0,0), 1)
        end
    end


    if currentIndex >=3 then    --显示第三个宝箱
        box3:setVisible(true)
        inviteNumTip3:setString(HLNSLocalizedString("邀请%d人",boxidTable[3]))
        inviteNumTip3:setVisible(true)
        if  _invatationList[boxidTable[3]]["canTake"]>0 then
            getRewardTips3:setVisible(true)
        else
            jincha_bg3:setVisible(true)
            jincha_3:setString(string.format("%d",boxidTable[3]-invitedNum))  
            jincha_3:enableShadow(CCSizeMake(2,-2), 1, 0)
            jincha_3:enableStroke(ccc3(0,0,0), 1)
        end
    end

    if currentIndex >= 4 then   --显示第四个宝箱
        box4:setVisible(true)
        inviteNumTip4:setString(HLNSLocalizedString("邀请%d人",boxidTable[4]))
        inviteNumTip4:setVisible(true)
        if  _invatationList[boxidTable[4]]["canTake"]>0 then
            getRewardTips4:setVisible(true)
        else
            jincha_bg4:setVisible(true)
            jincha_4:setString(string.format("%d",boxidTable[4]-invitedNum))  
            -- jincha_4:enableShadow(CCSizeMake(2,-2), 1, 0)
            jincha_4:enableStroke(ccc3(0,0,0), 1)
        end
    end
    --分享按钮是否显示
    local shareBtn = tolua.cast(InviteViewOwner["weiboBtn"], "CCMenuItemImage")
    local shareText = tolua.cast(InviteViewOwner["shareInviteLabel"], "CCLabelTTF")
    if not isOpenShare(  ) then
            shareBtn:setVisible(false)
            shareText:setVisible(false)
    end 
    
end

-- 通知的回调函数
local function updateUIStatus()

    _data = dailyData:getInviteData()
    if _data then
        _refreshUI()
    else
        print("failed to getInviteData~")
    end
end


local function inviteRewardCallback( url,rtndata )


    if rtndata["code"] == 200 then

        ShowText(HLNSLocalizedString("daily.invite.getRewardSuccess"))
        --兑换奖励后将更新缓存数据，并重新布局
        dailyData:updateInviteData(rtndata["info"]["invite"]) 
        updateUIStatus()
        postNotification(NOTI_DAILY_STATUS, nil)
    else
        ShowText(HLNSLocalizedString("daily.invite.getRewardFailed"))
    end
end

--进入改页面后刷新的回调函数
local function firstFreshCallback( url,rtndata )
    isQuest = false
    print("请求结束")
    if rtndata["code"] == 200 then
        --兑换奖励后将更新缓存数据，并重新布局
        dailyData:updateInviteData(rtndata["info"]["invite"]) 
        updateUIStatus()
    end
end

local function firstRefreshErrorCallBack( url,rtndata )
    isQuest = false
end


--获取邀请奖励方法
local function inviteRewardByIndex(index)

    local rewardKey = boxidTable[index]  --在_invatationList里面对应key值
    if tonumber(rewardKey)>0 then  --领取奖励
        local _invatationList = _data["invatationList"]
        local data = _invatationList[rewardKey]
        local cantake = _invatationList[rewardKey]["canTake"]

        if cantake>0 then   --可以领取
            Global:instance():TDGAonEventAndEventData("cdkey_"..rewardKey)
            doActionFun("DAILY_INVITE_REWARD", {rewardKey}, inviteRewardCallback)
        else
            ShowText(HLNSLocalizedString("daily.invite.inviteNumNotEnough"))
            getMainLayer():addChild(createGetInviteRewardLayer(rewardKey,-150))
        end
    end
end




local function getInvitedAwardCallback(url,rtndata)

    if rtndata["code"] == 200 then
        dailyData:updateInviteData(rtndata["info"]["invite"]) 
        updateUIStatus()    --刷新界面
    end
end

-- 填写他人邀请码
local function receiveInvite()

    -- getInvitedAward
    local invitedNum = editBox:getText()
    if string.len(tostring(invitedNum)) >0 then
        doActionFun("DAILY_GET_INVITE_REWARD", {editBox:getText()}, inviteRewardCallback)
    else
        ShowText(HLNSLocalizedString("daily.invite.inviteNumIsEmpty"))
    end
end
InviteViewOwner["receiveInvite"] = receiveInvite

-- 复制邀请码
local function copyInviteCode()
    local selfCode = _data["selfCode"]
    Global:instance().clipBoardCopy(selfCode)
    ShowText(HLNSLocalizedString("daily.copy.success"))
end
InviteViewOwner["copyInviteCode"] = copyInviteCode

-- 点击宝箱1
local function onBoxClicked1()
   inviteRewardByIndex(1)
end
InviteViewOwner["onBoxClicked1"] = onBoxClicked1

-- 点击宝箱2
local function onBoxClicked2()

    inviteRewardByIndex(2)
end
InviteViewOwner["onBoxClicked2"] = onBoxClicked2

-- 点击宝箱3
local function onBoxClicked3()
    inviteRewardByIndex(3)
end
InviteViewOwner["onBoxClicked3"] = onBoxClicked3

-- 点击宝箱4
local function onBoxClicked4()
   inviteRewardByIndex(4)
end

InviteViewOwner["onBoxClicked4"] = onBoxClicked4


-- 点击微博分享
local function onWeiSharedClicked()
    Global:instance():TDGAonEventAndEventData("shareinvite")
    shareSentence = RandomManager.randomRange(1, 2)%2
    
        local imagepath = "images/sharePic_"..string.format(shareSentence+2)..".jpg"
        local gotshare = 10+shareSentence
        local shareInfo = {pic = fileUtil:fullPathForFilename(imagepath), text = string.format(ConfigureStorage.Share[gotshare]["content"],userdata.selectServer.serverName,_data["selfCode"]), size = 1}
        local sharelayer = createShareLayer(shareInfo, -137)
        CCDirector:sharedDirector():getRunningScene():addChild(sharelayer,100)
    -- Global:instance().clipBoardCopy("微博分享")
end
InviteViewOwner["onWeiboSharedClicked"] = onWeiSharedClicked

-- private方法如果没有上下调用关系可以写在createLayer外面
local function init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/DailyInvite.ccbi",proxy, true,"InviteViewOwner")
    _layer = tolua.cast(node,"CCLayer")

    -- updateUIStatus()
end

function getInviteLayer()
    return _layer
end

function createInviteLayer()

    init()

    -- local inviteLabel = tolua.cast(InviteViewOwner["inviteLabel"],"CCLabelTTF")
    -- inviteLabel:enableStroke(ccc3(0,0,0), 1)

    updateUIStatus()

    --每次进入改页面执行
    function _layer:onEnterFresh()
        if not isQuest then
            print("请求开始")
            doActionFun("DAILY_INVITE_REWARD", {0}, firstFreshCallback,firstRefreshErrorCallBack)
            isQuest = true
        end
    end

    local function _onEnter()
        -- updateUIStatus()
    end

    local function _onExit()
        _layer = nil
        _data = nil
        boxidTable = nil
        editBox = nil
        isQuest = false
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