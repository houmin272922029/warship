--[[
	坦克工厂
	Author: Aaron Wei
	Date: 2015-05-11 20:16:52
]]

local TankShopView = qy.class("TankShopView", qy.tank.view.BaseView, "view/shop/TankShopView")

function TankShopView:ctor(delegate)
    TankShopView.super.ctor(self)
    local _titleUrl = ""
    if delegate and delegate.index == 3 then
        self.view_idx = delegate.index
        _titleUrl = "Resources/common/title/reputation_tank.png"
    else
        self.view_idx = 1
        _titleUrl = "Resources/common/title/tank_shop.png"
    end
    local style = qy.tank.view.style.ViewStyle1.new({
        titleUrl = _titleUrl,
        showHome = true,
        ["onExit"] = function()
            if delegate and delegate.dismiss then
                delegate.dismiss()
            end
        end
    })
    self:addChild(style)

    -- 内容样式
    self:InjectView("panel")
    self:InjectView("leftArrow")
    self:InjectView("rightArrow")
    self:InjectView("rightEage")
    self:InjectView("orangeIron")
    self:InjectView("purpleIron")
    self:InjectView("blueIron")
    self:InjectView("reputation")
    for i = 1, 4 do
        self:InjectView("res_"..i)
    end

    self.leftArrow:setLocalZOrder(10)
    self.rightArrow:setLocalZOrder(10)

    self.model = qy.tank.model.TankShopModel
    self.garageModel = qy.tank.model.GarageModel
    self.userInfo = qy.tank.model.UserInfoModel
    self.delegate = delegate
    self.selectIdx = 1
    self.currencyMap = {["orange_iron"] = qy.TextUtil:substitute(31031),["blue_iron"] = qy.TextUtil:substitute(31032),["purple_iron"] = qy.TextUtil:substitute(31033)}

    --向左移训练位列表
    self:OnClick("leftArrow", function (sendr)
        self:moveAreaLogic(1)
    end)

    --向右移训练位列表
    self:OnClick("rightArrow", function (sendr)
        self:moveAreaLogic(0)
    end)

    --一键移到最右
    self:OnClick("rightEage", function (sendr)
        self:moveEdge(0)
    end)

    if self.view_idx == 3 then
        -- 声望坦克
        self.res_3:setPosition(self.res_1:getPosition())
        self.res_4:setPosition(self.res_2:getPosition())
        self.res_1:setVisible(false)
        self.res_2:setVisible(false)
        self.res_4:setVisible(true)
    else
        -- 坦克商店
        self.res_1:setVisible(true)
        self.res_2:setVisible(true)
        self.res_4:setVisible(false)
    end
end

function TankShopView:onEnter()
    self:updateResource()
    self:createList()
end

function TankShopView:createList()
    -- local layer = cc.LayerColor:create(cc.c4b(0,255,255,100),960,600)
    if not tolua.cast(self.tankList,"cc.Node") then
        self.tankList = cc.TableView:create(cc.size(1000,650))
        self.tankList:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
        self.tankList:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
        self.tankList:setPosition(40,0)
        self.panel:addChild(self.tankList)
        -- self.tankList:addChild(layer)
        self.tankList:setDelegate()

        local function numberOfCellsInTableView(table)
            return #self.model:getTankList(self.delegate.index)
        end

        local function tableCellTouched(table,cell)
            print("cell touched at index: " .. cell:getIdx())
            self.selectIdx = cell:getIdx()+1
        end

        local function cellSizeForTable(tableView, idx)
            return 340, 650
        end

        local function tableCellAtIndex(table, idx)
            local strValue = string.format("%d",idx)
            local cell = table:dequeueCell()
            local item
            if nil == cell then
                cell = cc.TableViewCell:new()
                item = qy.tank.view.shop.TankShopCell.new(self)
                cell:addChild(item)
                cell.item = item
            end
            cell.item:render(self.model:getTankList(self.delegate.index)[idx+1])
            return cell
        end

        self.tankList:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
        self.tankList:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
        self.tankList:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
        self.tankList:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)

        self.tankList:reloadData()
    end
end

function TankShopView:isTouchMoved()
    return self.tankList:isTouchMoved()
end

--训练位移动逻辑 param type 0：左移 2：右移
function TankShopView:moveAreaLogic(type)
    local list_num =  #self.model:getTankList(self.delegate.index)
    if list_num <= 3 then
        -- 不超过4个不能移动
        return
    end
    local offset = 340
    local listCurX = math.abs(self.tankList:getContentOffset().x)
    local listMaxX = offset* (list_num - 3)

    if type == 0 then
        if listCurX < listMaxX then
            --向上取值
            local nextIdx = math.ceil(listCurX / offset) + 1
            if nextIdx > list_num - 4 then
                self.tankList:setContentOffset(cc.p(-listMaxX ,0), true)
            else
                self.tankList:setContentOffset(cc.p(- offset* nextIdx ,0), true)
            end
        end
    else
        if listCurX > 0 then
            --向下取值
            local nextIdx = math.floor(listCurX / offset) - 1
            if nextIdx < 0 then
                self.tankList:setContentOffset(cc.p(0 ,0), true)
            else
                self.tankList:setContentOffset(cc.p(- offset* nextIdx ,0), true)
            end
        end
    end
end

-- 移动到最左边 type 0   移动到最右边 type 1
function TankShopView:moveEdge(type)
    local list_num =  #self.model:getTankList(self.delegate.index)
    if list_num <= 3 then
        -- 不超过4个不能移动
        return
    end

    local offset = 340
    local listCurX = math.abs(self.tankList:getContentOffset().x)
    local listMaxX = offset* (list_num - 3)

    if type == 0 then
        if listCurX < listMaxX then
            --向上取值
            local nextIdx = math.ceil(listCurX / offset) + 1
            if nextIdx <= list_num then
                self.tankList:setContentOffset(cc.p(-listMaxX ,0), true)
            end
        end
    elseif type == 1 then
        if listCurX > 0 then
            --向下取值
            local nextIdx = math.floor(listCurX / offset) - 1
            if nextIdx < 0 then
                self.tankList:setContentOffset(cc.p(0 ,0), true)
            end
        end
    end
end

function TankShopView:updateResource()
    self.orangeIron:setString(tostring(self.userInfo.userInfoEntity.orangeIron))
    self.purpleIron:setString(tostring(self.userInfo.userInfoEntity.purpleIron))
    self.blueIron:setString(tostring(self.userInfo.userInfoEntity.blueIron))
    self.reputation:setString(tostring(self.userInfo.userInfoEntity.reputation)) 
end

return TankShopView
