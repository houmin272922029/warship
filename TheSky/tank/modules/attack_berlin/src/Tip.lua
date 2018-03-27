--[[
--装备tip
--Author: lijian
--Date: 2015-07-18
]]

local Tip = qy.class("Tip",  qy.tank.view.BaseDialog, "attack_berlin/ui/Tip")

local model = qy.tank.model.AttackBerlinModel
local service = qy.tank.service.AttackBerlinService

function Tip:ctor(delegate)
    Tip.super.ctor(self)
    self:InjectView("okimg")
    self:InjectView("closeBt")
    self:InjectView("title")
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
    self.types = delegate.types
    self.ids = delegate.ids
    self.Image_3:addChild(self:__createList())
end
function Tip:__createList()
    if self.types == 1 then
        self.title1:setString("随机获得以下任意一种奖励")
    else
        self.title1:setString("成功击破后，军团将随机获得以下若干奖励")
    end
    if self.types == 1 then
        self.data = model:getPersonalAwardByid(self.ids)
    else
        self.data = model:getjipoAwardByid(self.ids)
    end
    local nums = #self.data
    -- print("===========oooooo",self.ids)
    -- print("=============",json.encode(self.data))
    local tableView = cc.TableView:create(cc.size(550, 200))
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
            item = require("attack_berlin.src.PropCellList").new(self)
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
