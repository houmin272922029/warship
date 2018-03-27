--[[
	跨服战况cell

]]
local WarDetailCell = qy.class("WarDetailCell", qy.tank.view.BaseView, "server_exercise.ui.DetailCell")


function WarDetailCell:ctor()
	WarDetailCell.super.ctor(self)

	-- self:InjectView("Image_1")
	self:InjectView("win")
	self:InjectView("lost")
end

function WarDetailCell:setData(_type,data)
    local userModel = qy.tank.model.UserInfoModel
    local kid = userModel.userInfoEntity.kid
    print("战报数据",json.encode(data))
	self.data = data
    if tolua.cast(self.richText,"cc.Node") then
        self:removeChild(self.richText)
        self.richText = nil
    end
	self.richText = ccui.RichText:create()
	self.richText:setPosition(250, 20)
	self.richText:setAnchorPoint(0.5, 0.5)
	self.richText:ignoreContentAdaptWithSize(false)
    self.richText:setContentSize(cc.size(500, 50))

    local extratable = qy.TextUtil:StringSplit(self.data.servername,"s",false,false)
    local extratable1 = qy.TextUtil:StringSplit(self.data.rivalservername,"s",false,false)

    local info1
    local info2
    local info4
    local info5
    info1 = self:makeText("【".. extratable[1] .. " 服】", cc.c3b(22, 176, 245))
    info2 = self:makeText(self.data.username, cc.c3b(238, 221, 86))
    local info3 = self:makeText("击败了", cc.c3b(255, 253, 221))
    info4 = self:makeText("【".. extratable1[1] .. "服 】", cc.c3b(22, 176, 245))
    info5 = self:makeText(self.data.rivalname, cc.c3b(238, 221, 86))
    local info6 = self:makeText("获得了", cc.c3b(255, 253, 221))
    local info7 = self:makeText(self.data.diamond, cc.c3b(22, 176, 245))
    local info8 = self:makeText("钻石、", cc.c3b(255, 253, 221))
    local info9 = self:makeText(self.data.integral, cc.c3b(238, 221, 86))
    local info10 = self:makeText("积分", cc.c3b(255, 253, 221))

    
    local info11 = self:makeButton()

    local info31 = self:makeText("挑战", cc.c3b(255, 253, 221))
    local info61 = self:makeText("失利,不能屈服,再战！",cc.c3b(255, 253, 221))
    if _type == 200 then
        if kid == self.data.kid then
            info1 = self:makeText("", cc.c3b(22, 176, 245))
            info2 = self:makeText("我", cc.c3b(238, 221, 86))
        end
        if kid == self.data.rivalid then
            info4 = self:makeText("", cc.c3b(22, 176, 245))
            info5 = self:makeText("我", cc.c3b(238, 221, 86))
        end
    end
    
    if self.data.status == 1 then--失败
        self.richText:pushBackElement(info1)
        self.richText:pushBackElement(info2)
        self.richText:pushBackElement(info3)
        self.richText:pushBackElement(info4)
        self.richText:pushBackElement(info5)
        self.richText:pushBackElement(info6)
        self.richText:pushBackElement(info7)
        self.richText:pushBackElement(info8)
        self.richText:pushBackElement(info9)
        self.richText:pushBackElement(info10)
    else
        self.richText:pushBackElement(info1)
        self.richText:pushBackElement(info2)
        self.richText:pushBackElement(info31)
        self.richText:pushBackElement(info4)
        self.richText:pushBackElement(info5)
        self.richText:pushBackElement(info61)
    end
    self.richText:pushBackElement(info11)
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
    textButton:setTitleText("【战报】")
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
