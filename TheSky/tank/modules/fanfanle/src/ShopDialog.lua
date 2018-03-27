local ShopDialog = qy.class("ShopDialog", qy.tank.view.BaseDialog, "fanfanle.ui.ShopDialog")

local service = qy.tank.service.FanFanLeService
local model = qy.tank.model.FanFanLeModel
local activity = qy.tank.view.type.ModuleType
local userInfoModel = qy.tank.model.UserInfoModel
function ShopDialog:ctor(delegate)
   	ShopDialog.super.ctor(self)
    self:InjectView("num")--个数
    self:InjectView("pannellist")
   	self:InjectView("closeBt")
    self:InjectView("typeimg")
 
    self.types = 1
    self:OnClick("closeBt", function()
        self:removeSelf()
    end,{["isScale"] = false})
    self.tab = qy.tank.widget.TabButtonGroup.new("widget/TabButton2",{"日耀商店", "月华商店"},cc.size(170,67),"h",function(idx)
        self:createContent(idx)
    end, 1)

    self:addChild(self.tab)
    self.tab:setPosition(qy.winSize.width/2-455,qy.winSize.height-175)
    self.tab:setLocalZOrder(4)
  
end
function ShopDialog:createContent( _idx )
    self.types = _idx
    self:updatenum()
    self.pannellist:removeAllChildren()
    self.list = self:createView(_idx)
    self.pannellist:addChild(self.list)
    if _idx == 1 then
        self.typeimg:loadTexture("fanfanle/res/guang.png",0)
    else
        self.typeimg:loadTexture("fanfanle/res/riyao.png",0)
    end
end
function ShopDialog:updatenum( )
    local num = 0
    if self.types == 1 then
        num = userInfoModel.userInfoEntity.gcert
    else
        num = userInfoModel.userInfoEntity.scert
    end
    self.num:setString(num)
end
function ShopDialog:createView(types)
    local tableView = cc.TableView:create(cc.size(900, 470))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    -- tableView:setSwallowTouches(false)
    -- tableView:setTouchEnabled(false)
    tableView:setPosition(0, 0)

    local tempnum = 0
    local data = {}
   
    if types ==1 then
        tempnum =  #model.shoplist1
        data = model.shoplist1
    else
        tempnum = #model.shoplist2
        data = model.shoplist2
    end

    local function numberOfCellsInTableView(tableView)
        local num =math.ceil(tempnum/3)
        return num
    end

    local function cellSizeForTable(tableView,idx)
        return 900, 240
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        local label = nil
        -- local data = model:getList(idx)
        -- local height = model:getHeight(idx)
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("fanfanle.src.ShopCell").new({
                ["num"] = math.ceil(tempnum/3),
                ["data"] = data,
                ["types"] = types,
                ["callback"] = function (  )
                    self:updatenum()
                end
                })
            cell:addChild(item)
            cell.item = item
        end

        cell.item:setData(idx + 1,tempnum%3)
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    
    tableView:reloadData()
    self.tableView = tableView

    return tableView
end

function ShopDialog:onEnter()
   
    
end

function ShopDialog:onExit()
   
  
end

return ShopDialog
