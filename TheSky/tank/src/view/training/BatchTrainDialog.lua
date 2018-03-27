--[[
    批量突飞 Dialog
    Author: H.X.Sun
    Date: 2015.04
]]

local BatchTrainDialog = qy.class("BatchTrainDialog", qy.tank.view.BaseDialog, "view/training/BatchTrainDialog")

function BatchTrainDialog:ctor(delegate)
    BatchTrainDialog.super.ctor(self)

    self.delegate = delegate
    self.TankIdx = delegate.selectTankIdx
    self.tankEntity = delegate.tankEntity
    self.selectTrainIdx = delegate.selectTrainIdx
    self:InjectView("propsListPanel")
    self:InjectView("accessInfoBg")
    self:InjectView("cardNum")
    self:InjectView("confirmBtn")
    self:InjectView("autoBtn")
    self:InjectView("closeBtn")
    self:InjectView("Text_24")
    self.garageModel = qy.tank.model.GarageModel
    self.model = qy.tank.model.TrainingModel
    self.userInfoEntity = qy.tank.model.UserInfoModel.userInfoEntity

    self.userLevel = self.userInfoEntity.level
    self.cardNum:setString("x  " .. self.userInfoEntity.expCard)
    self.carTickUi = {}
    for i = 1, 4 do
        self:InjectView("card_tick_" .. i)
        self.carTickUi[i] = self["card_tick_" .. i]
    end
    self.model:clearChoiceData()

    self:updateCardTick()

    self.selectRapid = {}
    self.selectTankTick = {}

    for i = 1, 4 do
        self:InjectView("btn_tick_" .. i)
        if qy.cocos2d_version ~= qy.COCOS2D_3_7_1 then
            if qy.language == "cn" then 
                self["btn_tick_" .. i]:getChildByName("Text_24"):setPositionY(0)
            else
                if i ~= 2 then 
                    self["btn_tick_" .. i]:getChildByName("Text_2"..i):setPositionY(0)
                end
            end 
        end
        self:OnClick("btn_tick_" .. i, function (sendr)
            self:onClickLogic(self["card_tick_" .. i], i)
            qy.GuideManager:next(1221)
        end,{["isScale"] = false})
    end
    if qy.language == "en" then
        self.Text_24:setPositionY(30)
    end

    self:OnClick("closeBtn", function (sendr)
        self:dismiss()
        qy.GuideManager:next(322)
    end,{["audioType"] = qy.SoundType.BTN_CLOSE})

    self:OnClick("autoBtn", function (sendr)--一键选择
        self:auto()
    end)

    self:OnClick("confirmBtn", function (sendr)--确定
        self:confirmLogic()
    end)

    -- self:createTankList()
end

--[[--
--更新经验卡的打钩
--]]--
function BatchTrainDialog:updateCardTick()
    for  i = 1, #self.carTickUi do
        print("self.model:getBatchCellTickStatus(.."..i..")==",self.model:getBatchCellTickStatus(i))
        if self.model:getBatchCellTickStatus(i) == 0 then
            --隐藏
            self:cancelSelectTick(self.carTickUi[i], i)
        else
            --显示
            self:setSelectTick(self.carTickUi[i], i)
        end
    end
end

--[[--
--选中经验卡
--@param #number id 经验卡ID
--]]
function BatchTrainDialog:setSelectTick(ui,id)
    ui:setVisible(true)
    self.model:updataBatchCellTickStatus(id, 1)
end

--[[--
--取消选中经验卡
--@param #number id 经验卡ID
--]]
function BatchTrainDialog:cancelSelectTick(ui, id)
    ui:setVisible(false)
    self.model:updataBatchCellTickStatus(id, 0)
end

--[[--
--点击经验卡逻辑
--@param #UIImageVIew ui 点击的控件
--#param # id 经验卡ID
--]]
function BatchTrainDialog:onClickLogic(ui, id)
    if ui:isVisible() then
        self:cancelSelectTick(ui,id)
    else
        if  self.model:isEnoughExpCard(id) then
            self:setSelectTick(ui,id)
        else
            qy.hint:show(qy.TextUtil:substitute(37001))
        end
    end
