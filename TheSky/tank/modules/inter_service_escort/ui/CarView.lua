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

--Create Btn_view
local Btn_view = ccui.ImageView:create()
Btn_view:ignoreContentAdaptWithSize(false)
Btn_view:loadTexture("Default/ImageFile.png",0)

Btn_view:setFlippedX(false)
Btn_view:setFlippedY(false)

Btn_view:setScale9Enabled(true)
Btn_view:setCapInsets(cc.rect(71,51,74,53))
Btn_view:setTouchEnabled(false)
Btn_view:setLayoutComponentEnabled(true)
Btn_view:setName("Btn_view")
Btn_view:setLocalZOrder(0)
Btn_view:setTag(28)
Btn_view:setCascadeColorEnabled(true)
Btn_view:setCascadeOpacityEnabled(true)
Btn_view:setVisible(true)
Btn_view:setAnchorPoint(0.5, 0.5)
Btn_view:setPosition(84.2039, 58.7224)
Btn_view:setScaleX(0.4)
Btn_view:setScaleY(0.4)
Btn_view:setRotation(0)
Btn_view:setRotationSkewX(0)
Btn_view:setRotationSkewY(0)
Btn_view:setOpacity(0)
Btn_view:setColor(cc.c3b(255, 255, 255))
layout = ccui.LayoutComponent:bindLayoutComponent(Btn_view)
layout:setPositionPercentXEnabled(false)
layout:setPositionPercentYEnabled(false)
layout:setPositionPercentX(0)
layout:setPositionPercentY(0)
layout:setPercentWidthEnabled(false)
layout:setPercentHeightEnabled(false)
layout:setPercentWidth(0)
layout:setPercentHeight(0)

layout:setSize(cc.size(216, 150))

layout:setHorizontalEdge(0)
layout:setVerticalEdge(0)
layout:setLeftMargin(-23.7961)
layout:setRightMargin(-192.2039)
layout:setTopMargin(-133.7224)
layout:setBottomMargin(-16.2776)
layout:setStretchWidthEnabled(false)
layout:setStretchHeightEnabled(false)
Node:addChild(Btn_view)

--Create NameBg
cc.SpriteFrameCache:getInstance():addSpriteFrames("inter_service_escort/res/res.plist")
local NameBg = cc.Sprite:createWithSpriteFrameName("inter_service_escort/res/di11.png")
NameBg:setName("NameBg")
NameBg:setLocalZOrder(0)
NameBg:setTag(24)
NameBg:setCascadeColorEnabled(true)
NameBg:setCascadeOpacityEnabled(true)
NameBg:setVisible(true)
NameBg:setAnchorPoint(0.5, 0.5)
NameBg:setPosition(87.8012, 83.7078)
NameBg:setScaleX(0.7)
NameBg:setScaleY(0.7)
NameBg:setRotation(0)
NameBg:setRotationSkewX(0)
NameBg:setRotationSkewY(0)
NameBg:setOpacity(255)
NameBg:setColor(cc.c3b(255, 255, 255))
layout = ccui.LayoutComponent:bindLayoutComponent(NameBg)
layout:setPositionPercentXEnabled(false)
layout:setPositionPercentYEnabled(false)
layout:setPositionPercentX(0)
layout:setPositionPercentY(0)
layout:setPercentWidthEnabled(false)
layout:setPercentHeightEnabled(false)
layout:setPercentWidth(0)
layout:setPercentHeight(0)

layout:setSize(cc.size(148, 19))

layout:setHorizontalEdge(0)
layout:setVerticalEdge(0)
layout:setLeftMargin(13.8012)
layout:setRightMargin(-161.8012)
layout:setTopMargin(-93.2078)
layout:setBottomMargin(74.2078)
NameBg:setFlippedX(false)
NameBg:setFlippedY(false)
Node:addChild(NameBg)

--Create IsMy
cc.SpriteFrameCache:getInstance():addSpriteFrames("inter_service_escort/res/res.plist")
local IsMy = cc.Sprite:createWithSpriteFrameName("inter_service_escort/res/ziji.png")
IsMy:setName("IsMy")
IsMy:setLocalZOrder(0)
IsMy:setTag(22)
IsMy:setCascadeColorEnabled(true)
IsMy:setCascadeOpacityEnabled(true)
IsMy:setVisible(true)
IsMy:setAnchorPoint(0.5, 0.5)
IsMy:setPosition(33.4974, 83.0835)
IsMy:setScaleX(0.7)
IsMy:setScaleY(0.7)
IsMy:setRotation(0)
IsMy:setRotationSkewX(0)
IsMy:setRotationSkewY(0)
IsMy:setOpacity(255)
IsMy:setColor(cc.c3b(255, 255, 255))
layout = ccui.LayoutComponent:bindLayoutComponent(IsMy)
layout:setPositionPercentXEnabled(false)
layout:setPositionPercentYEnabled(false)
layout:setPositionPercentX(0)
layout:setPositionPercentY(0)
layout:setPercentWidthEnabled(false)
layout:setPercentHeightEnabled(false)
layout:setPercentWidth(0)
layout:setPercentHeight(0)

