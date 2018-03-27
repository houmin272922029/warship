--[[
--训练场
--Author: H.X.Sun
--Date:
]]
local TrainingView = qy.class("TrainingView", qy.tank.view.BaseView, "view/training/TrainingView")

function TrainingView:ctor(delegate)
    TrainingView.super.ctor(self)

    local style = qy.tank.view.style.ViewStyle1.new({
        titleUrl = "Resources/common/title/train_title.png",
        ["onExit"] = function()
            if delegate and delegate.dismiss then
                delegate.dismiss()
                qy.GuideManager:next()
            end
        end
    })
    self:addChild(style, 13)

    self:InjectView("panel")

    self.delegate = delegate
    self.model = qy.tank.model.TrainingModel
    self.garageModel = qy.tank.model.GarageModel
    self.userModel = qy.tank.model.UserInfoModel
    self.userExp = self.userModel.userInfoEntity.exp

    self:InjectView("costIngfoLayout")--训练消费
    self:InjectView("trainIngfoLayout")--正在训练信息
    self:InjectView("trainingListPanel")--训练位列表
    self:InjectView("tankListPanel")--坦克列表
    self:InjectView("beginTrainBtn")--开始训练按钮/批量突飞按钮
    self:InjectView("tankLevel")--坦克等级
    self:InjectView("trainTime")
    self:InjectView("stopTrainBtn")
    self:InjectView("trainTimeTitle")
    self:InjectView("tankLevelNum")
    self:InjectView("progressBar")--实的进度条
    self:InjectView("loadingBar") --虚的进度条
    self:InjectView("progressNum") --进度条的数字
    self:InjectView("tickSprite")--打钩
    self:InjectView("rapidTrainCost")--突飞花费
    self:InjectView("redDot")
    self:InjectView("rapidTrainBtn")
    self:InjectView("exitBtn")
    self:InjectView("diamondTxt")
    self:InjectView("reformLayout")
    self:InjectView("ratio_num")

    self.beginTrainBtn:setTitleText(qy.TextUtil:substitute(37020))

    self:__updatePosition()

    local trainFee = self.model:getTrainFee()
    for i = 1 ,4 do
        self:InjectView("costText" .. i)
        self["costText" .. i]:setString(qy.InternationalUtil:getResNumString(trainFee[i]))
        if i < 3 then
            self:InjectView("mask_"..i)
            self["mask_"..i]:setLocalZOrder(20)
        end
    end

    self.trainIngfoLayout:setVisible(false)
    self.costIngfoLayout:setVisible(true)
    self:setReformVisible(false)
    self.selectCostIdx = 1
    self.lastTrainViewX = 0
    local service = qy.tank.service.TrainingService

    --突飞猛进
    self:OnClick("rapidTrainBtn", function (sendr)
        if not self.hasStopTrain then
            self:rapidTrainLogic()
        end
    end)

    --单选框1
    for i = 1, 4 do
        self:OnClick("radioBtn" .. i, function (sendr)
            if self.tickSprite ~= nil then
                self.tickSprite:setPosition(54, 346 - i * 58)
                self.selectCostIdx = i
            end
        end)
    end

    --开始训练
    self:OnClick("beginTrainBtn", function (sendr)
        if qy.InternationalUtil:hasTankReform() and self.tankEntity and self.tankEntity:isNeedReform() then
            -- 改造功能
            service:reform(self.tankEntity,function()
                -- self:updateOneCell()
                self:updateTankList()
                self:setSelectedTank(self.garageModel.totalTanks[self.selectTankIdx+1])
                qy.hint:show(qy.TextUtil:substitute(90018))
            end)
        else
            self.rapidTrainBtn:setBright(true)
            self.rapidTrainBtn:setTouchEnabled(true)
            self.hasStopTrain = false
            self:beginTrainOrmassRapidLogic()
        end
    end)

    --向左移训练位列表
    self:OnClick("moveLeftBtn", function (sendr)
        self:moveAreaLogic(1)
    end)

    --向右移训练位列表
    self:OnClick("moveRightBtn", function (sendr)
        self:moveAreaLogic(0)
    end)

    --终止训练
    self:OnClick("stopTrainBtn", function (sendr)
        self:stopTrainOrReceiveLogic()
    end)

    self:update()

    if self.delegate and self.delegate.tankUid > 0 then
        local index = self.garageModel:getIndexByUniqueID(self.delegate.tankUid)
        -- self.selectTankIdx = index
        self:redirectCurTankIndex(index)
    end
