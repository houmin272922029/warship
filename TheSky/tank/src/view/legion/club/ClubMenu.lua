--[[
	军团俱乐部菜单
	Author: H.X.Sun
]]

local ClubMenu = qy.class("ClubMenu", qy.tank.view.BaseView, "legion/ui/club/ClubMenu")

local service = qy.tank.service.LegionService

function ClubMenu:ctor(delegate)
    ClubMenu.super.ctor(self)
    local head = qy.tank.view.legion.HeadCell.new({
        ["onExit"] = function()
            delegate.dismiss(false)
        end,
        ["showLine"] = false,
        ["titleUrl"] = "legion/res/jtjlb_08.png",
    })
    self:addChild(head,10)

    self.delegate = delegate
    self.model = qy.tank.model.LegionModel
    self:InjectView("container")
    self:InjectView("level")
    self:InjectView("bar")
    self:InjectView("bar_num")

    self:OnClick("hall_btn",function()
        delegate.hallLogic()
    end)

    self:OnClick("club_btn",function()
        delegate.clubLogic()
    end)

end

function ClubMenu:createList()
    local tableView = cc.TableView:create(cc.size(930,467))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setDelegate()

    local function numberOfCellsInTableView(table)
        return self.model:getClubNum()
    end

    local function tableCellTouched(table,cell)
        qy.QYPlaySound.playEffect(qy.SoundType.COMMON_CLICK)
        local data = self.model:getClubDataByIdx(cell:getIdx() + 1)
        if data.open_level <= self.model:getHisLegion().level then
            self.delegate.showClub(data.e_name)
        else
            qy.hint:show(qy.TextUtil:substitute(51003, data.open_level, data.introduce))
        end
    end

    local function cellSizeForTable(tableView, idx)
        return 834, 150
    end

    local function tableCellAtIndex(table, idx)
        local cell = table:dequeueCell()
        local item
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.legion.club.MenuCell.new()
            cell:addChild(item)
            cell.item = item
        end
        cell.item:render(self.model:getClubDataByIdx(idx + 1))

        return cell
    end

    local function tableCellHighLight(table,cell)
        cell.item:hightLight()
    end

    local function tableCellUnhighLight(table,cell)
        cell.item:unhightLight()
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:registerScriptHandler(tableCellHighLight, cc.TABLECELL_HIGH_LIGHT)
    tableView:registerScriptHandler(tableCellUnhighLight, cc.TABLECELL_UNHIGH_LIGHT)
    tableView:reloadData()
    return tableView
end

function ClubMenu:onEnter()
    if not tolua.cast(self.list,"cc.Node") then
        self.list = self:createList()
        self.container:addChild(self.list)
        self.list:setPosition(-423, -263)
    end

    local entity = self.model:getHisLegion()
    self.level:setString("Lv."..entity.level)
    self.bar:setPercent(entity:getExpPerNum())
    self.bar_num:setString(entity:getExpPerDesc())
end

return ClubMenu
