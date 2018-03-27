local MainView = qy.class("MainView", qy.tank.view.BaseView, "passenger.ui.MainView")

local garageModel = qy.tank.model.GarageModel
local PassengerModel = qy.tank.model.PassengerModel
local StorageModel = qy.tank.model.StorageModel
local PassengerService = qy.tank.service.PassengerService
local UserInfoModel = qy.tank.model.UserInfoModel
local staicData = qy.Config.passenger
local typeNumList ={
    ["1"] = 20,
    ["2"] = 30,
    ["3"] = 50,
    ["4"] = 100,
    ["5"] = 150,
    ["6"] = 200,
    ["7"] = 300
}
local MOVE_INCH = 7.0/160.0
local function convertDistanceFromPointToInch(pointDis)
    local glview = cc.Director:getInstance():getOpenGLView()
    local factor = (glview:getScaleX() + glview:getScaleY())/2
    return pointDis * factor / cc.Device:getDPI()
end
function MainView:ctor(delegate)
   	MainView.super.ctor(self)
    self.delegate = delegate
    self:InjectView("passengerBG")
   	self:InjectView("TankList")
    self:InjectView("Btn_close")
    self:InjectView("chengyuan")
    self:InjectView("chengyuan1")
    self:InjectView("chengyuan2")
    self:InjectView("zhaomu")
    self:InjectView("tujian")
    self:InjectView("jinxiu")
    self:InjectView("Button_upGrade") --乘员升级
    self:InjectView("upAllBtn")
    self:InjectView("Button_next")
    self:InjectView("Button_up")
    self:InjectView("upTitle")
    self:InjectView("updesName")
    self:InjectView("Panel_1")
    self:InjectView("upPlayerBg")
    self:InjectView("upPlayerinfo")
    self:InjectView("upPlayerName")
    self:InjectView("upPlayer")
    self:InjectView("equip_show")
    self:InjectView("equip_rank")
    self:InjectView("yizhuangbei")
    self:InjectView("Panel_2")
    self:InjectView("Panel_list")
    self:InjectView("tujianProgress")
    self:InjectView("tujianProText")
    self:InjectView("attribute")
    self:InjectView("upGreadBtn")
    self:InjectView("equip_rank2")
    self:InjectView("equip_name2")
    self:InjectView("updesName2")
    self:InjectView("updes11")
    self:InjectView("Button_upGrade2")
    self:InjectView("autoBtn")
    self:InjectView("Text_level")
    self:InjectView("leveProgress")
    self:InjectView("Button_up_0")
    self:InjectView("Button_next_0")
    self:InjectView("Sprite_rank2")
    self:InjectView("PressageInfo2")
    self:InjectView("PressageName2")
    self:InjectView("equip_sprite")
    self:InjectView("Panel_3")
    self:InjectView("Panel_22")
    -- self:InjectView("Panel_222")
    self:InjectView("Panel_list_2")
    self:InjectView("Sprite_player")
    self:InjectView("levelProText")
    self:InjectView("cost1")
    self:InjectView("cost_11")
    self:InjectView("cost2")
    self:InjectView("free2_0")
    self:InjectView("free2_0_0")
    self:InjectView("Text_des21")
    self:InjectView("Image_diamond")
    self:InjectView("Image_card")
    self:InjectView("zmBooks")
    self:InjectView("zmCards")
    self:InjectView("diamonds")
    self:InjectView("upPlayer_1")
    self:InjectView("up_select")
    self:InjectView("hasno")
    self:InjectView("Button_9")
    self:InjectView("hasno_2")
    self:InjectView("remind1")
    --进修新增
    self:InjectView("hasno_jinxiu")
    self:InjectView("Button_up_jinxiu")
    self:InjectView("Button_next_jinxiu")
    self:InjectView("jinxiulist")
    self:InjectView("jinxiuBt")
    self:InjectView("Panel_top_jinxiu")
    self:InjectView("Sprite_22_jinxiu")
    self:InjectView("upPlayerBg_jinxiu")
    self:InjectView("upPlayer_1_jinxiu")
    self:InjectView("upPlayer_jinxiu")
    self:InjectView("up_select_jinxiu")
    self:InjectView("upPlayerinfo_jinxiu")
    self:InjectView("upPlayerName_jinxiu")
    self:InjectView("shuxinglist")
    self:InjectView("addpassBt")
    self:InjectView("addpassBtbg")
    self:InjectView("jinxiutext")
    self:InjectView("jinxiujindu")
    self:InjectView("shuxing1")
    self:InjectView("shuxing2")
    self:InjectView("dengji1")
    self:InjectView("addpannel")
    self:InjectView("dengji2")
    self:InjectView("piaozi")
    for i=1,3 do
        self:InjectView("jinxiu" .. i)
        self:InjectView("jinxiuadd" .. i)
        self:InjectView("jinxiushuxing" .. i)
    end
    for i=1,2 do
        self:InjectView("chooseBt" .. i)
        self:InjectView("choosejinxiu" .. i)
        self:InjectView("chujixiaohao" .. i)
        self:InjectView("gaojixiaohao" .. i)
    end
    self.choosejinxiu2:setVisible(false)
    self:InjectView("xiaohaopannel")
    self:InjectView("dengji2")
    self:refreshRedDot()
    for i=1,4 do
        self:InjectView("AnswerBtn" .. i)
        self:InjectView("upAttr" .. i)
        self:InjectView("M_Name" .. i)
        self:InjectView("M1" .. i)
        self:InjectView("M" .. i)
        self:InjectView("MM_" .. i)
        self:InjectView("pass" .. i)
        self:InjectView("M".. i .."_Name")
        self:InjectView("updes" .. i)
        self:InjectView("updesjinxiu" .. i)
        self:InjectView("upAttr" .. i)
        self:InjectView("updes1" .. i)
        self:InjectView("M_select" .. i)
        self:InjectView("zhaooneBt" .. i)
        self:InjectView("Btimg" .. i)
    end
    for i=1,4 do
        self:InjectView("Button_" .. i)
        self["Button_"..i]:setTitleFontName(qy.res.FONT_NAME)
        self["Button_"..i]:getTitleRenderer():enableOutline(cc.c4b(0,0,0,255),1)
    end
    for i=1,6 do
        self:InjectView("Text_des" .. i)
    end
    self:OnClick("Btn_close", function()
        if self.chengyuan2:isVisible() and self.chengyuan:isVisible() then
            self:createContent(1,1,true)
        else
            delegate:dismiss()
        end
    end,{["isScale"] = false})

    self:OnClick("Button_9", function()
        qy.tank.view.common.HelpDialog.new(qy.tank.model.HelpTxtModel:getHelpDataByIndx(25)):show(true)
    end,{["isScale"] = false})

    self.index = delegate.idx1 or 1
    self.index2 = delegate.idx2 or 1
    self:createContent(self.index,self.index2)

    self:OnClick("Button_1", function()
        self:createContent(1,1,true)
    end,{["isScale"] = false})
    self:OnClick("Button_2", function()
        self:createContent(2)
    end,{["isScale"] = false})
    self:OnClick("Button_3", function()
        self:createContent(3)
    end,{["isScale"] = false})
    self:OnClick("Button_4", function()
        local open_level = qy.tank.model.RoleUpgradeModel:getOpenLevelById(54)
        if qy.tank.model.UserInfoModel.userInfoEntity.level >= open_level then
            self:createContent(4)
        else
            qy.hint:show("乘员进修"..qy.TextUtil:substitute(70044, open_level))
            return
        end
        
    end,{["isScale"] = false})


    --乘员
    self:OnClick("Button_up", function()
        if PassengerModel.page > 1 then
            local page = PassengerModel.page - 1
            PassengerModel:setPage(page)
            self:updatePassengerList()
            self:updateTank()
        else
            qy.hint:show("没有更多乘员")
        end
    end,{["isScale"] = false})

    self:OnClick("Button_next", function()
        if PassengerModel.page < PassengerModel:getMaxPage() then
            local page = PassengerModel.page + 1
            PassengerModel:setPage(page)
            self:updatePassengerList()
            self:updateTank()
        else
            qy.hint:show("没有更多乘员")
        end
    end,{["isScale"] = false})
    self:OnClick("Button_upGrade", function()
        if self.upPassengerId then
            local data = PassengerModel.list[self.upPassengerId..""]
            if data.passengerType == 7 then
                qy.hint:show("指导员不能升级哦！")
                return
            end
            if data.passengerType == 6 then
                qy.hint:show("战地护士不能升级哦！")
                return
            end
            if data.iscomplete == 200 then
                qy.hint:show("乘员碎片不可升级！")
                return
            end
            if data.level == 20 then
                qy.hint:show("乘员已满级！")
                return
            end
        end

        if self.upPassengerId then
            self:createContent(1,2)
        else
            qy.hint:show("请选择乘员！")
        end
    end,{["isScale"] = false})

    
    --乘员升级
    self:OnClick("Button_up_0", function()
        if PassengerModel.page2 > 1 then
            local page = PassengerModel.page2 - 1
            PassengerModel:setPage2(page)
            self:updatePassengerList2()
        else
            qy.hint:show("没有更多乘员")
        end
    end,{["isScale"] = false})

    self:OnClick("Button_next_0", function()
        if PassengerModel.page2 < PassengerModel:getMaxPage2() then
            local page = PassengerModel.page2 + 1
            PassengerModel:setPage2(page)
            self:updatePassengerList2()
        else
            qy.hint:show("没有更多乘员")
        end
    end,{["isScale"] = false})

    self:OnClick("autoBtn", function()
        if PassengerModel.upPassengerUse and #PassengerModel.upPassengerUse~= 0 then
            local isHasRank5 = #PassengerModel:getAutoEnablePassenger() == 0
            if isHasRank5 then
                qy.hint:show("橙色及以上乘员请手动添加！")
            else
                self:refresfPassengerCY2()
            end
        else
            qy.hint:show("没有可添加乘员！")
        end
    end,{["isScale"] = false})
    

    self:OnClick("upGreadBtn", function()
        if self.explist and #self.explist~= 0 then
            if self.isHasRank5 then
                qy.alert:show({qy.TextUtil:substitute(46004), {255,255,255}}, "添加的乘员里包含橙色及以上乘员，是否继续？", cc.size(450 , 220), {{qy.TextUtil:substitute(46006), 4}, {qy.TextUtil:substitute(46007) , 5}}, function(flag)
                    if flag == qy.TextUtil:substitute(46007) then
                        PassengerService:uplevel({
                                ["passengid"] = self.upPassengerId,
                                ["explist"] = self.explist,
                            },function(reData)
                                self:__showEffert() 
                                self:clearCY2()
                                self:refreshChengYuan2()
                        end)
                    end
                end,"")
            else
                PassengerService:uplevel({
                        ["passengid"] = self.upPassengerId,
                        ["explist"] = self.explist,
                    },function(reData)
                        self:__showEffert() 
                        self:clearCY2()
                        self:refreshChengYuan2()
                end)
            end
        else
            qy.hint:show("请添加乘员!")
        end
    end,{["isScale"] = false})
    self:OnClick("upAllBtn", function()
        PassengerService:uplevelAuto({
                ["passengid"] = self.upPassengerId,
            },function(reData)
                PassengerModel.page2 = 1
                self:__showEffert() 
                self:clearCY2()
                self:refreshChengYuan2()
        end)
    end,{["isScale"] = false})

    self:OnClick("Button_upGrade2", function()
        --取消升级
        -- if self.upPassengerId_2 then
        --     local data = PassengerModel.list[self.upPassengerId_2..""]
        --     if not data then
        --         qy.hint:show("没有可添加乘员！")
        --         return
        --     end
        --     if data.passengerType == 6 then
        --         qy.hint:show("战地护士不能升级哦！")
        --         return
        --     end
        --     if data.level == 20 then
        --         qy.hint:show("该乘员已满级！")
        --         return
        --     end
        -- end

        PassengerModel:resetAllList()
        -- self.upPassengerId = self.upPassengerId_2 or self.upPassengerId
        PassengerModel:refreshUpPassengerUse(self.upPassengerId)
        self:clearCY2()
        self:createPassengerView2()
        self.tempExp = 0
        
        self:refreshChengYuan2()
    end,{["isScale"] = false})

    --招  募
    self:InjectView("free1")
    self:InjectView("free2")
    self:InjectView("zhaomu1")
    self:InjectView("zhaomu2")
    self.flg = 0
    self:OnClick("zhaooneBt1", function()
        if self.status1 == 100 then
            PassengerService:extract({
                    ["num"] = 1,
                    ["type"] = 100,
                },function(reData)
                    self:refreshZhaoMu()
                    local dialog = require("passenger.src.showDialog").new(100, reData.award)
                    dialog:show()
            end)
        else
            if StorageModel:getPropNumByID(51) > 0 then
                PassengerService:extract({
                        ["num"] = 1,
                        ["type"] = 100,
                    },function(reData)
                        StorageModel:remove(51, 1)
                        self:refreshZhaoMu()
                        local dialog = require("passenger.src.showDialog").new(100, reData.award)
                        dialog:show()
                end)
            else
                qy.hint:show(qy.TextUtil:substitute(12001))
                qy.tank.model.PropShopModel:init()
                local entity = qy.tank.model.PropShopModel:getShopPropsEntityById(24)
                local buyDialog = qy.tank.view.shop.PurchaseDialog.new(entity,function(num)
                    local service = qy.tank.service.ShopService
                    service:buyProp(entity.id,num,function(data)
                        if data and data.consume then
                            qy.hint:show(qy.TextUtil:substitute(8029)..data.consume.num)
                        end
                        self:refreshZhaoMu()
                    end)
                end)
                buyDialog:show(true)
            end
        end
    end,{["isScale"] = false})
    self:OnClick("zhaooneBt3", function()
        if StorageModel:getPropNumByID(51) > 9 then
            PassengerService:extract({
                    ["num"] = 10,
                    ["type"] = 100,
                },function(reData)
                    StorageModel:remove(51, 10)
                    local dialog = require("passenger.src.TenView").new({
                        ["type"] = 100,
                        ["data"] = reData.award,
                        ["callback"] = function (  )
                            self:refreshZhaoMu()
                        end
                        })
                    dialog:show()
            end)
        else
            qy.hint:show(qy.TextUtil:substitute(12001))
            qy.tank.model.PropShopModel:init()
            local entity = qy.tank.model.PropShopModel:getShopPropsEntityById(24)
            local buyDialog = qy.tank.view.shop.PurchaseDialog.new(entity,function(num)
                local service = qy.tank.service.ShopService
                service:buyProp(entity.id,num,function(data)
                    if data and data.consume then
                        qy.hint:show(qy.TextUtil:substitute(8029)..data.consume.num)
                    end
                    self:refreshZhaoMu()
                end)
            end)
            buyDialog:show(true)
        end
    end,{["isScale"] = false})
    self:OnClick("zhaooneBt2", function()
        PassengerService:extract({
                ["num"] = 1,
                ["type"] = 200,
            },function(reData)
                self:refreshZhaoMu()
                local dialog = require("passenger.src.showDialog").new(200, reData.award)
                dialog:show()
        end)
    end,{["isScale"] = false})
    self:OnClick("zhaooneBt4", function()
        PassengerService:extract({
                ["num"] = 10,
                ["type"] = 200,
            },function(reData)
                 local dialog = require("passenger.src.TenView").new({
                        ["type"] = 200,
                        ["data"] = reData.award,
                        ["callback"] = function (  )
                            self:refreshZhaoMu()
                        end
                        })
                dialog:show()
        end)
    end,{["isScale"] = false})

    
    --进修
    self:OnClick("Button_up_jinxiu", function()
        if PassengerModel.page3 > 1 then
            local page = PassengerModel.page3 - 1
            PassengerModel:setPage3(page)
            local datas  = self.selectItem3.data
            print()
            if self.flg == 1  then
                self:updatePassengerList3()
                self.selectItem3.data = datas
                self:updateStudyinfo()
            else
                self:updatePassengerList3()
            end
        else
            qy.hint:show("没有更多乘员")
        end
    end,{["isScale"] = false})

    self:OnClick("Button_next_jinxiu", function()
        if PassengerModel.page3 < PassengerModel:getMaxPage3() then
            local page = PassengerModel.page3 + 1
            PassengerModel:setPage3(page)
            local datas  = self.selectItem3.data
            self:updatePassengerList3()
            if self.flg == 1  then
                self:updatePassengerList3()
                self.selectItem3.data = datas
                self:updateStudyinfo()
            else
                self:updatePassengerList3()
            end
        else
            qy.hint:show("没有更多乘员")
        end
    end,{["isScale"] = false})
    self:OnClick("jinxiuBt", function()
        if self.jinxiubtflag == 0 then
            PassengerService:study(self.chooseBtflag,self.selectItem3.data.unique_id,function ( data )
                if data.add_exp == 0 then
                    qy.hint:show("进修失败")
                    return
                end
                local num  = data.add_exp/10
                local x = self.jinxiujindu:getScaleX()
                self.piaozi:setPosition(cc.p(430 * x + 30,16))
                self.piaozi:setString("+"..num.."%")
                self.piaozi:setVisible(true)
                local moveUp = cc.MoveBy:create(1.0, cc.p(0,100))
                local actionback = function (  )
                    self.piaozi:setVisible(false)
                end
                self.piaozi:runAction(cc.Sequence:create(moveUp,cc.CallFunc:create(actionback)))
                local datas = PassengerModel:getnewlist(self.selectItem3.data.unique_id)
                self:createPassengerView3()
                self:updateStudyinfo(datas)
                self:refreshZhaoMu()
            end)
        elseif self.jinxiubtflag == 2 then
            qy.hint:show("乘员已晋升到最高级")
            return
        else
            if PassengerModel.uptempdate.passenger_id then
                PassengerService:promote(self.selectItem3.data.unique_id,PassengerModel.uptempdate.unique_id,function ( data )
                    local datas = PassengerModel:getnewlist(self.selectItem3.data.unique_id)
                    self:createPassengerView3()
                    self:updateStudyinfo(datas)
                    qy.hint:show("晋升成功")
                end)
            else
                qy.hint:show("请添加消耗")
                return
            end
        end
       
    end,{["isScale"] = false})
    self:OnClick("addpassBt", function()
        local list = PassengerModel:getuppassenger(self.tempdata.unique_id,self.tempdata.passenger_id)
        -- if #list == 0 then
        --     qy.hint:show("没有相同或晋升指导员")
        -- else
            require("passenger.src.ChooseTip").new({
                ["data"] = list,
                ["callback"] = function ( datas )
                    print("选择完了")
                    print("--",datas.passenger_id)
                    PassengerModel.uptempdate = {}
                    PassengerModel.uptempdate = datas
                    self.addpassBt:loadTexture("res/passenger/" .. datas.passenger_id  .. "_1.png")
                    self.addpassBt:setScale(0.83)
                    self.addpassBtbg:setVisible(true)
                    self.addpassBtbg:loadTexture("Resources/common/item/item_bg_".. datas.quality ..".png",1)
                end
                }):show()
        -- end
       
    end,{["isScale"] = false})
    self:OnClick("chooseBt1", function()
       self:updatechoose(1)
    end,{["isScale"] = false})
      self:OnClick("chooseBt2", function()
       self:updatechoose(2)
    end,{["isScale"] = false})
    --图  鉴
    self:InjectView("Bg_3")
    self.chooseBtflag = 1 --进修默认初级
    -- self:createPassengerView()
    self:setPassengerPotions()
   	self.TankList:addChild(self:createView())
