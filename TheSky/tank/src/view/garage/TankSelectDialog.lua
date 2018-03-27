--[[
	车库战车列表
	Author: Aaron Wei
	Date: 2015-03-20 17:40:00
]]

local TankSelectDialog = qy.class("TankSelectDialog", qy.tank.view.BaseDialog, "view/garage/TankSelectDialog")

function TankSelectDialog:ctor(delegate)
    TankSelectDialog.super.ctor(self)

    local style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(916,580),
        position = cc.p(0,0),
        offset = cc.p(0,0),  
        titleUrl = "Resources/common/title/choose_tank_list.png", 
        
        ["onClose"] = function()
            self:dismiss()
        end
    })
    self:addChild(style,-1)

    self.delegate = delegate
    self.model = qy.tank.model.GarageModel
	self.fightJapanModel = qy.tank.model.FightJapanGarageModel
    self:InjectView("panel")

    -- local layer = cc.LayerColor:create(cc.c4b(0,255,255,100),625,380)
    local layer = cc.Layer:create()

    local tableView = cc.TableView:create(cc.size(830,500))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(-315,-160)
    self.panel:addChild(tableView)
    tableView:addChild(layer)
    tableView:setDelegate()

    local function numberOfCellsInTableView(table)
        if self.delegate.type == 1 then
            return #self.model.totalTanks
        elseif self.delegate.type == 2 then
            return #self.model.selectedTanks
        elseif self.delegate.type == 3 then
            return #self.model.unselectedTanks
        elseif self.delegate.type == 4 then
            return #self.fightJapanModel.unselectedTanks            
        elseif self.delegate.type == 5 then
            return #self.model:getTankFragment()
        end
    end

    local function tableCellTouched(table,cell)
        print("cell touched at index: " .. cell:getIdx())
    end

    local function cellSizeForTable(tableView, idx)
        return 810, 150
    end

    local function tableCellAtIndex(table, idx)
        local strValue = string.format("%d",idx)
        local cell = table:dequeueCell()
        local item = nil
        local label = nil
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.garage.TankSelectCell.new({
                ["choose"] = function(uid)
                    self.delegate.choose(uid)
                end,
                ["index"] = idx + 1,
            })
            cell:addChild(item)
            cell.item = item

            -- label = cc.Label:createWithSystemFont(strValue, "Helvetica", 20.0)
            -- label:setPosition(0,0)
            -- label:setAnchorPoint(0,0)
            -- cell:addChild(label)
            -- cell.label = label
        end

        -- print("打开类型==========" .. self.delegate.type)
        if self.delegate.type == 1 then
            cell.item:render(self.model.totalTanks[idx+1])
        elseif self.delegate.type == 2 then
            cell.item:render(self.model.selectedTanks[idx+1])
        elseif self.delegate.type == 3 then
            cell.item:render(self.model.unselectedTanks[idx+1])
        elseif self.delegate.type == 4 then
            -- print("远征选择坦克==========")
            cell.item:render(self.fightJapanModel.unselectedTanks[idx+1])            
        elseif self.delegate.type == 5 then
            cell.item:render(self.model:getTankFragment()[idx + 1])
        end
        -- cell.label:setString(strValue)
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    
    tableView:reloadData()
    
end

return TankSelectDialog

