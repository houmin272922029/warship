


local Tip1 = qy.class("Tip1", qy.tank.view.BaseDialog, "accessories/ui/Tip1")

local model = qy.tank.model.FittingsModel
local service = qy.tank.service.FittingsService
local userModel = qy.tank.model.UserInfoModel

function Tip1:ctor(delegate)
    Tip1.super.ctor(self)

    self:InjectView("cancelBt")
    self:InjectView("okBt")
    self:InjectView("allbtbg")
    self:InjectView("allbt")
    self:InjectView("icon")
    self:InjectView("bg")

    self:OnClick("cancelBt",function()
        self:removeSelf()
    end,{["isScale"] = false})
    self:OnClick("okBt",function()
        if delegate.type == 1 then
            model.jingliantype = self.touchtyepe
        else
            model.refreshtype = self.touchtyepe
        end
        delegate.callback()
        self:removeSelf()
    end,{["isScale"] = false})
    self:OnClick("allbt",function()
        if self.touchtyepe == 0 then
        	self.touchtyepe = 1
        else
        	self.touchtyepe = 0
        end
        self.allbtbg:setVisible(self.touchtyepe == 1)
    end,{["isScale"] = false})
    self.allbtbg:setVisible(false)
	local richTxt = ccui.RichText:create()
    richTxt:ignoreContentAdaptWithSize(false)
    richTxt:setContentSize(300, 150)
    richTxt:setAnchorPoint(0,0.5)
    richTxt:setPosition(cc.p(208,127))
    if delegate.type == 1 then
    	self.icon:loadTexture("accessories/res/jingtie.png",0)
	    local stringTxt2 = ccui.RichElementText:create(2, cc.c3b(255, 153, 0), 255, delegate.num , qy.res.FONT_NAME_1, 22)
	    richTxt:pushBackElement(stringTxt2)
	    local stringTxt3 = ccui.RichElementText:create(3, cc.c3b(255,255,255), 255, "将配件精炼到", qy.res.FONT_NAME_1, 22)
	    richTxt:pushBackElement(stringTxt3)
        local level = 0 
        if delegate.level then
            level = delegate.level + 1
        end
        local sta = "+"..level
	    local stringTxt4 = ccui.RichElementText:create(4, cc.c3b(255, 153, 0), 255, sta , qy.res.FONT_NAME_1, 22)
	    richTxt:pushBackElement(stringTxt4)
    else
    	self.icon:loadTexture("accessories/res/1.png",1)
        -- min(10+int(刷新次数/5)*10,100)
    	local stringTxt2 = ccui.RichElementText:create(2, cc.c3b(30,144,255), 255, delegate.num , qy.res.FONT_NAME_1, 22)
	    richTxt:pushBackElement(stringTxt2)
	    local stringTxt3 = ccui.RichElementText:create(3, cc.c3b(255,255,255), 255, "立即刷新配件商店？", qy.res.FONT_NAME_1, 22)
	    richTxt:pushBackElement(stringTxt3)
    end
    self.bg:addChild(richTxt)
    self.touchtyepe = 0


end


return Tip1
