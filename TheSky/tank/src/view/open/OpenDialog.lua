--[[
    功能开启提示
]]

local OpenDialog = qy.class("OpenDialog", qy.tank.view.BaseDialog,"view/open/OpenDialog")
local OpenModel = qy.tank.model.OpenModel
local model = qy.tank.model.UserInfoModel
function OpenDialog:ctor(delegate)
    OpenDialog.super.ctor(self)
    self:InjectView("close")
    self:InjectView("tv_Bg")
    for i=1,2 do
        self:InjectView("cell"..i)
        self:InjectView("name"..i)
        self:InjectView("levelopen"..i)
        self:InjectView("des"..i)
        self:InjectView("icon"..i)
    end
    self:OnClick("close", function()
        self:removeSelf()
    end,{["isScale"] = false})

    self.tv_Bg:addChild(self:createView())
end

function OpenDialog:createView()
    local tableView = cc.TableView:create(cc.size(525, 205))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(0, 0)
    local data = OpenModel:getOpenArray(model.userInfoEntity.level)

    local function numberOfCellsInTableView(tableView)
        return #data
    end

    local function cellSizeForTable(tableView,idx)
        return 524, 100
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.open.ItemCell.new()
            cell:addChild(item)
            cell.item = item
        end

        cell.item.idx = idx
        cell.item:setData(data[idx+1])
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    
    tableView:reloadData()
    self.tableView = tableView
    return tableView
end

return OpenDialog