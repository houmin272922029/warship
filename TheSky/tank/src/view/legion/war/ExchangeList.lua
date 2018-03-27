--[[
	兑换列表
	Author: H.X.Sun
]]

local ExchangeList = qy.class("ExchangeList", qy.tank.view.BaseView)

local userModel = qy.tank.model.UserInfoModel
local NumberUtil = qy.tank.utils.NumberUtil
local service = qy.tank.service.LegionWarService

function ExchangeList:ctor(params)
    ExchangeList.super.ctor(self)
    self.model = qy.tank.model.LegionWarModel
    self.params = params
    print("ExchangeList ctor")

end

function ExchangeList:createList()
    local tableView = cc.TableView:create(cc.size(960,410))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setDelegate()

    local function numberOfCellsInTableView(table)
        return self.model:getShopNum()
    end

    local function tableCellTouched(table,cell)
    end

    local function cellSizeForTable(tableView, idx)
        return 960, 150
    end

    local function tableCellAtIndex(table, idx)
        local cell = table:dequeueCell()
        local item
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.legion.war.ExchangeCell.new(self.params)
            cell:addChild(item)
            cell.item = item
        end
        -- print("idx ======>>>>",idx + 1)
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

function ExchangeList:updateTime()
    local end_time = self.model:getShopEndTime()
    -- print("ExchangeList:updateTime ExchangeList:updateTime",end_time)
    if end_time > 0 then
        local time = end_time - userModel.serverTime
        if time < 0 then
            service:getShopList(false,function()
                self:dealList()
            end)
        else
            local s_time = NumberUtil.secondsToTimeStr(time, 1)
            if self.params and self.params.exchangeCallFunc then
                self.params.exchangeCallFunc(s_time)
            end
        end
    end
end

function ExchangeList:dealList()
    if not tolua.cast(self.list,"cc.Node") then
        self.list = self:createList()
        self:addChild(self.list)
        self.list:setPosition(0,0)
    else
        self.list:reloadData()
    end
end

function ExchangeList:onEnter()
    self:dealList()
    self.timeListener = qy.Event.add(qy.Runtime.TIMER_UPDATE,function(event)
        self:updateTime()
    end)
    self:updateTime()
end

function ExchangeList:onExit()
    qy.Event.remove(self.timeListener)
	self.timeListener = nil
end

return ExchangeList
