	local CarrayItemView = qy.class("CarrayItemView", qy.tank.view.BaseView, "carray.ui.CarrayItemView")

local model = qy.tank.model.CarrayModel
local service = qy.tank.service.CarrayService
function CarrayItemView:ctor(delegate)
   	CarrayItemView.super.ctor(self)

   	self:InjectView("Img1")
   	self:InjectView("Img2")
   	self:InjectView("Stay1")
   	self:InjectView("Stay2")
   	self:InjectView("Lv1")
   	self:InjectView("Lv2")
   	self:InjectView("DiamondNum2")
   	self:InjectView("DiamondNum1")
   	self:InjectView("action1")
   	self:InjectView("action2")
   	self:InjectView("Name1")
   	self:InjectView("Name2")
   	self:InjectView("ResName1")
   	self:InjectView("ResName2")
   	

   	self.status1 = 1
   	self.status2 = 1
   	self:OnClick("Btn1", function()	
   		if self.status1 == 3 then
    	-- 强制押运
	    	service:forceEscort(function()
	    		delegate:update()
	    		delegate:dismiss()
	    	end)
	    else
			if self.status1 == 1 then
				if model:testStatus() then
		        	service:joinTeam({
		        		["pos_one"] = self.pos,
		        		["pos_two"] = "p_1",
		        		["pos_two_other_kid"] = self.data.p_2.kid or 0,
		        	}, function()
		        		delegate:update()
		        		if self.status1 == 1 then -- 当刷新后，依然可以加入，代表此时已经自动开启押运
		        			delegate:dismiss()
		        		end
		        	end)
		        else
			    	qy.hint:show(qy.TextUtil:substitute(44006))
			    end
		    elseif self.status1 == 2 then
		    	-- 离开
	        	service:leaveTeam(function()
	        		delegate:update()
	        	end)
	        end
	    end
    end,{["isScale"] = false})

    self:OnClick("Btn2", function()	
    	if self.status2 == 3 then
    		service:forceEscort(function()
    			delegate:update()
    			delegate:dismiss()
		    end)
    	else
	    	if self.status2 == 1 then
				if model:testStatus() then
		        	service:joinTeam({
		        		["pos_one"] = self.pos,
		        		["pos_two"] = "p_2",
		        		["pos_two_other_kid"] = self.data.p_1.kid or 0,
		        	}, function()
		        		delegate:update()
		        		if self.status2 == 1 then  -- 当刷新后，依然可以加入，代表此时已经自动开启押运
		        			delegate:dismiss()
		        		end
		        	end)
		        else
			    	qy.hint:show("你已加入队伍，暂时不能组队")
			    end
		    elseif self.status2 == 2 then
		    	-- 离开
	        	service:leaveTeam(function()
	        		delegate:update()
	        	end)
		    end
		end
    end,{["isScale"] = false})
end

