local MainView = qy.class("MainView", qy.tank.view.BaseDialog, "lucky_indiana.ui.MainView")

local service = qy.tank.service.OperatingActivitiesService
local model = qy.tank.model.OperatingActivitiesModel
local activity = qy.tank.view.type.ModuleType
local StorageModel = qy.tank.model.StorageModel
local userInfoModel = qy.tank.model.UserInfoModel
function MainView:ctor(delegate)
   	MainView.super.ctor(self)
    qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync(qy.ResConfig.DUOBAO1)
    qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync(qy.ResConfig.DUOBAO2)
    cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/mine/mine.plist")
    self:InjectView("totalnum")--累计个数
   	self:InjectView("CouponBt")
   	self:InjectView("dimondBt")
   	self:InjectView("shopbt")--商店按钮
    self:InjectView("xiangzilist")
    self:InjectView("time")
   	self:InjectView("closeBt")
    self:InjectView("awardlist")
    self:InjectView("choupannel")

    self:InjectView("hongdi")--红底进度条
    -- self.hongdi:setPercent(100)
    self:InjectView("liangdi")
    self:InjectView("helpBt")--规则
    self:InjectView("luckynum")--幸运值
    self:InjectView("buyoneBt")--购买一次
    self:InjectView("onebtimg")--图标
    self:InjectView("buyfiveBt")--购买五次
    self:InjectView("fivibtimg")--图标
    self:InjectView("zhezhao")
    self:InjectView("Frame")
    self:InjectView("awardbg")
    self:InjectView("t1")
    self:InjectView("t2")
    self.zhezhao:setVisible(false)
    self:InjectView("xiangzizhezhao")
    self.xiangzizhezhao:setVisible(false)

    self.fussionlist = model.fussionlist
    self.fissionlist = model.fissionlist

    for i=1,14 do
        self:InjectView("item"..i)
    end
    self:OnClick("helpBt",function ()
        qy.tank.view.common.HelpDialog.new(qy.tank.model.HelpTxtModel:getHelpDataByIndx(37)):show(true)
    end)
    self.types = 1
    self.flag1 = 1
    self.timeflag = 1
    self:OnClick("buyoneBt", function()
        if self.flag1 == 1 then
            self.flag1 = 2
            self:buyoneaward()
            local delay = cc.DelayTime:create(2)
            self:runAction(cc.Sequence:create(delay,cc.CallFunc:create(function()
                self.flag1 = 1
            end)))
        end
    end)
    self:OnClick("buyfiveBt", function()
           if self.flag1 == 1 then
            self.flag1 = 2
            self:buyfiveaward()
            local delay = cc.DelayTime:create(2)
            self:runAction(cc.Sequence:create(delay,cc.CallFunc:create(function()
                self.flag1 = 1
            end)))
        end
        
    end)
    
    self.awardlist:setVisible(false)
    self:OnClick("closeBt", function()
        self:removeSelf()
    end,{["isScale"] = false})

    self.list = self:createView(self.types)
    self.xiangzilist:addChild(self.list)

    self:updateBt(false)
    self:OnClick("CouponBt", function()
        self.types = 1
        self:updateBt(false)
        self.xiangzilist:removeAllChildren()
        self.list = self:createView(self.types)
        self.xiangzilist:addChild(self.list)
        self:update()
        self:updateaward()

    end)
    self:OnClick("dimondBt", function()
        self.types = 2
        self:updateBt(true)
        self.xiangzilist:removeAllChildren()
        self.list = self:createView(self.types)
        self.xiangzilist:addChild(self.list)
        self:update()
        self:updateaward()
    end)
    self:OnClick("shopbt", function()
       local dialog = require("lucky_indiana.src.ShopView").new()
       dialog:show(true)
    end)   
    self:update()
    self:updateaward()
    self:updateguang()
    self.Num = StorageModel:getPropNumByID(94)
    self:__showEffert()
    print("夺宝券个数",self.Num)

    
  
