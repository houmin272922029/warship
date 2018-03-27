--[[
    章节 tip 面板
]]
local ChapterOpenTip = qy.class("ChapterOpenTip", qy.tank.view.BaseView, "view/campaign/ChapterOpenTip")

function ChapterOpenTip:ctor(delegate)
    ChapterOpenTip.super.ctor(self)

    self:InjectView("bg")
    self:InjectView("titleImg")
    self:InjectView("sp")
    
    self.bg:setAnchorPoint(0.5,0.5)
    self.bg:setPosition(qy.winSize.width/2 , qy.winSize.height/2)
    
    -- self.bg:addChild(self.sp)
    
    self.cNum = qy.tank.widget.Attribute.new({
        ["attributeImg"] = "Resources/campaign/chapterTite.png", --属性字：例如攻击力
        ["numType"] = 7, --num_7.png
        ["hasMark"] = 0, --0没有加减号，1:有 默认为0
        ["value"] = 1,--支持正负，但图必须是由加减号 ["hasMark"] = 1
        ["space"] = 20
    })
    self.bg:addChild(self.cNum)
    self.cNum:setPosition(386.50,142.50)
end

function ChapterOpenTip:update(data)
    self.sp:setSpriteFrame("Resources/campaign/chapter_" .. data .. ".png")
    -- self.sp:setPosition(self.bg:getContentSize().width/2,55.5)
    local chanterNumStr = data > 9 and data or "0".. data
    self.cNum:update(chanterNumStr)
end

return ChapterOpenTip