
local CombatCastingRankDialog = qy.class("CombatCastingRankDialog", qy.tank.view.BaseDialog, "lucky_draw.ui.CombatCastingRankDialog")

local service = qy.tank.service.LuckyDrawService
local model = qy.tank.model.LuckyDrawModel
function CombatCastingRankDialog:ctor(delegate)
    CombatCastingRankDialog.super.ctor(self)

    self:InjectView("bg")
    self:InjectView("Rank")
    self:InjectView("Btn_receive")
    self:InjectView("lingqu")
    self:InjectView("weishangbang")
    self:InjectView("yilingqu")
    self:InjectView("End_time")
    self:InjectView("score")

    self.style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(670,620),
        position = cc.p(0,0),
        offset = cc.p(0,0),
        titleUrl = "lucky_draw/res/33.png",


        ["onClose"] = function()
            self:removeSelf()
        end
    })
    self:addChild(self.style , -1)

    self.bg:addChild(self:__createList(), 1)

    if model.my_rank > 0 then
        self.Rank:setString(qy.TextUtil:substitute(50011)..model.my_rank..qy.TextUtil:substitute(50012))

        local award = model.ranklist[model.my_rank].award

        self.award_2 = qy.AwardList.new({
                ["award"] = award,
                ["cellSize"] = cc.size(105,180),
                ["type"] = 1,
                ["len"] = 4,
                ["itemSize"] = 2,
                ["hasName"] = false,
            })
        self.award_2:setPosition(70,240)
        self.bg:addChild(self.award_2)
    else
        self.Rank:setString(qy.TextUtil:substitute(50021))
    end

    self:OnClick(self.Btn_receive, function()
        if self.Btn_receive:isBright() then
            service:getaward(function(data)
                model.get_award = 1
                self:update()
            end)
        end
    end,{["isScale"] = false})

    self:OnClick("Btn_yulan", function(sender)       
        require("lucky_draw.src.RewardPreviewDialog").new():show()
    end) 
    self:update()

end




function CombatCastingRankDialog:__createList()
    local tableView = cc.TableView:create(cc.size(580, 285))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(3, 155)
    tableView:setDelegate()

    local function numberOfCellsInTableView(tableView)
        return #model.endranklist
    end

    local function cellSizeForTable(tableView,idx)
        return 580, 33
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        local label = nil

        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("lucky_draw.src.CombatCastingRankCell").new(self)
            cell:addChild(item)
            cell.item = item
        end

        cell.item:render(model.endranklist[idx+1], idx+1)

        cell.item.idx = idx + 1
        return cell
    end

    local function tableAtTouched(table, cell)

    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:registerScriptHandler(tableAtTouched,cc.TABLECELL_TOUCHED)

    tableView:reloadData()

    return tableView
end



function CombatCastingRankDialog:update()
    self.score:setString("当前积分:"..model.my_score)
    self.End_time:setVisible(false)
    self.Btn_receive:setBright(false)
    self.yilingqu:setVisible(false)
    self.lingqu:setVisible(false)
    self.weishangbang:setVisible(false)

    if model.my_rank == 0 then
        self.Btn_receive:setBright(false)
        self.weishangbang:setVisible(true)
    else
        if model.get_award == 0 then
            self.Btn_receive:setBright(true)
            self.lingqu:setVisible(true)
        else
            self.Btn_receive:setBright(false)
            self.yilingqu:setVisible(true)
        end
    end

end



return CombatCastingRankDialog