end
function MainView:updateguang(  )
    local action = cc.FadeOut:create(1)--淡出
   
    local action2 = cc.FadeIn:create(1)--淡入
    local callback = function (  )
        self.liangdi:setOpacity(0)
    end
    local delay = cc.DelayTime:create(0.4)
    local sequence = cc.Sequence:create(action, cc.CallFunc:create(callback),action2)
    local action = cc.RepeatForever:create(sequence)
    self.liangdi:runAction(action)
end
function MainView:buyoneaward(  )
    self.flag1 = 2
    local delay = cc.DelayTime:create(2)
    self:runAction(cc.Sequence:create(delay,cc.CallFunc:create(function()
        self.flag1 = 1
    end)))
    local str = ""--get_fussion_2_1
    if self.types == 1 then
        str = "draw_fussion_2_1"
    else
        str = "draw_fission_1_1"
    end
    service:getCommonGiftAward(0, qy.tank.view.type.ModuleType.LUCKY_INDIANA,false, function(data)
        self.timeflag = 1
        self:update()
        self:updateBtEnabled(false)
        self:play(data.draw_ids[1])
    end,false,false,false,str)
   
end
function MainView:buyfiveaward(  )
    self.flag1 = 2
    local delay = cc.DelayTime:create(2)
    self:runAction(cc.Sequence:create(delay,cc.CallFunc:create(function()
        self.flag1 = 1
    end)))
    local str = ""--get_fussion_2_1
    if self.types == 1 then
        str = "draw_fussion_2_5"
    else
        str = "draw_fission_1_5"
    end
    service:getCommonGiftAward(0, qy.tank.view.type.ModuleType.LUCKY_INDIANA,false, function(data)
        self.timeflag = 1
        self:update()
        self:playfive(data.draw_ids)
        self:updateBtEnabled(false)
    end,false,false,false,str)
   
end
function MainView:update(  )
    self.fussionlist = model.fussionlist
    self.fissionlist = model.fissionlist
    local listCury = self.list:getContentOffset()
    self.xiangzilist:removeAllChildren()
    self.list = self:createView(self.types)
    self.xiangzilist:addChild(self.list)
    self.list:setContentOffset(listCury)--设置滚动距离
    if self.types == 1 then
        self.hongdi:setPercent(100 * (self.fussionlist.lucky/self.fussionlist.max_lucky))
        if self.timeflag == 1 then
             self.totalnum:setString(self.fussionlist.times)
        else
             self.totalnum:setString("0")
        end
        self.luckynum:setString(self.fussionlist.lucky)--幸运值
        self.onebtimg:setSpriteFrame("lucky_indiana/res/juan.png")
        self.fivibtimg:setSpriteFrame("lucky_indiana/res/juan.png")
        if self.fussionlist.max_lucky == self.fussionlist.lucky then
             self.luckynum:setString("满")--幸
        end
        self.t1:setString("260买一次")
        self.t2:setString("1170买五次")
    else
        self.hongdi:setPercent(100 * (self.fissionlist.lucky/self.fissionlist.max_lucky))
        if self.timeflag == 1 then
             self.totalnum:setString(self.fissionlist.times)
        else
             self.totalnum:setString("0")
        end
        self.luckynum:setString(self.fissionlist.lucky)--幸运值
        self.onebtimg:setSpriteFrame("lucky_indiana/res/1a.png")
        self.fivibtimg:setSpriteFrame("lucky_indiana/res/1a.png")
           if self.fissionlist.max_lucky == self.fissionlist.lucky then
             self.luckynum:setString("满")--幸
        end
        self.t1:setString("60买一次")
        self.t2:setString("270买五次")
    end
end
function MainView:updateBtEnabled(types)
    self.shopbt:setEnabled(types)
    self.closeBt:setEnabled(types)
    self.helpBt:setEnabled(types)
    self.buyfiveBt:setEnabled(types)
    self.buyoneBt:setEnabled(types)
    if types == false then
        self.zhezhao:setVisible(true)
    else
        self.zhezhao:setVisible(false)
    end