end
function MainView:updatechoose( idx )
    self.chooseBtflag = idx
    self.choosejinxiu1:setVisible(self.chooseBtflag == 1)
    self.choosejinxiu2:setVisible(self.chooseBtflag == 2)
end

function MainView:createContent(idx,idx2,bool)

    cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/common/item/common_item.plist")
    for i=1,4 do
        self["Button_"..i]:setEnabled(i ~= idx)
        self["Button_"..i]:setBright(i ~= idx)
    end
    self.chengyuan:setVisible(idx == 1)
    self.chengyuan1:setVisible(idx2 == 1)
    self.chengyuan2:setVisible(idx2 ~= 1)
    self.zhaomu:setVisible(idx == 2)
    self.tujian:setVisible(idx == 3)
    self.jinxiu:setVisible(idx == 4)
    
    self:InjectView("free1")
    self:InjectView("free2")

    self.diamonds:setString(UserInfoModel.userInfoEntity.diamond)
    local itemNums = StorageModel:getPropNumByID(51)
    self.zmCards:setString(itemNums)
    self.zmBooks:setString(UserInfoModel.userInfoEntity.study_handbook)
    
    self:clearCY2()
    if idx == 1 then
        PassengerModel:resetAllList()
        if idx2 == 1 then
            if bool then
                self:refreshCY2()
            else
                self:refreshChengYuan1()
            end
        else
            self:refreshChengYuan2()
        end
    elseif idx == 2 then
        self:refreshZhaoMu()
    elseif idx == 3 then
        self:refreshTuJian()
    elseif idx == 4 then
        self:clearCY3()
        self.flg = 0
        self:refreshJinXiu()
    end
