--[[--
--稀有矿区view
--Author: H.X.Sun
--Date: 2015-05-25
--]]--

local RareMineView = qy.class("RareMineView", qy.tank.view.BaseView, "view/mine/RareMineView")

function RareMineView:ctor(delegate)
    RareMineView.super.ctor(self)
	self.delegate = delegate
	self.model = qy.tank.model.MineModel
    self.userModel = qy.tank.model.UserInfoModel
	self.lastUpdateTime = 0

	--初始化ui
	self:__initView()
	--绑定点击事件
	self:__bindingClickEvent()
	self:updateViewData()
	self:__updatePageBtnStatus()
end

--[[--
--更新界面数据
--]]
function RareMineView:updateViewData()
	self.mineLevel:setString(self.model:getMineLevelDes())
	self.pageNum:setString(self.model:getCurPage())
end

--[[--
--初始化ui
--]]
function RareMineView:__initView()
	self:InjectView("previousPage")
	self:InjectView("nextPage")
    self:InjectView("energyTxt")

	self:InjectView("bg_Bottom")
	self.bg_Bottom:setContentSize(qy.winSize.width, qy.winSize.height)
	self:InjectView("mineLevel")
	self.mineLevel:enableOutline(cc.c4b(0,0,0,255),1)
	self:InjectView("previousPageTxt")
	self.previousPageTxt:enableOutline(cc.c4b(0,0,0,255),1)
	self:InjectView("nextPageTxt")
	self.nextPageTxt:enableOutline(cc.c4b(0,0,0,255),1)
	self:InjectView("pageNum")
	self.pageNum:enableOutline(cc.c4b(0,0,0,255),1)

	self:InjectView("mineList")
	self:InjectView("left")
	self:_initRareMineViewList()
	self:_intOilList()
end

--[[--
--初始化油料列表
--]]
function RareMineView:_intOilList()
	self.oilList = qy.tank.view.mine.OilList.new({["type"] = 2})
	self.left:addChild(self.oilList)
	self.oilList:setPosition(56, 630)
end

--[[--
--初始化稀有矿视图列表
--]]
function RareMineView:_initRareMineViewList()
	self.page1 = qy.tank.view.mine.RareMineList.new({
		["updateOil"] = function ()
			self.oilList:updateOil()
		end,
		["refreshPage"] = function ()
			self:refreshPage()
		end
		})
    	self.mineList:addChild(self.page1)
    	-- self:refreshPage()
end

--[[--
--绑定点击事件
--]]
function RareMineView:__bindingClickEvent()
	--关闭
	self:OnClick("exitBtn", function (sendr)
		if self.delegate and self.delegate.dismiss then
			self.delegate.dismiss()
		end
	end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})

	--刷新
	self:OnClick("refreshBtn", function (sendr)
		if qy.tank.model.UserInfoModel.serverTime - self.lastUpdateTime > 15 then
			local service = qy.tank.service.MineService
			service:getRareMineList(self.model:getCurPage(), function(data)
				self.lastUpdateTime = qy.tank.model.UserInfoModel.serverTime
				self:refreshPage()
			end)
		else
			qy.hint:show(qy.TextUtil:substitute(21041))
		end
	end)

	--上一页
	self:OnClick("previousPage", function (sendr)
		if self.model:getCurPage() == 1 then
			qy.hint:show(qy.TextUtil:substitute(21042))
		else
			self:getDataByPage(self.model:getCurPage() - 1)
		end
	end, nil,function(sendr) self.previousPageTxt:setScale(0.9) end,
	function(sendr) self.previousPageTxt:setScale(1) end)

	--下一页
	self:OnClick("nextPage", function (sendr)
		if self.model:getCurPage() == 10 then
			qy.hint:show(qy.TextUtil:substitute(21042))
		else
			self:getDataByPage(self.model:getCurPage() + 1)
		end
	end, nil,function(sendr) self.nextPageTxt:setScale(0.9) end,
	function(sendr) self.nextPageTxt:setScale(1) end)

    local award = {["type"] = 14, ["num"] = 1, ["id"] = 1}
    local _data = {award}
    self:OnClick("addEnergyBtn", function(sender)
        qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.BUY_OR_USE,_data)
    end)
end

function RareMineView:refreshPage()
	self:updateViewData()
	self.page1:updateList()
end

function RareMineView:__updatePageBtnStatus()
	if self.model:getCurPage() == 1 then
		self.previousPage:setBright(false)
		self.previousPage:setTouchEnabled(false)
	else
		self.previousPage:setBright(true)
		self.previousPage:setTouchEnabled(true)
	end

	if self.model:getCurPage() == 10 then
		self.nextPage:setBright(false)
		self.nextPage:setTouchEnabled(false)
	else
		self.nextPage:setBright(true)
		self.nextPage:setTouchEnabled(true)
	end
end

--[[--
--根据页数获取数据
--@param #number _type 1:上一页 2：下一页
--]]
function RareMineView:getDataByPage(nPage, _type)
	local service = qy.tank.service.MineService
	service:getRareMineList(nPage, function(data)
		self:__updatePageBtnStatus()
		self:refreshPage()
	end)
end

--[[--
--更新矿区信息
--]]
function RareMineView:updateMineInfo()
end

--[[--
--更新矿区时间
--]]
function RareMineView:updateMineTime()
	self.oilList:updateRemainTime()
end

--[[--
--更新用户资源
--]]
function RareMineView:updateResource(is_deleay)
    if is_deleay == nil then
        is_deleay = true
    end
    if not is_deleay then
        self.energyTxt:setString(self.userModel.userInfoEntity:getEnergyStr() .. "/" .. self.userModel:getEnergyLimitByVipLevel())
    else
        local timer = qy.tank.utils.Timer.new(0.2,1,function()
            self.energyTxt:setString(self.userModel.userInfoEntity:getEnergyStr() .. "/" .. self.userModel:getEnergyLimitByVipLevel())
        end)
        timer:start()
    end
end

function RareMineView:onEnter()
	self:updateResource(false)
	self:updateMineTime()
	self.oilList:updateOil()
	self:refreshPage()
end

function RareMineView:onExit()
	--移除控件的动画
	self:removeUiAmin()
	self.delegate.closeCallBack()
end

function RareMineView:removeUiAmin()
end

return RareMineView
