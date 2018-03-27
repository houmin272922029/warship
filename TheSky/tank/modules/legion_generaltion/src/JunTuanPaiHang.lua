--[[--
    
--]]--

local JunTuanPaiHang = qy.class("JunTuanPaiHang", qy.tank.view.BaseView, "legion_generaltion/ui/JunTuanPaiHang")

function JunTuanPaiHang:ctor(delegate)
    JunTuanPaiHang.super.ctor(self)
    self.model = qy.tank.model.LegionGeneraltionModel
    self:InjectView("shangbang")
    self:InjectView("BG")
    self:InjectView("RechageNum")
    self:InjectView("Panel_1")
    self:InjectView("Image_3")
    self:InjectView("Image_2")

    self:InjectView("Text_8")
    self.BG:setVisible(false)



    -- 个人排行
    self:OnClick("GeRenPaimBtn",function(sender)
        self.mIndexShop = 1
        self._tableView:reloadData()

        self.Text_8:setVisible(true)
        self.shangbang:setVisible(true)
        self.Image_3:setVisible(true)
        self.Image_2:setVisible(false)


    end)



    -- 军团排行
    self:OnClick("JunTuanPaiMBtn",function(sender)
        self.mIndexShop = 2
        self._tableView:reloadData()
        self.Text_8:setVisible(false)
        self.shangbang:setVisible(false)

        self.Image_3:setVisible(false)
        self.Image_2:setVisible(true)
    end)

    self:Init()

    self:UpdateDate()
end


function JunTuanPaiHang:Init()

    self.mIndexShop = 1
    self:createTableView()
    self:render()
end


function JunTuanPaiHang:render()
    
    if self.model.my_rank.rank == 0 then -- 未上榜
        self.shangbang:setString("未上榜")
    else
        self.shangbang:setString(self.model.my_rank.rank)
    end
end

function JunTuanPaiHang:createTableView()

    local widt = 738
    local tableView = cc.TableView:create(cc.size(widt,326))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setAnchorPoint(0,0)
    tableView:ignoreAnchorPointForPosition(false)
    local function numberOfCellsInTableView(tablev)
        -- local num = table.nums(self.dataCf)
        local num = 0
        if self.mIndexShop == 1 then
            num = #self.model.muser_rank
        else
            num = #self.model.mlegion_rank
        end
        return num
    end

    local function cellSizeForTable(table, idx)
        return widt, 100
    end

    local function tableCellAtIndex(table, idx)
        local cell = table:dequeueCell()
        local item
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("legion_generaltion.src.PaiMingCell").new({
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
        cell.item:render(num,data)
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
    self.Panel_1:addChild( self._tableView,999 )
end

-- 

function JunTuanPaiHang:UpdateDate(  )

end



return JunTuanPaiHang