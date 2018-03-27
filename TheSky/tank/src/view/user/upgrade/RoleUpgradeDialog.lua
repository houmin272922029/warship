--[[--
--角色升级dialog
--Author: H.X.Sun
--Date: 2015-06-01
--]]--

local RoleUpgradeDialog = qy.class("RoleUpgradeDialog", qy.tank.view.BaseDialog, "view/user/upgrade/RoleUpgradeDialog")

function RoleUpgradeDialog:ctor(delegate)
    RoleUpgradeDialog.super.ctor(self)
    self.isPopup = false

	self.delegate = delegate
	self.model = qy.tank.model.RoleUpgradeModel

	--初始化ui
	self:__initView()
	self.model:updateCurRoleLevel()
	-- self:createAward()
	self:enterAnim()
	self.animStop = false

	self:OnClick("bg", function (sendr)
		if self.animStop then
			print("bg ======animStop is true")
			self:dismiss()
			qy.Event.dispatch(qy.Event.CAMPAIGN_UPDATE_CHECKPOINT)
			qy.tank.model.RoleUpgradeModel:redirectRoleUpgrade()
			qy.GuideManager:next(31)
		else
			print("bg ======animStop is false")
		end
	end,{["isScale"] = false})
	local effect = qy.tank.view.common.ParticleEffect
   	effect:showRain(self)
end

function RoleUpgradeDialog:__initView()
	self:InjectView("info")
	self:InjectView("bg")
	self:InjectView("shield")
	self:InjectView("arrow")
	self:InjectView("levelTitle")
	self:InjectView("roleTitle")
	-- self:InjectView("awardPoint")
	self:InjectView("txtContinue")
	self:InjectView("open_name")
	self:InjectView("next_open_bg")
	self:InjectView("open_level")
	self:InjectView("open_des")
	self:InjectView("open_icon")
    self:InjectView("txt")
    self.txt:setPosition(self.txt:getPositionX(), self.txt:getPositionY()-25)
	self.next_open_bg:setVisible(false)

	self.upgradeInfo = qy.tank.view.user.upgrade.UpgradeInfoCell.new()
	self.info:addChild(self.upgradeInfo)
	self:createLevelLabel(self.model.curRoleLevel)

	self.upgradeInfo:setVisible(false)
	self.levelTitle:setVisible(false)
	self.arrow:setOpacity(0)
	self.lastLevelLabel:setOpacity(0)
	self.curLevelLabel:setOpacity(0)
	self.roleTitle:setOpacity(0)
end

function RoleUpgradeDialog:initNextOpenData()
	self.nextOpenData = self.model:findNextOpenData()
    print("self.nextOpenData=====>>>",qy.json.encode(self.nextOpenData))
	if self.nextOpenData then
        local picUrl = "Resources/activity/" ..self.nextOpenData.e_name .. ".png"
        -- print("self.nextOpenData.e_name====>>>",self.nextOpenData.e_name)
        if cc.SpriteFrameCache:getInstance():getSpriteFrame(picUrl) then
    		self.next_open_bg:setVisible(true)
    		self.open_name:setString(self.nextOpenData.note)
    		self.open_level:setString(qy.TextUtil:substitute(38001, self.nextOpenData.open_level))
    		self.open_des:setString(self.nextOpenData.introduce)
    		if self.nextOpenData.e_name and self.nextOpenData.e_name ~= "" then
    			self.open_icon:setSpriteFrame(picUrl)
    		end
    		if qy.language == "cn" then
    			self.open_level:setPosition(self.open_name:getPositionX() + self.open_name:getContentSize().width + 10, self.open_name:getPositionY())
    		end
        else
            print("升级提示："..picUrl.."图片资源不存在")
            self.next_open_bg:setVisible(false)
        end
	else
		self.next_open_bg:setVisible(false)
	end
end

function RoleUpgradeDialog:showNextOpenInfo()
	self.next_open_bg:setScale(0.8)
    self.next_open_bg:setAnchorPoint(0.5, 0.5)
    self.next_open_bg:runAction(cc.Sequence:create(cc.ScaleTo:create(0.15, 1.15), cc.ScaleTo:create(0.1, 1)))
    self:initNextOpenData()
end

