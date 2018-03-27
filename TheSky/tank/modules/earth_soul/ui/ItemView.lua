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

--Create Image_1
local Image_1 = ccui.ImageView:create()
Image_1:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/common/img/common_img.plist")
Image_1:loadTexture("Resources/common/img/kuang1.png",1)

Image_1:setFlippedX(false)
Image_1:setFlippedY(false)

Image_1:setScale9Enabled(true)
Image_1:setCapInsets(cc.rect(162,49,167,52))
Image_1:setTouchEnabled(false)
Image_1:setLayoutComponentEnabled(true)
Image_1:setName("Image_1")
Image_1:setLocalZOrder(0)
Image_1:setTag(34)
Image_1:setCascadeColorEnabled(true)
Image_1:setCascadeOpacityEnabled(true)
Image_1:setVisible(true)
Image_1:setAnchorPoint(0.5, 0.5)
Image_1:setPosition(475, 78)
Image_1:setScaleX(1)
Image_1:setScaleY(1)
Image_1:setRotation(0)
Image_1:setRotationSkewX(0)
Image_1:setRotationSkewY(0)
Image_1:setOpacity(255)
Image_1:setColor(cc.c3b(255, 255, 255))
layout = ccui.LayoutComponent:bindLayoutComponent(Image_1)
layout:setPositionPercentXEnabled(false)
layout:setPositionPercentYEnabled(false)
layout:setPositionPercentX(0)
layout:setPositionPercentY(0)
layout:setPercentWidthEnabled(false)
layout:setPercentHeightEnabled(false)
layout:setPercentWidth(0)
layout:setPercentHeight(0)

layout:setSize(cc.size(946, 150))

layout:setHorizontalEdge(0)
layout:setVerticalEdge(0)
layout:setLeftMargin(2)
layout:setRightMargin(-948)
layout:setTopMargin(-153)
layout:setBottomMargin(3)
layout:setStretchWidthEnabled(false)
layout:setStretchHeightEnabled(false)
Node:addChild(Image_1)

--Create Image_2
local Image_2 = ccui.ImageView:create()
Image_2:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("earth_soul/res/res.plist")
Image_2:loadTexture("earth_soul/res/bg5.png",1)

Image_2:setFlippedX(false)
Image_2:setFlippedY(false)

Image_2:setScale9Enabled(true)
Image_2:setCapInsets(cc.rect(37,37,116,41))
Image_2:setTouchEnabled(false)
Image_2:setLayoutComponentEnabled(true)
Image_2:setName("Image_2")
Image_2:setLocalZOrder(0)
Image_2:setTag(35)
Image_2:setCascadeColorEnabled(true)
Image_2:setCascadeOpacityEnabled(true)
Image_2:setVisible(true)
Image_2:setAnchorPoint(0.5, 0.5)
Image_2:setPosition(142, 76)
Image_2:setScaleX(0.9)
Image_2:setScaleY(0.9)
Image_2:setRotation(0)
Image_2:setRotationSkewX(0)
Image_2:setRotationSkewY(0)
Image_2:setOpacity(255)
Image_2:setColor(cc.c3b(255, 255, 255))
layout = ccui.LayoutComponent:bindLayoutComponent(Image_2)
layout:setPositionPercentXEnabled(false)
layout:setPositionPercentYEnabled(false)
layout:setPositionPercentX(0.1501)
layout:setPositionPercentY(0.5067)
layout:setPercentWidthEnabled(false)
layout:setPercentHeightEnabled(false)
layout:setPercentWidth(0.2008)
layout:setPercentHeight(0.8)

layout:setSize(cc.size(190, 120))

layout:setHorizontalEdge(0)
layout:setVerticalEdge(0)
layout:setLeftMargin(47)
layout:setRightMargin(709)
layout:setTopMargin(14)
layout:setBottomMargin(16)
layout:setStretchWidthEnabled(false)
layout:setStretchHeightEnabled(false)
Image_1:addChild(Image_2)

