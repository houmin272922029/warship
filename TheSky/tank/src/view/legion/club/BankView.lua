--[[
	金库
	Author: H.X.Sun
]]

local BankView = qy.class("BankView", qy.tank.view.BaseView, "legion/ui/club/BankView")

function BankView:ctor(delegate)
    BankView.super.ctor(self)
    local head = qy.tank.view.legion.HeadCell.new({
        ["onExit"] = function()
            delegate.dismiss(false)
        end,
        ["showLine"] = true,
        ["titleUrl"] = "legion/res/juntuanjinku.png",
    })
    self:addChild(head,10)
    self.delegate = delegate
    self.model = qy.tank.model.LegionModel
    local service = qy.tank.service.LegionService

    self:InjectView("img_right")
    self:InjectView("level")
    self:InjectView("bar")
    self:InjectView("bar_num")
    self:InjectView("l_name_txt")
    self:InjectView("contribute_txt")
    self:InjectView("rank_txt")
    self:InjectView("post_txt")
    self:InjectView("get_btn")

    for i = 1, 3 do
        self:InjectView("num_"..i)
        self:InjectView("coin_" ..i)
        if i ~= 3 then
            self:InjectView("cost_num_"..i)
            self:OnClick("donate_btn_"..i,function()
                service:getBankGiving(i,function()
                    qy.hint:show(qy.TextUtil:substitute(51001))
                    self:updateOwnInfo()
                end)
            end)
        end
    end
    self:OnClick("get_btn",function()
        if self.model:getCommanderEntity().has_get_salay then
            qy.hint:show(qy.TextUtil:substitute(51002))
            return
        end
        service:getBankAward(function()
            self:updateGtnBtnStatus()
        end)
    end)
end

function BankView:updateGtnBtnStatus()
    if self.model:getCommanderEntity().has_get_salay then
        self.get_btn:setBright(false)
    else
        self.get_btn:setBright(true)
    end
end

function BankView:updateOwnInfo()
    local uEntity = self.model:getCommanderEntity()
    local lEntity = self.model:getHisLegion()
    self.level:setString("Lv."..lEntity.level)
    self.l_name_txt:setString(lEntity.name)
    self.bar:setPercent(lEntity:getExpPerNum())
    self.bar_num:setString(lEntity:getExpPerDesc())
    self.contribute_txt:setString(uEntity:getContributionStr())
    self.rank_txt:setString(uEntity.user_score)
    self.post_txt:setString(uEntity:getPostName())
    local costArr = self.model:getBankCostArr()
    for i = 1, 2 do
        self["cost_num_"..i]:setString(costArr[tostring(i)])
    end
    local data = self.model:getSalary()
    for i = 1, 3 do
        self["num_" ..i]:setString("x "..data[i].s_num)
        self["coin_" ..i]:setTexture(data[i].icon)
    end
    self.list:reloadData()
end

function BankView:createList()
    local tableView = cc.TableView:create(cc.size(730,317))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setDelegate()

    local function numberOfCellsInTableView(table)
        return self.model:getBankLogNum()
    end

    local function tableCellTouched(table,cell)
    end

    local function cellSizeForTable(tableView, idx)
        return 730,42
    end

    local function tableCellAtIndex(table, idx)
        local cell = table:dequeueCell()
        local item
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.legion.club.BankCell.new()
            cell:addChild(item)
            cell.item = item
        end
        cell.item:update(self.model:getBankLogDataByIndex(idx + 1))

        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:reloadData()
    return tableView
end

function BankView:onEnter()
    if not tolua.cast(self.list,"cc.Node") then
        self.list = self:createList()
        self.list:setPosition(3,123)
        self.img_right:addChild(self.list)
    end
    self:updateOwnInfo()
    self:updateGtnBtnStatus()
end

return BankView