layout:setSize(cc.size(29, 28))

layout:setHorizontalEdge(0)
layout:setVerticalEdge(0)
layout:setLeftMargin(18.9974)
layout:setRightMargin(-47.9974)
layout:setTopMargin(-97.0835)
layout:setBottomMargin(69.0835)
IsMy:setFlippedX(false)
IsMy:setFlippedY(false)
Node:addChild(IsMy)

--Create Name
local Name = ccui.Text:create()
Name:ignoreContentAdaptWithSize(true)
Name:setTextAreaSize(cc.size(0, 0))
Name:setFontName("Resources/font/ttf/black_body_2.TTF")
Name:setFontSize(20)
Name:setString([[an--me]])
Name:setTextHorizontalAlignment(0)
Name:setTextVerticalAlignment(0)
Name:setTouchScaleChangeEnabled(false)
Name:setFlippedX(false)
Name:setFlippedY(false)
Name:setTouchEnabled(false)
Name:setLayoutComponentEnabled(true)
Name:setName("Name")
Name:setLocalZOrder(0)
Name:setTag(23)
Name:setCascadeColorEnabled(true)
Name:setCascadeOpacityEnabled(true)
Name:setVisible(true)
Name:setAnchorPoint(0, 0.5)
Name:setPosition(52.9976, 83.0842)
Name:setScaleX(0.7)
Name:setScaleY(0.7)
Name:setRotation(0)
Name:setRotationSkewX(0)
Name:setRotationSkewY(0)
Name:setOpacity(255)
Name:setColor(cc.c3b(255, 255, 255))
layout = ccui.LayoutComponent:bindLayoutComponent(Name)
layout:setPositionPercentXEnabled(false)
layout:setPositionPercentYEnabled(false)
layout:setPositionPercentX(0)
layout:setPositionPercentY(0)
layout:setPercentWidthEnabled(false)
layout:setPercentHeightEnabled(false)
layout:setPercentWidth(0)
layout:setPercentHeight(0)

layout:setSize(cc.size(80, 23))

layout:setHorizontalEdge(0)
layout:setVerticalEdge(0)
layout:setLeftMargin(52.9976)
layout:setRightMargin(-132.9976)
layout:setTopMargin(-94.5842)
layout:setBottomMargin(71.5842)
layout:setStretchWidthEnabled(false)
layout:setStretchHeightEnabled(false)
Node:addChild(Name)

--Create Resource1
cc.SpriteFrameCache:getInstance():addSpriteFrames("inter_service_escort/res/res.plist")
local Resource1 = cc.Sprite:createWithSpriteFrameName("inter_service_escort/res/w1.png")
Resource1:setName("Resource1")
Resource1:setLocalZOrder(0)
Resource1:setTag(29)
Resource1:setCascadeColorEnabled(true)
Resource1:setCascadeOpacityEnabled(true)
Resource1:setVisible(true)
Resource1:setAnchorPoint(0.5, 0.5)
Resource1:setPosition(82.5911, 58.2203)
Resource1:setScaleX(0.6)
Resource1:setScaleY(0.6)
Resource1:setRotation(0)
Resource1:setRotationSkewX(0)
Resource1:setRotationSkewY(0)
Resource1:setOpacity(255)
Resource1:setColor(cc.c3b(255, 255, 255))
layout = ccui.LayoutComponent:bindLayoutComponent(Resource1)
layout:setPositionPercentXEnabled(false)
layout:setPositionPercentYEnabled(false)
layout:setPositionPercentX(0)
layout:setPositionPercentY(0)
layout:setPercentWidthEnabled(false)
layout:setPercentHeightEnabled(false)
layout:setPercentWidth(0)
layout:setPercentHeight(0)

layout:setSize(cc.size(60, 33))

layout:setHorizontalEdge(0)
layout:setVerticalEdge(0)
layout:setLeftMargin(52.5911)
layout:setRightMargin(-112.5911)
layout:setTopMargin(-74.7203)
layout:setBottomMargin(41.7203)
Resource1:setFlippedX(false)
Resource1:setFlippedY(false)
Node:addChild(Resource1)

--Create Animation
result['animation'] = ccs.ActionTimeline:create()
  
result['animation']:setDuration(0)
result['animation']:setTimeSpeed(1)
--Create Animation List

result['root'] = Node
return result;
end

return Result
