local FactionRank = qy.class("FactionRank", qy.tank.view.BaseDialog, "service_faction_war/ui/FactionRank")

local model = qy.tank.model.ServerFactionModel
local service = qy.tank.service.ServerFactionService

function FactionRank:ctor(delegate)
	FactionRank.super.ctor(self)
    -- self.delegate = delegate

    self:InjectView("closeBt")--我的名次
    
   	self:OnClick("closeBt",function()
        self:dismiss()
    end)
  	self:InjectView("listbg")--排行榜


  	self.tab = qy.tank.widget.TabButtonGroup.new("widget/TabButton4",{"铁血轴心", "均衡仲裁","自由同盟"},cc.size(185,67),"h",function(idx)
        self:createContent(idx)
    end, 1,{cc.c3b(251, 48, 0),cc.c3b(46, 190, 83),cc.c3b(36, 174, 242)})
    self.tab:setPosition(qy.winSize.width/2-385,qy.winSize.height-248)
    self.tab:setLocalZOrder(4)
    self:addChild(self.tab)

  	
 
end
function FactionRank:createContent(_idx)
	self.listbg:removeAllChildren(true)
    if _idx == 1 then
        self.list1 = self:__createList(model.ranklist1)
  		self.listbg:addChild(self.list1)
    elseif _idx == 2 then
        self.list1 = self:__createList(model.ranklist2)
  		self.listbg:addChild(self.list1)
    else
		self.list1 = self:__createList(model.ranklist3)
	  	self.listbg:addChild(self.list1)
    end

end
function FactionRank:__createList(data)
	local tableView = cc.TableView:create(cc.size(820, 370))
	tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	tableView:setPosition(5,10)
	tableView:setDelegate()

	local function numberOfCellsInTableView(table)
		return #data
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
			item =  require("service_faction_war.src.RankCell").new()
			cell:addChild(item)
			cell.item = item
		end
		cell.item.idx = idx
		cell.item:render(idx+1,data[idx +1])
		return cell
	end

	tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
	tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
	tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
	tableView:reloadData()
	return tableView
end
return FactionRank
