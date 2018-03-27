--[[
	跨服军团战
	Author: 
]]

local ChangeView = qy.class("ChangeView", qy.tank.view.BaseDialog, "service_legion_war/ui/ChangeView")

local userModel = qy.tank.model.UserInfoModel
local service = qy.tank.service.ServiceLegionWarService
local model = qy.tank.model.ServiceLegionWarModel

function ChangeView:ctor(delegate)
    ChangeView.super.ctor(self)
    self.delegate = delegate
    self:InjectView("list")
    local style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(535,550),
        position = cc.p(0,0),
        offset = cc.p(0,0),
        titleUrl = "service_legion_war/res/huanfangtitle.png",--

        ["onClose"] = function()
            self:dismiss()
        end
    })
    style:setPositionY(15)
    self:addChild(style,-10)
    self.data = delegate.datas
    self.Pos = delegate.pos
    self.site = delegate.site
    self.lists = self:createView()
    self.list:addChild(self.lists)

end
function ChangeView:createView()
    local tableView = cc.TableView:create(cc.size(490, 442))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(3, 0)
    tableView:setDelegate()

    local function numberOfCellsInTableView(tableView)
        return #self.data
    end

    local function tableCellTouched(table, cell)
       
    end
    
    local function cellSizeForTable(tableView, idx)
        return 485, 110
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("service_legion_war.src.ChangeCell").new({
                ["data"] = self.data,
                ["site"] = self.site,
                ["pos"] = self.Pos,
                ["callback"] = function ( )
                    self.delegate:callback()
                    self:dismiss()
                end
                })
            cell:addChild(item)
            cell.item = item
        end
        cell.item.idx = idx
        cell.item:render(idx+1)
        return cell
    end
    tableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    tableView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)

    tableView:reloadData()
    return tableView
end

function ChangeView:onEnter()
  
end

function ChangeView:onExit()
    
end

return ChangeView