end

function TrainingView:__updatePosition()
    self.dis = (qy.winSize.width - 1080)/ 4
    self.tankListPanel:setPosition(136 - self.dis, 332)
    self.beginTrainBtn:setPosition(918 + self.dis, 386)
end

--[[--
--打开批量突飞界面
--]]
function TrainingView:openBatchTrainView()
    local nPos = self.model:changePosToIndex(self.tankEntity.train_pos)
    --如果当前的训练位已经有战车在训练，则按钮的逻辑为：批量突飞
    qy.tank.view.training.BatchTrainDialog.new( {
        ["selectTankIdx"] = self.selectTankIdx+1,
        ["tankEntity"] = self.tankEntity,
        ["selectTrainIdx"] =nPos,
        ["updateLoadingBar"] = function ()
            self:loadingBarAnim(2)
        end,
    }):show(true)
    qy.GuideManager:next(2324)
end

--[[--
--开始训练
--]]
function TrainingView:startTrain()
    --如果当前的训练位没有战车在训练，则按钮的逻辑为：开始训练
    if  self.model:isCurTankExpFull(self.tankEntity) then
        --如果当前的战车经验已满,则给个文字提示“经验值已满”
        qy.hint:show(qy.TextUtil:substitute(37021))
        return
    end
    --未满,则检查银币钻石的否足够
    if not  self.model:isEnoughMoneyToTrain(self.selectCostIdx) then
        if self.selectCostIdx > 2 then
            qy.hint:show(qy.TextUtil:substitute(37022))
        else
            qy.hint:show(qy.TextUtil:substitute(37023))
        end
        return
    end

    for i = 1, 8 do
        if i == 8 then
            qy.hint:show(qy.TextUtil:substitute(37024))
            return
        end

        if self.model:getTrainAreaByIdx(i).train_status == 0 then
            local service = qy.tank.service.TrainingService
            service:startTrain(i , self.tankEntity.unique_id, self.selectCostIdx,function(data)
                self:updateTankList()
                self:updateTrainList()
                self:setSelectedTank(self.tankEntity)
                qy.GuideManager:next(23451)
                --self:updateUserData()
            end)
            return
        elseif self.model:getTrainAreaByIdx(i).train_status == -1 then
            qy.hint:show(qy.TextUtil:substitute(37024))
            return
        end
    end
end

--[[--
--开始训练或批量突飞逻辑
--]]
function TrainingView:beginTrainOrmassRapidLogic()
    if self.selectTankIdx == -1 then
        qy.hint:show(qy.TextUtil:substitute(37025))
        return
    end
    -- local tankEntity = self.garageModel.totalTanks[self.selectTankIdx+1]
    if self.tankEntity.is_train == 1 then
        self:openBatchTrainView()
    else
        self:startTrain()
    end

end

--训练位移动逻辑 param type 0：左移 2：右移
function TrainingView:moveAreaLogic(type)
    local listCurX = math.abs(self.trainAreaList:getContentOffset().x)
    local _w = 210
    local listMaxX = _w * 4

    if type == 0 then
        if listCurX < listMaxX then
            --向上取值
            local nextIdx = math.ceil(listCurX / _w ) + 1
            if nextIdx > 4 then
                self.trainAreaList:setContentOffset(cc.p(-listMaxX ,0), true)
            else
                self.trainAreaList:setContentOffset(cc.p(- _w * nextIdx ,0), true)
            end
        end
    else
        if listCurX > 0 then
            --向下取值
            local nextIdx = math.floor(listCurX / _w ) - 1
            if nextIdx < 0 then
                self.trainAreaList:setContentOffset(cc.p(0 ,0), true)
            else
                self.trainAreaList:setContentOffset(cc.p(- _w * nextIdx ,0), true)
            end
        end
    end
end

--更新界面
function TrainingView:update()
    self:createTankList()
    self:createTrainAreaList()
end

--[[--
--更新用户数据
--]]
function TrainingView:updateUserData()
--self.delegate:updateUserData()
end

