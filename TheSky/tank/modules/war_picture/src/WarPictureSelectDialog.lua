--[[
    战争图卷
    2016年07月26日17:42:39
]]
local WarPictureSelectDialog = qy.class("WarPictureSelectDialog", qy.tank.view.BaseDialog, "war_picture.ui.WarPictureSelectDialog")

local model = qy.tank.model.WarPictureModel
local service = qy.tank.service.WarPictureService
function WarPictureSelectDialog:ctor(delegate)
    WarPictureSelectDialog.super.ctor(self)


    self.style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(1074,600),
        position = cc.p(0,0),
        offset = cc.p(0,0),
        titleUrl = "Resources/common/title/war_picture_select_title.png",


        ["onClose"] = function()
            self:removeSelf()
        end
    })
    self:addChild(self.style , -1)

    self:InjectView("Bg")

    self.Bg:addChild(self:__createList(), 1)

    self.parent = delegate
end




function WarPictureSelectDialog:__createList()
    local tableView = cc.TableView:create(cc.size(970, 485))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(8, 10)
    tableView:setDelegate()

    local function numberOfCellsInTableView(tableView)
        return #model.checkpointList
    end

    local function cellSizeForTable(tableView,idx)
        return 970, 190
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        local label = nil

        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("war_picture.src.WarPictureSelectCell").new(self)
            cell:addChild(item)
            cell.item = item
        end

        cell.item:render(model.checkpointList[idx+1], idx+1)
        cell.item.entity = model.checkpointList[idx+1]

        cell.item.idx = idx + 1
        return cell
    end

    local function tableAtTouched(table, cell)
        require("war_picture.src.SelectDialog").new(function(flag)
            service:start(function(data)            
                    self.parent:update()
                    self:removeSelf()
            end, cell.item.idx)
        end):show()  
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:registerScriptHandler(tableAtTouched,cc.TABLECELL_TOUCHED)

    tableView:reloadData()

    self.tankViewList = tableView

    return tableView
end


return WarPictureSelectDialog
