--[[--
    
--]]--

local GouWuChe = qy.class("GouWuChe", qy.tank.view.BaseView, "coupon_shop/ui/GouWuChe")

function GouWuChe:ctor(delegate)
    GouWuChe.super.ctor(self)
    self.model = qy.tank.model.CouponShopModel
    -- self.dataCf = self.model:ReturnActivityCf()
    self:InjectView("yuanbao")
    self:InjectView("zhekou")
    self:InjectView("ssyuanbao")
    self:InjectView("Panel_1")
    self:createTableView()

    self:UpdateDate()
end

function GouWuChe:render(idx)
    self.yuanbao:setString("1")
    self.zhekou:setString("1")
    self.ssyuanbao:setString("1")

end

function GouWuChe:createTableView()

    local widt = 738
    local tableView = cc.TableView:create(cc.size(widt,326))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setAnchorPoint(0,0)
    tableView:ignoreAnchorPointForPosition(false)
    local function numberOfCellsInTableView(tablev)
       -- local num = table.nums(self.dataCf)
        return 5
    end

    local function cellSizeForTable(table, idx)
        return widt, 140
    end

    local function tableCellAtIndex(table, idx)
        local cell = table:dequeueCell()
        local item
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("coupon_shop.src.GouWuCheCell").new({
                ["updateList"] = function()
                    tableView:reloadData()
                end,
                ["CloseParentFun"] = function()
                    self.CloseParentFun()
                end
            })
            cell:addChild(item)
            cell.item = item
        end
        local num = idx + 1
        cell.item:render(num)
        return cell
    end
    tableView:setPosition(263,113)
    tableView:setPosition(0,0)

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:reloadData()

    self._tableView = tableView

    if self._tableView == nil then
        print("================nil=====")
        return
    end
    self:addChild( self._tableView,999 )
end


function GouWuChe:UpdateDate(  )

end



return GouWuChe