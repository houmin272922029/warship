

local MainDialog = qy.class("MainDialog", qy.tank.view.BaseDialog, "recharge_duty/ui/Layer")

function MainDialog:ctor(delegate)
    MainDialog.super.ctor(self)
    self.model = qy.tank.model.RechargeDutyModel
    self.service = qy.tank.service.RechargeDutyService

	self:InjectView("bg")
	self:InjectView("Btn_close")
	self:InjectView("Text_time")
	self:InjectView("Image")
	self:InjectView("Node")

	self.type = 1

	for i = 1, 5 do
        self:InjectView("Button_"..i)
        self:InjectView("suo_"..i)
        self:InjectView("icon_hd_"..i)

	    self:OnClick("Button_"..i, function(sender)
	    	if i > self.model.current_day then
	    		qy.hint:show("时间未到")
	    	else
		    	self.type = i
		    	self:update()
		    end
	    end)
    end


    self:OnClick("Btn_close",function(sender)    	
        self:removeSelf()
    end)

    self.Image:setSwallowTouches(false)
    self.Node:addChild(self:__createList())

    self:update()
    self:updateList()
end




function MainDialog:__createList()
	local tableView = cc.TableView:create(cc.size(680, 470))
	tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	tableView:setPosition(20, 20)


	local function numberOfCellsInTableView(table)
		return 5
	end

	local function tableCellTouched(table,cell)
	end

	local function cellSizeForTable(tableView, idx)
		return 675, 145
	end

	local function tableCellAtIndex(table, idx)
		local cell = table:dequeueCell()
		local item
		if nil == cell then
			cell = cc.TableViewCell:new()
			item = require("recharge_duty.src.Cell").new(self)
			cell:addChild(item)
			cell.item = item
		end
		cell.item.idx = idx
		cell.item:render(self.model.award_list[(self.type - 1) * 5 + idx + 1], (self.type - 1) * 5 + idx + 1)
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


function MainDialog:update()
	for i = 1, 5 do        
		self["Button_"..i]:setBright(true)
    end

    for i = 2, 5 do
    	if i > self.model.current_day then
	    	self["suo_"..i]:setVisible(true)
	    else
	    	self["suo_"..i]:setVisible(false)
	    end
    end

	self["Button_"..self.type]:setBright(false)
    self.tableView:reloadData()
end

function MainDialog:updateList()
    local listCurY = self.tableView:getContentOffset().y
    self.tableView:reloadData()
    self.tableView:setContentOffset(cc.p(0,listCurY))

    self:updateHd()
end


function MainDialog:updateHd()
	for i = 1, 5 do        
		self["icon_hd_"..i]:setVisible(false)
    end

	for i = 1, #self.model.award_list do
		if self.model.list[tostring(i)] then
			if self.model.list[tostring(i)].status == 1 then
				print(math.floor((i - 0.1) / 5) + 1)
				self["icon_hd_"..math.floor((i - 0.1) / 5) + 1]:setVisible(true)
			end
		end
	end
end



function MainDialog:updateTime()
    if self.Text_time then
        self.Text_time:setString(self.model:getRemainTime())
    end
end


function MainDialog:onEnter()
    self:update()

    self:updateTime()
    self.timeListener = qy.Event.add(qy.Runtime.TIMER_UPDATE,function(event)
        self:updateTime()
    end)
end

function MainDialog:onExit()
    qy.Event.remove(self.timeListener)
    self.timeListener = nil
end


return MainDialog
