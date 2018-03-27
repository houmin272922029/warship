--[[
	VIP特权txt
	Author: H.X.Sun
	Date: 2015-06-12 17:56:14
]]

local PrivilegeTxt1 = qy.class("PrivilegeTxt1", qy.tank.view.BaseView)

local ModuleType = qy.tank.view.type.ModuleType
local ActivitiesCommand = qy.tank.command.ActivitiesCommand
local ActivityIconsModel = qy.tank.model.ActivityIconsModel

function PrivilegeTxt1:ctor(delegate)
    PrivilegeTxt1.super.ctor(self)
    local _x = 24
    local _y = 18

    local point = cc.Sprite:createWithSpriteFrameName("Resources/common/img/VIP_tqcz_0007.png")
    point:setPosition(_x, _y)
    self:addChild(point)

    -- self:InjectView("point")
    -- local _x = point:getPositionX() + point:getContentSize().width
    -- local _y = point:getPositionY()
    -- for i = 1, 2 do
    -- 	self:InjectView("label_"..i)
    -- end
    local data = delegate.desc

    if data.txt and #data.txt > 0 then
        local richTxt = ccui.RichText:create()
        richTxt:ignoreContentAdaptWithSize(false)
        richTxt:setContentSize(800, 50)
        richTxt:setAnchorPoint(0,0.5)
        for j = 1, #data.txt do
            local stringTxt = ccui.RichElementText:create(j, data.color[j], 255, data.txt[j] , qy.res.FONT_NAME_2, qy.InternationalUtil:getPrivilegeTxt())
            richTxt:pushBackElement(stringTxt)
        end
        point:addChild(richTxt)
        if qy.cocos2d_version ~= qy.COCOS2D_3_7_1 then
            richTxt:setPosition(_x + 10, 0)
        else
            richTxt:setPosition(_x + 10, -12)
        end
    end

    -- for i = 1, #data.txt do
    	-- if i <= 2 then
    	-- 	self["label_"..i]:setString(data.txt[i])
    	-- 	print("color"..i.. "===", data.color[i])
     --        self["label_"..i]:setTextColor(data.color[i])
    	-- end

    -- end
    -- if #data.txt >= 2 then
    -- 	self.label_2:setPosition(self.label_1:getPositionX()+self.label_1:getContentSize().width,self.label_2:getPositionY())
    -- else
    -- 	self.label_2:setString("")
    -- end

    if tonumber(data.type) == 2 and ActivityIconsModel:hasFirstPayData() then
    	-- local button_1 = ccui.Button:create("Resources/vip/sv.png","Resources/vip/sv.png","",0)
		-- button_1:ignoreContentAdaptWithSize(false)
		-- button_1:setTitleColor(cc.c3b(255, 255, 255))
		-- button_1:setCapInsets(cc.rect(15,11,122,43))
        cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/vip/vip.plist")
        local button_1 = ccui.ImageView:create()
        button_1:ignoreContentAdaptWithSize(false)
        button_1:loadTexture("Resources/vip/sv.png",1)
		button_1:setContentSize(170,84)
		-- button_1:setTitleFontSize(20)
		button_1:setPosition((qy.InternationalUtil:getPrivilegeTxtBtnX()),_y + 10)
        --270，18
        -- print("self.label_2:getPositionX()+self.label_2:getContentSize().width + 60===>",self.label_2:getPositionX()+self.label_2:getContentSize().width + 60)
        -- print(", self.label_2:getPositionY()===>>>", self.label_2:getPositionY())
		self:addChild(button_1)

		self:OnClick(button_1, function()
        	ActivitiesCommand:showActivity(ModuleType.FIRST_PAY,{["callBack2"] = function ()
        		if button_1 then
        			self:removeChild(button_1)
        		end
        	end})
        end)

    end
end

return PrivilegeTxt1
