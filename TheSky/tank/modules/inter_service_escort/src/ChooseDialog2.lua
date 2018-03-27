local ChooseDialog = qy.class("ChooseDialog", qy.tank.view.BaseView, "inter_service_escort.ui.ChooseDialog")

local model = qy.tank.model.InterServiceEscortModel
local service = qy.tank.service.InterServiceEscortService
function ChooseDialog:ctor(delegate)
   	ChooseDialog.super.ctor(self)

   	self:InjectView("BG")
   	self:InjectView("Num_1")
   	self:InjectView("Name")
    self:InjectView("Info")
    self:InjectView("Node_award")

   	self:OnClick("Btn_fresh", function()
        service:appoint(function()
            self.tableView:reloadData()
            local data = model:atRescours(model.appointQuality)
            self.Name:setString(data.name)
            self.Name:setTextColor(qy.tank.utils.ColorMapUtil.qualityMapColor(tostring(model.appointQuality)))
            self.Num_1:setVisible(model.appointTimes == 0)
            self.Info:setVisible(model.appointTimes > 0)
            local times = model.appointTimes
            self.Info:setString(qy.TextUtil:substitute(44007) .. times)
            if model.appointQuality > model.oldQuality then
                qy.hint:show(qy.TextUtil:substitute(44008))
            else
                qy.hint:show(qy.TextUtil:substitute(44009))
            end

            self:updateAward(data.award)
        end)
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})

    self:OnClick("Btn_choose", function()
        service:confirmAppoint(function()
            delegate:update()
            delegate:dismiss()
        end)
        
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})

    self.BG:addChild(self:createView())
    self.Num_1:setVisible(model.appointTimes == 0)
    self.Info:setVisible(model.appointTimes > 0)
    local times = model.appointTimes
    self.Info:setString(qy.TextUtil:substitute(44007) .. times)
    local data = model:atRescours(model.appointQuality)
    self.Name:setString(data.name)
    self.Name:setTextColor(qy.tank.utils.ColorMapUtil.qualityMapColor(tostring(model.appointQuality)))
    self:updateAward(data.award)

    
end

function ChooseDialog:createView()
	local tableView = cc.TableView:create(cc.size(750, 395))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    -- tableView:setSwallowTouches(false)
    tableView:setTouchEnabled(false)
    tableView:setPosition(10, 15)

    -- local data = entity:getAttributelist()

    local function numberOfCellsInTableView(tableView)
        return 5
    end

    local function cellSizeForTable(tableView,idx)
        return 150, 250
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        local label = nil
        -- local data = model:getList(idx)
        -- local height = model:getHeight(idx)
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("inter_service_escort.src.ChooseItemView").new()
            cell:addChild(item)
            cell.item = item
        end

        cell.item:setData(idx)
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    
    tableView:reloadData()
    self.tableView = tableView

    return tableView
end


function ChooseDialog:updateAward(award)
    if self.award_1 then
        self.Node_award:removeChild(self.award_1)
        self.award_1 = nil
    end

    self.award_1 = qy.AwardList.new({
        ["award"] = award,
        ["cellSize"] = cc.size(115,180),
        ["type"] = 1,
        ["len"] = 4,
        ["itemSize"] = 2,
        ["hasName"] = false,
    })
    self.award_1:setPosition(55,230)
    self.Node_award:addChild(self.award_1)
end

return ChooseDialog
