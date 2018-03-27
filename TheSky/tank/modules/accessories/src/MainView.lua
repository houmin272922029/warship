--[[
	配件系统
	Author: 
]]

local MainView = qy.class("MainView", qy.tank.view.BaseView, "accessories/ui/MainView")

local userModel = qy.tank.model.UserInfoModel
local service = qy.tank.service.FittingsService
local model = qy.tank.model.FittingsModel
local garageModel = qy.tank.model.GarageModel
local StorageModel = qy.tank.model.StorageModel
local UserInfoModel = qy.tank.model.UserInfoModel
local fittings_list = {}

function MainView:ctor(delegate)
    MainView.super.ctor(self)
    self:InjectView("helpBt")
    self:InjectView("closeBt")
    self:OnClick("helpBt",function()
        qy.tank.view.common.HelpDialog.new(49):show(true)
    end)
    self:OnClick("closeBt",function()
        delegate:finish()
    end,{["isScale"] = false})
    for i=1,3 do
        self:InjectView("num"..i)--上面的三个资源
    end
    self:InjectView("pannel1")
    self:InjectView("jinglianBt1")
    self:InjectView("tanklist")
    self:InjectView("tankimg")
    self:InjectView("partinfo1")
    self:InjectView("nopart1")
    self:InjectView("fangda")
    self:InjectView("Btlist")
    self:InjectView("changeBt")
    self:InjectView("exchangnum1")
    self:InjectView("xuanzhong")
    for i=1,8 do
        self:InjectView("part"..i)
        self:InjectView("partbg"..i)
    end

    self:InjectView("pannel2")
    self:InjectView("shuaixuanBt")
    self:InjectView("garagelist")
    self:InjectView("jinglianBt2")
    self:InjectView("nopart2")
    self:InjectView("partinfo2")
    self:InjectView("exchangnum2")
    self:InjectView("pannel2btbg")
    self:InjectView("storenum")

    self:InjectView("pannel3")
    self:InjectView("partlists")
    self:InjectView("fenjieBt")--分解货熔炼
    self:InjectView("fenjieallBt")--一键干啥
    self:InjectView("fenjietext")
    self:InjectView("fenjiebtimg")
    self:InjectView("fenjjieallimg")
    self:InjectView("shuaixuanBt2")

    self:InjectView("pannel4")
    self:InjectView("shoplist")
    self:InjectView("shuaxinBt")
    self:InjectView("shuaxinnum")
  
    self.tab = qy.tank.widget.TabButtonGroup.new("widget/TabButton1",{"坦克配件", "配件仓库","配件熔炼","配件分解","配件商店"},cc.size(185,67),"h",function(idx)
        self:createContent(idx)
    end, 1)
    self.tab:setPosition(qy.winSize.width/2-475,qy.winSize.height-140)
    self.tab:setLocalZOrder(4)

    self:OnClick("shuaixuanBt",function()
        local node = require("accessories.src.ScreenDialog").new({
            ["callback"] = function ( data1,data2 )
                -- print("帅选回来啊",data1)
                -- print("ooo",json.encode(data2))
                self:createList(data1,data2)
            end
        }):show()
    end,{["isScale"] = false})
    self:OnClick("jinglianBt1",function()
        local unique_id = self.tankflist[tostring(self.choosemedal)]
        local data = model:getFittingsById(unique_id)
        local num = model:GetupdataBydata(data)
        local funs = function (  )
            service:EliteAttr(data.unique_id,function ( data )
                self:updateziyuan()
                self:updateTank(false)
            end)
        end
        if model.jingliantype == 0 then
            local node = require("accessories.src.Tip1").new({
                ["num"] = num,
                ["level"] = data.level,
                ["type"] = 1,
                ["callback"] = function ( )
                    funs()
                end
            }):show()
        else
            funs()
        end

    end)
    --仓库里精炼
    self:OnClick("jinglianBt2",function()
        local data = self.scoredata[self.storeindex]
        local num = model:GetupdataBydata(data)
        if model.jingliantype == 0 then
            local node = require("accessories.src.Tip1").new({
                ["num"] = num,
                ["type"] = 1,
                ["level"] = data.level,
                ["callback"] = function ( )
                    service:EliteAttr(data.unique_id,function ( data )
                        self:updateziyuan()
                        local list = {}
                        for k,v in pairs(data) do
                             table.insert(list,v)
                        end
                        self.scoredata[self.storeindex] = list[1]
                        self:showStoreSelect()
                    end)
                end
            }):show()
        else
            service:EliteAttr(data.unique_id,function ( data )
                self:updateziyuan()
                local list = {}
                for k,v in pairs(data) do
                     table.insert(list,v)
                end
                self.scoredata[self.storeindex] = list[1]
                self:showStoreSelect()
            end)
        end

    end)
    self:OnClick("changeBt",function()
        service:fittingsOff(self.selectTankdata[self.choosetank..""].unique_id,self.choosemedal,function (  )
            self.partinfo1:removeAllChildren(true)
            self:updateTank(true)
        end)
    end)
    self:OnClick("fenjieBt",function (  )
        if #self.fenjielist == 0 then
            if self.shaixuantype == 1 then
                 qy.hint:show("请勾选要熔炼的配件")
            else
                 qy.hint:show("请勾选要分解的配件")
            end
            return
        end
        local list = {}
        for i=1,#self.fenjielist do
            table.insert(list,self.scoredata1[self.fenjielist[i]].unique_id)
        end
        -- print("分解最终的list",json.encode(list))
        if self.shaixuantype == 1 then
            service:smeltFittings(list,function (  )
                self:updateziyuan()
                self.fenjielist = {}
                self:createMeltingList(1,1)
            end)

        else
            local function callBack(flag)
                if qy.TextUtil:substitute(37011) == flag then
                    service:fenjie(list,function (  )
                        self:updateziyuan()
                        self.fenjielist = {}
                        self:createMeltingList(1,1)
                    end)
                end
            end
            local nums = model:getfenjienums(list)
            -- print("iiiiiiiiii",nums)
            local str = "确定要分解选中的配件吗？分解后将获得"..nums.."铸铁"
            qy.alert:show(qy.TextUtil:substitute(37032),  str, cc.size(560,250), {{qy.TextUtil:substitute(37015) , 4},{qy.TextUtil:substitute(37011) , 5} }, callBack, {})
        end
       
    end)
    self:OnClick("shuaxinBt",function()
        if model.refreshtype == 0 then
            local node = require("accessories.src.Tip1").new({
                ["num"] = self.shuanum,
                ["type"] = 2,
                ["callback"] = function (  )
                    service:refreshShopView(function (  )
                        self:updateziyuan()
                        self:createshopView()
                    end)
                end
            }):show()
        else
            service:refreshShopView(function (  )
                self:updateziyuan()
                self:createshopView()
            end)
        end
    end)
    self:OnClick("shuaixuanBt2",function()
        local node = require("accessories.src.ScreenDialog").new({
            ["callback"] = function ( data1,data2 )
                self:createMeltingList( data1,data2)
            end
        }):show()
    end,{["isScale"] = false})
    self:OnClick("fenjieallBt",function()
        if self.shaixuantype == 1 then
            local node = require("accessories.src.ChoiseDialog1").new({
                ["type"] = self.shaixuantype,
                ["callback"] = function (  )
                    self:updateziyuan()
                    self.fenjielist = {}
                    self:createMeltingList(1,1)
                end
            }):show()
        else
            local node = require("accessories.src.ChoiseDialog").new({
                ["type"] = self.shaixuantype,
                ["callback"] = function (  )
                    self:updateziyuan()
                    self.fenjielist = {}
                    self:createMeltingList(1,1)
                end
            }):show()
        end
    end,{["isScale"] = false})
    for i=1,8 do
        self:OnClick("part"..i,function (  )
            if fittings_list[tostring(i)] == 0 then
                self:addFittings(i)
            else
                self.choosemedal = i
                self:showSelectProp(i)
            end
        end,{["isScale"] = false})
    end
    self:OnClick("fangda",function (  )
        if self.Btflag  ==  1 then
            qy.hint:show("请装备配件后查看")
        else
            local node = require("accessories.src.TotalTip").new({
                ["tank_id"] = self.selectTankdata[self.choosetank..""].unique_id
            }):show()
        end
    end)
    self.selectTankdata = {}
    self.shopbt = 0 --商店每次进入只请求一次
    self.shaixuantype = 1 --筛选
    self.choosetank = 0
    self.Btflag  = 0 --放大精炼按钮
    self:addChild(self.tab)
    -- self:createList(1,1) -- 初始化仓库
    self:updateziyuan()
    
    self.tanklist:addChild(self:createView())
