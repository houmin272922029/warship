--[[
	军资整备 商店
	Author: H.X.Sun
]]
local ShopDialog = qy.class("ShopDialog", qy.tank.view.BaseDialog, "military_supply/ui/ShopDialog")

function ShopDialog:ctor(param)
   	ShopDialog.super.ctor(self)
    self:InjectView("cell_bg")
    self:InjectView("title_txt")

    self.model = qy.tank.model.OperatingActivitiesModel

    self:OnClick("closeBtn",function()
        self:dismiss()
    end)

    self.shopList = self:createItemList()
    self.cell_bg:addChild(self.shopList)
end

--创建商品列表
function ShopDialog:createItemList()
    local tableView = cc.TableView:create(cc.size(740, 430))
    tableView:setDirection(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(3,5)

    local function numberOfCellsInTableView(tableView)
        return math.ceil(self.model:getMilitaryGoodsNum() / 2)
    end

    local function cellSizeForTable(tableView, idx)
        return 320, 430
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.operatingActivities.military_supply.ShopItem.new({
                ["isTouchMoved"] = function()
                    return tableView:isTouchMoved()
                end,
                ["updateList"] = function()
                    self:updateList()
                end
            })
            cell:addChild(item)
            cell.item = item
        end
        cell.item:render(idx + 1)
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)

    tableView:reloadData()

    return tableView
end

function ShopDialog:updateList()
    local x = self.shopList:getContentOffset().x
    self.shopList:reloadData()
    self.shopList:setContentOffset(cc.p(x,0))
end

function ShopDialog:updateResource()
    self.title_txt:setString(qy.TextUtil:substitute(90115)..qy.tank.model.UserInfoModel.userInfoEntity:getTicketStr())
end

function ShopDialog:onEnter()
    self.userResourceDatalistener = qy.Event.add(qy.Event.USER_RESOURCE_DATA_UPDATE,function(event)
        self:updateResource()
    end)
    self:updateResource()
end

function ShopDialog:onExit()
    qy.Event.remove(self.userResourceDatalistener)
end

return ShopDialog
