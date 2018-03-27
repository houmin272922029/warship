--[[
	军需商店
	Author: Aaron Wei
	Date: 015-05-11 20:18:00
]]

local PropShopView = qy.class("PropShopView", qy.tank.view.BaseView, "view/shop/PropShopView")

function PropShopView:ctor(delegate)
    PropShopView.super.ctor(self)

    local style = qy.tank.view.style.ViewStyle1.new({
        titleUrl = "Resources/common/title/props_shop.png",
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
    self:InjectView("propBG")
    self:InjectView("propIcon")
    self:InjectView("propName")
    self:InjectView("propDescTitle")
    self:InjectView("propDesc")
    self:InjectView("equipLevel")
    self:InjectView("equipProperty")
    self:InjectView("price")
    self:InjectView("priceIcon")
    self:InjectView("blueIron")
    self:InjectView("purpleIron")
    self:InjectView("diamond")
    qy.tank.utils.TextUtil:autoChangeLine(self.propDesc , cc.size(550 , 120))

    self.delegate = delegate
    -- self.panel:setLocalZOrder(1)
    self.userInfo = qy.tank.model.UserInfoModel
    self.model = qy.tank.model.PropShopModel
    self.selectIdx = delegate.idx
    self.currencyList = {qy.TextUtil:substitute(31001),qy.TextUtil:substitute(31002),qy.TextUtil:substitute(31003),qy.TextUtil:substitute(31014)}
    self.currencyMap = {["diamond"]=qy.TextUtil:substitute(31001),["silver"]=qy.TextUtil:substitute(31002),["blue_iron"]=qy.TextUtil:substitute(31003),["purple_iron"]=qy.TextUtil:substitute(31014)}

    -- 向左移训练位列表
    self:OnClick("leftArrow", function (sendr)
        self:moveAreaLogic(1)
    end)

    -- 向右移训练位列表
    self:OnClick("rightArrow", function (sendr)
        self:moveAreaLogic(0)
    end)

    -- 购买
    self:OnClick("buyBtn", function (sendr)
        local entity = self.model.list[self.selectIdx]
        local have
        if entity.currency_type == 1 then
            have = self.userInfo.userInfoEntity.diamond
        elseif entity.currency_type == 2 then
            have = self.userInfo.userInfoEntity.silver
        elseif entity.currency_type == 3 then
            have = self.userInfo.userInfoEntity.blueIron
        elseif entity.currency_type == 4 then
            have = self.userInfo.userInfoEntity.purpleIron
        end

        if tonumber(self.userInfo.userInfoEntity.vipLevel) >= tonumber(entity.vip_limit) then
            if have >= entity.number then
                if entity.equip or (entity.props and entity.props.id == "1") then
                    -- 装备&压缩饼干 非批量购买
                    local service = qy.tank.service.ShopService
                    local entity = self.model.list[self.selectIdx]
                    service:buyProp(entity.id,1,function(data)
                        service = nil
                        self:updateResource()
                        if data and data.consume then
                            qy.hint:show(qy.TextUtil:substitute(31004)..self.currencyMap[data.consume.type].."x"..data.consume.num)
                        end
                        self:showDetailInfo(self.model.list[self.selectIdx])
                    end)
                else
                    -- 批量购买
                    local buyDialog = qy.tank.view.shop.PurchaseDialog.new(entity,function(num)
                        local service = qy.tank.service.ShopService
                        local entity = self.model.list[self.selectIdx]
                        service:buyProp(entity.id,num,function(data)
                            service = nil
                            self:updateResource()
                            if data and data.consume then
                                qy.hint:show(qy.TextUtil:substitute(31004)..self.currencyMap[data.consume.type].."x"..data.consume.num)
                            end
                            self:showDetailInfo(self.model.list[self.selectIdx])
                        end)
                    end)
                    buyDialog:show(true)
                end
            else
                if entity.currency_type ~= 1 then
                    qy.hint:show(self.currencyList[entity.currency_type]..qy.TextUtil:substitute(31005))
                else
                    qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.DIAMOND_NOT_ENOUGH)
                end
            end
        else
            qy.hint:show(qy.TextUtil:substitute(31006))
        end
    end)

    self:updateResource()
    self:createList()
end

function PropShopView:createList()
    local layer = cc.LayerColor:create(cc.c4b(0,255,255,100),770,126)
    self.tankList = cc.TableView:create(cc.size(890,126))
    self.tankList:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    self.tankList:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.tankList:setPosition(95,466)
    self.panel:addChild(self.tankList)
    -- self.tankList:addChild(layer)
    self.tankList:setDelegate()

    local function numberOfCellsInTableView(table)
        return #self.model.list
    end

    local function tableCellTouched(table,cell)
        print("cell touched at index: " .. cell:getIdx())
        qy.QYPlaySound.playEffect(qy.SoundType.COMMON_CLICK)
        local before = table:cellAtIndex(self.selectIdx-1)
        if before then
            before.item.light:setVisible(false)
        end
        self.selectIdx = cell:getIdx()+1
        cell.item.light:setVisible(true)
        self:showDetailInfo(self.model.list[self.selectIdx])
    end

    local function cellSizeForTable(tableView, idx)
        return 115, 126
    end

    local function tableCellAtIndex(table, idx)
        local strValue = string.format("%d",idx)
        local cell = table:dequeueCell()
        local item,label,status
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.shop.PropShopCell.new(self.model.list[idx+1])
            cell:addChild(item)
            cell.item = item

            status = cc.Label:createWithSystemFont("", "Helvetica", 24.0)
            status:setTextColor(cc.c4b(255,255,0,255))
            status:setPosition(110,65)
            status:setAnchorPoint(0.5,0.5)
            cell:addChild(status)
            cell.status = status
        end
        cell.item:render(self.model.list[idx+1], (idx + 1))
        if self.selectIdx == idx+1 then
            cell.item.light:setVisible(true)
            self:showDetailInfo(self.model.list[idx+1])
        else
            cell.item.light:setVisible(false)
        end
        return cell
    end

    self.tankList:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.tankList:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    self.tankList:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    self.tankList:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)

    self.tankList:reloadData()
    self:showSelectProp()
