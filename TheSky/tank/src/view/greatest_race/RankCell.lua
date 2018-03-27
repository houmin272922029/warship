--[[
	最强之战-最强统帅
	Author: H.X.Sun
]]

local RankCell = qy.class("RankCell", qy.tank.view.BaseView, "greatest_race/ui/RankCell")

function RankCell:ctor(delegate)
    RankCell.super.ctor(self)

    self.model = qy.tank.model.GreatestRaceModel
    self:InjectView("name_bg")
    local list = self:__createList()
    self.name_bg:addChild(list)
    list:setPosition(0,3)
end

function RankCell:__createList()
	local tableView = cc.TableView:create(cc.size(430, 420))
	tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	tableView:setDelegate()

	local function numberOfCellsInTableView(table)
		return self.model:getRankNum()
	end

	local function tableCellTouched(table,cell)
	end

	local function cellSizeForTable(tableView, idx)
		return 430, 45
	end

	local function tableCellAtIndex(table, idx)
		local cell = table:dequeueCell()
		local item
		if nil == cell then
			cell = cc.TableViewCell:new()
			item = qy.tank.view.greatest_race.RankName.new()
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

return RankCell
