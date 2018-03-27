

local LeaderboardDialog = qy.class("LeaderboardDialog", qy.tank.view.BaseDialog, "endless_war/ui/LeaderboardDialog")

local StorageModel = qy.tank.model.StorageModel

function LeaderboardDialog:ctor(delegate)
    LeaderboardDialog.super.ctor(self)
    self.model = qy.tank.model.EndlessWarModel
    
  	self.delegate = delegate
 
	self:InjectView("myrank")
	self:InjectView("mylevel")
	self:InjectView("list")
	self:InjectView("closeBt")
	self.list1 = self:__createList()
	self.list:addChild(self.list1,5)
	self:OnClick("closeBt", function(sender)
        self:dismiss()
    end,{["isScale"] = false})

    if self.model.myrank > 0 then
    	self.myrank:setString(self.model.myrank)
    else
    	self.myrank:setString("未上榜")
    end
    self.mylevel:setString("我的挑战关数："..self.model.checkpoint_id)

end

function LeaderboardDialog:__createList()
	local tableView = cc.TableView:create(cc.size(715, 420))
	tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	tableView:setPosition(-3,-10)
	tableView:setDelegate()

	local function numberOfCellsInTableView(table)
		return #self.model.ranklist
	end

	local function tableCellTouched(table,cell)
	end

	local function cellSizeForTable(tableView, idx)
		return 715, 130
	end

	local function tableCellAtIndex(table, idx)
		local cell = table:dequeueCell()
		local item
		if nil == cell then
			cell = cc.TableViewCell:new()
			item = require("endless_war.src.LeaderboardItem").new()
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


return LeaderboardDialog
