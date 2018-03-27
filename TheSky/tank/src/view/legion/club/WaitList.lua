--[[
	宴会详情cell
	Author: H.X.Sun
]]

local WaitList = qy.class("WaitList", qy.tank.view.BaseView,"legion/ui/club/WaitList")

local CELL_HEIGHT = 40.3

function WaitList:ctor(delegate)
    WaitList.super.ctor(self)
    self.model = qy.tank.model.LegionModel
    local service = qy.tank.service.LegionService

    self:InjectView("list_bg")
    self:InjectView("party_name")
    self:InjectView("num_txt")
    self:InjectView("cost_btn")
    self:InjectView("cancel_btn")
    self:InjectView("open_txt")
    self:InjectView("cost_num")

    self:OnClick("open_btn",function()
        if self.model:getCommanderEntity():isPartyMaster() then
            service:beginParty(self.model.B_P_NORMAL_TYPE,function()
                delegate.callback(true)
            end)
        else
            service:outParty(function()
                qy.hint:show(qy.TextUtil:substitute(51041))
                delegate.callback(false)
            end)
        end
    end)

    self:OnClick("cancel_btn",function()
        service:cancelParty(function()
            qy.hint:show(qy.TextUtil:substitute(51042))
            delegate.callback(false)
        end)
    end)

    self:OnClick("cost_btn",function()
        service:beginParty(self.model.B_P_FORCED_TYPE,function()
            delegate.callback(true)
        end)
    end)

end

function WaitList:createList()
    local tableView = cc.TableView:create(cc.size(530,290))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setDelegate()

    local function numberOfCellsInTableView(table)
        return self.model:getPWaitMsgNum()
    end

    local function tableCellTouched(table,cell)
    end

    local function cellSizeForTable(tableView, idx)
        return 530,CELL_HEIGHT
    end

    local function tableCellAtIndex(table, idx)
        local cell = table:dequeueCell()
        local item
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.legion.club.WaitMsgCell.new()
            cell:addChild(item)
            cell.item = item
        end
        cell.item:update(idx + 1)

        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:reloadData()
    return tableView
end

function WaitList:updateList()
    self.list:reloadData()
    local dis_num = self.model:getPWaitMsgNum() - 7
    if dis_num > 0 then
        local listCurY = self.list:getContentOffset().y + CELL_HEIGHT * dis_num
        self.list:setContentOffset(cc.p(0,listCurY))
    end
end


function WaitList:onEnter()
    if not tolua.cast(self.list,"cc.Node") then
        self.list = self:createList()
        self.list:setPosition(3,15)
        self.list_bg:addChild(self.list)
    end
    self:updateList()
    local data = self.model:getOpenPartyDataByIndex(1)
    self.party_name:setString(string.format("【%s】", data.party_data.name))
    self.party_name:setTextColor(data.color)
    self.num_txt:setString(string.format("%d/%d", data.len, data.party_data.need_num))
    self.cost_num:setString(string.format("x%d", data.party_data.forced_num))

    if self.model:getCommanderEntity():isPartyMaster() then
        self.cost_btn:setVisible(true)
        self.cancel_btn:setVisible(true)
        self.open_txt:setSpriteFrame("legion/res/club/kaishiyanhui.png")
    else
        self.cost_btn:setVisible(false)
        self.cancel_btn:setVisible(false)
        self.open_txt:setSpriteFrame("legion/res/club/likaiyanhui.png")
    end
end

return WaitList
