--[[
	宴会
	Author: H.X.Sun
]]

local PartyView = qy.class("PartyView", qy.tank.view.BaseView, "legion/ui/club/PartyView")

function PartyView:ctor(delegate)
    PartyView.super.ctor(self)
    local head = qy.tank.view.legion.HeadCell.new({
        ["onExit"] = function()
            delegate.dismiss(false)
        end,
        ["showLine"] = false,
        ["titleUrl"] = "legion/res/jtjlb_08.png",
    })
    self:addChild(head,10)
    self:InjectView("bg")
    self:InjectView("list_empty")
    self:InjectView("times_txt")
    self.delegate = delegate
    self.model = qy.tank.model.LegionModel
end

function PartyView:createList()
    local tableView = cc.TableView:create(cc.size(421,527))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setDelegate()

    local function numberOfCellsInTableView(table)
        if self.model:getOpenPartyNum() == 0 then
            self.list_empty:setVisible(true)
        else
            self.list_empty:setVisible(false)
        end
        return self.model:getOpenPartyNum()
    end

    local function tableCellTouched(table,cell)
    end

    local function cellSizeForTable(tableView, idx)
        return 421,150
    end

    local function tableCellAtIndex(table, idx)
        local cell = table:dequeueCell()
        local item
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.legion.club.PartyCell.new({
                ["callback"] = function(_tag)
                    self:updateView()
                    if self.model:isOpenParty() then
                        self:__showGetTips()
                    end
                end
            })
            cell:addChild(item)
            cell.item = item
        end
        cell.item:update(idx + 1)

        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:reloadData()
    return tableView
end

function PartyView:updateView()
    self.times_txt:setString(self.model:getPartyTimes())
    if self.model:getCommanderEntity():isInParty() then
        if tolua.cast(self.openCell,"cc.Node") then
            self.openCell:getParent():removeChild(self.openCell)
        end

        if not tolua.cast(self.wList,"cc.Node") then
            self.wList = qy.tank.view.legion.club.WaitList.new({
                ["callback"] = function(_isGetAward)
                    self:updateView()
                    if _isGetAward then
                        self:__showGetTips()
                    end
                end
            })
            self.wList:setPosition(435,0)
            self.bg:addChild(self.wList)
        end
    else
        if tolua.cast(self.wList,"cc.Node") then
            self.wList:getParent():removeChild(self.wList)
        end

        if not tolua.cast(self.openCell,"cc.Node") then
            self.openCell = qy.tank.view.legion.club.OpenPCell.new({
                ["callback"] = function()
                    self:updateView()
                end
            })
            self.openCell:setPosition(435,0)
            self.bg:addChild(self.openCell)
        end
    end
    self.list:reloadData()
end

function PartyView:__showGetTips()
    local _d = self.model:getPartyAward()
    local msg = {
        {id=1,color={255,255,255},alpha=255,text = qy.TextUtil:substitute(51036, _d[2], _d[1]) , font=qy.res.FONT_NAME_2,size=24},
    }
    qy.alert:show({qy.TextUtil:substitute(51039) ,{255,183,0} }  ,  msg , cc.size(550 , 260),{{qy.TextUtil:substitute(51040) , 5}} ,function()end,"")
    self.model:setHasPartyAward(false)
end

function PartyView:onEnter()
    if not tolua.cast(self.list,"cc.Node") then
        self.list = self:createList()
        self.list:setPosition(6,8)
        self.bg:addChild(self.list)
    end
    self:updateView()

    if self.model:getHasPartyAward() then
        self:__showGetTips()
    end
end

return PartyView
