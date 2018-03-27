--------------------------------------------------------------
-- This file was automatically generated by Cocos Studio.
-- Do not make changes to this file.
-- All changes will be lost.
--------------------------------------------------------------

local luaExtend = require "LuaExtend"

-- using for layout to decrease count of local variables
local layout = nil
local localLuaFile = nil
local innerCSD = nil
local innerProject = nil
local localFrame = nil

local Result = {}
------------------------------------------------------------
-- function call description
-- create function caller should provide a function to 
-- get a callback function in creating scene process.
-- the returned callback function will be registered to 
-- the callback event of the control.
-- the function provider is as below :
-- Callback callBackProvider(luaFileName, node, callbackName)
-- parameter description:
-- luaFileName  : a string, lua file name
-- node         : a Node, event source
-- callbackName : a string, callback function name
-- the return value is a callback function
------------------------------------------------------------
function Result.create(callBackProvider)

local result={}
setmetatable(result, luaExtend)

--Create Node
local Node=cc.Node:create()
Node:setName("Node")
Node:setLocalZOrder(0)

--Create bg
local bg = ccui.ImageView:create()
bg:ignoreContentAdaptWithSize(false)
bg:loadTexture("server_exercise/res/3.png",0)

bg:setFlippedX(false)
bg:setFlippedY(false)

bg:setScale9Enabled(false)
bg:setCapInsets(cc.rect(0,0,358,558))
bg:setTouchEnabled(false)
bg:setLayoutComponentEnabled(true)
bg:setName("bg")
bg:setLocalZOrder(0)
bg:setTag(57)
bg:setCascadeColorEnabled(true)
bg:setCascadeOpacityEnabled(true)
bg:setVisible(true)
bg:setAnchorPoint(0.5, 0.5)
bg:setPosition(182.8276, 283.5679)
bg:setScaleX(1)
bg:setScaleY(1)
bg:setRotation(0)
bg:setRotationSkewX(0)
bg:setRotationSkewY(0)
bg:setOpacity(255)
bg:setColor(cc.c3b(255, 255, 255))
layout = ccui.LayoutComponent:bindLayoutComponent(bg)
layout:setPositionPercentXEnabled(false)
layout:setPositionPercentYEnabled(false)
layout:setPositionPercentX(0)
layout:setPositionPercentY(0)
layout:setPercentWidthEnabled(false)
layout:setPercentHeightEnabled(false)
layout:setPercentWidth(0)
layout:setPercentHeight(0)

layout:setSize(cc.size(358, 558))

layout:setHorizontalEdge(0)
layout:setVerticalEdge(0)
layout:setLeftMargin(3.8276)
layout:setRightMargin(-361.8276)
layout:setTopMargin(-562.5679)
layout:setBottomMargin(4.5679)
layout:setStretchWidthEnabled(false)
layout:setStretchHeightEnabled(false)
Node:addChild(bg)

--Create level
local level = ccui.Text:create()
level:ignoreContentAdaptWithSize(true)
level:setTextAreaSize(cc.size(0, 0))
level:setFontName("Resources/font/ttf/black_body.TTF")
level:setFontSize(22)
level:setString([[LV.999]])
level:setTextHorizontalAlignment(0)
level:setTextVerticalAlignment(0)
level:setTouchScaleChangeEnabled(false)
level:setFlippedX(false)
level:setFlippedY(false)
level:setTouchEnabled(false)
level:setLayoutComponentEnabled(true)
level:setName("level")
level:setLocalZOrder(0)
level:setTag(58)
level:setCascadeColorEnabled(true)
level:setCascadeOpacityEnabled(true)
level:setVisible(true)
level:setAnchorPoint(0, 0.6049)
level:setPosition(31.267, 463.929)
level:setScaleX(1)
level:setScaleY(1)
level:setRotation(0)
level:setRotationSkewX(0)
level:setRotationSkewY(0)
level:setOpacity(255)
level:setColor(cc.c3b(255, 255, 255))
layout = ccui.LayoutComponent:bindLayoutComponent(level)
layout:setPositionPercentXEnabled(false)
layout:setPositionPercentYEnabled(false)
layout:setPositionPercentX(0)
layout:setPositionPercentY(0)
layout:setPercentWidthEnabled(false)
layout:setPercentHeightEnabled(false)
layout:setPercentWidth(0)
layout:setPercentHeight(0)

