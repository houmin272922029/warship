local MainView = qy.class("MainView", qy.tank.view.BaseDialog, "grouppurchase.ui.MainView")

local model = qy.tank.model.OperatingActivitiesModel

function MainView:ctor(delegate)
   	MainView.super.ctor(self)

    self:InjectView("Text_1")
    self:InjectView("Panel_1")
    self:InjectView("Panel_2")
    self:InjectView("Button_1")
	
    self:OnClick("Panel_2", function()
        self:removeSelf()
    end,{["isScale"] = false})

    self:OnClick("Button_1", function()
        qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.RECHARGE)
    end,{["isScale"] = false})

    self.Panel_1:addChild(self:createView())
end

function MainView:createView()
	
	local tableView = cc.TableView:create(cc.size(505, 448))
	tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	tableView:setPosition(0, 2)

	local data = model.goodlist

	local function numberOfCellsInTableView(tableView)
        return table.nums(data)
    end

    local function cellSizeForTable(tableView,idx)
        return 502, 155
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("grouppurchase.src.ItemView").new(self)
            cell:addChild(item)
            cell.item = item
        end

        cell.item.idx = idx
        cell.item:setData(data[(idx + 1)..""],(idx + 1))
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    
    tableView:reloadData()
    self.tableView = tableView
    return tableView
end

function MainView:refreshTableView()
	self.tableView:reloadData()
end


function MainView:onEnter()
    self.Text_1:setString(qy.tank.utils.DateFormatUtil:toDateString(model.grouppurchaseEndTime - qy.tank.model.UserInfoModel.serverTime, 7))
    self.listener_1 = qy.Event.add(qy.Event.BONUS_TIME,function(event)
        self.Text_1:setString(qy.tank.utils.DateFormatUtil:toDateString(model.grouppurchaseEndTime - qy.tank.model.UserInfoModel.serverTime, 7))
    end)
    self.listener_2 = qy.Event.add(qy.Event.GROUP_PURCHASE,function(event)
        self:refreshTableView()
    end)
end

function MainView:onExit()
    qy.Event.remove(self.listener_1)
    qy.Event.remove(self.listener_2)
end

return MainView