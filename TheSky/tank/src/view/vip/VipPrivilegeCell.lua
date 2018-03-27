--[[
	VIP特权cell
	Author: Aaron Wei
	Date: 2015-06-12 17:56:14
]]

local VipPrivilegeCell = qy.class("VipPrivilegeCell", qy.tank.view.BaseView, "view/vip/VipPrivilegeCell")

function VipPrivilegeCell:ctor(delegate)
    VipPrivilegeCell.super.ctor(self)

	self:InjectView("priceLabel")
	self:InjectView("getAwardBtn")
	self:InjectView("drawIcon")
	self:InjectView("title")
	self:InjectView("award_title")
	self:InjectView("container")
	self.userInfo = qy.tank.model.UserInfoModel.userInfoEntity
	self.model = qy.tank.model.VipModel

    self:OnClick("getAwardBtn",function()
        local service = qy.tank.service.VipService:new()
        service:drawGiftAward(self.index,function(data)
            qy.tank.command.AwardCommand:add(data.award)
            qy.tank.command.AwardCommand:show(data.award)
    		self.data = self.model.list[self.index]
	    	self:updateStatus()
        end)
    end)

end

function VipPrivilegeCell:render(index)
	self.index = index
	self.data = self.model.list[index]
	self.title:setString("VIP".. self.data.level.. " " .. qy.TextUtil:substitute(39004))
	self.award_title:setString("V".. self.data.level .. " " ..qy.TextUtil:substitute(39005))

	self.container:removeAllChildren()

	local desCell, arr
	for i = 1, #self.data.privilege do
		arr = self.data.privilege[i].desc
		if arr.txt and #arr.txt > 0 and arr.txt[1] ~= "" then
			desCell = qy.tank.view.vip.PrivilegeTxt1.new({["desc"] = arr})
			desCell:setPosition(qy.InternationalUtil:getVipPrivilegeCellX(), 430 - i * 40)
			self.container:addChild(desCell)
		end
	end

    self.awardList = qy.AwardList.new({
        ["award"] = self.data.gift_award,
        ["hasName"] = false,
        ["type"] = 1,
        ["cellSize"] = cc.size(120,120),
        ["itemSize"] = 2,
        ["len"] = 4
    })
    self.awardList:setPosition(qy.InternationalUtil:getVipPrivilegeCellAwardListX(),178)
    self.container:addChild(self.awardList)

    for i = 1, #self.data.gift_award do
    	-- if self.data.gift_award[i].type == 12 then
        --     local itemData = qy.tank.view.common.AwardItem.getItemData(self.data.gift_award[i])
        --     if itemData.entity:getSuitID() > 0 then
        --         self:createEquipSuitEffert(self.awardList.list[i])
        --     end
        -- else
        if self.data.gift_award[i].type == 11 then
        	self.awardList.list[i]:setPosition(self.awardList.list[i]:getPositionX() + 20 , self.awardList.list[i]:getPositionY())
        end
    end

	self:updateStatus()
end

function VipPrivilegeCell:updateStatus()
	if (self.userInfo.payment_diamond_added / 10) >= self.data.price then
		if self.userInfo.gift[tostring(self.data.level)] == nil then
			-- 可领取
			self.getAwardBtn:setVisible(true)
			self.drawIcon:setVisible(false)
			self.priceLabel:setVisible(false)
		else
			-- 已领取
			self.priceLabel:setVisible(false)
			self.getAwardBtn:setVisible(false)
			self.drawIcon:setVisible(true)
		end
	else
		-- 不可领取
		self.priceLabel:setString(qy.TextUtil:substitute(39006, self.data.price))
		self.priceLabel:setVisible(true)
		self.getAwardBtn:setVisible(false)
		self.drawIcon:setVisible(false)
	end
end

function VipPrivilegeCell:createEquipSuitEffert(_target)
    local _effert = ccs.Armature:create("Flame")
    -- _effert:setScale(1.1)
    _target:addChild(_effert,999)
    _effert:setPosition(2,0)
    _effert:getAnimation():playWithIndex(0)
    return _effert
end

return VipPrivilegeCell