layout:setSize(cc.size(86, 25))

layout:setHorizontalEdge(0)
layout:setVerticalEdge(0)
layout:setLeftMargin(31.267)
layout:setRightMargin(-117.267)
layout:setTopMargin(-473.8065)
layout:setBottomMargin(448.8065)
layout:setStretchWidthEnabled(false)
layout:setStretchHeightEnabled(false)
Node:addChild(level)

--Create Fightingnum
local Fightingnum = ccui.Text:create()
Fightingnum:ignoreContentAdaptWithSize(true)
Fightingnum:setTextAreaSize(cc.size(0, 0))
Fightingnum:setFontName("Resources/font/ttf/black_body.TTF")
Fightingnum:setFontSize(24)
Fightingnum:setString([[战斗力:   23232323]])
Fightingnum:setTextHorizontalAlignment(0)
Fightingnum:setTextVerticalAlignment(0)
Fightingnum:setTouchScaleChangeEnabled(false)
Fightingnum:setFlippedX(false)
Fightingnum:setFlippedY(false)
Fightingnum:setTouchEnabled(false)
Fightingnum:setLayoutComponentEnabled(true)
Fightingnum:setName("Fightingnum")
Fightingnum:setLocalZOrder(0)
Fightingnum:setTag(59)
Fightingnum:setCascadeColorEnabled(true)
Fightingnum:setCascadeOpacityEnabled(true)
Fightingnum:setVisible(true)
Fightingnum:setAnchorPoint(0, 0.6049)
Fightingnum:setPosition(63.1809, 183.3854)
Fightingnum:setScaleX(1)
Fightingnum:setScaleY(1)
Fightingnum:setRotation(0)
Fightingnum:setRotationSkewX(0)
Fightingnum:setRotationSkewY(0)
Fightingnum:setOpacity(255)
Fightingnum:setColor(cc.c3b(255, 255, 255))
layout = ccui.LayoutComponent:bindLayoutComponent(Fightingnum)
layout:setPositionPercentXEnabled(false)
layout:setPositionPercentYEnabled(false)
layout:setPositionPercentX(0)
layout:setPositionPercentY(0)
layout:setPercentWidthEnabled(false)
layout:setPercentHeightEnabled(false)
layout:setPercentWidth(0)
layout:setPercentHeight(0)

layout:setSize(cc.size(229, 27))

layout:setHorizontalEdge(0)
layout:setVerticalEdge(0)
layout:setLeftMargin(63.1809)
layout:setRightMargin(-292.1809)
layout:setTopMargin(-194.0531)
layout:setBottomMargin(167.0531)
layout:setStretchWidthEnabled(false)
layout:setStretchHeightEnabled(false)
Node:addChild(Fightingnum)

