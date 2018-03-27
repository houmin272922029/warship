--[[
	加入 & 创建 军团
	Author: H.X.Sun
]]

local MobilizeView = qy.class("MobilizeView", qy.tank.view.BaseView, "legion/ui/mobilize/MobilizeView")

local posArr = {{0,1},{1,1},{0,0},{1,0}}--位置
local service = qy.tank.service.LeMobilizeService

function MobilizeView:ctor(delegate)
    print("MobilizeView:ctor")
    MobilizeView.super.ctor(self)
    local head = qy.tank.view.legion.HeadCell.new({
        ["onExit"] = function()
            delegate.dismiss(false)
        end,
        ["showLine"] = true,
        ["titleUrl"] = "legion/res/mobilize/title.png",
    })
    self:addChild(head,10)

    self:InjectView("create_node")
    self:InjectView("join_node")
    self:InjectView("list_empty")
    self:InjectView("bg_mobi")
    self:InjectView("cost_txt")
    self:InjectView("btn_txt")

    self.model = qy.tank.model.LeMobilizeModel

    self.tab = qy.tank.widget.TabButtonGroup.new("widget/TabButton1",{qy.TextUtil:substitute(52014), qy.TextUtil:substitute(52015)},cc.size(190,67),"h",function(idx)
        self:createContent(idx)
    end, 1)
    self:addChild(self.tab)
    self.tab:setPosition(110,qy.winSize.height-140)
    self.tab:setLocalZOrder(4)

    self:OnClick("refresh_btn", function(sender)
        local function onClickLogic()
            service:refresh(function()
                self:updateMobilizeInfo()
            end)
        end
        if self.model:hasRefreshTips() then
            qy.alert:show(
                {qy.TextUtil:substitute(52016) ,{255,255,255} } ,
                {{id=1,color={255,255,255},alpha=255,text=qy.TextUtil:substitute(52017),font=qy.res.FONT_NAME_2,size=24}} ,
                    cc.size(533 , 260) ,{{qy.TextUtil:substitute(52018) , 4} , {qy.TextUtil:substitute(52019) , 5} } ,
                function(flag)
                    if qy.TextUtil:substitute(52019) == flag then
                        onClickLogic()
                    end
            end)
        else
            onClickLogic()
        end
    end)
end

function MobilizeView:createContent(_idx)
    if _idx == 1 then
        self.join_node:setVisible(false)
        self.create_node:setVisible(true)
        if not tolua.cast(self.list,"cc.Node") then
            self.list = self:createList()
            self.create_node:addChild(self.list)
            self.list:setPosition(6,5)
        else
            self.list:reloadData()
        end
    else
        self.join_node:setVisible(true)
        self.create_node:setVisible(false)
        if self.initiateArr == nil then
            self.initiateArr = {}
        end
        self:updateMobilizeInfo()
    end

end

function MobilizeView:updateMobilizeInfo()
    for i = 1, 4 do
        if not tolua.cast(self.initiateArr[i],"cc.Node") then
            self.initiateArr[i] = qy.tank.view.legion.mobilize.MobilizeCell.new({["callBack"]=function()
                self.tab:switchTo(1)
            end})
            self.bg_mobi:addChild(self.initiateArr[i])
            self.initiateArr[i]:setPosition(posArr[i][1] * 492,posArr[i][2] * 224 + 7)
        end
        self.initiateArr[i]:update(i)
    end
    self.cost_txt:setVisible(not self.model:isFree())
    cc.SpriteFrameCache:getInstance():addSpriteFrames("legion/res/mobilize/mobilize.plist")
    if self.model:isFree() then
        self.btn_txt:setSpriteFrame("legion/res/mobilize/mianfeishuaxin.png")
    else
        self.btn_txt:setSpriteFrame("legion/res/mobilize/shuaxin.png")
    end
end

function MobilizeView:createList()
    local tableView = cc.TableView:create(cc.size(995,520))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setDelegate()

    local function numberOfCellsInTableView(table)
        if self.model:getListNum() == 0 then
            self.list_empty:setVisible(true)
        else
            self.list_empty:setVisible(false)
        end
        return self.model:getListNum()
    end

    local function tableCellTouched(table,cell)

    end

    local function cellSizeForTable(tableView, idx)
        return 995, 200
    end

    local function tableCellAtIndex(table, idx)
        local cell = table:dequeueCell()
        local item
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.legion.mobilize.JoinCell.new({
                ["callForAward"] = function()
                    local move = cc.MoveBy:create(0.2, cc.p(995, 0))
                    local delay = cc.DelayTime:create(0.2)
                    local seq = cc.Sequence:create(move,delay,cc.CallFunc:create(function()
                        tableView:reloadData()
                    end))
                    cell:runAction(seq)
                end,
                ["callForJoin"] = function()
                    tableView:reloadData()
                end,
            })
            cell:addChild(item)
            cell.item = item
        end
        cell.item:render(self.model:getEntityByIdx(idx + 1))
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:reloadData()
    return tableView
end

return MobilizeView
