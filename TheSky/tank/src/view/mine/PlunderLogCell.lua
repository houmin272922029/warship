--[[
    任务
    Author: H.X.Sun
    Date: 2015-08-31
]]

local PlunderLogCell = qy.class("PlunderLogCell", qy.tank.view.BaseView, "view/mine/PlunderLogCell")

local NumberUtil = qy.tank.utils.NumberUtil
local UserInfoModel = qy.tank.model.UserInfoModel

function PlunderLogCell:ctor(delegate)
    PlunderLogCell.super.ctor(self)

	self.delegate = delegate
	self:InjectView("bg")
	self:InjectView("time")

	local _MineService = qy.tank.service.MineService
	self:OnClick("viewBtn", function (sendr)
		_MineService:showCombat(self.combat_id, function (data)
			qy.tank.manager.ScenesManager:pushBattleScene()
			-- qy.tank.manager.ScenesManager:pushScene(qy.tank.view.scene.BattleScene.new())
		end)
	end)
end

--[[--
--刷新
--]]
function PlunderLogCell:render(data)
	if data and data.t and tonumber(data.t) then
    local nTime = UserInfoModel.serverTime - data.t
    if nTime > 60 then
		  local sTime = NumberUtil.secondsToTimeStr((nTime), 7)
		  self.time:setString("(" ..sTime ..qy.TextUtil:substitute(21024))
    else
      self.time:setString(qy.TextUtil:substitute(21025))
    end
	else
		self.time:setString("")
	end
    if self.container then
    	self.bg:removeChild(self.container)
    	self.container = nil
    end

    self.container = cc.Node:create()
    self.container:setPosition(50,70)
    self.bg:addChild(self.container)

    local fontSize = qy.InternationalUtil:getPlunderLogCellNameFontSize()
    local fontStyle = "Resources/font/ttf/black_body_2.TTF"
    local x = qy.InternationalUtil:getPlunderLogCellx()
    local y = qy.InternationalUtil:getPlunderLogCelly()
    self.combat_id = data.combat_id or 0
    if data.is_win == 1 then
    	local txt1
		if data.attackId == data.defId then
			txt1 = cc.Label:createWithTTF(data.defName,fontStyle, fontSize,cc.size(0,0),0)
			txt1:setTextColor(cc.c4b(202, 110, 26, 255))
		else
			txt1 = cc.Label:createWithTTF(qy.TextUtil:substitute(21026),fontStyle, fontSize,cc.size(0,0),0)
			txt1:setTextColor(cc.c4b(255, 255, 255, 255))
		end
		txt1:setAnchorPoint(0, 0.5)
		txt1:enableOutline(cc.c4b(0,0,0,255),1)
		self.container:addChild(txt1)
		txt1:setPosition(x,y)
		x = x + txt1:getContentSize().width

		local txt2 = cc.Label:createWithTTF(qy.TextUtil:substitute(21027).." "..data.mineName..qy.TextUtil:substitute(21028),fontStyle, fontSize,cc.size(0,0),0)
		txt2:setTextColor(cc.c4b(255, 255, 255, 255))
		txt2:setAnchorPoint(0, 0.5)
		txt2:enableOutline(cc.c4b(0,0,0,255),1)
		self.container:addChild(txt2)
		txt2:setPosition(x,y)
		x = x + txt2:getContentSize().width

    	local txt3
		if data.attackId == data.defId then
			txt3 = cc.Label:createWithTTF(qy.TextUtil:substitute(21026),fontStyle, fontSize,cc.size(0,0),0)
			txt3:setTextColor(cc.c4b(255, 255, 255, 255))
		else
			txt3 = cc.Label:createWithTTF(data.defName,fontStyle, fontSize,cc.size(0,0),0)
			txt3:setTextColor(cc.c4b(202, 110, 26, 255))
		end
		txt3:setAnchorPoint(0, 0.5)
		self.container:addChild(txt3)
		txt3:enableOutline(cc.c4b(0,0,0,255),1)
		txt3:setPosition(x,y)
		x = x + txt3:getContentSize().width

		local txt4 = cc.Label:createWithTTF(qy.InternationalUtil:getResNumString(data.howmuch)..qy.TextUtil:substitute(21029),fontStyle, fontSize,cc.size(0,0),0)
		txt4:setTextColor(cc.c4b(40, 255, 53, 255))
		txt4:setAnchorPoint(0, 0.5)
		self.container:addChild(txt4)
		txt4:enableOutline(cc.c4b(0,0,0,255),1)
		txt4:setPosition(x,y)
		x = x + txt4:getContentSize().width

	else
		local txt1 = cc.Label:createWithTTF(data.defName,fontStyle, fontSize,cc.size(0,0),0)
		txt1:setTextColor(cc.c4b(202, 110, 26, 255))
		txt1:setAnchorPoint(0, 0.5)
		self.container:addChild(txt1)
		txt1:enableOutline(cc.c4b(0,0,0,255),1)
		txt1:setPosition(x,y)
		x = x + txt1:getContentSize().width

		local str = ""
		if data.attackId == data.defId then
			str = qy.TextUtil:substitute(21030, data.mineName) .. qy.TextUtil:substitute(21031)
		else
			str = qy.TextUtil:substitute(21032).. " " .. data.mineName .. " " .. qy.TextUtil:substitute(21033)
		end
		local txt2 = cc.Label:createWithTTF(str,fontStyle, fontSize,cc.size(0,0),0)
		txt2:setTextColor(cc.c4b(255, 255, 255, 255))
		txt2:setAnchorPoint(0, 0.5)
		txt2:enableOutline(cc.c4b(0,0,0,255),1)
		self.container:addChild(txt2)
		txt2:setPosition(x,y)
		x = x + txt2:getContentSize().width
	end
end

function PlunderLogCell:onEnter()
end

function PlunderLogCell:onExit()
	-- self.bg:removeChild(self.richTxt)
end

return PlunderLogCell
