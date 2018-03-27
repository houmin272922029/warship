--[[--
--将士之战宝箱信息dialog
--Author: Fu.Qiang
--Date: 2016-07-04
--]]--


local ChestDetailsDialog = qy.class("ChestDetailsDialog", qy.tank.view.BaseDialog, "soldiers_war.ui.ChestDetailsDialog")

local model = qy.tank.model.SoldiersWarModel
function ChestDetailsDialog:ctor(delegate)
    ChestDetailsDialog.super.ctor(self)

	self:InjectView("Panel")
	self:InjectView("Title")
	self:InjectView("Close")
    self:InjectView("bg")
	self:OnClick(self.Close, function(sender)
        self:removeSelf()
    end,{["isScale"] = false})

    self.data = {}

    if (tonumber(model.max_id) < tonumber(delegate.checkpoint_id)) and model.max_id < model.checkpoint_size then
        for i=1,#delegate.first_award do
            self.first = true
            table.insert(self.data, delegate.first_award[i])
        end
        self.nums = #delegate.first_award
    end

    for i, v in pairs(delegate.award) do 
        table.insert(self.data, delegate.award[i])
    end

    self.list = self:__createList()
    self.bg:addChild(self.list, 1)

    self.Title:setString(delegate.checkpoint_id)

end



function ChestDetailsDialog:__createList()
    local tableView = cc.TableView:create(cc.size(390, 330))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(11,18)
    tableView:setDelegate()

    local function numberOfCellsInTableView(table)
        return #self.data
    end

    local function tableCellTouched(table,cell)
    end

    local function cellSizeForTable(tableView, idx)
        return 420, 100
    end

    local function tableCellAtIndex(table, idx)
        local cell = table:dequeueCell()
        local item
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("soldiers_war.src.ChestDetailsCell").new(self)
            cell:addChild(item)
            cell.item = item
        end

        if self.first and idx < self.nums then
            cell.item:render(self.data[idx + 1], true)
        else
            cell.item:render(self.data[idx + 1], false)
        end
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:reloadData()
    return tableView
end


return ChestDetailsDialog