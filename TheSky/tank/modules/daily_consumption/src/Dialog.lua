--[[

]]
local Dialog = qy.class("Dialog", qy.tank.view.BaseDialog, "daily_consumption.ui.Layer")

function Dialog:ctor(delegate)
    Dialog.super.ctor(self)


    self.model = qy.tank.model.DailyConsumptionModel
    self.service = qy.tank.service.DailyConsumptionService

    self:InjectView("bg")
    self:InjectView("Btn_close")
    self:InjectView("Text_time")
    self:InjectView("Text_1")
    self:InjectView("Text_2")
    self:InjectView("Text_num1")
    self:InjectView("Text_num2")




    self:OnClick("Btn_close", function(sender)       
        self:removeSelf()
    end) 

    self.Btn_close:setSwallowTouches(false)
    
    self.bg:addChild(self:__createList())
    self.Btn_close:setLocalZOrder(1)

    self:update()

end




function Dialog:__createList()
    local tableView = cc.TableView:create(cc.size(690, 450))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(23, 20)
    tableView:setDelegate()

    local function numberOfCellsInTableView(tableView)
        return #self.model.score_award
    end

    local function cellSizeForTable(tableView,idx)
        return 690, 220
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        local label = nil

        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("daily_consumption.src.Cell").new(self)
            cell:addChild(item)
            cell.item = item
        end

        cell.item:render(self.model.score_award[idx+1], idx+1)

        cell.item.idx = idx + 1
        return cell
    end

    local function tableAtTouched(table, cell)

    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:registerScriptHandler(tableAtTouched,cc.TABLECELL_TOUCHED)

    tableView:reloadData()
    self.ListView = tableView

    return tableView
end



function Dialog:update()
    
    local next_ = -1
    for i = 1, #self.model.score_award do
        if self.model.score_award[i].diamond > self.model.diamond then
            next_ = self.model.score_award[i].diamond - self.model.diamond 
            break
        end
    end

    if next_ == -1 then
        self.Text_2:setString("可以领取全部奖励")
    end

    if self.model.diamond > self.model.score_award[#self.model.score_award].diamond then
        self.model.diamond = self.model.score_award[#self.model.score_award].diamond
    end
    
    self.Text_num1:setString(tostring(self.model.diamond))


    if next_ > -1 then
        self.Text_num2:setString(tostring(next_))
        self.Text_num1:setVisible(true)
    else
        self.Text_num2:setVisible(false)
    end


    local listCurY = self.ListView:getContentOffset().y
    self.ListView:reloadData()
    self.ListView:setContentOffset(cc.p(0,listCurY))

end



function Dialog:updateTime()
    if self.Text_time then
        if self.model:getRemainTime() == qy.TextUtil:substitute(63035) then
            self:update()
        end

        self.Text_time:setString(self.model:getRemainTime())
    end
end


function Dialog:onEnter()
    self:updateTime()
    self.timeListener = qy.Event.add(qy.Runtime.TIMER_UPDATE,function(event)
        self:updateTime()
    end)
end


function Dialog:onExit()
    qy.Event.remove(self.timeListener)
    self.timeListener = nil
end


return Dialog
