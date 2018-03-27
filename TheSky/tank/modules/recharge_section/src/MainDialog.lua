local MainDialog = qy.class("MainDialog", qy.tank.view.BaseDialog, "recharge_section.ui.MainDialog")

local model = qy.tank.model.OperatingActivitiesModel
function MainDialog:ctor(delegate)
   	MainDialog.super.ctor(self)
    self:InjectView("list")
    self:InjectView("time")
    self:InjectView("cur_pay_num")
    self:InjectView("next_pay_num")
   	self:OnClick("closeBt", function()
        self:removeSelf()
    end,{["isScale"] = false})

    self.list:addChild(self:createView())

    self:setTime()
end

function MainDialog:createView()
    local tableView = cc.TableView:create(cc.size(710, 380))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(0, 0)

    local function numberOfCellsInTableView(tableView)
        return #model.rechargesetionList
    end

    local function cellSizeForTable(tableView,idx)
        return 710, 170
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        local label = nil
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("recharge_section.src.Cell").new(self)
            cell:addChild(item)
            cell.item = item
        end

        cell.item:setData(model.rechargesetionList[idx + 1], idx + 1)
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    
    tableView:reloadData()
    self.list = tableView

    return tableView
end
function MainDialog:update(  )
    local listCury = self.list:getContentOffset()
    self.list:reloadData()
    self.list:setContentOffset(listCury)--设置滚动距离
end

function MainDialog:setTime()
    local _lessCash = model:getRechargeSectionLessCash()
    if _lessCash > 0 then
        self.next_pay_num:setString(_lessCash .. qy.TextUtil:substitute(63015))
    else
        self:InjectView("next_pay_num_1")
        self:InjectView("next_pay_num_2")
        self.next_pay_num_1:setString(qy.TextUtil:substitute(63018))
        self.next_pay_num:setVisible(false)
        self.next_pay_num_2:setVisible(false)
    end
    self.cur_pay_num:setString(model.rechargecash.."元")
    self.time:setString(os.date("%Y-%m-%d", model.recahrgesecyionBeginTime) .." 至 " .. os.date("%Y-%m-%d", model.recahrgesecyionEndTime))
end

return MainDialog
