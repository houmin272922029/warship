

local MainDialog = qy.class("MainDialog", qy.tank.view.BaseDialog, "login_fund/ui/Layer")

function MainDialog:ctor(delegate)
    MainDialog.super.ctor(self)
    self.model = qy.tank.model.LoginFundModel
    self.service = qy.tank.service.LoginFundService

	self:InjectView("Btn_close")
	self:InjectView("Btn_open")
	self:InjectView("Text_time")
	self:InjectView("bg")
	self:InjectView("kaiqi")
	self:InjectView("yikaiqi")

	self.type = 1

	for i=1,3 do
        self:InjectView("Btn_"..i)
        self:InjectView("Sprite_"..i)

        self:OnClick("Btn_"..i,function(sender)
        	self.type = i
        	self:update()
	    end)
    end


    self:OnClick("Btn_close",function(sender)    	
        self:removeSelf()
    end)


    self:OnClick("Btn_open",function(sender) 
    	if self.Btn_open:isBright() then
	    	local data
	    	if self.type == 1 then
	    		data = qy.tank.model.RechargeModel.data["tk198"]
	    	elseif self.type == 2 then
	    		data = qy.tank.model.RechargeModel.data["tk328"]
	    	elseif self.type == 3 then
	    		data = qy.tank.model.RechargeModel.data["tk648"]
	    	end


	        qy.tank.service.RechargeService:paymentBegin(data, function(flag, msg)
	            if flag == 3 then
	                self.toast = qy.tank.widget.Toast.new()
	                self.toast:make(self.toast, qy.TextUtil:substitute(58001))
	                self.toast:addTo(qy.App.runningScene, 1000)
	            elseif flag == true then
	                self.toast:removeSelf()
	                self.service:get(function(data)	                	
		                self:update()
	                end)
	                qy.hint:show(qy.TextUtil:substitute(58002))
	            else
	                self.toast:removeSelf()
	                qy.hint:show(msg)
	            end
	        end)
	    end
    end)

    self.bg:addChild(self:__createList())

    self:update()

end



function MainDialog:updateBt()
    if self.type == 1 then
        self.Sprite_1:setVisible(true)
        self.Sprite_2:setVisible(false)
        self.Sprite_3:setVisible(false)

        self.Btn_1:setBright(false)
        self.Btn_2:setBright(true)
        self.Btn_3:setBright(true)
    elseif self.type == 2 then
        self.Sprite_1:setVisible(false)
        self.Sprite_2:setVisible(true)
        self.Sprite_3:setVisible(false)

        self.Btn_1:setBright(true)
        self.Btn_2:setBright(false)
        self.Btn_3:setBright(true)
    else
        self.Sprite_1:setVisible(false)
        self.Sprite_2:setVisible(false)
        self.Sprite_3:setVisible(true)

        self.Btn_1:setBright(true)
        self.Btn_2:setBright(true)
        self.Btn_3:setBright(false)
    end 
end


function MainDialog:__createList()
	local tableView = cc.TableView:create(cc.size(650, 400))
	tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	tableView:setPosition(215, 30)


	local function numberOfCellsInTableView(table)
		return 5
	end

	local function tableCellTouched(table,cell)
	end

	local function cellSizeForTable(tableView, idx)
		return 650, 150
	end

	local function tableCellAtIndex(table, idx)
		local cell = table:dequeueCell()
		local item
		if nil == cell then
			cell = cc.TableViewCell:new()
			item = require("login_fund.src.Cell").new()
			cell:addChild(item)
			cell.item = item
		end
		cell.item.idx = idx
		cell.item:render(idx+1, self.model.award_list[self.type]["award_"..idx+1], self.type)
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
    self.tableView:reloadData()
    self:updateBt()

    local num = self.model.list[tostring(self.type)]["buy"]

    if num == 0 then
    	self.Btn_open:setBright(true)
    	self.kaiqi:setVisible(true)
    	self.yikaiqi:setVisible(false)
    elseif num == 1 then
    	self.Btn_open:setBright(false)
    	self.kaiqi:setVisible(false)
    	self.yikaiqi:setVisible(true)
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