end
function MainView:createshopView(  )
    self.shoplist:removeAllChildren(true)
    self.shuanum= 10 + math.floor((model.refreshtimes/5))*10
    self.shuanum = self.shuanum > 100 and 100 or self.shuanum
    self.shuaxinnum:setString(self.shuanum)
    for i = 1,#model.ShopList do
        local node = require("accessories.src.ShopCell").new({
            ["_idx"] = i,
            ["callback"] = function (  )
                self:createshopView()
                self:updateziyuan()
            end
            })
        if i<= 4 then
            node:setPosition(cc.p(-245 + i * 250,270))
        elseif (i > 4 and i < 9) then
            node:setPosition(cc.p(-245 + (i-4) * 250,135))
        else
            node:setPosition(cc.p(-245 + (i-8) * 250,0))
        end
        
        self.shoplist:addChild(node)
    end
end
function MainView:updateziyuan(  )
    self.num1:setString(UserInfoModel.userInfoEntity.fine_iron)
    self.num2:setString(UserInfoModel.userInfoEntity.smelting_integral)
    self.num3:setString(UserInfoModel.userInfoEntity.diamond)
end
function MainView:createContent(_idx)
    self.storeindex = 1 
    self.fenjielist = {}
    self.shaixuan = {0} 
    self.shaixuanqulity = {0} 
    self.scoredata = {}
    self.pannel1:setVisible(_idx == 1)
    self.pannel2:setVisible(_idx == 2 )
    self.pannel3:setVisible(_idx == 4 or _idx == 3)
    self.pannel4:setVisible(_idx == 5)
    self.fenjietext:setVisible(_idx == 4)
    if _idx == 1 then
       
    elseif _idx == 2 then
        self:createList(1,1) -- 初始化仓库
    elseif _idx == 3 then
        self.shaixuantype = 1
        self:createMeltingList(1,1)--初始化熔炼和分解
        self.fenjjieallimg:loadTexture("accessories/res/ronglian1.png",1)
        self.fenjiebtimg:loadTexture("accessories/res/ronglian.png",1)
    elseif _idx == 4 then
        self.shaixuantype = 2
        self:createMeltingList(1,1)--初始化熔炼和分解
        self.fenjjieallimg:loadTexture("accessories/res/yijianfenjie.png",1)
        self.fenjiebtimg:loadTexture("accessories/res/fenjie.png",1)
    elseif _idx == 5 then
        if self.shopbt == 0 then
            service:showShopView(function (  )
                self.shopbt = 1
                self:createshopView()--初始化商店
                self:updaterefreshtime()
            end)
        end
    end

