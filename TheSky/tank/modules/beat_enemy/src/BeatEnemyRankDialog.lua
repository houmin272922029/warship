--[[
    战争图卷
    2016年07月26日17:42:39
]]
local BeatEnemyRankDialog = qy.class("BeatEnemyRankDialog", qy.tank.view.BaseDialog, "beat_enemy.ui.BeatEnemyRankDialog")

local model = qy.tank.model.BeatEnemyModel
local service = qy.tank.service.BeatEnemyService
function BeatEnemyRankDialog:ctor(delegate)
    BeatEnemyRankDialog.super.ctor(self)

    self:InjectView("bg")
    self:InjectView("Rank")
    self:InjectView("Btn_receive")
    self:InjectView("lingqu")
    self:InjectView("weishangbang")
    self:InjectView("yilingqu")
    self:InjectView("End_time")

    self.style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(540,620),
        position = cc.p(0,0),
        offset = cc.p(0,0),
        titleUrl = "Resources/common/title/beat_enemy_title.png",


        ["onClose"] = function()
            self:removeSelf()
        end
    })
    self:addChild(self.style , -1)

    self.bg:addChild(self:__createList(), 1)

    if model.my_rank > 0 then
        self.Rank:setString(qy.TextUtil:substitute(50011)..model.my_rank..qy.TextUtil:substitute(50012))

        local award = model:getRankRewardById(model.my_rank).award[1]

        self.award_icon = qy.tank.view.common.AwardItem.createAwardView({["id"] = award.id, ["type"] = award.type, ["num"] = award.num}, 1)
        self.award_icon:setScale(0.7)
        self.award_icon:showTitle(false)
        self.award_icon:setPosition(250,60)
        self.bg:addChild(self.award_icon)
    else
        self.Rank:setString(qy.TextUtil:substitute(50021))
    end

    self:OnClick(self.Btn_receive, function()
        if self.Btn_receive:isBright() then
            service:getAward(function(data)
                if data.award then
                    delegate:update()
                    self:update()

                    qy.tank.command.AwardCommand:add(data.award)
                    qy.tank.command.AwardCommand:show(data.award)
                end
            end, 3, 0)
        end
    end,{["isScale"] = false})

    self:update()

end




function BeatEnemyRankDialog:__createList()
    local tableView = cc.TableView:create(cc.size(460, 325))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(3, 130)
    tableView:setDelegate()

    local function numberOfCellsInTableView(tableView)
        return 20
    end

    local function cellSizeForTable(tableView,idx)
        return 460, 33
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        local label = nil

        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("beat_enemy.src.BeatEnemyRankCell").new(self)
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



function BeatEnemyRankDialog:update()
    self.End_time:setVisible(false)
    self.Btn_receive:setBright(false)
    self.yilingqu:setVisible(false)
    self.lingqu:setVisible(false)
    self.weishangbang:setVisible(false)

    if model.my_rank == 0 then
        self.Btn_receive:setBright(false)
        self.weishangbang:setVisible(true)
    elseif model.is_draw_rank == 1 then
        self.Btn_receive:setBright(false)
        self.yilingqu:setVisible(true)
    elseif model:getRemainTime() == qy.TextUtil:substitute(63035) and model:getReceiveRemainTime() ~= qy.TextUtil:substitute(63035) then
        self.Btn_receive:setBright(true)
        self.lingqu:setVisible(true)
    else
        self.Btn_receive:setBright(false)
        self.End_time:setVisible(true)
    end

end


function BeatEnemyRankDialog:updateTime()
    if self.End_time then
        if model:getRemainTime() == qy.TextUtil:substitute(63035) then
            self:update()
        end

        self.End_time:setString(model:getRemainTime())
    end
end


function BeatEnemyRankDialog:onEnter()

    self:updateTime()
    self.timeListener = qy.Event.add(qy.Runtime.TIMER_UPDATE,function(event)
        self:updateTime()
    end)

end


function BeatEnemyRankDialog:onExit()
    qy.Event.remove(self.timeListener)
    self.timeListener = nil
end


return BeatEnemyRankDialog