--Create Sprite_1
cc.SpriteFrameCache:getInstance():addSpriteFrames("earth_soul/res/res.plist")
local Sprite_1 = cc.Sprite:createWithSpriteFrameName("earth_soul/res/7.png")
Sprite_1:setName("Sprite_1")
Sprite_1:setLocalZOrder(0)
Sprite_1:setTag(36)
Sprite_1:setCascadeColorEnabled(true)
Sprite_1:setCascadeOpacityEnabled(true)
Sprite_1:setVisible(true)
Sprite_1:setAnchorPoint(0.5, 0.5)
Sprite_1:setPosition(96, 61.9999)
Sprite_1:setScaleX(1)
Sprite_1:setScaleY(1)
Sprite_1:setRotation(0)
Sprite_1:setRotationSkewX(0)
Sprite_1:setRotationSkewY(0)
Sprite_1:setOpacity(255)
Sprite_1:setColor(cc.c3b(255, 255, 255))
layout = ccui.LayoutComponent:bindLayoutComponent(Sprite_1)
layout:setPositionPercentXEnabled(false)
layout:setPositionPercentYEnabled(false)
layout:setPositionPercentX(0.5053)
layout:setPositionPercentY(0.5167)
layout:setPercentWidthEnabled(false)
layout:setPercentHeightEnabled(false)
layout:setPercentWidth(0)
layout:setPercentHeight(0)

layout:setSize(cc.size(180, 104))

layout:setHorizontalEdge(0)
layout:setVerticalEdge(0)
layout:setLeftMargin(6)
layout:setRightMargin(4)
layout:setTopMargin(6.0001)
layout:setBottomMargin(9.9999)
Sprite_1:setFlippedX(false)
Sprite_1:setFlippedY(false)
Image_2:addChild(Sprite_1)

--Create Times
local Times = ccui.Text:create()
Times:ignoreContentAdaptWithSize(true)
Times:setTextAreaSize(cc.size(0, 0))
Times:setFontName("Resources/font/ttf/black_body_2.TTF")
Times:setFontSize(24)
Times:setString([[献花2000次]])
Times:setTextHorizontalAlignment(0)
Times:setTextVerticalAlignment(0)
Times:setTouchScaleChangeEnabled(false)
Times:setFlippedX(false)
Times:setFlippedY(false)
Times:enableOutline(cc.c4b(0, 0, 0, 255), 1)
Times:setTouchEnabled(false)
Times:setLayoutComponentEnabled(true)
Times:setName("Times")
Times:setLocalZOrder(0)
Times:setTag(37)
Times:setCascadeColorEnabled(true)
Times:setCascadeOpacityEnabled(true)
Times:setVisible(true)
Times:setAnchorPoint(0, 0.5)
Times:setPosition(240.5, 109)
Times:setScaleX(1)
Times:setScaleY(1)
Times:setRotation(0)
Times:setRotationSkewX(0)
Times:setRotationSkewY(0)
Times:setOpacity(255)
Times:setColor(cc.c3b(254, 255, 59))
layout = ccui.LayoutComponent:bindLayoutComponent(Times)
layout:setPositionPercentXEnabled(false)
layout:setPositionPercentYEnabled(false)
layout:setPositionPercentX(0.2542)
layout:setPositionPercentY(0.7267)
layout:setPercentWidthEnabled(false)
layout:setPercentHeightEnabled(false)
layout:setPercentWidth(0)
layout:setPercentHeight(0)

layout:setSize(cc.size(133, 29))

layout:setHorizontalEdge(0)
layout:setVerticalEdge(0)
layout:setLeftMargin(240.5)
layout:setRightMargin(572.5)
layout:setTopMargin(26.5)
layout:setBottomMargin(94.5)
layout:setStretchWidthEnabled(false)
layout:setStretchHeightEnabled(false)
Image_1:addChild(Times)

