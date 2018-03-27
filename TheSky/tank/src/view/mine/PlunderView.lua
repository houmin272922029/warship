--[[--
--矿区掠夺view
--Author: H.X.Sun
--Date: 2015-05-25
--]]--

local PlunderView = qy.class("PlunderView", qy.tank.view.BaseView, "view/mine/PlunderView")

function PlunderView:ctor(delegate)
    PlunderView.super.ctor(self)
	self.delegate = delegate
	self.model = qy.tank.model.MineModel
	self.owner = self.model.mineEntity.owner

	local style = qy.tank.view.style.ViewStyle1.new({
        titleUrl = "Resources/common/title/plunder_title.png",  
        ["onExit"] = function()
            if delegate and delegate.dismiss then
                delegate.dismiss()
            end
        end
    })
    self:addChild(style)

	--初始化ui
	self:__initView()
	--绑定点击事件
	self:__bindingClickEvent()
	self:updateViewData()
	
end

--[[--
--更新界面数据
--]]
function PlunderView:updateViewData()
	--显示掠夺列表
	self:showPlunderList()
	--更新掠夺力
	self:updatePlunder()
	--更新刷新条件
	self:updateRefreshCondition()
end

--[[--
--更新掠夺力
--]]
function PlunderView:updatePlunder()
	self.plunderTip:setString(self.owner:getPlunderDes())
	self.plunderLevel:setSpriteFrame(self.owner:getPlunderIcon())
	self.plunderTip:setTextColor(self.owner:getPlunderColor())
end

--[[--
--显示掠夺列表
--]]
function PlunderView:showPlunderList()
	local list = self.model:getPlunderList()
	for i = 1, #list do
		self.plunderViewList[i]:updateCell(list[i])
	end
end

--[[--
--更新刷新条件
--]]
function PlunderView:updateRefreshCondition()
	if self.owner.free_times > 0 then
		self.refresh_txt:setSpriteFrame("Resources/common/txt/mianfeishuaxin.png")
	else
		self.refresh_txt:setSpriteFrame("Resources/common/txt/tilishuaxin.png")
	end
end

--[[--
--初始化ui
--]]
function PlunderView:__initView()
	self:InjectView("bg_Bottom")
	self.bg_Bottom:setContentSize(qy.winSize.width, qy.winSize.height)
	self:InjectView("plunderTip")
	self.plunderTip:enableOutline(cc.c4b(0,0,0,255),1)
	-- self:InjectView("costEnergy")
	-- self.costEnergy:enableOutline(cc.c4b(0,0,0,255),1)

	self:InjectView("upPlunder")

	self:InjectView("refresh_txt")
	-- self:InjectView("freeText")
	self:InjectView("plunderList")
	self:InjectView("left")
	self:InjectView("plunderLevel")

	self:InjectView("right")
	self.energyNode = qy.tank.view.common.EnergyNode.new()
    self.right:addChild(self.energyNode)
    self.energyNode:setPosition(-295, 645)

	self:_initPlunderViewList()
	self:_intOilList()
end

--[[--
--初始化油料列表
--]]
function PlunderView:_intOilList()
	self.oilList = qy.tank.view.mine.OilList.new({["type"] = 1})
	self.left:addChild(self.oilList)
	self.oilList:setPosition(10, 590)
end

--[[--
--初始化掠夺视图列表
--]]
function PlunderView:_initPlunderViewList()
	local scale = (qy.winSize.width / qy.winSize.height) / (1280 / 720) 
	self.plunderList:setScale(scale)
	self.plunderViewList = {}
	local cell = nil
	for i = 1, 5 do
		cell = qy.tank.view.mine.PlunderCell.new({
			["updateOil"] = function ()
				self.oilList:updateOil()
			end
			})
		table.insert(self.plunderViewList, cell)
		self.plunderList:addChild(cell)
		if i == 1 then
			cell:setPosition(-409, 169)
		elseif i == 2 then
			cell:setPosition(-155, 131)
		elseif i == 3 then
			cell:setPosition(102, 175)
		elseif i == 4 then
			cell:setPosition(366, 129)
		elseif i == 5 then
			cell:setPosition(617, 169)
		end
	end
end