end

function PropShopView:showSelectProp()
    local diff_x = (self.selectIdx -1) * 126 - 890
    if diff_x > 0 then
        local x = self.tankList:getContentOffset().x - diff_x
        self.tankList:setContentOffset(cc.p(x, 0))
    end
    self:showDetailInfo(self.model.list[self.selectIdx])
end

--训练位移动逻辑 param type 0：左移 2：右移
function PropShopView:moveAreaLogic(type)
    local listCurX = math.abs(self.tankList:getContentOffset().x)
    local listMaxX = 110 * (#self.model.list - 7)

    if type == 0 then
        if listCurX < listMaxX then
            --向上取值
            local nextIdx = math.ceil(listCurX / 110 ) + 1
            if nextIdx > #self.model.list - 7 then
                self.tankList:setContentOffset(cc.p(-listMaxX ,0), true)
            else
                self.tankList:setContentOffset(cc.p(- 110 * nextIdx ,0), true)
            end
        end
    else
        if listCurX > 0 then
            --向下取值
            local nextIdx = math.floor(listCurX / 110 ) - 1
            if nextIdx < 0 then
                self.tankList:setContentOffset(cc.p(0 ,0), true)
            else
                self.tankList:setContentOffset(cc.p(- 110 * nextIdx ,0), true)
            end
        end
    end
end

function PropShopView:showDetailInfo(entity)
    if entity.shop_type == 1 then
        self.propBG:setSpriteFrame(entity.props:getIconBG())
        self.propIcon:setTexture(entity.props:getIcon())
        self.propName:setString(entity.props.name)
        self.propName:setTextColor(entity.props:getTextColor())
        self.propDescTitle:setString(qy.TextUtil:substitute(31007))
        self.propDesc:setString(entity.props.desc)
        self.equipLevel:setString("")
        self.equipProperty:setString("")
    elseif entity.shop_type == 2 then
        self.propBG:setSpriteFrame(entity.equip:getIconBg())
        self.propIcon:setTexture(entity.equip:getIcon())
        self.propName:setTextColor(entity.equip:getTextColor())
        self.propName:setString(entity.equip:getName())
        self.propDescTitle:setString(qy.TextUtil:substitute(31008))
        self.propDesc:setString(entity.equip.desc)
        self.equipLevel:setString(qy.TextUtil:substitute(31009)..tostring(entity.equip.level))
        self.equipProperty:setString(tostring(entity.equip:getPropertyInfo()))
    end
    self.price:setString(entity.number)
    self.priceIcon:setTexture(entity.priceIcon)
end

function PropShopView:updateResource()
    self.blueIron:setString(self.userInfo.userInfoEntity.blueIron)
    self.diamond:setString(self.userInfo.userInfoEntity:getDiamondStr())
    self.purpleIron:setString(self.userInfo.userInfoEntity.purpleIron)
end

function PropShopView:onEnter()
    self:updateResource()
end

function PropShopView:onExit()
    
end

return PropShopView
