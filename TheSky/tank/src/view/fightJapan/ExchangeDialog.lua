--[[
    远征商店
]]
local ExchangeDialog = qy.class("ExchangeDialog", qy.tank.view.BaseDialog, "view/fightJapan/ExchangeDialog")

local itemArr = {}

function ExchangeDialog:ctor(delegate)
    ExchangeDialog.super.ctor(self)
    self.awardCommand = qy.tank.command.AwardCommand
    itemArr = {}
    self.model = qy.tank.model.FightJapanModel
    self.userInfoModel = qy.tank.model.UserInfoModel

    self:InjectView("coinTxt")
    self:InjectView("bg")
    self:InjectView("container")
    -- self:InjectView("lsitNode")

     self.style = qy.tank.view.style.DialogStyle2.new({
        size = cc.size(920,540),
        position = cc.p(0,0),
        offset = cc.p(4,0), 
        titleUrl = "Resources/common/title/fj_exchange_title.png",

        ["onClose"] = function()
            self:dismiss()
        end
    }) 

    self:addChild(self.style , -1)
    self.shopList = self:createItemList()
    self.style.bg:addChild(self.shopList)

    self:OnClick("toLeft", function(sender)
        self:moveAreaLogic(2)
    end)

    self:OnClick("toRight", function(sender)
        self:moveAreaLogic(1)
    end)
end

function ExchangeDialog:updateResource()
   self.coinTxt:setString(self.userInfoModel.userInfoEntity.expeditionCoins)
end

--创建商品列表
function ExchangeDialog:createItemList()
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
            item = qy.tank.view.fightJapan.ExchangeCell.new({
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
function ExchangeDialog:moveAreaLogic(_type)
    local listCurX = math.abs(self.shopList:getContentOffset().x)
    local _w = 290
    local listMaxX = _w * 4

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


function ExchangeDialog:onEnter()
    --用户资源数据更新
    if self.userResourceDatalistener == nil then
        self.userResourceDatalistener = qy.Event.add(qy.Event.USER_RESOURCE_DATA_UPDATE,function(event)
            self:updateResource()
        end)
    end
    self:updateResource()
end

function ExchangeDialog:onExit()
    qy.Event.remove(self.userResourceDatalistener)
    self.userResourceDatalistener = nil
end

return ExchangeDialog