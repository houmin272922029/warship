--[[
	军团排名list
	Author: H.X.Sun
]]

local LeRankList = qy.class("LeRankList", qy.tank.view.BaseView, "legion_war/ui/LeRankList")

function LeRankList:ctor(params)
    LeRankList.super.ctor(self)
    self:InjectView("bg")
    self:InjectView("title")
    self.model = qy.tank.model.LegionWarModel
    local _stage = self.model:getLegionWarInfoEntity():getGameStage()
    if params.view == 1 then
        --首页显示排名只有前三
        self.bg:setContentSize(cc.size(309,340))
        self.title:setSpriteFrame("legion_war/res/legion_rank_4.png")
    end
    self.params = params
    self.hasScore = false
end

function LeRankList:update(_idx)
    self.tab_idx = _idx
    if _idx == 1 then
        self.title:setSpriteFrame("legion_war/res/legion_rank_4.png")
    else
        self.title:setSpriteFrame("legion_war/res/legion_rank_"..(_idx - 1)..".png")
    end
    if _idx == 1 or _idx == 3 then
        self.hasScore = true
    else
        self.hasScore = false
    end
    if tolua.cast(self.list,"cc.Node") then
        self.list:reloadData()
    end
end

function LeRankList:createList()
    local tableView = cc.TableView:create(cc.size(320,388))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setDelegate()

    local function numberOfCellsInTableView(table)
        return self.model:getLegionRankNum(self.tab_idx)
    end

    local function tableCellTouched(table,cell)
    end

    local function cellSizeForTable(tableView, idx)
        return 320, 90
    end

    local function tableCellAtIndex(table, idx)
        local cell = table:dequeueCell()
        local item
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.legion.war.LeRankCell.new()
            cell:addChild(item)
            cell.item = item
        end
        cell.item:render({
            ["idx"] = idx + 1,
            ["tab_idx"] = self.tab_idx,
            ["has_score"] = self.hasScore,
        })

        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:reloadData()
    return tableView
end

function LeRankList:onEnter()
    if not tolua.cast(self.list,"cc.Node") then
        self.list = self:createList()
        self:addChild(self.list)
        self.list:setPosition(0,10)
    end
    if self.params.view == 1 then
        self.list:setTouchEnabled(false)
    else
        self.list:setTouchEnabled(true)
    end
end

return LeRankList
