--[[
	最强之战-对战时用户信息
	Author: H.X.Sun
]]

local UserInfoCell = qy.class("UserInfoCell", qy.tank.view.BaseView, "greatest_race/ui/UserInfoCell")

local UserResUtil = qy.tank.utils.UserResUtil
local UserInfoModel = qy.tank.model.UserInfoModel

function UserInfoCell:ctor(delegate)
    UserInfoCell.super.ctor(self)
    self.delegate = delegate
    self:InjectView("info_node")
    self:InjectView("empty_node")
    self:InjectView("icon_head")
    -- self:InjectView("first_icon")
    self:InjectView("btn")
    self:InjectView("btn_txt")
    self:InjectView("name")
    self:InjectView("score")
    self:InjectView("legion")
    self:InjectView("server")
    self:InjectView("rank")
    self:InjectView("supporter")
    self:InjectView("combat_bg")
    self.model = qy.tank.model.GreatestRaceModel
    local service = qy.tank.service.GreatestRaceService

    self.index = delegate.index

    self:OnClick("btn",function()
        if self.model:isSupported() then
            qy.hint:show(qy.TextUtil:substitute(90222))
        elseif self.model:getCurrentAction() == self.model.ACTION_CALC then
            qy.hint:show(qy.TextUtil:substitute(90223))
        elseif self.model:getCurrentId() == self.model.ID_MATCH then
            -- 同步阵法
            service:sync(function()
                delegate.callback()
                self:updateDes()
                qy.hint:show(qy.TextUtil:substitute(90224))
            end)
        else
            -- 支持
            if self.model:getCurrentAction() == self.model.ACTION_GROUP then
                qy.hint:show(qy.TextUtil:substitute(90225))
            else
                service:support(self.index, function()
                    self.model:addSupportByIndex(self.index)
                    delegate.callback()
                end)
            end
        end
    end)
end

function UserInfoCell:updateInfo()
    if tolua.cast(self.list,"cc.Node") then
        self.combat_bg:removeChild(self.list)
    end

    self.info_node:setVisible(true)
    self.empty_node:setVisible(false)
    local data = self.model:getVsDataByUserIndex(self.index)
    if self.index == 0 then
        if self.model:getCurrentId() == self.model.ID_MATCH then
            if data.kid == UserInfoModel.userInfoEntity.kid then
                self.btn_txt:setSpriteFrame("greatest_race/res/tongbu.png")
            else
                self.btn:setVisible(false)
            end
        else
            self.btn_txt:setSpriteFrame("greatest_race/res/zhichi.png")
            if self.model:getCurrentAction() == self.model.ACTION_GROUP then
                self:waitForServer()
            end
        end
    else
        if self.model:getCurrentAction() == self.model.ACTION_GROUP or self.model:getCurrentAction() == self.model.ACTION_WAIT then
            -- 决赛期间的分组
            self.info_node:setVisible(false)
            self.empty_node:setVisible(true)
            self.isViewNeedUpdate = true
        elseif self.model:getCurrentId() == self.model.ID_MATCH then
            if data.kid == UserInfoModel.userInfoEntity.kid then
                self.btn_txt:setSpriteFrame("greatest_race/res/tongbu.png")
            else
                self.btn:setVisible(false)
            end
        else
            self.btn_txt:setSpriteFrame("greatest_race/res/zhichi.png")
        end
    end

    if not self.isViewNeedUpdate then
        self:updateDes()

        self.list = self:__createList(data.log)
        self.combat_bg:addChild(self.list)
        self.list:setPosition(0,4)
    end
end

function UserInfoCell:updateDes()
    local data = self.model:getVsDataByUserIndex(self.index)
    local icon = UserResUtil.getRoleIconByHeadType(data.headicon)
    self.icon_head:setTexture(icon)
    self.name:setString(data.name)
    self.score:setString(qy.TextUtil:substitute(90226).." "..data.results)
    self.legion:setString(qy.TextUtil:substitute(90227).." "..data.legion)
    self.server:setString(qy.TextUtil:substitute(90228)..data.server)
    self.rank:setString(qy.TextUtil:substitute(90229)..data.rank)
end

function UserInfoCell:updateSupport()
    if self.model:getCurrentAction() ~= self.model.ACTION_GROUP and self.model:getCurrentAction() ~= self.model.ACTION_WAIT then
        if self.isViewNeedUpdate then
            self.isViewNeedUpdate = false
            self:updateInfo()
        end
    end
    if not self.isViewNeedUpdate then
        self.supporter:setString(qy.TextUtil:substitute(90230).."  "..self.model:getShowSupportNum(self.index))
    end

    -- if self.index == 0 then
    --     self.first_icon:setVisible(self.model:isLeftPriority())
    -- else
    --     self.first_icon:setVisible(not self.model:isLeftPriority())
    -- end
end

function UserInfoCell:waitForServer()
    self.btn:setBright(false)
    self.btn:setTouchEnabled(false)
    self.is_waiting = true
end

function UserInfoCell:__createList(log_data)
	local tableView = cc.TableView:create(cc.size(400, 253))
	tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	tableView:setDelegate()

	local function numberOfCellsInTableView(table)
		return #log_data
	end

	local function tableCellTouched(table,cell)
	end

	local function cellSizeForTable(tableView, idx)
		return 400, 80
	end

	local function tableCellAtIndex(table, idx)
		local cell = table:dequeueCell()
		local item
		if nil == cell then
			cell = cc.TableViewCell:new()
			item = qy.tank.view.greatest_race.CombatCell.new()
			cell:addChild(item)
			cell.item = item
		end
		cell.item:render(log_data[idx + 1])
		return cell
	end

	tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
	tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
	tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
	tableView:reloadData()
	return tableView
end

function UserInfoCell:onEnter()
    self:updateInfo()
end

return UserInfoCell
