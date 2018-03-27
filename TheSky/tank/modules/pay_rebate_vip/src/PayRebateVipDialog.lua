--[[--
--新版累充返利dialog
--Author: Fu.Qiang
--Date: 2016-07-04
--]]--


local PayRebateVipDialog = qy.class("PayRebateVipDialog", qy.tank.view.BaseDialog, "pay_rebate_vip/ui/payRebateVip")

function PayRebateVipDialog:ctor(delegate)
    PayRebateVipDialog.super.ctor(self)
    self.model = qy.tank.model.OperatingActivitiesModel

	self:InjectView("bg")
	self:InjectView("cur_pay_num")
	self:InjectView("next_pay_num")
    self:InjectView("closeBtn")
    self:InjectView("privilegeBtn")
    self:InjectView("remain_time")
	self:OnClick(self.closeBtn, function(sender)
        self:removeSelf()
    end,{["isScale"] = false})

    self.privilegeBtn:setSwallowTouches(true)
    self:OnClick(self.privilegeBtn, function(sender)
        qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.VIP)
    end,{["isScale"] = false})
    

    self.list = self:__createList()
    self.bg:addChild(self.list)

    self.cur_pay_num:setString(self.model:getRebateVipRechargeNum() .. qy.TextUtil:substitute(63015))
    local _lessCash = self.model:getRebateVipLessCash()
    if _lessCash > 0 then
    	self.next_pay_num:setString(_lessCash .. qy.TextUtil:substitute(63015))
    else
    	self:InjectView("next_pay_num_1")
        self:InjectView("next_pay_num_2")
        self.next_pay_num_1:setString(qy.TextUtil:substitute(63018))
        self.next_pay_num:setVisible(false)
        self.next_pay_num_2:setVisible(false)
    end
end



function PayRebateVipDialog:__createList()
    local tableView = cc.TableView:create(cc.size(720, 385))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(26,8)
    tableView:setDelegate()

    local function numberOfCellsInTableView(table)
        return self.model:getPayRebateVipAwardNum()
    end

    local function tableCellTouched(table,cell)
    end

    local function cellSizeForTable(tableView, idx)
        return 720, 177
    end

    local function tableCellAtIndex(table, idx)
        local cell = table:dequeueCell()
        local item
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("pay_rebate_vip.src.PayRebateVipCell").new({
                ["callBack"] = function ()
                    self:removeSelf()
                end
            })

            cell:addChild(item)
            cell.item = item
        end
        cell.item:render(idx + 1)
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:reloadData()
    return tableView
end


function PayRebateVipDialog:updateTime()
    if self.remain_time then
        self.remain_time:setString(self.model:getPayRebateVipRemainTime())
    end
end

function PayRebateVipDialog:onEnter()
    self:updateTime()
    self.timeListener = qy.Event.add(qy.Runtime.TIMER_UPDATE,function(event)
        self:updateTime()
    end)
end

function PayRebateVipDialog:onExit()
    qy.Event.remove(self.timeListener)
    self.timeListener = nil
end

return PayRebateVipDialog