end

-- 乘员
function MainView:refreshChengYuan1()
    -- 刷新右边乘员列表
    self:createPassengerView()
end

-- 从升级页面回到乘员
function MainView:refreshCY2()
    self.TankList:removeAllChildren()
    self.TankList:addChild(self:createView())

    -- 刷新右边乘员列表
    self:createPassengerView()
end

--乘员  坦克列表
function MainView:createView()
    local tableView = cc.TableView:create(cc.size(211, 558))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(3, 5)
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

        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.garage.GarageTankCell.new(garageModel.formation[idx+1], idx + 1,true)
            cell:addChild(item)
            cell.item = item
            if idx == 0 then
                cell.item.light:setVisible(true)
                self.selectTank = cell
                self:updateTank()
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
            self.selectTank = cell
            self:updateTank()
        elseif cell.item.entity == 0 then
            qy.tank.command.GarageCommand:showUnselectedTankListDialog(false,function(uid)
                local service = qy.tank.service.GarageService
                service:lineup(1,1,"p_"..cell.idx,uid,function()
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

function MainView:updateTank()
    self.selectTank.item.light:setVisible(true)
    cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/common/item/common_item.plist")
    for i = 1, 4 do
        self["M" .. i]:setSpriteFrame("Resources/common/item/item_bg_1.png")
        self["pass" .. i]:setVisible(false)
        self["M" .. i .."_Name"]:setColor(qy.tank.utils.ColorMapUtil.qualityMapColor(1))
        self["M_select" .. i]:setVisible(false)
    end
    self.upPlayer:setVisible(false)
    self.up_select:setVisible(false)
    self.upPlayer_1:setVisible(false)
    self.upPlayerBg:setSpriteFrame("Resources/common/item/k1.png")
    self.upPlayerinfo:setString("")
    self.upPlayerName:setString("将领(车长)")
    self.upPlayerName:setColor(qy.tank.utils.ColorMapUtil.qualityMapColor(1))
    self.upPlayerinfo:setColor(qy.tank.utils.ColorMapUtil.qualityMapColor(1))

    local entity = self.selectTank.item.entity
    local list = PassengerModel:atTank(entity)

    if type(entity) == "table" then
        -- 刷新下面选中将领
        self.upTitle:setVisible(true)
        self.upTitle:setString("【"..self.selectTank.item.entity.name.."】" .. "乘员总加成")
        if list and #list > 0 then
            -- 显示上阵的乘员信息
            self:refreshPassengerBottomInfo(list, 1)
        else
            -- 显示列表中的乘员信息
            if PassengerModel:getEnableUse() and PassengerModel:getEnableUse()[PassengerModel.page] and #PassengerModel:getEnableUse()[PassengerModel.page] and #PassengerModel:getEnableUse()>0 and #PassengerModel:getEnableUse()[PassengerModel.page] > 0 then
                self:updatePassengerInfo(1) 
                self.Text_des6:setVisible(false)
            else
                self.equip_rank:setSpriteFrame("Resources/common/item/item_bg_".. 1 ..".png")
                for i=1,4 do
                    self["updes" .. i]:setVisible(false)
                    self["updesjinxiu"..i]:setVisible(false)
                end
                self.updesName:setString("")
                self.equip_show:setVisible(false)
                self.yizhuangbei:setVisible(false)
                -- 要升级乘员的kid 和坦克kid
                self.upPassengerId = nil
                self.tank_unique_id = ""
                for i=1,5 do
                    self["Text_des" .. i]:setVisible(false)
                end
                self.Text_des6:setVisible(true)
            end
        end
    end
    -- 刷新中间乘员信息
    if list then
        local atk = 0
        local def = 0
        local hp = 0
        for i, v in pairs(list) do
            if v.isjoin == 100 then
                local key = v.passengerType
                if key == 1 then
                    self.upPlayer_1:setVisible(true)
                    self.upPlayer_1:loadTexture("res/passenger/" .. v.passenger_id .. "_1" .. ".png")
                    self.upPlayer:setVisible(true)
                    self.upPlayer:loadTexture("res/passenger/" .. v.passenger_id .. ".jpg")
                    self.upPlayerBg:setSpriteFrame("Resources/common/item/k".. v.quality ..".png")
                    self.upPlayerinfo:setString((v.passengerType == 1 and  "将领("..PassengerModel.typeNameList[v.passengerType..""]..")" or PassengerModel.typeNameList[v.passengerType..""]) .. " Lv."..v.level)
                    self.upPlayerinfo:setColor(qy.tank.utils.ColorMapUtil.qualityMapColor(v.quality))
                    self.upPlayerName:setString(v.name)
                    self.upPlayerName:setColor(qy.tank.utils.ColorMapUtil.qualityMapColor(v.quality))
                else
                    local pass = self["pass" .. (key - 1)]
                    pass:setVisible(true)
                    self["M" .. (key - 1)]:setSpriteFrame("Resources/common/item/item_bg_".. v.quality ..".png")
                    local data = qy.tank.view.common.AwardItem.getItemData(v)
                    self["M" .. (key - 1) .."_Name"]:setColor(qy.tank.utils.ColorMapUtil.qualityMapColor(data.quality))
                    self["M" .. (key - 1) .."_Name"]:setString(PassengerModel.typeNameList[v.passengerType..""])
                    pass:loadTexture(data.icon)
                end
            end
            local passData = staicData[tostring(v.passenger_id)]
            local nums = (v.study_exp/1000) + 1
            atk = atk + math.floor(passData.attack * (v.level + 1)^1.5 * nums)
            def = def + math.floor(passData.defense * (v.level + 1)^1.5 * nums)
            hp = hp + math.floor(passData.blood * (v.level + 1)^1.5 * nums)
        end

        self.upAttr1:setString((atk > 0 and "攻击：+" .. atk or "攻击：+0"))
        self.upAttr2:setString((def > 0 and "防御：+" .. def or "防御：+0"))
        self.upAttr3:setString((hp > 0 and "生命：+" .. hp or "生命：+0"))
    else
        self.upAttr1:setString(("攻击：+0"))
        self.upAttr2:setString(("防御：+0"))
        self.upAttr3:setString(("生命：+0"))
    end
end

--乘员 坦克上的乘员
function MainView:setPassengerPotions()
    for i = 1, 4 do
        self:OnClick("pass" .. i, function()
            for i=1,4 do
                self["M_select"..i]:setVisible(false)
            end
            self.up_select:setVisible(false)
            self["M_select"..i]:setVisible(true)
            local entity = self.selectTank.item.entity
            local list = PassengerModel:atTank(entity)
            for j=1,5 do
                if list[j] and list[j].passengerType == (i+1) then
                    local showList = {}
                    table.insert(showList, list[j])
                    self:refreshPassengerBottomInfo(showList, 1)
                end
            end
        end,{["isScale"] = false, beganFunc = function(sender)
            local entity = self.selectTank.item.entity
            local list = PassengerModel:atTank(entity)
            self.selectItem = self["pass" .. i]
            self.selectType = 2
            self.selectItem.oldorder = self.selectItem:getParent():getLocalZOrder()
            self.selectItem:getParent():getParent():setLocalZOrder(10)
            self.selectItem:getParent():setLocalZOrder(10)
            self.initPositionX = self["pass" .. i]:getPositionX()
            self.initPositionY = self["pass" .. i]:getPositionY()
            
            for j=1,5 do
                if list[j] and list[j].passengerType == (i+1) then
                    self.childSprite_uid = list[j].unique_id
                end
            end
        end})
    end
    self:OnClick("upPlayer", function()
        for i=1,4 do
            self["M_select"..i]:setVisible(false)
        end
        self["up_select"]:setVisible(true)

        local entity = self.selectTank.item.entity
        local list = PassengerModel:atTank(entity)
            
        if list[1] and list[1].passengerType == 1 then
            self:refreshPassengerBottomInfo(list[1], 1)
            self.selectItem = self.upPlayer_1
        end
            
    end,{["isScale"] = false, beganFunc = function(sender)
        self.selectItem = self.upPlayer_1
        self.selectType = 2
        self.selectItem.oldorder = self.selectItem:getParent():getLocalZOrder()
        self.selectItem:getParent():getParent():setLocalZOrder(10)
        self.selectItem:getParent():setLocalZOrder(10)
        self.selectItem:setLocalZOrder(10)
        self.initPositionX = self.upPlayer_1:getPositionX()
        self.initPositionY = self.upPlayer_1:getPositionY()

        local entity = self.selectTank.item.entity
        local list = PassengerModel:atTank(entity)
        if list then
            for k,v in pairs(list) do
                if v and v.passengerType == 1 then
                    self:refreshPassengerBottomInfo(v, 1)
                    self.childSprite_uid = v.unique_id
                end
            end
        end
    end})
    self.upPlayer_1:setLocalZOrder(-10)
end

--乘员 列表中的乘员
function MainView:createPassengerView()
    self.Panel_1:removeAllChildren()
    for i = 1, 12 do
        self["item" .. i] = qy.tank.view.common.ItemIcon.new()
        self["item" .. i]:setPosition(112 * math.ceil((i - 1) % 3) + 50, 380 - 112 * math.floor((i - 1) / 3))
        self["item" .. i]:setVisible(false)
        self.Panel_1:addChild(self["item" .. i])
    end

    self:updatePassengerList()
end
--进修刷新列表逻辑
function MainView:createPassengerView3()
    self.jinxiulist:removeAllChildren()
    for i = 1, 12 do
        self["item3" .. i] = qy.tank.view.common.ItemIcon.new()
        self["item3" .. i]:setPosition(112 * math.ceil((i - 1) % 3) + 50, 380 - 112 * math.floor((i - 1) / 3))
        self["item3" .. i]:setVisible(false)
        self.jinxiulist:addChild(self["item3" .. i])
    end

    self:updatePassengerList3()
end
function MainView:updatePassengerList()

    self.hasno:setVisible(PassengerModel:getMaxPage() == 0)
    
    for i = 1, 12 do
        self["item" .. i]:setVisible(false)
    end
    self.selectItem = nil
    PassengerModel:resetAllList()
    local datas = PassengerModel:getEnableUse()[PassengerModel.page] or {}

    for i, v in pairs(datas) do
        local data = qy.tank.view.common.AwardItem.getItemData(v)
        data.beganFunc = function(sender)
            for i=1,4 do
                self["M_select"..i]:setVisible(false)
            end
            self.up_select:setVisible(false)
            self.selectItem = self["item" .. i].childSprite
            self.selectItem.oldorder = self.Panel_1:getLocalZOrder()
            self.selectItem.oldorder2 = self.selectItem:getParent():getParent():getLocalZOrder()
            self.Panel_1:setLocalZOrder(10)
            self.selectItem:getParent():getParent():setLocalZOrder(10)
            self.selectType = 1
            self.initPositionX = self.selectItem:getPositionX()
            self.initPositionY = self.selectItem:getPositionY()
            self.initPositionX2 = self["item" .. i].name:getPositionX()
            self.initPositionY2 = self["item" .. i].name:getPositionY()
            self.childSprite_uid = v.unique_id
        end
        data.callback = function()
            self.childSprite_uid = v.unique_id
            self:updatePassengerInfo(i)
        end
        self["item" .. i]:setData(data)
        self["item" .. i]:getParent():setLocalZOrder(0)
        self["item" .. i].name:setString(PassengerModel.typeNameList[v.passengerType ..""])
        self["item" .. i]:setNameAnchorPoint(0,1)
        self["item" .. i]:setHorizontalAlignment()
        self["item" .. i].childSprite:setScale(0.9)
        self["item" .. i]:setVisible(true)
        self["item" .. i]:setTitlePosition(5)
        if self["item" .. i].num then
            self["item" .. i].num:setString(v.iscomplete == 200 and (v.num.."/"..typeNumList[v.quality .. ""]) or ("Lv."..v.level))
        end
        if v.passengerType == 6 and v.iscomplete == 100 then
            self["item" .. i].num:setVisible(false)
        else
            self["item" .. i].num:setVisible(true)
        end
        if v.passengerType == 7 and v.iscomplete == 100 then
            self["item" .. i].num:setVisible(false)
        else
            self["item" .. i].num:setVisible(true)
        end
    end
    for i=1,12 do
        if i > #datas then
            self["item" .. i]:setVisible(false)
        end
    end
end
--进修刷新乘员逻辑
function MainView:updatePassengerList3()

    self.hasno_jinxiu:setVisible(PassengerModel:getMaxPage3() == 0)
    
    for i = 1, 12 do
        self["item3" .. i]:setVisible(false)
    end
    self.selectItem3 = {}
    self.selectItem3.data = {}
    PassengerModel:resetAllList()
    local datas = PassengerModel:getEnableUse3()[PassengerModel.page3] or {}

    for i, v in pairs(datas) do
        local data = qy.tank.view.common.AwardItem.getItemData(v)
        data.beganFunc = function(sender)
            -- for i=1,4 do
            --     self["M_select"..i]:setVisible(false)
            -- end
            self.selectItem3 = self["item3" .. i].childSprite
            self.selectItem3.oldorder = self.jinxiulist:getLocalZOrder()
            self.selectItem3.oldorder2 = self.selectItem3:getParent():getParent():getLocalZOrder()
            self.jinxiulist:setLocalZOrder(10)
            self.selectItem3:getParent():getParent():setLocalZOrder(10)
            self.selectItem3.unique_id = v.unique_id
            self.selectItem3.data = v
            self.selectType3 = 1
            self.initPositionX3 = self.selectItem3:getPositionX()
            self.initPositionY3 = self.selectItem3:getPositionY()
            self.initPositionX23 = self["item3" .. i].name:getPositionX()
            self.initPositionY23= self["item3" .. i].name:getPositionY()
            self.childSprite_uid3 = v.unique_id
        end
        data.callback = function()
            self.childSprite_uid3 = v.unique_id
            self.lightflag = i
            self:updatePassengerInfo3(i)
        end
        self["item3" .. i]:setData(data)
        self["item3" .. i]:getParent():setLocalZOrder(0)
        self["item3" .. i].name:setString(PassengerModel.typeNameList[v.passengerType ..""])
        self["item3" .. i]:setNameAnchorPoint(0,1)
        self["item3" .. i]:setHorizontalAlignment()
        self["item3" .. i].childSprite:setScale(0.9)
        self["item3" .. i]:setVisible(true)
        self["item3" .. i]:setTitlePosition(5)
        if self["item3" .. i].num then
            self["item3" .. i].num:setString(v.iscomplete == 200 and (v.num.."/"..typeNumList[v.quality .. ""]) or ("Lv."..v.level))
        end
        if v.passengerType == 6 and v.iscomplete == 100 then
            self["item3" .. i].num:setVisible(false)
        else
            self["item3" .. i].num:setVisible(true)
        end
        if v.passengerType == 7 then
            self["item3" .. i].num:setVisible(false)
        end
    end
    for i=1,12 do
        if i > #datas then
            self["item3" .. i]:setVisible(false)
        end
    end
end

function MainView:refreshPassengerBottomInfo(list, type)
    -- type 1 坦克上的乘员  2 列表中的乘员
    if type == 1 then
        for i, v in pairs(list) do
            if v.isjoin == 100 then
                self.equip_rank:setSpriteFrame("Resources/common/item/item_bg_".. v.quality ..".png")
                local data = qy.tank.view.common.AwardItem.getItemData(v)
                self.equip_show:setVisible(true)
                self.equip_show:loadTexture(data.icon)
                if v.passengerType == 1 then
                    self.up_select:setVisible(true)
                else
                    self["M_select" .. (tonumber(v.passengerType)-1)]:setVisible(true)
                end
                for j=1,5 do
                    self["Text_des" .. j]:setVisible(true)
                end
                for j=1,4 do
                    self["updes" .. j]:setVisible(true)
                    self["updesjinxiu"..j]:setVisible(true)
                end
                self.updesName:setString(v.name)
                self.updes1:setString((v.passengerType == 6 or v.passengerType == 7) and "无" or v.level)                   
                local passData = staicData[tostring(v.passenger_id)]
                self.updes2:setString(v.atk > 0 and (math.floor(passData.attack * (v.level + 1)^1.5)) or "无")
                self.updes3:setString(v.def > 0 and (math.floor(passData.defense * (v.level + 1)^1.5)) or "无")
                self.updes4:setString(v.hp > 0 and (math.floor(passData.blood * (v.level + 1)^1.5)) or "无")

                self.updesjinxiu1:setString(v.study_exp > 0 and ("(+"..v.study_level..")") or "")--进修等级
                local num = v.study_exp/10
                local xx = "(+"..num.."%)"
                if v.atk > 0 and v.study_exp > 0 then
                    self.updesjinxiu2:setString(xx)
                else
                    self.updesjinxiu2:setString("")
                end
                 if v.def > 0 and v.study_exp > 0 then
                    self.updesjinxiu3:setString(xx)
                else
                    self.updesjinxiu3:setString("")
                end
                 if v.hp > 0 and v.study_exp > 0 then
                    self.updesjinxiu4:setString(xx)
                else
                    self.updesjinxiu4:setString("")
                end
                
                self.yizhuangbei:setVisible(true)

                -- 要升级乘员的kid 和坦克kid
                self.upPassengerId = v.unique_id
                self.tank_unique_id = v.tank_unique_id
                self.Text_des1:setString(PassengerModel.typeNameList[v.passengerType .. ""]..":")
                self.Text_des1:setColor(qy.tank.utils.ColorMapUtil.qualityMapColor(v.quality or 1))
                self.updesName:setColor(qy.tank.utils.ColorMapUtil.qualityMapColor(v.quality or 1))
                self.Text_des6:setVisible(false)
                return
            else
                self.equip_rank:setSpriteFrame("Resources/common/item/item_bg_".. 1 ..".png")
                for j=1,4 do
                    self["updes" .. j]:setString("")
                    self["updesjinxiu" .. j]:setString("")
                end
                for j=1,5 do
                    self["Text_des" .. j]:setString("")
                end
                self.updesName:setString("")
                self.Text_des1:setColor(qy.tank.utils.ColorMapUtil.qualityMapColor(1))
                self.updesName:setColor(qy.tank.utils.ColorMapUtil.qualityMapColor(1))
                self.equip_show:setVisible(false)
                self.yizhuangbei:setVisible(false)
            end
        end
    else
        for i, v in pairs(list) do
            local passData = staicData[tostring(v.passenger_id)]
            -- self.upTitle:setString("")
            -- self.upAttr1:setString((v.atk > 0 and "攻击：+" .. (math.floor(passData.attack * (v.level + 1)^1.5)) or "攻击： 无"))
            -- self.upAttr2:setString((v.def > 0 and "防御：+" .. (math.floor(passData.defense * (v.level + 1)^1.5)) or "防御： 无"))
            -- self.upAttr3:setString((v.hp > 0 and "生命：+" .. (math.floor(passData.blood * (v.level + 1)^1.5)) or "生命： 无"))
            
            self.equip_rank:setSpriteFrame("Resources/common/item/item_bg_".. v.quality ..".png")
            local data = qy.tank.view.common.AwardItem.getItemData(v)
            self.equip_show:setVisible(true)
            self.equip_show:loadTexture(data.icon)
            for j=1,5 do
                self["Text_des" .. j]:setVisible(true)
            end
            for j=1,4 do
                self["updes" .. j]:setVisible(true)
                self["updesjinxiu"..j]:setVisible(true)
            end
            self.updesName:setString(v.name)
            self.updes1:setString((v.passengerType == 6 or v.passengerType == 7) and "无" or v.level)
            self.updes2:setString(v.atk > 0 and (math.floor(passData.attack * (v.level + 1)^1.5)) or "无")
            self.updes3:setString(v.def > 0 and (math.floor(passData.defense * (v.level + 1)^1.5)) or "无")
            self.updes4:setString(v.hp > 0 and (math.floor(passData.blood * (v.level + 1)^1.5)) or "无")
            self.updesjinxiu1:setString(v.study_exp > 0 and ("(+"..v.study_level..")") or "")--进修等级
            local num = v.study_exp/10
            local xx = "(+"..num.."%)"
            if v.atk > 0 and v.study_exp > 0 then
                self.updesjinxiu2:setString(xx)
            else
                self.updesjinxiu2:setString("")
            end
             if v.def > 0 and v.study_exp > 0 then
                self.updesjinxiu3:setString(xx)
            else
                self.updesjinxiu3:setString("")
            end
             if v.hp > 0 and v.study_exp > 0 then
                self.updesjinxiu4:setString(xx)
            else
                self.updesjinxiu4:setString("")
            end
            self.yizhuangbei:setVisible(false)
            self.upPassengerId = v.unique_id
            self.Text_des1:setString(PassengerModel.typeNameList[v.passengerType .. ""]..":")
            self.Text_des1:setColor(qy.tank.utils.ColorMapUtil.qualityMapColor(v.quality or 1))
            self.updesName:setColor(qy.tank.utils.ColorMapUtil.qualityMapColor(v.quality or 1))
            self.Text_des6:setVisible(false)
            return
        end
    end
end

--乘员 刷新右边的list
function MainView:updatePassengerInfo(idx)
    if idx and self["item" .. idx] then
        for i = 1, 12 do
            if self["item" .. i].light then
                self["item" .. i].light:setVisible(false)
            end
        end

        if idx then
            if self["item" .. idx].light then
                self["item" .. idx].light:setVisible(true)
            end
        end
        local showList = {}
        table.insert(showList,PassengerModel:getEnableUse()[PassengerModel.page][idx])
        self:refreshPassengerBottomInfo(showList,2)
    end
end
--乘员进修 刷新右边的list
function MainView:updatePassengerInfo3(idx)
    if idx and self["item3" .. idx] then
        for i = 1, 12 do
            if self["item3" .. i].light then
                self["item3" .. i].light:setVisible(false)
            end
        end

        if idx then
            if self["item3" .. idx].light then
                self["item3" .. idx].light:setVisible(true)
            end
        end
        local showList = {}
        table.insert(showList,PassengerModel:getEnableUse3()[PassengerModel.page3][idx])
        self:updateStudyinfo()
    end
end
function MainView:updatePassengerInfo3light( idx )
    if idx and self["item3" .. idx] then
        for i = 1, 12 do
            if self["item3" .. i].light then
                self["item3" .. i].light:setVisible(false)
            end
        end

        if idx then
            if self["item3" .. idx].light then
                self["item3" .. idx].light:setVisible(true)
            end
        end
    end
end

-- 乘员升级
function MainView:clearCY2()
    self.explist = {}
    self.tempExp = 0
    self.isHasRank5 = false
    for j=1,4 do
        self["M1"..j]:setSpriteFrame("Resources/common/item/item_bg_1.png")
        self["MM_"..j]:setVisible(false)
    end
    for i = 1, 12 do
        if self["item2" .. i] and self["item2" .. i].light then
            self["item2" .. i].light:setVisible(false)
        end
    end
end
function MainView:clearCY3(  )
    self.explist3 = {}
    for i = 1, 12 do
        if self["item3" .. i] and self["item3" .. i].light then
            self["item3" .. i].light:setVisible(false)
        end
    end
end
-- 乘员升级
function MainView:refreshChengYuan2()
    if self.upPassengerId then
        cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/common/item/common_item.plist")
        local data = PassengerModel.list[tostring(self.upPassengerId)]
        local level = data.level
        self.equip_sprite:loadTexture(qy.tank.view.common.AwardItem.getItemData(data).icon)
        self.equip_rank2:setSpriteFrame("Resources/common/item/item_bg_".. (data.quality or 1) ..".png")
        self.equip_name2:setVisible(data.isjoin == 100)
        self.updesName2:setString(data.name)
        self.Text_des21:setString(PassengerModel.typeNameList[data.passengerType .. ""]..":")
        self.Text_des21:setColor(qy.tank.utils.ColorMapUtil.qualityMapColor(data.quality or 1))
        self.updesName2:setColor(qy.tank.utils.ColorMapUtil.qualityMapColor(data.quality or 1))
        self.updes11:setString((data.passengerType == 6 or data.passengerType == 7) and "无" or data.level)
        local passData = staicData[tostring(data.passenger_id)]
        
        self.updes12:setString(data.atk > 0 and (math.floor(passData.attack * (data.level + 1)^1.5)) or "无")
        self.updes13:setString(data.def > 0 and (math.floor(passData.defense * (data.level + 1)^1.5)) or "无")
        self.updes14:setString(data.hp  > 0 and (math.floor(passData.blood * (data.level + 1)^1.5))  or "无")
        self.PressageName2:setString(data.name)
        self.PressageName2:setColor(qy.tank.utils.ColorMapUtil.qualityMapColor(data.quality or 1))
        self.PressageInfo2:setString(PassengerModel.typeNameList[data.passengerType .. ""] .. " Lv." .. level)
        self.PressageInfo2:setColor(qy.tank.utils.ColorMapUtil.qualityMapColor(data.quality or 1))
        self.Sprite_player:loadTexture("res/passenger/" .. data.passenger_id .. ".jpg")
        self.Sprite_rank2:setSpriteFrame("Resources/common/item/k".. (data.quality or 1) ..".png")

        self.Text_level:setString("Lv."..level)

        
        self:refreshProgressTextCY2()
        
        self:createPassengerView2()
    end
end

-- 乘员经验值显示
function MainView:refreshProgressTextCY2()
    
    self.levelProText:removeAllChildren()
    local data = PassengerModel.list[tostring(self.upPassengerId)]
    local level = data.level
    -- 进度条 
    cc.SpriteFrameCache:getInstance():addSpriteFrames("passenger/res/passengerui.plist")

    self.leveProgress:removeAllChildren()
    self.bar1 = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("passenger/res/exp.png"))
    self.bar1:setAnchorPoint(0,0)
    self.bar1:setScaleX(1.08)
    self.bar1:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.bar1:setMidpoint(cc.p(0,0))
    self.bar1:setOpacity(180)
    self.bar1:setBarChangeRate(cc.p(1, 0))
    self.bar1:setPosition(8, 10)
    self.leveProgress:addChild(self.bar1,9)

    self.bar2 = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("passenger/res/exp.png"))
    self.bar2:setAnchorPoint(0,0)
    self.bar2:setScaleX(1.08)
    self.bar2:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.bar2:setMidpoint(cc.p(0,0))
    self.bar2:setBarChangeRate(cc.p(1, 0))
    self.bar2:setPosition(8, 10)
    self.leveProgress:addChild(self.bar2,10)
    self.bar2:setPercentage(((data.exp - qy.Config.passenger_level[level..""][tonumber(data.passengerType) == 1 and "jiang_exp_sum_"..data.quality or "za_exp_sum_"..data.quality]) / qy.Config.passenger_level[level..""][tonumber(data.passengerType) == 1 and "jiang_exp_"..data.quality or "za_exp_"..data.quality]) * 100)

    self.richText = ccui.RichText:create()
    self.richText:setPosition(self.levelProText:getContentSize().width/2 + 0, 12)
    self.richText:setAnchorPoint(0.5, 0.5)
    -- self.richText:ignoreContentAdaptWithSize(false)
    self.richText:setContentSize(cc.size(275, 22))
    
    local num = data.num

    local info1 = self:makeText(level == 20 and "满级" or (data.exp - qy.Config.passenger_level[level..""][tonumber(data.passengerType) == 1 and "jiang_exp_sum_"..data.quality or "za_exp_sum_"..data.quality]), cc.c3b(255, 255, 255))
    local info2 = self:makeText(level == 20 and "" or (self.tempExp ~= 0 and "(+" .. self.tempExp .. ")" or ""), cc.c3b(64, 205, 64))
    local info3 = self:makeText(level == 20 and "" or ("/".. qy.Config.passenger_level[level..""][tonumber(data.passengerType) == 1 and "jiang_exp_"..data.quality or "za_exp_"..data.quality]), cc.c3b(255, 255, 255))
    
    self.richText:pushBackElement(info1)
    self.richText:pushBackElement(info2)
    self.richText:pushBackElement(info3)
    self.levelProText:addChild(self.richText)

    self.bar1:setPercentage(((data.exp + self.tempExp - qy.Config.passenger_level[level..""][tonumber(data.passengerType) == 1 and "jiang_exp_sum_"..data.quality or "za_exp_sum_"..data.quality]) / qy.Config.passenger_level[level..""][tonumber(data.passengerType) == 1 and "jiang_exp_"..data.quality or "za_exp_"..data.quality]) * 100)
    self.bar1:setVisible(self.tempExp ~= 0)