function TrainingView:updateOneCell()
    self.tankList:updateCellAtIndex(self.selectTankIdx)
end

--[[--
--坦克列表
--]]
function TrainingView:createTankList()
    self.tankListH = 590
    self.tankCellH = 135

    self.tankList = cc.TableView:create(cc.size(218,self.tankListH))
    self.tankList:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.tankList:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.tankList:setPosition(30,8)
    self.tankListPanel:addChild(self.tankList,1)
    self.tankList:setDelegate()
    self.selectTankIdx = 0

    local function numberOfCellsInTableView(table)
        return #self.garageModel.totalTanks
    end

    local function tableCellTouched(table,cell)
        if self.tankList:cellAtIndex(self.selectTankIdx) then
            self:updateOneCell()
            self.tankList:cellAtIndex(self.selectTankIdx).item:removeSelected()
        end
        if self.selectTankIdx ~= cell:getIdx() then
            qy.QYPlaySound.playEffect(qy.SoundType.SWITCH_TANK)
        end
        cell.item:setSelected()
        self.selectTankIdx = cell:getIdx()
        self.model:setBottomIdx(cell:getIdx())
        self:setSelectedTank(self.garageModel.totalTanks[self.selectTankIdx+1])
    end

    local function cellSizeForTable(tableView, idx)
        return 210, self.tankCellH
    end

    local function tableCellAtIndex(table, idx)
        local strValue = string.format("%d",idx)
        local cell = table:dequeueCell()
        local item,label,status
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.training.TankInfoCell.new()
            cell:addChild(item)
            cell.item = item
        end
        if idx == self.selectTankIdx then
            cell.item:setSelected()
            self.model:setBottomIdx(idx)
        else
            cell.item:removeSelected()
        end
        cell.item:render(self.garageModel.totalTanks[idx+1])
        return cell
    end

    self.tankList:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.tankList:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    self.tankList:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    self.tankList:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    self.tankList:reloadData()
    self:setSelectedTank(self.garageModel.totalTanks[self.selectTankIdx+1])
end

--更新坦克列表
function TrainingView:updateTankList()
    local listCurY = self.tankList:getContentOffset().y
    self.tankList:reloadData()
    self.tankList:setContentOffset(cc.p(0,listCurY))
end

--[[--
--更新坦克卡片
--]]
function TrainingView:updateTankCard(entity)
    if self.tankCard then
        self.tankCard:update({
            ["entity"] = entity,
            ["hasLevel"] = 1,
        })
    else
        self.tankCard =  qy.tank.view.common.ItemCard.new({
            ["entity"] = entity,
            ["hasLevel"] = 1,
        })
        self.tankCard:setPosition(925 + self.dis,535)
        self.tankCard:setScale(0.9)
        self.panel:addChild(self.tankCard)
    end
end

--[[--
--正在训练信息
--]]
function TrainingView:trainingInfo()
    self.trainAreaEntity = self.model:getTrainAreaByIdx(self.model:changePosToIndex(self.tankEntity.train_pos))
    self.tankLevelNum:setString(self.tankEntity.level .. "")
    local upgradeExp = self.model:getUpgradeExp(self.tankEntity.level)
    self.progressBar:setPercent(math.floor(self.tankEntity.exp/upgradeExp* 100))
    self.loadingBar:setPercent( math.floor((self.tankEntity.exp + self.trainAreaEntity:hasExp() )/upgradeExp* 100))
    self.progressNum:setString(self.tankEntity.exp .. "/" .. upgradeExp)

    self.rapidTrainCost:setString(self.model:getNextRapidCost())
    self.trainIngfoLayout:setVisible(true)
    self.stopTrainBtn:setVisible(true)
    self.costIngfoLayout:setVisible(false)
    self:setReformVisible(false)
    self.beginTrainBtn:setTitleText(qy.TextUtil:substitute(37026))

    self.trainTime:stopAllActions()
    if self.trainAreaEntity:getRemainTime() > 0 then
        --启动倒计时
        self.trainTimeTitle:setVisible(true)
        self:timeAnim(self.trainAreaEntity)
        self.stopTrainBtn:setTitleText(qy.TextUtil:substitute(37027))
        self.redDot:setVisible(false)
        self:updateTrainInfo(self.trainAreaEntity:getRemainTime())
    else
        self:stopTimeAnim()
    end
