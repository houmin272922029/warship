--[[
    战争图卷
    2016年07月26日17:42:39
]]
local CombatCastingRankDialog = qy.class("CombatCastingRankDialog", qy.tank.view.BaseDialog, "combat_casting.ui.CombatCastingRankDialog")

local model = qy.tank.model.CombatCastingModel
local service = qy.tank.service.CombatCastingService
function CombatCastingRankDialog:ctor(delegate)
    CombatCastingRankDialog.super.ctor(self)

    self:InjectView("bg")
    self:InjectView("Rank")
    self:InjectView("Btn_receive")
    self:InjectView("lingqu")
    self:InjectView("weishangbang")
    self:InjectView("yilingqu")
    self:InjectView("End_time")

    self.style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(620,620),
        position = cc.p(0,0),
        offset = cc.p(0,0),
        titleUrl = "combat_casting/res/33.png",


        ["onClose"] = function()
            self:removeSelf()
        end
    })
    self:addChild(self.style , -1)

    self.bg:addChild(self:__createList(), 1)

    if model.my_rank > 0 then
        self.Rank:setString(qy.TextUtil:substitute(50011)..model.my_rank..qy.TextUtil:substitute(50012))

        local award = model:getRankRewardById(model.my_rank).award

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
            service:getAward2(function(data)
                if data.award then
                    self:update()

                    qy.tank.command.AwardCommand:add(data.award)
                    qy.tank.command.AwardCommand:show(data.award)
                end
            end, 5)
        end
    end,{["isScale"] = false})


    self:OnClick("Btn_yulan", function(sender)       
        require("combat_casting.src.RewardPreviewDialog").new():show()
    end) 

    

    self:update()

end




function CombatCastingRankDialog:__createList()
    local tableView = cc.TableView:create(cc.size(555, 295))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(3, 160)
    tableView:setDelegate()

    local function numberOfCellsInTableView(tableView)
        return 50
    end

    local function cellSizeForTable(tableView,idx)
        return 555, 33
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        local label = nil

        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("combat_casting.src.CombatCastingRankCell").new(self)
            cell:addChild(item)
            cell.item = item
        end

        cell.item:render(model:getRankById(idx+1), model:getRankRewardById(idx+1), idx+1)
        cell.item.entity = model:getRankRewardById(idx+1)

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
    self.End_time:setVisible(false)
    self.Btn_receive:setBright(false)
    self.yilingqu:setVisible(false)
    self.lingqu:setVisible(false)
    self.weishangbang:setVisible(false)

    if model.my_rank == 0 then
        self.Btn_receive:setBright(false)
        self.weishangbang:setVisible(true)
    elseif model.get_rank_award == 1 then
        self.Btn_receive:setBright(false)
        self.yilingqu:setVisible(true)
    elseif model:getRemainTime() == qy.TextUtil:substitute(63035) then
        self.Btn_receive:setBright(true)
        self.lingqu:setVisible(true)
    else        
        self.Btn_receive:setBright(false)
        self.lingqu:setVisible(true)
    end

end



return CombatCastingRankDialog