end
function MainView:updatestore(  )
    -- body
end
function MainView:initpannel1( )
    self.Btflag  = 1
    self.nopart1:setVisible(true)
    self.Btlist:setVisible(false)
    self.xuanzhong:setVisible(false)
    for i=1,8 do
        self["part"..i]:loadTexture("accessories/res/partbg"..i..".png",1)
        self["partbg"..i]:setSpriteFrame("Resources/common/item/item_bg_1.png")
    end
end
function MainView:addFittings( pos )
    local data = model:getFittingsByPos(pos)
    if #data == 0 then
        qy.hint:show("没用此类型的配件")
    else
        local node = require("accessories.src.ChooseTip").new({
            ["data"] = data,
            ["callback"] = function ( _index )
                service:fittingsPutOn(data[_index].unique_id,self.selectTankdata[self.choosetank..""].unique_id,function (  )
                    self.choosemedal = pos
                    self:updateTank(false)
                end)
            end
        }):show()
    end

end
function MainView:updateTank( flag )--flag 为true 要刷新选中第几个为false 反之
    self.partinfo1:removeAllChildren(true)
    self.selectTank.item.light:setVisible(true)
    self.Btlist:setVisible(true)
    self.nopart1:setVisible(false)
    local entity = self.selectTank.item.entity
    self.tankimg:setTexture(entity:getImg())
    self.tankimg:setScale(0.55)
    print("kkkkkkk",self.selectTankdata[self.choosetank..""].unique_id)
    self.tankflist = model:atTank(self.selectTankdata[self.choosetank..""].unique_id)
    local ta = table.nums(self.tankflist)
    -- print("===========1",json.encode(self.tankflist))
    if ta ~= 0 then
        num = 1
        for i=1,8 do
            if self.tankflist[tostring(i)] then
                fittings_list[tostring(i)] = self.tankflist[tostring(i)]
            else
                fittings_list[tostring(i)] = 0 
            end
        end
        if fittings_list["1"] == 0 and fittings_list["2"] == 0 and fittings_list["3"] == 0 and fittings_list["4"] == 0 and fittings_list["5"] == 0 and fittings_list["6"] == 0 and fittings_list["7"] == 0 and fittings_list["8"] == 0 then
            self:initpannel1()
        else 
            self.Btflag  = 0
            --初始化坦克身上的配件
            for i=1,8 do
                if fittings_list[tostring(i)] ~= 0 then
                    local fittings_id = model.totallist[tostring(fittings_list[tostring(i)])].fittings_id--配件id
                    local medaldata = model.localfittingcfg[fittings_id..""]
                    local idds = medaldata.fittings_type
                    local pngs = "accessories/res/part"..idds..".png"
                    self["part"..i]:loadTexture(pngs,1)
                    local png = "Resources/common/item/item_bg_"..medaldata.quality..".png"
                    self["partbg"..i]:setSpriteFrame(png)
                else
                    self["part"..i]:loadTexture("accessories/res/partbg"..i..".png",1)
                    self["partbg"..i]:setSpriteFrame("Resources/common/item/item_bg_1.png")
                end
            end
        end
        if flag == true then
            self.choosemedal = 0
            for i=1,8 do
                if fittings_list[tostring(i)] ~= 0 then
                    self.choosemedal = i
                    break
                end
            end
        end
        self:showSelectProp()--刷新右边数值数值
    else
        for i=1,8 do
            fittings_list[i..""] = 0
        end
        self:initpannel1()
    end
