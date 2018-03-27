local FactionMilitaryDialog = qy.class("FactionMilitaryDialog", qy.tank.view.BaseDialog, "service_faction_war/ui/FactionMilitaryDialog")

local model = qy.tank.model.ServerFactionModel
local service = qy.tank.service.ServerFactionService

function FactionMilitaryDialog:ctor(delegate)
	FactionMilitaryDialog.super.ctor(self)
    -- self.delegate = delegate

    self:InjectView("closeBt")--我的名次
    
   	self:OnClick("closeBt",function()
        self:dismiss()
    end)
  	self:InjectView("listbg")--排行榜

  	self.list1 = self:__createList()
  	self.listbg:addChild(self.list1)
 
end
function FactionMilitaryDialog:__createList()
	local tableView = cc.TableView:create(cc.size(475, 380))
	tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	tableView:setPosition(8,5)
	tableView:setDelegate()

	local function numberOfCellsInTableView(table)
		return #model.camp_war_level
	end

	local function tableCellTouched(table,cell)
	end

	local function cellSizeForTable(tableView, idx)
		return 475, 75
	end

	local function tableCellAtIndex(table, idx)
		local cell = table:dequeueCell()
		local item
		if nil == cell then
			cell = cc.TableViewCell:new()
			item =  require("service_faction_war.src.MillitaryCell").new()
			cell:addChild(item)
			cell.item = item
		end
		cell.item.idx = idx
		cell.item:render(idx+1)
		return cell
	end

	tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
	tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
	tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
	tableView:reloadData()
	return tableView
end
return FactionMilitaryDialog
