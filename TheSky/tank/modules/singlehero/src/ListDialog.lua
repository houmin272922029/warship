--[[
    关卡列表
]]
local ListDialog = qy.class("ListDialog", qy.tank.view.BaseDialog, "singlehero.ui.ListDialog")

local model = qy.tank.model.SingleHeroModel
function ListDialog:ctor(delegate)
    ListDialog.super.ctor(self)

    self:InjectView("Btn_close") 
    self:InjectView("List")
    self:InjectView("Page")
    self:InjectView("Times")
    self:InjectView("Image_1")
    
    -- 通用弹窗样式
    
    self:OnClick("Btn_close", function()
        self:dismiss()
    end,{["isScale"] = false})

    self:OnClick("Btn_pre", function()
        local page = model.page - 1
        model:setPage(page)
        self:update()
    end)

    self:OnClick("Btn_pre2", function()
        local page = model.page - 10
        model:setPage(page)
        self:update()
    end)

    self:OnClick("Btn_next", function()
        local page = model.page + 1
        model:setPage(page)
        self:update()
    end)

    self:OnClick("Btn_next2", function()
        local page = model.page + 10
        model:setPage(page)
        self:update()
    end)

    self:OnClick("Btn_buy", function()
        delegate:showBuy()
    end,{["isScale"] = false})

    self:OnClick("Btn_help", function()
        qy.tank.view.common.HelpDialog.new(qy.tank.model.HelpTxtModel:getHelpDataByIndx(15)):show(true)
    end,{["isScale"] = false})

    self.List:addChild(self:createTableView())
    self:update()
    self.Image_1:setPositionX(display.width / 2)
end

function ListDialog:createTableView(idx)
    tableView = cc.TableView:create(cc.size(1005,440))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(0, 5)
    tableView:setDelegate()
    tableView:setTouchEnabled(false)
    
    local function numberOfCellsInTableView(table)
        return #model:getPageList()
    end

    local function cellSizeForTable(tableView, idx)
        return 1005, 149
    end

    local function tableCellAtIndex(table, idx)
        local strValue = string.format("%d",idx)
        local cell = table:dequeueCell()
        local item,label,status
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("singlehero.src.ItemView").new(self)
            cell:addChild(item)
            cell.item = item
        end
        
        cell.item:setData(model:getPageList()[idx + 1])
       
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:reloadData()
    self.tableView = tableView
    return tableView
end

function ListDialog:update()
    self.Page:setString(model.page .. "/" .. model:getMaxPage())
    self.tableView:reloadData()
    self.Times:setString(model.left_free_times + model.buy_times)
end

function ListDialog:onEnter()
    self.listener_1 = qy.Event.add(qy.Event.SINGLE_HERO,function(event)
        self:update()
    end)

    qy.Event.dispatch("SINGLE_HERO")
end

function ListDialog:onExit()
    qy.Event.remove(self.listener_1)
end

return ListDialog