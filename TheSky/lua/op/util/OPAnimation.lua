-- HLAnimation

-- 提示文字队列，切换场景时会清空
userTextArray = {}

-- 添加一个粒子效果
function HLAddParticle( plist, node, pos, duration, z, tag ,color)
    local ps = CCParticleSystemQuad:create(plist)
    -- ps:setDuration(duration)
    -- ps:setStartColor(ccc4(255,0,0,255))
    -- ps:setStartColor(ccc4f(1,0,0,1))
    ps:setPosition(pos)
    ps:setScale(ps:getScale() * winSize.width / 480)
    if color then
        ps:setStartColor(color)
    end
--[[
#ifdef UNI_VERSION
    if ([CCDirector sharedDirector].screenType >= Screen_iPad) {
        ps.scale = 2;
    }else{
        ps.scale = 1;
    }
#endif
--]]
    node:addChild(ps, z, tag)
end
-- 如果 isFollow 不为空，就产生追随效果
function HLAddParticleScale(plist, node, pos, duration, z, tag, scaleX, scaleY, isFollow)
    local ps = CCParticleSystemQuad:create(plist)
    -- ps:setDuration(duration)
    ps:setPosition(pos)
    if isFollow then
        ps:setPositionType(kCCPositionTypeGrouped)
    end
    -- ps:setStartColor(ccc4f(1,0,0,1))
    ps:setScaleX(scaleX * winSize.width / 480)
    ps:setScaleY(scaleY * winSize.width / 480)
--[[
#ifdef UNI_VERSION
    if ([CCDirector sharedDirector].screenType >= Screen_iPad) {
        ps.scale = 2;
    }else{
        ps.scale = 1;
    }
#endif
--]]
    node:addChild(ps, z, tag)
    return ps
end

function HLAddParticleScaleWithAction( plist, node, pos, duration, z, tag, scaleX, scaleY,action )
local ps = CCParticleSystemQuad:create(plist)
ps:setDuration(duration)
ps:setPosition(pos)
ps:setScaleX(scaleX * winSize.width / 480)
ps:setScaleY(scaleY * winSize.width / 480)
if action then
    ps:runAction(action)
end
--[[
#ifdef UNI_VERSION
if ([CCDirector sharedDirector].screenType >= Screen_iPad) {
    ps.scale = 2;
}else{
    ps.scale = 1;
}
#endif
--]]
node:addChild(ps, z, tag)
end

function HLAddParticleScaleWithColor( plist, node, pos, duration, z, tag, scaleX, scaleY ,beginColor,endColor)
    local ps = CCParticleSystemQuad:create(plist)
    ps:setDuration(duration)
    ps:setPosition(pos)
    ps:setStartColor(beginColor)
    ps:setEndColor(endColor)
    ps:setScaleX(scaleX * winSize.width / 480)
    ps:setScaleY(scaleY * winSize.width / 480)
--[[
#ifdef UNI_VERSION
    if ([CCDirector sharedDirector].screenType >= Screen_iPad) {
        ps.scale = 2;
    }else{
        ps.scale = 1;
    }
#endif
--]]
    node:addChild(ps, z, tag)
end

-- 圈住的粒子效果
function HLAddFrameParticle( plist, node, pos, width, height, color, duration, z, tag)
    local bIsPad = screenType >= Screen_iPad
    local top = CCParticleSystemQuad:create(plist)
    top:setDuration(duration)
    if color then
        top:setStartColor(color)
    end
    top:setPosition(ccp(pos.x ,pos.y + height / 2))
    top:setPosVar(ccp(width / (bIsPad and 4 or 2), 0))
    top:setTag(tag)
    if bIsPad then 
        top:setScale(2)
    end
    local bottom = CCParticleSystemQuad:create(plist)
    bottom:setDuration(duration)
    bottom:setPosition(ccp(pos.x, pos.y - height / 2))
    if color then
        bottom:setStartColor(color)
    end
    bottom:setPosVar(ccp(width / (bIsPad and 4 or 2), 0))
    bottom:setTag(tag)
    if bIsPad then 
        bottom:setScale(2)
    end
    local left = CCParticleSystemQuad:create(plist)
    left:setDuration(duration)
    if color then
        left:setStartColor(color)
    end
    left:setPosition(ccp(pos.x - width / 2,pos.y ))
    left:setPosVar(ccp(0, height / (bIsPad and 4 or 2)))
    left:setTag(tag)
    if bIsPad then 
        left:setScale(2)
    end
    local right = CCParticleSystemQuad:create(plist)
    right:setDuration(duration)
    if color then
        right:setStartColor(color)
    end
    right:setPosition(ccp(pos.x + width / 2, pos.y ))
    right:setPosVar(ccp(0, height / (bIsPad and 4 or 2)))
    right:setTag(tag)
    if bIsPad then 
        right:setScale(2)
    end
    node:addChild(top, z, tag)
    node:addChild(bottom, z, tag)
    node:addChild(left, z, tag)
    node:addChild(right, z, tag)