end

-- [[--
--设置选中坦克
--@param #table entity 坦克实体
--]]
function TrainingView:setSelectedTank(entity)
    self.rapidTrainBtn:setBright(true)
    self.rapidTrainBtn:setTouchEnabled(true)
    self.progressBar:stopAllActions()
    self.tankEntity = entity
    if entity then
        self:updateTankCard(entity)
        if entity.is_train == 1 then
            self:trainingInfo()
        else
            self.beginTrainBtn:setTitleText(qy.TextUtil:substitute(37020))
            self.trainIngfoLayout:setVisible(false)
            self.costIngfoLayout:setVisible(true)
            self:setReformVisible(false)
        end
        self:chooseReform()
    end
end

function TrainingView:setReformVisible(_flag)
    -- 是否有改造功能
    if qy.InternationalUtil:hasTankReform() then
        self.reformLayout:setVisible(_flag)
    end
end

function TrainingView:chooseReform()
    if not qy.InternationalUtil:hasTankReform() then
        -- 如果没有改造功能
        return
    end
    if self.tankEntity:isNeedReform() then
        print("self.tankEntity:getNextReformRatio()===>>>>",self.tankEntity:getNextReformRatio())
        self.ratio_num:setString(""..self.tankEntity:getNextReformRatio())
        self.trainIngfoLayout:setVisible(false)
        self.costIngfoLayout:setVisible(false)
        self:setReformVisible(true)
        self.beginTrainBtn:setTitleText(qy.TextUtil:substitute(37047))
    end
end

--[[--
--训练位列表
--]]
function TrainingView:createTrainAreaList()
    self.trainAreaList = cc.TableView:create(cc.size(725,250))
    self.trainAreaList:setDirection(cc.TABLEVIEW_FILL_TOPDOWN)
    self.trainAreaList:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.trainAreaList:setPosition(32,0)
    self.trainingListPanel:addChild(self.trainAreaList,1)
    self.trainAreaList:setDelegate()
    self.selectTrainIdx = -1

    local function numberOfCellsInTableView(table)
        return #self.model.trainList
    end

    local function tableCellTouched(table,cell)
        self.selectTrainIdx = cell:getIdx()
        self:setSelectedTrain(cell)
    end

    local function cellSizeForTable(tableView, idx)
        return 220, 250
    end

    local function tableCellAtIndex(table, idx)

        local cell = table:dequeueCell()
        local item,label,status
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.training.TrainAreaCell.new(self)

            cell:addChild(item)
            cell.item = item
        end
        cell.item:updateCell(self.model.trainList[idx + 1])

        return cell
    end

    self.trainAreaList:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.trainAreaList:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    self.trainAreaList:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    self.trainAreaList:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    self.trainAreaList:reloadData()
end

--[--
--选择选列表
--@param #tableViewCell cell
--]
function TrainingView:setSelectedTrain(cell)
    local status = self.model.trainList[self.selectTrainIdx + 1].train_status
    if status == -1 then
        cell.item:showUnlockLogic()
    elseif status == 1 then
        local idx = self.model.trainList[self.selectTrainIdx + 1]:getTankIndex()
        self:redirectCurTankIndex(idx)
    elseif status == 0 then
        qy.hint:show(qy.TextUtil:substitute(37028))
    end
end

--[[--
--跳转到当前坦克列表位置
--]]
function TrainingView:redirectCurTankIndex(index)
    if index > -1 then
        self.selectTankIdx = index - 1
        self.tankList:reloadData()
        self:setSelectedTank(self.garageModel.totalTanks[self.selectTankIdx+1])
        local _h = self.tankListH - self.tankCellH * index
        if _h < 0 then
            self.tankList:setContentOffset(cc.p(0,self.tankList:getContentOffset().y - _h))
        end
    end
end

--[[--
--更新训练位
--]]
function TrainingView:updateTrainList()
    if self.trainAreaList ~= nil then
        local listCurX = self.trainAreaList:getContentOffset().x
        self.trainAreaList:reloadData()
        self.trainAreaList:setContentOffset(cc.p(listCurX,0))
    end
