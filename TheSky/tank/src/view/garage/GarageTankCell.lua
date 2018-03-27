--[[
	车库坦克列表cell
	Author: Your Name
	Date: 2015-03-20 11:58:36
]]

local GarageTankCell = qy.class("GarageTankCell", qy.tank.view.BaseView, "view/garage/GarageTankCell")

function GarageTankCell:ctor(entity, index,_hasDot)
    GarageTankCell.super.ctor(self)

	self.showLevel = true
	self.entity = entity
	self.index = index
	self:InjectView("bg")
	self:InjectView("light")
	self:InjectView("tankName")
	self:InjectView("tankImg")
	self:InjectView("tankLevel")
	-- self:InjectView("lockIcon")
	self:InjectView("redDot")
    self:InjectView("reform_num")
    self:InjectView("reform_bg")
	self.model = qy.tank.model.GarageModel
	self.awardType = qy.tank.view.type.AwardType

	-- self.bg:setSwallowTouches(false)
	cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/garage/garage.plist")
	self:render(entity)
	self.hasDot = _hasDot
end

function GarageTankCell:setShowLevel(bool)
    self.showLevel = bool
    -- if self.showLevel == false then
    -- 	self:OnClick("bg", function(sender)
    -- 		local itemData = {}
    -- 		itemData.type = self.awardType.TANK
    -- 		itemData.entity = self.tank_id
    --     	qy.alert:showTip(qy.tank.utils.TipUtil.createTipContent(itemData))
    -- 	end)
    -- end
    return self
end

function GarageTankCell:setShowLevelBg(bool)
	if qy.InternationalUtil:hasTankReform() then
    	self.reform_bg:setVisible(bool)
    end
end

function GarageTankCell:render(entity, idx)
	self.tankLevel:setVisible(self.showLevel)
	self.light:setVisible(false)
	self.redDot:setVisible(false)
	self.tankImg:removeAllChildren()
	if entity ~= nil then
        if qy.InternationalUtil:hasTankReform() then
            self.reform_bg:setVisible(false)
        end
		if entity == -1 then
			self.tankName:setString("")
			self.tankLevel:setString("")
			self.tankImg:setSpriteFrame("Resources/common/icon/c_8.png")
			self.bg:loadTexture("tank/bg/bg1.png")
			local unlockLevelNum = self.model:getUnlockLevelByIndex(idx)
			print("unlockLevelNum ====" .. unlockLevelNum)
			self.unlockLevel = qy.tank.widget.Attribute.new({
				["attributeImg"] = "Resources/garage/c_16.png",
        		["numType"] = 16,
        		["value"] = unlockLevelNum,
        		["showType"] = 2,
    		})
    		self.tankImg:addChild(self.unlockLevel)
		elseif entity == 0 then
			self.tankName:setString("")
			self.tankLevel:setString("")
			self.tankImg:setSpriteFrame("Resources/garage/c_14.png")
			self.bg:loadTexture("tank/bg/bg1.png")
		else
			-- self.lockIcon:setVisible(false)
			self.tank_id = entity.tank_id
			if entity.advance_level and entity.advance_level > 0 then
	            self.tankName:setString(entity.name .. "  +" .. entity.advance_level)
	        else
	            self.tankName:setString(entity.name)
	        end
			self.tankName:setString(entity.name)
			self.tankName:setColor(entity:getFontColor())
			self.tankLevel:setString("LV."..entity.level)
			 print("++++++++++++777001",entity:getIcon())
			 print("++++++++++++999111",entity.level)
			self.tankImg:setTexture(entity:getIcon())
			print("88888==00999--",entity:getIcon())
			self.bg:loadTexture(entity:getIconBg())
			if self.hasDot and self.model:hasRedDotOnTankIcon(entity.unique_id) then
				self.redDot:setVisible(true)
			end
            if qy.InternationalUtil:hasTankReform() then
    			if entity.reform_stage == 0 then
    				self.reform_bg:setVisible(false)
    			else
    				self.reform_bg:setVisible(true)
                	self.reform_num:setString(entity.reform_stage)
    			end
            end
		end
	end
end

function GarageTankCell:onEnter()
end

function GarageTankCell:onExit()
end

return GarageTankCell
