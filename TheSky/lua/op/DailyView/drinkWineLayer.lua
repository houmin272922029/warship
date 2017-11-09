local _layer
local _data = nil
local _tableView

local _enterLayer
local _mainLayer 
local _curHeroUId
local _curWineRank =1
local _last_drinkRank  = 1 --上一次喝的就的品阶，决定跳字的字样：换酒成功 或 换酒失败
--饮酒活动配置
local  _cSdrink_tabodds   
local  _cSdrink_buycap    
local  _cSdrink_freetimes 
local  _cSdhangeWineCost  
local  _cSdrink_othercosts
local  _cSdrink_gainCap   
local  _cSdrink_rank   
local  _cSdrink_adout   

local _ifIsFirstComeIn = true --是否是初次进入酒吧 决定了zoro说的话
local _ifJustHaveADrinke = false --是否刚喝完酒，决定了zoro说的话
local _nowDinkBtnClicked = false --是否 现在是喝酒按钮按下状态
local _nowChangeWineBtnClick = false --是否 现在是换酒按钮按下状态
local _nowOneBtnChangeWineBtnClick = false --是否 现在是一键换酒按钮按下状态
local _haveWarned = false --是否 提醒过玩家没有免费饮酒次数

local _winePosition = { 0.69, 0.75, 0.81, 0.87, 0.93 } --5个酒的初始百分比位置
local _wineMoveLeftW = 0.62 --酒从右边移动到左边的移动宽度
local _wineMoveCenterH = 2
local stateArray = {}       -- 存储每一个位置索引的位置信息和缩放比例信息 ，暂时没用到
local _size 
local _cache
local isAnimation = false
local maxPointDrink   --最大潜力值
local pointDrink  --饮酒增加的潜力值

DailyDrinkWineViewOwner = DailyDrinkWineViewOwner or {}
ccb["DailyDrinkWineViewOwner"] = DailyDrinkWineViewOwner


--详情
local function descBtnTaped()
    local desc = ConfigureStorage.Drink_adout
    print("Drink xiangqing")
    PrintTable(desc)
    local  function getMyDescription()
        local temp = {}      
        for i=1,getMyTableCount(desc) do
            table.insert(temp, desc[tostring(i)].talk)
        end
        return temp
    end
    local description = getMyDescription()
    print("lsf111 Drink description")
    PrintTable(description )
    local contentLayer = MainSceneOwner["contentLayer"]
    getMainLayer():getParent():addChild(createCommonHelpLayer(description, -132))
end
DailyDrinkWineViewOwner["descBtnTaped"] = descBtnTaped



--进入按钮 进入英雄选择界面
local function onEnterBtnTaped()  
    if getMainLayer() then
        getMainLayer():addChild(createDailyDrinkChoseHeroLayer(-140), 100)
    end  
end
DailyDrinkWineViewOwner["onEnterBtnTaped"] = onEnterBtnTaped
    


-- 点击英雄头像 查看英雄 
local function onHeadClicked()
    if getMainLayer() then
        getMainLayer():addChild(createDailyDrinkChoseHeroLayer(-140), 100)
    end 
end 
DailyDrinkWineViewOwner["onHeadClicked"] = onHeadClicked


--摆放酒的位置
local function _putWinesPos( )
   
    local wine11 = tolua.cast(DailyDrinkWineViewOwner["wine11"], "CCSprite") --cur
    wine11:setVisible(false)
    wine11:setDisplayFrame(_cache:spriteFrameByName(string.format("wine_%d.png", _curWineRank )))

    for i=1, tonumber(getMyTableCount(_cSdrink_tabodds))  do
        local wine = tolua.cast(DailyDrinkWineViewOwner["wine" .. i], "CCSprite")

        if i < _curWineRank then  --左边的酒
            print("**lsf showWine i",i)
            wine:setVisible(true)
            wine:setPosition( (_winePosition[i] - _wineMoveLeftW)  *_size.width ,  0.37*_size.height   )
            wine:setScale(  0.7)
        elseif i > _curWineRank then  --右边的酒
            print("**lsf showWine i",i)
            wine:setVisible(true)
            wine:setPosition(  _winePosition[i]  *_size.width ,  0.37*_size.height   )
            wine:setScale(  0.7 )
        elseif i == _curWineRank then
            print("**lsf showWine i",i)
            wine:setPosition(   0.51  *_size.width ,  0.35*_size.height )
            wine:setScale(  1 )
        end 
    end
