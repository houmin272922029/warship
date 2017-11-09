--装备的分解、铸造、合成 弗兰奇之家
local _layer
local _data = nil
local _tableView
local bAni

local _enterLayer
local _decomposeLayer 
local _composeLayer
local _NewcomposeLayer 

local _size 
local _cache
local isAnimation = false
local _sellIdArrays = {} --分解界面 所选择的装备
local _sellIdArrays2 = {} --分解界面 所选择的装备 具体数据
local _composeEquip --铸造界面 所选择的装备
local _compoundItems = {
    "whitecost",
    "greencost",
    "bluecost",
    "purplecost",
    "purplecostes",
}
local _compoundItemsDic -- 未使用
local _contentLayer
local _newContentLayer -- 合成界面 材料需求框
local _nowState 
local _inDecomposing = false --在做动画  暂时没用到
local isRestoreBegin = true      -- 是否是还原-开始   true为合成-开始
local _newComposeEquip
local _restoreEquip
local _chanceDic               -- 合成 成功几率 和 消耗的贝里
local FildX = -1
local requireArray = {}
local _showCoverTag
local needEquipCount
local announceLabel
local guide1
local guide2
--以上数据在结尾_onExit都已得到处理  所选装备数据没有释放


DailyDecomposeAndComposeViewOwner = DailyDecomposeAndComposeViewOwner or {}
ccb["DailyDecomposeAndComposeViewOwner"] = DailyDecomposeAndComposeViewOwner
local _owner = DailyDecomposeAndComposeViewOwner

--详情
local function descBtnTaped()
    local desc = ConfigureStorage.equip_message
    if not desc then 
        print("lsf error:get ConfigureStorage.equip_message fail!") 
        desc = {}
    end
    local  function getMyDescription()
        local temp = {}      
        for i=1,getMyTableCount(desc) do
            table.insert(temp, desc[tostring(i)].say)
        end
        return temp
    end
    local description = getMyDescription()
    local contentLayer = MainSceneOwner["contentLayer"]
    getMainLayer():getParent():addChild(createCommonHelpLayer(description, -132))
end
DailyDecomposeAndComposeViewOwner["descBtnTaped"] = descBtnTaped


--铸造界面底下的玩家材料黑框
local function _addTableView()
    local dic = ConfigureStorage.equip_compoundItems --data is like {"greencost": { "itemId":"item_001"},"bluecost": { "itemId":"item_001" },}
    if not dic then
        print("lsf error:get ConfigureStorage.equip_compoundItems fail!") 
        return
    end 
    local width  = _contentLayer:getContentSize().width 
    local height = _contentLayer:getContentSize().height 
    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(  width / 4.5 , height )
        elseif fn == "cellAtIndex" then
            -- Return CCTableViewCell, a1 is cell index (zero based), a2 is dequeued cell (maybe nil)
            -- Do something to create cell  and change the content  
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end

            local costStuff = _compoundItems[a1+1]  --costStuff data like "greencost"
            local stuffItemId = dic[costStuff].itemId  --stuffItemId data like "item_001"
            local itemDic = wareHouseData:getItemConfig(stuffItemId)
            local iconName = itemDic.icon
            print("**lsf costStuff stuffItemId" ,costStuff, stuffItemId)
            local icon
            icon = CCSprite:create(equipdata:getEquipIconByEquipId(iconName))
            icon:setScale(0.36)

            local itemsConfig = ConfigureStorage.item
            local item = itemsConfig[stuffItemId]
            if not item then --如果配置表里没有 stuffItemId 的数据
                item = itemsConfig["item_203"] --月饼
                print( string.format("lsf error:fail to get %s in ConfigureStorage.item " ,stuffItemId))
            end 
            if item.rank >= 4  then
                --紫色材料发光
                HLAddParticleScale( "images/purpleEquip.plist", icon, ccp(icon:getContentSize().width / 2,icon:getContentSize().height / 2), 1, 100, 777, 2 / 0.35 / retina, 2 / 0.35 / retina, 1 )
            end

            local frame = CCSprite:createWithSpriteFrameName(string.format("frame_%d.png", item.rank))
            frame:setAnchorPoint(ccp( 0.5,0.5))
            frame:setPosition(ccp( (width/4.5)/2, height/2))

            frame:addChild(icon)
            local frameSize = frame:getContentSize()
            icon:setAnchorPoint(ccp( 0.5,0.5))
            icon:setPosition(ccp(frameSize.width / 2, frameSize.height / 2))
            
            --添加文字
            local labelTextSize = 20
            if isPlatform(IOS_VIETNAM_VI) 
                or isPlatform(ANDROID_VIETNAM_VI)
                or isPlatform(WP_VIETNAM_EN) then
                labelTextSize = 10 
            end
            -- labelTextSize = labelTextSize /0.36 
            --label  材料数量
            local label = CCLabelTTF:create("", "ccbResources/FZCuYuan-M03S.ttf", labelTextSize)
            local stuffCount = wareHouseData:getItemCountById(stuffItemId) 
            label:setString( "x" ..  tostring( stuffCount))
            if stuffCount > 99999999 then
                label:setString( "x99999999+"  )
            end
            label:setColor(ccc3(221,233,73))
            label:setAnchorPoint(ccp( 0.5,0)) --这段话没用 CCLabelTTF固定Anchor在0.5 0
            -- label:setPosition(frame:getContentSize().width / 2, - frame:getContentSize().height * 0.6)
            label:setPosition(frame:getContentSize().width / 2, - labelTextSize*1.3)
            frame:addChild(label)

            --label2 材料名称
            local label2 = CCLabelTTF:create("", "ccbResources/FZCuYuan-M03S.ttf", labelTextSize)
            local itemName = item.name
            label2:setString( itemName )
            label2:setAnchorPoint(ccp( 0.5,0))
            label2:setPosition(frame:getContentSize().width / 2,  frame:getContentSize().height)
            label2:setColor(ccc3(221,233,73))
            frame:addChild(label2)
            

            a2:addChild(frame, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            r = a2
        elseif fn == "numberOfCells" then
            r = getMyTableCount(_compoundItems) --    除3意思是3个一行
        -- Cell events:
        elseif fn == "cellTouched" then         -- A cell was touched, a1 is cell that be touched. This is not necessary.
        elseif fn == "cellTouchBegan" then      -- A cell is touching, a1 is cell, a2 is CCTouch
        elseif fn == "cellTouchEnded" then      -- A cell was touched, a1 is cell, a2 is CCTouch
        elseif fn == "cellHighlight" then       -- A cell is highlighting, coco2d-x 2.1.3 or above
        elseif fn == "cellUnhighlight" then     -- A cell had been unhighlighted, coco2d-x 2.1.3 or above
        elseif fn == "cellWillRecycle" then     -- A cell will be recycled, coco2d-x 2.1.3 or above
        elseif fn == "scroll" then
            getDailyLayer():pageViewTouchEnabled(false)
        end
        return r
    end)
    local size = CCSizeMake( width, height)  -- 这里是为了在tableview上面显示一个小空出来
    _tableView = LuaTableView:createWithHandler(h, size)
    _tableView:setBounceable(true)
    _tableView:setAnchorPoint(ccp(0,0))
    _tableView:setPosition(0,0)
    _tableView:setVerticalFillOrder(0)
    _tableView:setDirection(0)
    _contentLayer:addChild(_tableView,1000)
    _tableView:reloadData() 
