--[[
	全服福利
]]
local Welfare = qy.class("Welfare", qy.tank.view.BaseDialog, "view/service_war/Welfare")

local model = qy.tank.model.ServiceWarModel
local CurrentList = {}

function Welfare:ctor(data)
	Welfare.super.ctor(self)
	self:InjectView("backBtn")
	self:InjectView("getrawardsBtn")
	self:InjectView("contentLayer")

	self:OnClick("getrawardsBtn", function(sender)
   		local service = qy.tank.service.ServiceWarService
        service:GetAllAwards(function(data)
            model:SetAllAwardsList()
            self:removeSelf()
            -- qy.tank.command.AwardCommand:show(data.award)
        end, 1)
    end)
    self:OnClick("backBtn", function()
    self:removeSelf()
    end,{["isScale"] = false})
    
    self.data = data
	self:getNewList()
    self.contentLayer:addChild(self:createView())
    model.award = false
end

function Welfare:getNewList()
	for k,v in pairs(self.data) do
	   table.insert(CurrentList, v)
	end
end

function Welfare:createView()
    local tableView = cc.TableView:create(cc.size(590, 340))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(5, 0)
    tableView:setDelegate()
    
    -- self.selectIdx = 1

    local function numberOfCellsInTableView(tableView)
        -- return table.nums(self.data)
         return #self.data
    end

    local function tableCellTouched(table, cell)

    end

    local function cellSizeForTable(tableView, idx)
        return 587, 285
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("view/service_war/AwardsCell").new()
            cell:addChild(item)
            cell.item = item
        end

        cell.item.idx = idx
        cell.item:setData(CurrentList[idx + 1])
        return cell
    end
    tableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)

    tableView:reloadData()
    self.tableView = tableView
    return tableView
end

function Welfare:onEnter()
    
end

function Welfare:onExit()
    
end

return Welfare
