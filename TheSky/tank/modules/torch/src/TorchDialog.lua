--[[
	火炬行动
	Author: Your Name
	Date: 2016-01-04 17:23:12
]]

local TorchDialog = qy.class("TorchDialog", qy.tank.view.BaseDialog, "torch.ui.TorchDialog")
local RedDotModel = qy.tank.model.RedDotModel

function TorchDialog:ctor()
    TorchDialog.super.ctor(self)
    self:setCanceledOnTouchOutside(true)
    self.model = require("torch.src.TorchModel")
    self.service = require("torch.src.TorchService")
    self.today = self.model.day
    self.chooseDay = self.model.day
    self.userInfo = qy.tank.model.UserInfoModel

    self:InjectView("cd1")
    self:InjectView("cd2")
    local function updateTime()
        if self.model then
            local end_time = self.model.end_time-self.userInfo.serverTime
            if end_time > 0 then
                self.cd1:setString(qy.tank.utils.DateFormatUtil:toDateString1(end_time,1))
            else
                self.cd1:setString(qy.TextUtil:substitute(68001))
            end

            local award_end_time = self.model.award_end_time-self.userInfo.serverTime
            if award_end_time > 0 then
                self.cd2:setString(qy.tank.utils.DateFormatUtil:toDateString1(award_end_time,1))
            else
                self.cd2:setString(qy.TextUtil:substitute(68001))
            end
        end
    end
    updateTime()
    self.timeListener = qy.Event.add(qy.Runtime.TIMER_UPDATE,function(event)
        updateTime()
    end)

    for i = 1,7 do
    	self:InjectView("item"..i)
		self:OnClick("item"..i, function()
			if i <= self.today then
    			self:onDayChange(i)
    		else
    			qy.hint:show(qy.TextUtil:substitute(68002))
    		end
    	end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = true})
   	end

    self:OnClick("previewBtn", function()
        local preview = require("torch.src.PreviewDialog").new()
        preview:show()
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})

   	self:OnClick("closeBtn", function()
        self:removeSelf()
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})

    self:InjectView("panel")
    self.panel:setLocalZOrder(1)

    self.tabBar = qy.tank.widget.TabButtonGroup.new("widget/TabButton2",{qy.TextUtil:substitute(68003), qy.TextUtil:substitute(68004), qy.TextUtil:substitute(68005), qy.TextUtil:substitute(68006)},cc.size(159,70),"h",function(idx)
        self.tabIdx = idx
        if idx ~= 4 then
            if not tolua.cast(self.list,"cc.Node") then
                self.list =  self:createList()
                self.panel:addChild(self.list)
            else
                self.list:reloadData()
            end
            self:removePurchase()
        else
            self.list:reloadData()
            self:createPurchase()
        end
    end)
    self.panel:addChild(self.tabBar)
    self.tabBar:setPosition(-375,205)

    self:onDayChange(self.today)
end

function TorchDialog:onEnter()
    local _uiArr = {}
    for i = 1,4 do
        _uiArr[qy.RedDotType["TORCH_TAB_"..i]] = self.tabBar.btns[i]
    end
    for i = 1, 7 do
        _uiArr[qy.RedDotType["TORCH_D_"..i]] = self["item"..i]
    end
    qy.RedDotCommand:addSignal(_uiArr)
    qy.RedDotCommand:updateTorchRedDot(self.today)
end

function TorchDialog:onExit()
    print("TorchDialog:onExit")
    qy.Event.remove(self.timeListener)
    self.timeListener = nil

    local redType = {}
    for i = 1,4 do
        table.insert(redType,qy.RedDotType["TORCH_TAB_"..i])
    end
    for i = 1, 7 do
        table.insert(redType,qy.RedDotType["TORCH_D_"..i])
    end
    qy.RedDotCommand:removeSignal(redType)
     qy.RedDotCommand:emitSignal(qy.RedDotType.TORCH, RedDotModel:isTorchHasDot())
end

function TorchDialog:onCleanup()
    print("WorldBossView:onCleanup")
    qy.Event.remove(self.timeListener)
    self.timeListener = nil
end

function TorchDialog:onDayChange(idx)
    local tabs = {}
    table.insert(tabs,{qy.TextUtil:substitute(68003),qy.TextUtil:substitute(68007),qy.TextUtil:substitute(68004),qy.TextUtil:substitute(68006)})
    table.insert(tabs,{qy.TextUtil:substitute(68003),qy.TextUtil:substitute(68008),qy.TextUtil:substitute(68009),qy.TextUtil:substitute(68006)})
    table.insert(tabs,{qy.TextUtil:substitute(68003),qy.TextUtil:substitute(68010),qy.TextUtil:substitute(68011),qy.TextUtil:substitute(68006)})
    table.insert(tabs,{qy.TextUtil:substitute(68003),qy.TextUtil:substitute(68012),qy.TextUtil:substitute(68013),qy.TextUtil:substitute(68006)})
    table.insert(tabs,{qy.TextUtil:substitute(68003),qy.TextUtil:substitute(68014),qy.TextUtil:substitute(68015),qy.TextUtil:substitute(68006)})
    table.insert(tabs,{qy.TextUtil:substitute(68003),qy.TextUtil:substitute(68016),qy.TextUtil:substitute(68017),qy.TextUtil:substitute(68006)})
    table.insert(tabs,{qy.TextUtil:substitute(68003),qy.TextUtil:substitute(68018),qy.TextUtil:substitute(68019),qy.TextUtil:substitute(68006)})

    self.tabBar:setTabNames(tabs[idx])
    qy.RedDotCommand:updateTorchRedDot(idx)

	self.chooseDay = idx
	local item
	for i=1,7 do
		item = self["item"..i]
		if i == 7 then
			item:loadTexture("torch/res/hjxd06.jpg",0)
		else
			item:loadTexture("torch/res/hjxd04.jpg",0)
		end
	end

	item = self["item"..idx]
	if i == 7 then
	   item:loadTexture("torch/res/hjxd07.jpg",0)
    else
       item:loadTexture("torch/res/hjxd05.jpg",0)
    end

    if self.tabIdx ~= 4 then
        self.list:reloadData()
    else
        self:removePurchase()
        self:createPurchase(self.chooseDay)
    end