end

function TrainingView:updateTrainInfo(remainTime)
    local hour = math.floor(remainTime / 3600) .. ""
    local min = math.floor((remainTime - tonumber(hour) * 3600) / 60) .. ""
    local seconds = remainTime - tonumber(hour )* 3600 - tonumber(min) * 60
    if string.len(hour) == 1 then
        hour = "0" .. hour
    end
    if string.len(min) == 1 then
        min = "0" .. min
    end
    if string.len(seconds) == 1 then
        seconds = "0" .. seconds
    end
    self.trainTime:setString(hour .. ":" .. min .. ":" .. seconds)
end

--[[--
--停止时间
--]]
function TrainingView:stopTimeAnim()
    self.stopTrainBtn:setTitleText(qy.TextUtil:substitute(37029))
    self.trainTime:setString(qy.TextUtil:substitute(37030))
    self.redDot:setVisible(true)
    self.trainTimeTitle:setVisible(false)
    self.trainTime:stopAllActions()
end

function TrainingView:timeAnim(entity)
    local seq = cc.Sequence:create(cc.DelayTime:create(1), cc.CallFunc:create(function()
        if entity == nil or entity:getRemainTime() > 0 then
            self:updateTrainInfo(entity:getRemainTime())
        else
            self:stopTimeAnim()
        end
    end))
    self.trainTime:runAction(cc.RepeatForever:create(seq))
end

function TrainingView:stopTrainOrReceiveLogic()
    local fontName = qy.language == "tw" and "res/Resources/font/ttf/black_body_2.TTF" or "Arial"
    if self.trainAreaEntity:getRemainTime() > 0 then
        qy.alert:show(
            {qy.TextUtil:substitute(37032) ,{255,255,255} } ,
            {{id=1,color={255,255,255},alpha=255,text=qy.TextUtil:substitute(37031),font=fontName,size=20}} ,
            cc.size(533 , 250) ,{{qy.TextUtil:substitute(37033) , 4} , {qy.TextUtil:substitute(37034) , 5} } ,
            function(flag)
                if qy.TextUtil:substitute(37034) == flag then
                        self:__stopTrainOrReceive()
                end
        end ,"")
    else
        self:__stopTrainOrReceive()
    end
end

--领取或停止按钮
function TrainingView:__stopTrainOrReceive()
    --倒计时完，点击领取，倒计时没完，则为终止
    local service = qy.tank.service.TrainingService
    -- local tankEntity = self.garageModel.totalTanks[self.selectTankIdx+1]
    local nPos = self.model:changePosToIndex(self.tankEntity.train_pos)
    service:stopTrainOrReceive(nPos, self.tankEntity.unique_id,function(data)
        self.hasStopTrain = true
        self.rapidTrainBtn:setBright(false)
        self.rapidTrainBtn:setTouchEnabled(false)
        self.trainTime:stopAllActions()
        self.stopTrainBtn:setVisible(false)
        self.trainTime:setString(qy.TextUtil:substitute(37035))
        self.trainTimeTitle:setVisible(false)
        self:showReceiveAnim()
        self:loadingBarAnim()
    end)
end

--进度条动画
function TrainingView:loadingBarAnim(nType)
    self.times = 1
    self.progressBar:stopAllActions()
    local exp = self.model.receive.exp
    local upgradeLevel = self.model.receive.upgrade_level
    local upgradeExp = self.model:getUpgradeExp(self.tankEntity.level)
    local isFull = false

    if upgradeLevel > 0 then
        isFull = true
    end
    self.progressNum:setString(exp.. "/" .. upgradeExp)
    local updatePercent = math.floor(exp/upgradeExp* 100)
    local function __afterProgressRun()
        self.progressBar:stopAllActions()
        self.loadingBar:setPercent(self.progressBar:getPercent())
        self:updateTrainList()
        self:updateOneCell()
        self.trainIngfoLayout:runAction(cc.Sequence:create(cc.CallFunc:create(function ()
        self.rapidTrainBtn:setBright(true)
        self.rapidTrainBtn:setTouchEnabled(true)
    end),cc.DelayTime:create(1),
        cc.CallFunc:create(function ()
            self:setSelectedTank(self.tankEntity)
        end)))
    end

    local callFunc = cc.CallFunc:create(function ()
        local curPercent = self.progressBar:getPercent()
        if curPercent  < 100  then
            self.progressBar:setPercent(curPercent + 1)
            if not isFull and curPercent == updatePercent then
                __afterProgressRun()
            end
        else
            qy.QYPlaySound.playEffect(qy.SoundType.TANK_UPGRADE)
            self:updateTankList()
            self.tankLevelNum:setString(self.tankEntity.level  .. "")
            if self.times == 2 then
                __afterProgressRun()
                return
            end
            isFull = false
            self.progressBar:setPercent(1)
            self.loadingBar:setPercent(1)
            self.times = 2
        end
    end)
    local seq = cc.Sequence:create(callFunc)
    self.progressBar:runAction(cc.RepeatForever:create(seq))
