local ShopDialog = qy.class("ShopDialog", qy.tank.view.BaseDialog, "service_faction_war/ui/ShopDialog")

local model = qy.tank.model.ServerFactionModel
local service = qy.tank.service.ServerFactionService

function ShopDialog:ctor(delegate)
	ShopDialog.super.ctor(self)
    -- self.delegate = delegate

    self:InjectView("closeBt")--我的名次
    
   	self:OnClick("closeBt",function()
   		qy.Event.dispatch(qy.Event.REFRESHMAINVIEW)
        self:dismiss()
    end)
  	self:InjectView("listbg")--排行榜

  	local my_camp = model.userinfo.camp
  	self.tab = qy.tank.widget.TabButtonGroup.new("widget/TabButton4",{"铁血轴心", "均衡仲裁","自由同盟"},cc.size(185,67),"h",function(idx)
        self:createContent(idx)
    end, my_camp,{cc.c3b(251, 48, 0),cc.c3b(46, 190, 83),cc.c3b(36, 174, 242)})
    self.tab:setPosition(qy.winSize.width/2-410,qy.winSize.height-205)
    self.tab:setLocalZOrder(4)
    self:addChild(self.tab)

  	
 
end
function ShopDialog:createContent( idx )
	self.idx = idx
	self.listbg:removeAllChildren(true)
	self.list1 = self:__createList()
  	self.listbg:addChild(self.list1)
end
function ShopDialog:__createList()
	local tableView = cc.TableView:create(cc.size(820, 370))
	tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	tableView:setPosition(5,8)
	tableView:setDelegate()

	local function numberOfCellsInTableView(table)
		if self.idx == 1 then
			return model.RedList_length
		elseif self.idx == 2 then
			return model.GreenList_length
		else
			return model.BlueList_length
		end
		
	end

	local function tableCellTouched(table,cell)
	end

	local function cellSizeForTable(tableView, idx)
		return 820, 140
	end

	local function tableCellAtIndex(table, idx)
		local cell = table:dequeueCell()
		local item
		if nil == cell then
			cell = cc.TableViewCell:new()
			item =  require("service_faction_war.src.ShopCell").new({
				["callback"] = function (  )
					local listCurY = self.tableView:getContentOffset().y
					self.tableView:reloadData()
					self.tableView:setContentOffset(cc.p(0,listCurY))
				end

				})
			cell:addChild(item)
			cell.item = item
		end
		cell.item.idx = idx
		cell.item:render(idx+1,self.idx)
		return cell
	end

	tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
	tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
	tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
	tableView:reloadData()
	self.tableView = tableView 
	return tableView
end
return ShopDialog