end
function MainView:playfive(lists)--买五次
    self.flg = 1
    print("五个是什么",json.encode(lists))
    local list = lists
    self.choupannel:setVisible(false)
    self.awardlist:setVisible(true)
    self.awardbg:removeAllChildren()
    self.xiangzizhezhao:setVisible(true)

    local data = {}
    if self.types == 1 then
        data = model.fusioncfg
    else
        data = model.fissioncfg
    end
    local num =  math.random(4, 2)

    local actions = {}
    for i = 1, num do
        for j = 1, 14 do        
            local pos = model.indianaListPosition[tostring(j)]
            local func = cc.CallFunc:create(function()
                qy.QYPlaySound.playEffect(qy.SoundType.OPEN_MENU)
                self.Frame:setPosition(pos)
            end)
            local delay = cc.DelayTime:create(0.05)
            table.insert(actions, func)
            table.insert(actions, delay)
            if list[1] == j and i == num then
                break
            end
        end
    end
    local func2 = cc.CallFunc:create(function()
        local item = qy.tank.view.common.AwardItem.createAwardView(data[list[1]].award[1] ,1)
        self.awardbg:addChild(item)
        item:setPosition(40 , 45)
        item:setScale(0.7)
        item.name:setVisible(false)
    end)
    table.insert(actions, func2)
     for i=1,2 do
        local action = cc.FadeOut:create(0.25)--淡出
        local action2 = cc.FadeIn:create(0.25)--淡入
        local callback = cc.CallFunc:create(function()
            self.liangdi:setOpacity(0)
        end)
        table.insert(actions, action)
        table.insert(actions, callback)
        table.insert(actions, action2)
    end

    for i=2,5 do
        -- local delays = cc.DelayTime:create(0.5)
        -- table.insert(actions, delays)
        if list[i-1] ~= 14 then
            for j = list[i-1], 14 do      
                local pos = model.indianaListPosition[tostring(j)]
                local func = cc.CallFunc:create(function()
                    qy.QYPlaySound.playEffect(qy.SoundType.OPEN_MENU)
                    self.Frame:setPosition(pos)
                end)
                local delay = cc.DelayTime:create(0.05)
                table.insert(actions, func)
                table.insert(actions, delay)
                if list[i] == j then
                    self.flg = 2
                    break
                end
            end
        end
        if list[i-1] ~= 1 and self.flg == 1 then
             for k=1,list[i-1] do
                local pos = model.indianaListPosition[tostring(k)]
                local func = cc.CallFunc:create(function()
                    qy.QYPlaySound.playEffect(qy.SoundType.OPEN_MENU)
                    self.Frame:setPosition(pos)
                end)
                local delay = cc.DelayTime:create(0.05)
                table.insert(actions, func)
                table.insert(actions, delay)
                if list[i] == k then
                    break
                end
           end 
        end
        local func2 = cc.CallFunc:create(function()
            local item = qy.tank.view.common.AwardItem.createAwardView(data[list[i]].award[1] ,1)
            self.awardbg:addChild(item)
            item:setPosition(40 + 80 * (i - 1), 45)
            item:setScale(0.7)
            item.name:setVisible(false)
        end)

        table.insert(actions, func2)
        for i=1,2 do
            local action = cc.FadeOut:create(0.2)--淡出
            local action2 = cc.FadeIn:create(0.2)--淡入
            local callback = cc.CallFunc:create(function()
                self.liangdi:setOpacity(0)
            end)
            table.insert(actions, action)
            table.insert(actions, callback)
            table.insert(actions, action2)
        end

        self.flg = 1
         
    end

    local func3 = cc.CallFunc:create(function()
        self:updateBtEnabled(true)
    end)
    table.insert(actions, func3)
    local delays = cc.DelayTime:create(0.5)
    table.insert(actions, delays)
    local func2 = cc.CallFunc:create(function()
        local dialog = require("lucky_indiana.src.AwardDialog").new({
                    ["num"] = 5,
                    ["data"] = data,
                    ["index"] = 0,
                    ["type"] = self.types,
                    ["list"] = list,
                    ["callback"] = function (types )
                        self.xiangzizhezhao:setVisible(types)
                    end,
                    ["callback2"] = function (  )
                        self:buyfiveaward()
                    end
                    })
        dialog:show(true)
    end)
    table.insert(actions, func2)
    local func3 = cc.CallFunc:create(function()
        self.choupannel:setVisible(true)
        self.awardlist:setVisible(false)
    end)
    table.insert(actions, func3)

    self.Frame:runAction(cc.Sequence:create(actions))
