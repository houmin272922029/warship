local MainDialog = qy.class("MainDialog", qy.tank.view.BaseDialog, "bonus.ui.MainDialog")

local model = qy.tank.model.OperatingActivitiesModel
function MainDialog:ctor(delegate)
   	MainDialog.super.ctor(self)
    self:InjectView("BG")
    self:InjectView("Name")
    self:InjectView("Attack")
    self:InjectView("Level")
    self:InjectView("Time1")
    self:InjectView("Time2")

   	self:OnClick("Btn_close", function()
        self:removeSelf()
    end,{["isScale"] = false})

    self.BG:addChild(self:createView())

    self:setAward()
end

function MainDialog:createView()
 local tableView = cc.TableView:create(cc.size(505, 385))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    -- tableView:setSwallowTouches(false)
    tableView:setPosition(355, 10)

    local data = model.bonusList

    local function numberOfCellsInTableView(tableView)
        return #data
    end

    local function cellSizeForTable(tableView,idx)
        return 505, 145
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        local label = nil
        -- local data = model:getList(idx)
        -- local height = model:getHeight(idx)
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("bonus.src.ItemView").new(self)
            cell:addChild(item)
            cell.item = item
        end

        cell.item:setData(data[idx + 1])
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    
    tableView:reloadData()

    return tableView
end

function MainDialog:setAward(data)
    local data = qy.Config.recharge_bonus["7"].award[1]

    local view = qy.tank.view.common.AwardItem.createAwardView(data ,1)
    local data1 = qy.tank.view.common.AwardItem.getItemData(data, 1)
    view:setPosition(178, 271)
    view.name:setVisible(false)
    self.BG:addChild(view)

    self.Name:setString(data1.name)
    self.Attack:setString(qy.TextUtil:substitute(43005) .. data1.entity:getPropertyInfo())
    self.Level:setString(qy.TextUtil:substitute(43006))
end

function MainDialog:onEnter()
    self.Time2:setString(qy.tank.utils.DateFormatUtil:toDateString(model.bonusEndTime - qy.tank.model.UserInfoModel.serverTime, 3))
    self.listener_1 = qy.Event.add(qy.Event.BONUS_TIME,function(event)
        -- self.Time1:setString(qy.tank.utils.DateFormatUtil:toDateString(model.bonusBeginTime, 3))
        self.Time2:setString(qy.tank.utils.DateFormatUtil:toDateString(model.bonusEndTime - qy.tank.model.UserInfoModel.serverTime, 3))
    end)
end

function MainDialog:onExit()
    qy.Event.remove(self.listener_1)
end

return MainDialog
