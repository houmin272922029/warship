--[[
	军奥排行tab
	Author: Aaron Wei
	Date: 2016-09-12 18:58:47
]]

local ShopView = qy.class("ShopView", qy.tank.view.BaseView, "olympic.ui.ShopView")

function ShopView:ctor(delegate)
	print("ShopView:ctor")
    ShopView.super.ctor(self)

    self:InjectView("due")
    self:InjectView("listBG")
    self:InjectView("panel")

	self.delegate = delegate
    self.model = qy.tank.model.OlympicModel

    self.due:setString("兑换截止日期："..os.date("%Y年%m月%d日",self.model.award_end_time))

	local h = 505
    self.tableView = cc.TableView:create(cc.size(700,h))
    self.tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.tableView:setPosition(10,520-h)
    self.listBG:addChild(self.tableView)
    self.tableView:setDelegate()

    local function numberOfCellsInTableView(table)
        return #self.model.goodList
    end

    local function tableCellTouched(table,cell)
        print("cell touched at index: " .. cell:getIdx())
    end

    local function cellSizeForTable(tableView, idx)
        return 700, 160
    end

    local function tableCellAtIndex(table, idx)
        local strValue = string.format("%d",idx)
        local cell = table:dequeueCell()
        local item = nil
        local label = nil
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("olympic.src.ShopCell").new({
                ["exchange"] = function(data)
                    self.tableView:reloadData()
                    qy.tank.command.AwardCommand:add(data.award)
                    qy.tank.command.AwardCommand:show(data.award)
                end
            })
            cell:addChild(item)
            cell.item = item
        end
        cell.item:render(self.model.goodList[idx+1])
        return cell
    end

    self.tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    self.tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    self.tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    self.tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)

    self.tableView:reloadData()
end


function ShopView:render()
    self.tableView:reloadData()
end

return ShopView