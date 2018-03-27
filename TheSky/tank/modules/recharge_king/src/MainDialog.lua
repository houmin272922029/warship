local MainDialog = qy.class("MainDialog", qy.tank.view.BaseDialog, "recharge_king.ui.Maindialog")

local model = qy.tank.model.OperatingActivitiesModel
function MainDialog:ctor(delegate)
   	MainDialog.super.ctor(self)
    self:InjectView("BG")
    -- self:InjectView("Name")
    -- self:InjectView("Attack")
    -- self:InjectView("Level")
    self:InjectView("Time1")
    self:InjectView("Time2")

   	self:OnClick("Btn_close", function()
        self:removeSelf()
    end,{["isScale"] = false})

    self:OnClick("Btn_help", function()
        qy.tank.view.common.HelpDialog.new(qy.tank.model.HelpTxtModel:getHelpDataByIndx(36)):show(true)
    end,{["isScale"] = false})

    self.BG:addChild(self:createView())

    -- self:setAward()
    self:setTime()
end

function MainDialog:createView()
    local tableView = cc.TableView:create(cc.size(820, 415))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    -- tableView:setSwallowTouches(false)
    tableView:setPosition(30, 15)

    local function numberOfCellsInTableView(tableView)
        return #model.rechargeKingList
    end

    local function cellSizeForTable(tableView,idx)
        return 820, 160
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        local label = nil
        -- local data = model:getList(idx)
        -- local height = model:getHeight(idx)
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("recharge_king.src.ItemView").new(self)
            cell:addChild(item)
            cell.item = item
        end

        cell.item:setData(model.rechargeKingList[idx + 1], idx)
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    
    tableView:reloadData()

    return tableView
end

function MainDialog:setTime()
    self.Time1:setString(os.date("%Y.%m.%d %H:%M:%S", model.recahrgeKingBeginTime) .."   至   " .. os.date("%Y.%m.%d %H:%M:%S", model.rechargeKingEndTime))
    self.Time2:setString(os.date("%Y.%m.%d %H:%M:%S", model.rechargeKingAwardBeginTime) .."   至   " .. os.date("%Y.%m.%d %H:%M:%S", model.rechargeKingAwardEndTime))
end

return MainDialog