end


local function _setEquipIconAndFrame(equipContent,frame ,equip)
    if equipContent and frame and equip then
        frame:setVisible(true)
        frame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", equipContent.rank)))

        local texture = CCTextureCache:sharedTextureCache():addImage(equipdata:getEquipIconByEquipId( equipContent.icon ))
        if texture then
            equip:setVisible(true)
            equip:setTexture(texture)
        end  
    elseif frame and equip then  -- equipContent为nil
        frame:setVisible(false)
        equip:setVisible(false)
    end
end


-- 刷新分解界面 UI
local function _refreshDecomposeUI()
    local frame = tolua.cast(DailyDecomposeAndComposeViewOwner["frame"],"CCSprite")
    local equip = tolua.cast(DailyDecomposeAndComposeViewOwner["equip"],"CCSprite")
    local multiDecomposeTTF = tolua.cast(_owner["multiDecompose"],"CCLabelTTF")

    if _sellIdArrays and getMyTableCount(_sellIdArrays) > 0  then -- _sellIdArrays可能是 {}
        print("**lsf _sellIdArrays" ,_sellIdArrays[1])
        --显示最好的装备
        local bestEquip 
        bestEquip = _sellIdArrays2[_sellIdArrays[1]].equip
        for k,v in pairs(_sellIdArrays2) do
            if v.equip.rank > bestEquip.rank then
                bestEquip = v.equip
            elseif v.equip.rank == bestEquip.rank and v.equip.silver > bestEquip.silver then
                bestEquip = v.equip
            end
        end
        
        -- 刷新框里的东西
        _setEquipIconAndFrame(bestEquip,frame ,equip)
        --界面中"将分解%d个所选装备" 字样  
        multiDecomposeTTF:setString( HLNSLocalizedString("daily.DC.willMultiDecompose", getMyTableCount(_sellIdArrays) )  )
        multiDecomposeTTF:setVisible(true)
    else
        frame:setVisible(false)
        equip:setVisible(false)
        multiDecomposeTTF:setVisible(false) --界面中"将分解多个所选装备" 字样 隐藏

    end
end

-- 刷新铸造界面 UI
local function _refreshComposeUI()
    local frame = tolua.cast(_owner["c_frame"],"CCSprite")
    local equip = tolua.cast(_owner["c_equip"],"CCSprite")
    _setEquipIconAndFrame(_composeEquip,frame ,equip) --中间的装备框
    _tableView:reloadData()
end

