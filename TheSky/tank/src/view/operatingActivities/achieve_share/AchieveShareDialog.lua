--[[--
--充值返利dialog
--Author: H.X.Sun
--Date: 2015-06-24
--]]--

local AchieveShareDialog = qy.class("AchieveShareDialog", qy.tank.view.BaseDialog, "share/ui/share")

function AchieveShareDialog:ctor(delegate)
    AchieveShareDialog.super.ctor(self)
    self.model = qy.tank.model.OperatingActivitiesModel
    print("重新打开");
	self:InjectView("bg")
	self:InjectView("closeBtn")
	self:InjectView("pannal")
	self:OnClick("closeBtn", function(sender)
        self:dismiss()
    end)
	
    self.list = self:__createList()
    self.pannal:addChild(self.list)

end

function AchieveShareDialog:__createList()
	local tableView = cc.TableView:create(cc.size(420, 420))
	tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	tableView:setPosition(0,0)
	tableView:setDelegate()

	local function numberOfCellsInTableView(table)
		return self.model:getShareAwardNum()
	end

	local function tableCellTouched(table,cell)
	end

	local function cellSizeForTable(tableView, idx)
		return 420, 176
	end

	local function tableCellAtIndex(table, idx)
		local cell = table:dequeueCell()
		local item
		if nil == cell then
			cell = cc.TableViewCell:new()
			item = qy.tank.view.operatingActivities.achieve_share.AchieveShareCell.new({
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


return AchieveShareDialog
