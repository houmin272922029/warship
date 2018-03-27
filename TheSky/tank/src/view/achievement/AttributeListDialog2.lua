--[[
    成就 升级属性预览表
    Author: mingming
    Date: 2015-08-21 16:28:15
]]

local AttributeListDialog = qy.class("AttributeListDialog", qy.tank.view.BaseView, "view/achievement/AttributeListDialog")

function AttributeListDialog:ctor(entity)
    AttributeListDialog.super.ctor(self)

    self:InjectView("Name")
    self:InjectView("Panel_1")
    -- self:InjectView("Title")
    self:InjectView("BZ_1_1")
    

    -- 通用弹窗样式
    -- local style = qy.tank.view.style.DialogStyle1.new({
    --     size = cc.size(840, 480),   
    --     position = cc.p(0, 0),
    --     offset = cc.p(0, 0),
        
    --     ["onClose"] = function()
    --         self:dismiss()
    --     end
    -- })
    -- self:addChild(style)
    -- style:setLocalZOrder(-1)
    -- self.style = style

    -- local winSize = cc.Director:getInstance():getWinSize()

    self.Panel_1:addChild(self:createView(entity))

    self.Name:setString(entity.name)
end

function AttributeListDialog:createView(entity)
    local tableView = cc.TableView:create(cc.size(820, 323))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(0, 5)

    local data = entity:getAttributelist()

    local function numberOfCellsInTableView(tableView)
        return #data
    end

    local function cellSizeForTable(tableView,idx)
        return 820, 79
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        local label = nil
        -- local data = model:getList(idx)
        -- local height = model:getHeight(idx)
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.achievement.AttributeItem.new({
                
            })
            cell:addChild(item)
            cell.item = item
        end

        cell.item:setData(data[idx + 1])
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    
    tableView:reloadData()

    return tableView
end

return AttributeListDialog


