

local FightluckDialog = qy.class("FightluckDialog", qy.tank.view.BaseDialog, "newyear_redpacket/ui/FightluckDialog")

local model = qy.tank.model.RedPacketModel
local service = qy.tank.service.RedPacketService

function FightluckDialog:ctor(delegate)
    FightluckDialog.super.ctor(self)
    self.model = qy.tank.model.OperatingActivitiesModel
	self:InjectView("closeBt")
	self:InjectView("saiBt")
	self:InjectView("title")
	self:InjectView("totalnum")
	self:InjectView("qiehuan")
	self:InjectView("text1")
	self:InjectView("text2")
	self:InjectView("Image_4")
	self:InjectView("numtextbg")
	self:InjectView("strtextbg")
	self:InjectView("text")
 
    self:OnClick("saiBt",function ( sender )
    	local numberstring1 = tonumber(self.accountTxt1:getText())
        local checkStr1 = self.accountTxt1:getText()
        local numberstring2 = tonumber(self.accountTxt2:getText())
        local checkStr2 = self.accountTxt2:getText()
        if #checkStr1 > 0  then
            for i=1,#checkStr1 do
                local curByte = string.byte(checkStr1, i)
                if curByte > 57 or curByte < 48 then
                     qy.hint:show("请输入数字")
                    return
                end
            end
        else
            qy.hint:show("请输入红包个数")
            return
        end
         if #checkStr2 > 0  then
            for i=1,#checkStr2 do
                local curByte = string.byte(checkStr2, i)
                if curByte > 57 or curByte < 48 then
                     qy.hint:show("请输入数字")
                    return
                end
            end
        else
            qy.hint:show("请输入金额")
            return
        end
        if numberstring1 <= 0 then
            qy.hint:show("请输入正确红包个数")
            return
        end
        if numberstring2 <= 0 then
            qy.hint:show("请输入正确金额")
            return
        end
        if self.num == 2 then
            if numberstring1 >1 then
                if numberstring2 == 1 then
                    qy.hint:show("每个红包最少一钻石")
                    return
                end
            end
        end
        local totala = 0
        if self.num == 2 then
            totala = numberstring2
        else
            totala = numberstring1*numberstring2
        end
        local checkStr3 = self.accountTxt3:getText()
        print("+++++++++++",checkStr,"-------------",#checkStr1)
        self:removeSelf()
        local tempstr = #checkStr3== 0 and "恭喜发财,大吉大利!" or checkStr3
        local dialog = require("newyear_redpacket.src.PacketNotice").new({
            ["total"] = totala,
            ["range"] = delegate.range,
            ["type"] = self.num,
            ["content"] = tempstr,
            ["copies"] = numberstring1,
            ["callback"] = function ( )
                delegate:callback()
                self:removeSelf()
            end
        	})
	 	dialog:show(true)
    end)
  	self:OnClick("qiehuan",function ( sender )
    	self:updatetext(self.num == 1 and 2 or 1)
    end)
	self:OnClick("closeBt", function(sender)
        self:removeSelf()
    end)
    self.accountTxt1 = ccui.EditBox:create(cc.size(400, 60), "Resources/common/bg/c_12.bg")
    self.accountTxt1:setPosition(320,15)
    self.accountTxt1:setFontSize(24)
    self.accountTxt1:setInputMode(6)
    self.accountTxt1:setPlaceholderFontSize(22)
    self.accountTxt1:setMaxLength(5)
    -- self.accountTxt1:setLabelAnchorPoint(1,0.5)
    self.accountTxt1:setPlaceHolder("填写个数")
    if self.accountTxt1.setReturnType then
        self.accountTxt1:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    end
    self.Image_4:addChild(self.accountTxt1)
    self.accountTxt2 = ccui.EditBox:create(cc.size(400, 60), "Resources/common/bg/c_12.bg")
    self.accountTxt2:setPosition(320,15)
    self.accountTxt2:setFontSize(24)
    self.accountTxt2:setInputMode(6)
    self.accountTxt2:setPlaceholderFontSize(22)
    self.accountTxt2:setMaxLength(5)
    self.accountTxt2:setPlaceHolder("填写金额")
    if self.accountTxt2.setReturnType then
        self.accountTxt2:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    end
    self.numtextbg:addChild(self.accountTxt2)

    self.accountTxt3 = ccui.EditBox:create(cc.size(450, 60), "Resources/common/bg/c_12.bg")
    self.accountTxt3:setPosition(230,15)
    self.accountTxt3:setFontSize(24)
    self.accountTxt3:setInputMode(6)
    self.accountTxt3:setPlaceholderFontSize(22)
    self.accountTxt3:setMaxLength(16)
    self.accountTxt3:setPlaceHolder("恭喜发财,大吉大利!")
    if self.accountTxt3.setReturnType then
        self.accountTxt3:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    end
    self.strtextbg:addChild(self.accountTxt3)

	self.num = 2
    self:updatetext(self.num)
    self:update()
end
function FightluckDialog:update(  )
	local scheduler = cc.Director:getInstance():getScheduler()
    self.schedulerID = scheduler:scheduleScriptFunc(function()
        local numberstring1 = tonumber(self.accountTxt1:getText())
        local checkStr1 = self.accountTxt1:getText()
        local numberstring2 = tonumber(self.accountTxt2:getText())
        local checkStr2 = self.accountTxt2:getText()
        if #checkStr1 > 0 and #checkStr2 > 0 then
            for i=1,#checkStr1 do
                local curByte = string.byte(checkStr1, i)
                if curByte > 57 or curByte < 48 then
                    self.totalnum:setString(0)
                    return
                end
            end
            for i=1,#checkStr2 do
                local curByte = string.byte(checkStr2, i)
                if curByte > 57 or curByte < 48 then
                    self.totalnum:setString(0)
                    return
                end
            end
            if self.num == 1 then
                self.totalnum:setString(numberstring1*numberstring2)
            else
                self.totalnum:setString(numberstring2)
            end
        end
    end,0,false) 
end
function FightluckDialog:updatetext(num)
	self.num = num
	if self.num == 1 then
		self.title:setSpriteFrame("newyear_redpacket/res/dinge.png")
		self.text1:setString("当前为定额红包,更换为")
		self.text2:setString("拼手气红包")
		self.text2:setPosition(cc.p(243,12))
		self.text:setString("单个金额:")
		self.accountTxt1:setText("")
		self.accountTxt2:setText("")
	else
	 	self.title:setSpriteFrame("newyear_redpacket/res/pinshouq.png")
		self.text1:setString("当前为拼手气红包,更换为")
		self.text2:setString("定额红包")
		self.text2:setPosition(cc.p(257,12))
		self.text:setString("总金额:")
		self.accountTxt1:setText("")
		self.accountTxt2:setText("")
	end
	self.totalnum:setString("0")
     
end
function FightluckDialog:onEnter()
     self.schedulerID = nil
     self.totalnum:setString(0)
end

function FightluckDialog:onExit()
    if self.schedulerID ~= nil then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
    end
end


return FightluckDialog
