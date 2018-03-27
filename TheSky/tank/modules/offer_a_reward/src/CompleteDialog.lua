
local CompleteDialog = qy.class("CompleteDialog", qy.tank.view.BaseDialog, "offer_a_reward.ui.CompleteDialog")

local model = qy.tank.model.OfferARewardModel
function CompleteDialog:ctor(data)
    CompleteDialog.super.ctor(self)

    self:InjectView("BG")
    self:InjectView("Btn_confirm")
    self:InjectView("Btn_close")
 
    self:OnClick(self.Btn_confirm, function()
	    self:removeSelf()
    end,{["isScale"] = false})


    self:OnClick(self.Btn_close, function()
	    self:removeSelf()
    end,{["isScale"] = false})

    self.BG:addChild(self:__createList())
end



function CompleteDialog:__createList()
    local tableView = cc.TableView:create(cc.size(550, 370))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(8, 80)
    tableView:setDelegate()

    local function numberOfCellsInTableView(tableView)
        return #model:getFinish()
    end

    local function cellSizeForTable(tableView,idx)
        return 600, 120
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        local label = nil

        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("offer_a_reward.src.Cell3").new(self)
            cell:addChild(item)
            cell.item = item
        end

        cell.item:render(model:getFinish()[idx+1])

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

    self.tankViewList = tableView

    return tableView
end




return CompleteDialog
