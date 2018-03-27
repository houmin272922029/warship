

local PacketHistory = qy.class("PacketHistory", qy.tank.view.BaseDialog, "newyear_redpacket/ui/PacketHistory")

local model = qy.tank.model.RedPacketModel
local service = qy.tank.service.RedPacketService

function PacketHistory:ctor(delegate)
    PacketHistory.super.ctor(self)
	self:InjectView("closeBt")
	self:InjectView("bg")
	for i=1,2 do
        self:InjectView("Bt"..i)
    end
    for i=2,3 do
    	 self:InjectView("pannel"..i)
    	 self:InjectView("num"..i)
    	 self["pannel"..i]:setVisible(false)
    end
 
    self:OnClick("Bt1",function ( sender )
    	self:choosedayBt(1)
    end)
     self:OnClick("Bt2",function ( sender )
    	self:choosedayBt(2)
    end)
 
	self:OnClick("closeBt", function(sender)
        self:removeSelf()
    end)
	self.day = 1
	self.chooseday = 0
	self.flag = true
	self.flag2 = true
	self.page_num = 1
	self.page_num2 = 1
	self.rank_list = delegate.data.lists.info_list
	self.rank_list2 = delegate.data.listf.info_list
	self.data = delegate.data
	self:choosedayBt(1)
	self:updatepannel2()
	self:updatepannel3()
	
    
end
function PacketHistory:updatepannel2(  )
	-- 刷新和初始化pannel1--已发出
	self.num2:setString(self.data.listf.sum2)
	self.list2 = self:__createList()
	self.pannel2:addChild(self.list2)
end
function PacketHistory:updatepannel3(  )
	--已收到
	self.num3:setString(self.data.lists.sum1)
	self.list3 = self:__createList2()
	self.pannel3:addChild(self.list3)
end
function PacketHistory:choosedayBt( day )
	if self.chooseday ~= day then
		self.chooseday = day
		self:updateDayBt(day)
		if day == 2 then
			self.pannel2:setVisible(true)
			self.pannel3:setVisible(false)
		else
			self.pannel2:setVisible(false)
			self.pannel3:setVisible(true)
		end
	end
end
function PacketHistory:updateDayBt(day)
	for i=1,2 do
		if i == day then
			self["Bt"..i]:loadTexture("newyear_redpacket/res/anniuhuang.png",1)
		else
			self["Bt"..i]:loadTexture("newyear_redpacket/res/anniuhong.png",1)
		end
	end
end

function PacketHistory:__createList()
	local tableView = cc.TableView:create(cc.size(580, 400))
	tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	tableView:setPosition(10,40)
	tableView:setDelegate()

	local function numberOfCellsInTableView(tableView)
		return #self.rank_list2
	end

	local function tableCellTouched(tableView,cell)
	end

	local function cellSizeForTable(tableView, idx)
		return 580, 36
	end

	local function tableCellAtIndex(tableView, idx)
		local cell = tableView:dequeueCell()
		local item
		if nil == cell then
			cell = cc.TableViewCell:new()
			item = require("newyear_redpacket.src.HistoryCell").new({
				["value"] = 2,
				["data"] = self.rank_list2,
			})
			cell:addChild(item)
			cell.item = item
		end
		cell.item.idx = idx
		cell.item:render(idx + 1)
		-- print("ssssssssssssssss111",idx+1)
		if idx+1 == #self.rank_list2 and self.flag  and #self.rank_list2 >= 15 then
            print(self.tableView:getContentOffset().y)
            self.page_num = self.page_num + 1
            service:getRankList("xf", self.page_num,function(data)
            	-- print("ssssssssssssssss",json.encode(data))
                table.insertto(self.rank_list2, data.listf.info_list)

                if #data.listf.info_list < 15 then
                    self.flag = false
                end

                local y = self.tableView:getContentOffset().y
                y = y - #data.listf.info_list * 36

                self.tableView:reloadData()
                self.tableView:setContentOffset(cc.p(0, y))

            end)
    	end
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
function PacketHistory:__createList2()
	local tableView = cc.TableView:create(cc.size(580, 400))
	tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	tableView:setPosition(0,40)
	tableView:setDelegate()

	local function numberOfCellsInTableView(tableView)
		return #self.rank_list
	end

	local function tableCellTouched(tableView,cell)
	end

	local function cellSizeForTable(tableView, idx)
		return 580, 36
	end

	local function tableCellAtIndex(tableView, idx)
		local cell = tableView:dequeueCell()
		local item
		if nil == cell then
			cell = cc.TableViewCell:new()
			item = require("newyear_redpacket.src.HistoryCell").new({
				["value"] = 1,
				["data"] = self.rank_list
			})
			cell:addChild(item)
			cell.item = item
		end
		cell.item.idx = idx
		cell.item:render(idx + 1)
		if idx+1 == #self.rank_list and self.flag2 and #self.rank_list >= 15 then
            print(self.tableView2:getContentOffset().y)
            self.page_num2 = self.page_num2 + 1
            service:getRankList("xs",self.page_num2,function(data)
                table.insertto(self.rank_list, data.lists.info_list)

                if #data.lists.info_list < 15 then
                    self.flag2 = false
                end

                local y = self.tableView2:getContentOffset().y
                y = y - #data.lists.info_list * 36

                self.tableView2:reloadData()
                self.tableView2:setContentOffset(cc.p(0, y))

            end)
    	end
		return cell
	end


	tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
	tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
	tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
	tableView:reloadData()
	self.tableView2 = tableView
	return tableView
end
function PacketHistory:onEnter()
     
end

function PacketHistory:onExit()
  
end


return PacketHistory
