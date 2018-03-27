--[[--
--将士之战宝箱信息dialog
--Author: Fu.Qiang
--Date: 2016-07-04
--]]--


local ChestDetailsDialog = qy.class("ChestDetailsDialog", qy.tank.view.BaseDialog, "beat_enemy.ui.ChestDetailsDialog")

local model = qy.tank.model.BeatEnemyModel
local service = qy.tank.service.BeatEnemyService
function ChestDetailsDialog:ctor(delegate, data, type)
    ChestDetailsDialog.super.ctor(self)

	self:InjectView("Panel")
	self:InjectView("Close")
    self:InjectView("bg")
    self:InjectView("Btn_receive")
    self:InjectView("lingqu")
    self:InjectView("yilingqu")
    self:InjectView("weidacheng")

	self:OnClick(self.Close, function(sender)
        self:removeSelf()
    end,{["isScale"] = false})

    self.data = data

    self.list = self:__createList()
    self.bg:addChild(self.list, 1)

    if type == "open" then
        self.lingqu:setVisible(true)
        self.Btn_receive:setBright(true)
    elseif type == "empty" then
        self.yilingqu:setVisible(true)
        self.Btn_receive:setBright(false)
    else
        self.weidacheng:setVisible(true)
        self.Btn_receive:setBright(false)
    end

    self:OnClick(self.Btn_receive, function(sender)
        if type == "open" then
            service:getAward(function(data)
                if data.award then
                    delegate:update()
                
                    self.lingqu:setVisible(false)
                    self.yilingqu:setVisible(true)
                    self.Btn_receive:setBright(false)

                    qy.tank.command.AwardCommand:add(data.award)
                    qy.tank.command.AwardCommand:show(data.award)
                end
            end, 2, self.data.id)
        end
    end,{["isScale"] = false})
end



function ChestDetailsDialog:__createList()
    local tableView = cc.TableView:create(cc.size(390, 250))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(11,98)
    tableView:setDelegate()

    local function numberOfCellsInTableView(table)
        return #self.data.award
    end

    local function tableCellTouched(table,cell)
    end

    local function cellSizeForTable(tableView, idx)
        return 420, 100
    end

    local function tableCellAtIndex(table, idx)
        local cell = table:dequeueCell()
        local item
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("beat_enemy.src.ChestDetailsCell").new(self)
            cell:addChild(item)
            cell.item = item
        end

        if self.first and idx < self.nums then
            cell.item:render(self.data.award[idx + 1], true)
        else
            cell.item:render(self.data.award[idx + 1], false)
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




return ChestDetailsDialog