-- 刷新合成界面 UI
local function _refreshNewComposeUI()
    guide1 = tolua.cast(DailyDecomposeAndComposeViewOwner["guide1"], "CCSprite")
    guide2 = tolua.cast(DailyDecomposeAndComposeViewOwner["guide2"], "CCSprite")
    for i=1,2 do
        local guide = tolua.cast(DailyDecomposeAndComposeViewOwner["guide" .. i], "CCSprite")
        guide:stopAllActions()

        local array = CCArray:create()
        array:addObject(CCDelayTime:create(0.25))
        array:addObject(CCFadeTo:create(0.05, 255))
        array:addObject(CCDelayTime:create(0.25))
        local move1 = CCMoveBy:create(0.1, ccp(0, 8))
        local move2 = CCMoveBy:create(0.1, ccp(0, -8))
        local fadeOut = CCFadeTo:create(0.05, 240)
        local spawn1 = CCSpawn:createWithTwoActions(move1, fadeOut)
        local spawn2 = CCSpawn:createWithTwoActions(move2, fadeOut)
        array:addObject(spawn1)
        array:addObject(CCDelayTime:create(0.1))
        array:addObject(spawn2)

        guide:runAction(CCRepeatForever:create(CCSequence:create(array)))
    end
    
    local frame = tolua.cast(DailyDecomposeAndComposeViewOwner["cr_frame"],"CCSprite")
    local equip = tolua.cast(DailyDecomposeAndComposeViewOwner["cr_equip"],"CCSprite")
    local frame1 = tolua.cast(DailyDecomposeAndComposeViewOwner["cr_frame1"],"CCSprite")
    local equip1 = tolua.cast(DailyDecomposeAndComposeViewOwner["cr_equip1"],"CCSprite")
    local constBely = tolua.cast(DailyDecomposeAndComposeViewOwner["constBely"],"CCLabelTTF")
    local successRateLabel = tolua.cast(DailyDecomposeAndComposeViewOwner["successRateLabel"],"CCLabelTTF")
    local rateProgress = tolua.cast(DailyDecomposeAndComposeViewOwner["rateProgress"],"CCLayerColor")

    for i=1,3 do
        local needEquip = tolua.cast(DailyDecomposeAndComposeViewOwner["needEquip"..i],"CCSprite")
        local needEquipFrame = tolua.cast(DailyDecomposeAndComposeViewOwner["needEquipFrame"..i],"CCSprite")
        local menu = tolua.cast(DailyDecomposeAndComposeViewOwner["needEquipClick"..i], "CCMenuItemImage")
        local cover = tolua.cast(DailyDecomposeAndComposeViewOwner["cover"..i],"CCLayerColor")
        needEquip:setVisible(false)
        menu:setEnabled(false)
        needEquipFrame:setVisible(false)
    end
    
    if _restoreEquip then
        _setEquipIconAndFrame(_restoreEquip.equip,frame1 ,equip1)
    end
    if _newComposeEquip then
        -- 合成区域的指引小手
        guide1:setVisible(false)
        guide2:setVisible(true)

        _setEquipIconAndFrame(_newComposeEquip.equip,frame ,equip)
        local chance = _chanceDic.myChance
        local nextAdvanced = _chanceDic.nextAdvanced
        local consume
        local confId = _newComposeEquip.equip.id
        local composeEquipRank = ConfigureStorage.equip[confId].rank
        if composeEquipRank == 3 then
            consume = ConfigureStorage.equip_blue_awave[tostring(nextAdvanced)].expend.silver
            needEquipCount =  ConfigureStorage.equip_blue_awave[tostring(nextAdvanced)].expend.self
        elseif composeEquipRank == 4 then
            consume = ConfigureStorage.equip_pur_awave[tostring(nextAdvanced)].expend.silver
            needEquipCount =  ConfigureStorage.equip_pur_awave[tostring(nextAdvanced)].expend.self
        elseif composeEquipRank == 5 then
            consume = ConfigureStorage.equip_gold_awave[tostring(nextAdvanced)].expend.silver
            needEquipCount =  ConfigureStorage.equip_gold_awave[tostring(nextAdvanced)].expend.self
        end

        constBely:setString(consume)
        constBely:setVisible(true)
        successRateLabel:setString(chance*100 .. "%")
        rateProgress:setScaleX(chance)
        rateProgress:setVisible(true)

        for i=1,3 do
            local needEquip = tolua.cast(DailyDecomposeAndComposeViewOwner["needEquip" .. i],"CCSprite")
            local needEquipFrame = tolua.cast(DailyDecomposeAndComposeViewOwner["needEquipFrame" .. i],"CCSprite")
            local menu = tolua.cast(DailyDecomposeAndComposeViewOwner["needEquipClick" .. i], "CCMenuItemImage")
            local cover = tolua.cast(DailyDecomposeAndComposeViewOwner["cover" .. i],"CCLayerColor")
            local texture = CCTextureCache:sharedTextureCache():addImage(equipdata:getEquipIconByEquipId( _newComposeEquip.equip.icon ))
            local equipId = _newComposeEquip.equip.id 
            needEquipFrame:setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", ConfigureStorage.equip[equipId].rank)))
            needEquip:setTexture(texture)
            needEquip:setVisible(needEquipCount >= i)
            needEquipFrame:setVisible(needEquipCount >= i)
            menu:setEnabled(needEquipCount >= i)
            cover:setVisible(needEquipCount >= i)
        end
    else
        frame:setVisible(false)
        equip:setVisible(false)

        constBely:setVisible(false)
        successRateLabel:setString("0.0%")
        rateProgress:setVisible(false)
    end
    frame:setVisible(false)
    equip:setVisible(false)
    frame1:setVisible(false)
    equip1:setVisible(false)
    
    if isRestoreBegin then
        if _newComposeEquip then
            frame:setVisible(true)
            equip:setVisible(true)
            frame1:setVisible(false)
            equip1:setVisible(false)
        else
            guide1:setVisible(true)
            guide2:setVisible(false)
        end
    else
        guide1:setVisible(false)
        guide2:setVisible(false)
        if _restoreEquip then
            frame:setVisible(false)
            equip:setVisible(false)
            frame1:setVisible(true)
            equip1:setVisible(true)
        end
    end
end

function _changeState(state)
    if state == "decompose" and not ConfigureStorage.equipDecomposeOpen then
        ShowText( HLNSLocalizedString("daily.DC.equipDecomposeNotOpen") )  --"分解功能暂时关闭"
        return 
    end
    if state == "compose" and not ConfigureStorage.equipCompoundOpen then
        ShowText( HLNSLocalizedString("daily.DC.equipCompoundNotOpen") )  --"制造功能暂时关闭"
        return 
    end
    if state == "Newcompose" and not ConfigureStorage.equipNewComposeOpen then
        ShowText( HLNSLocalizedString("daily.DC.equipNewCompoundNotOpen") )  --"合成功能暂时关闭"
        return
    end

    _nowState = state
    _decomposeLayer:setVisible(state == "decompose")
    _composeLayer:setVisible(state == "compose")
    _NewcomposeLayer:setVisible(state == "Newcompose")
    _enterLayer:setVisible(state == "enter")
    if state == "enter" then   
        --
    elseif state == "decompose" then          
        _refreshDecomposeUI()
    elseif state == "compose" then   
        _refreshComposeUI()
    elseif state == "Newcompose" then
        _refreshNewComposeUI()
    end
