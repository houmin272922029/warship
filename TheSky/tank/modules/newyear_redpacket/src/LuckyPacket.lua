

local LuckyPacket = qy.class("LuckyPacket", qy.tank.view.BaseDialog, "newyear_redpacket/ui/LuckyPacket")

local model = qy.tank.model.RedPacketModel
local service = qy.tank.service.RedPacketService

function LuckyPacket:ctor(delegate)
    LuckyPacket.super.ctor(self)
	self:InjectView("closeBt")
	self:InjectView("saiBt")
	self:InjectView("num")
    self:InjectView("textbg")
    self:InjectView("Image_5")
 
    self:OnClick("saiBt",function ( sender )
    	local numberstring = tonumber(self.accountTxt:getText())
        local checkStr = self.accountTxt:getText()
        if #checkStr > 0 then
            for i=1,#checkStr do
                local curByte = string.byte(checkStr, i)
                if curByte > 57 or curByte < 48 then
                    qy.hint:show("请输入数字")
                    return
                end
            end
        else
            qy.hint:show("请输入钻石数")
            return
        end
        if numberstring <= 0 then
            qy.hint:show("请输入正确金额")
            return
        end
        local checkStr1 = self.accountTxt2:getText()
        print("+++++++++++",checkStr,"-------------",#checkStr1)
        local tempstr = #checkStr1== 0 and "恭喜发财,大吉大利!" or checkStr1
        print("............",tempstr)
        self:removeSelf()
        local dialog = require("newyear_redpacket.src.PacketNotice").new({
            ["type"] = 3,
            ["total"] = numberstring,
            ["range"] = delegate.range,
            ["type"] = delegate.type,
            ["content"] = tempstr,
            ["copies"] = 1,
            ["callback"] = function ( )
                delegate:callback()
                self:removeSelf()
            end
            })
        dialog:show(true)
    end)
  
	self:OnClick("closeBt", function(sender)
        self:removeSelf()
    end)
    self.accountTxt = ccui.EditBox:create(cc.size(400, 60), "Resources/common/bg/c_12.bg")
    self.accountTxt:setPosition(320,15)
    self.accountTxt:setFontSize(24)
    self.accountTxt:setInputMode(6)
    self.accountTxt:setPlaceholderFontSize(22)
    self.accountTxt:setMaxLength(5)
   
    self.accountTxt:setPlaceHolder("填写金额")
    if self.accountTxt.setReturnType then
        self.accountTxt:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    end
    self.textbg:addChild(self.accountTxt)
  
    self.accountTxt2 = ccui.EditBox:create(cc.size(500, 120), "Resources/common/bg/c_12.bg")
    self.accountTxt2:setPosition(265,20)
    self.accountTxt2:setFontSize(24)
    self.accountTxt2:setInputMode(6)
    self.accountTxt2:setPlaceholderFontSize(22)
    self.accountTxt2:setMaxLength(16)
    self.accountTxt2:setPlaceHolder("恭喜发财,大吉大利!")
    if self.accountTxt2.setReturnType then
        self.accountTxt2:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    end
    self.Image_5:addChild(self.accountTxt2)
    self:update()

end
function LuckyPacket:update()
    local scheduler = cc.Director:getInstance():getScheduler()
    self.schedulerID = scheduler:scheduleScriptFunc(function()
        local numberstring = tonumber(self.accountTxt:getText())
        local checkStr = self.accountTxt:getText()
        if #checkStr > 0 then
            for i=1,#checkStr do
                local curByte = string.byte(checkStr, i)
                if curByte > 57 or curByte < 48 then
                    self.num:setString(0)
                    return
                end
            end
           self.num:setString(checkStr)
        end
    end,0,false) 
end
function LuckyPacket:onEnter()
     self.schedulerID = nil
     self.num:setString(0)
end

function LuckyPacket:onExit()
    if self.schedulerID ~= nil then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
    end
end

return LuckyPacket