end
function MainView:makeText(text, color)
    return ccui.RichElementText:create(1, color or display.COLOR_WHITE, 255, text, qy.res.FONT_NAME, 18)
end
-- 乘员升级 (点击自动加载乘员)
function MainView:refresfPassengerCY2()
    PassengerModel:refreshUpPassengerUse(self.upPassengerId)
    local data = PassengerModel:getAutoEnablePassenger()
    local index = #self.explist
    for i=1,#data do
        index = index + 1
        if index > 4 then
            return
        end
        self["M1"..index]:setSpriteFrame("Resources/common/item/item_bg_".. (data[i].quality or 1) ..".png")
        self["MM_"..index]:setVisible(true)
        self["MM_"..index]:loadTexture(qy.tank.view.common.AwardItem.getItemData(data[i]).icon)
        if data[i].iscomplete == 100  and tonumber(data[i].quality) >= 5 and data[i].passengerType ~= 6 then
            self.isHasRank5 = true
        end
        table.insert(self.explist, data[i].unique_id)

        self.tempExp = self.tempExp + data[i].exp + qy.Config.passenger[data[i].passenger_id..""].exp
        self:refreshProgressTextCY2()
        PassengerModel:refreshUpPassengerUse(data[i].unique_id)
        self:updatePassengerList2()
    end
