--[[
	登陆作战
	Author: Aaron Wei
	Date: 2016-03-05 14:30:01
]]

local MainDialog = qy.class("MainDialog", qy.tank.view.BaseDialog, "login_total.ui.MainDialog")

function MainDialog:ctor()
    MainDialog.super.ctor(self)
    self:setCanceledOnTouchOutside(true)
    self.model = require("login_total.src.Model")
    self.service = require("login_total.src.Service")

    self:InjectView("panel")
    self:InjectView("closeBtn")
    self:InjectView("des")
    self:InjectView("date")

    self.des:setLineHeight(40)

   	self:OnClick("closeBtn", function()
        self:removeSelf()
    end,{["audioType"] = qy.SoundType.COMMON_CLICK, ["isScale"] = false})

end

function MainDialog:onEnter()
	-- self.date:setString(os.date("%Y年%m月%d日%H时%M分%S秒",self.model.start_time))
	self.date:setString(os.date(qy.TextUtil:substitute(55003),self.model.end_time))


    local tableView = cc.TableView:create(cc.size(570, 425))
	tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	if qy.language == "cn" then 
		tableView:setPosition(-45,-130)
	else
		tableView:setPosition(293,20)
	end
	self.panel:addChild(tableView)
	tableView:setDelegate()

	local function numberOfCellsInTableView(table)
		return #self.model.list
	end

	local function tableCellTouched(table,cell)
	end

	local function cellSizeForTable(tableView, idx)
		return 720, 150
	end

	local function tableCellAtIndex(table, idx)
		local cell = table:dequeueCell()
		if nil == cell then
			cell = cc.TableViewCell:new()
			local item = require("login_total.src.Cell").new({
				["draw"] = function (day)
					self.service:getAward(day,function()
						tableView:reloadData()
					end)
				end
			})
			cell:addChild(item)
			cell.item = item
		end
		cell.item:render(self.model.list[idx + 1])
		return cell
	end

	tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
	tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
	tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
	tableView:reloadData()
	return tableView
end

function MainDialog:onExit()
    print("MainDialog:onExit")
    -- qy.Event.remove(self.timeListener)
    -- self.timeListener = nil
end

function MainDialog:onCleanup()
    print("WorldBossView:onCleanup")
    -- qy.Event.remove(self.timeListener)
    -- self.timeListener = nil
end

return MainDialog

