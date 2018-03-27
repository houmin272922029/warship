local MainDialog = qy.class("MainDialog", qy.tank.view.BaseView, "god_of_war/ui/MainView")

local model = qy.tank.model.GodWarModel
local service = qy.tank.service.GodWarService
local GarageModel = qy.tank.model.GarageModel
function MainDialog:ctor(delegate)
   	MainDialog.super.ctor(self)
    local style = qy.tank.view.style.ViewStyle1.new({
        titleUrl = "god_of_war/res/titleimg.png",
        ["onExit"] = function()
            delegate:finish()
        end
    })
    self:addChild(style, 13)
    self:InjectView("listbg")
    self:InjectView("getBt")
    self:InjectView("titleimg")
    self:InjectView("titletext")
    self:InjectView("awardtext")
    self:InjectView("tequantext")
    self:InjectView("numstest")
    self:InjectView("awardbg")
    self:InjectView("yilingqu")
    for i=1,6 do
        self:InjectView("shuxing"..i)
    end
    self:OnClick("getBt",function ( sender )
        service:getAward(function (  )
            model.status = 1
            self:updateslect()
        end)
    end)
    self.slectid = model.sviplevel == 0 and 1 or model.sviplevel
    self.datalist = self:__createList()
    self.listbg:addChild(self.datalist)
    self:updateslect()

end
function MainDialog:updateslect(  )
    for i=1,6 do
        self["shuxing"..i]:setVisible(false)
    end
    self.awardbg:removeAllChildren(true)
    self.numstest:setString("本月已充值"..model.rechagenum..model.TypeNameList[tostring(15)])
    local png = "god_of_war/res/s"..self.slectid..".png"
    self.titleimg:setSpriteFrame(png)
    self.awardtext:setString(model.TypeNameList[tostring(11)]..model.TypeNameList[tostring(self.slectid)]..model.TypeNameList[tostring(12)])
    self.tequantext:setString(model.TypeNameList[tostring(11)]..model.TypeNameList[tostring(self.slectid)]..model.TypeNameList[tostring(13)])
    self.getBt:setVisible(self.slectid == model.sviplevel and model.status == 0)
    self.yilingqu:setVisible(self.slectid == model.sviplevel and model.status == 1)
    local data = model:getDataByid(self.slectid)
    self.titletext:setString(model.TypeNameList[tostring(14)]..data.diamond..model.TypeNameList[tostring(15)])
    for i=1,#data.award do
        local item = qy.tank.view.common.AwardItem.createAwardView(data.award[i], 1)
        item:setPosition( 100 *i -50,42)
        item:showTitle(false)
        item:setScale(0.8)
        self.awardbg:addChild(item,99,99)
    end
    --特权
    for i=1,data.num do
        self["shuxing"..i]:setVisible(true)
        self["shuxing"..i]:setString(data["desc_"..i])
    end
end
function MainDialog:__createList()
    local tableView = cc.TableView:create(cc.size(250, 415))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(5,0)
    tableView:setDelegate()
    local data2 = table.nums(model.localfittingcfg)
    -- print("+++++++++++++++",json.encode(data2))

    local function numberOfCellsInTableView(table)
        return data2
    end

    local function tableCellTouched(table,cell)
    end

    local function cellSizeForTable(tableView, idx)
        return 250, 62
    end

    local function tableCellAtIndex(table, idx)
        local cell = table:dequeueCell()
        local item
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("god_of_war.src.Cell").new({
                ["callback"] = function (_indx)
                    self.slectid = _indx
                    self:updateslect()
                    local listCurY = self.datalist:getContentOffset().y
                    self.datalist:reloadData()
                    self.datalist:setContentOffset(cc.p(0,listCurY))
                end
            })
            cell:addChild(item)
            cell.item = item
        end
        cell.item.idx = idx
        cell.item:render(idx + 1,self.slectid)
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:reloadData()
    if self.slectid > 6 then
        tableView:setContentOffset(cc.p(0,0))
    end
    return tableView
end


return MainDialog