end


-- 刷新main UI
local function _refreshMainUI()

    --------------------数据区---------------------------------------
    _data = dailyData:getDrinkWineData()
    print("**lsf _refreshMainUI DrinkWineData table")
    PrintTable(_data)

    _curWineRank = _data.wineRank --
    print("**lsf _size",_size.width, _size.height )
 
    ---------------------UI区---------------------------------------------

    -- zoro说的话
    local zorosWord = tolua.cast(DailyDrinkWineViewOwner["zorosWord"], "CCLabelTTF")
    zorosWord:setString( string.format( HLNSLocalizedString("daily.drinkWine.zorosWord" .. _curWineRank) ,_cSdrink_tabodds[tostring(_curWineRank)].point)  )
    if _ifIsFirstComeIn then
        zorosWord:setString( HLNSLocalizedString("daily.drinkWine.zorosWord_in")  )
        _ifIsFirstComeIn = false
    elseif _ifJustHaveADrinke  then
        zorosWord:setString( HLNSLocalizedString("daily.drinkWine.zorosWord_afterDrink")  )
        _ifJustHaveADrinke = false
    end

    -- 已喝次数/ 总的可喝次数（免费）
    local drinkTimes1 = tolua.cast(DailyDrinkWineViewOwner["drinkTimes1"], "CCLabelTTF")
    local freeDrinkTimesLast = _cSdrink_freetimes.drink.times - _data.drinkCount 
    if freeDrinkTimesLast < 0 then
        freeDrinkTimesLast = 0
    end
    drinkTimes1:setString(string.format("%d/%d", freeDrinkTimesLast, _cSdrink_freetimes.drink.times))

    --vip饮酒次数
    local vipDrinkTime_num = ConfigureStorage.vipConfig[userdata:getVipLevel() + 1].drinktimes  --vip从0开始，配置里从1开始，所以要加1
    local vipDrinkTimes1 = tolua.cast(DailyDrinkWineViewOwner["vipDrinkTimes1"], "CCLabelTTF")
    if (_cSdrink_freetimes.drink.times - _data.drinkCount) < 0 then
        vipDrinkTimes1:setString(string.format("%d", vipDrinkTime_num + _cSdrink_freetimes.drink.times - _data.drinkCount))
    else
        vipDrinkTimes1:setString(string.format("%d", vipDrinkTime_num))
    end
    -- 潜力值
    local rank = herodata:getHeroInfoByHeroUId(_curHeroUId).rank
    local rankInfo = _cSdrink_rank[tostring(rank)]
    maxPointDrink = math.ceil(rankInfo.base + rankInfo.grow * (herodata.heroes[_curHeroUId].level-1) ) --最大潜力值= 基础+当前等级*系数,向上取整，c 1级是 53.5 -》54
    if herodata.heroes[_curHeroUId].pointDrink == nil then --如果是空，说明饮酒增加的潜力为0
        pointDrink = 0
    else
        pointDrink = herodata.heroes[_curHeroUId].pointDrink 
    end
    local playersPotentialInfo = tolua.cast(DailyDrinkWineViewOwner["playersPotentialInfo"], "CCLabelTTF")
    playersPotentialInfo:setString(string.format("%d/%d", pointDrink, maxPointDrink)) 


    --所选英雄头像
    local frame = tolua.cast( DailyDrinkWineViewOwner["frame"], "CCMenuItemImage")
    local head = tolua.cast(DailyDrinkWineViewOwner["head"], "CCSprite")
    local hero = herodata.heroes[_curHeroUId]
    local heroId = hero.heroId
    local conf = herodata:getHeroConfig(heroId)
    if conf then  
        frame:setVisible(true)
        frame:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%d.png", herodata:fixRank(conf.rank, hero.wake))))
        local f = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(herodata:getHeroHeadByHeroId(heroId))
        if f then
            head:setVisible(true)
            head:setDisplayFrame(f)
        end
    end   

    -- 一键换酒的花销
    local goldCost = tolua.cast(DailyDrinkWineViewOwner["goldCost"], "CCLabelTTF")
    goldCost:setString(string.format("X%d", _cSdrink_othercosts.top.gold))
    -- 普通换酒的花销
    local changeCount = _data.changeCount 
    if changeCount + 1 > 10 then
        changeCount = 9  -- changeCount+1 = 10
    end
    print("**lsf changeCount ",changeCount)
   
    local gold2Cost = tolua.cast(DailyDrinkWineViewOwner["gold2Cost"], "CCLabelTTF")
    gold2Cost:setString(string.format("X%d", _cSdrink_changeWineCost[tostring(changeCount + 1)].costw))
    
    -- 今日可免费%d次
    local totalFreeTimes
    for i=1,getMyTableCount(_cSdrink_changeWineCost) do
        if _cSdrink_changeWineCost[tostring(i)].costw > 0 then
            totalFreeTimes= tonumber(i) - 1
            break
        end
    end
    local freeTimes = totalFreeTimes - _data.changeCount
    if freeTimes < 0 then
        freeTimes = 0
    end
    local todaysFreeTimesToChange = tolua.cast(DailyDrinkWineViewOwner["todaysFreeTimesToChange"], "CCLabelTTF")
    todaysFreeTimesToChange:setString(string.format(HLNSLocalizedString("daily.drinkWine.todaysFreeTimes" ), freeTimes))   

    --今日获得的瓶盖
    local numberOfTodaysCapGet = tolua.cast(DailyDrinkWineViewOwner["numberOfTodaysCapGet"], "CCLabelTTF")
    numberOfTodaysCapGet:setString(string.format("%d", _data.capToday))
    
    