end

---------------------四个界面的跳转---------------------

--  进入分解界面
local function enterDecomposeViewBtnTaped()  
    -- if getMainLayer() then
    --     getMainLayer():addChild(createDecomposeChooseLayer(-140), 100) --选择分解的装备
    -- end  
    _changeState("decompose")
end
DailyDecomposeAndComposeViewOwner["enterDecomposeViewBtnTaped"] = enterDecomposeViewBtnTaped 
DailyDecomposeAndComposeViewOwner["goDecomposeBtnClick"] = enterDecomposeViewBtnTaped

--  进入铸造界面
local function enterComposeViewBtnTaped()  
    _changeState("compose")
end
DailyDecomposeAndComposeViewOwner["enterComposeViewBtnTaped"] = enterComposeViewBtnTaped
DailyDecomposeAndComposeViewOwner["goComposeBtnClick"] = enterComposeViewBtnTaped

-- 进入合成界面
local function enterNewcomposeViewBtnTaped() 
    requireArray = {}
    _changeState("Newcompose")
end
DailyDecomposeAndComposeViewOwner["enterNewcomposeViewBtnTaped"] = enterNewcomposeViewBtnTaped
DailyDecomposeAndComposeViewOwner["goNewcomposeBtnClick"] = enterNewcomposeViewBtnTaped

--  返回enter界面
local function backBtnClick()  
    _changeState("enter")
end
DailyDecomposeAndComposeViewOwner["backBtnClick"] = backBtnClick


-------------------------------分解--------------------------------
-----------------------------------------------------------------

-- 分解界面 [选择装备 ]
local function decomposeChooseBtnClick()
    if getMainLayer() then
        getMainLayer():addChild(createDecomposeChooseLayer(-140), 100)
    end  
end 
DailyDecomposeAndComposeViewOwner["decomposeChooseBtnClick"] = decomposeChooseBtnClick
DailyDecomposeAndComposeViewOwner["onDecomposeFrameClicked"] = decomposeChooseBtnClick

--  孙宇大爷要求的跑马灯效果  _(:_」∠)_   
local function paomadeng(blinkPart,myCallfun)

    blinkPart:setVisible(true)
    blinkPart:setOpacity (0)
    local array = CCArray:create()
    for i=1 , 10 ,10/10 do  --闪烁20次 
        local dur = 0.5* (1/i)  --从0.5--0.1
        dur = (dur < 0.1) and 0.1 or dur  --最低不小于0.1
        local fadeTo255 = CCFadeTo:create( dur, 0)
        local fadeTo0 = CCFadeTo:create( dur , 255)
        array:addObject(fadeTo255)
        array:addObject(fadeTo0)
    end
        --最后保持亮一段时间,再灭掉
    array:addObject( CCDelayTime:create(1))
    array:addObject( CCFadeTo:create( 0.1,0))
    --doaction 调后台
    array:addObject( CCDelayTime:create(0.1) )
    array:addObject(CCCallFunc:create(myCallfun))

    blinkPart:runAction(CCSequence:create(array))

end

--"恭喜您分解装备成功!"
local function _ShowSuccessText(rtnData)
    if rtnData.info and rtnData.info["gain"] then
        if getMyTableCount( rtnData.info["gain"]["items"] ) >1 then  --多个获得物品
            ShowText( HLNSLocalizedString("daily.DC.CongratulationsDecomposeSuccess") )  --"恭喜您分解装备成功!"
        else     --获得单个物品                                               
            for k,v in pairs( rtnData.info["gain"]["items"] ) do
                ShowText( HLNSLocalizedString("daily.DC.CongratulationsDecomposeSuccessSingle",v) )  --"恭喜您分解装备成功!\n获得了%d个合成材料"
            end
        end
    end

end

--- 分解界面  分解 -----
local function beginDecomposeBtnClick()
    if not bAni then --点分解后会做动作,如果在做动作 就不能再相应了
        if not (_sellIdArrays and getMyTableCount(_sellIdArrays) > 0 )  then
            ShowText( HLNSLocalizedString("daily.DC.haventChooseEquip") )  --"您还未选择装备"
        else  
            ShowText( HLNSLocalizedString("daily.DC.haveBegunDecompose") )  --"机器人已开始分解装备!"
            print("_sellIdArrays")
            local decomposeMachineHead_1 = tolua.cast(_owner["decomposeMachineHead_1"],"CCSprite") --机器人的眼睛 闪烁部分 

            local function myCallfun(  ) --跑马灯之后的回调
                local function doActionCallback(url, rtnData)
                    _sellIdArrays = {}
                    _sellIdArrays2 = {}
                    _refreshDecomposeUI()
                    _ShowSuccessText(rtnData) --跳字. 如果获得一种材料:"恭喜您分解装备成功!" .....  如果获得多种."恭喜您分解装备成功!\n获得了%d个合成材料"
                    
                end
                doActionFun("EQUIP_DECOMPOSE", { _sellIdArrays }, doActionCallback)
                bAni = false
            end

            --跑马灯开始
            paomadeng(decomposeMachineHead_1,myCallfun)
            bAni = true
        end
    end
end 
DailyDecomposeAndComposeViewOwner["beginDecomposeBtnClick"] = beginDecomposeBtnClick

local function _ifHaveEquipOfRank(rank)  --仓库中是否有rank品质的装备
    AllEquipsData = equipdata:getAllEquipData(  )
    -- print("**lsf AllEquipsData")
    -- PrintTable(AllEquipsData)
    for i,v in ipairs(AllEquipsData) do
        if v.equip.rank == rank then
            return true
        end    
    end
    return false