end

local function removeObject( object )
    object:removeFromParentAndCleanup(true)
end

local function _nodeAction( node, startPos, endPos )
    print(" Print By lixq ---- _nodeAction")
    local fade1 = CCFadeTo:create(0.5, 255)
    
    local move 
    if endPos then
        move = CCMoveTo:create(1, endPos)
    else
        move = CCMoveTo:create(0.5, ccpAdd(startPos, ccp(0, (-20 * retina))))
    end
    
    local bounce = CCEaseSineInOut:create(move)
    local spawn = CCSpawn:createWithTwoActions(fade1, bounce)
    local fade2 = CCFadeTo:create(1.2, 0)
    local remove = CCCallFuncN:create(removeObject)
    
    local array = CCArray:create()
    array:addObject(spawn)
    array:addObject(CCDelayTime:create(1.5))
    array:addObject(fade2)
    array:addObject(remove)

    local seq = CCSequence:create(array)
    
    node:setOpacity(0)
    node:runAction(seq)
end

local function playOver( node )
    userTextArray = {}
end

local function _nodeUpAction( node, startPos )
    print(" Print By lixq ---- _nodeUpAction")
    local fade1 = CCFadeTo:create(0.5, 255)
    print(" Print By lixq ---- _nodeUpAction startPos ", startPos.x, startPos.y)
    local move = CCMoveBy:create(0.5, ccp(0, 20 * retina))
    
    local bounce = CCEaseSineInOut:create(move)
    local spawn = CCSpawn:createWithTwoActions(fade1, bounce)
    local fade2 = CCFadeTo:create(1.2, 0)
    local remove = CCCallFuncN:create(removeObject)
    local playOver = CCCallFuncN:create(playOver)
    
    local array = CCArray:create()
    array:addObject(spawn)
    array:addObject(CCDelayTime:create(1.5))
    array:addObject(fade2)
    array:addObject(remove)
    array:addObject(playOver)

    local seq = CCSequence:create(array)

    node:setOpacity(0)
    node:runAction(seq)
end

-- 获得错误提示文字
local function _getErrorText( errorCode, response )
    print(" Print By lixq ---- _getErrorText", errorCode)
    local text = nil
    
    text = HLNSLocalizedString(string.format("ERR_%d", errorCode))

    if errorCode == ErrorCodeTable.ERR_1106 then
        local itemName = wareHouseData:getItemName(response["info"])
        text = HLNSLocalizedString("ERR_1106", itemName)
    elseif errorCode == ErrorCodeTable.ERR_1103 then
        -- ["ERR_1103"]  =  "体力不足",
        userdata.strength = tonumber(response["info"])
        postNotification(NOTI_STRENGTH, nil)
    elseif errorCode == ErrorCodeTable.ERR_1104 then
        -- ["ERR_1104"]  =  "精力不足",
        userdata.energy = tonumber(response["info"])
        postNotification(NOTI_ENERGY, nil)
    end

    return text
end

-- -- 向屏幕顶部弹出一个提示信息
-- -- startPos位置向上弹出一个提示信息
-- function HLShowUpText( node, text, startPos )
--     node = pDirector:getRunningScene()
--     print(" Print By lixq ---- HLShowUpText")
--     if not node or not text then
--         return
--     end
    
--     if not startPos then
--         startPos = ccp(winSize.width / 2, 280 * retina)
--         if screenType >= Screen_iPad then
--             startPos.y = 698 * retina
--         end
--     end

--     local fnt = "AmericanTypewriter"
--     local fntSize = HLFontSize(32)
--     local strSize = HLGetSizeWithStr(text, fnt, fntSize)
--     local boxSize = CCSizeMake(strSize.width, strSize.height)
--     -- local box = StretchBox:create(boxSize)
--     local box = CCScale9Sprite:create("images/textBg.png")
--     box:setContentSize(boxSize)
--     box:setAnchorPoint(ccp(0.5, 1))
    
