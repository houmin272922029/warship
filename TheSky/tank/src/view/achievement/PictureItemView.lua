--[[
--图鉴
--Author: mingming
--Date:
]]

local PictureItemView = qy.class("PictureItemView", qy.tank.view.BaseView, "view/achievement/PictureItemView")

function PictureItemView:ctor(delegate)
	PictureItemView.super.ctor(self)
    self:InjectView("Title")
    self:InjectView("TitleName")
    self.delegate = delegate
end

function PictureItemView:setData(data, height, color)
	self.Title:setPositionY(height - 15)

	local title = color == 1 and qy.TextUtil:substitute(1016) or color == 2 and qy.TextUtil:substitute(1017) or color == 3 and qy.TextUtil:substitute(1018) or color == 4 and qy.TextUtil:substitute(1019) or color == 5 and qy.TextUtil:substitute(1020) or qy.TextUtil:substitute(1021)
	self.TitleName:setString(title)
	self.TitleName:setTextColor(qy.tank.utils.ColorMapUtil.qualityMapColor(tostring(color)))

	self:createItems(data, height)
end

function PictureItemView:createItems(data, height)
	local nums = math.ceil(#data / 3)

	local list = qy.Utils.oneToTwo(data, nums, 3)

	for i = 1, nums do
		local item = qy.tank.view.achievement.PictureFragment.new({
                ["data"] = list[i],
                ["callback"] = function(entity)
                	self.delegate.callback(entity)
            	end
            })
		item:setPositionY(height - 30 - i * 145)
		self:addChild(item)
	end

	-- local tableView = cc.TableView:create(cc.size(605, height - 20))
 --    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
 --    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
 --    tableView:setPosition(0, 25)
 --    -- self.panel:addChild(tableView)
 --    -- tableView:addChild(layer)
 --    tableView:setTouchEnabled(false)

 --    local function numberOfCellsInTableView(tableView)
 --        return 
 --    end

 --    local function cellSizeForTable(tableView, idx)
 --        return 605, 145
 --    end

 --    local function tableCellAtIndex(tableView, idx)
 --        local cell = tableView:dequeueCell()
 --        local item = nil
 --        local label = nil
 --        -- local data = model:getList(idx)
 --        -- local height = model:getHeight(idx)
 --        if nil == cell then
 --            cell = cc.TableViewCell:new()
 --            item = qy.tank.view.achievement.PictureFragment.new({
                
 --            })
 --            cell:addChild(item)
 --            cell.item = item
 --        end
 --        -- cell.item:setData(data, height, idx)
 --        return cell
 --    end

 --    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
 --    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
 --    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    
 --    tableView:reloadData()

 --    return tableView
end

return PictureItemView