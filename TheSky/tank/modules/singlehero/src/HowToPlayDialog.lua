--[[
    关卡攻略 dialog
]]
local HowToPlayDialog = qy.class("HowToPlayDialog", qy.tank.view.BaseDialog, "view/campaign/HowToPlayDialog")

local model = qy.tank.model.SingleHeroModel
function HowToPlayDialog:ctor(delegate)
    HowToPlayDialog.super.ctor(self)

    self:InjectView("closeBtn")

    self:OnClick(self.closeBtn, function()
        self:dismiss()
    end)
    self:setCanceledOnTouchOutside(true)
    -- 通用弹窗样式
    self.style = qy.tank.view.style.DialogStyle5.new({
        size = cc.size(533,495),
        position = cc.p(0,0),
        offset = cc.p(0,0),
        titleUrl = "Resources/campaign/tongguangonglue.png",

        -- ["onClose"] = function()
        --     delegate.isClose()
        --     self:dismiss()
        -- end
    })
    self:addChild(self.style)
    self.style:setLocalZOrder(-1)

    self.delegate = delegate
    self:createTableView(1)

    

    -- -- local title = cc.Label:createWithSystemFont("通关捷报",nil,24,cc.size(0,0),cc.TEXT_ALIGNMENT_LEFT,cc.VERTICAL_TEXT_ALIGNMENT_TOP)
    -- title:setTextColor(cc.c4b(255,255,255,255))
    -- title:setPosition(qy.winSize.width / 2,609)
    -- self:addChild(title)

end

function HowToPlayDialog:createTableView(idx)
    local tableView = cc.TableView:create(cc.size(500,355))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(15, 90)
    -- tableView:setAnchorPoint(0, 0)
    -- tableView:setDelegate()
    --    tableView:setTouchEnabled(false)
    self.style.bg:addChild(tableView)

    local function numberOfCellsInTableView(tableView)
        return #model.playList
    end

    local function cellSizeForTable(tableView, idx)
        return 500, 95
    end

    local function tableCellAtIndex(table, idx)
        local strValue = string.format("%d",idx)
        print("---createTableView---tableCellAtIndex------->rollNum = ",rollNum)
        local cell = table:dequeueCell()
        local label = nil
        if nil == cell then
            cell = cc.TableViewCell:new()
            local item =  require("singlehero.src.HowToPlayItem").new(self.delegate)

            cell:addChild(item)
            cell.item = item
        end

        cell.item:update(model.playList[idx+1])

        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:reloadData()

    return tableView
end
function HowToPlayDialog:showDetail()

end

return HowToPlayDialog