--Create soul_1
local soul_1 = cc.Sprite:create("Resources/common/icon/coin/soul.png")
soul_1:setName("soul_1")
soul_1:setLocalZOrder(0)
soul_1:setTag(40)
soul_1:setCascadeColorEnabled(true)
soul_1:setCascadeOpacityEnabled(true)
soul_1:setVisible(true)
soul_1:setAnchorPoint(0.5, 0.5)
soul_1:setPosition(258.5, 50.5)
soul_1:setScaleX(1)
soul_1:setScaleY(1)
soul_1:setRotation(0)
soul_1:setRotationSkewX(0)
soul_1:setRotationSkewY(0)
soul_1:setOpacity(255)
soul_1:setColor(cc.c3b(255, 255, 255))
layout = ccui.LayoutComponent:bindLayoutComponent(soul_1)
layout:setPositionPercentXEnabled(false)
layout:setPositionPercentYEnabled(false)
layout:setPositionPercentX(0.2733)
layout:setPositionPercentY(0.3367)
layout:setPercentWidthEnabled(false)
layout:setPercentHeightEnabled(false)
layout:setPercentWidth(0)
layout:setPercentHeight(0)

layout:setSize(cc.size(36, 36))

layout:setHorizontalEdge(0)
layout:setVerticalEdge(0)
layout:setLeftMargin(240.5)
layout:setRightMargin(669.5)
layout:setTopMargin(81.5)
layout:setBottomMargin(32.5)
soul_1:setFlippedX(false)
soul_1:setFlippedY(false)
Image_1:addChild(soul_1)

--Create Name1
local Name1 = ccui.Text:create()
Name1:ignoreContentAdaptWithSize(true)
Name1:setTextAreaSize(cc.size(0, 0))
Name1:setFontName("Resources/font/ttf/black_body_2.TTF")
Name1:setFontSize(22)
Name1:setString([[Text Label]])
Name1:setTextHorizontalAlignment(0)
Name1:setTextVerticalAlignment(0)
Name1:setTouchScaleChangeEnabled(false)
Name1:setFlippedX(false)
Name1:setFlippedY(false)
Name1:enableOutline(cc.c4b(0, 0, 0, 255), 1)
Name1:setTouchEnabled(false)
Name1:setLayoutComponentEnabled(true)
Name1:setName("Name1")
Name1:setLocalZOrder(0)
Name1:setTag(38)
Name1:setCascadeColorEnabled(true)
Name1:setCascadeOpacityEnabled(true)
Name1:setVisible(true)
Name1:setAnchorPoint(0, 0.5)
Name1:setPosition(240.5, 72)
Name1:setScaleX(1)
Name1:setScaleY(1)
Name1:setRotation(0)
Name1:setRotationSkewX(0)
Name1:setRotationSkewY(0)
Name1:setOpacity(255)
Name1:setColor(cc.c3b(254, 120, 22))
layout = ccui.LayoutComponent:bindLayoutComponent(Name1)
layout:setPositionPercentXEnabled(false)
layout:setPositionPercentYEnabled(false)
layout:setPositionPercentX(0.2542)
layout:setPositionPercentY(0.48)
layout:setPercentWidthEnabled(false)
layout:setPercentHeightEnabled(false)
layout:setPercentWidth(0)
layout:setPercentHeight(0)

layout:setSize(cc.size(110, 27))

layout:setHorizontalEdge(0)
layout:setVerticalEdge(0)
layout:setLeftMargin(240.5)
layout:setRightMargin(595.5)
layout:setTopMargin(64.5)
layout:setBottomMargin(58.5)
layout:setStretchWidthEnabled(false)
layout:setStretchHeightEnabled(false)
Image_1:addChild(Name1)

--Create Name2
local Name2 = ccui.Text:create()
Name2:ignoreContentAdaptWithSize(true)
Name2:setTextAreaSize(cc.size(0, 0))
Name2:setFontName("Resources/font/ttf/black_body_2.TTF")
Name2:setFontSize(22)
Name2:setString([[Text Label]])
Name2:setTextHorizontalAlignment(0)
Name2:setTextVerticalAlignment(0)
Name2:setTouchScaleChangeEnabled(false)
Name2:setFlippedX(false)
Name2:setFlippedY(false)
Name2:enableOutline(cc.c4b(0, 0, 0, 255), 1)
Name2:setTouchEnabled(false)
Name2:setLayoutComponentEnabled(true)
Name2:setName("Name2")
Name2:setLocalZOrder(0)
Name2:setTag(39)
Name2:setCascadeColorEnabled(true)
Name2:setCascadeOpacityEnabled(true)
Name2:setVisible(true)
Name2:setAnchorPoint(0, 0.5)
Name2:setPosition(240.5, 44)
Name2:setScaleX(1)
Name2:setScaleY(1)
Name2:setRotation(0)
Name2:setRotationSkewX(0)
Name2:setRotationSkewY(0)
Name2:setOpacity(255)
Name2:setColor(cc.c3b(254, 120, 22))
layout = ccui.LayoutComponent:bindLayoutComponent(Name2)
layout:setPositionPercentXEnabled(false)
layout:setPositionPercentYEnabled(false)
layout:setPositionPercentX(0.2542)
layout:setPositionPercentY(0.2933)
layout:setPercentWidthEnabled(false)
layout:setPercentHeightEnabled(false)
layout:setPercentWidth(0)
layout:setPercentHeight(0)

