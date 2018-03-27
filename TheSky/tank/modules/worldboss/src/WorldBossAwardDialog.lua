--
-- Author: Your Name
-- Date: 2015-12-10 14:44:21
--

local WorldBossAwardDialog = qy.class("WorldBossAwardDialog", qy.tank.view.BaseDialog, "worldboss.ui.WorldBossAwardDialog")

function WorldBossAwardDialog:ctor()
    WorldBossAwardDialog.super.ctor(self)
	self:setCanceledOnTouchOutside(true)
	self.model = qy.tank.model.WorldBossModel
     -- 通用弹窗样式
    local style = qy.tank.view.style.DialogStyle5.new({
        size = cc.size(720,580),
        position = cc.p(0,0),
        offset = cc.p(0,0),
        -- ["onClose"] = function()
        --     self:dismiss()
        -- end
    })
    self:addChild(style, -1)

    self:InjectView("panel")

    local tableView = cc.TableView:create(cc.size(600, 450))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(-200, -145)
    self.panel:addChild(tableView)

    local function numberOfCellsInTableView(tableView)
        return #self.model.awardList
    end

    local function cellSizeForTable(tableView, idx)
        return 600, 50
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        local label = nil
        -- local data = model:getList(idx)
        -- local height = model:getHeight(idx)
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("worldboss.src.WorldBossAwardCell").new()
            cell:addChild(item)
            cell.item = item
        end
        cell.item:render(self.model.awardList[idx+1])
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)

    tableView:reloadData()
end

function WorldBossAwardDialog:onEnter()

end

return WorldBossAwardDialog
