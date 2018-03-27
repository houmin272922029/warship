--[[
	最强之战-积分商城
	Author: H.X.Sun
]]

local ShopDialog = qy.class("ShopDialog", qy.tank.view.BaseDialog, "greatest_race/ui/ShopDialog")

local PropShopModel = qy.tank.model.PropShopModel
local AwardUtils = qy.tank.utils.AwardUtils
local UserInfoModel = qy.tank.model.UserInfoModel

function ShopDialog:ctor(delegate)
    ShopDialog.super.ctor(self)

    -- 通用弹窗样式
    local style = qy.tank.view.style.DialogStyle4.new({
        size = cc.size(920,560),
        position = cc.p(0,0),
        offset = cc.p(0,0),
        titleUrl = "greatest_race/res/shop_title.png",

        ["onClose"] = function()
            self:dismiss()
        end
    })
    self:addChild(style,-1)

    self:InjectView("bg1")
    self:InjectView("name")
    self:InjectView("des")
    self:InjectView("cost")
    self:InjectView("score")
    for i = 1,5 do
        self:InjectView("num_"..i)
        self:InjectView("icon_"..i)
    end

    self.model = qy.tank.model.GreatestRaceModel
    local service = qy.tank.service.GreatestRaceService

    self.list = self:__createList()
    self.bg1:addChild(self.list)
    self.list:setPosition(0,3)
    self:selectChest()

    self:OnClick("btn",function()
        service:buy(self.id,function()
            self:updateScore()
        end)
    end)
end

function ShopDialog:__createList()
    local tableView = cc.TableView:create(cc.size(512, 400))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setDelegate()

    local function numberOfCellsInTableView(table)
        return self.model:getShopCellNum()
    end

    local function cellSizeForTable(tableView, idx)
        return 448, 120
    end

    local function tableCellAtIndex(table, idx)
        local cell = table:dequeueCell()
        local item = nil
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.greatest_race.ShopCell.new({
                ["callBack"] = function()
                    print("点击了点击了=>>>>",self.model:getShopSelectIndex())
                    self:updateList()
                    self:selectChest()
                end,
            })
            cell:addChild(item)
            cell.item = item
        end
        cell.item:render(idx)
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:reloadData()
    return tableView
end

function ShopDialog:updateList()
    local listCurY = self.list:getContentOffset().y
    self.list:reloadData()
    self.list:setContentOffset(cc.p(0,listCurY))
end

function ShopDialog:updateScore()
    self.score:setString("x"..UserInfoModel.userInfoEntity.arena_coin)
end

function ShopDialog:selectChest()
    local select = self.model:getShopSelectIndex()
    local cdata = self.model:getShopListByIndex(select)
    self.id = cdata.id
    print("cdata.propid====",cdata.propid)
    local entity = PropShopModel:createPropEntity(cdata.propid)
    self.name:setString(entity.name)
    self.des:setString(entity.desc)
    self.cost:setString(cdata.arena_coin)
    local icon
    for i = 1, 5 do
        if cdata.award[i] then
            icon = AwardUtils.getAwardIconByType(cdata.award[i].type,cdata.award[i].id or 0)
            self["icon_"..i]:setTexture(icon)
            self["num_"..i]:setString("x "..cdata.award[i].num)
            self["icon_"..i]:setVisible(true)
            self["num_"..i]:setVisible(true)
        else
            self["icon_"..i]:setVisible(false)
            self["num_"..i]:setVisible(false)
        end
    end
end

function ShopDialog:onEnter()
    self:updateScore()
end

return ShopDialog
