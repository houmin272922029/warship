--[[--
	矿区tip
	Author: H.X.Sun
	Date: 2015-05-25
--]]--

local MineTip = qy.class("MineTip", qy.tank.view.BaseDialog, "view/mine/MineTip")
local NumberUtil = qy.tank.utils.NumberUtil

function MineTip:ctor(delegate)
    MineTip.super.ctor(self)
	self.entity = delegate.entity
	self.updateMineInfo = delegate.updateMineInfo
    self:setCanceledOnTouchOutside(true)
    self:InjectView("full_icon")

	local style = qy.tank.view.style.DialogStyle5.new({
		size = cc.size(500,380),
        position = cc.p(0,0),
        offset = cc.p(0,0),

		-- ["onClose"] = function()
		-- 	self:dismiss()
		-- end
	})
	self:addChild(style, -1)

	self:OnClick("btn",function()
		if self.entity.owner.id ~= 0 then
			qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.EXAMINE,self.entity.owner.id)
		end
    end)


	self:__initView()
	self:updateViewData()

	self:OnClick("action", function (sendr)
		if self.entity.owner.id == 0 then
			--空闲状态--占领
			local service = qy.tank.service.MineService
			service:occupation(self.entity.id, function(data)
				if delegate.updateMineInfo then
					delegate.updateMineInfo(1)
				end
			end)
			self:dismiss()
		elseif self.entity.owner.id == qy.tank.model.UserInfoModel.userInfoEntity.kid then
			--自己占领-->收获
			if self.entity:canHarvest() then
				local service = qy.tank.service.MineService
				service:harvestRareMine(self.entity.id, function(data)
					qy.tank.model.RedDotModel:cancelRareMineDot()
					if delegate.updateMineInfo then
						delegate.updateMineInfo(2)
					end
					if data.list and data.list.list then
						delegate:refreshPage()
					end
				end)
				self:dismiss()
			else
				local fontName = qy.language == "tw" and "res/Resources/font/ttf/black_body_2.TTF" or "Arial"
				qy.alert:show(
            		{qy.TextUtil:substitute(21002) ,{255,255,255} } ,
            		{{id=1,color={255,255,255},alpha=255,text=qy.TextUtil:substitute(21001),font=fontName,size=20}} ,
            		cc.size(533 , 250) ,{{qy.TextUtil:substitute(21003) , 4} , {qy.TextUtil:substitute(21004) , 5} } ,
            		function(flag)
                		if qy.TextUtil:substitute(21004) == flag then
                        	local service = qy.tank.service.MineService
							service:harvestRareMine(self.entity.id, function(data)
								if delegate.updateMineInfo then
									delegate.updateMineInfo(1)
								end
								if data.list and data.list.list then
									delegate:refreshPage()
								end
							end)
							self:dismiss()
							qy.hint:show(qy.TextUtil:substitute(21005))
               			end
        		end ,"")
        	end
		else
			--别人占领-->掠夺
			-- if self.entity.owner
			local service = qy.tank.service.MineService
			service:plunderRareMine(self.entity, function(data)
				-- qy.tank.manager.ScenesManager:pushScene(qy.tank.view.scene.BattleScene.new())
				qy.tank.manager.ScenesManager:pushBattleScene()
				-- if delegate.updateMineInfo then
				-- 	delegate.updateMineInfo(3)
				-- end
			end)
			self:dismiss()
		end
		-- self:dismiss()
	end)
end

--[[--
--初始化控件
--]]
function MineTip:__initView()
	self:InjectView("product_1")
    self:InjectView("product_2")

	self:InjectView("occupation")
	self:InjectView("owner")
	self:InjectView("level")
	self:InjectView("fight")
	self:InjectView("totalProduct")
    self:InjectView("legion_name")

	self:InjectView("free")
	self:InjectView("maxProduct")

	self:InjectView("action")
	self:InjectView("bg2")
	self:InjectView("icon")
	self:InjectView("underline")
end

--[[--
--更新控件数据
--]]
function MineTip:updateViewData()
	if self.entity.type == 2 then
		--2:龙头
		self.icon:setSpriteFrame("Resources/mine/lead_mine.png")
		self.icon:setScale(0.4)
	else
		--1:普通
		self.icon:setSpriteFrame("Resources/mine/general_mine.png")
		self.icon:setScale(0.7)

	end
	if self.entity.owner.id == 0 then
		--空闲状态
        self.product_2:setString(self.entity:getProductEveryMinuteDes())
		self.occupation:setVisible(false)
		self.free:setVisible(true)
		self.maxProduct:setString(qy.InternationalUtil:getResNumString(self.entity.maxProduct))
		self.action:setTitleText(qy.TextUtil:substitute(21006))
		self.bg2:setContentSize(cc.size(460,70))
		self.bg2:setPosition(153,141)
        self.full_icon:setVisible(false)
	else
        self.product_1:setString(self.entity:getProductEveryMinuteDes())
		self.bg2:setContentSize(cc.size(460,40))
		self.bg2:setPosition(153,108)
		self.occupation:setVisible(true)
		self.free:setVisible(false)
		self.totalProduct:setString(qy.InternationalUtil:getResNumString(self.entity:getRareMineCurProduct()))
		if self.entity.owner.id == qy.tank.model.UserInfoModel.userInfoEntity.kid then
			--自己占领
			self.owner:setString(qy.tank.model.UserInfoModel.userInfoEntity.name)
			self.level:setString(qy.tank.model.UserInfoModel.userInfoEntity.level)
			self.fight:setString(qy.tank.model.UserInfoModel.userInfoEntity.fightPower)
			if self.entity:canHarvest() then
				self.action:setTitleText(qy.TextUtil:substitute(21007))
			else
				self.action:setTitleText(qy.TextUtil:substitute(21008))
			end
		else
			--别人占领
			self.owner:setString(self.entity.owner.nickname)
			self.level:setString(self.entity.owner.level)
			self.fight:setString(self.entity.owner.fight_power)
			self.action:setTitleText(qy.TextUtil:substitute(21009))
		end
		self.underline:setContentSize(cc.size(self.owner:getContentSize().width,29))
        self.legion_name:setString(self.entity.owner.legion_name)
        if self.entity:isProductFull() then
            self.full_icon:setVisible(true)
        else
            self.full_icon:setVisible(false)
        end
	end
end

return MineTip
