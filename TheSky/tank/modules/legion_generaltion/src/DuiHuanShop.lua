--[[--
	
--]]--

local DuiHuanShop = qy.class("DuiHuanShop", qy.tank.view.BaseView, "legion_generaltion/ui/DuiHuanShop")

function DuiHuanShop:ctor(delegate)
    DuiHuanShop.super.ctor(self)
    self.model = qy.tank.model.LegionGeneraltionModel
    self.service = qy.tank.service.LegionGeneraltionService
    self:InjectView("BG")
    self:InjectView("Panel_1")
   -- self.BG:setVisible(false)

   self.delegate = delegate

    self:Init()

    -- 钻石商城
    self:OnClick("ZuanShibtn",function(sender)
        self.mIndexShop = 1
        self._tableView:reloadData()
    end)



    -- 购物卡商城
    self:OnClick("GouWuKabtn",function(sender)
        print("222")

        self.mIndexShop = 2
        self._tableView:reloadData()
    end)

    self:UpdateDate()

end

function DuiHuanShop:Init()

    self.mIndexShop = 1
    self:createTableView()
end

function DuiHuanShop:UpdateDate(  )
end

function DuiHuanShop:createTableView()

    local widt = 400
    local tableView = cc.TableView:create(cc.size(648,400))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setAnchorPoint(0,0)
    tableView:ignoreAnchorPointForPosition(false)
    local function numberOfCellsInTableView(tablev)
        local num = 0
        if self.mIndexShop == 1 then
            num = #self.model.DiamondShop
        else
            num = #self.model.BuyShop
        end
        return math.ceil(num/3)
    end

    local function cellSizeForTable(table, idx)
        return 640, 256
    end

    local function tableCellAtIndex(table, idx)
        local cell = table:dequeueCell()
        local item
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("legion_generaltion.src.ShangChengCellMax").new({
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
        local data = {}
        data.mIndexShop = self.mIndexShop
        data.delegate = self.delegate
        cell.item:render(num,data)
        return cell
    end
    tableView:setPosition(-3,0)

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:reloadData()

    self._tableView = tableView

    if self._tableView == nil then
        print("================nil=====")
        return
    end
    self.Panel_1:addChild( self._tableView,999 )
end
return DuiHuanShop