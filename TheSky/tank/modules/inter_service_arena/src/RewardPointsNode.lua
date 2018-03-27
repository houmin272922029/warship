local RewardPointsNode = qy.class("RewardPointsNode", qy.tank.view.BaseView, "inter_service_arena.ui.RewardPointsNode")

-- local model = qy.tank.model.SingleHeroModel
-- local service = qy.tank.service.SingleHeroService
function RewardPointsNode:ctor(delegate)
   	RewardPointsNode.super.ctor(self)

    self.model = qy.tank.model.InterServiceArenaModel
    self.service = qy.tank.service.InterServiceArenaService

    self.delegate = delegate

    self:InjectView("bg")
    self:InjectView("Btn_auto_receive")
    self:InjectView("Text_points")


    self:OnClick("Btn_auto_receive", function()
        self.service:getSourceAward(function(data)
            if data.award and #data.award > 0 then
                qy.tank.command.AwardCommand:add(data.award)
                qy.tank.command.AwardCommand:show(data.award)
                data.award = nil
            else
                qy.hint:show(qy.TextUtil:substitute(90305))
            end
            self:update()
            delegate:update()
        end, 200)
    end,{["isScale"] = false})

    self.Text_points:setString(self.model.source)

    self.bg:addChild(self:createTable())
end


function RewardPointsNode:createTable()
    local tableView = cc.TableView:create(cc.size(950, 432))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    -- tableView:setSwallowTouches(false)
    tableView:setPosition(10, 5)
    tableView:setDelegate()

    local function numberOfCellsInTableView(tableView)
        return #self.model.score_award + 1
    end

    local function cellSizeForTable(tableView,idx)
        if idx == 0 then
            return 950, 115
        else
            return 950, 130
        end
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil

        if (nil == cell or cell.idx == 0) and idx ~= 0 then
            cell = cc.TableViewCell:new()
            item = require("inter_service_arena.src.RewardPointsCell").new(function()
                self:update()
                self.delegate:update()
            end)
            cell:addChild(item)
            cell.item = item
            cell.idx = idx
        elseif idx == 0 then
            cell = nil
            cell = cc.TableViewCell:new()
            item = require("inter_service_arena.src.RewardPointsCell_1").new(self)
            cell:addChild(item)
            cell.item = item
            cell.idx = idx
        end
        
        cell.item:render(idx == 0 and nil or idx)

        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)

    tableView:reloadData()

    self.tableView = tableView

    return tableView
end


function RewardPointsNode:update()
    local point = self.tableView:getContentOffset()

    self.tableView:reloadData()

    self.tableView:setContentOffset(point) 
end


return RewardPointsNode
