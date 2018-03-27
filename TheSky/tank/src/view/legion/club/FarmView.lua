--[[
	军团农场
	Author: H.X.Sun
]]

local FarmView = qy.class("FarmView", qy.tank.view.BaseView, "legion/ui/club/FarmView")

local CELL_HEIGHT = 40

function FarmView:ctor(delegate)
    FarmView.super.ctor(self)
    local head = qy.tank.view.legion.HeadCell.new({
        ["onExit"] = function()
            delegate.dismiss(false)
        end,
        ["showLine"] = false,
        ["titleUrl"] = "legion/res/jtjlb_08.png",
    })
    self:addChild(head,10)
    self:InjectView("num")
    self:InjectView("msg_node")
    self:InjectView("bg")
    self.delegate = delegate
    self.model = qy.tank.model.LegionModel
end

function FarmView:createList()
    local tableView = cc.TableView:create(cc.size(635,284))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setDelegate()

    local function numberOfCellsInTableView(table)
        return self.model:getFarmMsgNum()
    end

    local function tableCellTouched(table,cell)
    end

    local function cellSizeForTable(tableView, idx)
        return 635,CELL_HEIGHT
    end

    local function tableCellAtIndex(table, idx)
        local cell = table:dequeueCell()
        local item
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.legion.club.FarmMsgCell.new()
            cell:addChild(item)
            cell.item = item
        end
        cell.item:update(self.model:getFarmMsgByIdx(idx + 1))

        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:reloadData()
    return tableView
end

function FarmView:update()
    for i = 1, 3 do
        if not tolua.cast(self["getCell" .. i],"cc.Node") then
            self["getCell" .. i] = qy.tank.view.legion.club.FarmGetCell.new({
                ["update"] = function()
                    self:update()
                end
            })
            self.bg:addChild(self["getCell" .. i])
            self["getCell" .. i]:setPosition(-327 + 325 * i, 1)
        end
        self["getCell" .. i]:update(i)
    end
    self.num:setString(qy.TextUtil:substitute(51021, self.model:getRemainNum(), self.model.FARM_MAX_NUM))
    if not tolua.cast(self.list,"cc.Node") then
        self.list = self:createList()
        self.list:setPosition(10,1)
        self.msg_node:addChild(self.list)
    end
    self:updateList()
end

function FarmView:updateList()
    self.list:reloadData()
    self.list:setTouchEnabled(false)
    -- local dis_num = self.model:getFarmMsgNum() - 7
    -- if dis_num > 0 then
    --     local listCurY = self.list:getContentOffset().y + CELL_HEIGHT * dis_num
    --     self.list:setContentOffset(cc.p(0,listCurY))
    -- end
end

function FarmView:onEnter()
    self:update()
end

return FarmView
