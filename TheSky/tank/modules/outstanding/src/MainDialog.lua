local MainDialog = qy.class("MainDialog", qy.tank.view.BaseDialog, "outstanding.ui.MainDialog")

local model = qy.tank.model.OperatingActivitiesModel
local service = qy.tank.service.OperatingActivitiesService
function MainDialog:ctor(delegate)
   	MainDialog.super.ctor(self)
    self:InjectView("close")
    self:InjectView("tableviewBg")
    self:InjectView("Text_1")
    self:InjectView("Text_2")

   	self:OnClick("close", function()
        self:removeSelf()
    end,{["isScale"] = false})

    self.tableviewBg:addChild(self:createView())
end

function MainDialog:createView()
	
	local tableView = cc.TableView:create(cc.size(445, 360))
	tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	tableView:setPosition(3, 0)

	local data = model.outStandingList

	local function numberOfCellsInTableView(tableView)
        return #data
    end

    local function cellSizeForTable(tableView,idx)
        return 440, 150
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("outstanding.src.ItemCell").new(self)
            cell:addChild(item)
            cell.item = item
        end

        cell.item.idx = idx
        cell.item:setData(data[idx + 1], (idx + 1))
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    
    tableView:reloadData()
    self.tableView = tableView
    return tableView
end

function MainDialog:onEnter()
    local endTime = os.date("*t", model.outStandingData.end_time) 
    local awardEndTime = os.date("*t", model.outStandingData.award_end_time) 
    self.Text_1:setString(endTime.year.."年"..endTime.month.."月"..endTime.day.."日".. endTime.hour.. "时")
    self.Text_2:setString(awardEndTime.year.."年"..awardEndTime.month.."月"..awardEndTime.day.."日".. awardEndTime.hour.. "时")
    -- self.listener_1 = qy.Event.add(qy.Event.BONUS_TIME,function(event)
    --     self.Text_1:setString(qy.tank.utils.DateFormatUtil:toDateString(endTime- qy.tank.model.UserInfoModel.serverTime, 3))
    -- end)
    -- self.listener_2 = qy.Event.add(qy.Event.BONUS_TIME,function(event)
    --     self.Text_2:setString(qy.tank.utils.DateFormatUtil:toDateString(awardEndTime- qy.tank.model.UserInfoModel.serverTime, 3))
    -- end)
    -- if self.tableView then
    --     local listCurY = self.tableView:getContentOffset().y
    --     self.tableView:reloadData()
    --     self.tableView:setContentOffset(cc.p(0,listCurY))
    -- end
    self.listener_3 = qy.Event.add(qy.Event.SEARCH_TREASURE,function(event)
        self:removeSelf()
    end)
end

function MainDialog:onExit()
    -- qy.Event.remove(self.listener_1)
    -- qy.Event.remove(self.listener_2)
    qy.Event.remove(self.listener_3)
end

return MainDialog