function CarrayItemView:setData(data, pos)
	self.data = data
	self.pos = "p_" .. pos
	
	-- self.Img1:setVisible(data.p_1 ~= nil and data.p_1.kid ~= nil)
	-- self.Stay1:setVisible(not data.p_1 or not data.p_2.kid)
	-- self.Lv1:setVisible(data.p_1 ~= nil and data.p_2.kid ~= nil)
	
	-- self.Img2:setVisible(data.p_2 ~= nil and data.p_2.kid ~= nil)
	-- self.Stay2:setVisible(not data.p_2 or not data.p_2.kid)
	-- self.Lv2:setVisible(data.p_2 ~= nil and data.p_2.kid ~= nil)

	-- self.DiamondNum2:setVisible((data.p_1 ~= nil and data.p_1.kid ~= nil) and not data.p_2.kid)
	-- self.DiamondNum1:setVisible((data.p_2 ~= nil and data.p_2.kid ~= nil) and not data.p_1.kid)

	-- 两个都没有KID的是可以加入的 1; 只有p_1有kid, p_2没有 ----- p_2可以强行押运 ,p_1 可以离开; 只有p_2有kid p_1没有 -- p_2可以离开，p_1可以强行押运  (3);  两个都有kid的不存在

	local kid = qy.tank.model.UserInfoModel.userInfoEntity.kid

	-- 离开, 强行押运
	if (data.p_1 ~= nil and (data.p_1.kid ~= nil and data.p_1.kid == kid)) and not data.p_2.kid then
		self.status1 = 2
		self.status2 = 3
	end

	-- 强行押运, 离开
	if (data.p_2 ~= nil and (data.p_2.kid ~= nil and data.p_2.kid == kid)) and not data.p_1.kid then
		self.status1 = 3
		self.status2 = 2
	end

	-- 加入, 加入
	if (not data.p_2 or not data.p_2.kid) and (not data.p_1 or not data.p_1.kid) then
		self.status2 = 1
		self.status1 = 1
	end

	-- 离开, 加入
	if (data.p_1 ~= nil and (data.p_1.kid ~= nil and data.p_1.kid ~= kid)) and not data.p_2.kid then
		self.status1 = 2
		self.status2 = 1
	end

	-- 加入, 离开
	if (data.p_2 ~= nil and (data.p_2.kid ~= nil and data.p_2.kid ~= kid)) and not data.p_1.kid then
		self.status1 = 1
		self.status2 = 2
	end

	local img1 = self.status1 == 3 and "qiangxing" or self.status1 == 2 and "likai" or "jiaru"
	local img2 = self.status2 == 3 and "qiangxing" or self.status2 == 2 and "likai" or "jiaru"
	self.action1:setSpriteFrame("carray/res/" .. img1 .. ".png")
	self.action2:setSpriteFrame("carray/res/" .. img2 .. ".png")

	self.Name1:setString((data.p_1 and data.p_1.nickname) and data.p_1.nickname or "")
	self.Name2:setString((data.p_2 and data.p_2.nickname) and data.p_2.nickname or "")
	local level1 = (data.p_1 and data.p_1.level) and data.p_1.level or 1
	local level2 = (data.p_1 and data.p_2.level) and data.p_2.level or 1
	self.Lv1:setString("Lv." .. level1)
	self.Lv2:setString("Lv." .. level2)

	self.Img1:setVisible(self.status1 == 2)
	self.Stay1:setVisible(self.status1 ~= 2)
	self.Lv1:setVisible(self.status1 == 2)
	
	self.Img2:setVisible(self.status2 == 2)
	self.Stay2:setVisible(self.status2 ~= 2)
	self.Lv2:setVisible(self.status2 == 2)

	self.DiamondNum1:setVisible(self.status1 == 3)
	self.DiamondNum2:setVisible(self.status2 == 3)

	local resname1 = (data.p_1 and data.p_1.quality) and model:atRescours(data.p_1.quality).name or ""
	local resname2 = (data.p_2 and data.p_2.quality) and model:atRescours(data.p_2.quality).name or ""
	self.ResName1:setString(resname1)  
	self.ResName2:setString(resname2)

	if data.p_1 and data.p_1.quality then
		self.ResName1:setTextColor(qy.tank.utils.ColorMapUtil.qualityMapColor(data.p_1.quality))
	end

	if data.p_2 and data.p_2.quality then
		self.ResName2:setTextColor(qy.tank.utils.ColorMapUtil.qualityMapColor(data.p_2.quality))
	end

	local UserResUtil = qy.tank.utils.UserResUtil
	if data.p_1 and data.p_1.headicon then
		self.Img1:setTexture(UserResUtil.getRoleIconByHeadType(data.p_1.headicon))
	end

	if data.p_2 and data.p_2.headicon then
		self.Img2:setTexture(UserResUtil.getRoleIconByHeadType(data.p_2.headicon))
	end
    -- self.Img:loadTexture("carray/res/" .. idx + 1 .. ".png", 1)
end


return CarrayItemView