end

-- 乘员升级
function MainView:createPassengerView2()
    self.Panel_3:removeAllChildren()
    self.selectItem2 = nil
    for i = 1, 12 do
        self["item2" .. i] = qy.tank.view.common.ItemIcon.new()
        self["item2" .. i]:setPosition(112 * math.ceil((i - 1) % 3) + 50, 380 - 112 * math.floor((i - 1) / 3))
        self["item2" .. i]:setVisible(false)
        self.Panel_3:addChild(self["item2" .. i])
    end
    self:updatePassengerList2()
end
-- 乘员升级
function MainView:updatePassengerList2()
    for i = 1, 12 do
        self["item2" .. i]:setVisible(false)
    end
    self.selectItem2 = nil
    PassengerModel:refreshUpPassengerUse(self.upPassengerId)
    self.hasno_2:setVisible(PassengerModel:getMaxPage2() == 0)
    local data = PassengerModel:getEnableUse2()[PassengerModel.page2] or {}
    for i, v in pairs(data) do
        local data = qy.tank.view.common.AwardItem.getItemData(v)
        data.beganFunc = function(sender)
            self.selectItem2 = self["item2" .. i].childSprite
            if self.selectItem2 then
                self.selectItem2.oldorder = self.Panel_list_2:getLocalZOrder()
                self.selectItem2.oldorder2 = self.selectItem2:getParent():getParent():getLocalZOrder()
                self.Panel_list_2:setLocalZOrder(10)
            end
            self.selectItem2:getParent():getParent():setLocalZOrder(10)
            self.selectItem2.unique_id = v.unique_id
            self.selectItem2.data = v
            self.selectType = 1
            self.initPositionX1 = self.selectItem2:getPositionX()
            self.initPositionY1 = self.selectItem2:getPositionY()
            self.initPositionX21 = self["item2" .. i].name:getPositionX()
            self.initPositionY21 = self["item2" .. i].name:getPositionY()
        end
        data.callback = function()
            self:updatePassengerInfo2(self["item2" .. i].idx, self["item2" .. i].unique_id)
        end
        self["item2" .. i]:setData(data)
        self["item2" .. i].name:setString(v.iscomplete == 200 and ("数量"..v.num) or PassengerModel.typeNameList[v.passengerType ..""])
        self["item2" .. i]:setNameAnchorPoint(0,1)
        self["item2" .. i]:setHorizontalAlignment()
        self["item2" .. i].childSprite:setScale(0.9)
        self["item2" .. i]:setVisible(true)
        self["item2" .. i]:setTitlePosition(5)
        self["item2" .. i].childSprite.entity = data
        self["item2" .. i].childSprite.idx = i
        self["item2" .. i].idx = i
        self["item2" .. i].unique_id = v.unique_id
        self["item2" .. i].num:setVisible(v.passengerType ~= 6)
        self["item2" .. i].num:setString("Lv.".. v.level)
        if v.passengerType == 7 then
            self["item2" .. i].num:setVisible(false)
        end
    end
