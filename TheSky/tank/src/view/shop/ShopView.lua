--[[
	商店入口
	Author: Aaron Weo
	Date: 2015-05-11 19:47:44
]]

local ShopView = qy.class("ShopView", qy.tank.view.BaseView, "view/shop/ShopView")
local model = qy.tank.model.TankShopModel

function ShopView:ctor(delegate)
	print("ShopView:ctor")
    ShopView.super.ctor(self)
	self:InjectView("list_con")
    self:InjectView("panel")
	self.delegate = delegate
	local style = qy.tank.view.style.ViewStyle1.new({
        titleUrl = "Resources/common/title/shop.png",
        ["onExit"] = function()
            if delegate and delegate.dismiss then
                delegate.dismiss()
            end
        end
    })
    self:addChild(style)

	-- self:OnClick("bg1",function(sender)
	--  	qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.TANK_SHOP)
	-- end, {["isScale"] = false})
	--
	-- self:OnClick("bg2",function(sender)
	--  	qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.PROP_SHOP)
	-- end, {["isScale"] = false})
	local dis_w = 0
	if model:getMenuNum() < 3 then
		dis_w = qy.winSize.width/2-512 --28
	else
		dis_w = 10
	end
    self.menuMum = model:getMenuNum()
	self.list_con:setPosition(dis_w,10)
	self.menu = self:createList(dis_w,model:getMenuNum())
    self.menu:setPositionX(self.menu:getPositionX()+50)
    self.menu:setPositionY(self.menu:getPositionY()+30)
    self.menuposx = self.menu:getPositionX()
    self.menuposy = self.menu:getPositionY()

	self.list_con:addChild(self.menu)


	self.mSectIndex = 1
    self.tab = qy.tank.widget.TabButtonGroup.new("widget/TabButton1",{"坦克配件","军需商店"},cc.size(185,67),"h",function(idx)
    	self:SetSectIndex(idx)
    end, 1)

    self.panel:addChild(self.tab,9999999)
    self.tab:setPosition(55,585)

end

function ShopView:SetSectIndex( idx )
	self.mSectIndex = idx
    if self.mSectIndex == 2 then
        self.menuMum = 1
        self.menu:setPositionX(315)
    else
        self.menuMum = model:getMenuNum()
        self.menu:setPosition(self.menuposx,self.menuposy)
    end
	self.menu:reloadData()
end

function ShopView:createList(dis_w,num)
    local tableView = cc.TableView:create(cc.size(qy.winSize.width-dis_w*2,600-70))
    tableView:setDirection(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setDelegate()

    local function numberOfCellsInTableView(table)
        return self.menuMum
    end

    local function tableCellTouched(table,cell)
		local index = cell:getIdx() +1 
		if index == 1 then

            if self.mSectIndex == 1 then
                print("---------1")
                qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.TANK_SHOP,{["index"] = index})
            else
               -- qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.PROP_SHOP,{["index"] = index})
               -- qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.COUPON_SHOP,{["index"] = 1})
                qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.PROP_SHOP)
                print("---------2")
        
            end
			-- 普通坦克商店
		elseif index == 2 then
			if self.mSectIndex == 1 then
                print("---------3")
                qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.TANK_SHOP,{["index"] = 3})
            else
                qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.COUPON_SHOP,{["index"] = 2})
                print("---------4")
            end
		end
        print("index===="..index)
    end

    local function cellSizeForTable(tableView, idx)
        return 450, 600
    end

    local function tableCellAtIndex(table, idx)

        local cell = table:dequeueCell()
        local item,label,status
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.shop.MenuCell.new(self)

            cell:addChild(item)
            cell.item = item
            item:setScale(0.87)
            item:setPositionY( item:getPositionY() + 40 )
        end
        local data1 = {1,3}
        local data2 = {2,4}
        local data = nil
        if self.mSectIndex == 1 then
        	data = data1
        else
        	data = data2
        end
        cell.item:render(data[ idx + 1])

        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:reloadData()

	return tableView
end

function ShopView:onEnter()
	print("ShopView:onEnter")
end

function ShopView:onEnterFinish()
	print("ShopView:onEnterFinish")
end

function ShopView:onExit()
	print("ShopView:onExit")
end

function ShopView:onExitStart()
	print("ShopView:onExitStart")
end

function ShopView:onCleanup()
	print("ShopView:onCleanup")
end

return ShopView