end



-- --酒的移位  _data.wineRank
local function _showNowWine()
    isAnimation = true
    print("**lsf now comein _showNowWine")
    local time = 0.4
    local time1 = 0.3
    local wine11 = tolua.cast(DailyDrinkWineViewOwner["wine11"], "CCSprite") --cur
    wine11:setVisible(false)
    wine11:setDisplayFrame(_cache:spriteFrameByName(string.format("wine_%d.png", _curWineRank )))
    

    -- 之前的酒
    local winePrevious = tolua.cast(DailyDrinkWineViewOwner["wine" .. _last_drinkRank], "CCSprite")
    local posArray = CCArray:create()
    local desPos
    if _curWineRank > _last_drinkRank then --左移
        print("**lsf wineleft 左移",_curWineRank,_last_drinkRank)
        desPos = ccp(  (_winePosition[_last_drinkRank] - _wineMoveLeftW)  * _size.width ,  0.37 * _size.height )
    elseif _curWineRank < _last_drinkRank then  --右移
        print("**lsf wineright 右移",_curWineRank,_last_drinkRank)    
        desPos = ccp(  _winePosition[_last_drinkRank] * _size.width ,  0.37 * _size.height )
    end
    local spawn = CCSpawn:createWithTwoActions(CCMoveTo:create(time1, desPos),CCScaleTo:create(time1 ,0.7))
    posArray:addObject(spawn)
    winePrevious:runAction(CCSequence:create(posArray))


    -- 现在的酒
    local wineNow= tolua.cast(DailyDrinkWineViewOwner["wine" .. _curWineRank], "CCSprite")
    local posArray = CCArray:create()
    local desPos = ccp(0.51 * _size.width, 0.35*_size.height)
    local spawn = CCSpawn:createWithTwoActions(CCMoveTo:create(time,desPos),CCScaleTo:create(time ,1.0))
    posArray:addObject(spawn)
    local function setAnimation(  )
        isAnimation = false 
    end
    posArray:addObject(CCCallFunc:create(setAnimation))
    wineNow:runAction(CCSequence:create(posArray))


end



-- 1 真正的 喝酒动作执行 
local function _doActionDrinkWine()

    local function Callback(url, rtnData)
        print("**lsf drinkBtnClick Callback table")
        PrintTable(rtnData)
        herodata.heroes[_curHeroUId].pointDrink = rtnData.info.heros[_curHeroUId].pointDrink
        _ifJustHaveADrinke = true
        
        ShowText(string.format(HLNSLocalizedString("daily.drinkWine.drinkSuc") ,_cSdrink_tabodds[tostring(_curWineRank)].point) )
        _refreshMainUI()
        _last_drinkRank = _curWineRank
        _haveWarned = false
        _putWinesPos()
        herodata:addHeroByDic(rtnData.info.heros[_curHeroUId]) --更新英雄数据
        --如果已喝次数等于 免费+最大vip次数, 按钮变灰
        local vipDrinkTimeMax = ConfigureStorage.vipConfig[13+1].drinktimes
        if  _data.drinkCount >= (_cSdrink_freetimes.drink.times + vipDrinkTimeMax) then 
            local changeWineBtn = tolua.cast(DailyDrinkWineViewOwner["changeWineBtn"] , "CCMenuItemImage")
            local oneBtnChangeWineBtn = tolua.cast(DailyDrinkWineViewOwner["oneBtnChangeWineBtn"] , "CCMenuItemImage")
            changeWineBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn7_2.png"))
            changeWineBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName( "btn7_2.png"))
            oneBtnChangeWineBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn7_2.png"))
            oneBtnChangeWineBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName( "btn7_2.png")) 
        end

    end
    doActionFun("ACTIVITYDRINK_DRINKWINE", { herodata.heroes[_curHeroUId].heroId}, Callback)
    