--[[--
--进入动画
--]]
function RoleUpgradeDialog:enterAnim()
	local function __titleShowAnim()
		self.roleTitle:setScale(5)
		local scale = cc.ScaleTo:create(0.1, 1)
		local FadeIn = cc.FadeTo:create(0.1, 255)
        		local ease = cc.EaseOut:create(scale,0.1)
		local spawn = cc.Spawn:create(FadeIn, ease)

		self.roleTitle:runAction(cc.Sequence:create(spawn))
	end

	self.shield:setPosition(1280, -400)

	local skewTo = cc.SkewTo:create(0.3, 180, 180)
	local move = cc.MoveTo:create(0.3, cc.p(368,404))
	local spawn = cc.Spawn:create(move, skewTo)

	local  callFunc = cc.CallFunc:create(function()
		__titleShowAnim()
		self.upgradeInfo:setVisible(true)
		self:showLevelAnim()
		self.levelTitle:setVisible(true)
		self.upgradeInfo:upgradeInfoAnim()
	end)
	self.shield:runAction(cc.Sequence:create(spawn, callFunc))

end

--[[--
--显示等级动画
--]]
function RoleUpgradeDialog:showLevelAnim()
	local fadeIn = cc.FadeIn:create(0.1)
	local delay = cc.DelayTime:create(0.2)

	local function __updateCurLevelAnim()
		local callFunc = cc.CallFunc:create(function ()
			self.curLevelLabel:update(self.model.curRoleLevel)
		end)
		local scaleBig = cc.ScaleTo:create(0.2, self.curLevelLabel:getScale() * 11 / 10)
		local spawn = cc.Spawn:create(scaleBig, callFunc)
		local callBackForShowAward = cc.CallFunc:create(function ()
			-- self:showRewardAnim()
			self.animStop = true
			self:showNextOpenInfo()
		end)
		local scaleSmall = cc.ScaleTo:create(0.2, self.curLevelLabel:getScale() * 10 / 11)

		self.curLevelLabel:runAction(cc.Sequence:create(fadeIn, spawn, scaleSmall, callBackForShowAward))
	end

	local callFunc = cc.CallFunc:create(function()
		__updateCurLevelAnim()
	end)

	self.curLevelLabel:runAction(cc.Sequence:create(delay, delay,fadeIn, callFunc))
	self.arrow:runAction(cc.Sequence:create(delay,fadeIn))
	self.lastLevelLabel:runAction(cc.Sequence:create(fadeIn))
	self:setLabelScale(self.curLevelLabel, self.model.curRoleLevel)
end

--[[--
--创建数字label
--@param #number 升级前角色的等级
--]]
function RoleUpgradeDialog:createLevelLabel(lastLevel)
	self.lastLevelLabel = qy.tank.widget.Attribute.new({
        ["numType"] = 9,
        ["anchorPoint"] = cc.p(0.5, 0.5),
        ["value"] = lastLevel,
    })
	self.lastLevelLabel:setPosition(340, 265)
	self.bg:addChild(self.lastLevelLabel)
	self:setLabelScale(self.lastLevelLabel, lastLevel)

	self.curLevelLabel = qy.tank.widget.Attribute.new({
        ["numType"] = 8,
        ["anchorPoint"] = cc.p(0.5, 0.5),
        ["value"] = lastLevel,
    })
	self.curLevelLabel:setPosition(360, 395)
	self.bg:addChild(self.curLevelLabel)
	self:setLabelScale(self.curLevelLabel, lastLevel)
end

function RoleUpgradeDialog:setLabelScale(ui, value)
	if value >= 1000 then
		ui:setScale(0.5)
	elseif value >= 100 then
		ui:setScale(0.7)
	elseif value >= 10 then
		ui:setScale(0.8)
	end
end

function RoleUpgradeDialog:__showEffert()
    self.currentEffert = ccs.Armature:create("ui_fx_zhujiaoshengji")
    self.shield:addChild(self.currentEffert,999)
    self.currentEffert:setPosition(280,475)
    self.currentEffert:setVisible(true)

    self.currentEffert:getAnimation():setMovementEventCallFunc(function(armatureBack,movementType,movementID)
        if movementType == ccs.MovementEventType.complete then
            self.currentEffert:setVisible(false)
        end
    end)
    self.currentEffert:getAnimation():playWithIndex(0)
end

function RoleUpgradeDialog:onEnter()
	--新手引导：注册控件
    qy.GuideCommand:addUiRegister({
        {["ui"] = self.bg,["step"] = {"SG_20","SG_47","SG_78","SG_118"}}
    })

end

function RoleUpgradeDialog:onExit()
	--新手引导：移除控件注册
    qy.GuideCommand:removeUiRegister({"SG_20","SG_47","SG_78","SG_118"})

	self.currentEffert = nil
end

return RoleUpgradeDialog
