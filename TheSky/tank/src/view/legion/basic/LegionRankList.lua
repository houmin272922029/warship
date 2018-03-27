--[[
	军团排行榜
	Author: H.X.Sun
]]

local LegionRankList = qy.class("LegionRankList", qy.tank.view.BaseView, "legion/ui/basic/LegionRankList")

function LegionRankList:ctor(delegate)
    LegionRankList.super.ctor(self)
    self:InjectView("rank_title")
    self:InjectView("name_title")
    self:InjectView("num_title")
    self:InjectView("leader_title")
    self:InjectView("page_txt")

    self.model = qy.tank.model.LegionModel
    self.selectIdx = 0
    self.delegate = delegate
    if qy.language == "cn" then
        if delegate.type == self.model.IS_OPERATE then
            self.rank_title:setPosition(10, 22)
            self.name_title:setPosition(167,22)
            self.num_title:setPosition(293, 22)
            self.leader_title:setPosition(426,22)
        else
            self.rank_title:setPosition(22, 22)
            self.name_title:setPosition(214,22)
            self.num_title:setPosition(373, 22)
            self.leader_title:setPosition(537,22)
        end
    end

    self:OnClick("last_btn", function()
        if self.model:hasLastPage() then
            qy.tank.service.LegionService:getLegionList({["page"] = self.model.curPage - 1},function()
                self:update()
                self:updatePage()
            end)
        else
            qy.hint:show(qy.TextUtil:substitute(50036))
        end
    end)

    self:OnClick("next_btn", function()
        if self.model:hasNextPage() then
            qy.tank.service.LegionService:getLegionList({["page"] = self.model.curPage + 1},function()
                self:update()
                self:updatePage()
            end)
        else
            qy.hint:show(qy.TextUtil:substitute(50036))
        end
    end)
end

function LegionRankList:updatePage()
    self.page_txt:setString(self.model:getPageInfo())
end

function LegionRankList:createList()
    local tableView = cc.TableView:create(cc.size(739,420))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setDelegate()

    local function numberOfCellsInTableView(table)
        return self.model:getLegionNum()
    end

    local function tableCellTouched(table,cell)
        if self.selectIdx ~= cell:getIdx() then
            if tableView:cellAtIndex(self.selectIdx) then
                tableView:cellAtIndex(self.selectIdx).item:removeSelected()
            end
            cell.item:setSelected()
            self.selectIdx = cell:getIdx()
            self:__showIntro()
        end
    end

    local function cellSizeForTable(tableView, idx)
        return 722, 133
    end

    local function tableCellAtIndex(table, idx)
        local cell = table:dequeueCell()
        local item
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.legion.basic.JoinCell.new({
                ["type"] = self.delegate.type,
                ["updateList"] = function()
                    self:updateList()
                end,
            })
            cell:addChild(item)
            cell.item = item
        end
        cell.item:render(self.model:getLegionEntityByIndex(idx + 1))

        if idx == self.selectIdx then
            cell.item:setSelected()
        else
            cell.item:removeSelected()
        end
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:reloadData()
    self:__showIntro()
    return tableView
end

function LegionRankList:updateList()
    if self.rankList ~= nil then
        local listCurY = self.rankList:getContentOffset().y
        self.rankList:reloadData()
        self.rankList:setContentOffset(cc.p(0,listCurY))
    end
end

function LegionRankList:update()
    self.selectIdx = 0
    self.rankList:reloadData()
    self:__showIntro()
end

function LegionRankList:__showIntro()
    if self.delegate.updateIntro then
        self.delegate.updateIntro(self.model:getLegionEntityByIndex(self.selectIdx + 1))
    end
end

function LegionRankList:onEnter()
    if not tolua.cast(self.rankList,"cc.Node") then
        self.rankList = self:createList()
        self:addChild(self.rankList)
        self.rankList:setPosition(9,77)
    end
    self:updatePage()
end

return LegionRankList
