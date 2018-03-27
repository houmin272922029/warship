--[[--
--折扣贩售dialog
--Author: lijian ren
--Date: 2015-08-04
--]]--

local DiscountSaleDialog = qy.class("DiscountSaleDialog", qy.tank.view.BaseDialog, "discount_sale/ui/discount_sale")

function DiscountSaleDialog:ctor(delegate)
    DiscountSaleDialog.super.ctor(self)
    self.model = qy.tank.model.OperatingActivitiesModel
    print("重新打开")
	self:InjectView("bg")
	self:InjectView("closeBtn")
	self:InjectView("Panel")
	self:InjectView("time")--时间
	self:InjectView("title")--标题
	self:OnClick("bg_close", function(sender)
        self:dismiss()
    end)
	
    self.list = self:__createList()
    self.Panel:addChild(self.list)

end

function DiscountSaleDialog:__createList()
	local tableView = cc.TableView:create(cc.size(700, 450))
	tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	tableView:setPosition(0,0)
	tableView:setDelegate()

	local function numberOfCellsInTableView(table)
		return self.model:getDiscountNum()
	end

	local function tableCellTouched(table,cell)
	end

	local function cellSizeForTable(tableView, idx)
		return 700, 165
	end

	local function tableCellAtIndex(table, idx)
		local cell = table:dequeueCell()
		local item
		if nil == cell then
			cell = cc.TableViewCell:new()
			item = qy.tank.view.operatingActivities.discount_sale.DiscountSaleCell.new({
				["callBack"] = function ()
					self:dismiss()
				end
			})
			cell:addChild(item)
			cell.item = item
		end
		cell.item.idx = idx
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
function DiscountSaleDialog:onEnter()
    self.time:setString(qy.tank.utils.DateFormatUtil:toDateString(self.model.Endtime - qy.tank.model.UserInfoModel.serverTime, 7))
    self.listener_1 = qy.Event.add(qy.Event.BONUS_TIME,function(event)
        self.time:setString(qy.tank.utils.DateFormatUtil:toDateString(self.model.Endtime - qy.tank.model.UserInfoModel.serverTime, 7))
    end)
    
end

function DiscountSaleDialog:onExit()
    qy.Event.remove(self.listener_1)
  
end


return DiscountSaleDialog