end
function MainView:play(idx)
    self.xiangzizhezhao:setVisible(true)
    local num =  math.random(4, 2)

    local actions = {}
    for i = 1, num do
        local sec = i == num and 0.1 or 0.05
        for j = 1, 14 do        
            local pos = model.indianaListPosition[tostring(j)]
            local func = cc.CallFunc:create(function()
                qy.QYPlaySound.playEffect(qy.SoundType.OPEN_MENU)
                self.Frame:setPosition(pos)
            end)
            local delay = cc.DelayTime:create(sec)
            table.insert(actions, func)
            table.insert(actions, delay)
            if idx == j and i == num then
                break
            end
        end
    end
    local data = {}
    if self.types == 1 then
        data = model.fusioncfg
    else
        data = model.fissioncfg
    end
    for i=1,2 do
        local action = cc.FadeOut:create(0.2)--淡出
        local action2 = cc.FadeIn:create(0.2)--淡入
        local callback = cc.CallFunc:create(function()
            self.liangdi:setOpacity(0)
        end)
        table.insert(actions, action)
        table.insert(actions, callback)
        table.insert(actions, action2)
    end
    local func2 = cc.CallFunc:create(function()
        local dialog = require("lucky_indiana.src.AwardDialog").new({
                    ["num"] = 1,
                    ["data"] = data,
                    ["index"] = idx,
                    ["type"] = self.types,
                    ["list"] = 1,
                    ["callback"] = function (types )
                        self.xiangzizhezhao:setVisible(types)
                     end,
                    ["callback2"] = function (  )
                        self:buyoneaward()
                    end
                    })
        dialog:show(true)
    end)
    table.insert(actions, func2)

    local func3 = cc.CallFunc:create(function()
      self:updateBtEnabled(true)
    end)

    table.insert(actions, func3)

    self.Frame:runAction(cc.Sequence:create(actions))
end
function MainView:updateaward(  )
    local data = {}
    if self.types == 1 then
        data = model.fusioncfg
    else
        data = model.fissioncfg
    end
    for i=1,14 do
        self["item"..i]:removeAllChildren()
    end
    for i=1,#data do
        local item = qy.tank.view.common.AwardItem.createAwardView(data[i].award[1] ,1)
        self["item"..i]:addChild(item)
        item:setPosition(73 , 68)
        item:setScale(0.7)
        item.name:setScale(1.2)
        if data[i].type == 1 then
            self["item"..i]:loadTexture("lucky_indiana/res/kuang2.png",1)
            local image = ccui.ImageView:create()
            image:loadTexture("lucky_indiana/res/xiyou.png",1)
            self:__showEffert2(i)
            image:setPosition(cc.p(35,85))
            self["item"..i]:addChild(image)
        else
            self["item"..i]:loadTexture("lucky_indiana/res/kuang1.png",1)
        end
    end
  
            
end
function MainView:updateBt( type1 )
    if type1 == false then
        self.dimondBt:setTouchEnabled(true)
        self.dimondBt:setEnabled(true)
    else
        self.dimondBt:setTouchEnabled(false)
        self.dimondBt:setEnabled(false)
        
    end
    self.CouponBt:setTouchEnabled(type1)
    self.CouponBt:setEnabled(type1)
end
function MainView:__showEffert()
    if self.currentEffert == nil then
        self.currentEffert = ccs.Armature:create("ui_fx_duobao1")
        self["shopbt"]:addChild(self.currentEffert,999)
        -- self.currentEffert:setScale(1.25)
        local size = self["shopbt"]:getContentSize()
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
    self.currentEffert = nil
