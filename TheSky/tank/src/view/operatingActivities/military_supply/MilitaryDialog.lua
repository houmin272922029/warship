--[[
	军资整备
	Author: H.X.Sun
]]
local MilitaryDialog = qy.class("MilitaryDialog", qy.tank.view.BaseDialog, "military_supply/ui/MilitaryDialog")

function MilitaryDialog:ctor(param)
   	MilitaryDialog.super.ctor(self)
    self:InjectView("container")
    self:InjectView("end_time")
    self:InjectView("task_dec")
    self.task_dec:setLocalZOrder(100)

    self.model = qy.tank.model.OperatingActivitiesModel

    self:OnClick("close_btn",function()
        self:dismiss()
    end)

    self:OnClick("shop_btn",function()
        qy.tank.view.operatingActivities.military_supply.ShopDialog.new():show(true)
    end)

    self.tab_host = qy.tank.widget.TabHost.new({
        delegate = self,
        csd = "widget/TabButton3",
        tabs = {qy.TextUtil:substitute(90104),qy.TextUtil:substitute(90111),qy.TextUtil:substitute(90112),qy.TextUtil:substitute(90113)},
        size = cc.size(160,70),
        layout = "h",
        idx = 1,

        ["onCreate"] = function(tabHost, idx)
            print("onCreate===idx==",idx)
            if idx == 3 then
                self.task_dec:setVisible(true)
            else
                self.task_dec:setVisible(false)
            end
            return self:createContent(idx)
        end,

        ["onTabChange"] = function(tabHost, idx)
            print("onTabChange===idx==",idx)
            if idx == 3 then
                self.task_dec:setVisible(true)
            else
                self.task_dec:setVisible(false)
            end
            tabHost.views[idx]:reloadData()
        end
    })

    self.container:addChild(self.tab_host)
    self.tab_host:setPosition(-254,121)
end

function MilitaryDialog:createContent(tab_idx)
    local tableView = cc.TableView:create(cc.size(640,430))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(-8,-435)
    tableView:setDelegate()

    local function numberOfCellsInTableView(table)
        return self.model:getMilitaryNumByIdx(tab_idx)
    end

    local function tableCellTouched(table,cell)
        print("cell touched at index: " .. cell:getIdx())
    end

    local function cellSizeForTable(tableView, idx)
        return 825, 166
    end

    local function tableCellAtIndex(table, idx)
        local strValue = string.format("%d",idx)
        local cell = table:dequeueCell()
        local item = nil
        local label = nil
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.operatingActivities.military_supply.MilitaryCell.new({
                ["callback"] = function()
                    self:dismiss()
                end,
                ["updateList"] = function()
                    self:updateList()
                end
            })
            cell:addChild(item)
            cell.item = item
        end

        cell.item:render(tab_idx,idx+1)
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)

    tableView:reloadData()

    self.tableView = tableView
    return tableView
end

function MilitaryDialog:updateTime()
	self.end_time:setString(self.model:getMilitaryEndTime())
end

function MilitaryDialog:onEnter()
    self.timeListener = qy.Event.add(qy.Runtime.TIMER_UPDATE,function(event)
        self:updateTime()
    end)
    self:updateTime()
    qy.RedDotCommand:addSignal({
        [qy.RedDotType.MILI_TAB_1] = self.tab_host.tab.btns[1],
        [qy.RedDotType.MILI_TAB_2] = self.tab_host.tab.btns[2],
        [qy.RedDotType.MILI_TAB_3] = self.tab_host.tab.btns[3],
    })
    qy.RedDotCommand:emitSignal(qy.RedDotType.MILI_TAB_1, self.model.military_supply_dot[1])
    qy.RedDotCommand:emitSignal(qy.RedDotType.MILI_TAB_2, self.model.military_supply_dot[2])
    qy.RedDotCommand:emitSignal(qy.RedDotType.MILI_TAB_3, self.model.military_supply_dot[3])
end

function MilitaryDialog:updateList()
    local listCurY = self.tableView:getContentOffset().y
    self.tableView:reloadData()
    self.tableView:setContentOffset(cc.p(0,listCurY))
end

function MilitaryDialog:onExit()
    qy.Event.remove(self.timeListener)
	self.timeListener = nil
    qy.RedDotCommand:removeSignal({
        qy.RedDotType.MILI_TAB_1,
        qy.RedDotType.MILI_TAB_2,
        qy.RedDotType.MILI_TAB_3,
    })
end

return MilitaryDialog
