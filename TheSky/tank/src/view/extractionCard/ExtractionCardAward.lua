--[[
	军资基地(领奖页面)
	Date: 2016-04-28 16:52:17
]]
local ExtractionCardAward = qy.class("ExtractionCardAward", qy.tank.view.BaseView, "view/extractionCard/ExtractionCardAward")

local model = qy.tank.model.ExtractionCardModel
local userModel = qy.tank.model.UserInfoModel
function ExtractionCardAward:ctor(delegate)
	ExtractionCardAward.super.ctor(self)
	self.delegate = delegate
    self:InjectView("Text_14")
    self:InjectView("silverTxt")
    self:InjectView("diamondTxt")
	self:InjectView("BG")
	self:InjectView("closeBtn")
	self:InjectView("Left")
	self:InjectView("Right")
	self.Left:setPosition((display.width - 1080) / 2,0)
	self.Left:setLocalZOrder(10)
	self.Right:setPosition(display.width - (display.width - 1080) / 2,0)
	self.Right:setLocalZOrder(10)
    self.Left:setVisible(false)
    self.Right:setVisible(false)

    self.Text_14:setString(qy.TextUtil:substitute(90010, model.total_times))
    self.silverTxt:setString(userModel.userInfoEntity:getSilverStr())
    self.diamondTxt:setString(userModel.userInfoEntity:getDiamondStr())

	self:OnClick("closeBtn", function(sender)
        self.delegate:dismiss()
    end,{["audioType"] = qy.SoundType.BTN_CLOSE,["isScale"] = false})

	self:createList()
end

function ExtractionCardAward:createList()
	local awardList = cc.TableView:create(cc.size(1065, 600))
    self.awardList = awardList
	awardList:setDirection(cc.TABLEVIEW_FILL_TOPDOWN)
 	awardList:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    awardList:setPosition((qy.winSize.width - 1065) / 2,0)
    self:addChild(awardList,1)
    awardList:setDelegate()

    local function numberOfCellsInTableView(table)
        return #model.cfg
    end

    local function cellSizeForTable(tableView, idx)
        return 355, 505
    end

    local function tableCellAtIndex(table, idx)
        local cell = table:dequeueCell()
        local item
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.extractionCard.ExtractionCardAwardCell.new(self)

            cell:addChild(item)
            cell.item = item
        end
        cell.item:render(model.cfg[idx + 1])
        cell.item:setPosition(10,-30)
        cell.item:setAnchorPoint(0, 0)
        return cell
    end

    awardList:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    awardList:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    awardList:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    awardList:reloadData()
end

function ExtractionCardAward:isTouchMoved()
    return self.awardList:isTouchMoved()                    
end

function ExtractionCardAward:onEnter()
   
end

function ExtractionCardAward:onExit()

end

return ExtractionCardAward