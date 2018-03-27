--[[--
--账号列表
--Author: H.X.Sun
--Date: 2015-07-28
--]]

local AccountList = qy.class("AccountList", qy.tank.view.BaseView)

function AccountList:ctor(delegate)
    AccountList.super.ctor(self)
	self.delegate = delegate
	-- self.panel = ccui.ImageView:create()
	-- self.panel:setContentSize(qy.winSize.width,qy.winSize.height)
	-- self.panel:setTouchEnabled(true)
	-- -- self.panel:setBackGroundColor(cc.c3b(0, 0, 255))
	-- -- self.panel:setBackGroundColorOpacity(102)
	-- self:addChild(self.panel)
	self.panel = ccui.ImageView:create()
	self.panel:ignoreContentAdaptWithSize(false)
	self.panel:loadTexture("Resources/common/bg/c_12.png",0)
	self.panel:setContentSize(qy.winSize.width,qy.winSize.height)
	self.panel:setScale9Enabled(true)
	self.panel:setCapInsets(cc.rect(25,18,5,19))
	self.panel:setTouchEnabled(false)
	self.panel:setPosition(-5,290)
	self.panel:setAnchorPoint(0.5,1)
	self:addChild(self.panel)

	--关闭
	self:OnClick(self.panel, function()
		self.delegate.updateData()
		-- self:dismiss()
	end)
	
	self.bg = ccui.ImageView:create()
	self.bg:ignoreContentAdaptWithSize(false)
	self.bg:loadTexture("Resources/login/login_H_00015.png",1)
	self.bg:setContentSize(458,62 * qy.tank.model.LoginModel:getUserAccountNun() + 17)
	self.bg:setScale9Enabled(true)
	self.bg:setCapInsets(cc.rect(25,18,5,19))
	self.bg:setTouchEnabled(false)
	self.bg:setPosition(0,11)
	self.bg:setAnchorPoint(0.5,1)
	self:addChild(self.bg)

	self.list = self:__createList()
	self.bg:addChild(self.list)
end

function AccountList:__createList()
	local tableView = cc.TableView:create(cc.size(460,62 * qy.tank.model.LoginModel:getUserAccountNun()))
	tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	tableView:setPosition(3,9)
	tableView:setDelegate()

	local function numberOfCellsInTableView(table)
		return qy.tank.model.LoginModel:getUserAccountNun()
	end

	local function tableCellTouched(table,cell)
		-- qy.tank.model.LoginModel:saveAccountData(qy.tank.model.LoginModel:getUserAccountData(cell:getIdx()))
		-- self.delegate.updateData()
		print("+++++++++++++++++++tableCellTouched")
	end

	local function cellSizeForTable(tableView, idx)
		return 440, 62
	end

	local function tableCellAtIndex(table, idx)
		local cell = table:dequeueCell()
		local item
		if nil == cell then
			cell = cc.TableViewCell:new()
			item = qy.tank.view.login.AccountCell.new({
				["updateData"] = function ()
					self.delegate.updateData()
				end
				})
			cell:addChild(item)
			cell.item = item
		end
		item:update(idx + 1)
		return cell
	end

	tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    	tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
	tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
	tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
	tableView:reloadData()
	return tableView
end

function AccountList:__sacle(_begin, _endScale)
	if _begin >= _endScale then
		self.bg:setScaleY(_endScale)
	else
		_begin = _begin + 0.1
		self.bg:setScaleY(_begin)
		self:__sacle(_begin, _endScale)
	end
end

function AccountList:onEnter()
	self.bg:setScaleY(0.1)
	-- self:__sacle(0.1, 1)
	local sacle = 0.1
	local callFunc = cc.CallFunc:create(function ()
		sacle = sacle + 0.1
		if sacle > 1 then
			self.bg:stopAllActions()
		else
			self.bg:setScaleY(sacle)
		end
	end)
	self.bg:runAction(cc.RepeatForever:create(cc.Sequence:create(callFunc)))
end

function AccountList:onExit()
	local sacle = 1
	local callFunc = cc.CallFunc:create(function ()
		sacle = sacle - 0.1
		if sacle < 0.1 then
			self.bg:stopAllActoins()
		else
			self.bg:setScaleY(sacle)
		end
	end)
	self.bg:runAction(cc.RepeatForever:create(cc.Sequence:create(callFunc)))
end

return AccountList