--Create shenglv
local shenglv = ccui.Text:create()
shenglv:ignoreContentAdaptWithSize(true)
shenglv:setTextAreaSize(cc.size(0, 0))
shenglv:setFontName("Resources/font/ttf/black_body.TTF")
shenglv:setFontSize(20)
shenglv:setString([[胜率:]])
shenglv:setTextHorizontalAlignment(0)
shenglv:setTextVerticalAlignment(0)
shenglv:setTouchScaleChangeEnabled(false)
shenglv:setFlippedX(false)
shenglv:setFlippedY(false)
shenglv:setTouchEnabled(false)
shenglv:setLayoutComponentEnabled(true)
shenglv:setName("shenglv")
shenglv:setLocalZOrder(0)
shenglv:setTag(60)
shenglv:setCascadeColorEnabled(true)
shenglv:setCascadeOpacityEnabled(true)
shenglv:setVisible(true)
shenglv:setAnchorPoint(0, 0.6049)
shenglv:setPosition(80.2661, 141.2089)
shenglv:setScaleX(1)
shenglv:setScaleY(1)
shenglv:setRotation(0)
shenglv:setRotationSkewX(0)
shenglv:setRotationSkewY(0)
shenglv:setOpacity(255)
shenglv:setColor(cc.c3b(255, 255, 255))
layout = ccui.LayoutComponent:bindLayoutComponent(shenglv)
layout:setPositionPercentXEnabled(false)
layout:setPositionPercentYEnabled(false)
layout:setPositionPercentX(0)
layout:setPositionPercentY(0)
layout:setPercentWidthEnabled(false)
layout:setPercentHeightEnabled(false)
layout:setPercentWidth(0)
layout:setPercentHeight(0)

layout:setSize(cc.size(47, 23))

layout:setHorizontalEdge(0)
layout:setVerticalEdge(0)
layout:setLeftMargin(80.2661)
layout:setRightMargin(-127.2661)
layout:setTopMargin(-150.2962)
layout:setBottomMargin(127.2962)
layout:setStretchWidthEnabled(false)
layout:setStretchHeightEnabled(false)
Node:addChild(shenglv)

--Create winning
local winning = ccui.Text:create()
winning:ignoreContentAdaptWithSize(true)
winning:setTextAreaSize(cc.size(0, 0))
winning:setFontName("Resources/font/ttf/black_body.TTF")
winning:setFontSize(20)
winning:setString([[38%]])
winning:setTextHorizontalAlignment(0)
winning:setTextVerticalAlignment(0)
winning:setTouchScaleChangeEnabled(false)
winning:setFlippedX(false)
winning:setFlippedY(false)
winning:setTouchEnabled(false)
winning:setLayoutComponentEnabled(true)
winning:setName("winning")
winning:setLocalZOrder(0)
winning:setTag(61)
winning:setCascadeColorEnabled(true)
winning:setCascadeOpacityEnabled(true)
winning:setVisible(true)
winning:setAnchorPoint(0, 0.6049)
winning:setPosition(204.6664, 141.2089)
winning:setScaleX(1)
winning:setScaleY(1)
winning:setRotation(0)
winning:setRotationSkewX(0)
winning:setRotationSkewY(0)
winning:setOpacity(255)
winning:setColor(cc.c3b(255, 255, 255))
layout = ccui.LayoutComponent:bindLayoutComponent(winning)
layout:setPositionPercentXEnabled(false)
layout:setPositionPercentYEnabled(false)
layout:setPositionPercentX(0)
layout:setPositionPercentY(0)
layout:setPercentWidthEnabled(false)
layout:setPercentHeightEnabled(false)
layout:setPercentWidth(0)
layout:setPercentHeight(0)

layout:setSize(cc.size(46, 23))

layout:setHorizontalEdge(0)
layout:setVerticalEdge(0)
layout:setLeftMargin(204.6664)
layout:setRightMargin(-250.6664)
layout:setTopMargin(-150.2962)
layout:setBottomMargin(127.2962)
layout:setStretchWidthEnabled(false)
layout:setStretchHeightEnabled(false)
Node:addChild(winning)

