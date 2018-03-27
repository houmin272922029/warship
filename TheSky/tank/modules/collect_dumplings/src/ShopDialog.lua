

local ShopDialog = qy.class("ShopDialog", qy.tank.view.BaseDialog, "collect_dumplings/ui/ShopDialog")

local service = qy.tank.service.CollectDumpingsService
local StorageModel = qy.tank.model.StorageModel

function ShopDialog:ctor(delegate)
    ShopDialog.super.ctor(self)
    self.model = qy.tank.model.CollectDumpingsModel
	self:InjectView("closeBt")
	self:InjectView("pannel")
	for i=1,8 do
        self:InjectView("num"..i)
    end
    self:OnClick("closeBt", function(sender)
        self:removeSelf()
    end)
	self.list = self:__createList()
	self.pannel:addChild(self.list)
	self:updatenums()

end
function ShopDialog:updatenums(  )
	for i=1,8 do
		id = i + 130
        self["num"..i]:setString(StorageModel:getPropNumByID(id))
    end
end

function ShopDialog:__createList()
	local tableView = cc.TableView:create(cc.size(890, 430))
	tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	tableView:setPosition(0,0)
	tableView:setDelegate()
	local data2 = self.model:Getshoplistnum()
	-- print("+++++++++++++++",json.encode(data2))

	local function numberOfCellsInTableView(table)
		return data2
	end

	local function tableCellTouched(table,cell)
	end

	local function cellSizeForTable(tableView, idx)
		return 890, 105
	end

	local function tableCellAtIndex(table, idx)
		local cell = table:dequeueCell()
		local item
		if nil == cell then
			cell = cc.TableViewCell:new()
			item = require("collect_dumplings.src.ShopCell").new({
				["callback"] = function ()
					self:updatenums()
				end
			})
			cell:addChild(item)
			cell.item = item
		end
		cell.item.idx = idx
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


return ShopDialog
