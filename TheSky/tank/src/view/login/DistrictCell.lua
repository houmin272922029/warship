--[[--
--区cell
--Author: H.X.Sun
--Date: 2015-07-28
--]]

local DistrictCell = qy.class("DistrictCell", qy.tank.view.BaseView, "view/login/DistrictCell")

function DistrictCell:ctor(delegate)
    DistrictCell.super.ctor(self)

	for i = 1, 2 do
		self:InjectView("district_"..i)
		self:InjectView("district_"..i .. "_name")
		self:InjectView("district_"..i .. "_status")
		self:InjectView("district_"..i .. "_portrait")

		self:OnClick("district_" ..i, function()
			if self[i .. "_moved"] == false then
				qy.tank.model.LoginModel:setLastDistrictIdx(self["entity" .. i].index)
				delegate.confirm()
			end
		end,{["beganFunc"] = function(isSelf, sender)
			self[i .. "_moved"]=false
		end,["canceledFunc"] =  function(isSelf, sender)
			self[i .. "_moved"]=true
		end})

		self["district_"..i]:setSwallowTouches(false)
	end
end

function DistrictCell:update(_key)
	self.entity1 = qy.tank.model.LoginModel:getDistrictEntityByKey(_key)
	if self.entity1 then
		self.district_1_name:setString(self.entity1.s_name .. "  " .. self.entity1.name)
		self.district_1_status:setString(self.entity1:getStatusTxt())
		self.district_1_status:setTextColor(self.entity1:getStatusColor())
		self.district_1_portrait:setVisible(self.entity1:hasAccount())
		self.district_1:setVisible(true)
	else
		self.district_1:setVisible(false)
	end
	self.entity2 = qy.tank.model.LoginModel:getDistrictEntityByKey(_key + 1)
	if self.entity2 then
		self.district_2_name:setString(self.entity2.s_name .. "  " .. self.entity2.name)
		self.district_2_status:setString(self.entity2:getStatusTxt())
		self.district_2_status:setTextColor(self.entity2:getStatusColor())
		self.district_2_portrait:setVisible(self.entity1:hasAccount())
		self.district_2:setVisible(true)
	else
		self.district_2:setVisible(false)
	end
end
return DistrictCell