layout:setSize(cc.size(110, 27))

layout:setHorizontalEdge(0)
layout:setVerticalEdge(0)
layout:setLeftMargin(240.5)
layout:setRightMargin(595.5)
layout:setTopMargin(92.5)
layout:setBottomMargin(30.5)
layout:setStretchWidthEnabled(false)
layout:setStretchHeightEnabled(false)
Image_1:addChild(Name2)

--Create soul_2
local soul_2 = cc.Sprite:create("Resources/common/icon/coin/soul.png")
soul_2:setName("soul_2")
soul_2:setLocalZOrder(0)
soul_2:setTag(41)
soul_2:setCascadeColorEnabled(true)
soul_2:setCascadeOpacityEnabled(true)
soul_2:setVisible(true)
soul_2:setAnchorPoint(0.5, 0.5)
soul_2:setPosition(429.5, 50.5)
soul_2:setScaleX(1)
soul_2:setScaleY(1)
soul_2:setRotation(0)
soul_2:setRotationSkewX(0)
soul_2:setRotationSkewY(0)
soul_2:setOpacity(255)
soul_2:setColor(cc.c3b(255, 255, 255))
layout = ccui.LayoutComponent:bindLayoutComponent(soul_2)
layout:setPositionPercentXEnabled(false)
layout:setPositionPercentYEnabled(false)
layout:setPositionPercentX(0.454)
layout:setPositionPercentY(0.3367)
layout:setPercentWidthEnabled(false)
layout:setPercentHeightEnabled(false)
layout:setPercentWidth(0)
layout:setPercentHeight(0)

layout:setSize(cc.size(36, 36))

layout:setHorizontalEdge(0)
layout:setVerticalEdge(0)
layout:setLeftMargin(411.5)
layout:setRightMargin(498.5)
layout:setTopMargin(81.5)
layout:setBottomMargin(32.5)
soul_2:setFlippedX(false)
soul_2:setFlippedY(false)
Image_1:addChild(soul_2)

--Create Num1
local Num1 = ccui.Text:create()
Num1:ignoreContentAdaptWithSize(true)
Num1:setTextAreaSize(cc.size(0, 0))
Num1:setFontName("Resources/font/ttf/black_body_2.TTF")
Num1:setFontSize(20)
Num1:setString([[1000]])
Num1:setTextHorizontalAlignment(0)
Num1:setTextVerticalAlignment(0)
Num1:setTouchScaleChangeEnabled(false)
Num1:setFlippedX(false)
Num1:setFlippedY(false)
Num1:enableOutline(cc.c4b(0, 0, 0, 255), 1)
Num1:setTouchEnabled(false)
Num1:setLayoutComponentEnabled(true)
Num1:setName("Num1")
Num1:setLocalZOrder(0)
Num1:setTag(42)
Num1:setCascadeColorEnabled(true)
Num1:setCascadeOpacityEnabled(true)
Num1:setVisible(true)
Num1:setAnchorPoint(0, 0.5)
Num1:setPosition(279.5, 50.5)
Num1:setScaleX(1)
Num1:setScaleY(1)
Num1:setRotation(0)
Num1:setRotationSkewX(0)
Num1:setRotationSkewY(0)
Num1:setOpacity(255)
Num1:setColor(cc.c3b(255, 255, 255))
layout = ccui.LayoutComponent:bindLayoutComponent(Num1)
layout:setPositionPercentXEnabled(false)
layout:setPositionPercentYEnabled(false)
layout:setPositionPercentX(0.2955)
layout:setPositionPercentY(0.3367)
layout:setPercentWidthEnabled(false)
layout:setPercentHeightEnabled(false)
layout:setPercentWidth(0)
layout:setPercentHeight(0)

