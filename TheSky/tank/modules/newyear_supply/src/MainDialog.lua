local MainDialog = qy.class("MainDialog", qy.tank.view.BaseDialog, "newyear_supply.ui.MainDialog")

local model = qy.tank.model.OperatingActivitiesModel
local service = qy.tank.service.OperatingActivitiesService
function MainDialog:ctor(delegate)
   	MainDialog.super.ctor(self)
    self:InjectView("BG")
    self:InjectView("Sprite1")
    self:InjectView("Btn_right")
    self:InjectView("Btn_left")
    self:InjectView("Point1")
    self:InjectView("Point2")
    self:InjectView("Point3")
    self:InjectView("Point4")
    self:InjectView("Price1")
    self:InjectView("Price2")
    self:InjectView("notAward")
    self:InjectView("get")
    self:InjectView("hasGot")
    self:InjectView("Btn_buy")
    self:InjectView("Time2")
    self:InjectView("Name")

   	self:OnClick("Btn_close", function()
        self:removeSelf()
    end,{["isScale"] = false})

    self:OnClick("Btn_right", function()
        self.idx = self.idx + 1

        if self.idx >= #model.newYearSupplyList then
            self.idx = #model.newYearSupplyList

        end
        self:update(true)
    end,{["isScale"] = false})

    self:OnClick("Btn_left", function()
        self.idx = self.idx - 1

        if self.idx <= 1 then
            self.idx = 1
        end

        self:update(true)
    end,{["isScale"] = false})

    self:OnClick("Btn_buy", function()
        if self.entity.status == 1 then
            local data = qy.tank.model.RechargeModel.data[self.key]
            qy.tank.service.RechargeService:paymentBegin(data, function(flag, msg)
                if flag == 3 then
                    self.toast = qy.tank.widget.Toast.new()
                    self.toast:make(self.toast, qy.TextUtil:substitute(58001))
                    self.toast:addTo(qy.App.runningScene, 1000)
                elseif flag == true then
                    self.toast:removeSelf()
                    -- table.insert(model.newYearSupplyRecharge, self.key)
                    self.entity.status = 2
                    self:update(true)
                    qy.hint:show(qy.TextUtil:substitute(58002))
                else
                    self.toast:removeSelf()
                    qy.hint:show(msg)
                end
            end)
        elseif self.entity.status == 2 then
            local aType = qy.tank.view.type.ModuleType
            service:getCommonGiftAward(self.key, aType.NEWYEAR_SUPPLY,false, function(reData)
                self.entity.status = 3
                self:update()
            end)
        else
            qy.hint:show(qy.TextUtil:substitute(58003))
        end
    end,{["isScale"] = false})


    self.idx = model:getNewYearSupplyIdx()
    self.entity = model:atNewYearSupply(self.idx)
    self.key = self.entity.product_id
    self.BG:addChild(self:createView())

    -- local item = ccui.TextAtlas:create()
    -- local info = qy.tank.utils.NumPicUtils.getNumPicInfoByType(25)
    -- item:setProperty("1111", info.numImg, info.width, info.height,"0")
    -- item:setPosition(230,435)
    -- item:setAnchorPoint(cc.p(0.5, 0.5))

    -- self.BG:addChild(item)

    local item2 = ccui.TextAtlas:create()
    local info = qy.tank.utils.NumPicUtils.getNumPicInfoByType(25)
    item2:setProperty("1111", info.numImg, info.width, info.height,"0")
    item2:setPosition(355,450)
    item2:setAnchorPoint(cc.p(1, 0.5))

    self.BG:addChild(item2)
    -- self.gem = item
    self.div = item2

    self:update()
    -- self:setGem()
    -- self:setMul()
    -- self:setAward()
    self:showAction(self.Btn_left)
    self:showAction(self.Btn_right)
end

function MainDialog:createView()
 local tableView = cc.TableView:create(cc.size(415, 310))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    -- tableView:setSwallowTouches(false)
    tableView:setPosition(40, 100)

    -- local data = model.bonusList

    local function numberOfCellsInTableView(tableView)
        return table.nums(self.entity.award)
    end

    local function cellSizeForTable(tableView,idx)
        return 415, 80
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        local label = nil
        -- local data = model:getList(idx)
        -- local height = model:getHeight(idx)
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("newyear_supply.src.ItemView").new(self)
            cell:addChild(item)
            cell.item = item
        end

        -- local data = model:getNewYearSupplyStaticData(self.key)
        cell.item:setData(self.entity.award[idx + 1], self.entity.gem)
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    
    tableView:reloadData()

    self.tableView = tableView

    return tableView