end
-- 乘员升级  点击回调  刷新右边的list
function MainView:updatePassengerInfo2(idx, unique_id)
    for i = 1, 12 do
        if self["item2" .. i].light then
            self["item2" .. i].light:setVisible(false)
        end
    end

    if idx then
        if self["item2" .. idx].light then
            self["item2" .. idx].light:setVisible(true)
        end
    end
    self.upPassengerId_2 = unique_id
    if self.upPassengerId_2 then
        local data = PassengerModel.list[tostring(self.upPassengerId_2)]
        local level = data.level
        self.equip_sprite:loadTexture(qy.tank.view.common.AwardItem.getItemData(data).icon)
        self.equip_rank2:setSpriteFrame("Resources/common/item/item_bg_".. (data.quality or 1) ..".png")
        self.equip_name2:setVisible(data.isjoin == 100)
        self.updesName2:setString(data.name)
        self.Text_des21:setString(PassengerModel.typeNameList[data.passengerType .. ""]..":")
        self.Text_des21:setColor(qy.tank.utils.ColorMapUtil.qualityMapColor(data.quality or 1))
        self.updesName2:setColor(qy.tank.utils.ColorMapUtil.qualityMapColor(data.quality or 1))
        self.updes11:setString((data.passengerType == 6 or data.passengerType == 7) and "无" or data.level)
        local passData = staicData[tostring(data.passenger_id)]
        
        self.updes12:setString(data.atk > 0 and (math.floor(passData.attack * (data.level + 1)^1.5)) or "无")
        self.updes13:setString(data.def > 0 and (math.floor(passData.defense * (data.level + 1)^1.5)) or "无")
        self.updes14:setString(data.hp  > 0 and (math.floor(passData.blood * (data.level + 1)^1.5))  or "无")
    end
end

--图鉴

