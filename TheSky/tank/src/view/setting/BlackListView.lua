--[[
    BlackList
    Data:2016-06-12
]]

local BlackListView = qy.class("BlackListView", qy.tank.view.BaseDialog, "view/setting/BlackListView")
local model = qy.tank.model.BlackModel

function BlackListView:ctor(delegate)
    BlackListView.super.ctor(self)

    local style = qy.tank.view.style.DialogStyle1.new({
		size = cc.size(600,580),
		position = cc.p(0,0),
		offset = cc.p(0,0),
		titleUrl = "Resources/common/title/pingbiheimingdan.png",

		["onClose"] = function()
			self:dismiss()
		end
	})
	self:addChild(style, -1)

    self:InjectView("Panel_1")
    self:InjectView("isBlackList")
    self.Panel_1:addChild(self:createView())
    self.isBlackList:setVisible(#model.blackList == 0)
end

function BlackListView:createView()
    
    local tableView = cc.TableView:create(cc.size(545, 472))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(0, 1)

    local data = model.blackList

    local function numberOfCellsInTableView(tableView)
        return #data
    end

    local function cellSizeForTable(tableView,idx)
        return 555, 118
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.setting.BlackListItem.new(self)
            cell:addChild(item)
            cell.item = item
        end

        cell.item.idx = idx
        cell.item:render(data[idx + 1])
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    
    tableView:reloadData()
    self.tableView = tableView
    return tableView
end

function BlackListView:refreshTableView()
    self.Panel_1:removeAllChildren()
    self.Panel_1:addChild(self:createView())
end


function BlackListView:onEnter()
    self.listener_2 = qy.Event.add(qy.Event.GROUP_PURCHASE,function(event)
        self:refreshTableView()
    end)
end

function BlackListView:onExit()
    qy.Event.remove(self.listener_2)
end

return BlackListView