end
function MainView:__showEffert2(id)
    local currentEffert = nil
    local isEffertShow1 = false
    if currentEffert == nil then
        currentEffert = ccs.Armature:create("ui_fx_duobao2")
        self["item"..id]:addChild(currentEffert,999)
        -- currentEffert:setScale(1.25)
        local size = self["item"..id]:getContentSize()
        currentEffert:setPosition(size.width/2,size.height/2)
    end

    currentEffert:getAnimation():setMovementEventCallFunc(function(armatureBack,movementType,movementID)
        if movementType == ccs.MovementEventType.complete then
            isEffertShow1 = false
        end
    end)
    if not self.isEffertShow1 then
        isEffertShow1 = true
        currentEffert:getAnimation():playWithIndex(0)
    end
    currentEffert = nil
end
function MainView:createView()
    local tableView = cc.TableView:create(cc.size(150, 390))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    -- tableView:setSwallowTouches(false)
    -- tableView:setTouchEnabled(false)
    tableView:setPosition(10, 0)
    local tempnum = 0
    local data = {}
   
    if self.types == 1 then
        tempnum =  table.nums(model.fusionexawardcfg)
        data = model.fusionexawardcfg
    else
        tempnum = table.nums(model.fissionexawardcfg)
        data = model.fissionexawardcfg
    end

    local function numberOfCellsInTableView(tableView)
        return tempnum
    end

    local function cellSizeForTable(tableView,idx)
        return 140, 110
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        local label = nil
        -- local data = model:getList(idx)
        -- local height = model:getHeight(idx)
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("lucky_indiana.src.BoxCell").new({
                ["type"] = self.types,
                ["data"] = data,
                ["callback"] = function (types )
                    self.xiangzizhezhao:setVisible(types)
                end,
                ["callback2"] = function (  )
                   self:buyoneaward()
                end,
                ["callback3"] = function (  )
                    local listCury = self.list:getContentOffset()
                    self.xiangzilist:removeAllChildren()
                    self.list = self:createView(self.types)
                    self.xiangzilist:addChild(self.list)
                    self.list:setContentOffset(listCury)--设置滚动距离
                end
                })
            cell:addChild(item)
            cell.item = item
        end

        cell.item:setData(idx + 1)
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    
    tableView:reloadData()
    self.tableView = tableView

    return tableView
end

function MainView:onEnter()
    self.currentEffert = nil
    self.time:setString(qy.tank.utils.DateFormatUtil:toDateString(model.lucky_indiana_endtime - qy.tank.model.UserInfoModel.serverTime, 7))
    self.listener_1 = qy.Event.add(qy.Event.BONUS_TIME,function(event)
        local time = (model.lucky_indiana_endtime - qy.tank.model.UserInfoModel.serverTime)< 0 and 0 or (model.lucky_indiana_endtime - qy.tank.model.UserInfoModel.serverTime)
        self.time:setString(qy.tank.utils.DateFormatUtil:toDateString(time, 7))
        if model.lucky_indiana_endtime ==  qy.tank.model.UserInfoModel.serverTime then
        self.timeflag = 99
        self.totalnum:setString("0")
        qy.Event.remove(self.listener_1)
        service:getInfo("lucky_indiana",function ( data )
            self.time:setString(qy.tank.utils.DateFormatUtil:toDateString(model.lucky_indiana_endtime - qy.tank.model.UserInfoModel.serverTime, 7))
            self.listener_1 = qy.Event.add(qy.Event.BONUS_TIME,function(event)
                local time = (model.lucky_indiana_endtime - qy.tank.model.UserInfoModel.serverTime)< 0 and 0 or (model.lucky_indiana_endtime - qy.tank.model.UserInfoModel.serverTime)
                self.time:setString(qy.tank.utils.DateFormatUtil:toDateString(time, 7))
            end)
        end)
        end
    end)
    
end

function MainView:onExit()
    qy.Event.remove(self.listener_1)
    self.currentEffert = nil 
    qy.tank.utils.cache.CachePoolUtil.removeArmatureFile(qy.ResConfig.DUOBAO1)
    qy.tank.utils.cache.CachePoolUtil.removeArmatureFile(qy.ResConfig.DUOBAO2)
    cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("lucky.plist")
    -- cc.Director:getInstance():getTextureCache():removeAllTextures()
  
end

return MainView
