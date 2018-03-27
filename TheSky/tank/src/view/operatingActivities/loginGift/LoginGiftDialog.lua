--[[--
--七天登陆礼包dialog
--Author: H.X.Sun
--Date: 2015-06-24
--]]--

local LoginGiftDialog = qy.class("LoginGiftDialog", qy.tank.view.BaseDialog, "view/operatingActivities/loginGift/LoginGiftDialog")

function LoginGiftDialog:ctor()
    LoginGiftDialog.super.ctor(self)
	self.model = qy.tank.model.OperatingActivitiesModel
	--通用弹窗样式
	local style = qy.tank.view.style.DialogStyle1.new({
		size = cc.size(910,572),
		position = cc.p(0,0),
		offset = cc.p(0,0), 
		titleUrl = "Resources/common/title/login_gift_title.png",

		["onClose"] = function()
			self:dismiss()
			qy.GuideManager:next(11112)
		end
	})
	self:addChild(style, -1)
	style.bg:loadTexture("Resources/operatingActivities/login_gift/login_gift_bg.jpg")
	self:InjectView("bg_sp")
	self.bg_sp:retain()
	self.bg_sp:getParent():removeChild(self.bg_sp)
	style.bg:addChild(self.bg_sp)
	self.bg_sp:release()
	self.bg_sp:setPosition(430,276)
	self:InjectView("Panel_1")
	self:InjectView("right_title")
	self:InjectView("btn")
	self:InjectView("btn_txt")
	self:InjectView("re_icon")
	self.right_title:setLocalZOrder(10)
	self.closeBtn = style.closeBtn
	self.giftList = self:__createList()
	self.Panel_1:addChild(self.giftList,2)

	self:__bindingClickEvent()
end

function LoginGiftDialog:updateGetTankStatus()
	local _status = self.model:isCompleteGetTank()
	if _status == 0 then
		self.btn:setBright(false)
        self.btn:setTouchEnabled(false)
        self.btn:setVisible(true)
        self.re_icon:setVisible(false)
        self.btn_txt:setSpriteFrame("Resources/common/txt/weidacheng2.png")
	elseif _status == 1 then
		self.btn:setBright(true)
        self.btn:setTouchEnabled(true)
        self.btn:setVisible(true)
        self.re_icon:setVisible(false)
        self.btn_txt:setSpriteFrame("Resources/common/txt/lijilingqu.png")
	else 
        self.btn:setVisible(false)
        self.re_icon:setVisible(true)
	end
end

function LoginGiftDialog:__bindingClickEvent()
	local service = qy.tank.service.OperatingActivitiesService
	--抽卡
	self:OnClick("extCardBtn",function(sender)
		self:dismiss()
		qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.EXTRACTION_CARD)
	end)

	--充值
	self:OnClick("rechargeBtn",function(sender)
		self:dismiss()
		-- qy.hint:show("跳转到充值界面")
		-- qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.EXTRACTION_CARD)
		qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.VIP)
	end)

	--坦克工厂
	self:OnClick("tankFactoryBtn",function(sender)
		self:dismiss()
		qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.TANK_SHOP)
	end)

	--领取钻石
	self:OnClick("btn",function(sender)
		service:getSevenDayAward(function(data)
			self:updateGetTankStatus()
		end)
	end)
end

function LoginGiftDialog:__createList()
	local tableView = cc.TableView:create(cc.size(500, 410))
	tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	tableView:setPosition(-45,-233)
	tableView:setDelegate()

	local function numberOfCellsInTableView(table)
		return self.model:getNumOfLoginGiftDay()
	end

	local function tableCellTouched(table,cell)
	end

	local function cellSizeForTable(tableView, idx)
		return 500, 155
	end

	local function tableCellAtIndex(table, idx)
		local cell = table:dequeueCell()
		local item
		if nil == cell then
			cell = cc.TableViewCell:new()
			item = qy.tank.view.operatingActivities.loginGift.LoginGiftCell.new({
				["callBack"] = function ()
					self:updateList()
				end,
				["day"] = idx + 1
			})
			cell:addChild(item)
			cell.item = item
		end
		local data = {
			["status"] = self.model:getLoginGiftStatusByIndex(idx + 1),
			["day"] = self.model:getDayByIndexOfLoginGift(idx + 1),
			["award"] = self.model:getAwardByIndexOfLoginGift(idx + 1),
		}
		cell.item:render(data)
		return cell
	end

	tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
	tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
	tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
	tableView:reloadData()
	return tableView
end

function LoginGiftDialog:updateList()
	if self.giftList ~= nil then
		local listCurY = self.giftList:getContentOffset().y
		self.giftList:reloadData()
		self.giftList:setContentOffset(cc.p(0,listCurY))
	end
end

function LoginGiftDialog:onEnter()
	self:updateGetTankStatus()
end

return LoginGiftDialog