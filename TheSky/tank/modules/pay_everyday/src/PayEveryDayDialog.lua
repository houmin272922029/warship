--[[--
--每日充值
--Author: Fu.Qiang
--Date: 2016-07-04
--]]--


local PayEveryDayDialog = qy.class("PayEveryDayDialog", qy.tank.view.BaseDialog, "pay_everyday/ui/Dialog")


local userinfoModel = qy.tank.model.UserInfoModel
local NumberUtil = qy.tank.utils.NumberUtil

function PayEveryDayDialog:ctor(delegate)
    PayEveryDayDialog.super.ctor(self)
    self.model = qy.tank.model.PayEveryDayModel
    self.service = qy.tank.service.PayEveryDayService

	self:InjectView("Bg")
	self:InjectView("Btn_close")
	self:InjectView("Btn_get")
    self:InjectView("Text_s_time")
    self:InjectView("Text_e_time")
	self:OnClick(self.Btn_close, function(sender)
        self:removeSelf()
    end,{["isScale"] = false})

    self.Btn_get:setSwallowTouches(true)
    self.Btn_close:setSwallowTouches(true)

    self:OnClick(self.Btn_get, function(sender)

    end,{["isScale"] = false})
    

    self.list = self:__createList()
    self.Bg:addChild(self.list)


    self:OnClick(self.Btn_get, function(sender)
        self.service:getAward(function(data)
                qy.tank.command.AwardCommand:add(data.award)
                qy.tank.command.AwardCommand:show(data.award,{["isShowHint"]=false})
                self.list:reloadData()
            end, 200)
    end,{["isScale"] = false})



    self.Text_e_time:setString(os.date("%Y-%m-%d %H:%M:%S",self.model:getEndTime()))
    self.Text_s_time:setString(os.date("%Y-%m-%d %H:%M:%S",self.model:getStartTime()))
end



function PayEveryDayDialog:__createList()
    local tableView = cc.TableView:create(cc.size(750, 400))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(34,89)
    tableView:setDelegate()

    local function numberOfCellsInTableView(table)
        return #self.model:getChestList()
    end

    local function tableCellTouched(table,cell)
    end

    local function cellSizeForTable(tableView, idx)
        return 770, 185
    end

    local function tableCellAtIndex(table, idx)
        local cell = table:dequeueCell()
        local item
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("pay_everyday.src.PayEveryDayCell").new(self, function()
                    self:removeSelf()
                end)

            cell:addChild(item)
            cell.item = item
        end
        cell.item:render(self.model:getChestList()[idx + 1])
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:reloadData()
    return tableView
end

return PayEveryDayDialog