end

-- 2 真正的 换酒执行动作 
local function _doActionChangeWine() 

    if _curWineRank == tonumber(getMyTableCount(_cSdrink_tabodds))  then
        ShowText(HLNSLocalizedString("daily.drinkWine.nowIsTop" ))
        return
    end
    local function Callback(url, rtnData)
        print("**lsf changeWineBtnClick ACTIVITYDRINK_CHANGEWINE Callback -- PrintTable")
        PrintTable(rtnData)
        _last_drinkRank = _curWineRank --记录上一次酒的rank
        _refreshMainUI()

        local ifChangeSuc
        if  _curWineRank > _last_drinkRank then
            ifChangeSuc = HLNSLocalizedString("daily.drinkWine.changeSuc" )
        elseif _curWineRank < _last_drinkRank then
            ifChangeSuc = HLNSLocalizedString("daily.drinkWine.changeFail" )
        end     
        ShowText(ifChangeSuc .. HLNSLocalizedString("daily.drinkWine.getACap" ))
        _showNowWine()
        _last_drinkRank = _curWineRank
    end
    doActionFun("ACTIVITYDRINK_CHANGEWINE", { }, Callback)

end


-- 3 真正的一键换酒按执行动作 
local function _doActionOneBtnChangeWine() 
    if _curWineRank == tonumber(getMyTableCount(_cSdrink_tabodds))  then
        ShowText(HLNSLocalizedString("daily.drinkWine.nowIsTop" ))
        return
    end 
    local function Callback(url, rtnData)
        print("**lsf oneBtnChangeWineBtnClick ACTIVITYDRINK_CHANGEWINETOP Callback -- table")
        PrintTable(rtnData)
        _refreshMainUI()
        ShowText(HLNSLocalizedString("daily.drinkWine.getTenCap" ))
        _putWinesPos()
    end
    doActionFun("ACTIVITYDRINK_CHANGEWINETOP", { }, Callback)
end 


