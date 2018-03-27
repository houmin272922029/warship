--[[
	报名比赛结果(在首页展示)
	Author: H.X.Sun
]]

local ResultList = qy.class("ResultList", qy.tank.view.BaseView, "legion_war/ui/ResultList")

local CELL_HIGHT = 155
local SHOW_NUM = 3
local service = qy.tank.service.LegionWarService

function ResultList:ctor(params)
    ResultList.super.ctor(self)
    self:InjectView("title")
    self:InjectView("cell_bg")
    self.params = params
    self.model = qy.tank.model.LegionWarModel
    self.infoEntity = self.model:getLegionWarInfoEntity()
    if self.model:getLastTab() == 1 then
        self:updateTitle()
        self.list_hight = 435
        self.list_width = 630
        self.cell_bg:setVisible(true)
    else
        self.list_hight = 510
        self.list_width = 956
        self.cell_bg:setVisible(false)
    end

end

function ResultList:createList()
    local tableView = cc.TableView:create(cc.size(self.list_width,self.list_hight))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setDelegate()

    local function numberOfCellsInTableView(table)

        if self.model:getLastTab() == 1 then
            --首页
            self.cell_num = self.model:getResultNum()
        else
            --昨日战况
            self.cell_num = self.model:getCombatNum()
            if self.cell_num == 0 and self.params.callback then
                self.params.callback(qy.TextUtil:substitute(53026))
            end
        end
        return self.cell_num
    end

    local function tableCellTouched(table,cell)
    end

    local function cellSizeForTable(tableView, idx)
        return self.list_width, CELL_HIGHT
    end

    local function tableCellAtIndex(table, idx)
        local cell = table:dequeueCell()
        local item
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.legion.war.ResultCell.new()
            cell:addChild(item)
            cell.item = item
        end
        cell.item:render(idx + 1)

        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:reloadData()
    return tableView
end

function ResultList:updateTitle()
    if self.infoEntity.round > 0 then
        self.title:setString(qy.TextUtil:substitute(53027, self.infoEntity:getWarName(), self.infoEntity.round))
    else
        self.title:setString(qy.TextUtil:substitute(53028))
    end
end

function ResultList:update(_isShowAnim)
    if self.infoEntity:getGameStage() ~= self.model.STAGE_FINAL then
        self:updateTitle()
        if tolua.cast(self.list,"cc.Node") then
            self.list:reloadData()
            if _isShowAnim then
                self:anim()
            end
        end
    end
end

function ResultList:anim()
    local count = 1
    self.list:setTouchEnabled(false)
    self.list:setContentOffset(cc.p(0,self.list:getContentOffset().y + CELL_HIGHT * self.cell_num), false)
    local offsetY = self.list:getContentOffset().y
    function scrollTableView()
        if count <= self.cell_num then
            self.list:setContentOffset(cc.p(0,offsetY - CELL_HIGHT * count), true)
            count = count + 1
            if count == self.cell_num then
                -- 直接播放战斗
                local watch_combat_id = self.model:getWatchCombatId()
                if watch_combat_id > 0 then
                    service:showCombat(watch_combat_id,function()
                        qy.tank.manager.ScenesManager:pushBattleScene()
                    end)
                end
            end
        else
            self.list:setTouchEnabled(true)
            self.list:stopAllActions()
        end
    end

    if self.cell_num > 0 then
        local seq = cc.Sequence:create(cc.DelayTime:create(0.8) ,cc.CallFunc:create(scrollTableView))
        self.list:runAction(cc.RepeatForever:create(seq))
    end
end

function ResultList:createFinalList()
    if not tolua.cast(self.list,"cc.Node") then
        self.list = qy.tank.view.legion.war.FinalResultCell.new({["callback"] = function()
            if self.params and self.params.callback then
                self.params.callback()
            end
        end,["updateTitle"] = function()
            self:updateTitle()
        end})
        self:addChild(self.list)
        self.list:setPosition(0,0)
    end
end

function ResultList:createOtherList()
    if not tolua.cast(self.list,"cc.Node") then
        self.list = self:createList()
        self:addChild(self.list)
        self.list:setPosition(0,0)
    end
end

function ResultList:createWatchView()
    if not tolua.cast(self.watchCell,"cc.Node") then
        self.watchCell = qy.tank.view.legion.war.WatchCell.new()
        self:addChild(self.watchCell)
        self.watchCell:setPosition(0,0)
    end
end

function ResultList:onEnter()
    if self.model:getLastTab() == 1 then
        if self.infoEntity:getGameStage() == self.model.STAGE_FINAL then
            self:createFinalList()
        else
            self:createOtherList()
        end
    else
        if self.model:isFinalStageCombat() then
            self:createWatchView()
        else
            self:createOtherList()
        end
    end

end

return ResultList