function MainView:refreshTuJian()
    -- 进度条 
    cc.SpriteFrameCache:getInstance():addSpriteFrames("passenger/res/passengerui.plist")

    self.tujianProgress:removeAllChildren()
    self.bar = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("passenger/res/exp.png"))
    self.bar:setAnchorPoint(0,0)
    self.bar:setScaleX(2.16)
    self.bar:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.bar:setMidpoint(cc.p(0,0))
    self.bar:setBarChangeRate(cc.p(1, 0))
    self.bar:setPosition(8, 10)
    self.tujianProgress:addChild(self.bar,9)
    local totalnum = PassengerModel:gettujiantotalnum()
    if PassengerModel.collect then
        self.tujianProText:setString(#PassengerModel.collect .. "/" .. totalnum)
        self.bar:setPercentage(#PassengerModel.collect / totalnum * 100)
    else
        self.tujianProText:setString(0 .. "/" .. totalnum)
        self.bar:setPercentage(0 * 100)
    end
    self.attribute:removeAllChildren()
    self.Bg_3:removeAllChildren()
    self.attribute:addChild(self:creteAttrList(),10)
    self.Bg_3:addChild(self:creteTujianList())
end

function MainView:creteAttrList()
    local tableView = cc.TableView:create(cc.size(290, 360))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(0, 0)

    local data = PassengerModel:getAddAttr()

    local function numberOfCellsInTableView(tableView)
        return 13
    end

    local function cellSizeForTable(tableView,idx)
        return 250, 40
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("passenger.src.attribute").new()
            cell:addChild(item)
            cell.item = item
        end

        cell.item.idx = idx
        cell.item:setData((idx+1))
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    
    tableView:reloadData()
    self.AttrtableView = tableView
    return tableView
end

function MainView:creteTujianList()
    local tableView = cc.TableView:create(cc.size(705, 460))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(0, 7)

    local data = PassengerModel:getTujianList()

    local function numberOfCellsInTableView(tableView)
        return #data
    end

    local function cellSizeForTable(tableView,idx)
        return 700, 175
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("passenger.src.ItemCell").new({
                ["callback"] = function(data)
                    if not tableView:isTouchMoved() then
                        local dialog = require("passenger.src.handBookDialog").new(data)
                        dialog:show()
                    end
                end,
            })
            cell:addChild(item)
            cell.item = item
        end

        cell.item.idx = idx
        cell.item:setData(data[idx + 1])
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    
    tableView:reloadData()
    self.TujiantableView = tableView
    return tableView
end
--招募
function MainView:refreshZhaoMu()
    self.diamonds:setString(UserInfoModel.userInfoEntity.diamond)
    local itemNums = StorageModel:getPropNumByID(51)
    self.zmBooks:setString(UserInfoModel.userInfoEntity.study_handbook)
    self.zmCards:setString(itemNums)
    if self.timer1 ~=nil then
        self.timer1:stop()
    end

    if self.timer2 ~=nil then
        self.timer2:stop()
    end
    self.timer1 = nil
    self.timer2 = nil
    self:createTimer1()
    self:createTimer2()
    self:refreshRedDot()
end

function MainView:createTimer1()
    self.status1 = PassengerModel.status1
    self.remainTime1 = PassengerModel.cdTime1 - PassengerModel.serviceTime
    if self.status1 == 100 then
        self.timer1 = nil
        self:updateCardInfo(0, 1)
        return
    end
    if self.timer1 == nil then
        self.timer1 = qy.tank.utils.Timer.new(1,self.remainTime1,function(leftTime)
            self:updateCardInfo(leftTime or 0, 1)
        end)
        self.timer1:start()
    end
    self:updateCardInfo(self.remainTime1, 1)
end
function MainView:createTimer2()
    self.status2 = PassengerModel.status2
    self.remainTime2 = PassengerModel.cdTime2 - PassengerModel.serviceTime
    if self.status2 == 100 then
        self.timer2 = nil
        self:updateCardInfo(0, 2)
        return
    end
    if self.timer2 == nil then
        self.timer2 = qy.tank.utils.Timer.new(1,self.remainTime2,function(leftTime)
            self:updateCardInfo(leftTime or 0, 2)
        end)
        self.timer2:start()
    end
    self:updateCardInfo(self.remainTime2, 2)
end

function MainView:updateCardInfo(leftTime, index)
    if leftTime > 0 then
        local timeStr = qy.TextUtil:substitute(12004, qy.tank.utils.DateFormatUtil:toDateString(leftTime))
        self["free" .. index]:setString(timeStr)
        self["Btimg"..index]:setSpriteFrame("passenger/res/zhaomuyici.png")

        self.free2_0:setVisible(PassengerModel.first == 100)
        self.free2_0_0:setVisible(PassengerModel.first == 100)

        if index == 1 then
            self.cost1:setVisible(true)
            self.cost_11:setVisible(true)
        else
            self.cost2:setVisible(true)
        end
    else
        self["free" .. index]:setString(qy.TextUtil:substitute(51031))
        self["Btimg"..index]:setSpriteFrame("passenger/res/mianfei.png")
        if index == 1 then
            self.cost1:setVisible(false)
            self.cost_11:setVisible(false)
        else
            self.cost2:setVisible(false)
        end
    end
    local itemNums = StorageModel:getPropNumByID(51)
    self.cost1:setString("        ×1")
    -- self.cost_11:setVisible(0 >= itemNums)
    self.diamonds:setString(UserInfoModel.userInfoEntity.diamond)
    self.zmCards:setString(itemNums)
    self.zmBooks:setString(UserInfoModel.userInfoEntity.study_handbook)
end

function MainView:refreshRedDot()
    self.statusRed = false
    self.status1 = PassengerModel.status1
    self.remainTime3 = PassengerModel.cdTime1 - PassengerModel.serviceTime
    if self.status1 == 100 then
        self.timer3 = nil
        self:updateCardInfo2(0, 1)
        return
    end
    if self.timer3 == nil then
        self.timer3 = qy.tank.utils.Timer.new(1,self.remainTime3,function(leftTime)
            self:updateCardInfo2(leftTime or 0, 1)
        end)
        self.timer3:start()
    end
    self:updateCardInfo2(self.remainTime3, 1)
    self.status2 = PassengerModel.status2
    self.remainTime4 = PassengerModel.cdTime2 - PassengerModel.serviceTime
    if self.status2 == 100 then
        self.timer4 = nil
        self:updateCardInfo2(0, 2)
        return
    end
    if self.timer4 == nil then
        self.timer4 = qy.tank.utils.Timer.new(1,self.remainTime4,function(leftTime)
            self:updateCardInfo2(leftTime or 0, 2)
        end)
        self.timer4:start()
    end
    self:updateCardInfo2(self.remainTime4, 2)

    self.remind1:setVisible(self.statusRed)
end

function MainView:updateCardInfo2(leftTime, index)
    if leftTime > 0 then
    else
        self.statusRed = true
    end
end

-- 检查装载
function MainView:checkUpPos()
    local isSelected = false
    self.selectItem:setPosition(self.initPositionX, self.initPositionY)

    -- self.passengerBG:setLocalZOrder(self.selectItem.oldorder)
    self.selectItem:getParent():getParent():setLocalZOrder(self.selectItem.oldorder2)
    self.selectItem:getParent():getParent().name:setPosition(self.initPositionX2, self.initPositionY2)

    

    local boxPoint = self.Panel_2:getBoundingBox()
    
    if (self.endPoint.x > boxPoint.x and self.endPoint.x < boxPoint.x + boxPoint.width) and (self.endPoint.y > boxPoint.y and self.endPoint.y < boxPoint.y + boxPoint.height) then
        isSelected = true
        self:addPos(self.selectItem)
    end
        
    if not isSelected then
        self.selectItem = nil
    end
end

-- 检查卸载
function MainView:checkUnload()
    local boxPoint = self.Panel_list:getBoundingBox()

    self.selectItem:setPosition(self.initPositionX, self.initPositionY)
    self.selectItem:getParent():setLocalZOrder(self.selectItem.oldorder)
    self.upPlayer_1:setLocalZOrder(-10)
    if (self.endPoint.x > boxPoint.x and self.endPoint.x < boxPoint.x + boxPoint.width) and (self.endPoint.y > boxPoint.y and self.endPoint.y < boxPoint.y + boxPoint.height) then
        self.selectItem:setVisible(false)
        self:unload(self.selectItem)
    else
        self.selectItem = nil
    end
end

-- 给某个位置添加乘员
function MainView:addPos(data)
    PassengerService:joinformation({
        ["tank_unique_id"] = self.selectTank.item.entity.unique_id,
        ["type"] = 100,
        ["unique_id"] =self.childSprite_uid
    }, function(data)
        PassengerModel:resetAllList()
        -- self:createContent(1,1)
        self:updateTank()
        self:updatePassengerList()

        self:showUtil()
    end)
end

-- 执行卸载
function MainView:unload(data)
    PassengerService:joinformation({
        ["tank_unique_id"] = self.selectTank.item.entity.unique_id,
        ["type"] = 200,
        ["unique_id"] = self.childSprite_uid
    }, function(data)
        PassengerModel:resetAllList()
        -- self:createContent(1,1)
        self:updateTank()
        self:updatePassengerList()
        self:showUtil()
    end)
end

-- 战斗力飘字
function MainView:showUtil()
    local _aData = {}
    local fightPower = qy.tank.model.UserInfoModel.userInfoEntity.fightPower - qy.tank.model.UserInfoModel.userInfoEntity.oldfight_power
    if fightPower then
        local numType = 0
        if fightPower > 0 then
            numType = 15
        else
            numType = 14
        end
        _data = {
            ["value"] = fightPower,
            ["url"] = qy.ResConfig.IMG_FIGHT_POWER,
            ["type"] = numType,
            ["picType"] = 2,
         }
        table.insert(_aData, _data)
        qy.tank.utils.HintUtil.showSomeImageToast(_aData,cc.p(qy.winSize.width / 3 * 2, qy.winSize.height * 0.7))
    end
end

--乘员升级  给某个乘员添加升级材料
function MainView:checkAddPassenger()
    local isSelected = false
    if self.initPositionX1 and self.initPositionY1 then
        self.selectItem2:setPosition(cc.p(self.initPositionX1, self.initPositionY1))
    end
    -- self.passengerBG:setLocalZOrder(self.selectItem2.oldorder)
    self.selectItem2:getParent():getParent():setLocalZOrder(self.selectItem2.oldorder2)
    self.selectItem2:getParent():getParent().name:setPosition(self.initPositionX21, self.initPositionY21)
    local boxPoint = self.Panel_22:getBoundingBox()
    
    if (self.endPoint.x > boxPoint.x and self.endPoint.x < boxPoint.x + boxPoint.width) and (self.endPoint.y > boxPoint.y and self.endPoint.y < boxPoint.y + boxPoint.height) then
        isSelected = true
        self:addPassenger(self.selectItem2)
    end
        
    if not isSelected then
        self.selectItem2 = nil
    end
end
function MainView:updateStudy()
    local isSelected = false
    if self.initPositionX3 and self.initPositionY3 then
        self.selectItem3:setPosition(cc.p(self.initPositionX3, self.initPositionY3))
    end
    -- self.passengerBG:setLocalZOrder(self.selectItem2.oldorder)
    self.selectItem3:getParent():getParent():setLocalZOrder(self.selectItem3.oldorder2)
    self.selectItem3:getParent():getParent().name:setPosition(self.initPositionX23, self.initPositionY23)
    -- local boxPoint = self.Panel_222:getBoundingBox()
    
    if (self.endPoint.x > boxPoint.x and self.endPoint.x < boxPoint.x + boxPoint.width) and (self.endPoint.y > boxPoint.y and self.endPoint.y < boxPoint.y + boxPoint.height) then
        isSelected = true
        self:updateStudyinfo(self.selectItem3)
    end
    if not isSelected then
        self.selectItem3 = nil
    end
end
function MainView:updateStudyinfo( items )
    local data = {}
    self.flg = 1
    if items then
        data = items[1]
        self.selectItem3.data = items[1]
    else
        data = self.selectItem3.data
        self.piaozi:setVisible(false)
        self:updatechoose(1)
    end
    self.tempdata = data
    PassengerModel.uptempdate = {}--初始化临时data
    -- print("=============",json.encode(data))
    self.shuxinglist:setVisible(true)
    self.upPlayerinfo_jinxiu:setVisible(true)
    self.upPlayerName_jinxiu:setVisible(true)
    self.jinxiuBt:setEnabled(true)
    self.jinxiuBt:setBright(true)
    self.addpassBt:loadTexture("passenger/res/11 (2).png",0)
    self.addpassBt:setScale(1)
    self.addpassBtbg:setVisible(false)
    -- self.upPlayer_1_jinxiu:loadTexture("res/passenger/" .. data.passenger_id .. "_1" .. ".png")
    self.upPlayer_jinxiu:setVisible(true)
    self.upPlayer_jinxiu:loadTexture("res/passenger/" .. data.passenger_id .. ".jpg")
    self.upPlayerBg_jinxiu:setSpriteFrame("Resources/common/item/k".. data.quality ..".png")
    self.upPlayerinfo_jinxiu:setString((data.passengerType == 1 and  "将领".."("..PassengerModel.typeNameList[data.passengerType..""]..")" or PassengerModel.typeNameList[data.passengerType..""]) .. " Lv."..data.level)
    self.upPlayerinfo_jinxiu:setColor(qy.tank.utils.ColorMapUtil.qualityMapColor(data.quality))
    self.upPlayerName_jinxiu:setString(data.name)
    self.upPlayerName_jinxiu:setColor(qy.tank.utils.ColorMapUtil.qualityMapColor(data.quality))
    -- PassengerModel:refreshenableStudy(data.unique_id)
    -- self:updatePassengerList3()
    --刷新属性值
    local passData = staicData[tostring(data.passenger_id)]
    self.jinxiu1:setString(data.atk > 0 and (math.floor(passData.attack * (data.level + 1)^1.5)) or "无")
    self.jinxiu2:setString(data.def > 0 and (math.floor(passData.defense * (data.level + 1)^1.5)) or "无")
    self.jinxiu3:setString(data.hp > 0 and (math.floor(passData.blood * (data.level + 1)^1.5)) or "无")

    local num = data.study_exp/10
    local tempnu = "(+"..num.."%)"
    self["jinxiuadd1"]:setString(data.atk > 0 and tempnu or "")
    self["jinxiuadd2"]:setString(data.def > 0 and tempnu or "")
    self["jinxiuadd3"]:setString(data.hp > 0 and tempnu or "")
    local study_shuxing = PassengerModel:getstudyshuxing(data.study_level)
    self.shuxing1:setString("属性+"..study_shuxing["1"].."%")
    self.shuxing2:setString("属性+"..study_shuxing["2"].."%")
    if data.study_level < 5 then
        self.dengji1:setString("进修lv."..data.study_level)
        self.dengji2:setString("进修lv."..(data.study_level+1))
    else
        self.dengji1:setString("进修lv.4")
        self.dengji2:setString("进修lv.5")
    end
    local consumedats = PassengerModel.passenger_study_consume
    local tt = (data.study_exp/10- study_shuxing["1"])/(study_shuxing["2"] - study_shuxing["1"])
    self.jinxiujindu:setScaleX( tt> 0 and tt or 0)
    self.chujixiaohao1:setString(consumedats[data.study_level..""].study_handbook1)
    self.chujixiaohao2:setString(consumedats[data.study_level..""].silver)
    self.gaojixiaohao1:setString(consumedats[data.study_level..""].study_handbook2)
    self.gaojixiaohao2:setString(consumedats[data.study_level..""].diamond)
   
    self.jinxiubtflag = PassengerModel:getstudystus(data.study_level,data.study_exp) --状态 0 进修  1 晋升 2 满了
    self.xiaohaopannel:setVisible(self.jinxiubtflag == 0)
    print("====================="..self.jinxiubtflag)
    self.addpannel:setVisible(self.jinxiubtflag == 1)
    self.jinxiutext:setVisible(self.jinxiubtflag == 2)
    if self.jinxiubtflag == 1 then
        self.jinxiuBt:setTitleText("晋 升")
    else
        self.jinxiuBt:setTitleText("进 修")
    end
end
--进修
function MainView:refreshJinXiu(  )
    self.shuxinglist:setVisible(false)
    self.upPlayerinfo_jinxiu:setVisible(false)
    self.upPlayerName_jinxiu:setVisible(false)
    self.upPlayer_jinxiu:setVisible(false)
    self.jinxiuBt:setEnabled(false)
    self.jinxiuBt:setBright(false)
    self.upPlayerBg_jinxiu:setSpriteFrame("Resources/common/item/k1.png")
    self:createPassengerView3()
end
function MainView:addPassenger()
    local data = self.selectItem2.data
    if self.explist and #self.explist ~= 0 then
        for i=1,#self.explist do
            if self.explist[i] == data.unique_id then
                return
            end
        end
    end
    for i=1,4 do
        if not self["MM_"..i]:isVisible() then
            self["M1"..i]:setSpriteFrame("Resources/common/item/item_bg_".. (data.quality or 1) ..".png")
            self["MM_"..i]:setVisible(true)
            self["MM_"..i]:loadTexture(qy.tank.view.common.AwardItem.getItemData(data).icon)
            if data.iscomplete == 100 and tonumber(data.quality) >= 5 and data.passengerType ~= 6 then
                self.isHasRank5 = true
            end
            table.insert(self.explist, data.unique_id)
            PassengerModel:refreshUpPassengerUse(data.unique_id)
            self.tempExp = self.tempExp + data.exp + qy.Config.passenger[data.passenger_id..""].exp
            self:updatePassengerList2()
            self:refreshProgressTextCY2()
            return
        end
    end
end

function MainView:__showEffert()
    if self.currentEffert == nil then
        self.currentEffert = ccs.Armature:create("ui_fx_chengyuanup")
        self.Sprite_rank2:addChild(self.currentEffert,999)
        self.currentEffert:setScale(1.25)
        local size = self.Sprite_rank2:getContentSize()
        self.currentEffert:setPosition(size.width/2,size.height/2)
    end

    self.currentEffert:getAnimation():setMovementEventCallFunc(function(armatureBack,movementType,movementID)
        if movementType == ccs.MovementEventType.complete then
            self.isEffertShow = false
        end
    end)
    if not self.isEffertShow then
        self.isEffertShow = true
        self.currentEffert:getAnimation():playWithIndex(0)
    end
end

function MainView:onEnter()
    self.diamonds:setString(UserInfoModel.userInfoEntity.diamond)
    self.listener_1 = qy.Event.add(qy.Event.LINEUP_SUCCESS,function(event)
        if self.tankViewList then
            self.tankViewList:reloadData()
        end
    end)
    local touchPoint = nil
    self.listener = nil
    self.onTouchBegan = function(touch, event)
        touchPoint = touch:getLocation()
        return true
    end

    self.onTouchMoved = function(touch, event)
        local point = touch:getLocation()
        local moveDistance = {}
        moveDistance.x = point.x - touchPoint.x
        moveDistance.y = point.y - touchPoint.y
        local dis = math.sqrt(moveDistance.x * moveDistance.x + moveDistance.y * moveDistance.y)
        if math.abs(convertDistanceFromPointToInch(dis)) >= MOVE_INCH then
            if self.selectItem then
                self.selectItem:setPosition(self.initPositionX + moveDistance.x, self.initPositionY + moveDistance.y)
                if self.selectType == 1 then
                    self.selectItem:getParent():getParent().name:setPosition(self.initPositionX2 + moveDistance.x, self.initPositionY2 + moveDistance.y)
                end
            end
            if self.selectItem2 then
                self.selectItem2:setPosition(self.initPositionX1 + moveDistance.x, self.initPositionY1 + moveDistance.y)
                self.selectItem2:getParent():getParent().name:setPosition(self.initPositionX21 + moveDistance.x, self.initPositionY21 + moveDistance.y)
            end
            --  if self.selectItem3 then
            --     self.selectItem3:setPosition(self.initPositionX3 + moveDistance.x, self.initPositionY3 + moveDistance.y)
            --     self.selectItem3:getParent():getParent().name:setPosition(self.initPositionX23 + moveDistance.x, self.initPositionY23 + moveDistance.y)
            -- end
        end
    end

    self.onTouchended = function(touch, event)
        local point = touch:getLocation()
        if self.passengerBG then
            self.endPoint = self.passengerBG:convertToNodeSpace(point)
            if self.selectItem then
            -- if tolua.cast(self.selectItem,"cc.Node") then
                if self.selectType == 1 then
                    self:checkUpPos(point) -- 判断是否装载
                else
                    self:checkUnload(point)
                end
            end
            if self.selectItem2 then
                self:checkAddPassenger(point)
            end
            -- if self.selectItem3 then
            --     self:updateStudyinfo()
            --     print("》》》》》》》》》》》》》》onTouchended")
            -- end
        end
    end

    self.onTouchCancelled = function(touch, event)
        if self.selectItem then
            if self.selectType == 1 then
                self.Panel_2:setLocalZOrder(self.selectItem.oldorder)
                self.selectItem:getParent():getParent():setLocalZOrder(self.selectItem.oldorder2)
            else
                self.selectItem:getParent():setLocalZOrder(self.selectItem.oldorder)
            end
            self.selectItem = nil
        end
        if self.selectItem2 then
            self.Panel_22:setLocalZOrder(self.selectItem2.oldorder)
            self.selectItem2:getParent():getParent():setLocalZOrder(self.selectItem2.oldorder2)
            self.selectItem2 = nil
        end
        -- if self.selectItem3 then
        --     self.Panel_222:setLocalZOrder(self.selectItem3.oldorder)
        --     self.selectItem3:getParent():getParent():setLocalZOrder(self.selectItem3.oldorder2)
        --     self.selectItem3 = nil
        -- end
    end

    if self.listener == nil then
        self.listener = cc.EventListenerTouchOneByOne:create()
        self.listener:setSwallowTouches(false)
        self.listener:registerScriptHandler(self.onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
        self.listener:registerScriptHandler(self.onTouchMoved, cc.Handler.EVENT_TOUCH_MOVED)
        self.listener:registerScriptHandler(self.onTouchended, cc.Handler.EVENT_TOUCH_ENDED)
        self.listener:registerScriptHandler(self.onTouchCancelled, cc.Handler.EVENT_TOUCH_CANCELLED)
        self:getEventDispatcher():addEventListenerWithFixedPriority(self.listener, -1)
    end

    qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync(qy.ResConfig.CHENGYUAN_UP)
end

function MainView:onExit()
    if self.timer1 ~=nil then
        self.timer1:stop()
    end
    if self.timer2 ~=nil then
        self.timer2:stop()
    end
    if self.timer3 ~=nil then
        self.timer3:stop()
    end
    if self.timer4 ~=nil then
        self.timer4:stop()
    end
    self.timer1 = nil
    self.timer2 = nil
    self.listener = nil
    qy.tank.utils.cache.CachePoolUtil.removeArmatureFile(qy.ResConfig.CHENGYUAN_UP)
    self.currentEffert = nil
end

return MainView
