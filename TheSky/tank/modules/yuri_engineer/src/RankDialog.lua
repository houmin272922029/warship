--[[
]]
local RankDialog = qy.class("RankDialog", qy.tank.view.BaseDialog, "yuri_engineer.ui.RankDialog")


function RankDialog:ctor(delegate)
    RankDialog.super.ctor(self)

    self.model = qy.tank.model.YuriEngineerModel
    self.service = qy.tank.service.YuriEngineerService


    self:InjectView("bg")
    self:InjectView("Btn_close")
    self:InjectView("Text_num")


    self:OnClick("Btn_close", function(sender)
        self:removeSelf()
    end)

    self:OnClick("Btn_preview", function()
        require("yuri_engineer.src.RewardPreviewDialog").new():show()
    end)


    self.bg:addChild(self:createTable(), 1)
    if self.model.my_rank > -1 then
        self.Text_num:setString(self.model.my_rank)
    else
        self.Text_num:setString("未上榜")
    end
end





function RankDialog:createTable()
    local tableView = cc.TableView:create(cc.size(520, 360))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    -- tableView:setSwallowTouches(false)
    tableView:setPosition(10, 10)
    tableView:setDelegate()

    local function numberOfCellsInTableView(tableView)
        return #self.model.rank_list
    end

    local function cellSizeForTable(tableView,idx)
        return 500, 89
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        local label = nil

        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("yuri_engineer.src.RankCell").new(self)
            cell:addChild(item)
            cell.item = item
        end
        cell.item:render(self.model.rank_list[idx+1], idx + 1)
           

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



return RankDialog
