

local ShopDialog = qy.class("ShopDialog", qy.tank.view.BaseDialog, "taste_war/ui/ShopDialog")

local service = qy.tank.service.TasteWarService
local StorageModel = qy.tank.model.StorageModel

function ShopDialog:ctor(delegate)
    ShopDialog.super.ctor(self)
    self.model = qy.tank.model.TasteWarModel
       -- 通用弹窗样式
  	self.style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(660,560),
        position = cc.p(0,0),
        offset = cc.p(0,0),
        titleUrl = "taste_war/res/jifenshangdian.png",--ranking_title

        ["onClose"] = function()
            self:dismiss()
        end
 	 })
  	self.delegate = delegate
  	self.style:setPositionY(-20)
  	self:addChild(self.style,-1)
	self:InjectView("time")
	self:InjectView("list")
	  self.time:setString("兑换截至日期:"..self.model:Getawardtimes())
	self.list1 = self:__createList()
	self.list:addChild(self.list1,5)

end

function ShopDialog:__createList()
	local tableView = cc.TableView:create(cc.size(610, 420))
	tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	tableView:setPosition(10,5)
	tableView:setDelegate()
	local data2 = self.model:Getshoplistnum()
	-- print("+++++++++++++++",json.encode(data2))

	local function numberOfCellsInTableView(table)
		return data2
	end

	local function tableCellTouched(table,cell)
	end

	local function cellSizeForTable(tableView, idx)
		return 610, 114
	end

	local function tableCellAtIndex(table, idx)
		local cell = table:dequeueCell()
		local item
		if nil == cell then
			cell = cc.TableViewCell:new()
			item = require("taste_war.src.ShopCell").new({
				["callback"] = function ()
					self.delegate:callback()
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
