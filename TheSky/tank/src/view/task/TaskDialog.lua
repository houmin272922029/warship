--[[
    任务
    Author: H.X.Sun
    Date: 2015-05-11
]]

local TaskDialog = qy.class("TaskDialog", qy.tank.view.BaseDialog)

function TaskDialog:ctor(delegate)
    TaskDialog.super.ctor(self)

    self.delegate = delegate
    self.model = qy.tank.model.TaskModel
    -- 通用弹窗样式
    local style = qy.tank.view.style.DialogStyle2.new({
        size = cc.size(890,600),
        position = cc.p(0,0),
        offset = cc.p(0,0),
        bgOpacity = 200,
        titleUrl = "Resources/common/title/Tasks_title.png",

        ["onClose"] = function()
            self:dismiss()
        end
    })
    self.canTouch = true
    self:addChild(style, -1)
    self.lastTabIdx = 0


    self.tab_host = qy.tank.widget.TabButtonGroup.new(
        "widget/TabButton1",
        {qy.TextUtil:substitute(34001), qy.TextUtil:substitute(90334),qy.TextUtil:substitute(34002)},
        cc.size(185,70),
        "h",
        function(idx)
            self.cellIdx = idx
            if self.taskList then
                self.taskList:reloadData()
            else
                self.taskList = self:createTaskList()
                style:addChild(self.taskList)
                self.taskList:setPosition(qy.winSize.width/2 - 420,84)
            end
        end,
    1)

    self.tab_2 = self.tab_host.btns[2]
    self:addChild(self.tab_host)
    self.tab_host:setPosition(qy.winSize.width/2 - 397,545)

end

function TaskDialog:__rewardAction(cell, idx)
    local service = qy.tank.service.TaskService
    service:getReward(self.model:getTaskListByIdx(self.cellIdx)[idx + 1], function()
        self.canTouch = false
        self:rewardAnim(cell, idx)
        qy.RedDotCommand:emitSignal(qy.RedDotType.M_TASK, qy.tank.model.RedDotModel:isTaskHasRedDot())
        if _idx == 1 then
            -- qy.RedDotCommand:emitSignal(qy.RedDotType.T_TAB_1, qy.tank.model.RedDotModel:isDailyTaskHasRedDot())
        else
            qy.RedDotCommand:emitSignal(qy.RedDotType.T_TAB_2, qy.tank.model.RedDotModel:isOneTimesTaskHasRedDot())
        end
    end)
end

--[[--
    列表
--]]
function TaskDialog:createTaskList()
    print("_idx ==", self.cellIdx)
    tableView = cc.TableView:create(cc.size(840,450))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setAnchorPoint(0,0)
    tableView:setDelegate()

    local function numberOfCellsInTableView(table)
        return #self.model:getTaskListByIdx(self.cellIdx)
    end

    local function tableCellTouched(table,cell)
        self.selectIdx = cell:getIdx()
        local entity = self.model:getTaskListByIdx(self.cellIdx)[self.selectIdx + 1]
        if self.canTouch and entity.status == 1 then
           self:__rewardAction(cell, self.selectIdx)
        end
    end

    local function cellSizeForTable(tableView, idx)
        return 840, 150
    end

    local function tableCellAtIndex(table, idx)
        local cell = table:dequeueCell()
        local item
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.task.TaskCell.new({
                ["closeView"] = function ()
                    self:dismiss()
                end,
            })
            cell:addChild(item)
            cell.item = item

        end
        cell.item:render(self.model:getTaskListByIdx(self.cellIdx)[idx + 1], idx)
        return cell
    end

    local function tableCellHighLight(table,cell)
        cell.item:hightLight()
    end

    local function tableCellUnhighLight(table,cell)
        cell.item:unhightLight()
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)

    tableView:registerScriptHandler(tableCellHighLight, cc.TABLECELL_HIGH_LIGHT)
    tableView:registerScriptHandler(tableCellUnhighLight, cc.TABLECELL_UNHIGH_LIGHT)
    tableView:reloadData()
    return tableView
end

--[[--
--领奖动画
--]]
function TaskDialog:rewardAnim(tableCell, idx)
    tableCell:stopAllActions()
    local move = cc.MoveTo:create(0.2, cc.p(tableCell:getPositionX() + 841, tableCell:getPositionY()))
    local delay = cc.DelayTime:create(0.2)
    local callFunc = cc.CallFunc:create(function ()
        self.taskList:reloadData()
        qy.tank.command.AwardCommand:show(self.model:getReward(), {["callback"] = function ()
            local model = qy.tank.model.RoleUpgradeModel
            if model:isRoleUpgrade() then
                model:redirectRoleUpgrade()
                model:setRoleUpgrade(false)
            end
        end})
        self.canTouch = true
    end)
    tableCell:runAction(cc.Sequence:create(move, callFunc))
end

function TaskDialog:onEnter()
    qy.RedDotCommand:addSignal({
        -- [qy.RedDotType.T_TAB_1] = self.tab_1,
        [qy.RedDotType.T_TAB_2] = self.tab_2,
    })
    -- qy.RedDotCommand:emitSignal(qy.RedDotType.T_TAB_1, qy.tank.model.RedDotModel:isDailyTaskHasRedDot())
    qy.RedDotCommand:emitSignal(qy.RedDotType.T_TAB_2, qy.tank.model.RedDotModel:isOneTimesTaskHasRedDot())
end

function TaskDialog:onExit()
    qy.RedDotCommand:removeSignal({
        qy.RedDotType.T_TAB_2,
    })
end

return TaskDialog
