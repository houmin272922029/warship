--[[
	军团审核列表
	Author: H.X.Sun
]]

local AuditList = qy.class("AuditList", qy.tank.view.BaseView, "legion/ui/basic/AuditList")

function AuditList:ctor(delegate)
    AuditList.super.ctor(self)
    self:InjectView("rank_id")
    self:InjectView("rank_num")
    self:InjectView("list_empty")

    self.model = qy.tank.model.LegionModel
    self.selectIdx = 0
    self.delegate = delegate
    local service = qy.tank.service.LegionService
    self:OnClick("all_btn",function()
        if self.model:getApplyNum() == 0 then
            qy.hint:show(qy.TextUtil:substitute(50041))
        else
            service:applyRefuseAuto(function()
                self.list:reloadData()
            end)
        end
    end)
end

function AuditList:createList()
    local tableView = cc.TableView:create(cc.size(980,412))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setDelegate()

    local function numberOfCellsInTableView(table)
        if self.model:getApplyNum() == 0 then
            self.list_empty:setVisible(true)
        else
            self.list_empty:setVisible(false)
        end
        return self.model:getApplyNum()
    end

    local function tableCellTouched(table,cell)
        self.selectIdx = cell:getIdx()
        if cell.item.entity then
            local kid = cell.item.entity.kid or 0
            if kid ~= 0 then
                qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.EXAMINE,cell.item.entity.kid)
            end
        end
    end

    local function cellSizeForTable(tableView, idx)
        return 980, 155
    end

    local function tableCellAtIndex(table, idx)
        local cell = table:dequeueCell()
        local item
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.legion.basic.AuditCell.new({
                ["updateList"] = function()
                    tableView:reloadData()
                end
            })
            cell:addChild(item)
            cell.item = item
        end
        cell.item:render(self.model:getApplyEntityByIndex(idx + 1))

        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:reloadData()
    return tableView
end


function AuditList:onEnter()
    if not tolua.cast(self.list,"cc.Node") then
        self.list = self:createList()
        self:addChild(self.list)
        self.list:setPosition(-490,85)
    end
end


return AuditList
