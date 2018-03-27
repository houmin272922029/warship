--[[
	猴年
	Author: H.X.Sun
]]

local SpringGDialog = qy.class("SpringGDialog", qy.tank.view.BaseDialog, "spring_gift/ui/SpringGDialog")

function SpringGDialog:ctor(delegate)
    SpringGDialog.super.ctor(self)
    self.model = qy.tank.model.OperatingActivitiesModel
    local service = qy.tank.service.OperatingActivitiesService

    self:InjectView("bg")

    self:OnClick("close_btn", function(sender)
        self:dismiss()
    end)
end

function SpringGDialog:__createList()
	local tableView = cc.TableView:create(cc.size(500, 498))
	tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	tableView:setDelegate()

	local function numberOfCellsInTableView(table)
		return self.model:getSpriGiftNum()
	end

	local function tableCellTouched(table,cell)
	end

	local function cellSizeForTable(tableView, idx)
		return 485, 148
	end

	local function tableCellAtIndex(table, idx)
		local cell = table:dequeueCell()
		local item
		if nil == cell then
			cell = cc.TableViewCell:new()
			item = qy.tank.view.operatingActivities.spring_gift.GiftCell.new()
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

function SpringGDialog:onEnter()
    if not tolua.cast(self.list,"cc.Node") then
        self.list = self:__createList()
        self.list:setPosition(440,28)
        self.bg:addChild(self.list)
    end
end

return SpringGDialog
