--[[
	跨服军团战
	Author: 
]]

local DefenseView = qy.class("DefenseView", qy.tank.view.BaseDialog, "service_legion_war/ui/DefenseView")

local userModel = qy.tank.model.UserInfoModel
local service = qy.tank.service.ServiceLegionWarService
local model = qy.tank.model.ServiceLegionWarModel

function DefenseView:ctor(delegate)
    DefenseView.super.ctor(self)
    self:InjectView("name")
    self:InjectView("listbg")
    self:InjectView("closeBt")
    self:OnClick("closeBt",function()
        self:dismiss()
    end)
    self.type = delegate.type -- 1代表攻击  2 代表不妨自己军团
    self.num1 = delegate.totalnum
    self.id = delegate.id
    self.list = self:createView()
    self.listbg:addChild(self.list)
    self:update()

end
function DefenseView:update(  )
    self.name:setString(model.typeNameList[tostring(self.id)])
end
function DefenseView:createView()
    local tableView = cc.TableView:create(cc.size(900, 490))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(3, 0)
    tableView:setDelegate()

    local num = self.num1
    local function numberOfCellsInTableView(tableView)
        return num/2
    end

    local function tableCellTouched(table, cell)
       
    end
    
    local function cellSizeForTable(tableView, idx)
        return 320, 480
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        if nil == cell then
            cell = cc.TableViewCell:new()
            if self.type == 1 then
                 item = require("service_legion_war.src.AttackCell").new()
            else
                 item = require("service_legion_war.src.DefenceCell").new({
                    ["site"] = self.id,
                    ["callback"] = function (  )
                        local listCury = self.list:getContentOffset()
                        self.list:reloadData()
                        self.list:setContentOffset(listCury)--设置滚动距离
                    end
                    })
            end
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

function DefenseView:onEnter()
  
end

function DefenseView:onExit()
    
end

return DefenseView