--Create integral
local integral = ccui.Text:create()
integral:ignoreContentAdaptWithSize(true)
integral:setTextAreaSize(cc.size(0, 0))
integral:setFontName("Resources/font/ttf/black_body.TTF")
integral:setFontSize(20)
integral:setString([[59999]])
integral:setTextHorizontalAlignment(0)
integral:setTextVerticalAlignment(0)
integral:setTouchScaleChangeEnabled(false)
integral:setFlippedX(false)
integral:setFlippedY(false)
integral:setTouchEnabled(false)
integral:setLayoutComponentEnabled(true)
integral:setName("integral")
integral:setLocalZOrder(0)
integral:setTag(62)
integral:setCascadeColorEnabled(true)
integral:setCascadeOpacityEnabled(true)
integral:setVisible(true)
integral:setAnchorPoint(0, 0.6049)
integral:setPosition(204.6664, 105.6421)
integral:setScaleX(1)
integral:setScaleY(1)
integral:setRotation(0)
integral:setRotationSkewX(0)
integral:setRotationSkewY(0)
integral:setOpacity(255)
integral:setColor(cc.c3b(255, 255, 255))
layout = ccui.LayoutComponent:bindLayoutComponent(integral)
layout:setPositionPercentXEnabled(false)
layout:setPositionPercentYEnabled(false)
layout:setPositionPercentX(0)
layout:setPositionPercentY(0)
layout:setPercentWidthEnabled(false)
layout:setPercentHeightEnabled(false)
layout:setPercentWidth(0)
layout:setPercentHeight(0)

layout:setSize(cc.size(65, 23))

layout:setHorizontalEdge(0)
layout:setVerticalEdge(0)
layout:setLeftMargin(204.6664)
layout:setRightMargin(-269.6664)
layout:setTopMargin(-114.7294)
layout:setBottomMargin(91.7294)
layout:setStretchWidthEnabled(false)
layout:setStretchHeightEnabled(false)
Node:addChild(integral)

--Create level_4
local level_4 = ccui.Text:create()
level_4:ignoreContentAdaptWithSize(true)
level_4:setTextAreaSize(cc.size(0, 0))
level_4:setFontName("Resources/font/ttf/black_body.TTF")
level_4:setFontSize(20)
level_4:setString([[当前积分:]])
level_4:setTextHorizontalAlignment(0)
level_4:setTextVerticalAlignment(0)
level_4:setTouchScaleChangeEnabled(false)
level_4:setFlippedX(false)
level_4:setFlippedY(false)
level_4:setTouchEnabled(false)
level_4:setLayoutComponentEnabled(true)
level_4:setName("level_4")
level_4:setLocalZOrder(0)
level_4:setTag(63)
level_4:setCascadeColorEnabled(true)
level_4:setCascadeOpacityEnabled(true)
level_4:setVisible(true)
level_4:setAnchorPoint(0, 0.6049)
level_4:setPosition(80.2661, 105.8611)
level_4:setScaleX(1)
level_4:setScaleY(1)
level_4:setRotation(0)
level_4:setRotationSkewX(0)
level_4:setRotationSkewY(0)
level_4:setOpacity(255)
level_4:setColor(cc.c3b(255, 255, 255))
layout = ccui.LayoutComponent:bindLayoutComponent(level_4)
layout:setPositionPercentXEnabled(false)
layout:setPositionPercentYEnabled(false)
layout:setPositionPercentX(0)
layout:setPositionPercentY(0)
layout:setPercentWidthEnabled(false)
layout:setPercentHeightEnabled(false)
layout:setPercentWidth(0)
layout:setPercentHeight(0)

layout:setSize(cc.size(87, 23))

layout:setHorizontalEdge(0)
layout:setVerticalEdge(0)
layout:setLeftMargin(80.2661)
layout:setRightMargin(-167.2661)
layout:setTopMargin(-114.9484)
layout:setBottomMargin(91.9484)
layout:setStretchWidthEnabled(false)
layout:setStretchHeightEnabled(false)
Node:addChild(level_4)