-- 饮酒主界面的动作审查员 _(:_」∠)_  审查玩家喝酒、换酒、一键换酒动作是否满足条件, （比如免费次数用完了就提示一下）
local function _theInspector () 
    print("**lsf player VipLevel",userdata:getVipLevel() )
    local vipDrinkTime = ConfigureStorage.vipConfig[ userdata:getVipLevel()+1 ].drinktimes  --vip从0开始，配置里从1开始，所以要加1
    local vipDrinkTimeMax = ConfigureStorage.vipConfig[13+1].drinktimes

    if  _data.drinkCount >= (_cSdrink_freetimes.drink.times + vipDrinkTimeMax) then --已喝次数等于 免费+最大vip次数,提示明天再来
        ShowText(HLNSLocalizedString("daily.drinkWine.timesTotallyUsedUp" ))
        return
    end

    if  _data.drinkCount >= (_cSdrink_freetimes.drink.times + vipDrinkTime) then --已喝次数等于 免费+vip次数,提示是否充vip增加vip次数
        ShowText( HLNSLocalizedString("daily.drinkWine.timesUsedUp_UpVip" ))
        return
    end
    
    if  pointDrink >= maxPointDrink  then --已喝次数小于免费次数,但饮酒已超过最大潜力值 
        ShowText( HLNSLocalizedString("daily.drinkWine.pointBeyondMax" ))
        return  
    end

    if  _data.drinkCount >= _cSdrink_freetimes.drink.times  then --已喝次数大于免费次数,但是还有vip次数可用 。 

        if _nowDinkBtnClicked then --玩家按下了喝酒按钮
            local function cardConfirmAction(  )  
                _doActionDrinkWine()         
            end
            local function cardCancelAction(  )  
            end
            if wareHouseData:getItemCountById( "item_024" ) > 0 then -- 有醒酒茶

                getMainLayer():getParent():addChild(createSimpleConfirCardLayer( HLNSLocalizedString("daily.drinkWine.freeTimesUsedUp_useBag" )))
                SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
                SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
            else                                              -- 没有醒酒茶
                getMainLayer():getParent():addChild(createSimpleConfirCardLayer( 
                    string.format(HLNSLocalizedString("daily.drinkWine.freeTimesUsedUp_buy" ), 
                    _cSdrink_othercosts.tea.gold )  ) ,100)
                SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
                SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
            end
            return
            
        elseif _nowChangeWineBtnClick or _nowOneBtnChangeWineBtnClick then --玩家按下 换酒按钮
            local nowChangeWineBtnClick = _nowChangeWineBtnClick  --因为_nowChangeWineBtnClick在用过之后,马上会被还原
            local nowOneBtnChangeWineBtnClick = _nowOneBtnChangeWineBtnClick

            if not _haveWarned then --只提醒一次 没提醒过的话提醒一下
                local function cardConfirmAction(  )
                    _haveWarned = true 
                    if nowChangeWineBtnClick then
                        print("**lsf _nowChangeWine1")
                        _doActionChangeWine()
                    elseif nowOneBtnChangeWineBtnClick then
                         _doActionOneBtnChangeWine()
                    end   
                       
                end
                local function cardCancelAction(  )  
                end      
                getMainLayer():getParent():addChild(createSimpleConfirCardLayer( 
                    string.format(HLNSLocalizedString("daily.drinkWine.freeTimesUsedUp_change" ), 
                    _cSdrink_othercosts.tea.gold )  ))
                SimpleConfirmCard.confirmMenuCallBackFun = cardConfirmAction
                SimpleConfirmCard.cancelMenuCallBackFun = cardCancelAction
                
                
                return
        
            else --已经提醒过了
                if _nowChangeWineBtnClick then
                     _doActionChangeWine()
                elseif _nowOneBtnChangeWineBtnClick then
                     _doActionOneBtnChangeWine()
                end
                return
            end
        end

    end

    if  _data.drinkCount < _cSdrink_freetimes.drink.times  then --已喝次数小于免费次数 可以随便喝 随便换酒
        if _nowDinkBtnClicked then
            _doActionDrinkWine()
        elseif _nowChangeWineBtnClick then
            _doActionChangeWine()
        elseif _nowOneBtnChangeWineBtnClick then
            _doActionOneBtnChangeWine()
        end

        return
    end

end


-- 喝酒按钮 
local function drinkBtnClick()
    _nowDinkBtnClicked = true
    _theInspector () 
    _nowDinkBtnClicked = false
end 
DailyDrinkWineViewOwner["drinkBtnClick"] = drinkBtnClick


-- 换酒按钮 
local function changeWineBtnClick()
    if isAnimation then
        return
    end
    _nowChangeWineBtnClick = true 
    _theInspector ()
    _nowChangeWineBtnClick = false 
    
end 
DailyDrinkWineViewOwner["changeWineBtnClick"] = changeWineBtnClick


-- 一键换酒按钮 
local function oneBtnChangeWineBtnClick()  
     _nowOneBtnChangeWineBtnClick = true
    _theInspector ()
     _nowOneBtnChangeWineBtnClick = false
end 
DailyDrinkWineViewOwner["oneBtnChangeWineBtnClick"] = oneBtnChangeWineBtnClick


-- 瓶盖兑换
local function capExchangeBtnClick()
    if getMainLayer() then
        getMainLayer():addChild(createDailyDrinkCapExchangeLayer(-140), 100)
    end  
end 
DailyDrinkWineViewOwner["capExchangeBtnClick"] = capExchangeBtnClick



