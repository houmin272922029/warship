--[[--
--服务器区列表	dialog
--Author: H.X.Sun
--Date: 2015-07-28
--]]

local DistrictDialog = qy.class("DistrictDialog", qy.tank.view.BaseDialog, "view/login/DistrictDialog")

function DistrictDialog:ctor(delegate)
    DistrictDialog.super.ctor(self)

	self.delegate = delegate
	self:InjectView("container")
	self:InjectView("bg")
	self:InjectView("districtName")
	self:InjectView("statusTxt")
	self.bg:setContentSize(qy.winSize.width, qy.winSize.height)
	--关闭
	self:OnClick("bg", function()
		self:dismiss()
	end, {["isScale"] = false})
	--进入游戏
	self:OnClick("confirmBtn", function()
		self:confirmLogic()
	end)
	self.districtList = self:__createList()
	self.container:addChild(self.districtList)

	self:__initViewData()
end

function DistrictDialog:confirmLogic()
	self.delegate.updateDistrict()
	self:dismiss()
end

function DistrictDialog:__initViewData()
	self.entity = qy.tank.model.LoginModel:getLastDistrictEntity()
	self.districtName:setString(self.entity.s_name .. "  " .. self.entity.name)
	self.statusTxt:setString(self.entity:getStatusTxt())
	self.statusTxt:setTextColor(self.entity:getStatusColor())
end

function DistrictDialog:__createList()
	local tableView = cc.TableView:create(cc.size(710,330))
	tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	tableView:setPosition(-355,-255)
	tableView:setDelegate()

	local function numberOfCellsInTableView(table)
		return math.ceil(qy.tank.model.LoginModel:getDistrictNun() / 2)
	end

	local function tableCellTouched(table,cell)
	end

	local function cellSizeForTable(tableView, idx)
		return 710, 93
	end

	local function tableCellAtIndex(table, idx)
		local cell = table:dequeueCell()
		local item
		if nil == cell then
			cell = cc.TableViewCell:new()
			item = qy.tank.view.login.DistrictCell.new({
				["confirm"] = function ()
					self:confirmLogic()
				end
				})
			cell:addChild(item)
			cell.item = item
		end
		cell.item:update(idx * 2 + 1)
		return cell
	end

	tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    	tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
	tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
	tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
	tableView:reloadData()
	return tableView
end

return DistrictDialog
