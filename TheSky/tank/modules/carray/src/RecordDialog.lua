local RecordDialog = qy.class("RecordDialog", qy.tank.view.BaseView, "carray.ui.RecordDialog")

local model = qy.tank.model.CarrayModel
function RecordDialog:ctor(delegate, controller)
   	RecordDialog.super.ctor(self)

    -- self:setCanceledOnTouchOutside(true)
    local style = qy.tank.view.style.ViewStyle1.new({
        titleUrl = "carray/res/yayunjilu1.png", 
        showHome = false,
        ["onExit"] = function()
            delegate.viewStack:pop()
        end
    })
    self:addChild(style)
   	self:InjectView("BG")
   	self:InjectView("Image_1")

    self.Image_1:setLocalZOrder(1)

    self.BG:addChild(self:createView())

    self.richText = ccui.RichText:create()
end

function RecordDialog:createView()
	local tableView = cc.TableView:create(cc.size(1000, 545))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setTouchEnabled(true)
    -- tableView:setSwallowTouches(false)
    tableView:setPosition(0, 0)

    local data = model.log

    local function numberOfCellsInTableView(tableView)
        return #data
    end

    local function cellSizeForTable(tableView,idx)
        return 1000, 98
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        -- local data = model:getList(idx)
        -- local height = model:getHeight(idx)
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("carray.src.RecordItemView").new()
            cell:addChild(item)
            cell.item = item
        end

        cell.item:setData(idx, data[idx + 1])
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    
    tableView:reloadData()

    return tableView
end

return RecordDialog