end


-- 分解界面 一键分解所有白色
local function decomposeAllWhiteBtnClick()
    local rank = 1
    print("一键白色decomposeAllWhiteBtnClick")

    if _ifHaveEquipOfRank(rank)  then  --如果背包里有白色装备

        --"确定分解所有白色装备吗?"
        local function cardConfirmAction(  )

            local function Callback(url, rtnData)
                if getMyTableCount(rtnData.info) == 0 then 
                    ShowText( HLNSLocalizedString("daily.DC.haveNotGreen") )  --"分解失败\n您已经没有可分解的绿色装备了",
                else 
                    _ShowSuccessText(rtnData) --跳字. 如果获得一种材料:"恭喜您分解装备成功!" .....  如果获得多种."恭喜您分解装备成功!\n获得了%d个合成材料"
                    if _sellIdArrays and getMyTableCount(_sellIdArrays) > 0  then
                        --去除所选装备里的白色装备
                        for k,v in pairs(_sellIdArrays2) do
                            if v.equip.rank == rank then
                                --print("lsf del equip",k)
                                _sellIdArrays2[k] = nil 
                            end
                        end
                        _sellIdArrays = table.allKey(_sellIdArrays2) or {}
                    end
                    _refreshDecomposeUI()
                end
            end

            doActionFun("EQUIP_DECOMPOSE_BY_RANK", { rank }, Callback)
        end

        local function cardCancelAction(  )
            
        end
        getMainLayer():getParent():addChild(createSimpleConfirCardLayer( HLNSLocalizedString("daily.DC.DecomposeAllWhite?") )) --"确定分解所有白色装备吗?"
        SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
        SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction

    else 
        ShowText( HLNSLocalizedString("daily.DC.haveNotWhite") )  --"分解失败\n您已经没有可分解的绿色装备了",

    end
end 
DailyDecomposeAndComposeViewOwner["decomposeAllWhiteBtnClick"] = decomposeAllWhiteBtnClick

-- 分解界面 一键分解所有绿色
local function decomposeAllGreenBtnClick()
    local rank = 2
    print("一键绿色 ecomposeAllGreenBtnClick")
    if _ifHaveEquipOfRank(rank) then  --如果背包里有绿色装备

        --"确定分解所有绿色装备吗?"
        local function cardConfirmAction(  )

            local function Callback(url, rtnData)
                if getMyTableCount(rtnData.info) == 0 then 
                    ShowText( HLNSLocalizedString("daily.DC.haveNotGreen") )  --"分解失败\n您已经没有可分解的绿色装备了",
                else 
                    _ShowSuccessText(rtnData) --跳字. 如果获得一种材料:"恭喜您分解装备成功!" .....  如果获得多种."恭喜您分解装备成功!\n获得了%d个合成材料"
                    --去除所选装备里的白色装备
                    if _sellIdArrays and getMyTableCount(_sellIdArrays) > 0  then 
                        for k,v in pairs(_sellIdArrays2) do
                            if v.equip.rank == rank then
                                --print("lsf del equip",k)
                                _sellIdArrays2[k] = nil 
                            end
                        end
                        _sellIdArrays = table.allKey(_sellIdArrays2) or {}
                    end
                    _refreshDecomposeUI()
                end
            end

            doActionFun("EQUIP_DECOMPOSE_BY_RANK", { rank }, Callback)
            
        end

        local function cardCancelAction(  )
            
        end
        getMainLayer():getParent():addChild(createSimpleConfirCardLayer( HLNSLocalizedString("daily.DC.DecomposeAllGreen?") )) --"确定分解所有绿色装备吗?"
        SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
        SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction

     else 
        ShowText( HLNSLocalizedString("daily.DC.haveNotGreen") )  --"分解失败\n您已经没有可分解的绿色装备了",
     end
end 
DailyDecomposeAndComposeViewOwner["decomposeAllGreenBtnClick"] = decomposeAllGreenBtnClick


-------------------------------铸造---------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------


-- 铸造 -- [选择装备界面 ]
local function composeChooseBtnClick()
    if getMainLayer() then
        getMainLayer():addChild(createComposeChooseLayer(-140), 100)
    end  
end 
DailyDecomposeAndComposeViewOwner["composeChooseBtnClick"] = composeChooseBtnClick
DailyDecomposeAndComposeViewOwner["onComposeFrameClicked"] = composeChooseBtnClick


--- 铸造界面  制造 -----
local function beginComposeBtnClick()
    if not _composeEquip then
        ShowText( HLNSLocalizedString("daily.DC.haventChooseEquip") )  --"您还未选择装备"
    else
        ShowText( HLNSLocalizedString("daily.DC.haveBegunCompose") )  --"机器人已开始制造装备!"

        local composeMachineHead_1 = tolua.cast(_owner["composeMachineHead_1"],"CCSprite") --机器人的眼睛 闪烁部分 
            --然后doaction
        local function myCallfun(  ) --跑马灯之后的回调
            local tpArray = {}
            table.insert( tpArray,_composeEquip.id)
            local function doActionCallback(url, rtnData)
                --更新装备时间戳
                -- print( "**lsf 合成callback ",rtnData.info["compoundEquip"][_composeEquip.id]["lastTime"])
                local equipCool = dailyData.daily.compose.compoundEquip  --装备的冷却时间
                print("lsf equipCool")
                PrintTable(equipCool)
                if (not equipCool) or type(equipCool) == "string"  then
                    equipCool = {}
                    dailyData.daily.compose.compoundEquip = equipCool
                    print("**lsf1")
                end
                if not equipCool[_composeEquip.id] then
                    equipCool[_composeEquip.id] = {}
                    print("**lsf2")

                end
                equipCool[_composeEquip.id]["lastTime"] = rtnData.info["compoundEquip"][_composeEquip.id]["lastTime"]  --更新装备时间戳
                --PrintTable(equipCool)
                --PrintTable(dailyData.daily.compose.compoundEquip )
                -- print( "**lsf 合成callback2 ", equipCool[_composeEquip.id]["lastTime"])
                _composeEquip = nil 
                _refreshComposeUI()
                ShowText( HLNSLocalizedString("daily.DC.CongratulationsComposeSuccess") )  --"恭喜您制造装备成功!"
                
            end
            doActionFun("EQUIP_COMPOUND", { tpArray }, doActionCallback)
            bAni = false

        end

        --跑马灯开始
        paomadeng(composeMachineHead_1,myCallfun)
        bAni = true
    end  
