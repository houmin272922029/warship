--[[--
--推送列表Dialog
--Author: H.X.Sun
--Date: 2015-06-17
--]]
local PushListDialog = qy.class("PushListDialog", qy.tank.view.BaseDialog, "view/setting/PushListDialog")

function PushListDialog:ctor(delegate)
    PushListDialog.super.ctor(self)
    self:setCanceledOnTouchOutside(true)

	local style = qy.tank.view.style.DialogStyle5.new({
		size = cc.size(468,320),
		position = cc.p(0,0),
		offset = cc.p(0,0),

		-- ["onClose"] = function()
		-- 	self:dismiss()
		-- end
	})
	self:addChild(style , -1)
	self:InjectView("list")

	self.pushList = self:__createList()
	self.list:addChild(self.pushList)
end

function PushListDialog:__createList()
	local tableView = cc.TableView:create(cc.size(450,222))
	tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	tableView:setPosition(0,0)
	tableView:setDelegate()

	local function numberOfCellsInTableView(table)
		return 6
	end

	local function tableCellTouched(table,cell)
	end

	local function cellSizeForTable(tableView, idx)
		return 435, 68
	end

	local function tableCellAtIndex(table, idx)
		-- local cell = table:dequeueCell()
		-- local item
		-- if nil == cell then
		-- 	cell = cc.TableViewCell:new()
		-- 	item = qy.tank.view.setting.PushCell.new()
		-- 	cell:addChild(item)
		-- 	cell.item = item
		-- end
		return cell
	end

	tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    	tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
	tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
	tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
	tableView:reloadData()
	return tableView
end

return PushListDialog