--Create level_5
local level_5 = ccui.Text:create()
level_5:ignoreContentAdaptWithSize(true)
level_5:setTextAreaSize(cc.size(0, 0))
level_5:setFontName("Resources/font/ttf/black_body.TTF")
level_5:setFontSize(20)
level_5:setString([[当前钻石:]])
level_5:setTextHorizontalAlignment(0)
level_5:setTextVerticalAlignment(0)
level_5:setTouchScaleChangeEnabled(false)
level_5:setFlippedX(false)
level_5:setFlippedY(false)
level_5:setTouchEnabled(false)
level_5:setLayoutComponentEnabled(true)
level_5:setName("level_5")
level_5:setLocalZOrder(0)
level_5:setTag(64)
level_5:setCascadeColorEnabled(true)
level_5:setCascadeOpacityEnabled(true)
level_5:setVisible(true)
level_5:setAnchorPoint(0, 0.6049)
level_5:setPosition(80.2661, 66.7276)
level_5:setScaleX(1)
level_5:setScaleY(1)
level_5:setRotation(0)
level_5:setRotationSkewX(0)
level_5:setRotationSkewY(0)
level_5:setOpacity(255)
level_5:setColor(cc.c3b(255, 255, 255))
layout = ccui.LayoutComponent:bindLayoutComponent(level_5)
layout:setPositionPercentXEnabled(false)
layout:setPositionPercentYEnabled(false)
layout:setPositionPercentX(0)
layout:setPositionPercentY(0)
layout:setPercentWidthEnabled(false)
layout:setPercentHeightEnabled(false)
layout:setPercentWidth(0)
layout:setPercentHeight(0)

layout:setSize(cc.size(87, 23))

layout:setHorizontalEdge(0)
layout:setVerticalEdge(0)
layout:setLeftMargin(80.2661)
layout:setRightMargin(-167.2661)
layout:setTopMargin(-75.8149)
layout:setBottomMargin(52.8149)
layout:setStretchWidthEnabled(false)
layout:setStretchHeightEnabled(false)
Node:addChild(level_5)

--Create diamondnum
local diamondnum = ccui.Text:create()
diamondnum:ignoreContentAdaptWithSize(true)
diamondnum:setTextAreaSize(cc.size(0, 0))
diamondnum:setFontName("Resources/font/ttf/black_body.TTF")
diamondnum:setFontSize(20)
diamondnum:setString([[6000]])
diamondnum:setTextHorizontalAlignment(0)
diamondnum:setTextVerticalAlignment(0)
diamondnum:setTouchScaleChangeEnabled(false)
diamondnum:setFlippedX(false)
diamondnum:setFlippedY(false)
diamondnum:setTouchEnabled(false)
diamondnum:setLayoutComponentEnabled(true)
diamondnum:setName("diamondnum")
diamondnum:setLocalZOrder(0)
diamondnum:setTag(65)
diamondnum:setCascadeColorEnabled(true)
diamondnum:setCascadeOpacityEnabled(true)
diamondnum:setVisible(true)
diamondnum:setAnchorPoint(0, 0.6049)
diamondnum:setPosition(204.6664, 70.3373)
diamondnum:setScaleX(1)
diamondnum:setScaleY(1)
diamondnum:setRotation(0)
diamondnum:setRotationSkewX(0)
diamondnum:setRotationSkewY(0)
diamondnum:setOpacity(255)
diamondnum:setColor(cc.c3b(255, 255, 255))
layout = ccui.LayoutComponent:bindLayoutComponent(diamondnum)
layout:setPositionPercentXEnabled(false)
layout:setPositionPercentYEnabled(false)
layout:setPositionPercentX(0)
layout:setPositionPercentY(0)
layout:setPercentWidthEnabled(false)
layout:setPercentHeightEnabled(false)
layout:setPercentWidth(0)
layout:setPercentHeight(0)

layout:setSize(cc.size(52, 23))

layout:setHorizontalEdge(0)
layout:setVerticalEdge(0)
layout:setLeftMargin(204.6664)
layout:setRightMargin(-256.6664)
layout:setTopMargin(-79.4246)
layout:setBottomMargin(56.4246)
layout:setStretchWidthEnabled(false)
layout:setStretchHeightEnabled(false)
Node:addChild(diamondnum)

--Create Headicon
local Headicon = ccui.ImageView:create()
Headicon:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("server_exercise/res/serverexerise.plist")
Headicon:loadTexture("server_exercise/res/user4.png",1)

