local ChooseDialog = qy.class("ChooseDialog", qy.tank.view.BaseView, "carray.ui.ChooseDialog")

local service = qy.tank.service.CarrayService
local model = qy.tank.model.CarrayModel
function ChooseDialog:ctor(delegate)
   	ChooseDialog.super.ctor(self)

   	self:InjectView("BG")
   	self:InjectView("Num_1")
   	self:InjectView("Name")
    self:InjectView("Info")

   	self:OnClick("Btn_fresh", function()
        service:appoint(function()
            self.tableView:reloadData()
            local data = model:atRescours(model.appointQuality)
            self.Name:setString(data.name)
            self.Name:setTextColor(qy.tank.utils.ColorMapUtil.qualityMapColor(tostring(model.appointQuality)))
            self.Num_1:setVisible(model.appointTimes >= 3)

            self.Info:setVisible(model.appointTimes < 3)
            local times = 3 - model.appointTimes
            self.Info:setString(qy.TextUtil:substitute(44007) .. times)
            if model.appointQuality > model.oldQuality then
                qy.hint:show(qy.TextUtil:substitute(44008))
            else
                qy.hint:show(qy.TextUtil:substitute(44009))
            end
        end)
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})

    self:OnClick("Btn_choose", function()
        service:confirmAppoint(function()
            delegate:update()
            delegate:dismiss()
        end)        
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})

    self.BG:addChild(self:createView())
    self.Num_1:setVisible(model.appointTimes >= 3)
    self.Info:setVisible(model.appointTimes < 3)
    local times = 3 - model.appointTimes
    self.Info:setString(qy.TextUtil:substitute(44007) .. times)
    local data = model:atRescours(model.appointQuality)
    self.Name:setString(data.name)
    self.Name:setTextColor(qy.tank.utils.ColorMapUtil.qualityMapColor(tostring(model.appointQuality)))
end

function ChooseDialog:createView()
	local tableView = cc.TableView:create(cc.size(750, 395))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    -- tableView:setSwallowTouches(false)
    tableView:setTouchEnabled(false)
    tableView:setPosition(10, -100)

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
            item = require("carray.src.ChooseItemView").new()
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

return ChooseDialog
