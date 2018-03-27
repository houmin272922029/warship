--[[
	猴年
	Author: H.X.Sun
]]

local GiftCell = qy.class("GiftCell", qy.tank.view.BaseView, "spring_gift/ui/GiftCell")

function GiftCell:ctor(delegate)
    GiftCell.super.ctor(self)
    self.model = qy.tank.model.OperatingActivitiesModel
    local service = qy.tank.service.OperatingActivitiesService
    local _ModuleType = qy.tank.view.type.ModuleType

	self:InjectView("btn")
    self:InjectView("has_icon")
    self:InjectView("title")

    self:OnClick("btn",function()
        service:getCommonGiftAward(self.data.id,_ModuleType.SPR_GIT, true, function()
            self.data.status = 2
            self:updateBtnStatus(self.data.status)
        end, true)
    end,{["isScale"]=true})
end

function GiftCell:render(idx)
    self.data = self.model:getSpriGiftByIndex(idx)
    self.title:setString(self.data.title)
    self:updateBtnStatus(self.data.status)

    if not tolua.cast(self.awardList,"cc.Node") then
        self.awardList = qy.AwardList.new({
            ["award"] = self.data.award,
            ["hasName"] = false,
            ["type"] = 1,
            ["cellSize"] = cc.size(120,180),
            ["itemSize"] = 2,
        })
        self:addChild(self.awardList)
        self.awardList:setPosition(130,240)
    else
        self.awardList:update(self.data.award)
    end
end

function GiftCell:updateBtnStatus(_status)
    if _status == 1 then
		--不可领取
		self.btn:setVisible(true)
		self.btn:setEnabled(false)
        self.btn:setBright(false)
        self.has_icon:setVisible(false)
	elseif _status == 0 then
		--可领取
		self.btn:setVisible(true)
		self.btn:setEnabled(true)
        self.btn:setBright(true)
        self.has_icon:setVisible(false)
	elseif _status == 2 then
		--已可领取
		self.btn:setVisible(false)
		self.has_icon:setVisible(true)
	end
end


return GiftCell