Headicon:setFlippedX(false)
Headicon:setFlippedY(false)

Headicon:setScale9Enabled(false)
Headicon:setCapInsets(cc.rect(0,0,316,270))
Headicon:setTouchEnabled(false)
Headicon:setLayoutComponentEnabled(true)
Headicon:setName("Headicon")
Headicon:setLocalZOrder(0)
Headicon:setTag(66)
Headicon:setCascadeColorEnabled(true)
Headicon:setCascadeOpacityEnabled(true)
Headicon:setVisible(true)
Headicon:setAnchorPoint(0.5, 0.5)
Headicon:setPosition(187.669, 344.5484)
Headicon:setScaleX(1)
Headicon:setScaleY(1)
Headicon:setRotation(0)
Headicon:setRotationSkewX(0)
Headicon:setRotationSkewY(0)
Headicon:setOpacity(255)
Headicon:setColor(cc.c3b(255, 255, 255))
layout = ccui.LayoutComponent:bindLayoutComponent(Headicon)
layout:setPositionPercentXEnabled(false)
layout:setPositionPercentYEnabled(false)
layout:setPositionPercentX(0)
layout:setPositionPercentY(0)
layout:setPercentWidthEnabled(false)
layout:setPercentHeightEnabled(false)
layout:setPercentWidth(0)
layout:setPercentHeight(0)

layout:setSize(cc.size(316, 270))

layout:setHorizontalEdge(0)
layout:setVerticalEdge(0)
layout:setLeftMargin(29.669)
layout:setRightMargin(-345.669)
layout:setTopMargin(-479.5484)
layout:setBottomMargin(209.5484)
layout:setStretchWidthEnabled(false)
layout:setStretchHeightEnabled(false)
Node:addChild(Headicon)

--Create playername
local playername = ccui.Text:create()
playername:ignoreContentAdaptWithSize(true)
playername:setTextAreaSize(cc.size(0, 0))
playername:setFontName("Resources/font/ttf/black_body.TTF")
playername:setFontSize(20)
playername:setString([[宇智波谢广坤(1服)]])
playername:setTextHorizontalAlignment(0)
playername:setTextVerticalAlignment(1)
playername:setTouchScaleChangeEnabled(false)
playername:setFlippedX(false)
playername:setFlippedY(false)
playername:setTouchEnabled(false)
playername:setLayoutComponentEnabled(true)
playername:setName("playername")
playername:setLocalZOrder(0)
playername:setTag(81)
playername:setCascadeColorEnabled(true)
playername:setCascadeOpacityEnabled(true)
playername:setVisible(true)
playername:setAnchorPoint(0, 0.5)
playername:setPosition(38.5026, 510.9993)
playername:setScaleX(1)
playername:setScaleY(1)
playername:setRotation(0)
playername:setRotationSkewX(0)
playername:setRotationSkewY(0)
playername:setOpacity(255)
playername:setColor(cc.c3b(255, 255, 255))
layout = ccui.LayoutComponent:bindLayoutComponent(playername)
layout:setPositionPercentXEnabled(false)
layout:setPositionPercentYEnabled(false)
layout:setPositionPercentX(0)
layout:setPositionPercentY(0)
layout:setPercentWidthEnabled(false)
layout:setPercentHeightEnabled(false)
layout:setPercentWidth(0)
layout:setPercentHeight(0)

layout:setSize(cc.size(168, 23))

layout:setHorizontalEdge(0)
layout:setVerticalEdge(0)
layout:setLeftMargin(38.5026)
layout:setRightMargin(-206.5026)
layout:setTopMargin(-522.4993)
layout:setBottomMargin(499.4993)
layout:setStretchWidthEnabled(false)
layout:setStretchHeightEnabled(false)
Node:addChild(playername)

--Create Animation
result['animation'] = ccs.ActionTimeline:create()
  
result['animation']:setDuration(0)
result['animation']:setTimeSpeed(1)
--Create Animation List

result['root'] = Node
return result;
end

return Result
