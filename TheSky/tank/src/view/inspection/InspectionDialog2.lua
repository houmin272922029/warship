--[[
    每日检阅
]]
local InspectionDialog = qy.class("InspectionDialog", qy.tank.view.BaseView, "view/inspection/InspectionDialog")

function InspectionDialog:ctor(delegate)
    InspectionDialog.super.ctor(self)
	self.model = qy.tank.model.InspectionModel

	self.delegate = delegate
	self:InjectView("inspectBtn1")
	self:InjectView("inspectBtn2")
	self:InjectView("inspectBtn3")
	self:InjectView("inspectBtn4")
	self:InjectView("done1")
	self:InjectView("done2")
	self:InjectView("done3")
	self:InjectView("done4")
	self:InjectView("infoContainer")

    --  self.style = qy.tank.view.style.DialogStyle2.new({
    --     size = cc.size(1074,598),
    --     position = cc.p(0,0),
    --     offset = cc.p(0,0),

    --     ["onClose"] = function()
    --         self:dismiss()
    --     end
    -- })
    -- self:addChild(self.style , -1)

    self:OnClick("inspectBtn1", function(sender)
    	self:onBtnClick(1)
    end)

    self:OnClick("inspectBtn2", function(sender)
      	self:onBtnClick(2)
    end)

    self:OnClick("inspectBtn3", function(sender)
      	self:onBtnClick(3)
    end)

    self:OnClick("inspectBtn4", function(sender)
      	self:onBtnClick(4)
    end)


    self:updateList()
end

function InspectionDialog:onBtnClick( type )
	-- local canInspected = self.model.inspectionNum > 0 and true or false
	-- if not canInspected then
	-- 	qy.hint:show("已无检阅次数！")
	-- 	return
	-- end
	local service = qy.tank.service.InspectionService
	local param = {}
	param.type = type
    service:set(param , function(data)
    	 self.model:update(data)
         self:updateList()

        local awardCommand = qy.tank.command.AwardCommand
        awardCommand:add(data.award)
        function tpClose( ... )
            
        end
        awardCommand:show(data.award ,{["callback"] = tpClose, ["tipTxt"] = qy.TextUtil:substitute(16001)})
         -- qy.hint:show("检阅成功！")
    end)
end

function InspectionDialog:updateList()
	self.infoContainer:removeAllChildren()
	local list = self.model:getList()
	if list ~=nil then
		for i=(#list >8 and (#list - 7) or 1),#list do
			if list[i].nickname == nil then
				list[i].nickname = list[i].name
			end
			local richTxt = self:getRichTextByType(list[i].nickname , list[i].type)

			richTxt:setAnchorPoint(0,1)
			richTxt:setPosition( qy.InternationalUtil:getInspectionDialogX() , -30+(#list >8 and (i - #list+7) or (i - 1) )*-35)
			self.infoContainer:addChild(richTxt)
		end
	end

	self:setBtnEnable(self.inspectBtn1 ,self.done1, (self.model.inspectionNum1 > 0 and true or false))
	self:setBtnEnable(self.inspectBtn2 ,self.done2 , (self.model.inspectionNum2 > 0 and true or false))
	self:setBtnEnable(self.inspectBtn3 ,self.done3 , (self.model.inspectionNum3 > 0 and true or false))
	self:setBtnEnable(self.inspectBtn4 ,self.done4 , (self.model.inspectionNum4 > 0 and true or false))
end

function InspectionDialog:getRichTextByType( name , eType )

	local armyName,gotNum,gotItemName,spC3bColor,fontName
	local fontSize = qy.InternationalUtil:getInspectionDialogFontSize()
	local nameStr  = name
	if eType == 1 then
		armyName = qy.TextUtil:substitute(16002)
		gotNum = 25
		gotItemName = qy.TextUtil:substitute(16003)
		spC3bColor = cc.c3b(36, 174, 242)
	elseif  eType == 2 then
		armyName = qy.TextUtil:substitute(16004)
		gotNum = 5
		gotItemName = qy.TextUtil:substitute(16005)
		-- nameStr = " "..name
		spC3bColor = cc.c3b(174, 53, 248)
	elseif  eType == 3 then
		armyName = qy.TextUtil:substitute(16006)
		gotNum = 8
		gotItemName = qy.TextUtil:substitute(16007)
		-- nameStr = " "..name
		spC3bColor = cc.c3b(235, 129, 35)
	else
		armyName = qy.TextUtil:substitute(16008)
		gotNum = 15
		gotItemName = qy.TextUtil:substitute(16009)
		-- nameStr = " "..name
		spC3bColor = cc.c3b(235, 129, 35)
	end
	-- if type(nameStr) == "number" then
	-- 	nameStr = "  "..nameStr
	-- end
	local richTxt = ccui.RichText:create()
	richTxt:ignoreContentAdaptWithSize(false)
    richTxt:setContentSize(qy.InternationalUtil:getInspectionDialogContentSize(), 30)
    fontName = qy.language == "tw" and "res/Resources/font/ttf/black_body_2.TTF" or "Arial"
	local reK = ccui.RichElementText:create(1,cc.c3b(255, 255, 255),255,nameStr,fontName, fontSize)
	richTxt:pushBackElement(reK)

	local reK = ccui.RichElementText:create(2,cc.c3b(250, 224, 149),255, " " .. qy.TextUtil:substitute(16010) .. " ",fontName, fontSize)
	richTxt:pushBackElement(reK)
	local reK = ccui.RichElementText:create(3,spC3bColor,255,armyName.."，",fontName, fontSize)
	richTxt:pushBackElement(reK)
	local reK = ccui.RichElementText:create(4,cc.c3b(255, 255, 255),255," " .. qy.TextUtil:substitute(16011) .. " " ,fontName, fontSize)
	richTxt:pushBackElement(reK)
	local reK = ccui.RichElementText:create(5,cc.c3b(255, 255, 222),255,gotNum,fontName, fontSize)
	richTxt:pushBackElement(reK)
	local reK = ccui.RichElementText:create(6,cc.c3b(255, 255, 255),255," " .. qy.TextUtil:substitute(16012),fontName, fontSize)
	richTxt:pushBackElement(reK)
	local reK = ccui.RichElementText:create(7,spC3bColor,255,gotItemName,fontName, fontSize)
	richTxt:pushBackElement(reK)

	return richTxt
end

function InspectionDialog:setBtnEnable(btn ,done, enabled)
	-- btn:setEnabled(enabled)
	-- btn:setBright(enabled)
	btn:setVisible(enabled)
	done:setVisible(not enabled)
end
function InspectionDialog:onExit()
    -- cc.Director:getInstance():getTextureCache():removeAllTextures()
end

return InspectionDialog
