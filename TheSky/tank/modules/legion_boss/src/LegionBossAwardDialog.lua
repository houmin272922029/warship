--
-- Author: Your Name
-- Date: 2015-12-10 14:44:21
--

local LegionBossAwardDialog = qy.class("LegionBossAwardDialog", qy.tank.view.BaseDialog, "legion_boss.ui.LegionBossAwardDialog")

function LegionBossAwardDialog:ctor()
    LegionBossAwardDialog.super.ctor(self)
	self:setCanceledOnTouchOutside(true)
	self.model = qy.tank.model.LegionBossModel
     -- 通用弹窗样式
    local style = qy.tank.view.style.DialogStyle5.new({
        size = cc.size(720,600),
        position = cc.p(0,0),
        offset = cc.p(0,0),
        -- ["onClose"] = function()
        --     self:dismiss()
        -- end
    })
    self:addChild(style, -1)

    self:InjectView("panel")

    local tableView1 = cc.TableView:create(cc.size(610, 210))
    tableView1:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView1:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView1:setPosition(-200,90)
    self.panel:addChild(tableView1)

    local function numberOfCellsInTableView(tableView)
        return #self.model.awardList
    end

    local function cellSizeForTable(tableView, idx)
        return 600, 45
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        local label = nil
        -- local data = model:getList(idx)
        -- local height = model:getHeight(idx)
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("legion_boss.src.LegionBossAwardCell").new()
            cell:addChild(item)
            cell.item = item
        end
        cell.item:render(self.model.awardList[idx+1],1)
        return cell
    end

    tableView1:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView1:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView1:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)

    tableView1:reloadData()

    local tableView2 = cc.TableView:create(cc.size(610, 220))
    tableView2:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView2:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView2:setPosition(-200, -170)
    self.panel:addChild(tableView2)

    local function numberOfCellsInTableView(tableView)
        return #self.model.awardList 
    end

    local function cellSizeForTable(tableView, idx)
        return 600, 45
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        local label = nil
        -- local data = model:getList(idx)
        -- local height = model:getHeight(idx)
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("legion_boss.src.LegionBossAwardCell").new()
            cell:addChild(item)
            cell.item = item
        end
        cell.item:render(self.model.awardList[idx+1],2)
        return cell
    end

    tableView2:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView2:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView2:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)

    tableView2:reloadData()
end

function LegionBossAwardDialog:onEnter()

end

return LegionBossAwardDialog
