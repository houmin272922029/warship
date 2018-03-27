

local DetialCell = qy.class("DetialCell", qy.tank.view.BaseView, "service_faction_war/ui/DetialCell")

local model = qy.tank.model.ServerFactionModel
local service = qy.tank.service.ServerFactionService

function DetialCell:ctor(delegate)
    DetialCell.super.ctor(self)
    self.delegate = delegate
    self:InjectView("des")
    self:InjectView("buyBt")
   	self:InjectView("bg")
   	self.des:setVisible(false)
    self:OnClick("buyBt",function()
        service:showCombat(self.combat_id,function (  )
        	-- body
        end)
    end)
end

function DetialCell:render(idx)
	local data = model.combat[idx]
	self.combat_id = data.combat_id
	if tolua.cast(self.richText,"cc.Node") then
	    self.bg:removeChild(self.richText)
	    self.richText = nil
	end
    self.richText = ccui.RichText:create()
    self.richText:setPosition(20, 50)
    self.richText:setAnchorPoint(0, 0.5)
    self.richText:ignoreContentAdaptWithSize(false)
    self.richText:setContentSize(cc.size(620, 80))

	if data.combat_id ~= 0 then
		self.buyBt:setVisible(true)
		local enemy_camp  = data.enemy_camp 
		local camptext = model.camp[tostring(enemy_camp)]
		local level = model:getlevelByid(data.enemy_level).name
		
		local cityname  = model.city_info[data.city_id].name
		if data.att_or_def == "att" then
			if data.is_win == 0 then
				self.des:setString(camptext.."|"..level.."|"..data.enemy_nickname.."在"..cityname.."据点防守住了您的进攻！")
			else
				self.des:setString(camptext.."|"..level.."|"..data.enemy_nickname.."在"..cityname.."据点被您无情击退！")
			end
		else
			if data.is_win == 1 then
				self.des:setString("您在"..cityname.."据点的防守位被"..camptext.."|"..level.."|"..data.enemy_nickname.."抢占！")
			else
				self.des:setString("您成功在"..cityname.."据点防守住了"..camptext.."|"..level.."|"..data.enemy_nickname.."的进攻！")
			end
		end
		-- if tolua.cast(self.richText,"cc.Node") then
	 --        self.bg:removeChild(self.richText)
	 --        self.richText = nil
	 --    end
	 --    self.richText = ccui.RichText:create()
	 --    self.richText:setPosition(20, 50)
	 --    self.richText:setAnchorPoint(0, 0.5)
	 --    self.richText:ignoreContentAdaptWithSize(false)
	 --    self.richText:setContentSize(cc.size(620, 80))
	    local info1 
	    if enemy_camp  == 1 then
			info1 = self:makeText(camptext, cc.c3b(251, 48, 0))
		elseif enemy_camp == 2 then
			info1 = self:makeText(camptext ,cc.c3b(46, 190, 83))
		else
			info1 = self:makeText(camptext, cc.c3b(36, 174, 242))
		end
	    local info2 = self:makeText(level, cc.c3b(255, 255, 255))
	    local info3 = self:makeText(data.enemy_nickname, cc.c3b(255, 153, 0))
	    local info4 = self:makeText("在", cc.c3b(255, 255, 255))
	    local info5 = self:makeText(cityname, cc.c3b(255, 153, 0))
	    local info6 = self:makeText("据点防守住了您的进攻！", cc.c3b(255, 255, 255))

	    local info7 = self:makeText("据点被您无情击退！", cc.c3b(255, 255, 255))
	    local info8 = self:makeText("您在", cc.c3b(255, 255, 255))
	    local info9 = self:makeText("据点的防守位被", cc.c3b(255, 255, 255))
	    local info10 = self:makeText("抢占！", cc.c3b(255, 255, 255))
	    local info11 = self:makeText("您成功在", cc.c3b(255, 255, 255))
	    local info12 = self:makeText("据点防守住了", cc.c3b(255, 255, 255))
	    local info13 = self:makeText("的进攻!", cc.c3b(255, 255, 255))

	    local info22 = self:makeText("您成功掠夺", cc.c3b(255, 255, 255))
	    local info23 = self:makeText("阵营", cc.c3b(255, 255, 255))
	    local info24 = self:makeText("据点的", cc.c3b(255, 255, 255))
	    local info25 = self:makeText("获得", cc.c3b(255, 255, 255))
	    if data.add_credit then
	    	info26 = self:makeText(data.add_credit, cc.c3b(255, 255, 255))
	    else
	    	info26 = self:makeText("0", cc.c3b(255, 255, 255))
	    end
	    local info27 = self:makeText("功勋", cc.c3b(255, 255, 255))

	    local info28 = self:makeText("您进攻", cc.c3b(255, 255, 255))
	    local info29 = self:makeText("失败，请再接再厉", cc.c3b(255, 255, 255))


	    if data.add_credit then
	        info14 = self:makeText("收益减半，获得", cc.c3b(255, 255, 255))
	        info30 = self:makeText(data.add_credit, cc.c3b(255, 153, 0))
	    else
	    	info14 = self:makeText("收益减半，获得0", cc.c3b(255, 255, 255))
	        info30 = self:makeText("", cc.c3b(255, 153, 0))

	    end
	    if data.att_or_def == "att" then
			if data.is_win == 0 then
	    		self.richText:pushBackElement(info28)
	    		self.richText:pushBackElement(info1)
	    		self.richText:pushBackElement(info23)
	    		self.richText:pushBackElement(info5)
	    		self.richText:pushBackElement(info24)
	    		self.richText:pushBackElement(info3)
	    		self.richText:pushBackElement(info29)
			else
				self.richText:pushBackElement(info22)
				self.richText:pushBackElement(info1)
				self.richText:pushBackElement(info23)
				self.richText:pushBackElement(info5)
				self.richText:pushBackElement(info24)
				self.richText:pushBackElement(info3)
				self.richText:pushBackElement(info25)
				self.richText:pushBackElement(info26)
				self.richText:pushBackElement(info27)
			end
		else
			if data.is_win == 1 then
				self.richText:pushBackElement(info8)
				self.richText:pushBackElement(info5)
				self.richText:pushBackElement(info9)
				self.richText:pushBackElement(info1)
				self.richText:pushBackElement(info2)
				self.richText:pushBackElement(info3)
				self.richText:pushBackElement(info10)
				self.richText:pushBackElement(info14)
				self.richText:pushBackElement(info30)
				self.richText:pushBackElement(info27)
			else
				self.richText:pushBackElement(info11)
				self.richText:pushBackElement(info5)
				self.richText:pushBackElement(info12)
				self.richText:pushBackElement(info1)
				self.richText:pushBackElement(info2)
				self.richText:pushBackElement(info3)
				self.richText:pushBackElement(info13)
			end
		end
		self.bg:addChild(self.richText)
	else
		self.buyBt:setVisible(false)
		local cityname = ""
		if data.city_id then
			cityname  = model.city_info[data.city_id].name
		end
        local info15 = self:makeText("己方", cc.c3b(255, 255, 255))
        local info16 = self:makeText(cityname, cc.c3b(255, 153, 0))
        local info17 = self:makeText("据点被", cc.c3b(255, 255, 255))
        if data.new_camp == 1 then
        	info18 = self:makeText(model.camp[tostring(data.new_camp)], cc.c3b(251, 48, 0))
        elseif data.new_camp == 2 then
        	info18 = self:makeText(model.camp[tostring(data.new_camp)], cc.c3b(46, 190, 83))
        else
        	info18 = self:makeText(model.camp[tostring(data.new_camp)], cc.c3b(36, 740, 242))
        end
        local info19 = self:makeText("阵营占领，您被强制撤离，获得", cc.c3b(255, 255, 255))
	    local info20 = self:makeText(data.add_credit, cc.c3b(255, 153, 0))
	    local info21 = self:makeText("功勋", cc.c3b(255, 255, 255))

        self.richText:pushBackElement(info15)
        self.richText:pushBackElement(info16)
        self.richText:pushBackElement(info17)
        self.richText:pushBackElement(info18)
        self.richText:pushBackElement(info19)
        self.richText:pushBackElement(info20)
        self.richText:pushBackElement(info21)
        
    	self.bg:addChild(self.richText)
	
	end
    --self.bg:addChild(self.richText)
end
function DetialCell:makeText(text, color)
    return ccui.RichElementText:create(1, color or display.COLOR_WHITE, 255, text, qy.res.FONT_NAME_2, 22)
end


return DetialCell
