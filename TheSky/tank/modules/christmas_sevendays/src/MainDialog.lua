

local MainDialog = qy.class("MainDialog", qy.tank.view.BaseDialog, "christmas_sevendays/ui/MainDialog")

function MainDialog:ctor(delegate)
    MainDialog.super.ctor(self)
    self.model = qy.tank.model.OperatingActivitiesModel
	self:InjectView("clostBt")
	self:InjectView("time")--时间
	self:InjectView("allmubiao")
	self:InjectView("Panel")
	for i=1,5 do
        self:InjectView("day"..i)
        self:InjectView("hongdian"..i)
        self:InjectView("suo"..i)
        self["suo"..i]:setVisible(true)
        self["hongdian"..i]:setVisible(false)
    end
    for i=1,3 do
        self:InjectView("Bt"..i)
        self:InjectView("task"..i)
        self:InjectView("btdian"..i)
        self["btdian"..i]:setVisible(false)
    end
    self:OnClick("day1",function ( sender )
    	self:choosedayBt(1)
    end)
     self:OnClick("day2",function ( sender )
    	self:choosedayBt(2)
    end)
    self:OnClick("day3",function ( sender )
    	self:choosedayBt(3)
    end)
       self:OnClick("day4",function ( sender )
    	self:choosedayBt(4)
    end)
    self:OnClick("day5",function ( sender )
    	self:choosedayBt(5)
    end)
    self:OnClick("Bt1",function ( sender )
    	self:updateBt(1)
    	self:updateBttask(self.chooseday,1)--开始默认选择第一个
    	-- body
    end)
    self:OnClick("Bt2",function ( sender )
    	self:updateBt(2)
    	self:updateBttask(self.chooseday,2)--开始默认选择第一个
    	-- body
    end)
    self:OnClick("Bt3",function ( sender )
    	self:updateBt(3)
    	 self:updateBttask(self.chooseday,3)--开始默认选择第一个
    	-- body
    end)
	self:OnClick("clostBt", function(sender)
        self:removeSelf()
    end)
    self:OnClick("allmubiao", function(sender)
        local dialog = require("christmas_sevendays.src.AwardDialog").new()
        dialog:show(true)
    end)
	self:updateBt(1)
	self.day = self.model.christmas_day > 5 and 5 or self.model.christmas_day--总天数
	self.chooseday = self.day--选择的天
	self:updateDayBt(self.chooseday)
    self:updateBttask(self.chooseday,1)--开始默认选择第一个
    for i=1,self.day do
    	self["suo"..i]:setVisible(false)
    end

end
function MainDialog:updateBttask( day ,idx)
	print("第几天啊",day,"第几个啊",idx)
	local data = self.model.christmascfg[tostring(day)]
	local data2 = self.model:getDaydate(day)
	for i=1,3 do
		local value = data["group_id"..i]
		print("--------------",value)
		local data2 = self.model:getDaydate(value)
		-- print("+++++++++++++++",json.encode(data2))
		self["task"..i]:setString(data2[1].title)
	end
	self.Panel:removeAllChildren()
	self.datalist = self:__createList(data["group_id"..idx])
    self.Panel:addChild(self.datalist)

end

function MainDialog:choosedayBt( day )
	if day > self.day then
		 qy.hint:show("活动未开启")
		return
	end
	if self.chooseday ~= day then
		self.chooseday = day
		self:updateDayBt(day)
		self:updateBttask(day,1)
		self:updateBt(1)
	end
end
function MainDialog:updateDayBt(day)
	for i=1,5 do
		if i == day then
			self["day"..i]:loadTexture("christmas_sevendays/res/anniu2.png",1)
		else
			self["day"..i]:loadTexture("christmas_sevendays/res/anniu1.png",1)
		end
	end
end
function MainDialog:updateBt( type1 )
    if type1 == 1 then
        self.Bt1:setEnabled(false)
        self.Bt2:setEnabled(true)
        self.Bt3:setEnabled(true)
    elseif type1 == 2 then
        self.Bt1:setEnabled(true)
        self.Bt2:setEnabled(false)
        self.Bt3:setEnabled(true)
    else
  		self.Bt1:setEnabled(true)
        self.Bt2:setEnabled(true)
        self.Bt3:setEnabled(false)
    end
 
end

function MainDialog:__createList(_idx)
	local tableView = cc.TableView:create(cc.size(580, 410))
	tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	tableView:setPosition(0,0)
	tableView:setDelegate()
	local data2 = self.model:getDaydate(_idx)
	-- print("+++++++++++++++",json.encode(data2))

	local function numberOfCellsInTableView(table)
		return #data2
	end

	local function tableCellTouched(table,cell)
	end

	local function cellSizeForTable(tableView, idx)
		return 580, 142
	end

	local function tableCellAtIndex(table, idx)
		local cell = table:dequeueCell()
		local item
		if nil == cell then
			cell = cc.TableViewCell:new()
			item = require("christmas_sevendays.src.Cell").new({
				["value"] = _idx,
				["data"]= data2,
				["callback"] = function ()
					tableView:reloadData()
				end,
				["dismiss"] = function (  )
					self:removeSelf()
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
function MainDialog:onEnter()
	if self.model.christmas_endtime - qy.tank.model.UserInfoModel.serverTime <= 0 then
         self.time:setString("活动已结束")
    else
    	self.time:setString(qy.tank.utils.DateFormatUtil:toDateString(self.model.christmas_endtime - qy.tank.model.UserInfoModel.serverTime, 7))
    	self.listener_1 = qy.Event.add(qy.Event.BONUS_TIME,function(event)
        self.time:setString(qy.tank.utils.DateFormatUtil:toDateString(self.model.christmas_endtime - qy.tank.model.UserInfoModel.serverTime, 7))
    end)
    end
 
    
end

function MainDialog:onExit()
    qy.Event.remove(self.listener_1)
  
end


return MainDialog
