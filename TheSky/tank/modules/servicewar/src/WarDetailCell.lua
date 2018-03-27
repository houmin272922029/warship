--[[
	跨服战况cell

]]
local WarDetailCell = qy.class("WarDetailCell", qy.tank.view.BaseView, "servicewar.ui.DetailCell")

local model = qy.tank.model.ServiceWarModel

function WarDetailCell:ctor()
	WarDetailCell.super.ctor(self)

	-- self:InjectView("Image_1")
	self:InjectView("win")
	self:InjectView("lost")
end

function WarDetailCell:setData(data)
	self.data = data
    if tolua.cast(self.richText,"cc.Node") then
        self:removeChild(self.richText)
        self.richText = nil
    end
	self.richText = ccui.RichText:create()
	self.richText:setPosition(350, 45)
	self.richText:setAnchorPoint(0.5, 0.5)
	self.richText:ignoreContentAdaptWithSize(false)
    self.richText:setContentSize(cc.size(500, 50))

    local info1 = self:makeText("【".. self.data.servername .. " 】", cc.c3b(22, 176, 245))
    local info2 = self:makeText(self.data.username, cc.c3b(238, 221, 86))
    local info3 = self:makeText(qy.TextUtil:substitute(90080), cc.c3b(255, 253, 221))
    local info4 = self:makeText("【".. self.data.rivalservername .. " 】", cc.c3b(22, 176, 245))
    local info5 = self:makeText(self.data.rivalname, cc.c3b(238, 221, 86))
    local info6
    local info7
    local info8
    local info9
    if self.data.status == 100 then
    	info6 = self:makeText(qy.TextUtil:substitute(90081), cc.c3b(44, 255, 6))
    elseif self.data.status == 200 then
    	info6 = self:makeText(qy.TextUtil:substitute(90082), cc.c3b(250, 0, 10))
    elseif self.data.status == 300 then
    	info6 = self:makeText(qy.TextUtil:substitute(90083), cc.c3b(250, 0, 10))
    end
    if self.data.status == 100 then
        if self.data.tranking == 0 then
            info7 = self:makeText(qy.TextUtil:substitute(90085), cc.c3b(255, 253, 221))
        else
        	info7 = self:makeText(qy.TextUtil:substitute(90084), cc.c3b(255, 253, 221))
        	info8 = self:makeText(self.data.tranking, cc.c3b(250, 0, 10))
        	info9 = self:makeText(qy.TextUtil:substitute(90074), cc.c3b(255, 253, 221))
        end
    elseif self.data.status == 200 then
    	info7 = self:makeText(qy.TextUtil:substitute(90085), cc.c3b(255, 253, 221))
    elseif self.data.status == 300 then
    	info7 = self:makeText(qy.TextUtil:substitute(90085), cc.c3b(255, 253, 221))
    end
    local info10 = self:makeButton()

    self.richText:pushBackElement(info1)
    self.richText:pushBackElement(info2)
    self.richText:pushBackElement(info3)
    self.richText:pushBackElement(info4)
    self.richText:pushBackElement(info5)
    self.richText:pushBackElement(info6)
    self.richText:pushBackElement(info7)
    if self.data.status == 100 and self.data.tranking ~= 0 then
    	self.richText:pushBackElement(info8)
    	self.richText:pushBackElement(info9)
	end
    self.richText:pushBackElement(info10)
   
    
    self:addChild(self.richText)
    self:SetIconStatus()
end

-- 查看战报带下划线
function WarDetailCell:makeButton(text, callback, color)
    cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/chat/ui.plist")
    local textButton = ccui.Button:create()
    textButton:ignoreContentAdaptWithSize(true)
    textButton:setTouchEnabled(true)
    textButton:setSwallowTouches(false)
    textButton:setTitleText(qy.TextUtil:substitute(90086))
    textButton:setTitleFontName(qy.res.FONT_NAME)
    textButton:setTitleFontSize(20)
    textButton:setTitleColor(color or cc.c3b(44, 255, 6))
    textButton:getTitleRenderer():enableOutline(cc.c4b(0,0,0,255),1)
    textButton:setZoomScale(0)
    textButton:getTitleRenderer():setAnchorPoint(0.5, 0.4)
    
    local size = textButton:getContentSize()
    local line = ccui.Scale9Sprite:createWithSpriteFrameName("Resources/chat/line.png")
    line:setAnchorPoint(0.5, 0)
    line:setPosition(size.width / 2 + 3, -2)
    line:setCapInsets(cc.rect(2, 0, 2, 0))
    line:setContentSize(size.width - 5, 16)
    line:setColor(color or cc.c3b(44, 255, 6))
    textButton:addChild(line, -1)
    return ccui.RichElementCustomNode:create(1, cc.c3b(44, 255, 6), 255, textButton)
end

function WarDetailCell:makeText(text, color)
    return ccui.RichElementText:create(1, color or display.COLOR_WHITE, 255, text, qy.res.FONT_NAME_2, 22)
end

function WarDetailCell:SetIconStatus()
	local function setIconVisible()
		self.win:setVisible(false)
		self.lost:setVisible(false)
	end
	setIconVisible()
	if self.data.status == 100 then   --挑战成功后排名升高剑表示
		self.win:setVisible(true)
	elseif self.data.status == 200 then -- 挑战平局盾表示
		self.lost:setVisible(true)
	elseif self.data.status == 300 then -- 挑战失败盾表示
		self.lost:setVisible(true)
	end
end

function WarDetailCell:onEnter()
    
end

function WarDetailCell:onExit()
    
end
return WarDetailCell
