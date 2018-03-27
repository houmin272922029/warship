local MainDialog = qy.class("MainDialog", qy.tank.view.BaseDialog, "coupon_shop.ui.Maindialog")

local model = qy.tank.model.CouponShopModel
local service = qy.tank.service.CouponShopService

function MainDialog:ctor(delegate)
   	MainDialog.super.ctor(self)
    self:InjectView("BG")
    self:InjectView("TimeNuma")
    self:InjectView("price")
    self:InjectView("zhekou")
    self:InjectView("ssprice")
    self:InjectView("SDPanel")
    self:InjectView("GWCPanel")
    self:InjectView("Image_s2")
    self:InjectView("Image_s1")
    self:InjectView("TimeNuma_0_0")


    self:createTableView()

    self:createGwcTableView()

   	self:OnClick("Btn_close", function()
        self:removeSelf()
    end,{["isScale"] = false})


    self:OnClick("addbuy",function(d,sender)
        if model:GetClikIndex() <= 0 then
            qy.hint:show("你还没选中商品")    
            return
        end

        if model:GetShopCfInDexBuyNum( model:GetClikIndex()) <= 0 then
            qy.hint:show("商品剩余个数不足")    
            return
        end

        model:SetGwcData(model:GetClikIndex())
        local item = model:GetLastClickItem()
        item:render(item.mClikIndex)
        self.mGwctableView:reloadData()
        -- self._tableView:reloadData()
        self:UpdateDate()
    end)

    self:OnClick("buy",function(d,sender)
        local num = table.nums( model:GetShopTable())
        if num <=0 then
            qy.hint:show("购物车为空")    
            return
        end
        service:GetgetawardData(1,1,function ( ... )
        end)
    end)


    self:OnClick("shuaxinbtn",function(d,sender)
        qy.alert:show({"提示",{255, 255, 255}},"你确定要花费50钻石刷新商店？",cc.size(500,300),{{qy.TextUtil:substitute(9005),4},{qy.TextUtil:substitute(9006),5}},function(label)
                    if label == "确定" then
                        service:UpdatePropsList(function ( ... )
                                local item = model:GetLastClickItem()
                                item:UpdateGuangImage(0)
                               -- self:UpdateTableViewInAll()
                        end)
                    end
                end)
    end)



    local titleUrl = {"junxushop.png","shangpjshop.png"}
    local ty = model:GetAtType()
    self:addChild(qy.tank.view.style.ViewStyle1.new({
        ["onExit"] = function()
            self:removeSelf()
        end,
        ["titleUrl"] = "Resources/common/title/"..titleUrl[ty],
        ["showHome"] = true,
    }))

    self:setTime()
    self:UpdateDiamond()

    model:OnEnter( self )
end
--[[
    刷新左右2边的view数据 
]]--
function MainDialog:UpdateTableViewInAll( ... )
    self.mGwctableView:reloadData()
    self._tableView:reloadData()
    self:UpdateDate()
end



function MainDialog:createTableView()

    local widt = 738
    local tableView = cc.TableView:create(self.SDPanel:getContentSize())
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setAnchorPoint(0,0)
    tableView:ignoreAnchorPointForPosition(false)
    local function numberOfCellsInTableView(tablev)
       local num = table.nums(model.mShopCf)
        return math.ceil(num/2)
    end

    local function cellSizeForTable(table, idx)
        return 210, 105
    end

    local function tableCellAtIndex(table, idx)
        local cell = table:dequeueCell()
        local item
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("coupon_shop.src.ShopCellMax").new({
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

    local function tableAtTouched(table, cell)
        cell.item:UpdateGuangImage(0)
    end

    tableView:setPosition(10,0)
    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:registerScriptHandler(tableAtTouched,cc.TABLECELL_TOUCHED)
    
    tableView:reloadData()

    self._tableView = tableView

    if self._tableView == nil then
        print("================nil=====")
        return
    end
    self.SDPanel:addChild( self._tableView,999 )
end

function MainDialog:UpdateDate( ... )
    local t = model:GetShopDisPrice()

    self.price:setString(t.price)
    if t.discount == 1 then
        t.discount = "无"
    end
    self.zhekou:setString(t.discount)
    self.ssprice:setString( t.ssprice )


    self:UpdateDiamond()

end


function MainDialog:UpdateDiamond()
    if model:GetAtType() == 1 then
        self.Image_s1:setVisible(true)
        self.Image_s2:setVisible(false)
    else
        self.Image_s1:setVisible(false)
        self.Image_s2:setVisible(true)
    end
    self.TimeNuma_0_0:setString(model:GetDiamond())
end



function MainDialog:createGwcTableView()

    local widt = 738
    local tableView = cc.TableView:create(self.GWCPanel:getContentSize())
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setAnchorPoint(0,0)
    tableView:ignoreAnchorPointForPosition(false)
    local function numberOfCellsInTableView(tablev)
        local num = #model.mGwcData
        local x = num
        return num
    end

    local function cellSizeForTable(table, idx)
        return 210, 105
    end

    local function tableCellAtIndex(table, idx)
        local cell = table:dequeueCell()
        local item
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("coupon_shop.src.ShopCell").new({})
            cell:addChild(item)
            cell.item = item
        end
        local num = idx + 1
        cell.item:render(model.mGwcData[num],num)
        return cell
    end

    local function tableAtTouched(table, cell)
    end

    tableView:setPosition(50,0)
    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:registerScriptHandler(tableAtTouched,cc.TABLECELL_TOUCHED)
    
    tableView:reloadData()

    self.mGwctableView = tableView
    self.GWCPanel:addChild( self.mGwctableView,999 )
end

function MainDialog:onExit()
    -- model:onExit(  )

end

function MainDialog:setTime()

    if model:GetSurplusTiemsState() then
        return
    end

    self.TimeNuma:setString(qy.tank.utils.DateFormatUtil:toDateString(model:GetSurplusTiems(), nil))
    self.timer = qy.tank.utils.Timer.new(1,1,function()
        self.TimeNuma:setString(qy.tank.utils.DateFormatUtil:toDateString(model:GetSurplusTiems(), nil))
        model:SetSurplusTiems( model:GetSurplusTiems() - 1 )
        print("=======")
    end) 
    self.timer:start()



end

return MainDialog