layout:setSize(cc.size(50, 25))

layout:setHorizontalEdge(0)
layout:setVerticalEdge(0)
layout:setLeftMargin(279.5)
layout:setRightMargin(616.5)
layout:setTopMargin(87)
layout:setBottomMargin(38)
layout:setStretchWidthEnabled(false)
layout:setStretchHeightEnabled(false)
Image_1:addChild(Num1)

--Create Num2
local Num2 = ccui.Text:create()
Num2:ignoreContentAdaptWithSize(true)
Num2:setTextAreaSize(cc.size(0, 0))
Num2:setFontName("Resources/font/ttf/black_body_2.TTF")
Num2:setFontSize(20)
Num2:setString([[1000]])
Num2:setTextHorizontalAlignment(0)
Num2:setTextVerticalAlignment(0)
Num2:setTouchScaleChangeEnabled(false)
Num2:setFlippedX(false)
Num2:setFlippedY(false)
Num2:enableOutline(cc.c4b(0, 0, 0, 255), 1)
Num2:setTouchEnabled(false)
Num2:setLayoutComponentEnabled(true)
Num2:setName("Num2")
Num2:setLocalZOrder(0)
Num2:setTag(43)
Num2:setCascadeColorEnabled(true)
Num2:setCascadeOpacityEnabled(true)
Num2:setVisible(true)
Num2:setAnchorPoint(0, 0.5)
Num2:setPosition(452.5, 50.5)
Num2:setScaleX(1)
Num2:setScaleY(1)
Num2:setRotation(0)
Num2:setRotationSkewX(0)
Num2:setRotationSkewY(0)
Num2:setOpacity(255)
Num2:setColor(cc.c3b(255, 255, 255))
layout = ccui.LayoutComponent:bindLayoutComponent(Num2)
layout:setPositionPercentXEnabled(false)
layout:setPositionPercentYEnabled(false)
layout:setPositionPercentX(0.4783)
layout:setPositionPercentY(0.3367)
layout:setPercentWidthEnabled(false)
layout:setPercentHeightEnabled(false)
layout:setPercentWidth(0)
layout:setPercentHeight(0)

layout:setSize(cc.size(50, 25))

layout:setHorizontalEdge(0)
layout:setVerticalEdge(0)
layout:setLeftMargin(452.5)
layout:setRightMargin(443.5)
layout:setTopMargin(87)
layout:setBottomMargin(38)
layout:setStretchWidthEnabled(false)
layout:setStretchHeightEnabled(false)
Image_1:addChild(Num2)

--Create HasGot
cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/common/img/common_img.plist")
local HasGot = cc.Sprite:createWithSpriteFrameName("Resources/common/img/D_12.png")
HasGot:setName("HasGot")
HasGot:setLocalZOrder(0)
HasGot:setTag(47)
HasGot:setCascadeColorEnabled(true)
HasGot:setCascadeOpacityEnabled(true)
HasGot:setVisible(true)
HasGot:setAnchorPoint(0.5, 0.5)
HasGot:setPosition(794, 73.2984)
HasGot:setScaleX(1)
HasGot:setScaleY(1)
HasGot:setRotation(14.9982)
HasGot:setRotationSkewX(14.9982)
HasGot:setRotationSkewY(14.9994)
HasGot:setOpacity(255)
HasGot:setColor(cc.c3b(255, 255, 255))
layout = ccui.LayoutComponent:bindLayoutComponent(HasGot)
layout:setPositionPercentXEnabled(false)
layout:setPositionPercentYEnabled(false)
layout:setPositionPercentX(0.8393)
layout:setPositionPercentY(0.4887)
layout:setPercentWidthEnabled(false)
layout:setPercentHeightEnabled(false)
layout:setPercentWidth(0)
layout:setPercentHeight(0)

layout:setSize(cc.size(146, 121))

