--[[--
--开服礼包dialog
--Author: H.X.Sun
--Date: 2015-06-24
--]]--

local ServerGiftDialog = qy.class("ServerGiftDialog", qy.tank.view.BaseDialog, "view/operatingActivities/openServerGift/ServerGiftDialog")

function ServerGiftDialog:ctor()
    ServerGiftDialog.super.ctor(self)
	self.model = qy.tank.model.OperatingActivitiesModel
	--通用弹窗样式
	local style = qy.tank.view.style.DialogStyle2.new({
		size = cc.size(696,604),
		position = cc.p(0,0),
		offset = cc.p(-0.5,0),
		titleUrl = "Resources/common/title/server_gift_title.png",

		["onClose"] = function() 
			self:dismiss()
		end
	})
	-- style.bg:setContentSize(bdSize)
	-- style:removeChild(style.bg)
	self:addChild(style, -1)
	self:InjectView("container")
	-- self:InjectView("bg")
	-- self.bg:setLocalZOrder(-2)

	self.giftList = self:__createList()
	self.container:addChild(self.giftList)

	-- self:__bindingClickEvent()
end

function ServerGiftDialog:__createList()
	local tableView = cc.TableView:create(cc.size(635, 455))
	tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	tableView:setPosition(-320,-282)
	tableView:setDelegate()

	local function numberOfCellsInTableView(table)
		return self.model:getNumOfServerGift()
	end

	local function tableCellTouched(table,cell)
	end

	local function cellSizeForTable(tableView, idx)
		return 635, 147
	end

	local function tableCellAtIndex(table, idx)
		local cell = table:dequeueCell()
		local item
		if nil == cell then
			cell = cc.TableViewCell:new()
			item = qy.tank.view.operatingActivities.openServerGift.ServerGiftCell.new({
				["callBack"] = function ()
					self:updateList()
				end,
				["day"] = idx + 1
			})
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

function ServerGiftDialog:updateList()
	if self.giftList ~= nil then
		local listCurY = self.giftList:getContentOffset().y
		self.giftList:reloadData()
		self.giftList:setContentOffset(cc.p(0,listCurY))
	end
end

return ServerGiftDialog