end

--[[--
--一键选择逻辑
--]]
function BatchTrainDialog:choiceLogic()
    if self.userInfoEntity.expCard < 1 then
        qy.hint:show(qy.TextUtil:substitute(37002))
        return
    end
    self.model:optimalMassRapidScheme(self.TankIdx,  self.selectTrainIdx)
    -- if self.model:getSelectTickNum() == 0 then
    --     qy.hint:show("战车经验卡不足")
    -- end
    --刷新经验卡打钩
    self:updateCardTick()
    --刷新坦克打钩
    -- self:updateTankList()
end

--[[--
--确定逻辑
--]]
function BatchTrainDialog:confirmLogic()
    if self.model:getSelectTickNum() == 0 then
        qy.hint:show(qy.TextUtil:substitute(37003))
        return
    end
    self:clearRewardList()

    --计算等级值经验值
    if not self.model:isCurTankExpFull(self.tankEntity) then
        local sExpCard = self.model:getSelectCardList()
        -- local sTankUid = self.model:getSelectTankList()
        local service = qy.tank.service.TrainingService
        service:massRapid(self.selectTrainIdx, sExpCard, sTankUid, self.tankEntity.unique_id, function(data)
            self.cardNum:setString("x  " .. self.userInfoEntity.expCard)
            self.delegate:updateLoadingBar()
            self:showUpgradeLevel()
            --self.model:clearChoiceData()
            --self:updateCardTick()
            -- self:updateTankList()
            self:createRewardList()
            qy.GuideManager:next(2123)
        end)
    else
        qy.hint:show(qy.TextUtil:substitute(37004))
    end
end

--一键升级
function BatchTrainDialog:auto()
    self:clearRewardList()

    --计算等级值经验值
    if not self.model:isCurTankExpFull(self.tankEntity) then
        local sExpCard = self.model:getSelectCardList()
        -- local sTankUid = self.model:getSelectTankList()
        local service = qy.tank.service.TrainingService
        service:autoRapid(self.selectTrainIdx, function(data)
            self.cardNum:setString("x  " .. self.userInfoEntity.expCard)
            self.delegate:updateLoadingBar()
            self:showUpgradeLevel()
            --self.model:clearChoiceData()
            --self:updateCardTick()
            -- self:updateTankList()
            self:createRewardList()
            qy.GuideManager:next(2123)
        end)
    else
        qy.hint:show(qy.TextUtil:substitute(37004))
    end
end



function BatchTrainDialog:showUpgradeLevel()
    if self.model.receive then
        if self.model.receive.upgrade_level and self.model.receive.upgrade_level > 0 then
            local toast = qy.tank.widget.Attribute.new({
            ["attributeImg"] = qy.ResConfig.IMG_TANK_LEVEL,
            ["numType"] = 4,
            ["value"] = self.model.receive.upgrade_level,
            ["hasMark"] = 1,
        })
        qy.hint:showImageToast(toast)
        end
    end
end

--坦克列表
-- function BatchTrainDialog:createTankList()
--     self.tankList = cc.TableView:create(cc.size(385,178))
--     self.tankList:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
--     self.tankList:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
--     self.tankList:setPosition(0,0)
--     self.propsListPanel:addChild(self.tankList)
--     self.tankList:setLocalZOrder(3)
--     self.tankList:setDelegate()

