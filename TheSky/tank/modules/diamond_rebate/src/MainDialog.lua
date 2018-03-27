

local MainDialog = qy.class("MainDialog", qy.tank.view.BaseDialog, "diamond_rebate/ui/MainView")

function MainDialog:ctor(delegate)
    MainDialog.super.ctor(self)
    self.model = qy.tank.model.OperatingActivitiesModel
	self:InjectView("closeBt")
	self:InjectView("listview")
	self:InjectView("time")--时间
	self:OnClick("closeBt", function(sender)
        self:removeSelf()
    end)
	
    self.datalist = self:__createList()
    self.listview:addChild(self.datalist)

end

function MainDialog:__createList()
	local tableView = cc.TableView:create(cc.size(480, 360))
	tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	tableView:setPosition(-3,0)
	tableView:setDelegate()

	local function numberOfCellsInTableView(table)
		return #(self.model.endlist)
	end

	local function tableCellTouched(table,cell)
	end

	local function cellSizeForTable(tableView, idx)
		return 480, 145
	end

	local function tableCellAtIndex(table, idx)
		local cell = table:dequeueCell()
		local item
		if nil == cell then
			cell = cc.TableViewCell:new()
			item = require("diamond_rebate.src.Cell").new({
				["callBack"] = function ()
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
function MainDialog:onEnter()
    self.time:setString(qy.tank.utils.DateFormatUtil:toDateString(self.model.diamond_rebate_endtime - qy.tank.model.UserInfoModel.serverTime, 7))
    self.listener_1 = qy.Event.add(qy.Event.BONUS_TIME,function(event)
        self.time:setString(qy.tank.utils.DateFormatUtil:toDateString(self.model.diamond_rebate_endtime - qy.tank.model.UserInfoModel.serverTime, 7))
    end)
    
end

function MainDialog:onExit()
    qy.Event.remove(self.listener_1)
  
end


return MainDialog
