local rankAwardView = qy.class("rankAwardView", qy.tank.view.BaseDialog, "searchTreasure.ui.rankAwardView")

local model = qy.tank.model.OperatingActivitiesModel
local service = qy.tank.service.OperatingActivitiesService

function rankAwardView:ctor(delegate)
   	rankAwardView.super.ctor(self)
   	self:setCanceledOnTouchOutside(true)

   	self.style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(820,540),
        position = cc.p(0,0),
        offset = cc.p(4,0), 
        titleUrl = "searchTreasure/res/paimingjiangliyulan.png",

        ["onClose"] = function()
            self:dismiss()
        end
    }) 

    self:addChild(self.style , -1)

   	self.delegate = delegate
   	self:InjectView("Node_1")
    self:InjectView("Sprite_2")
    self:InjectView("Sprite_4")
    self:InjectView("Sprite_5")
    self:InjectView("Button_1")
    self:InjectView("Image_1")
    self:InjectView("Text_2")
    self:InjectView("Text_4")
    self.Node_1:setPositionX(display.width / 2)
    self.Text_2:setString(model.searchTreasureCost)
    self.Text_4:setString(model.myrank == 0 and qy.TextUtil:substitute(46010) or (qy.TextUtil:substitute(50011).." "..model.myrank .. " "..qy.TextUtil:substitute(50012)))
    self.Sprite_2:setVisible(false)
    self:update()
    self:OnClick("Button_1", function()
	    	if model.endTime - qy.tank.model.UserInfoModel.serverTime <= 0 then
	    		local aType = qy.tank.view.type.ModuleType
	   			service:getCommonGiftAward({
	   				["type"] = 3,
	                ["activity_name"] = aType.SEARCH_TREASURE
	            }, aType.SEARCH_TREASURE,false, function(reData)
	                self:update()
	        	end)
			   	
	    	else
	    		qy.hint:show("活动尚未结束")
	    	end
   		end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})

    self.Image_1:addChild(self:createItemList())
end
function rankAwardView:update()

	if model.endTime - qy.tank.model.UserInfoModel.serverTime <= 0  and model.myrank > 0 then

		if model.rank_award_get == 0 then
            self.Button_1:setBright(true)
            -- self.Button_1:loadTextureNormal("Resources/common/button/btn_3.png")
            -- self.Button_1:loadTexturePressed("Resources/common/button/anniuhong02.png")
		-- elseif model.rank_award_get == 1 then

            -- self.Button_1:loadTextureNormal("Resources/common/button/anniuhui.png")
            -- self.Button_1:loadTexturePressed("Resources/common/button/anniuhui.png")
        else
             self.Button_1:setVisible(false)
             self.Sprite_2:setVisible(true)
			-- self.Button_1:loadTextureNormal("Resources/common/button/anniuhui.png")
   --          self.Button_1:loadTexturePressed("Resources/common/button/anniuhui.png")
		end
	else
        self.Button_1:setBright(false)
		-- self.Button_1:loadTextureNormal("Resources/common/button/anniuhui.png")
  --       self.Button_1:loadTexturePressed("Resources/common/button/anniuhui.png")
	end
end

function rankAwardView:createItemList()
	local tableView = cc.TableView:create(cc.size(720, 390))
	tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	tableView:setPosition(0, 8)

	local data = model.rankAwardList

	local function numberOfCellsInTableView(tableView)
        return #data
    end

    local function cellSizeForTable(tableView,idx)
        return 708, 145
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("searchTreasure.src.ItemView").new(self)
            cell:addChild(item)
            cell.item = item
        end
        cell.item.idx = idx
        cell.item:setData(data[(idx + 1)])
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    
    tableView:reloadData()
    self.tableView = tableView
    return tableView
end

function rankAwardView:onEnter()
    
end

function rankAwardView:onExit()

end

return rankAwardView