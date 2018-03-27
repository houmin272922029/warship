local CombatView = qy.class("CombatView", qy.tank.view.BaseView, "inter_service_arena.ui.CombatView")

function CombatView:ctor(delegate)
   	CombatView.super.ctor(self)

    self.model = qy.tank.model.InterServiceArenaModel
    self.service = qy.tank.service.InterServiceArenaService

    local style = qy.tank.view.style.ViewStyle1.new({
        titleUrl = "Resources/activity/title_inter_service_arena.png", 
        showHome = false,
        ["onExit"] = function()
            if delegate and delegate.dismiss then
                delegate.dismiss()
            end
        end
    })
    self:addChild(style)
    self.data = delegate.data
    self.page_num = 1

    self:InjectView("bg")

    self.bg:addChild(self:createTable())

end


function CombatView:createTable()
    local tableView = cc.TableView:create(cc.size(940, 440))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    -- tableView:setSwallowTouches(false)
    tableView:setPosition(5, 10)
    tableView:setDelegate()

    local function numberOfCellsInTableView(tableView)
        return #self.data.list
    end

    local function cellSizeForTable(tableView,idx)
        return 920, 150
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        local label = nil

        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("inter_service_arena.src.CombatCell").new(self)
            cell:addChild(item)
            cell.item = item
        end

        cell.item:render(self.data.list[idx+1], idx+1)

        cell.item.idx = idx + 1

        if idx+1 == #self.data.list and self.page_num < self.data.maxpage then
            self.page_num = self.page_num + 1
            self.service:battlelist(function(data)

                table.insertto(self.data.list, data.list)

                local y = self.tableView:getContentOffset().y
                y = y - #data.list * 150

                self.tableView:reloadData()
                self.tableView:setContentOffset(cc.p(0, y))

            end, 200, self.page_num)
        end

        return cell
    end

    local function tableAtTouched(table, cell)
        print(1)
    end


    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:registerScriptHandler(tableAtTouched,cc.TABLECELL_TOUCHED)

    tableView:reloadData()

    self.tableView = tableView

    return tableView
end

return CombatView
