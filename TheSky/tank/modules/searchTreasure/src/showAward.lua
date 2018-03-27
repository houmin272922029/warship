local showAward = qy.class("showAward", qy.tank.view.BaseDialog, "searchTreasure.ui.showAward")

local model = qy.tank.model.OperatingActivitiesModel
local service = qy.tank.service.OperatingActivitiesService
function showAward:ctor(delegate)
   	showAward.super.ctor(self)
   	self.delegate = delegate
    self:InjectView("Button_1")
    self:InjectView("Image_1")
    self:InjectView("Sprite_9")
    
    self.style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(650,480),
        position = cc.p(0,0),
        offset = cc.p(4,0), 

        ["onClose"] = function()
            self:dismiss()
        end
    }) 
    self.style.title_bg:setVisible(false)
    self:addChild(self.style , -1)
    self.Image_1:addChild(self:createItemList())

    self:refreshButton()
    self:OnClick("Button_1", function()
   		local aType = qy.tank.view.type.ModuleType
   			service:getCommonGiftAward({
   				["type"] = 2,
                ["times"] = self.delegate.idx,
                ["activity_name"] = aType.SEARCH_TREASURE
            }, aType.SEARCH_TREASURE,false, function(reData)
                self:refreshButton()
                qy.Event.dispatch(qy.Event.SEARCH_TREASURE)

                self:removeSelf()
        	end)
   	end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})
end

function showAward:refreshButton()
    self.Sprite_9:setVisible(false)
	if model.times >= model.timesAwardList[self.delegate.idx].times then
    	if  model.award_list == nil or table.keyof(model.award_list, model.timesAwardList[self.delegate.idx].ID) == nil then
        else
            self.Sprite_9:setVisible(true)
            self.Button_1:setVisible(false)
        end
    else
    	self.Button_1:setEnabled(false)
    end
end
function showAward:createItemList()
	local tableView = cc.TableView:create(cc.size(545, 300))
	tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	tableView:setPosition(0, 15)


	local data = model.timesAwardList


	local function numberOfCellsInTableView(tableView)
        return math.floor((#data[self.delegate.idx].timesAwardList - 1) / 3 + 1)
    end

    local function cellSizeForTable(tableView,idx)
        return 545, 130
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("searchTreasure.src.awardCell").new(self)
            cell:addChild(item)
            cell.item = item
        end

        cell.item:setData(data[self.delegate.idx], idx)
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    
    tableView:reloadData()
    self.tableView = tableView
    return tableView
end

function showAward:onEnter()
    
end

function showAward:onExit()

end

return showAward