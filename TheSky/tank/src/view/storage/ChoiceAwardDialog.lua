--[[
    奖励选择弹窗
    Author: FQ
    Date: 2016年10月13日12:30:16
]]

local ChoiceAwardDialog = qy.class("ChoiceAwardDialog", qy.tank.view.BaseDialog, "view/storage/ChoiceAwardDialog")

function ChoiceAwardDialog:ctor(entity, callback)
    ChoiceAwardDialog.super.ctor(self)

    self:InjectView("bg")
    self:InjectView("Btn_close")
    self:InjectView("Btn_sure")    

    self.award = entity.choice_award
    self.selected = 1

    self.list = self:__createList()
    
    self.bg:addChild(self.list)
    self.Btn_sure:setLocalZOrder(1)
    self.Btn_close:setLocalZOrder(1)

    self:OnClick(self.Btn_close, function(sender)
        self:dismiss()
    end,{["isScale"] = false})

    self:OnClick(self.Btn_sure, function(sender)
        callback(entity.id, 1, self.selected - 1)
        self:dismiss()
    end,{["isScale"] = false})

    self:InjectView("Image_4")
    self:InjectView("Image_5")
    self:InjectView("frame")
    self.frame:setLocalZOrder(2)
    self.Image_4:setLocalZOrder(1)
    self.Image_5:setLocalZOrder(1)
    self.Image_4:setSwallowTouches(true)
    self.Image_5:setSwallowTouches(true)

end



function ChoiceAwardDialog:__createList()
    local tableView = cc.TableView:create(cc.size(600, 230))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(10, 85)
    tableView:setDelegate()

    local function numberOfCellsInTableView(tableView)
        return self:getAwardLineSize()
    end

    local function cellSizeForTable(tableView,idx)
        return 600, 150
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil

        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.storage.ChoiceAwardCell.new(self)
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
function ChoiceAwardDialog:getAwardByLine(line_num)
    local line_award = {}
    for i = 4 * (line_num - 1) + 1, 4 * line_num  do
        if self.award[i] ~= nil then
            table.insert(line_award, self.award[i])
        end
    end

    return line_award
end

function ChoiceAwardDialog:getAwardLineSize()
    return math.floor(#self.award / 4)
end


function ChoiceAwardDialog:update(idx)
    self.selected = idx
    local point = self.tableViewList:getContentOffset()
    self.list:reloadData()
    self.tableViewList:setContentOffset(point)
end

return ChoiceAwardDialog
