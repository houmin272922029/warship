local MainView = qy.class("MainView", qy.tank.view.BaseDialog, "allrecharge.ui.MainView")

local model = qy.tank.model.OperatingActivitiesModel
function MainView:ctor(delegate)
   	MainView.super.ctor(self)
    self:InjectView("BG")
    self:InjectView("ContentLayer")
    self:InjectView("Text_1")
    self:InjectView("Text_2")
    self:InjectView("Text_4")
    self:InjectView("Button_1")
    self:InjectView("Button_2")
    self:InjectView("Button_3")
    self.Button_2:setEnabled(true)
	self.Button_1:setEnabled(false)
	self.selectType = 1

    self.Text_2:setString(qy.TextUtil:substitute(90002, model.nums))

    self:OnClick("Button_1", function()
        if self.selectType == 1 then
        	return
        else
        	self.selectType = 1
        	self.Button_2:setEnabled(true)
			self.Button_1:setEnabled(false)
			self:refreshTableView()
        end
    end)

    self:OnClick("Button_2", function()
        if self.selectType == 2 then
        	return
        else
        	self.selectType = 2
        	self.Button_2:setEnabled(false)
			self.Button_1:setEnabled(true)
			self:refreshTableView()
        end
    end)

   	self:OnClick("Btn_close", function()
        self:removeSelf()
    end,{["isScale"] = false})

    self:OnClick("Button_3", function()
        self:removeSelf()
        qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.RECHARGE)
    end,{["isScale"] = false})

    self.BG:setPositionX(display.width / 2 + 80)
    self.ContentLayer:addChild(self:createView())
end

function MainView:createView()
	
	local tableView = cc.TableView:create(cc.size(555, 465))
	tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	tableView:setPosition(0, 0)

	local data = model.allRechargeList

	local function numberOfCellsInTableView(tableView)
        return #data
    end

    local function cellSizeForTable(tableView,idx)
        return 555, 148
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("allrecharge.src.ItemView").new(self)
            cell:addChild(item)
            cell.item = item
        end

        cell.item.idx = idx
        cell.item:setData(data[idx + 1], self.selectType == 2 and "recharge_award" or "all_award")
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
function refreshRechargeNums()
	self.Text_2:setString(model.nums)
end
function MainView:onEnter()
    self.Text_1:setString(qy.tank.utils.DateFormatUtil:toDateString(model.AllRechargeEndTime - qy.tank.model.UserInfoModel.serverTime, 7))
    self.listener_1 = qy.Event.add(qy.Event.BONUS_TIME,function(event)
        self.Text_1:setString(qy.tank.utils.DateFormatUtil:toDateString(model.AllRechargeEndTime - qy.tank.model.UserInfoModel.serverTime, 7))
    end)
end

function MainView:onExit()
    qy.Event.remove(self.listener_1)
end

return MainView