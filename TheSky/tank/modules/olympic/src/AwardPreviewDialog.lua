--
-- Author: Your Name
-- Date: 2016-09-26 11:39:57
--


local AwardPreviewDialog = qy.class("AwardPreviewDialog", qy.tank.view.BaseDialog, "olympic.ui.AwardPreviewDialog")

function AwardPreviewDialog:ctor()
    AwardPreviewDialog.super.ctor(self)
	self:setCanceledOnTouchOutside(true)
	self.model = qy.tank.model.OlympicModel

     -- 通用弹窗样式
    local style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(690,560),
        position = cc.p(0,0),
        offset = cc.p(0,0),
        titleUrl = "olympic/res/20.png",
        ["onClose"] = function()
            self:dismiss()
        end
    })
    self:addChild(style, -1)

    self:InjectView("panel")

    local tableView = cc.TableView:create(cc.size(620, 480))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(-210, -150)
    self.panel:addChild(tableView)

    local function numberOfCellsInTableView(tableView)
        return #self.model:getRankAwardList()
    end

    local function cellSizeForTable(tableView, idx)
        return 620, 215
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        local label = nil
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("olympic.src.AwardPreviewCell").new()
            cell:addChild(item)
            cell.item = item
        end
        cell.item:render(self.model.rankAwardList[idx+1])
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)

    tableView:reloadData()
end

function AwardPreviewDialog:onEnter()

end

return AwardPreviewDialog
