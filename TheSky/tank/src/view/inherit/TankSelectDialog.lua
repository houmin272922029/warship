--[[

]]

local TankSelectDialog = qy.class("TankSelectDialog", qy.tank.view.BaseDialog, "view/inherit/TankSelectDialog")

function TankSelectDialog:ctor(delegate)
    TankSelectDialog.super.ctor(self)

    local style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(916,580),
        position = cc.p(0,0),
        offset = cc.p(0,0),  
        titleUrl = "Resources/inherit/55.png", 
        
        ["onClose"] = function()
            self:dismiss()
        end
    })
    self:addChild(style,-1)

    self.delegate = delegate
    self.entity = delegate.entity
    self.model = qy.tank.model.GarageModel
    self.fightJapanModel = qy.tank.model.FightJapanGarageModel
    self:InjectView("panel")


    self.list = {}
    for i=1,#self.model.unselectedTanks do 
        local _entity = self.model.unselectedTanks[i]
        print()
        if _entity.is_train == 0 and not self.fightJapanModel:contains(self.fightJapanModel.data.formation, _entity.unique_id) and _entity.inherit == self.entity.inherit then
            table.insert(self.list, _entity)
        end
    end

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
        return #self.list
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
            item = qy.tank.view.inherit.TankSelectCell.new(self)
            cell:addChild(item)
            cell.item = item

        end
        
        cell.item:render(self.list[idx+1])
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    
    tableView:reloadData()
    
end


function TankSelectDialog:set(entity)
    self.delegate:set(entity)
    self:dismiss()
end

return TankSelectDialog