end 
DailyDecomposeAndComposeViewOwner["beginComposeBtnClick"] = beginComposeBtnClick


-------------------------------合成---------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
local function isShowComposeWidget(isShows)
    local contentbg = tolua.cast(owner["contentbg"],"CCSprite")
    local newContentLayer = tolua.cast(owner["newContentLayer"],"CCLayer")
    local contentDesVIew = tolua.cast(owner["contentDesVIew"],"CCLayer")
    local frame = tolua.cast(DailyDecomposeAndComposeViewOwner["cr_frame"],"CCSprite")
    local equip = tolua.cast(DailyDecomposeAndComposeViewOwner["cr_equip"],"CCSprite")
    local frame1 = tolua.cast(DailyDecomposeAndComposeViewOwner["cr_frame1"],"CCSprite")
    local equip1 = tolua.cast(DailyDecomposeAndComposeViewOwner["cr_equip1"],"CCSprite")
    frame:setVisible(isShows)
    equip:setVisible(isShows)
    local isshow = isShows == true and false or true
    frame1:setVisible(isshow)
    equip1:setVisible(isshow)
    contentbg:setVisible(isShows)
    newContentLayer:setVisible(isShows)
    contentDesVIew:setVisible(isShows)
end

-- [合成详情]
local function directionsClick()
    local desc = ConfigureStorage.equip_help
    if not desc then
        desc = {}
    end 
    local  function getMyDescription()
        local temp = {}      
        for i=1,getMyTableCount(desc) do
            table.insert(temp, desc[tostring(i)].hp)
        end
        return temp
    end
    local description = getMyDescription()
    local contentLayer = MainSceneOwner["contentLayer"]
    getMainLayer():getParent():addChild(createCommonHelpLayer(description, -132))
end
DailyDecomposeAndComposeViewOwner["directionsClick"] = directionsClick

-- [选择装备界面 ]
local function onNewComposeFrameClicked()
    if FildX == -1 then
        getMainLayer():addChild(createNewcomposeChooseLayer(-140), 100)
    else
        if getMainLayer() then
            getMainLayer():addChild(createRestoreChooseLayer(-140), 100)
        end 
    end
end 
DailyDecomposeAndComposeViewOwner["onNewComposeFrameClicked"] = onNewComposeFrameClicked
DailyDecomposeAndComposeViewOwner["beginNewComposeBtnClick"] = beginNewComposeBtnClick

-- [装备合成还原]
local function composeRestoreClick()
    
    local composeRestoreItem = tolua.cast(DailyDecomposeAndComposeViewOwner["composeRestoreItem"],"CCMenuItemImage")
    composeRestoreItem:setScaleX(FildX)
    if FildX == -1 then
        isRestoreBegin = false
        isShowComposeWidget(false)
        requireArray = {}
        _refreshNewComposeUI()
    else
        isRestoreBegin = true
        isShowComposeWidget(true)
        _refreshNewComposeUI()
    end
    FildX = FildX == 1 and -1 or 1 
end 
DailyDecomposeAndComposeViewOwner["composeRestoreClick"] = composeRestoreClick

-- [开始]
local function beginClick()
    if isRestoreBegin then
        if _newComposeEquip and getMyTableCount(requireArray) == needEquipCount then
            print("-- STARTADVANCED = ?action=startAdvanced,--开始进阶接口 参数是需要材料的数组")
            local function onEnterCallBack( url,rtnData )
                if rtnData["code"] == 200 then
                    if rtnData["info"].success == 1 then
                        
                        local advanced
                        for k,v in pairs(rtnData["info"].gain.equips) do
                            advanced = v.advanced
                        end
                        local composeLevel
                        local equipId = _newComposeEquip.equip.id
                        if ConfigureStorage.equip[equipId].rank == 3 then
                            composeLevel = ConfigureStorage.equip_blue_awave[tostring(advanced)].rankchange
                        elseif ConfigureStorage.equip[equipId].rank == 4 then
                            composeLevel = ConfigureStorage.equip_pur_awave[tostring(advanced)].rankchange
                        elseif ConfigureStorage.equip[equipId].rank == 5 then
                            composeLevel = ConfigureStorage.equip_gold_awave[tostring(advanced)].rankchange
                        end
                        if composeLevel == -1 then
                            composeLevel = "max"
                        end
                        if composeLevel == 0 then
                            announceLabel:setString(HLNSLocalizedString("daily.DC.composeSuccessRank",_newComposeEquip.equip.name))
                        else
                            announceLabel:setString(HLNSLocalizedString("daily.DC.composeSuccess",_newComposeEquip.equip.name,composeLevel))
                        end
                        
                        _newComposeEquip = nil
                        _refreshNewComposeUI()
                    else
                        announceLabel:setString(HLNSLocalizedString("daily.DC.composeDefeat"))
                        _chanceDic.myChance = rtnData["info"].nextProbabity
                        _refreshNewComposeUI()
                    end
                end
            end
            
            local function cardConfirmAction( )
                doActionFun("STARTADVANCED",{_newComposeEquip.id,requireArray},onEnterCallBack)
            end
            local function cardCancelAction( )
            end
            getMainLayer():getParent():addChild(createSimpleConfirCardLayer(HLNSLocalizedString("daily.DC.isComposeEquip")))
            SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
            SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
        else
            ShowText( HLNSLocalizedString("daily.DC.notRequireEquip")) -- 请添加合成材料
        end
        
    else
        if _restoreEquip then
            print("-- GOBACKADVANCED = ?action=goBackAdvanced,--还原装备接口 参数是还原装备的Id")
            local function onEnterCallBack( url,rtnData )
                if rtnData["code"] == 200 then
                    _restoreEquip = nil
                    _refreshNewComposeUI()
                end
            end
            local function cardConfirmAction( )
                doActionFun("GOBACKADVANCED",{_restoreEquip.id},onEnterCallBack)
            end
            local function cardCancelAction( )
            end
            getMainLayer():getParent():addChild(createSimpleConfirCardLayer(HLNSLocalizedString("daily.DC.isRestoreEquip")))
            SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
            SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
        end
        
    end
