--[[--
--充值返利dialog
--Author: H.X.Sun
--Date: 2015-06-24
--]]--

local PayRebateDialog = qy.class("PayRebateDialog", qy.tank.view.BaseDialog, "view/operatingActivities/pay_rebate/PayRebateDialog")

function PayRebateDialog:ctor(delegate)
    PayRebateDialog.super.ctor(self)
    self.model = qy.tank.model.OperatingActivitiesModel

	self:InjectView("bg")
	self:InjectView("total_num")
	self:InjectView("need_num")
	self:InjectView("remain_time")
	self:OnClick("closeBtn", function(sender)
        self:dismiss()
    end,{["isScale"] = false})

    self:OnClick("rechargeBtn", function(sender)
    	self:dismiss()
    	qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.RECHARGE)
    end)

    self.list = self:__createList()
    self.bg:addChild(self.list)

    self.total_num:setString(self.model:getRebateRechargeNum() .. qy.TextUtil:substitute(63015))
    local _lessCash = self.model:getRebateLessCash()
    if _lessCash > 0 then
    	self.need_num:setString(qy.TextUtil:substitute(63016) .. _lessCash .." ".. qy.TextUtil:substitute(63017))
    else
    	self.need_num:setString(qy.TextUtil:substitute(63018))
    end
end

function PayRebateDialog:__createList()
	local tableView = cc.TableView:create(cc.size(720, 335))
	tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	tableView:setPosition(3,3)
	tableView:setDelegate()

	local function numberOfCellsInTableView(table)
		return self.model:getPayRebateAwardNum()
	end

	local function tableCellTouched(table,cell)
	end

	local function cellSizeForTable(tableView, idx)
		return 720, 150
	end

	local function tableCellAtIndex(table, idx)
		local cell = table:dequeueCell()
		local item
		if nil == cell then
			cell = cc.TableViewCell:new()
			item = qy.tank.view.operatingActivities.pay_rebate.PayRebateCell.new({
				["callBack"] = function ()
					self:dismiss()
				end
			})
			cell:addChild(item)
			cell.item = item
		end
		cell.item:render(idx + 1)
		return cell
	end

	tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
	tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
	tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
	tableView:reloadData()
	return tableView
end

function PayRebateDialog:updateTime()
	if self.remain_time then
		self.remain_time:setString(self.model:getPayRebateRemainTime())
	end
end

function PayRebateDialog:onEnter()
	self:updateTime()
	self.timeListener = qy.Event.add(qy.Runtime.TIMER_UPDATE,function(event)
		self:updateTime()
	end)
end

function PayRebateDialog:onExit()
    qy.Event.remove(self.timeListener)
    self.timeListener = nil
end

return PayRebateDialog
