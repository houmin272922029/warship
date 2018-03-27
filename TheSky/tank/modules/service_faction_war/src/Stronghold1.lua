

local Stronghold1 = qy.class("Stronghold1", qy.tank.view.BaseView, "service_faction_war/ui/Stronghold1")

local model = qy.tank.model.ServerFactionModel
local service = qy.tank.service.ServerFactionService

function Stronghold1:ctor(delegate)
    Stronghold1.super.ctor(self)
   
    self:InjectView("img")
    self:InjectView("name")
    self:InjectView("icon")
    self:InjectView("level")
    self.id = delegate.id
    self.cityid = delegate.cityid
    self:OnClick("img",function()
    
   	   service:getPointInfo(self.cityid,self.id,function (_data)
	   local PositionDate = model.position[tostring(self.id)]
	   local CityInfoDate = model.campbase
	   local my_type = 0
	   local my_texttype = 0
	   if CityInfoDate.camp ~= model.my_camp then --敌方据点 没有占领归位敌方据点
			if self.camp ~= model.my_camp then 
				if self.camp == 0 then -- 策划案2 点击敌方据点空白防守点
					my_type = 1
					my_texttype = 2
				else -- 策划案1 点击敌方据点敌方防守点
					my_type = 2
					my_texttype = 1
				end
			else
				if tostring(PositionDate.kid) == tostring(model.my_kid) then -- 策划案4 点击敌方据点自己防守点
					my_type = 3
					my_texttype = 4
				else -- 策划案3 点击敌方据点我方防守点
					my_type = 0
					my_texttype = 3
				end
			end
	   else-- 我方据点
	   		if self.camp ~= model.my_camp then 
				if self.camp == 0 then -- 策划案6 点击敌方据点空白防守点
					my_type = 1
					my_texttype = 6
				else -- 策划案5 点击敌方据点地方防守点
					my_type = 2
					my_texttype = 5
				end
			else
				if tostring(PositionDate.kid) == tostring(model.my_kid) then -- 策划案8 点击我方据点自己防守点
					my_type = 3
					my_texttype = 8
				else -- 策划案7 点击敌方据点我方防守点
					my_type = 0
					my_texttype = 7
				end
			end
	   end
	   local item = require("service_faction_war.src.Tip").new({
			["type"] = my_type,
			["texttype"] = my_texttype,
			["cityid"] = self.cityid,
			["id"] = self.id,
			["info"] = _data.info
		})
		self:setTipPosition(item)
      end)
    end,{["isScale"] = false})
end

function Stronghold1:setTipPosition(item)--设置tip位置
	local distance_up = 1
	local distance_down = 1
	if qy.winSize.width > 1080 then
		distance_up = 600
		distance_down = 400
	else
		distance_up = 580
		distance_down = 380
	end
	if self.id == 6 or self.id == 10 or self.id == 14 or self.id == 20 then
		item:setPosition(cc.p(self:getPositionX()-distance_up,self:getPositionY()-250))
	else
		item:setPosition(cc.p(self:getPositionX()-distance_down,self:getPositionY()-250))
	end
    qy.alert:showTip2(item)
end

function Stronghold1:update()
	local data  = model.position[tostring(self.id)]
	if data.p  then
		self.icon:setVisible(true)
		self.name:setVisible(true)
		self.level:setVisible(true)
		self.name:setString(data.nickname)
		self.level:setString("Lv"..data.level)
		self.camp = data.camp
		self.kid = data.kid
		if data.camp == 1 then
			self.icon:loadTexture("service_faction_war/res/hong.png",1)
		elseif data.camp ==2 then
			self.icon:loadTexture("service_faction_war/res/lv.png",1)
		else
			self.icon:loadTexture("service_faction_war/res/lan.png",1)
		end
	else
		self.camp = 0
		self.level:setVisible(false)
		self.icon:setVisible(false)
		self.name:setVisible(false)
	end
end


return Stronghold1