layout:setHorizontalEdge(0)
layout:setVerticalEdge(0)
layout:setLeftMargin(721)
layout:setRightMargin(79)
layout:setTopMargin(16.2016)
layout:setBottomMargin(12.7984)
HasGot:setFlippedX(false)
HasGot:setFlippedY(false)
Image_1:addChild(HasGot)

--Create Button_1
local Button_1 = ccui.Button:create()
Button_1:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/common/button/common_button.plist")
Button_1:loadTextureNormal("Resources/common/button/btn_3.png",1)
cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/common/button/common_button.plist")
Button_1:loadTexturePressed("Resources/common/button/anniuhong02.png",1)
cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/common/button/common_button.plist")
Button_1:loadTextureDisabled("Resources/common/button/anniuhui.png",1)
Button_1:setTitleFontSize(14)
Button_1:setTitleText("")
Button_1:setTitleColor(cc.c3b(65, 65, 70))
Button_1:setFlippedX(false)
Button_1:setFlippedY(false)
Button_1:setScale9Enabled(true)
Button_1:setCapInsets(cc.rect(15,11,122,44))
Button_1:setBright(true)
Button_1:setTouchEnabled(true)
Button_1:setLayoutComponentEnabled(true)
Button_1:setName("Button_1")
Button_1:setLocalZOrder(0)
Button_1:setTag(44)
Button_1:setCascadeColorEnabled(true)
Button_1:setCascadeOpacityEnabled(true)
Button_1:setVisible(true)
Button_1:setAnchorPoint(0.5, 0.5)
Button_1:setPosition(799, 73.7016)
Button_1:setScaleX(1)
Button_1:setScaleY(1)
Button_1:setRotation(0)
Button_1:setRotationSkewX(0)
Button_1:setRotationSkewY(0)
Button_1:setOpacity(255)
Button_1:setColor(cc.c3b(255, 255, 255))
layout = ccui.LayoutComponent:bindLayoutComponent(Button_1)
layout:setPositionPercentXEnabled(false)
layout:setPositionPercentYEnabled(false)
layout:setPositionPercentX(0.8446)
layout:setPositionPercentY(0.4913)
layout:setPercentWidthEnabled(false)
layout:setPercentHeightEnabled(false)
layout:setPercentWidth(0)
layout:setPercentHeight(0)

layout:setSize(cc.size(152, 66))

layout:setHorizontalEdge(0)
layout:setVerticalEdge(0)
layout:setLeftMargin(723)
layout:setRightMargin(71)
layout:setTopMargin(43.2984)
layout:setBottomMargin(40.7016)
layout:setStretchWidthEnabled(false)
layout:setStretchHeightEnabled(false)
Image_1:addChild(Button_1)

--Create Btn_text
cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/common/txt/common_txt.plist")
local Btn_text = cc.Sprite:createWithSpriteFrameName("Resources/common/txt/lingqu.png")
Btn_text:setName("Btn_text")
Btn_text:setLocalZOrder(0)
Btn_text:setTag(45)
Btn_text:setCascadeColorEnabled(true)
Btn_text:setCascadeOpacityEnabled(true)
Btn_text:setVisible(true)
Btn_text:setAnchorPoint(0.5, 0.5)
Btn_text:setPosition(77, 33)
Btn_text:setScaleX(1)
Btn_text:setScaleY(1)
Btn_text:setRotation(0)
Btn_text:setRotationSkewX(0)
Btn_text:setRotationSkewY(0)
Btn_text:setOpacity(255)
Btn_text:setColor(cc.c3b(255, 255, 255))
layout = ccui.LayoutComponent:bindLayoutComponent(Btn_text)
layout:setPositionPercentXEnabled(false)
layout:setPositionPercentYEnabled(false)
layout:setPositionPercentX(0.5066)
layout:setPositionPercentY(0.5)
layout:setPercentWidthEnabled(false)
layout:setPercentHeightEnabled(false)
layout:setPercentWidth(0)
layout:setPercentHeight(0)

layout:setSize(cc.size(56, 21))

