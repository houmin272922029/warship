--[[
	群战-战斗-参与人员列表
	Author: H.X.Sun
]]

local BattleList = qy.class("BattleList", qy.tank.view.BaseView,"war_group/ui/BattleList")


function BattleList:ctor(params)
    BattleList.super.ctor(self)
    self:InjectView("title")
    self.model = qy.tank.model.WarGroupModel
    self._prefix = params._prefix
    self.title:setString(self.model[self._prefix.."_legion_name"])
end

function BattleList:createList()
    local tableView = cc.TableView:create(cc.size(283,522))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setDelegate()

    local function numberOfCellsInTableView(table)
        return self.model:getMemberNumByPrefix(self._prefix)
    end

    local function tableCellTouched(table,cell)
    end

    local function cellSizeForTable(tableView, idx)
        return 283, 45
    end

    local function tableCellAtIndex(table, idx)
        local cell = table:dequeueCell()
        local item
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.war_group.NameCell.new()
            cell:addChild(item)
            cell.item = item
        end
        cell.item:render(self.model:getMemberDataByIdx(self._prefix,idx + 1) ,idx + 1)

        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:reloadData()
    return tableView
end

function BattleList:update()
    if tolua.cast(self.list,"cc.Node") then
        self.list:reloadData()
    end
end

function BattleList:onEnter()
    if not tolua.cast(self.list,"cc.Node") then
        self.list = self:createList()
        self:addChild(self.list)
        self.list:setPosition(0,12)
    end
end

return BattleList
