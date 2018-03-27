--[[--
--开服礼包cell
--Author: H.X.Sun
--Date: 2015-06-24
--]]--

local SupplyRankCell = qy.class("LoginGiftCell", qy.tank.view.BaseView, "view/operatingActivities/armyAssault/SupplyRankCell")

function SupplyRankCell:ctor(delegate)
    SupplyRankCell.super.ctor(self)
	self.model = qy.tank.model.OperatingActivitiesModel
	self:InjectView("numTxt")
	self:InjectView("nameTxt")
	self:InjectView("timesTxt")
	self:InjectView("earningsTxt")
end

function SupplyRankCell:render(index)
	local _data = self.model:getListDataByIndexOfArnyAssault(index)
	self.numTxt:setString(index)
	self.nameTxt:setString(_data.name)
	self.timesTxt:setString(_data.times )
	self.earningsTxt:setString(_data.earnings)
end

return SupplyRankCell