layout:setHorizontalEdge(0)
layout:setVerticalEdge(0)
layout:setLeftMargin(49)
layout:setRightMargin(47)
layout:setTopMargin(22.5)
layout:setBottomMargin(22.5)
Btn_text:setFlippedX(false)
Btn_text:setFlippedY(false)
Button_1:addChild(Btn_text)

--Create soul_3
local soul_3 = cc.Sprite:create("Resources/common/icon/coin/soul.png")
soul_3:setName("soul_3")
soul_3:setLocalZOrder(0)
soul_3:setTag(106)
soul_3:setCascadeColorEnabled(true)
soul_3:setCascadeOpacityEnabled(true)
soul_3:setVisible(true)
soul_3:setAnchorPoint(0.5, 0.5)
soul_3:setPosition(578.5, 50.5)
soul_3:setScaleX(1)
soul_3:setScaleY(1)
soul_3:setRotation(0)
soul_3:setRotationSkewX(0)
soul_3:setRotationSkewY(0)
soul_3:setOpacity(255)
soul_3:setColor(cc.c3b(255, 255, 255))
layout = ccui.LayoutComponent:bindLayoutComponent(soul_3)
layout:setPositionPercentXEnabled(false)
layout:setPositionPercentYEnabled(false)
layout:setPositionPercentX(0.6115)
layout:setPositionPercentY(0.3367)
layout:setPercentWidthEnabled(false)
layout:setPercentHeightEnabled(false)
layout:setPercentWidth(0)
layout:setPercentHeight(0)

layout:setSize(cc.size(36, 36))

layout:setHorizontalEdge(0)
layout:setVerticalEdge(0)
layout:setLeftMargin(560.5)
layout:setRightMargin(349.5)
layout:setTopMargin(81.5)
layout:setBottomMargin(32.5)
soul_3:setFlippedX(false)
soul_3:setFlippedY(false)
Image_1:addChild(soul_3)

--Create Num3
local Num3 = ccui.Text:create()
Num3:ignoreContentAdaptWithSize(true)
Num3:setTextAreaSize(cc.size(0, 0))
Num3:setFontName("Resources/font/ttf/black_body_2.TTF")
Num3:setFontSize(20)
Num3:setString([[1000]])
Num3:setTextHorizontalAlignment(0)
Num3:setTextVerticalAlignment(0)
Num3:setTouchScaleChangeEnabled(false)
Num3:setFlippedX(false)
Num3:setFlippedY(false)
Num3:enableOutline(cc.c4b(0, 0, 0, 255), 1)
Num3:setTouchEnabled(false)
Num3:setLayoutComponentEnabled(true)
Num3:setName("Num3")
Num3:setLocalZOrder(0)
Num3:setTag(107)
Num3:setCascadeColorEnabled(true)
Num3:setCascadeOpacityEnabled(true)
Num3:setVisible(true)
Num3:setAnchorPoint(0, 0.5)
Num3:setPosition(602.5, 50.5)
Num3:setScaleX(1)
Num3:setScaleY(1)
Num3:setRotation(0)
Num3:setRotationSkewX(0)
Num3:setRotationSkewY(0)
Num3:setOpacity(255)
Num3:setColor(cc.c3b(255, 255, 255))
layout = ccui.LayoutComponent:bindLayoutComponent(Num3)
layout:setPositionPercentXEnabled(false)
layout:setPositionPercentYEnabled(false)
layout:setPositionPercentX(0.6369)
layout:setPositionPercentY(0.3367)
layout:setPercentWidthEnabled(false)
layout:setPercentHeightEnabled(false)
layout:setPercentWidth(0)
layout:setPercentHeight(0)

layout:setSize(cc.size(50, 25))

layout:setHorizontalEdge(0)
layout:setVerticalEdge(0)
layout:setLeftMargin(602.5)
layout:setRightMargin(293.5)
layout:setTopMargin(87)
layout:setBottomMargin(38)
layout:setStretchWidthEnabled(false)
layout:setStretchHeightEnabled(false)
Image_1:addChild(Num3)

--Create Animation
result['animation'] = ccs.ActionTimeline:create()
  
result['animation']:setDuration(0)
result['animation']:setTimeSpeed(1)
--Create Animation List

result['root'] = Node
return result;
end

return Result
