local _layer
local _equipUId = nil
local _uiType = 0
local _priority = -132
local _huid
local _pos

local _tableView
local topData

-- 名字不要重复
AllTitleInfoOwner = AllTitleInfoOwner or {}
ccb["AllTitleInfoOwner"] = AllTitleInfoOwner

local function closeClick()
    if getTitleInfoLayer() then
        getTitleInfoLayer():removeFromParentAndCleanup(true)
    end
    popUpCloseAction( AllTitleInfoOwner,"infoBg",_layer )
end
AllTitleInfoOwner["closeClick"] = closeClick

local function onTopItemTaped( tag,sender )
    local finalArr = topData[tag]
    

    if finalArr.title.obtainFlag == 2 then
        if finalArr.conf.expire == 24 then
            -- 变暗的图标
            ShowText(HLNSLocalizedString("您的航海经历还不够丰富，多去冒险\n战斗，会有意外成就收获噢！"))
        else
            -- 显示锁的图标
            ShowText(HLNSLocalizedString("您的航海经历还不够丰富，多去冒险\n战斗，会有意外成就收获噢！"))
        end
    else
        -- 点亮的图标
        if getTitleInfoLayer() then
            getTitleInfoLayer():removeFromParentAndCleanup(true)
        end
        -- if not getMainLayer() then
            CCDirector:sharedDirector():getRunningScene():addChild(createTitleInfoLayer( finalArr["title"]["id"],1,_priority - 2),130) 
        -- else
        --     getMainLayer():addChild(createTitleInfoLayer( finalArr["title"]["id"],1,_priority - 2),130) 
        -- end
    end
end

AllTitleInfoOwner["onTopItemTaped"] = onTopItemTaped

-- 刷新UI数据
local function _refreshData()
    topData = titleData:getTopAllTitleInfo(  )
    
    for i=1,10 do
        local frameSprite = tolua.cast(AllTitleInfoOwner["frame"..i],"CCMenuItemImage")

        local avatarSprite = tolua.cast(AllTitleInfoOwner["avatarSprite"..i],"CCSprite")

        local shadowLayer = tolua.cast(AllTitleInfoOwner["shadowLayer"..i],"CCSprite")

        local titleLabel = tolua.cast(AllTitleInfoOwner["titleLabel"..i],"CCLabelTTF")
        if getMyTableCount(topData) < i then
            frameSprite:setVisible(false)
            avatarSprite:setVisible(false)
            titleLabel:setVisible(false)
            shadowLayer:setVisible(false)
        else
            if topData[i].title.obtainFlag == 2 then
                if topData[i].conf.expire == 24 then
                    shadowLayer:setVisible(true)
                    titleLabel:setString(topData[i].conf.name)
                    if avatarSprite then
                        local texture = CCTextureCache:sharedTextureCache():addImage(equipdata:getEquipIconByEquipId( topData[i].title.titleId ))
                        if texture then
                            avatarSprite:setVisible(true)
                            avatarSprite:setTexture(texture)
                        end
                    end
                else
                    -- 显示锁的图标
                    frameSprite:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("frame_lock.png"))
                    frameSprite:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("frame_lock.png"))
                    titleLabel:setVisible(false)
                    -- frameSprite:setEnabled(false)
                end
            else
                -- 点亮
                if avatarSprite then
                    local texture = CCTextureCache:sharedTextureCache():addImage(equipdata:getEquipIconByEquipId( topData[i].title.titleId ))
                    if texture then
                        avatarSprite:setVisible(true)
                        avatarSprite:setTexture(texture)
                    end
                end
                frameSprite:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%s.png",topData[i].conf.colorRank)))
                frameSprite:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%s.png",topData[i].conf.colorRank)))
                titleLabel:setString(topData[i].conf.name)
            end
        end
    end
end