-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/DailyDrinkWineView.ccbi",proxy, true,"DailyDrinkWineViewOwner")
    _layer = tolua.cast(node,"CCLayer")
    _data = dailyData:getDrinkWineData()
    _curWineRank = _data.wineRank
    

    _enterLayer = tolua.cast(DailyDrinkWineViewOwner["enterLayer"], "CCLayer")
    _mainLayer = tolua.cast(DailyDrinkWineViewOwner["mainLayer"], "CCLayer")
    _enterLayer:setVisible(true)
    _mainLayer:setVisible(false)
    _size = _mainLayer:getContentSize()
    _cache = CCSpriteFrameCache:sharedSpriteFrameCache()

    _cSdrink_tabodds       = ConfigureStorage.Drink_tabodds    
    _cSdrink_buycap        = ConfigureStorage.Drink_buycap     
    _cSdrink_freetimes     = ConfigureStorage.Drink_freetimes  
    _cSdrink_changeWineCost = ConfigureStorage.Drink_changeWineCost   
    _cSdrink_othercosts    = ConfigureStorage.Drink_othercosts 
    _cSdrink_gainCap       = ConfigureStorage.Drink_gainCap    
    _cSdrink_rank          = ConfigureStorage.Drink_rank  
    _cSdrink_adout          = ConfigureStorage.Drink_adout  
    -- print("  drinkPage _cSdrink_tabodds")
    -- PrintTable(_cSdrink_tabodds)
    -- print("  drinkPage _cSdrink_buycap")
    -- PrintTable(_cSdrink_buycap)
    -- print("  drinkPage _cSdrink_freetimes")
    -- PrintTable(_cSdrink_freetimes)
    -- print("  drinkPage _cSdrink_changeWineCost")
    -- PrintTable(_cSdrink_changeWineCost)
    -- print("  drinkPage _cSdrink_othercosts")
    -- PrintTable(_cSdrink_othercosts)
    -- print("  drinkPage _cSdrink_gainCap")
    -- PrintTable(_cSdrink_gainCap)
    -- print("  drinkPage _cSdrink_rank")
    -- PrintTable(_cSdrink_rank)
    -- print("  drinkPage _cSdrink_adout")
    -- PrintTable(_cSdrink_adout)


    --刚进来时候位置摆放
    _putWinesPos()
    _ifIsFirstComeIn = true

    --一些文字的多语言版本
    local todayCapGet   = tolua.cast(DailyDrinkWineViewOwner["todayCapGet"],"CCLabelTTF")
    local drinkTimes    = tolua.cast(DailyDrinkWineViewOwner["drinkTimes"],"CCLabelTTF")
    local vipDrinkTimes = tolua.cast(DailyDrinkWineViewOwner["vipDrinkTimes"],"CCLabelTTF")
    todayCapGet:setString( HLNSLocalizedString("daily.drinkWine.todayCapGet")  )   
    drinkTimes:setString( HLNSLocalizedString("daily.drinkWine.drinkTimes")  )       
    vipDrinkTimes:setString( HLNSLocalizedString("daily.drinkWine.vipDrinkTimes") )   

    local capExchange = tolua.cast(DailyDrinkWineViewOwner["capExchange"],"CCLabelTTF")
    capExchange:setString( HLNSLocalizedString("daily.drinkWine.capExchange")  )   
    local underTitle = tolua.cast(DailyDrinkWineViewOwner["underTitle"],"CCLabelTTF")
    underTitle:setString( HLNSLocalizedString("daily.drinkWine.underTitle")  )   

    local vipDrinkTimeMax = ConfigureStorage.vipConfig[13 + 1].drinktimes
    if  _data.drinkCount >= (_cSdrink_freetimes.drink.times + vipDrinkTimeMax) then --已喝次数等于 免费+最大vip次数, 按钮变灰
        local changeWineBtn = tolua.cast(DailyDrinkWineViewOwner["changeWineBtn"] , "CCMenuItemImage")
        local oneBtnChangeWineBtn = tolua.cast(DailyDrinkWineViewOwner["oneBtnChangeWineBtn"] , "CCMenuItemImage")
        changeWineBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn7_2.png"))
        changeWineBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName( "btn7_2.png"))
        oneBtnChangeWineBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("btn7_2.png"))
        oneBtnChangeWineBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName( "btn7_2.png")) 
    end

end

-- 该方法名字每个文件不要重复
function getDailyDrinkWineViewLayer()
	return _layer
end

function createDailyDrinkWineViewLayer()
    _init()

    function _layer:changeState(state,HeroUId)
        if state == "main" then          
            _enterLayer:setVisible(false)
            _mainLayer:setVisible(true)
            _curHeroUId = HeroUId
            _refreshMainUI()
            
        end
    end

    local function _onEnter()

    end

    local function _onExit()
        _layer = nil
        _data = nil
        _tableView = nil
        isAnimation = false
        _haveWarned = false

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
            if _bAni then
                return true
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