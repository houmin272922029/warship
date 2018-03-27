--[[
	最强之战-查看用户战报
	Author: H.X.Sun
]]

local UserCombatDialog = qy.class("UserCombatDialog", qy.tank.view.BaseDialog, "greatest_race/ui/UserCombatDialog")

function UserCombatDialog:ctor(delegate)
    UserCombatDialog.super.ctor(self)
    self:setCanceledOnTouchOutside(true)

    self:InjectView("bg")
    self:InjectView("btn")
    self:InjectView("name")
    self:InjectView("server")
    -- self.btn:setScale(1.3)
    self.model = qy.tank.model.GreatestRaceModel

    local list = self:__createList()
    self.bg:addChild(list)
    list:setPosition(20,100)

    self:OnClick("btn", function()
        -- print("ooxxooxxooxx")
        self:dismiss()
    end)
    local data = self.model:getLogUserInfo()
    self.name:setString(data.name)
    self.server:setString(data.server_name)
end

function UserCombatDialog:__createList()
    local tableView = cc.TableView:create(cc.size(448, 270))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setDelegate()

    local function numberOfCellsInTableView(table)
        return self.model:getLogNum()
    end

    local function tableCellTouched(table,cell)

    end

    local function cellSizeForTable(tableView, idx)
        return 448, 45
    end

    local function tableCellAtIndex(table, idx)
        local cell = table:dequeueCell()
        local item = nil
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.greatest_race.UserCombatCell.new()
            cell:addChild(item)
            cell.item = item
        end
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

return UserCombatDialog
