--[[
	车库坦克列表cell
	Author: Aaron Wei
	Date: 2015-03-20 20:02:10
]]

local TankSelectCell = qy.class("TankSelectCell", qy.tank.view.BaseView, "view/garage/TankSelectCell")

local FightJapanModel = qy.tank.model.FightJapanModel
local VipModel = qy.tank.model.VipModel

function TankSelectCell:ctor(delegate)
    TankSelectCell.super.ctor(self)

	self.delegate = delegate
	self.index = delegate.index
	self.entity = nil
	self:InjectView("bg")
	self:InjectView("tankName")
	self:InjectView("tankLevel")
	self:InjectView("tankStar")
	self:InjectView("tankIcon")
	self:InjectView("quality")
	self:InjectView("btn")
    self:InjectView("reform_num")
    self:InjectView("reform_bg")
    self:InjectView("levelTitle")
    self:InjectView("tank_fragment")
	local awardType = qy.tank.view.type.AwardType
	self.achieveModel = qy.tank.model.AchievementModel

	for i = 1,5 do
        self:InjectView("s"..i)
    end

	self:OnClick("btn", function(sender)
        self.delegate.choose(self.entity.unique_id)
    end)

    self:OnClick("quality", function(sender)
    	local itemData = {}
    	itemData.type = awardType.TANK
    	itemData.entity = self.entity
        qy.alert:showTip(qy.tank.utils.TipUtil.createTipContent(itemData))
    end)


	self:dealFightJapan()

	self.bg:setSwallowTouches(true)
	self.btn:setSwallowTouches(false)
	self.quality:setSwallowTouches(false)
end

function TankSelectCell:render(entity)
	if entity then
		self.entity = entity
		if entity.advance_level and entity.advance_level > 0 then
            self.tankName:setString(entity.name .. "  +" .. entity.advance_level)
        else
            self.tankName:setString(entity.name)
        end
		-- self.tankName:setString(entity.name)
		self.tankName:setTextColor(qy.tank.utils.ColorMapUtil.qualityMapColor(entity.quality))

		if entity.num and tonumber(entity.is_tank_fragment) == 1 then
			self.levelTitle:setString(qy.TextUtil:substitute(90260))
			self.tankLevel:setString(entity.num % qy.tank.model.GarageModel.tank_fragment_merge[entity.quality].." / "..qy.tank.model.GarageModel.tank_fragment_merge[entity.quality])
			self.tank_fragment:setVisible(true)
			self.btn:setVisible(false)
		else
			self.levelTitle:setString(qy.TextUtil:substitute(90259))
			self.tankLevel:setString(""..entity.level)
			self.tank_fragment:setVisible(false)
			self.btn:setVisible(true)
		end

		
		self:setStar(tonumber(entity.star))
		local res_id = qy.Config.tank[tostring(entity.tank_id)].icon
		self.tankIcon:setTexture("tank/icon/icon_t"..res_id..".png")
		self.quality:loadTexture(qy.tank.model.GarageModel:getQualityBgPath(entity.quality))
		self:updataFightJapanStatus()

		self:showRedDot()

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

--[[--
--显示红点
--]]
function TankSelectCell:showRedDot()
	if self.entity:isNew() and self.achieveModel:getPicAddListNum() > 0 then
		if self.dot == nil then
			self.dot = qy.tank.view.common.RedDot.new({})
			self.quality:addChild(self.dot)
			self.dot:setPosition(185, 107)
		end
		self.dot:update(true)
		self.dot:setVisible(true)
		self.achieveModel:removeTankInPicList(self.entity.tank_id)
		qy.tank.model.RedDotModel:changeTankCellRedDot()
	else
		if self.dot then
			self.dot:setVisible(false)
		end
	end
	self.entity:setNewStatus(false)
end

function TankSelectCell:setStar(value)
    print("GarageView:setStar star="..value)
    for i = 1,5 do
        if i <= value then
            self["s"..i]:setVisible(true)
        else
            self["s"..i]:setVisible(false)
        end
    end
end

-- 判断是否为抗日远征专属
function TankSelectCell:isForFightJapan()
	return qy.tank.model.UserInfoModel.isInFightJapan
end