end
function MainView:showSelectProp(idx)
    self.xuanzhong:setVisible(true)
    self.xuanzhong:setPosition(self["partbg"..self.choosemedal]:getPosition())
    -- print("self.choosemedal",self.choosemedal)
    local unique_id = self.tankflist[tostring(self.choosemedal)]
    local data = model:getFittingsById(unique_id)
    -- print("=============tank",json.encode(data))
    local num = model:GetupdataBydata(data)
    self.exchangnum1:setString(num)
    self.jinglianBt1:setTouchEnabled(num ~= 0)
    self.jinglianBt1:setBright(num ~= 0)
    self.partinfo1:removeAllChildren(true)
    local node = require("accessories.src.Partinfo").new({
        ["data"] = data
        })
    node:setPosition(cc.p(140,210))
    self.partinfo1:addChild(node)
    
end
---仓库详细
function MainView:showStoreSelect()
    local data = self.scoredata[self.storeindex]
    -- print("=============仓库",json.encode(data))
    local num = model:GetupdataBydata(data)
    self.exchangnum2:setString(num)
    self.jinglianBt2:setTouchEnabled(num ~= 0)
    self.jinglianBt2:setBright(num ~= 0)
    self.partinfo2:removeAllChildren(true)
    local node = require("accessories.src.Partinfo").new({
        ["data"] = data
        })
    node:setPosition(cc.p(140,210))
    self.partinfo2:addChild(node)
end

function MainView:createView()
    local tableView = cc.TableView:create(cc.size(211, 530))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(0, 5)
    tableView:setDelegate()

    self.tanks = {}

    local function numberOfCellsInTableView(tableView)
        return #garageModel.formation
    end

    local function cellSizeForTable(tableView,idx)
        return 210, 125
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        self.selectTankdata[idx..""] = garageModel.formation[idx+1]
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.garage.GarageTankCell.new(garageModel.formation[idx+1], idx + 1,true)
            cell:addChild(item)
            cell.item = item
            if idx == self.choosetank then
                cell.item.light:setVisible(true)
                self.selectTank = cell
                self:updateTank(true)
            end
            table.insert(self.tanks, cell)
        end

        cell.item:render(garageModel.formation[idx+1], idx+1)
        cell.item.entity = garageModel.formation[idx+1]
        cell.idx = idx + 1
        return cell
    end

    local function tableAtTouched(table, cell)
        if type(cell.item.entity) == "table" then
            for i, v in pairs(self.tanks) do
                v.item.light:setVisible(false)
            end

            cell.item.light:setVisible(true)
            self.choosetank = cell.idx - 1
            self.selectTank = cell
            self:updateTank(true)
        elseif cell.item.entity == 0 then
            qy.tank.command.GarageCommand:showUnselectedTankListDialog(false,function(uid)
                local service = qy.tank.service.GarageService
                service:lineup(1,1,"p_"..cell.idx,uid,function()
                    self.choosetank = cell.idx - 1
                    qy.Event.dispatch(qy.Event.LINEUP_SUCCESS)
                    qy.tank.command.GarageCommand:hideTankListDialog()
                end)
            end)
        elseif cell.item.entity == -1 then
            qy.hint:show(qy.TextUtil:substitute(66012),0.5)
        end
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:registerScriptHandler(tableAtTouched,cc.TABLECELL_TOUCHED)

    tableView:reloadData()

    self.tankViewList = tableView

    return tableView