end 
DailyDecomposeAndComposeViewOwner["beginClick"] = beginClick

-- [选择合成需要的装备]
local function chooseComposeEquip(tag, sender)
    if getMainLayer() then
        getMainLayer():addChild(createRequireEquipChooseLayer(-140,tag,_newComposeEquip), 100)
    end
end 
DailyDecomposeAndComposeViewOwner["chooseComposeEquip"] = chooseComposeEquip

-- [前往合成器]
local function synthesizerUpdataBtnClick()
    local function onEnterCallBack( url,rtnData )
        if rtnData["code"] == 200 then
            if getMainLayer() then
                getMainLayer():addChild(createComposeUpdataLayer(rtnData["info"].equipUpgrade,-140), 100)
            end
        end
    end
    
    doActionFun("INITEQUIPUPGRADE",{},onEnterCallBack) 
end
DailyDecomposeAndComposeViewOwner["synthesizerUpdataBtnClick"] = synthesizerUpdataBtnClick

-------------------------------------------------------------


-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/DailyDecomposeAndComposeView.ccbi",proxy, true,"DailyDecomposeAndComposeViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    _size = winSize
    _cache = CCSpriteFrameCache:sharedSpriteFrameCache()

    owner = DailyDecomposeAndComposeViewOwner
    _enterLayer = tolua.cast(owner["enterLayer"], "CCLayer")
    _decomposeLayer  = tolua.cast(owner["decomposeLayer"], "CCLayer")
    _composeLayer  = tolua.cast(owner["composeLayer"], "CCLayer")
    _NewcomposeLayer = tolua.cast(owner["NewcomposeLayer"], "CCLayer")
    _contentLayer  = tolua.cast(owner["contentLayer"], "CCLayer") --合成界面底下的黑框
    local composeMachineHead_1 = tolua.cast(_owner["composeMachineHead_1"],"CCSprite") --合成界面 机器人眼睛 跑马灯效果
    composeMachineHead_1:setVisible(false)
    local decomposeMachineHead_1 = tolua.cast(_owner["decomposeMachineHead_1"],"CCSprite") --机器人眼睛 跑马灯效果
    decomposeMachineHead_1:setVisible(false)
    local multiDecomposeTTF = tolua.cast(_owner["multiDecompose"],"CCLabelTTF") --将分解%d个所选装备
    multiDecomposeTTF:setVisible(false)
    local decomposeAllWhiteTTF = tolua.cast(_owner["decomposeAllWhiteTTF"],"CCLabelTTF")
    decomposeAllWhiteTTF:setString( HLNSLocalizedString("daily.DC.decomposeAllWhite")  ) -- "一键分解\n白色装备",
    local decomposeAllWhite2TTF = tolua.cast(_owner["decomposeAllWhite2TTF"],"CCLabelTTF")
    decomposeAllWhite2TTF:setString( HLNSLocalizedString("daily.DC.decomposeAllWhite")  )
    local decomposeAllGreenTTF = tolua.cast(_owner["decomposeAllGreenTTF"],"CCLabelTTF") 
    decomposeAllGreenTTF:setString( HLNSLocalizedString("daily.DC.decomposeAllGreen")  )  --"一键分解\n绿色装备",
    local decomposeAllGreen2TTF = tolua.cast(_owner["decomposeAllGreen2TTF"],"CCLabelTTF")
    decomposeAllGreen2TTF:setString( HLNSLocalizedString("daily.DC.decomposeAllGreen")  )
    announceLabel = tolua.cast(DailyDecomposeAndComposeViewOwner["announceLabel"],"CCLabelTTF")

    local composeFrameMenu = tolua.cast(owner["composeFrameMenu"],"CCMenuItemImage")
    local composeEquipMenu = tolua.cast(owner["composeEquipMenu"],"CCMenuItemImage")
    local decomposeFrameMenu = tolua.cast(owner["decomposeFrameMenu"],"CCMenuItemImage")
    composeEquipMenu:setOpacity(0)
    composeFrameMenu:setOpacity(0)
    decomposeFrameMenu:setOpacity (0)

    _changeState("enter") --选择enter界面    

    _newContentLayer = tolua.cast(owner["newContentLayer"], "CCLayer")

    -- print("**lsf11 ConfigureStorage")
    -- PrintTable(ConfigureStorage.equipDecomposeOpen)
    -- PrintTable(ConfigureStorage.equipCompoundOpen)
    -- print(ConfigureStorage.equipCompoundOpen,ConfigureStorage.equipCompoundOpen)

