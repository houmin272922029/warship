local ShopView = qy.class("ShopView", qy.tank.view.BaseDialog, "lucky_indiana.ui.ShopView")

local service = qy.tank.service.OperatingActivitiesService
local model = qy.tank.model.OperatingActivitiesModel
local activity = qy.tank.view.type.ModuleType
local userInfoModel = qy.tank.model.UserInfoModel
function ShopView:ctor(delegate)
   	ShopView.super.ctor(self)
    self:InjectView("num")--个数
   	self:InjectView("Bt1")
   	self:InjectView("Bt2")
    self:InjectView("Panel_5")
    self:InjectView("time")
   	self:InjectView("closeBt")
    self:InjectView("typeimg")
 
    self.types = 1
    self:OnClick("closeBt", function()
        self:removeSelf()
    end,{["isScale"] = false})

    self.list = self:createView(1)
    self.Panel_5:addChild(self.list)
    self.typeimg:loadTexture("lucky_indiana/res/jubian1.png",1)
    self:updateBt(false)
    self:OnClick("Bt1", function()
        self.types = 1
        self:updateBt(false)
        self:updatenum() 
        self.Panel_5:removeAllChildren()
        self.list = self:createView(self.types)
        self.Panel_5:addChild(self.list)
        self.typeimg:loadTexture("lucky_indiana/res/jubian1.png",1)
    end)
    self:OnClick("Bt2", function()
        self.types = 2
        self:updatenum() 
        self:updateBt(true)
        self.Panel_5:removeAllChildren()
        self.list = self:createView(self.types)
        self.Panel_5:addChild(self.list)
        self.typeimg:loadTexture("lucky_indiana/res/liebian.png",1)
    end)  

    self:updatenum() 
  
end
function ShopView:updatenum( )
    
    local num = 0
    if self.types == 1 then
        num = userInfoModel.userInfoEntity.ucrystal
        print("更新1111",num)
    else
        num = userInfoModel.userInfoEntity.icrystal
        print("更新2222",num)
    end
    print("更新",num)
    self.num:setString(num)
end
function ShopView:updateBt( type1 )
    if type1 == false then
        self.Bt2:setTouchEnabled(true)
        self.Bt2:setEnabled(true)
    else
        self.Bt2:setTouchEnabled(false)
        self.Bt2:setEnabled(false)
        
    end
    self.Bt1:setTouchEnabled(type1)
    self.Bt1:setEnabled(type1)
end
function ShopView:createView(types)
    local tableView = cc.TableView:create(cc.size(850, 480))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    -- tableView:setSwallowTouches(false)
    -- tableView:setTouchEnabled(false)
    tableView:setPosition(0, 0)

    local tempnum = 0
    local data = {}
   
    if types ==1 then
        tempnum =  table.nums(model.fusionshopcfg)
        data = model.fusionshopcfg
    else
        tempnum = table.nums(model.fissionshopcfg)
        data = model.fissionshopcfg
    end

    local function numberOfCellsInTableView(tableView)
        local num =math.ceil(tempnum/3)
        return num
    end

    local function cellSizeForTable(tableView,idx)
        return 850, 240
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        local label = nil
        -- local data = model:getList(idx)
        -- local height = model:getHeight(idx)
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("lucky_indiana.src.ShopCell").new({
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

function ShopView:onEnter()
   
    
end

function ShopView:onExit()
   -- cc.Director:getInstance():getTextureCache():removeAllTextures()
end

return ShopView