end
function MainView:createList(postype ,qulity)
    self.propList = {}
    self.partinfo2:removeAllChildren(true)
    self.garagelist:removeAllChildren(true)
    self.propList = cc.TableView:create(cc.size(710,440))
    self.propList:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.propList:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    -- local w = (qy.winSize.width - 1080)/6
    -- self.right:setPositionX(self.right:getPositionX()-w*2)
    self.propList:setPosition(0,0)
    self.garagelist:addChild(self.propList)
    self.propList:setDelegate()
    self.cellArr = {}
   
    self.scoredata = model:GetStoreList(postype,qulity)
    local num = #self.scoredata
    self.nopart2:setVisible(num == 0)
    self.pannel2btbg:setVisible(num ~= 0)
    local data2 = model:GetStoreList(1,1)
    local numss = #data2
    if numss >= 1000 then
        self.storenum:setString("1000/1000")
        self.storenum:setColor(cc.c3b(251, 48, 0))
        local dialog = require("accessories.src.Tip2").new():show()
    else
        self.storenum:setString(numss.."/1000")
        self.storenum:setColor(cc.c3b(255, 255, 255))
    end
    local function numberOfCellsInTableView(table)
        return math.ceil(num/5)
    end

    local function cellSizeForTable(tableView, idx)
        return 710, 120
    end

    local function tableCellAtIndex(cTable, idx)
        local cell = cTable:dequeueCell()
        local item
        if nil == cell then
            cell = cc.TableViewCell:new()
            item =  require("accessories.src.PropCellList").new({
                ["data"] = self.scoredata,
                ["callback"] = function(index)
                    -- print("h回来啦",index)
                    self.storeindex = index
                    self:updateList()
                    self:showStoreSelect()
                end,
                ["isMoved"] = function ()
                    return cTable:isTouchMoved()
                end
            })
            cell:addChild(item)
            cell.item = item
            table.insert(self.cellArr,cell)
        end
        cell.item:render(idx,self.storeindex)
        return cell
    end

    self.propList:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.propList:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    self.propList:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)

    self.propList:reloadData()
    if num > 0 then
        self:showStoreSelect()
    end
end
function MainView:createMeltingList(postype ,qulity)
    self.partlists:removeAllChildren(true)
    self.meltingList = cc.TableView:create(cc.size(1000,340))
    self.meltingList:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.meltingList:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.meltingList:setPosition(0,0)
    self.partlists:addChild(self.meltingList)
    self.meltingList:setDelegate()
    self.cellArr1 = {}
    self.scoredata1 = model:GetStoreList(postype,qulity)
    local num = #self.scoredata1
    local function numberOfCellsInTableView(table)
        return math.ceil(num/5)
    end

    local function cellSizeForTable(tableView, idx)
        return 1000, 120
    end

    local function tableCellAtIndex(cTable, idx)
        local cell = cTable:dequeueCell()
        local item
        if nil == cell then
            cell = cc.TableViewCell:new()
            item =  require("accessories.src.PropCellList1").new({
                ["data"] = self.scoredata1,
                ["callback"] = function(type1 , _index)
                    if type1 == 1 then
                        table.insert(self.fenjielist,_index)
                    else
                        for i=1,#self.fenjielist do
                            if self.fenjielist[i] == _index then
                                table.remove(self.fenjielist,i)
                                break
                            end
                        end
                    end
                    -- print("分解啊",json.encode(self.fenjielist))
                end,
                ["isMoved"] = function ()
                    return cTable:isTouchMoved()
                end
            })
            cell:addChild(item)
            cell.item = item
            table.insert(self.cellArr1,cell)
        end
        cell.item:render(idx)
        return cell
    end

    self.meltingList:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.meltingList:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    self.meltingList:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)

    self.meltingList:reloadData()
end
function MainView:updateList()
    local listCurY = self.propList:getContentOffset().y
    self.propList:reloadData()
    self.propList:setContentOffset(cc.p(0,listCurY))
end
function MainView:updaterefreshtime(  )
    self.listener_1 = qy.Event.add(qy.Event.BONUS_TIME,function(event)
        if model.next_refresh_time - qy.tank.model.UserInfoModel.serverTime <= 0 then
            service:showShopView(function (  )
                self:createshopView()--初始化商店
            end)
        end
    end)
end

function MainView:onEnter()
    
     
end

function MainView:onExit()
    if self.listener_1 then
        qy.Event.remove(self.listener_1)
    end
end

return MainView