--[[--
--绑定点击事件
--]]
function PlunderView:__bindingClickEvent()
	--关闭
	self:OnClick("exitBtn", function (sendr)
		if self.delegate and self.delegate.dismiss then
			self.delegate.dismiss()
		end
	end,{["audioType"] = qy.SoundType.BTN_CLOSE,["isScale"] = false})

	--刷新
	self:OnClick("refreshBtn", function (sendr)
		if self.owner.free_times > 0 or qy.tank.model.UserInfoModel.userInfoEntity.energy > 0 then
			local service = qy.tank.service.MineService
        	service:refresh(function(data)
        		self:updateRefreshCondition()
        		self:showPlunderList()
        	end)
        else
        	qy.hint:show(qy.TextUtil:substitute(21034))
        	qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.BUY_OR_USE)
        end
	end)

	--提升掠夺力
	self:OnClick("upPlunder", function (sendr)
		local _vip = self.owner:getVipLevelForUpgradePlunder()
		local _nextLevel = self.owner.plunderLevel + 1
		local _name = self.owner:getPlunderName(_nextLevel)
		if  qy.tank.model.UserInfoModel.userInfoEntity.vipLevel < _vip then
			qy.hint:show("VIP" .. _vip .. qy.TextUtil:substitute(21035).._name)
            return
		end

		if self.owner.plunderLevel < 5 then
			self.content = qy.tank.view.mine.UpgradeMineTip.new({
				["type"] = 2,
				["entity"] = self.owner,
				["percentTxt"] = self.owner:getPlunderPercentByLevel(_nextLevel),
			})

			local function callBack(flag)
				if qy.TextUtil:substitute(21036) == flag then
					self:upgradePlunderLevel()
				end
			end

			qy.alert:showWithNode(qy.TextUtil:substitute(21037),  self.content, cc.size(560,250), {{qy.TextUtil:substitute(21038) , 4},{qy.TextUtil:substitute(21036) , 5} }, callBack, {})

			-- qy.alert:show(
			-- {"升级掠夺力" ,{255,255,255} } ,
			-- {{id=1,color={255,255,255},alpha=255,text="\n花费" .. self.owner:getUpgradePlunderCost() .. "钻石提升",font="Arial",size=20} ,
			-- {id=2,color=self.owner:getPlunderColorFor3b(),alpha=255,text="矿场",font="Arial",size=20} ,
			-- {id=3,color={255,255,255},alpha=255,text="掠夺力至",font="Arial",size=20} ,
			-- {id=4,color=self.owner:getPlunderColorFor3b(), alpha=255,
			-- text=self.owner:getPlunderPercentByLevel(_nextLevel),font="Arial",size=20}} ,
			-- cc.size(533 , 250) ,{{"取消" , 4} , {"确定" , 5} } ,
			-- function(flag)
			-- 	if "确定" == flag then
			-- 		self:upgradePlunderLevel()
			-- 	end
			-- end ,"")
		else
			qy.hint:show(qy.TextUtil:substitute(21039))
		end
	end)
end

--[[--
--升级掠夺能力
--]]
function PlunderView:upgradePlunderLevel()
	local service = qy.tank.service.MineService
        service:upgradePlunder(function(data)
        	self:updatePlunder()
        	qy.hint:show(qy.TextUtil:substitute(21040))
    end)
end

--[[--
--更新矿区时间
--]]
function PlunderView:updateMineTime()
	self.oilList:updateRemainTime()
end

--[[--
--更新用户资源
--]]
function PlunderView:updateResource()
    self.energyNode:updateEnergy(qy.tank.model.UserInfoModel.userInfoEntity.energy)
end

function PlunderView:onEnter()
	--self:updateResource()
	self:updateMineTime()
	self.oilList:updateOil()
	if self.model:isSuccessfulPlunder() then
		self.model:updatePlunderResult()
		self.timer = qy.tank.utils.Timer.new(0.3,1,function()
			qy.tank.command.AwardCommand:show(self.model:getPlunderAward())
		end)
		self.timer:start()
	end

end

function PlunderView:onExit()
	--移除控件的动画
	self:removeUiAmin()
end

function PlunderView:removeUiAmin()
end

return PlunderView