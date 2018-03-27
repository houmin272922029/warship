--[[
--描述
--Author: H.X.Sun
--Date: 2015-05-21
]]

local DescribeCell = qy.class("DescribeCell", qy.tank.view.BaseView, "view/tip/DescribeCell")

function DescribeCell:ctor(params)
    DescribeCell.super.ctor(self)

	self:InjectView("title")
	self:InjectView("des")
	self:InjectView("des2")
	self:InjectView("Node1")
	self.title:setString(params[1] or params.name .. ":")
	
	--烦烦烦！！！
	if params.level then
		if params.name and params.name ~= "" then
			self.title:setString(params[1] or params.name)
		else
			self.title:setString("+"..qy.TextUtil:substitute(90256, params.level))
			self.des2:setString(params.desc)
		end
	elseif params.name then
		if params.type ~= 0 and params.param ~= 0 then
			local info = nil
			local value = (params.type == 8 or params.type == 12 or params.type == 13 or params.type == 14 or params.type == 15 or params.type == 6 or params.type == 7 or params.type == 11) and params.param / 10 .. "%" or params.param
			if params.type ~= 9 then

		        info = qy.TextUtil:substitute(36001, qy.tank.model.AdvanceModel.attrTypes[tostring(params.type)], value, params.idx)
		    else
		        info = qy.TextUtil:substitute(36003)
		    end
		    self.des:setString(info)
		else
			self.title:setString(params[1] or params.name)
		end
	else
		self.des:setString(params[2])
	end

	self.Node1:setPosition(0, self.title:getContentSize().height / 2 + self.title:getPositionY())

	self.des:setPosition(self.title:getContentSize().width + self.title:getPositionX() + 10, 0)
	self.des2:setPosition(self.title:getContentSize().width + self.title:getPositionX() + 10, 0)
end

return DescribeCell