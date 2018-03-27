--[[
	最强之战-晋级名单
	Author: H.X.Sun
]]

local PromotionCell = qy.class("PromotionCell", qy.tank.view.BaseView, "greatest_race/ui/PromotionCell")

local NumberUtil = qy.tank.utils.NumberUtil

function PromotionCell:ctor(delegate)
    PromotionCell.super.ctor(self)

    self:InjectView("name_bg")
    self:InjectView("rank")
    self:InjectView("time")
    self:InjectView("time_title")
    self.model = qy.tank.model.GreatestRaceModel

    local list = self:__createList()
    self.name_bg:addChild(list)
    -- list:setPosition(0,-3)
    list:setTouchEnabled(false)
end

function PromotionCell:__createList()
	local tableView = cc.TableView:create(cc.size(600, 420))
	tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	tableView:setDelegate()

	local function numberOfCellsInTableView(table)
		return self.model:getRankNum()
	end

	local function tableCellTouched(table,cell)
	end

	local function cellSizeForTable(tableView, idx)
		return 600, 30
	end

	local function tableCellAtIndex(table, idx)
		local cell = table:dequeueCell()
		local item
		if nil == cell then
			cell = cc.TableViewCell:new()
			item = qy.tank.view.greatest_race.PromotionName.new()
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

function PromotionCell:update()
    local time = self.model:getEndTime()
    if time > 0 then
        self.time:setString(NumberUtil.secondsToTimeStr(time,1))
    elseif time == 0 then
        self.time:setString("00:00:00")
        qy.Event.dispatch(qy.Event.GREATEST_RACE_UPDATE)
    elseif time < -self.model:getDelayTime() then
        -- 3s 延时
        self.time:setString("00:00:00")
        if not self.model:getErrorStatus() then
            qy.tank.view.greatest_race.ErrorDialog.new():show(true)
        end
    end
end

function PromotionCell:onEnter()
    self.rank:setString(qy.TextUtil:substitute(90213)..self.model:getMyRank())
    self.time_title:setString(qy.TextUtil:substitute(90214)..self.model:getNextMacthTitle()..qy.TextUtil:substitute(90215))
end

return PromotionCell
