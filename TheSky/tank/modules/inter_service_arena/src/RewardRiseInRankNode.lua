local RewardRiseInRankNode = qy.class("RewardRiseInRankNode", qy.tank.view.BaseView, "inter_service_arena.ui.RewardRiseInRankNode")

-- local model = qy.tank.model.SingleHeroModel
-- local service = qy.tank.service.SingleHeroService
function RewardRiseInRankNode:ctor(delegate)
   	RewardRiseInRankNode.super.ctor(self)

    self.model = qy.tank.model.InterServiceArenaModel
    self.service = qy.tank.service.InterServiceArenaService


    self:InjectView("bg")
    self:InjectView("Img_stage_num")
    self:InjectView("Img_stage")
    self:InjectView("Text_rank")

    self:InjectView("Btn_auto_receive")

    self.delegate = delegate


    self:OnClick("Btn_auto_receive", function()
        self.service:getStageAward(function(data)            
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


    local icon, num = self.model:getStageIcon()
    self.Img_stage:loadTexture("inter_service_arena/res/stage_name2_".. icon ..".png",0)
    if num and num > 0 then
        self.Img_stage_num:setVisible(true)
        self.Img_stage_num:loadTexture("inter_service_arena/res/stage_num2_".. num ..".png",0)
    else
        self.Img_stage_num:setVisible(false)
    end

    self.Text_rank:setString(qy.TextUtil:substitute(4003, self.model.stage_rank))


    self.bg:addChild(self:createTable())
end




function RewardRiseInRankNode:createTable()
    local tableView = cc.TableView:create(cc.size(950, 400))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    -- tableView:setSwallowTouches(false)
    tableView:setPosition(10, 5)
    tableView:setDelegate()

    local function numberOfCellsInTableView(tableView)
        return 19 --王者到青铜3共19个阶段
    end

    local function cellSizeForTable(tableView,idx)
        return 950, 155
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        local label = nil

        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("inter_service_arena.src.RewardRiseInRankCell").new(function()
                self:update()
                self.delegate:update()
            end)
            cell:addChild(item)
            cell.item = item
        end

        cell.item:render(idx+1, self.model.stage_award[tostring(idx+1)])

        return cell
    end

    local function tableAtTouched(table, cell)
        print(1)
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:registerScriptHandler(tableAtTouched,cc.TABLECELL_TOUCHED)

    tableView:reloadData()

    self.tableView = tableView

    return tableView
end




function RewardRiseInRankNode:update()
    local point = self.tableView:getContentOffset()

    self.tableView:reloadData()

    self.tableView:setContentOffset(point) 
end


return RewardRiseInRankNode
