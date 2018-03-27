--[[
	最强之战-报名
	Author: H.X.Sun
]]

local SignUpCell = qy.class("SignUpCell", qy.tank.view.BaseView, "greatest_race/ui/SignUpCell")

local UserInfoModel = qy.tank.model.UserInfoModel
local NumberUtil = qy.tank.utils.NumberUtil

function SignUpCell:ctor(delegate)
    SignUpCell.super.ctor(self)
    self.model = qy.tank.model.GreatestRaceModel
    local service = qy.tank.service.GreatestRaceService

    self:InjectView("tip_1")
    self:InjectView("tip_2")
    self:InjectView("btn")
    self:InjectView("name_bg")
    self:InjectView("time")
    self.tip_1:setString(qy.TextUtil:substitute(90216, self.model:getLevelForSignUp()))
    self.tip_2:setString(qy.TextUtil:substitute(90217, self.model:getLevelForSupport()))

    self:OnClick("btn", function()
        if self.model:isSignUp() then
            qy.hint:show(qy.TextUtil:substitute(90218))
        elseif UserInfoModel.userInfoEntity.level >= self.model:getLevelForSignUp() then
            service:sign(function()
                qy.hint:show(qy.TextUtil:substitute(90219))
                self:updateBtnStatus()
                self:updateList()
            end)
        else
            qy.hint:show(qy.TextUtil:substitute(90220))
        end
    end)

    self.list = self:__createList()
    self.name_bg:addChild(self.list)
    self.list:setTouchEnabled(false)

    self:updateBtnStatus()
end

function SignUpCell:updateList()
    self.list:reloadData()
end

function SignUpCell:updateBtnStatus()
    if self.model:isSignUp() then
        self.btn:setBright(false)
    elseif UserInfoModel.userInfoEntity.level >= self.model:getLevelForSignUp() then
        self.btn:setBright(true)
    else
        self.btn:setBright(false)
    end
end

function SignUpCell:__createList()
	local tableView = cc.TableView:create(cc.size(530, 192))
	tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	tableView:setPosition(0,3)
	tableView:setDelegate()

	local function numberOfCellsInTableView(table)
		return 5
	end

	local function tableCellTouched(table,cell)
	end

	local function cellSizeForTable(tableView, idx)
		return 530, 38
	end

	local function tableCellAtIndex(table, idx)
		local cell = table:dequeueCell()
		local item
		if nil == cell then
			cell = cc.TableViewCell:new()
			item = qy.tank.view.greatest_race.SignUpName.new()
			cell:addChild(item)
			cell.item = item
		end
		cell.item:render(idx)
		return cell
	end

	tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
	tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
	tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
	tableView:reloadData()
	return tableView
end

function SignUpCell:updateTime()
    local time = self.model:getEndTime()
    if time > 0 then
        self.time:setString(NumberUtil.secondsToTimeStr(time,6))
    elseif time == 0 then
        self.time:setString(qy.TextUtil:substitute(90221))
        qy.Event.dispatch(qy.Event.GREATEST_RACE_UPDATE)
    elseif time < -self.model:getDelayTime() then
        -- 3s 延时
        self.time:setString("00:00:00")
        if not self.model:getErrorStatus() then
            qy.tank.view.greatest_race.ErrorDialog.new():show(true)
        end
    end
end

return SignUpCell
