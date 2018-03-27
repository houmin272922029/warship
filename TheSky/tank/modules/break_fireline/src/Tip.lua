--[[
--装备tip
--Author: lijian
--Date: 2015-07-18
]]

local Tip = qy.class("Tip",  qy.tank.view.BaseDialog, "break_fireline/ui/Tip")

local model = qy.tank.model.BreakFireModel

function Tip:ctor(delegate)
    Tip.super.ctor(self)
    -- self:setCanceledOnTouchOutside(true)
    self:InjectView("okimg")
    self:InjectView("closeBt")
    self:InjectView("titleimg")
    self:InjectView("title")
    self:InjectView("okBt")
    self:InjectView("Image_3")
    self:InjectView("title1")
  	self.types  = delegate.types
    self.num = delegate.num
    self:OnClick("okBt", function(sender)
        if self.selected == 0 then
            qy.hint:show("请选择要领取的奖励")
            return
        end
        if self.selected ~= 0 then
            delegate.callback(self.selected)
        end
        self:removeSelf()
    end)
    self:OnClick("closeBt", function(sender)
        self:removeSelf()
    end)
    self.selected = 0
    self.data = {}
    self.Image_3:addChild(self:__createList())
end
function Tip:__createList()
    if model.settup ~= 30 then
        self.okBt:setVisible(false)
        self.titleimg:setVisible(false)
        self.title:setVisible(true)
        if self.types == 2 then
            self.title1:setString("随机获得以下任意一种奖励")
        else
            self.title1:setString("自由选择以下一种奖励")
        end
    else
        self.title:setVisible(self.types == 2)
        self.titleimg:setVisible(self.types == 3)
        self.okBt:setVisible(self.types == 3)
    end
    if self.types == 2 then
        self.data = model:getlist(self.num)
    else
        self.data = model.crossfire_final
    end
    local nums = #self.data
    local tableView = cc.TableView:create(cc.size(550, 190))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(0, 5)
    tableView:setDelegate()

    local function numberOfCellsInTableView(tableView)
        return math.ceil(nums/5)
    end

    local function cellSizeForTable(tableView,idx)
        return 550, 95
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil

        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("break_fireline.src.PropCellList").new(self)
            cell:addChild(item)
            cell.item = item
        end

        cell.item:render(self:getAwardByLine(idx+1), idx+1)

        return cell
    end

    local function tableAtTouched(table, cell)

    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:registerScriptHandler(tableAtTouched,cc.TABLECELL_TOUCHED)

    tableView:reloadData()

    self.tableViewList = tableView

    return tableView
end
function Tip:update(idx)
    self.selected = idx
    local point = self.tableViewList:getContentOffset()
    self.tableViewList:reloadData()
    self.tableViewList:setContentOffset(point)
end

--line_num 从1开始 
function Tip:getAwardByLine(line_num)
    local line_award = {}
    for i = 5 * (line_num - 1) + 1, 5 * line_num  do
        if self.data[i] ~= nil then
            table.insert(line_award, self.data[i].award[1])
        end
    end

    return line_award
end

return Tip