end


local function setMenuPriority()
    _tableView:setTouchPriority(-150 - 2)
end

-- 该方法名字每个文件不要重复
function getDecomposeAndComposeLayer()
	return _layer
end

--装备的分解、铸造、合成 弗兰奇之家
function createDecomposeAndComposeLayer()
    _init()
   
    function _layer:decomposeChooseFinished( array2)
        --_sellIdArrays = array
        _sellIdArrays2 = array2
        _sellIdArrays = table.allKey(_sellIdArrays2) or {}
        print("**lsf11111 _sellIdArrays2 table")
        --PrintTable(_sellIdArrays2)
        _refreshDecomposeUI()

    end

    function _layer:composeChooseFinished( equipContent)
        _composeEquip = equipContent
        print("**lsf _composeEquip ")
        --PrintTable(_composeEquip)
        _refreshComposeUI()

    end

    function _layer:newComposeChooseFinished( equip , chance )
        _chanceDic = chance
        _newComposeEquip = equip
        requireArray = {}
        -- PrintTable(requireArray)
        -- PrintTable(_newComposeEquip)
        -- PrintTable(_chanceDic)
        print("**选择需要合成装备 _newcomposeEquip--------- ")
        _refreshNewComposeUI()
    end

    function _layer:newRestoreChooseFinished( equip )
        _restoreEquip = equip
        --PrintTable(_restoreEquip)
        print("**选择还原物品 _newRestorecomposeEquip--------- ")
        _refreshNewComposeUI()
    end

    function _layer:newChooseRequireFinished( equip,showCoverTag )
        _showCoverTag = showCoverTag
        local equipArray = {}
        equipArray[tostring(_showCoverTag)] = equip.id
        table.insert(requireArray, equipArray[tostring(_showCoverTag)])
        --PrintTable(requireArray)
        if _showCoverTag then
            local menu = tolua.cast(DailyDecomposeAndComposeViewOwner["needEquipClick".._showCoverTag], "CCMenuItemImage")
            local cover = tolua.cast(DailyDecomposeAndComposeViewOwner["cover".._showCoverTag],"CCLayerColor")
            menu:setEnabled(false)
            
            if getMyTableCount(requireArray) == needEquipCount then
                cover:setVisible(false)
            end
            guide2:setVisible(false)
        end
        print("**选择合成材料 _newChooseRequireEquip--------- ",_showCoverTag)
    end

    function _layer:changeState( state)
        if state == "decompose" and not ConfigureStorage.equipDecomposeOpen then
            ShowText( HLNSLocalizedString("daily.DC.equipDecomposeNotOpen") )  --"分解功能暂时关闭"
            return 
        end
        if state == "compose" and not ConfigureStorage.equipCompoundOpen then
            ShowText( HLNSLocalizedString("daily.DC.equipCompoundNotOpen") )  --"制造功能暂时关闭"
            return 
        end
        if state == "Newcompose" and not ConfigureStorage.equipNewCompoundOpen then
            ShowText( HLNSLocalizedString("daily.DC.equipNewCompoundNotOpen") )  --"合成功能暂时关闭"
            return 
        end

        _nowState = state
        _decomposeLayer:setVisible(state == "decompose")
        _composeLayer:setVisible(state == "compose")
        _NewcomposeLayer:setVisible(state == "Newcompose")
        _enterLayer:setVisible(state == "enter")
        if state == "enter" then   
            --
        elseif state == "decompose" then 
            _refreshDecomposeUI()
        elseif state == "compose" then   
            _refreshComposeUI()
        elseif state == "Newcompose" then
            _refreshNewComposeUI()
        end

    end

    local function _onEnter()
        bAni = false
        _addTableView()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)
    end

    local function _onExit()
        bAni = false
        _layer = nil
        _data = nil
        _tableView = nil
        isAnimation = false
        _sellIdArrays2 = {}
        _sellIdArrays = {}
        _compoundItemsDic = {}
        _inDecomposing = false
        isRestoreBegin = true
        _newComposeEquip = nil
        _chanceDic = nil
        _restoreEquip = nil
        requireArray = {}
        _showCoverTag = nil
        announceLabel = nil
        needEquipCount =nil
        guide1 = nil
        guide2 = nil
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end

    local function onTouchBegan(x, y)

        if  bAni then
            return true
        end
        
        --如果在合成界面,点击下面的横向tableview区域 禁止pageview的滑动
        if _nowState == "compose" then
            local width = _contentLayer:getContentSize().width  * retina
            local height = _contentLayer:getContentSize().height * retina
            local cx = _contentLayer:getPositionX() * retina
            local cy = _contentLayer:getPositionY() * retina
            
            local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
            local rect = CCRectMake( cx, cy , width, height)  
            print("**lsf rect",  cx, cy , width, height)
            print("**lsf touchPoint", touchLocation.x ,touchLocation.y)
            print(x,y)
            if  rect:containsPoint(touchLocation) then --如果在_contentLayer里,则禁止pageview的触摸
                getDailyLayer():pageViewTouchEnabled(false)
                print("return1")
            else 
                getDailyLayer():pageViewTouchEnabled(true)
                print("return2")
            end
        end

        return false
    end

    local function onTouchEnded(x, y)
    end

    local function onTouch(eventType, x, y)
        if eventType == "began" then   
            return onTouchBegan(x, y)
        elseif eventType == "moved" then
        elseif eventType == "ended" then
        end
    end
    _layer:registerScriptTouchHandler(onTouch, false, -300, true)
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end