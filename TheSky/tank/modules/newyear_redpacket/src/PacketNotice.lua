

local PacketNotice = qy.class("PacketNotice", qy.tank.view.BaseDialog, "newyear_redpacket/ui/PacketNotice")

local model = qy.tank.model.RedPacketModel
local service = qy.tank.service.RedPacketService

function PacketNotice:ctor(delegate)
    PacketNotice.super.ctor(self)
	self:InjectView("closeBt")
	self:InjectView("bg")
	self:InjectView("queding")

 
   -- self:setPosition(cc.p(qy.winSize.width / 2 + 200,qy.winSize.height/2))
	self:OnClick("closeBt", function(sender)
        self:removeSelf()
    end)
       -- ["type"] = 3,
        -- ["total"] = numberstring,
        -- ["range"] = delegate.range,
        -- ["type"] = delegate.type,
        -- ["content"] = tempstr,
        -- ["copies"] = 1,
        -- range,type,content,total,copies,callback
    self:OnClick("queding", function(sender)
        service:fahongbao(delegate.range,delegate.type,delegate.content,delegate.total,delegate.copies ,function ( data )
            delegate:callback()
            self:removeSelf()
        end)
    end)
    -- self.num:setString(delegate.total)
      local richTxt = ccui.RichText:create()
    richTxt:ignoreContentAdaptWithSize(false)
    richTxt:setContentSize(400, 150)
    richTxt:setAnchorPoint(0,0.5)
    local shuijing 
    if delegate.type == 1 then
        shuijing = "定额红包"
    elseif delegate.type == 2 then
        shuijing = "拼手气红包"
    else
        shuijing = "幸运红包"
    end
    local stringTxt1 = ccui.RichElementText:create(1, cc.c3b(255,255,255), 255, "请确认消耗", qy.res.FONT_NAME_1, 20)
    richTxt:pushBackElement(stringTxt1)
    local stringTxt2 = ccui.RichElementText:create(2, cc.c3b(30,144,255), 255, delegate.total , qy.res.FONT_NAME_1, 20)
    richTxt:pushBackElement(stringTxt2)
    local stringTxt11 = ccui.RichElementText:create(1, cc.c3b(255,255,255), 255, "钻石发放",qy.res.FONT_NAME_1, 20)
    richTxt:pushBackElement(stringTxt11)
    local stringTxt3 = ccui.RichElementText:create(3, cc.c3b(245, 139, 12), 255, shuijing, qy.res.FONT_NAME_1, 20)
    richTxt:pushBackElement(stringTxt3)
    richTxt:setPosition(cc.p(40,120))
    self.bg:addChild(richTxt)
   

end

function PacketNotice:onEnter()
     
end

function PacketNotice:onExit()
  
end


return PacketNotice