function TankSelectCell:dealFightJapan()
    -- if not self:isForFightJapan()  then return end

	self:InjectView("resurrectionBtn")
	self:InjectView("fightJapanNode")
	self:InjectView("diedSignPanel")
	self:InjectView("btn")

    local service = qy.tank.service.FightJapanService

    local function callback(flag)
        if flag == qy.TextUtil:substitute(14013) then
            local num1 = VipModel:getRaisedNumByVipLevel()
            local num2 = FightJapanModel:getRaisedNum()

            if tonumber(num1) and tonumber(num2) and num1 - num2 <= 0 then
                qy.hint:show(qy.TextUtil:substitute(14014)..VipModel:getRaisedNumByVipLevel() .."次")
                return
            end

            service:resurrection(self.entity.unique_id, function(data)
    		    qy.hint:show(qy.TextUtil:substitute(14015))
                self:updataFightJapanStatus()
    	    end)
        end
    end

	self:OnClick(self.resurrectionBtn, function(sender)
    	if not self:isForFightJapan()  then return end
        local cost = FightJapanModel:getDiamondByQuality(self.entity.star)

        local richTxt = ccui.RichText:create()
        richTxt:ignoreContentAdaptWithSize(false)
        richTxt:setContentSize(460, 150)
        richTxt:setAnchorPoint(0,0.5)
        local stringTxt1 = ccui.RichElementText:create(1, cc.c3b(255,255,255), 255, qy.TextUtil:substitute(14017) , qy.res.FONT_NAME_2, 24)
        richTxt:pushBackElement(stringTxt1)
        local stringTxt2 = ccui.RichElementImage:create(2, cc.c3b(255,255,255), 255, "Resources/common/icon/coin/1a.png")
        richTxt:pushBackElement(stringTxt2)
        local stringTxt3 = ccui.RichElementText:create(3, cc.c3b(255,255,255), 255, cost , qy.res.FONT_NAME_2, 24)
        richTxt:pushBackElement(stringTxt3)
        local stringTxt4 = ccui.RichElementText:create(4, cc.c3b(255,255,255), 255, qy.TextUtil:substitute(14018), qy.res.FONT_NAME_2, 24)
        richTxt:pushBackElement(stringTxt4)
        qy.alert:showWithNode(qy.TextUtil:substitute(14019),  richTxt, cc.size(560,250), {{qy.TextUtil:substitute(14020) , 4},{qy.TextUtil:substitute(14013) , 5} }, callback, {})
        richTxt:setPosition(richTxt:getPositionX()-220,richTxt:getPositionY()-90)
	end)

	-- 血量条标签
	self.bloodBar = qy.tank.widget.progress.BattleBloodBar.new()
	self.bloodBar:setAnchorPoint(0,0)
    self.bloodBar:setPosition(95,32-2)
    self.bloodBar:setPercent(1,false)
    self.fightJapanNode:addChild(self.bloodBar)

    -- 士气条标签
	self.moraleBar = qy.tank.widget.progress.BattleMoraleBar.new()
    self.moraleBar:setAnchorPoint(0,0)
    self.moraleBar:setPosition(95,32-12)
    self.fightJapanNode:addChild(self.moraleBar)


    self.fightJapanNode:setVisible(self:isForFightJapan())
end

--显示血条或士气
function TankSelectCell:showBloodAndMorale( show , isDied)
	self.bloodBar:setVisible(show)
	self.moraleBar:setVisible(show)
	self.diedSignPanel:setVisible(show)
	if show then
		if isDied then
			self.diedSignPanel:setVisible(true)
			self.moraleBar:setVisible(false)
			self.bloodBar:setVisible(false)
			self.resurrectionBtn:setVisible(true)
		else
			self.bloodBar:setVisible(true)
			self.moraleBar:setVisible(true)
			self.diedSignPanel:setVisible(false)
			self.resurrectionBtn:setVisible(false)
		end
	end

end

--更新hp
function TankSelectCell:updateHp( current , max)
	self.bloodBar:setPercent(current/max,false)
end

-- 更新士气
function TankSelectCell:updateMorale( current , max )
	self.moraleBar:setPercent(current/max,false)
end

function TankSelectCell:updataFightJapanStatus()
	if not self:isForFightJapan()  then
		return
	end

	local expeGaraModel = qy.tank.model.FightJapanGarageModel
	local tankExData = expeGaraModel:getTankExtendDataByTankUId(self.entity.unique_id)
	local totalMorale= expeGaraModel:getTotalMorale()
	local isDied = false
	if tankExData == nil then
		self:showBloodAndMorale(true , isDied)
		self:updateMorale(0, 4)
		self:updateHp(1, 1)
	else
		isDied = tankExData.status == 1 and true or false
		self:showBloodAndMorale(true , isDied)
		self:updateHp(tankExData.current_blood, 1)
		self:updateMorale(tankExData.morale , 4)
	end
end

function TankSelectCell:onEnter()
	if self.index == 1 then
		-- --新手引导：注册控件
		qy.GuideCommand:addUiRegister({
			{["ui"] = self.btn, ["step"] = {"SG_63"}},
		})
	end
end

function TankSelectCell:onExit()
	--新手引导：移除控件注册
	qy.GuideCommand:removeUiRegister({"SG_63"})
end
return TankSelectCell