--     local label = CCLabelTTF:create(text, fnt, fntSize, strSize, kCCTextAlignmentCenter)
--     label:setAnchorPoint(ccp(0.5, 0.5))
--     label:setPosition(ccp(box:getContentSize().width / 2, box:getContentSize().height / 2))
--     label:setColor(ccc3(255, 252, 150))
    
--     box:addChild(label)

--     -- local box = CCScale9Sprite:create("images/blb_cen.png")
--     -- box:setContentSize(boxSize)
    
--     if node then
--         local n = node
--         -- while not tolua.type(n, "CCScene") do
--         --     if n:getParent() then
--         --         local temp = n:getParent()
--         --         if not temp then
--         --             break
--         --         end
--         --         n = temp
--         --     else
--         --         return
--         --     end
--         -- end
--         box:setPosition(ccpAdd(startPos, ccp(0, 10 * retina)))
--         if #userTextArray > 0 then
--             local lastBox = userTextArray[#userTextArray]
--             print("userTextArray count = ***", #userTextArray)
--             if lastBox and lastBox:getPosition() then
--                 box:setPosition(ccp(lastBox:getPositionX(), lastBox:getPositionY() - lastBox:getContentSize().height - CGHeroLegendPointPosition_y(10 * retina)))
--             end
--         end
--         n:addChild(box, 1000)
--         table.insert(userTextArray, box)
        
--         print("userTextArray count = ", #userTextArray)
--         _nodeUpAction(box, startPos)
--     end
-- end

-- -- 弹出一个提示信息
-- -- 参数：startPos ： 弹出的位置
-- -- 样式：黑色半透明边框，字体颜色为淡黄色
-- -- 动画效果：startPos位置出现 -> 往下移动10个点 -> 渐变消失
-- function HLShowText( node, text, startPos, endPos )
--     print(" Print By lixq ---- HLShowText")
--     if not node or not text then
--         return
--     end

--     if not startPos then
--         HLShowUpText(node, text)
--         return
--     end
    
--     local fnt = "AmericanTypewriter";
--     -- wxd 适配ipad，20121112－10：45
--     local fntSize = HLFontSize(16);
--     local strSize = HLGetSizeWithStr(text, fnt, fntSize)
--     local boxSize = CCSizeMake(strSize.width + 10 * retina, strSize.height)
--     local box = StretchBox:create(boxSize)
--     box:setAnchorPoint(ccp(0.5, 0))
--     box:setPosition(ccpAdd(startPos, ccp(0, 10 * retina)))
    
--     local label = CCLabelTTF:create(text, fnt, fntSize, strSize, kCCTextAlignmentCenter)
--     label:setAnchorPoint(ccp(0.5, 0.5))
--     label:setPosition(ccp(box:getContentSize().width / 2, box:getContentSize().height / 2))
--     label:setColor(ccc3(255, 252, 150))
    
--     box:addChild(label)
--     node:addChild(box, 1000)
    
--     _nodeAction(box, startPos, endPos)
-- end

-- -- 弹出错误提示
-- function HLShowErrorText( node, errorCode, response, startPos )
--     print(" Print By lixq ---- HLShowErrorText")
--     if not node then
--         return
--     end
--     local text = _getErrorText(errorCode, response)
--     if not text then
--         return
--     end
--     HLShowText(node, text, startPos)
-- end

-- 弹出错误提示
function ShowErrorText(errorCode, response )
    local text = _getErrorText(errorCode, response)
    if not text then
        return
    end
    ShowText(text)
end

-- 在顶部弹出文字提示
function ShowText( text )
    local node = pDirector:getRunningScene()
    if not node or not text then
        return
    end
    
    -- if not startPos then
    --     startPos = ccp(winSize.width / 2, 280 * retina)
    --     if screenType >= Screen_iPad then
    --         startPos.y = 698 * retina
    --     end
    -- end
    local startPos = ccp(winSize.width / 2, winSize.height*9/10)

    local fnt = "ccbResources/FZCuYuan-M03S.ttf"
    local fntSize = HLFontSize(32)
    local strSize = HLGetSizeWithStr(text, fnt, fntSize)
    local boxSize = CCSizeMake(strSize.width+winSize.width*0.02, strSize.height*1.1)
    -- local box = StretchBox:create(boxSize)
    local box = CCScale9Sprite:create("images/grayBg.png")
    box:setContentSize(boxSize)
    box:setAnchorPoint(ccp(0.5, 1))
    
    local label = CCLabelTTF:create(text, fnt, fntSize, CCSizeMake(winSize.width * 0.96,strSize.height*1.1), kCCTextAlignmentCenter)
    label:setAnchorPoint(ccp(0.5, 0.5))
    label:setPosition(ccp(box:getContentSize().width / 2, box:getContentSize().height / 2))
    label:setColor(ccc3(255, 252, 150))
    
    box:addChild(label)
    if node then 
        box:setPosition(ccpAdd(startPos, ccp(0, 10 * retina)))
        node:addChild(box, 1000)
        _nodeUpAction(box, startPos)
    end
    
    -- if node then
    --     local n = node
    --     box:setPosition(ccpAdd(startPos, ccp(0, 10 * retina)))
    --     if #userTextArray > 0 then
    --         local lastBox = userTextArray[#userTextArray]
    --         print("userTextArray count = ***", #userTextArray)
    --         if lastBox and lastBox:getPosition() then
    --             box:setPosition(ccp(lastBox:getPositionX(), lastBox:getPositionY() - lastBox:getContentSize().height - CGHeroLegendPointPosition_y(10 * retina)))
    --         end
    --     end
    --     n:addChild(box, 1000)
    --     table.insert(userTextArray, box)
        
    --     _nodeUpAction(box, startPos)
    -- end
end

local function _spriteAction( sprite, startPos, endPos, delay )
    print(" Print By lixq ---- _spriteAction")
    local fade1 = CCFadeTo:create(0.5, 255)
    local move = CCMoveTo:create(0.5, startPos)
    local bounce = CCEaseBounceOut:create(move)
    local spawn1 = CCSpawn:createWithTwoActions(fade1, bounce)
    local flyOut = CCMoveTo:create(0.5, endPos)
    local fade2 = CCFadeTo:create(0.5, 0)
    local spawn2 = CCSpawn:createWithTwoActions(fade2, flyOut)
    local remove = CCCallFuncN:create(removeObject)
    
    local array = CCArray:create()
    array:addObject(CCDelayTime:create(delay))
    array:addObject(spawn1)
    array:addObject(CCDelayTime:create(1.5))
    array:addObject(spawn2)
    array:addObject(remove)

    local seq = CCSequence:create(array)

    sprite:runAction(seq)
end

local function _labelAction( label, startPos, delay )
    local fade1 = CCFadeTo:create(0.5, 255)
    local pos = ccpAdd(startPos, ccp(0,  CGHeroLegendPointPosition_y(-20 * retina)))
    local move = CCMoveTo:create(0.5, pos)
    local bounce = CCEaseSineInOut:create(move)
    local spawn = CCSpawn:createWithTwoActions(fade1, bounce)
    local fade2 = CCFadeTo:create(1.2, 0)
    local remove = CCCallFuncN:create(removeObject)
    
    local array = CCArray:create()
    array:addObject(CCDelayTime:create(delay))
    array:addObject(spawn)
    array:addObject(CCDelayTime:create(1.5))
    array:addObject(fade2)
    array:addObject(remove)

    local seq = CCSequence:create(array)

    label:runAction(seq)
end

-- 收获多个道具
-- gainDic 收获道具,包括道具,装备,金币,银币,荣誉,精力
function animationNode( node, gainDic, fontName, fontSize )
    print(" Print By lixq ---- animationNode")
    local zOrder = 2000
    local delay = 0.2
    for key,value in pairs(gainDic) do
    -- for (NSString* key in gainDic) {
        zOrder = zOrder + 1
        local rand = RandomManager.random() % 100 - 50
        local startPos = CGHeroLegendPointMake((240 + rand) * retina, (160 + rand) * retina)
        local amount = value
        if key == "silver" then
            -- 银币
            local labelString = HLNSLocalizedString("basic.silver").."x"..amount
            local endPos = CGHeroLegendPointMake(340 * retina, 295 * retina)
            local sprite = CCSprite:createWithSpriteFrameName("pub_1_silverIcon.png")
            -- local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName("pub_1_silverIcon.png")
            -- if frame then
            --     sprite = [CCSprite spriteWithSpriteFrame:frame];
            -- }
            sprite:setPosition(ccpAdd(startPos, ccp(0, CGHeroLegendPointPosition_y(40 * retina))))
            sprite:setAnchorPoint(ccp(0, 0))
            sprite:setOpacity(0)
            -- CCShadowLabelTTF* label = [CCShadowLabelTTF shadowLabelWithString:labelString fontName:fontName fontSize:fontSize];
            local label = CCLabelTTF:create(labelString, fontName, fontSize)
            label:setPosition(ccpAdd(startPos, ccp(0,  CGHeroLegendPointPosition_y(10 * retina))))
            label:setAnchorPoint(ccp(0, 0))
            label:setOpacity(0)
            node:addChild(sprite, zOrder)
            node:addChild(label, zOrder)
            
            _spriteAction(sprite, startPos, endPos, delay)
            _labelAction(label, startPos, delay)
        elseif key == "gold" then
            local labelString = HLNSLocalizedString("basic.gold").."x"..amount
            local endPos = CGHeroLegendPointMake(410 * retina, 295 * retina)
            local sprite = CCSprite:createWithSpriteFrameName("pub_1_goldIcon.png")
            
            sprite:setPosition(ccpAdd(startPos, ccp(0, CGHeroLegendPointPosition_y(40 * retina))))
            sprite:setAnchorPoint(ccp(0, 0))
            sprite:setOpacity(0)
            -- CCShadowLabelTTF* label = [CCShadowLabelTTF shadowLabelWithString:labelString fontName:fontName fontSize:fontSize];
            local label = CCLabelTTF:create(labelString, fontName, fontSize)
            label:setPosition(ccpAdd(startPos, ccp(0, CGHeroLegendPointPosition_y(10 * retina))))
            label:setAnchorPoint(ccp(0, 0))
            label:setOpacity(0)
            node:addChild(sprite, zOrder)
            node:addChild(label, zOrder)
            
            _spriteAction(sprite, startPos, endPos, delay)
            _labelAction(label, startPos, delay)
        elseif key == "honor" then
            local labelString = HLNSLocalizedString("basic.honor").."x"..amount
            local endPos = CGHeroLegendPointMake(270 * retina, 295 * retina)
            local sprite = CCSprite:createWithSpriteFrameName("pub_1_honor.png")
            
            sprite:setPosition(ccpAdd(startPos, ccp(0, CGHeroLegendPointPosition_y(40 * retina))))
            sprite:setAnchorPoint(ccp(0, 0))
            sprite:setOpacity(0)
            -- CCShadowLabelTTF* label = [CCShadowLabelTTF shadowLabelWithString:labelString fontName:fontName fontSize:fontSize];
            local label = CCLabelTTF:create(labelString, fontName, fontSize)
            label:setPosition(ccpAdd(startPos, ccp(0, CGHeroLegendPointPosition_y(10 * retina))))
            label:setAnchorPoint(ccp(0, 0))
            label:setOpacity(0)
            node:addChild(sprite, zOrder)
            node:addChild(label, zOrder)
            
            _spriteAction(sprite, startPos, endPos, delay)
            _labelAction(label, startPos, delay)
        elseif key == "senergy" or key == "energy" then
            local labelString = HLNSLocalizedString("basic.energy").."x"..amount
            local endPos = CGHeroLegendPointMake(75 * retina, 295 * retina)
            local sprite = CCSprite:createWithSpriteFrameName("pub_1_energy.png")

            sprite:setPosition(ccpAdd(startPos, ccp(0, CGHeroLegendPointPosition_y(40 * retina))))
            sprite:setAnchorPoint(ccp(0, 0))
            sprite:setOpacity(0)
            -- CCShadowLabelTTF* label = [CCShadowLabelTTF shadowLabelWithString:labelString fontName:fontName fontSize:fontSize];
            local label = CCLabelTTF:create(labelString, fontName, fontSize)
            label:setPosition(ccpAdd(startPos, ccp(0, CGHeroLegendPointPosition_y(10 * retina))))
            label:setAnchorPoint(ccp(0, 0))
            label:setOpacity(0)
            node:addChild(sprite, zOrder)
            node:addChild(label, zOrder)
            
            _spriteAction(sprite, startPos, endPos, delay)
            _labelAction(label, startPos, delay)
        else
            local itemDic = getItemConfigInfoById(key)
            if itemDic then
                local resDic = getResourceInfoWithId(key)
                local labelString = resDic["name"].."x"..amount
                local endPos = CGHeroLegendPointMake(65 * retina, 5 * retina)
                local sprite = CCSprite:createWithSpriteFrameName("pub_1_itemBg_"..resDic["rank"]..".png")
                if sprite then
                    sprite:setPosition(ccpAdd(startPos, ccp(0,  CGHeroLegendPointPosition_y(40 * retina))))
                    sprite:setAnchorPoint(ccp(0, 0))
                    node:addChild(sprite, zOrder)
                    local image = CCSprite:createWithSpriteFrameName(resDic["icon"])
                    if image then
                        local size = sprite:getContentSize()
                        local imageSize = image:getContentSize()
                        image:setPosition(size.width / 2, size.height / 2)
                        image:setScale(size.width / imageSize.width * 0.9)
                        sprite:addChild(image, 1, 1)
                    end
                    sprite:setOpacity(0)
                    
                    if resDic["seq"] then
                        local seq = CCSprite:createWithSpriteFrameName("luoma_"..resDic["seq"]..".png")
                        seq:setPosition(sprite:getContentSize().width / 2, sprite:getContentSize().height / 2)
                        sprite:addChild(seq, 2)
                    end
                    _spriteAction(sprite, startPos, endPos, delay)
                end
                -- CCShadowLabelTTF* label = [CCShadowLabelTTF shadowLabelWithString:labelString fontName:fontName fontSize:fontSize];
                local label = CCLabelTTF:create(labelString, fontName, fontSize)
                label:setPosition(ccpAdd(startPos, ccp(0,  CGHeroLegendPointPosition_y(10 * retina))))
                label:setAnchorPoint(ccp(0, 0))
                label:setOpacity(0)
                node:addChild(label, zOrder)
                
                _labelAction(label, startPos, delay)
            end
            if string.find(key, "equip") then
                local gainEquip = value
                local tid = gainEquip["tid"]
                local equipDic = getEquipConfigInfoById(tid)
                local labelString = equipDic["name"].."x1"
                local endPos = CGHeroLegendPointMake(65 * retina, 5 * retina)
                local sprite = CCSprite:createWithSpriteFrameName("pub_1_itemBg_"..equipDic["rank"]..".png")
                if sprite then
                    sprite:setPosition(ccpAdd(startPos, ccp(0,  CGHeroLegendPointPosition_y(40 * retina))))
                    sprite:setAnchorPoint(ccp(0, 0))
                    node:addChild(sprite, zOrder)
                    local image = CCSprite:createWithSpriteFrameName(equipDic["image"])
                    if image then
                        local size = sprite:getContentSize()
                        image:setPosition(size.width / 2, size.height / 2)
                        sprite:addChild(image, 1, 1)
                    end
                    sprite:setOpacity(0)
                    _spriteAction(sprite, startPos, endPos, delay)
                end
                -- CCShadowLabelTTF* label = [CCShadowLabelTTF shadowLabelWithString:labelString fontName:fontName fontSize:fontSize];
                local label = CCLabelTTF:create(labelString, fontName, fontSize)
                label:setPosition(ccpAdd(startPos, ccp(0, CGHeroLegendPointPosition_y(10 * retina))))
                label:setAnchorPoint(ccp(0, 0))
                label:setOpacity(0)
                node:addChild(label, zOrder)
                
                _labelAction(label, startPos, delay)
            end
        end
        delay = delay + 0.3
    end
end

function hl_playScaleAnimation(node, duration, scale)
    local scaleAction = CCScaleBy:create(duration, scale)
    local reverse = scaleAction:reverse()
    local seq = CCSequence:createWithTwoActions(scaleAction, reverse)
    local rep = CCRepeatForever:create(seq)
    node:runAction(rep)
end

function HLAddMoveParticle(plist, node, pos, movingTime, moveByX, moveByY, delayTime, duration, z, tag, scaleX, scaleY)
    local ps = CCParticleSystemQuad:create(plist)
    ps:setDuration(duration)
    ps:setPosition(pos)
    ps:setScaleX(scaleX * winSize.width / 480)
    ps:setScaleY(scaleY * winSize.width / 480)
    node:addChild(ps, z, tag)
    local delay = CCDelayTime:create(delayTime)
    local moveBy = CCMoveBy:create(movingTime, ccp(moveByX, moveByY))
    ps:runAction(CCSequence:createWithTwoActions(delay, moveBy))
end

-- 添加一个旋转的光环
function HLAddRotatingCircleOnNode( node, tag, scale )
    if not tag then
        tag = 9999
    end
    local theRing = CCSprite:createWithSpriteFrameName("pub_1_circle.png")
    node:addChild(theRing)
    theRing:setAnchorPoint(ccp(0.5, 0.5))
    theRing:setScale(scale)
    theRing:setFlipX(true)
    theRing:setPosition(node:getContentSize().width / 2, node:getContentSize().height / 2)
    theRing:setTag(tag)
    local rot = CCRotateBy:create(1.25, 360)
    local rep = CCRepeatForever:create(rot)
    theRing:runAction(rep)
end

function HLPlayJumpUpAndZoomInAnimation( object, delayTime, scale, srcPosition, dstPosition )
    
    local function removeTheObjectFromParent( sender )
        local theSender = sender
        theSender:removeFromParentAndCleanup(true)
    end 


    local theObject = object
    local theDelayTime = delayTime
    local theScale = scale
    local theSrcPosition = srcPosition
    local theDstposition = dstPosition

    theObject:setScale(theScale)
    theObject:setPosition(theSrcPosition)
    local moveAction = CCMoveTo:create( theDelayTime, theDstposition )
    local scaleAction = CCScaleTo:create( theDelayTime ,2 )
    local spawnAction = CCSpawn:createWithTwoActions(moveAction ,scaleAction)

    local moveUp = CCMoveBy:create(0.5 ,ccp(0 ,10))
    local bounce = CCEaseBounceOut:create(moveUp)

    local theFadeOut = CCFadeOut:create(0.3)
    local theActionFinished = CCCallFuncN:create(removeTheObjectFromParent)

    local array = CCArray:create()
    array:addObject(spawnAction)
    array:addObject(bounce)
    array:addObject(theFadeOut)
    array:addObject(theActionFinished)
    local theSequence = CCSequence:create( array )

    theObject:runAction(theSequence)

end

-- 参数
-- 1:序列帧图片前缀 2:所在的节点 3：位置信息 4：开始帧 5:结束帧 6:自定义的颜色
function playCustomFrameAnimation( framePrefix,node,pos,startIndex,endIndex,CustomColor )
    local startSprite = node:getChildByTag(9888)
    if startSprite then
        startSprite:stopAllActions()
        startSprite:removeFromParentAndCleanup(true)
    end
    local startSprite = CCSprite:createWithSpriteFrameName(framePrefix..startIndex..".png")
    if CustomColor then
        startSprite:setColor(CustomColor)
    end
    local animFrames = CCArray:create()
    for i = startIndex, endIndex do
        local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(framePrefix..i..".png")
        animFrames:addObject(frame)
    end
    local animation = CCAnimation:createWithSpriteFrames(animFrames, 0.13)
    local animate = CCAnimate:create(animation)
    startSprite:runAction(CCRepeatForever:create(animate))
    node:addChild(startSprite,1,9888)
    startSprite:setPosition( pos )
end

function popUpUiAction( owner,name )
    local infoBg = tolua.cast(owner[name], "CCSprite")
    infoBg:setScale(0.4 * retina)
    local array = CCArray:create()
    array:addObject(CCScaleTo:create(0.06,1 * retina))
    array:addObject(CCDelayTime:create(0.04))
    array:addObject(CCScaleTo:create(0.04,1.04 * retina))
    array:addObject(CCDelayTime:create(0.04))
    array:addObject(CCScaleTo:create(0.04,1.02 * retina))
    array:addObject(CCScaleTo:create(0.04,1 * retina))
    infoBg:runAction(CCSequence:create(array))
end

function popUpCloseAction( owner,name,layer )
    local function closeAndRemove(  )
        if layer then
            layer:removeFromParentAndCleanup(true)
        end
    end
    if owner[name] then
        local infoBg = tolua.cast(owner[name], "CCSprite")
        local array = CCArray:create()
        array:addObject(CCScaleTo:create(0.04,1.03 * retina))
        array:addObject(CCDelayTime:create(0.04))
        array:addObject(CCScaleTo:create(0.04,1.06 * retina))
        array:addObject(CCDelayTime:create(0.04))
        array:addObject(CCScaleTo:create(0.04,0.4 * retina))
        array:addObject(CCCallFunc:create(closeAndRemove))
        infoBg:runAction(CCSequence:create(array))
    end
end