end

function MainDialog:update(isTouch)
    if not isTouch then
        self.idx = model:getNewYearSupplyIdx()  
    end

    self.entity = model:atNewYearSupply(self.idx)
    self.key = self.entity.product_id
    self:setBtnStatus()   
    -- self:setGem()

    self.Btn_right:setVisible(self.idx < #model.newYearSupplyList)
    self.Btn_left:setVisible(self.idx > 1)
    self.tableView:reloadData()

    for i = 1, 4 do
        local idx = self.idx == i and 1 or 2

        self["Point" .. i]:setSpriteFrame("newyear_supply/res/point" .. idx .. ".png")
    end

    -- local idx1 = self.idx == 1 and 1 or 2
    -- self.Point1:setSpriteFrame("newyear_supply/res/point" .. idx1 .. ".png")
    -- local idx2 = self.idx == 2 and 1 or 2
    -- self.Point2:setSpriteFrame("newyear_supply/res/point" .. idx2 .. ".png")

    local paymentData = qy.Config["payment_" .. "dev"][self.key]

    self.Price2:setString(paymentData.cash)
    self.Price1:setString(self.entity.price)

    
    self:setMul()

    self.Name:setString(self.entity.name)
end

function MainDialog:setGem()
    self.gem:setString(self.entity.gem)
end

function MainDialog:setMul()
    self.div:setString(self.entity.div)
    -- self.Sprite1:setSpriteFrame("newyear_supply/res/xnlb0" .. self.idx .. ".png")
end

function MainDialog:setBtnStatus()
    self.get:setVisible(self.entity.status == 2)
    self.notAward:setVisible(self.entity.status == 1)
    self.hasGot:setVisible(self.entity.status == 3)
    self.Btn_buy:setVisible(self.entity.status ~= 3)

    -- if table.keyof(model.newYearSupplyRecharge, self.key) then
    --     if table.keyof(model.newYearSupplyAwardList, self.key) then
    --         self.idx = self.idx == 1 and 2 or 1
    --         self.key = self.idx == 1 and  "tk30" or "tk98"
            
    --         if table.keyof(model.newYearSupplyRecharge, self.key) and not table.keyof(model.newYearSupplyAwardList, self.key) then
    --             self.get:setVisible(true)
    --             self.notAward:setVisible(false)
    --         else
    --             self.get:setVisible(false)
    --             self.notAward:setVisible(true)
    --         end
    --     else
    --         self.get:setVisible(true)
    --         self.notAward:setVisible(false)
    --     end
    -- else
    --     self.get:setVisible(false)
    --     self.notAward:setVisible(true)
    -- end
end

function MainDialog:showAction(node)
    local func1 = cc.FadeTo:create(1, 210)
    local func2 = cc.FadeTo:create(1, 255)
    local func3 = cc.ScaleTo:create(1, 1.05)
    local func4 = cc.ScaleTo:create(1, 1)
    local func5 = cc.DelayTime:create(0.5)

    node:runAction(cc.RepeatForever:create(cc.Sequence:create(func1, func2, func5)))
    node:runAction(cc.RepeatForever:create(cc.Sequence:create(func4, func3, func5)))
end

function MainDialog:onEnter()
    self.Time2:setString(qy.tank.utils.DateFormatUtil:toDateString(model.newYearSupplyEndTime - qy.tank.model.UserInfoModel.serverTime, 3))
    self.listener_1 = qy.Event.add(qy.Event.BONUS_TIME,function(event)
        -- self.Time1:setString(qy.tank.utils.DateFormatUtil:toDateString(model.bonusBeginTime, 3))
        self.Time2:setString(qy.tank.utils.DateFormatUtil:toDateString(model.newYearSupplyEndTime - qy.tank.model.UserInfoModel.serverTime, 3))
    end)
end

function MainDialog:onExit()
    qy.Event.remove(self.listener_1)
end

return MainDialog
