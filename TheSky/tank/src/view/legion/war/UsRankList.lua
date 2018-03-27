--[[
	个人排名list
	Author: H.X.Sun
]]

local UsRankList = qy.class("UsRankList", qy.tank.view.BaseView, "legion_war/ui/UsRankList")

function UsRankList:ctor(params)
    UsRankList.super.ctor(self)
    self:InjectView("bg")
    self:InjectView("rank_info_node")
    self:InjectView("title")
    self:InjectView("no_node")
    self:InjectView("legion_rank")
    self:InjectView("legion_point")
    self:InjectView("my_rank")

    self.model = qy.tank.model.LegionWarModel
    local _stage = self.model:getLegionWarInfoEntity():getGameStage()
    if params.view == 1 then
        --首页显示排名只有前三
        self.bg:setContentSize(cc.size(620,340))
        self.title:setSpriteFrame("legion_war/res/user_rank_4.png")
    end
    self.view = params.view
end

function UsRankList:update(_idx)
    self.tab_idx = _idx
    if _idx == 1 then
        self.title:setSpriteFrame("legion_war/res/user_rank_4.png")
    else
        self.title:setSpriteFrame("legion_war/res/user_rank_"..(_idx - 1)..".png")
    end
    if tolua.cast(self.list,"cc.Node") then
        self.list:reloadData()
    end
end

function UsRankList:createList()
    local tableView = cc.TableView:create(cc.size(624,388))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setDelegate()

    local function numberOfCellsInTableView(table)
        self.cellNum = self.model:getUserRankNum(self.tab_idx)
        if self.cellNum == 0 then
            self.no_node:setString(qy.TextUtil:substitute(53039))
        else
            self.no_node:setString("")
        end
        return self.cellNum
    end

    local function tableCellTouched(table,cell)
    end

    local function cellSizeForTable(tableView, idx)
        return 603, 90
    end

    local function tableCellAtIndex(table, idx)
        local cell = table:dequeueCell()
        local item
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.legion.war.UsRankCell.new()
            cell:addChild(item)
            cell.item = item
        end
        cell.item:render({
            ["idx"] = idx + 1,
            ["tab_idx"] = self.tab_idx,
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

function UsRankList:onEnter()
    if not tolua.cast(self.list,"cc.Node") then
        self.list = self:createList()
        self:addChild(self.list)
        self.list:setPosition(6,10)
    end
    if self.view == 1 then
        self.rank_info_node:setVisible(true)
        self.list:setTouchEnabled(false)
        local data = self.model:getEndInfo()

        self.legion_rank:setString(self.model:formattRank(data.my_legion_rank))
        self.legion_point:setString(self.model:formattScore(data.my_legion_rank,self.model:getLegionWarInfoEntity():getGameStage()))
        self.my_rank:setString(self.model:formattRank(data.my_rank))
    else
        self.rank_info_node:setVisible(false)
        self.list:setTouchEnabled(true)
    end
end

return UsRankList