--     local function numberOfCellsInTableView(table)
--         return math.ceil(#self.garageModel:sortWithNoTraining() / 2)
--     end

--     local function tableCellTouched(table,cell)

--     end

--     local function cellSizeForTable(tableView, idx)
--         return 378, 120
--     end

--     local function tableCellAtIndex(table, idx)
--         local cell = table:dequeueCell()
--         local item
--         if nil == cell then
--             cell = cc.TableViewCell:new()
--             item = qy.tank.view.training.BatchTrainCell.new(self)
--             cell:addChild(item)
--             cell.item = item
--         end
--         cell.item:updateCell(self.garageModel:sortWithNoTraining()[idx * 2 + 1], self.garageModel:sortWithNoTraining()[idx * 2 + 2])
--         return cell
--     end

--     self.tankList:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
--     self.tankList:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
--     self.tankList:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
--     self.tankList:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
--     self.tankList:reloadData()
-- end

--[[--
--更新用户数据
--]]
function BatchTrainDialog:updateUserData()
--self.delegate:updateUserData()
end

--[[--
--更新坦克列表
--]]
function BatchTrainDialog:updateTankList()
    self.tankList:reloadData()
end

--[[--
--奖励列表
--]]
function BatchTrainDialog:createRewardList()
    -- 动态容器
    if not tolua.cast(self.dynamic_c,"cc.Node") then
        self.info_c = cc.Layer:create()
    end
    local receive = self.model.receive
    local separateTank = self.model.separateTank

    local h = 170
    -- 获得经验经验
    if receive.exp > 0 then
        local exp = cc.Label:createWithSystemFont(qy.TextUtil:substitute(37005, receive.add_exp),nil,20,cc.size(0,0),cc.TEXT_ALIGNMENT_LEFT,cc.VERTICAL_TEXT_ALIGNMENT_TOP)
        exp:setAnchorPoint(0,1)
        exp:setTextColor(cc.c4b(46, 189, 82,255))
        exp:setPosition(0,h)
        self.info_c:addChild(exp)
        h = h - exp:getContentSize().height - 5
    end
    --分离的坦克
    if separateTank ~= nil then
        for i = 1, #separateTank do
            local separateTankLabel = cc.Label:createWithSystemFont(qy.TextUtil:substitute(37007, separateTank[i].name),nil,20,cc.size(0,0),cc.TEXT_ALIGNMENT_LEFT,cc.VERTICAL_TEXT_ALIGNMENT_TOP)
            separateTankLabel:setAnchorPoint(0,1)
            separateTankLabel:setTextColor(qy.tank.utils.ColorMapUtil.qualityMapColor(separateTank[i].quality))
            separateTankLabel:setPosition(0,h)
            self.info_c:addChild(separateTankLabel)
            h = h - separateTankLabel:getContentSize().height - 5
        end
    end

    --暴击
    -- if receive.crit_exp > 0 then
    --     local criTexp = cc.Label:createWithSystemFont("暴击获得".. receive.exp.."经验",nil,20,cc.size(0,0),cc.TEXT_ALIGNMENT_LEFT,cc.VERTICAL_TEXT_ALIGNMENT_TOP)
    --     criTexp:setAnchorPoint(0,1)
    --     criTexp:setTextColor(cc.c4b(46, 189, 82, 255))
    --     criTexp:setPosition(0,h)
    --     self.info_c:addChild(criTexp)
    --     h = h - criTexp:getContentSize().height - 5
    -- end

    self.info_c:setContentSize(200,170)
    self.info_c:setPosition(0,0)

    if not tolua.cast(self.rewardList,"cc.Node") then
        self.rewardList = cc.ScrollView:create()
        self.accessInfoBg:addChild(self.rewardList)
        self.rewardList:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
        self.rewardList:ignoreAnchorPointForPosition(false)
        self.rewardList:setClippingToBounds(true)
        self.rewardList:setBounceable(true)
        self.rewardList:setAnchorPoint(0,0)
        self.rewardList:setPosition(23,7)
        self.rewardList:setViewSize(cc.size(200,170))
        self.rewardList:setContainer(self.info_c)
    end
end

--[[--
--清除数据
-]]
function BatchTrainDialog:clearRewardList()
    if self.info_c ~= nil then
        self.info_c:removeAllChildren()
        self.info_c = nil
        self.rewardList = nil
    end
end

function BatchTrainDialog:onEnter()
end

function BatchTrainDialog:onExit()
end

return BatchTrainDialog
