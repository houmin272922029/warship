--[[

]]
local RewardDialog = qy.class("RewardDialog", qy.tank.view.BaseDialog, "combat_casting.ui.RewardDialog")

function RewardDialog:ctor(delegate)
    RewardDialog.super.ctor(self)

    self.model = qy.tank.model.CombatCastingModel
    self.service = qy.tank.service.CombatCastingService

    self:InjectView("bg")

    self.style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(705,520),
        position = cc.p(0,0),
        offset = cc.p(0,0),
        titleUrl = "combat_casting/res/44.png",
        bgShow = false,

        ["onClose"] = function()
            self:removeSelf()
        end
    })
    self:addChild(self.style , 1)

    self.bg:addChild(self:__createList(), 1)
    
    self:update()
end




function RewardDialog:__createList()
    local tableView = cc.TableView:create(cc.size(687, 470))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(13, 5)
    tableView:setDelegate()

    local function numberOfCellsInTableView(tableView)
        return #self.model.achieve
    end

    local function cellSizeForTable(tableView,idx)
        return 655, 140
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        local label = nil

        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("combat_casting.src.RewardCell").new(self)
            cell:addChild(item)
            cell.item = item
        end

        cell.item:render(self.model.achieve[idx+1], idx+1)

        cell.item.idx = idx + 1
        return cell
    end

    local function tableAtTouched(table, cell)

    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:registerScriptHandler(tableAtTouched,cc.TABLECELL_TOUCHED)

    tableView:reloadData()
    self.tableView = tableView

    return tableView
end



function RewardDialog:update()
    local listCurY = self.tableView:getContentOffset().y
    self.tableView:reloadData()
    self.tableView:setContentOffset(cc.p(0,listCurY))
end



return RewardDialog
