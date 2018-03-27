--[[
	跨服商店
]]
local ServiceWarShop = qy.class("ServiceWarShop", qy.tank.view.BaseDialog, "servicewar.ui.ServiceWarShop")

local model = qy.tank.model.ServiceWarModel
local userModel = qy.tank.model.UserInfoModel

function ServiceWarShop:ctor(delegate)
	ServiceWarShop.super.ctor(self)

	self:InjectView("contentayer")
	self:InjectView("name")
	self:InjectView("detail")
	self:InjectView("pay")
	self:InjectView("total")
	self:InjectView("buyBtn")
	self:InjectView("PageView_1")
	self:InjectView("Image_9")
	self:InjectView("Image_3")
	self.selectIdx = 1
	
    self.CurrentIndex = 0
	self:OnClick("Button_2", function()
        self:removeSelf()
    end,{["isScale"] = false})

	self:OnClick("buyBtn", function(sender)
			local service = qy.tank.service.ServiceWarService
	       		  service:Buyitems(self.ID.id, function(data)
	       		  self:refersh(self.ID.id)
	  		end)
	end)

	self.itemList = {}
	self.delegate = delegate
	-- self:update()
	self.contentayer:addChild(self:createView(model.getLocalShopList()))
	self.total:setString(model.findscore)
	-- self:update()
	
	self.contentayer:addChild(self:createView())
	self:ItemDetail(1)

	if self.itemList[1] and self.itemList[1].itemList[1] then
		self.itemList[1].itemList[1]:setLight(true)
	end
end

function ServiceWarShop:refersh()
	local score = model.score or model.findscore
	print("score",score)
	self.total:setString(score)
	print("++++++++++111",self.selectIdx)
	if score then
		for i = 1, #model.shopList do
			if model:getChooseIndex() == i then
				if  score >= model.shopList[i].score then
					self.pay:setTextColor(cc.c4b(0, 255, 0, 255))
				else
					self.pay:setTextColor(cc.c4b(255, 0, 0, 255))
				end
			end
		end
		-- print("***12*****",qy.json.encode(model.shopList))
		-- if model.score >= model.shopList[u].score then
		-- 	self.pay:setTextColor(cc.c4b(0, 255, 0, 255))
		-- else
		-- 	self.pay:setTextColor(cc.c4(255, 0, 0, 255))
		-- end
	end
end

-- function ServiceWarShop:update()
-- 	if not self.info_c then
--            -- self.info_c = cc.LayerColor:create(cc.c4b(100,0,0,255))
--            self.info_c = cc.Layer:create()
--     end

-- 	if self.itemList ~= nil and #self.itemList >= 1 then
-- 		for i = 1, #self.itemList do
-- 			self.itemList[i]:setTouchEnabled(true)
-- 		end
-- 		self.info_c:removeAllChildren()
-- 	end
-- 	 self.itemList = {}
--     self.sp = cc.Sprite:create("servicewar/res/15.png")
--     self.info_c:addChild(self.sp)
--     -- self.info_c:setSwallowTouches(true)
-- 	for i = 1, #model.shopList do
--         self.itemList[i] = qy.tank.view.common.AwardItem.createAwardView(model.shopList[i].award[1], 1, 1, false, function ()
--         -- self.itemList[i] = qy.tank.view.common.AwardItem.createAwardView({id = self.actIndexArr[i].id, type = self.actIndexArr[i].type, num = 1}, 1, 1, false, function ()
--         	self:ItemDetail(i)
--         end)
--         self.itemList[i]:setScale(0.95)
-- 		self.info_c:addChild(self.itemList[i])
-- 	end

-- 	qy.tank.utils.TileUtil.arrange(self.itemList, 3, 140, 165, cc.p(100,1000))
-- 	self.info_c:setContentSize(700, 930)
-- 	self.info_c:setPosition(0, -50)
-- 	if not tolua.cast(self.infoList,"cc.Node") then
-- 	    self.infoList = cc.ScrollView:create()
-- 	    self.contentayer:addChild(self.infoList)
-- 	    self.infoList:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
-- 	    self.infoList:ignoreAnchorPointForPosition(false)
-- 	    self.infoList:setClippingToBounds(true)
-- 	    self.infoList:setBounceable(true)
-- 	    self.infoList:setAnchorPoint(0, 0)
-- 	    self.infoList:setPosition(0, 20)
-- 	    self.infoList:setViewSize(cc.size(850,428))
-- 	    self.infoList:setTouchEnabled(true)
-- 	    self.infoList:setContainer(self.info_c)
--     end
--     self.infoList:updateInset()
--     self.infoList:setDelegate()
--     self.infoList:setContentOffset(cc.p(0, self.infoList:getViewSize().height - self.info_c:getContentSize().height), false)
--   	-- self:ItemDetail(1)
--  	self.CurrentIndex = 1

-- end

function ServiceWarShop:createView()
    local tableView = cc.TableView:create(cc.size(550, 450))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(0, 10)
    -- tableView:setDelegate()

    local list = qy.Utils.oneToTwo(model.shopList, math.ceil(#model.shopList / 3), 3)

    local function numberOfCellsInTableView(tableView)
        return #list
    end

    local function cellSizeForTable(tableView, idx)
        return 500, 170
    end

    -- local function tableCellTouched(table, cell)
    -- 	self.selectIdx = cell:getIdx() + 1
    --    -- self:refersh()
    -- end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item 
        if nil == cell then
            cell = cc.TableViewCell:new()
			item = require("servicewar.src.ShopCell").new(self)
            cell:addChild(item)
            cell.item = item
            table.insert(self.itemList, item)
        end

        cell.item.idx = idx
		cell.item:setData(list[idx + 1], idx,function ()
			self:refersh()
		end)
        return cell
    end
    tableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    -- tableView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)

    tableView:reloadData()
    self.tableView = tableView
    return tableView
end

function ServiceWarShop:ItemDetail(index)
	if not self.itemIcon then
		self.itemIcon = qy.tank.view.common.AwardItem.createAwardView(model.shopList[index].award[1], 1, 1, false)
	    self.Image_3:addChild(self.itemIcon)
	    self.itemIcon:setPosition(100, 390)
	    self.itemIcon:setScale(0.95)
	end 

	local itemData = qy.tank.view.common.AwardItem.getItemData(model.shopList[index].award[1])
	self.name:setTextColor(qy.tank.utils.ColorMapUtil.qualityMapColor(itemData.quality))
	self.itemIcon:setData(itemData)
	self.CurrentIndex = index
	self.ID = model.shopList[index]
	
    self.itemIcon.name:setVisible(false)
	self.detail:setString(model.shopList[index].desc)
	self.name:setString(model.shopList[index].title)

	self.pay:setString(model.shopList[index].score)
	if model.findscore >= model.shopList[index].score then
		self.pay:setTextColor(cc.c4b(0, 255, 0, 255))
	else
		self.pay:setTextColor(cc.c4b(255, 0, 0, 255))
	end
end

function ServiceWarShop:clearLights()
	for i, v in pairs(self.itemList) do
		v:setLight(false)
	end
end

function ServiceWarShop:onEnter()
	
end

function ServiceWarShop:onExit()
	
end
return ServiceWarShop