end

function TorchDialog:createList()
    local h = 420
    local tableView = cc.TableView:create(cc.size(630,h))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(-373,-h+200)
    tableView:setDelegate()

    local function numberOfCellsInTableView(table)
        if self.tabIdx == 1 then
            return #self.model.list[self.chooseDay].daily_welfare
        elseif self.tabIdx == 2 then
            return #self.model.list[self.chooseDay].task1
        elseif self.tabIdx == 3 then
            return #self.model.list[self.chooseDay].task2
        elseif self.tabIdx == 4 then
            return 0
        end
    end

    local function tableCellTouched(table,cell)
        print("cell touched at index: " .. cell:getIdx())
    end

    local function cellSizeForTable(tableView, idx)
        return 627, 144
    end

    local function tableCellAtIndex(table, idx)
        local strValue = string.format("%d",idx)
        local cell = table:dequeueCell()
        local item = nil
        local label = nil
        if nil == cell then
            cell = cc.TableViewCell:new()
            if self.tabIdx == 1 or self.tabIdx == 2 or self.tabIdx == 3 then
            	item = require("torch.src.TorchCell").new({
            		["draw"] = function(entity)
            			local service = require("torch.src.TorchService").new()
					    service:draw(entity.day,self.tabIdx,entity.id,function(data)
                            entity.is_draw = 1
                            RedDotModel:updateTRedDotByDay(entity.day,true)
                            qy.RedDotCommand:updateTorchRedDot(entity.day)
                            -- self.list:reloadData()
                            item:render(entity)
					    	qy.tank.command.AwardCommand:add(data.award)
        					qy.tank.command.AwardCommand:show(data.award)
					    end)
            		end,
            		["goto"] = function(viewId)
                        --前往当前任务
                        print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>> view_id",viewId)
                        qy.tank.utils.ModuleUtil.viewRedirectByViewId(viewId,function ()
                            self:removeSelf()
                        end)
            		end
            	})
            end
            cell:addChild(item)
            cell.item = item
        end

        if self.tabIdx == 1 then
            cell.item:render(self.model.list[self.chooseDay].daily_welfare[idx+1])
        elseif self.tabIdx == 2 then
            cell.item:render(self.model.list[self.chooseDay].task1[idx+1])
        elseif self.tabIdx == 3 then
            cell.item:render(self.model.list[self.chooseDay].task2[idx+1])
        end
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)

    tableView:reloadData()

    return tableView
end

function TorchDialog:createPurchase()
    if self.chooseDay == 7 then
        self.purchase = require("torch.src.TorchPurchase2").new({
            ["onPurchase"] = function()
                local service = require("torch.src.TorchService").new()
                service:buy(self.chooseDay,function(data)
                    qy.tank.command.AwardCommand:add(data.award)
                    qy.tank.command.AwardCommand:show(data.award)
                    self.model.my_buy[tostring(self.chooseDay)] = 1
                    RedDotModel:updateTRedDotByDay(self.chooseDay,true)
                    qy.RedDotCommand:updateTorchRedDot(self.chooseDay)
                    self.purchase:render(self.model.list[self.chooseDay].buy)
                end)
            end
        })
        self.purchase:setPosition(-60,-10)
        self.purchase:render(self.model.list[self.chooseDay].buy)
    else
        self.purchase = require("torch.src.TorchPurchase1").new({
            ["onPurchase"] = function()
                local service = require("torch.src.TorchService").new()
                service:buy(self.chooseDay,function(data)
                    qy.tank.command.AwardCommand:add(data.award)
                    qy.tank.command.AwardCommand:show(data.award)
                    self.model.my_buy[tostring(self.chooseDay)] = 1
                    RedDotModel:updateTRedDotByDay(self.chooseDay,true)
                    qy.RedDotCommand:updateTorchRedDot(self.chooseDay)
                    self.purchase:render(self.model.list[self.chooseDay].buy)
                end)
            end
        })
        self.purchase:setPosition(-55,-80)
        self.purchase:render(self.model.list[self.chooseDay].buy)
    end
    self.panel:addChild(self.purchase)
end

function TorchDialog:removePurchase()
    if tolua.cast(self.purchase,"cc.Node") then
        self.panel:removeChild(self.purchase)
    end
end

return TorchDialog
