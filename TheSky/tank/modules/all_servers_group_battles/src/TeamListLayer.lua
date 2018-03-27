--[[
    跨服副本
]]
local TeamListLayer = qy.class("TeamListLayer", qy.tank.view.BaseDialog, "all_servers_group_battles.ui.TeamListLayer")


function TeamListLayer:ctor(delegate)
    TeamListLayer.super.ctor(self)

    self.model = qy.tank.model.AllServersGroupBattlesModel
    self.service = qy.tank.service.AllServersGroupBattlesService

    self:InjectView("bg")
    self:InjectView("Btn_close")
    self:InjectView("Btn_refresh")
    

    self.status = 0
    
    self:OnClick(self.Btn_close, function(sender)
        delegate.viewStack:pop()
    end,{["isScale"] = false})
    self:OnClick(self.Btn_refresh, function(sender)
        self.service:getTeamList(function(data)     
            self:update()
        end, self.model.select_scene_id, 1, 20)
    end,{["isScale"] = false})


    self.bg:addChild(self:__createList(), 1)

    self.callback = function()
        delegate:showTeamInfoView()
    end

    self:update()
end




function TeamListLayer:__createList()
    local tableView = cc.TableView:create(cc.size(970, 480))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(5, 80)
    tableView:setDelegate()

    local function numberOfCellsInTableView(tableView)
        return #self.model.team_list
    end

    local function cellSizeForTable(tableView,idx)
        return 970, 200
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil

        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("all_servers_group_battles.src.TeamCell").new(self)
            cell:addChild(item)
            cell.item = item
        end

        cell.item:render(self.model.team_list[idx + 1], idx+1)
        cell.idx = idx+1
        
        return cell
    end

    local function tableAtTouched(table, cell)
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:registerScriptHandler(tableAtTouched,cc.TABLECELL_TOUCHED)

    tableView:reloadData()

    self.tableViewList = tableView

    return tableView
end




function TeamListLayer:update()
    self.tableViewList:reloadData()
end



function TeamListLayer:onEnter()
    self:update()

end



function TeamListLayer:onExit()
end




return TeamListLayer
