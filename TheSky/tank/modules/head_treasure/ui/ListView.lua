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
cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/common/img/common_img.plist")
bg:loadTexture("Resources/common/img/b2.png",1)

bg:setFlippedX(false)
bg:setFlippedY(false)

bg:setScale9Enabled(true)
bg:setCapInsets(cc.rect(87,56,92,60))
bg:setTouchEnabled(false)
bg:setLayoutComponentEnabled(true)
bg:setName("bg")
bg:setLocalZOrder(0)
bg:setTag(28)
bg:setCascadeColorEnabled(true)
bg:setCascadeOpacityEnabled(true)
bg:setVisible(true)
bg:setAnchorPoint(0.5, 1)
bg:setPosition(309, -0.4999)
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

layout:setSize(cc.size(615, 351))

layout:setHorizontalEdge(0)
layout:setVerticalEdge(0)
layout:setLeftMargin(1.5)
layout:setRightMargin(-616.5)
layout:setTopMargin(0.4999)
layout:setBottomMargin(-351.4999)
layout:setStretchWidthEnabled(false)
layout:setStretchHeightEnabled(false)
Node:addChild(bg)

--Create Image_2
local Image_2 = ccui.ImageView:create()
Image_2:ignoreContentAdaptWithSize(false)
cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/common/img/common_img.plist")
Image_2:loadTexture("Resources/common/img/biaotidi.png",1)

Image_2:setFlippedX(false)
Image_2:setFlippedY(false)

Image_2:setScale9Enabled(false)
Image_2:setCapInsets(cc.rect(0,0,354,37))
Image_2:setTouchEnabled(false)
Image_2:setLayoutComponentEnabled(true)
Image_2:setName("Image_2")
Image_2:setLocalZOrder(0)
Image_2:setTag(29)
Image_2:setCascadeColorEnabled(true)
Image_2:setCascadeOpacityEnabled(true)
Image_2:setVisible(true)
Image_2:setAnchorPoint(0.5, 0.5)
Image_2:setPosition(312, 321.9438)
Image_2:setScaleX(1)
Image_2:setScaleY(1)
Image_2:setRotation(0)
Image_2:setRotationSkewX(0)
Image_2:setRotationSkewY(0)
Image_2:setOpacity(255)
Image_2:setColor(cc.c3b(255, 255, 255))
layout = ccui.LayoutComponent:bindLayoutComponent(Image_2)
layout:setPositionPercentXEnabled(false)
layout:setPositionPercentYEnabled(false)
layout:setPositionPercentX(0.5073)
layout:setPositionPercentY(0.9172)
layout:setPercentWidthEnabled(false)
layout:setPercentHeightEnabled(false)
layout:setPercentWidth(0)
layout:setPercentHeight(0)

layout:setSize(cc.size(354, 37))

layout:setHorizontalEdge(0)
layout:setVerticalEdge(0)
layout:setLeftMargin(135)
layout:setRightMargin(126)
layout:setTopMargin(10.5562)
layout:setBottomMargin(303.4438)
layout:setStretchWidthEnabled(false)
layout:setStretchHeightEnabled(false)
bg:addChild(Image_2)

--Create Title
cc.SpriteFrameCache:getInstance():addSpriteFrames("head_treasure/res/res.plist")
local Title = cc.Sprite:createWithSpriteFrameName("head_treasure/res/11.png")
Title:setName("Title")
Title:setLocalZOrder(0)
Title:setTag(30)
Title:setCascadeColorEnabled(true)
Title:setCascadeOpacityEnabled(true)
Title:setVisible(true)
Title:setAnchorPoint(0.5, 0.5)
Title:setPosition(172.5, 17)
Title:setScaleX(1)
Title:setScaleY(1)
Title:setRotation(0)
Title:setRotationSkewX(0)
Title:setRotationSkewY(0)
Title:setOpacity(255)
Title:setColor(cc.c3b(255, 255, 255))
layout = ccui.LayoutComponent:bindLayoutComponent(Title)
layout:setPositionPercentXEnabled(false)
layout:setPositionPercentYEnabled(false)
layout:setPositionPercentX(0.4873)
layout:setPositionPercentY(0.4595)
layout:setPercentWidthEnabled(false)
layout:setPercentHeightEnabled(false)
layout:setPercentWidth(0)
layout:setPercentHeight(0)

layout:setSize(cc.size(167, 50))

layout:setHorizontalEdge(0)
layout:setVerticalEdge(0)
layout:setLeftMargin(89)
layout:setRightMargin(98)
layout:setTopMargin(-5)
layout:setBottomMargin(-8)
Title:setFlippedX(false)
Title:setFlippedY(false)
Image_2:addChild(Title)

--Create Animation
result['animation'] = ccs.ActionTimeline:create()
  
result['animation']:setDuration(0)
result['animation']:setTimeSpeed(1)
--Create Animation List

result['root'] = Node
return result;
end

return Result
