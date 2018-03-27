--[[
	查看科技
	Author: Aaron Wei
	Date: 2015-09-09 20:45:55
]]

local ExamineTech = qy.class("ExamineTech", qy.tank.view.BaseView, "view/examine/ExamineTech")

function ExamineTech:ctor()
	ExamineTech.super.ctor(self)
	self.model = qy.tank.model.ExamineModel

	for i=1,4 do
		self:InjectView("cell_"..i)
		local cell = self["cell_"..i]
		local list = self.model.tech[i]
		if list then
			local tableView = cc.TableView:create(cc.size(400,90))
		    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
		    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
		    -- tableView:setPosition(((i-1)%2)*430+75,270-math.floor((i-1)/2)*175)
		    tableView:setPosition(15,7)
		    tableView:setDelegate()
		    cell:addChild(tableView)


		    local function numberOfCellsInTableView(table)
		    	return #list
		    end

		    local function tableCellTouched(table,cell)
		        print("cell touched at index: " .. cell:getIdx())
		    end

		    local function cellSizeForTable(tableView, idx)
		        return 160, 32
		    end

		    local function tableCellAtIndex(table, idx)
		        local strValue = string.format("%d",idx)
		        local cell = table:dequeueCell()
		        if nil == cell then
		            cell = cc.TableViewCell:new()
		
		            local name = cc.Label:createWithTTF("","Resources/font/ttf/black_body_2.TTF",22,cc.size(0,0),1)
        			name:setTextColor(cc.c4b(255, 255, 255,255))
        			name:enableOutline(cc.c4b(0,0,0,255),1)
		            name:setPosition(0,0)
		            name:setAnchorPoint(0,0)
		            cell:addChild(name)
		            cell.name = name

		            local value = cc.Label:createWithTTF("","Resources/font/ttf/black_body_2.TTF",22,cc.size(0,0),1)
        			value:setTextColor(cc.c4b(0, 255, 0,255))
        			value:enableOutline(cc.c4b(0,0,0,255),1)
		            value:setPosition(380,0)
		            value:setAnchorPoint(1,0)
		            cell:addChild(value)
		            cell.value = value

		        end
		        local data = list[idx+1]
		        cell.name:setString(data.name)
		        cell.value:setString(data.attr.."+"..tostring(data.value))
		        return cell
		    end

		    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
		    tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
		    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
		    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
		    
		    tableView:reloadData()
		else

		end
	end
end
	
return ExamineTech