local function _addTableView()
    -- 得到数据
    local _bottomLayer = AllTitleInfoOwner["bottomLayer"]
    local _bottomData = titleData:getBottomAllTitleInfo( )

    TitleTableCellOwner = TitleTableCellOwner or {}
    ccb["TitleTableCellOwner"] = TitleTableCellOwner

    local function bottomItemTaped( tag,sender )
        local finalArr = _bottomData[tag]

        if finalArr.title.obtainFlag == 2 then
            if finalArr.title.obtainTime == -1 then
                ShowText(HLNSLocalizedString("您的航海经历还不够丰富，多去冒险\n战斗，会有意外成就收获噢！"))
            else
                if getTitleInfoLayer() then
                    getTitleInfoLayer():removeFromParentAndCleanup(true)
                end
                -- if not getMainLayer() then
                    CCDirector:sharedDirector():getRunningScene():addChild(createTitleInfoLayer( finalArr["title"]["id"],1,_priority - 2),130) 
                -- else
                --     getMainLayer():addChild(createTitleInfoLayer( finalArr["title"]["id"],1,_priority - 2),130) 
                -- end
            end
        else
            if getTitleInfoLayer() then
                getTitleInfoLayer():removeFromParentAndCleanup(true)
            end
            -- if not getMainLayer() then
                CCDirector:sharedDirector():getRunningScene():addChild(createTitleInfoLayer( finalArr["title"]["id"],1,_priority - 2),130) 
            -- else
            --     getMainLayer():addChild(createTitleInfoLayer( finalArr["title"]["id"],1,_priority - 2),130) 
            -- end
        end
    end

    TitleTableCellOwner["bottomItemTaped"] = bottomItemTaped

    local h = LuaEventHandler:create(function(fn, table, a1, a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(winSize.width, 150)
        elseif fn == "cellAtIndex" then
            -- Return CCTableViewCell, a1 is cell index (zero based), a2 is dequeued cell (maybe nil)
            -- Do something to create cell  and change the content
            
            if a2 then
                a2:removeAllChildrenWithCleanup(true)
            else 
                a2 = CCTableViewCell:create()
            end
            local  proxy = CCBProxy:create()
            local  _hbCell = tolua.cast(CCBReaderLoad("ccbResources/TitleBottomTableCell.ccbi",proxy,true,"TitleTableCellOwner"),"CCLayer")

            local menu1 = tolua.cast(TitleTableCellOwner["cellMenu"], "CCMenu")
            if menu1 then
                menu1:setTouchPriority(_priority - 1)
            end

            for i=1,5 do
                local titleLabel = tolua.cast(TitleTableCellOwner["nameLabel"..i],"CCLabelTTF")
                local avatarBtn = tolua.cast(TitleTableCellOwner["avatarBtn"..i],"CCMenuItemImage")
                local avatarSprite = tolua.cast(TitleTableCellOwner["rankSprite"..i],"CCSprite")
                local shadowLayer = tolua.cast(TitleTableCellOwner["shadow"..i],"CCLayer")

                avatarBtn:setTag((a1 * 5) + i)

                -- obtainFlag 为1 置为亮   为2  判断  如果有时效性灰色，如果没有时效性锁

                if (a1 * 5) + i > getMyTableCount(_bottomData) then
                    titleLabel:setVisible(false)
                    avatarBtn:setVisible(false)
                    avatarSprite:setVisible(false)
                else
                    if _bottomData[(a1 * 5) + i].title.obtainFlag == 2 then
                        if _bottomData[(a1 * 5) + i].title.obtainTime == -1 then
                            avatarBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("frame_lock.png"))
                            avatarBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("frame_lock.png"))
                            titleLabel:setVisible(false)
                        else
                            -- if _bottomData[(a1 * 5) + i].conf.expire == 24 then
                                shadowLayer:setVisible(true)
                                titleLabel:setString(_bottomData[(a1 * 5) + i].conf.name)
                                if avatarSprite then
                                    local texture = CCTextureCache:sharedTextureCache():addImage(equipdata:getEquipIconByEquipId( _bottomData[(a1 * 5) + i].title.titleId ))
                                    if texture then
                                        avatarSprite:setVisible(true)
                                        avatarSprite:setTexture(texture)
                                    end
                                end
                        end
                    else
                        -- 点亮
                        if avatarSprite then
                            local texture = CCTextureCache:sharedTextureCache():addImage(equipdata:getEquipIconByEquipId( _bottomData[(a1 * 5) + i].title.titleId ))
                            if texture then
                                avatarSprite:setVisible(true)
                                avatarSprite:setTexture(texture)
                            end
                        end
                        avatarBtn:setNormalSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%s.png",_bottomData[(a1 * 5) + i].conf.colorRank)))
                        avatarBtn:setSelectedSpriteFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(string.format("frame_%s.png",_bottomData[(a1 * 5) + i].conf.colorRank)))
                        titleLabel:setString(_bottomData[(a1 * 5) + i].conf.name)

                        if _bottomData[(a1 * 5) + i].conf.expire == 24 then
                            if (userdata.loginTime - _bottomData[(a1 * 5) + i].title.obtainTime) >= (24 * 3600) then
                                shadowLayer:setVisible(true)
                                titleLabel:setString(_bottomData[(a1 * 5) + i].conf.name)
                                if avatarSprite then
                                    local texture = CCTextureCache:sharedTextureCache():addImage(equipdata:getEquipIconByEquipId( _bottomData[(a1 * 5) + i].title.titleId ))
                                    if texture then
                                        avatarSprite:setVisible(true)
                                        avatarSprite:setTexture(texture)
                                    end
                                end
                            end
                        end
                    end
                end
            end

            -- _hbCell:setScale(retina)
            a2:addChild(_hbCell, 0, 1)
            a2:setAnchorPoint(ccp(0, 0))
            a2:setPosition(0, 0)
            r = a2
        elseif fn == "numberOfCells" then
            -- Return number of cells
            -- r = 5
            r = math.ceil(getMyTableCount(_bottomData) / 5)
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
    local size = CCSizeMake(_bottomLayer:getContentSize().width, _bottomLayer:getContentSize().height)  -- 这里是为了在tableview上面显示一个小空出来
    _tableView = LuaTableView:createWithHandler(h, size)
    _tableView:setBounceable(true)
    _tableView:setAnchorPoint(ccp(0,0))
    _tableView:setPosition(0,0)
    _tableView:setVerticalFillOrder(0)
    _bottomLayer:addChild(_tableView)
    _tableView:setTouchPriority(_priority - 1)
