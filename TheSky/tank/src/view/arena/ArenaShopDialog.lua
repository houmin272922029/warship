--
--[[
	军神商店
	Author: Aaron Wei
	Date: 2015-12-28 20:53:55
]]

local ArenaShopDialog = qy.class("ArenaShopDialog", qy.tank.view.BaseDialog, "view/fightJapan/ExchangeDialog")

local itemArr = {}

function ArenaShopDialog:ctor(delegate)
    ArenaShopDialog.super.ctor(self)
    self.awardCommand = qy.tank.command.AwardCommand
    itemArr = {}
    self.model = qy.tank.model.ArenaModel
    self.userInfoModel = qy.tank.model.UserInfoModel

    self:InjectView("coinIcon")
    self:InjectView("coinTxt")
    self:InjectView("tipLabel")
    self:InjectView("container")

     self.style = qy.tank.view.style.DialogStyle2.new({
        size = cc.size(920,540),
        position = cc.p(0,0),
        offset = cc.p(4,0), 
        titleUrl = "Resources/arena/jssd.png",

        ["onClose"] = function()
            self:dismiss()
        end
    }) 

    self:addChild(self.style , -1)
    self.shopList = self:createItemList()
    self.style.bg:addChild(self.shopList)

    self.coinIcon:initWithFile("Resources/common/icon/coin/21.png")
    self.coinIcon:setScale(0.6)
    self.tipLabel:setString(qy.TextUtil:substitute(4006))

    self:OnClick("toLeft", function(sender)
        self:moveAreaLogic(2)
    end)

    self:OnClick("toRight", function(sender)
        self:moveAreaLogic(1)
    end)
end

function ArenaShopDialog:updateResource()
   self.coinTxt:setString(self.userInfoModel.userInfoEntity.prestige)
end

--创建商品列表
function ArenaShopDialog:createItemList()
    local tableView = cc.TableView:create(cc.size(890, 430))
    tableView:setDirection(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    -- tableView:setPosition(95, 145)
    tableView:setPosition(0,7)

    local function numberOfCellsInTableView(tableView)
        return math.ceil(self.model:getExpeditionGoodsNum() / 2)
    end

    local function cellSizeForTable(tableView, idx)
        return 290, 430
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.arena.ArenaShopCell.new({
                ["isTouchMoved"] = function()
                    return tableView:isTouchMoved()
                end,
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

--训练位移动逻辑 param _type 1：左移 2：右移
function ArenaShopDialog:moveAreaLogic(_type)
    local listCurX = math.abs(self.shopList:getContentOffset().x)
    local _w = 290
    -- local listMaxX = _w * math.ceil(self.model:getExpeditionGoodsNum() / 2)
    local listMaxX = _w * 9

    if _type == 1 then
        if listCurX < listMaxX then
            --向上取值
            local nextIdx = math.ceil(listCurX / _w ) + 1
            if nextIdx > 4 then
                self.shopList:setContentOffset(cc.p(-listMaxX ,0), true)
            else
                self.shopList:setContentOffset(cc.p(- _w * nextIdx ,0), true)
            end
        end
    else
        if listCurX > 0 then
            --向下取值
            local nextIdx = math.floor(listCurX / _w ) - 1
            if nextIdx < 0 then
                self.shopList:setContentOffset(cc.p(0 ,0), true)
            else
                self.shopList:setContentOffset(cc.p(-_w * nextIdx ,0), true)
            end
        end
    end
end


function ArenaShopDialog:onEnter()
    --用户资源数据更新
    if self.userResourceDatalistener == nil then
        self.userResourceDatalistener = qy.Event.add(qy.Event.USER_RESOURCE_DATA_UPDATE,function(event)
            self:updateResource()
        end)
    end
    self:updateResource()
end

function ArenaShopDialog:onExit()
    qy.Event.remove(self.userResourceDatalistener)
    self.userResourceDatalistener = nil
end

return ArenaShopDialog