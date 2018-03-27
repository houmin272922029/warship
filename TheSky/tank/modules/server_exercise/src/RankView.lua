local RankView = qy.class("RankView", qy.tank.view.BaseDialog, "server_exercise/ui/RankView")

local model = qy.tank.model.ServerExerciseModel

function RankView:ctor(delegate)
	RankView.super.ctor(self)
    -- self.delegate = delegate

    self:InjectView("mylevel")--我的名次
    
    local data = model.ranklist--判断当前状态

    local style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(590,520),
        position = cc.p(0,0),
        offset = cc.p(0,0),
        titleUrl = "Resources/common/title/ranking_title.png",--

        ["onClose"] = function()
            self:dismiss()
        end
    })
  	style:setPositionY(-60)
  	self:addChild(style,-10)

  	self:InjectView("list")--排行榜

  	self.list1 = self:__createList()
  	self.list:addChild(self.list1)
  	if data.rank == 0 then
  		self.mylevel:setString("我的排名:未上榜  积分:"..data.source)
  		
  	else
  		self.mylevel:setString("我的排名:"..data.rank.." 积分:"..data.source)
  	end
end
function RankView:__createList()
	local tableView = cc.TableView:create(cc.size(535, 305))
	tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	tableView:setPosition(0,0)
	tableView:setDelegate()
	print("排行榜数目",#model.ranklist.list)
	local function numberOfCellsInTableView(table)
		return #model.ranklist.list
	end

	local function tableCellTouched(table,cell)
	end

	local function cellSizeForTable(tableView, idx)
		return 535, 40
	end

	local function tableCellAtIndex(table, idx)
		local cell = table:dequeueCell()
		local item
		if nil == cell then
			cell = cc.TableViewCell:new()
			item =  require("server_exercise.src.RankCell").new()
			cell:addChild(item)
			cell.item = item
		end
		cell.item.idx = idx
		cell.item:render(idx+1)
		return cell
	end

	tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
	tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
	tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
	tableView:reloadData()
	return tableView
end
return RankView