end

-- private方法如果没有上下调用关系可以写在createLayer外面
local function _init()
    -- get layer
    local  proxy = CCBProxy:create()
    local  node  = CCBReaderLoad("ccbResources/AllTitleInfoView.ccbi", proxy, true,"AllTitleInfoOwner")
    _layer = tolua.cast(node,"CCLayer")
    _refreshData()
end

local function onTouchBegan(x, y)
    local touchLocation = _layer:convertToNodeSpace(ccp(x, y))
    local infoBg = tolua.cast(AllTitleInfoOwner["infoBg"], "CCSprite")
    local rect = infoBg:boundingBox()
    if not rect:containsPoint(touchLocation) then

        popUpCloseAction( AllTitleInfoOwner,"infoBg",_layer )
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
    local menu1 = tolua.cast(AllTitleInfoOwner["closeMenu"], "CCMenu")
    menu1:setHandlerPriority(_priority - 1)
    local menu2 = tolua.cast(AllTitleInfoOwner["topMenu"], "CCMenu")
    menu2:setHandlerPriority(_priority - 1)
    -- local bottomLayer = tolua.cast(AllTitleInfoOwner["bottomLayer"], "CCLayer")
    -- bottomLayer:setTouchPriority(_priority - 1)

    
end

-- 该方法名字每个文件不要重复
function getAllTitleInfoLayer()
	return _layer
end

function createAllTitleInfoLayer(priority)
    _priority = (priority ~= nil) and priority or -132
    _init()

    local function _onEnter()
        _addTableView()
        local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.5), CCCallFunc:create(setMenuPriority))
        _layer:runAction(seq)

        -- local infoBg = tolua.cast(AllTitleInfoOwner["infoBg"], "CCSprite")
        -- infoBg:setScale(0.01)
        -- infoBg:runAction(CCEaseBounceOut:create(CCScaleTo:create(0.6,1)))

        popUpUiAction( AllTitleInfoOwner,"infoBg" )
    end

    local function _onExit()
        print("onExit")
        _layer = nil
        _tableView = nil     
    end

    --onEnter onExit
    local function _layerEventHandler(eventType)
        if eventType == "enter" then
            if _onEnter then _onEnter() end
        elseif eventType == "exit" then
            if _onExit then _onExit() end
        end
    end


    _layer:registerScriptTouchHandler(onTouch ,false ,_priority ,true )
    _layer:setTouchEnabled(true)
    _layer:registerScriptHandler(_layerEventHandler)

    return _layer
end