end

--突飞猛进逻辑
function TrainingView:rapidTrainLogic()
    if  self.model:isCurTankExpFull(self.tankEntity, self.model:getRapidExp(self.selectTankIdx +1 )) then
        --如果当前的战车经验已满,则给个文字提示“经验值已满”
        qy.hint:show(qy.TextUtil:substitute(37036))
        return
    end
    --未满,则检查钻石的否足够
    if not  self.model:isEnoughDiamondToTrain() then
        -- qy.hint:show("钻石不足")
        qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.DIAMOND_NOT_ENOUGH)
        return
    end

    local service = qy.tank.service.TrainingService
    local nPos = self.model:changePosToIndex(self.tankEntity.train_pos)
    service:rapidTrain(nPos, self.tankEntity.unique_id,function(data)
        self.rapidTrainBtn:setBright(false)
        self.rapidTrainBtn:setTouchEnabled(false)
        self:showReceiveAnim()
        self:loadingBarAnim()
        self.rapidTrainCost:setString(self.model:getNextRapidCost())
        qy.GuideManager:next(35682)
    end)
end

function TrainingView:showReceiveAnim()
    local allReceive = self.model:getAddAttribute()

    local function __showAttributeAnim(attributeUrl, nValue,_type,_picType)
        local toast = qy.tank.widget.Attribute.new({
            ["attributeImg"] = attributeUrl,
            ["numType"] = _type,
            ["picType"] = _picType,
            ["value"] = nValue,--支持正负
            ["hasMark"] = 1, --0没有加减号，1:有 默认为0
        })
        qy.hint:showImageToast(toast)
    end

    local callFunc = cc.CallFunc:create(function()
        if allReceive[1] then
            if allReceive[1].numType == nil  then allReceive[1].numType = 4 end
            __showAttributeAnim(allReceive[1].url, allReceive[1].value, allReceive[1].numType, allReceive[1].picType)
            table.remove(allReceive, 1)
        else
            self.stopTrainBtn:stopAllActions()
        end
    end)
    local delay = cc.DelayTime:create(0.7)
    local seq = cc.Sequence:create(callFunc,delay, nil)

    self.stopTrainBtn:runAction(cc.RepeatForever:create(seq))
end

function TrainingView:updateRecharge()
    self.diamondTxt:setString(self.userModel.userInfoEntity:getDiamondStr())
end

function TrainingView:onEnter()
    --新手引导：注册控件
    qy.GuideCommand:addUiRegister({
        {["ui"] = self.beginTrainBtn, ["step"] = {"SG_99"}},
        {["ui"] = self.rapidTrainBtn, ["step"] = {"SG_101"}},
        {["ui"] = self.exitBtn, ["step"] = {"SG_103"}},
    })

     --用户充值数据更新
    if self.userRechargeDatalistener == nil then
        self.userRechargeDatalistener = qy.Event.add(qy.Event.USER_RECHARGE_DATA_UPDATE,function(event)
            self:updateRecharge()
        end)
    end
    self:updateRecharge()
end

function TrainingView:onExit()
    if self.delegate and self.delegate.tankUid then
        self.delegate.tankUid = -1
    end
     --新手引导：移除控件注册
    qy.GuideCommand:removeUiRegister({"SG_99","SG_101","SG_103"})
    qy.Event.remove(self.userRechargeDatalistener)
    self.userRechargeDatalistener = nil
end

return TrainingView
