--[[
    章节关卡面板
]]

local SceneView = qy.class("SceneView", qy.tank.view.BaseView, "view/campaign/SceneView")

local model = qy.tank.model.CampaignModel
local service = qy.tank.service.CampaignService
function SceneView:ctor(delegate)
    SceneView.super.ctor(self)
    self.Scenev = Scenev
    print("从走了了一遍")
    self:InjectView("closeBtn")
    self:InjectView("homeBtn")
    self:InjectView("howToPlayBtn")
    self:InjectView("titleTxt")
    self:InjectView("fightBtn")
    self:InjectView("prepareBtn")
    self:InjectView("autoFightBtn")
    self:InjectView("checkpointAwardBtn")
    self:InjectView("listView")
    self:InjectView("story")
    self:InjectView("award")
    self:InjectView("sceneAwardBtn")
    self:InjectView("hasAwardBtn")
    self:InjectView("listBg")
    self:InjectView("contentBg")
    -- self:InjectView("maskTop")
    -- self:InjectView("maskBottom")
    self:InjectView("awardBg")
    self:InjectView("awardDesc1")
    self:InjectView("awardDesc2")
    self:InjectView("awardDesc3")
    self:InjectView("chapter")
    self:InjectView("storyTxt")
    qy.tank.utils.TextUtil:autoChangeLine(self.storyTxt , cc.size(500 , 300))
    self.storyTxt:getVirtualRenderer():setLineHeight(38)
    self:InjectView("authorTxt")
    qy.tank.utils.TextUtil:autoChangeLine(self.authorTxt , cc.size(500.00 , 50))
    self:InjectView("checkTitleTxt")
    self:InjectView("timeTxt")
    -- self:InjectView("energyTxt")
    self:InjectView("seePowerBtn")
    self:InjectView("delSpiritNum")
    self:InjectView("hasGot")

    self:InjectView("Image_1")
    self:InjectView("Txt_times")
    self:InjectView("Txt_all_times")

    --困难模式 隐藏体力
    self:InjectView("di04_1")
    

    self.is_true = model:is_common()
    self.di04_1:setVisible(self.is_true)
    self.Image_1:setVisible(not self.is_true)
    self:refresh()
    self.is_common = model:is_common()


    -- self.maskTop:setLocalZOrder(5)
    -- self.maskBottom:setLocalZOrder(5)

    self.energyNode = qy.tank.view.common.EnergyNode.new()
    self:addChild(self.energyNode)
    self.energyNode:setPosition(130, 630)
    --困难模式 隐藏体力
    self.energyNode:setVisible(self.is_true)

    self.awardCommand = qy.tank.command.AwardCommand
    self.userInfoModel = qy.tank.model.UserInfoModel
    self.checkpointView = {}
    self.tableMax = 0
    self.sceneId = delegate.sceneId
    print("SceneView090",self.sceneId)
    -- self.canUpdate = false
    self.isSeeReplay = false

    --  self.xx = model:add_isdrawaward()

    -- local is_true = model:is_common()
    -- if is_true then
    --     self.x = 0
    -- else
    --     self.x = model.is_draw_award[tostring(self.sceneId)].status
    -- end
    
    --print("SceneView911",self.x)

    self.isDrawAward = delegate.isDrawAward

    print("SceneView0000000",self.isDrawAward)
    self.sceneData = delegate.sceneData
    print("SceneView22222222",self.sceneData.isDrawAward)
    self.chapter:setSpriteFrame("Resources/campaign/zj" .. delegate.sceneData.chapter_id .. ".png")

    -- self.sceneData = self.campaignModel.sceneList[tonumber(self.sceneId)]

    self:OnClick(self.closeBtn, function()
        qy.Event.dispatch(qy.Event.HARDATTACKTWO)
        self:clear()
        delegate:dismiss()
    end,{["audioType"] = qy.SoundType.BTN_CLOSE,["isScale"] = false})

    self:OnClick(self.homeBtn, function()
        qy.Event.dispatch(qy.Event.HARDATTACKTWOTHREE)
        qy.QYPlaySound.stopMusic()
        --qy.Event.dispatch(qy.Event.CAMPAIGN_UPDATE_SCENE)
        model:remove_is_common()
         for i=1,20 do
            model:remove_is_true(i)
        end
        self:clear()
        delegate.goHome()
        qy.GuideManager:next(3)
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})

    -- self.sceneConfigData = self.campaignModel:getSceneConfigBySceneId(self.sceneId)

    -- 奖励预览
    self:OnClick(self.checkpointAwardBtn, function()
        self:showAward()
    end)

    self:OnClick("checkpointAwardBtn2", function()
        self:showAward()
    end)

    -- 布阵
    self:OnClick(self.prepareBtn, function()
        qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.EMBATTLE)
    end)


    --战斗
    self:OnClick(self.fightBtn, function()
        if self.is_true then
            if self.needUseEnergy == nil then
                self.needUseEnergy = 5
            end
            print("需要花费的体力："..self.needUseEnergy)
            if self.userInfoModel.userInfoEntity.energy < self.needUseEnergy then
                --体力不足
                qy.hint:show(qy.TextUtil:substitute(6009))
                qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.BUY_OR_USE)
                return
            end

            -- qy.GuideManager:startOtherBattle()
            local param = {}
            self.isClickToFight = true
            param["checkpoint_id"] = self.currentCheckpoint.checkpointId
            self.wasFightCheckpointId = self.currentCheckpoint.checkpointId

            service:toBattle(param,function(data)
                qy.QYPlaySound.pauseMusic()
                self:prepareCheckpointData()
                self:updateTimes()
                qy.tank.command.AwardCommand:add(data.award)
                model.ChapterViewDelegate:showBattle(data)
            end)
        else
            local param = {}
            self.isClickToFight = true
            param["checkpoint_id"] = self.currentCheckpoint.checkpointId
            self.wasFightCheckpointId = self.currentCheckpoint.checkpointId

            service:hardtoBattle(param,function(data)
                print("SceneView98765",data.is_win)
                if tonumber(data.is_win) == 1 then
                    model:remove_one()
                    self:refresh()
                    model:boostime(self.currentCheckpoint.checkpointId)
                    self:updateTimes()
                end
                
                qy.QYPlaySound.pauseMusic()
                self:prepareCheckpointData()
                qy.tank.command.AwardCommand:add(data.award)
                model.ChapterViewDelegate:showBattle(data)
                print("SceneView010--",data.award)

            end)
        end    
    end)

    -- 领取
    self:OnClick(self.sceneAwardBtn, function()
        if self.is_true then
            print("普通领取")
            if model:testSceneOver(self.sceneData) == 0 then
                qy.hint:show(qy.TextUtil:substitute(6010))
            else
                if self.isDrawAward == 1 then
                    qy.hint:show(qy.TextUtil:substitute(6011))
                    self.hasGot:setVisible(true)
                else
                    local param = {}
                    param["scene_id"] = self.sceneId
                    print("普通领取SceneView111",self.sceneId)
                    service:getSceneAward(param,function(data)
                        self.isDrawAward = 1
                        self.sceneData.isDrawAward = 1
                        model:remove_isdrawaward(self.sceneId)
                        self.sceneAwardBtn:setVisible(false)
                        self.hasGot:setVisible(true)
                        -- self.hasAwardBtn:setVisible(true)
                        local awardData = data.award
                        self.awardCommand:add(awardData)
                        function tpClose( ... )
                        delegate:dismiss()
                        
                        end
                        self.awardCommand:show(awardData ,{["callback"] = tpClose})
                        qy.GuideManager:next(5)
                    end)
                end
            end
        else
            print("困难领取1",model:testhardSceneOver(self.sceneData))
            print("困难领取2",self.isDrawAward)
            if model:testhardSceneOver(self.sceneData) == 0 then
                qy.hint:show(qy.TextUtil:substitute(6010))
            else
                if self.isDrawAward == 1 then
                    qy.hint:show(qy.TextUtil:substitute(6011))
                    self.hasGot:setVisible(true)
                else
                    local param = {}
                    param["scene_id"] = self.sceneId
                    print("困难领取3",self.sceneId)
                    service:gethardSceneAward(param,function(data)
                        self.isDrawAward = 1
                        self.sceneData.isDrawAward = 1

                        model:remove_isdrawaward2(self.sceneId)
                        self.sceneAwardBtn:setVisible(false)
                        self.hasGot:setVisible(true)
                        -- self.hasAwardBtn:setVisible(true)
                        local awardData = data.award
                        self.awardCommand:add(awardData)
                        function tpClose( ... )
                        qy.Event.dispatch(qy.Event.HARDATTACKTWO)
                        self:clear()
                        delegate:dismiss()
                        end
                        self.awardCommand:show(awardData ,{["callback"] = tpClose})
                        --qy.GuideManager:next(5)
                    end)
                end
            end

        end    
    end)

    -- 无法领取提示
    -- self:OnClick(self.hasAwardBtn, function()
    --     if self.isDrawAward == 0 then
    --         qy.hint:show("请通关后领取物资奖励")
    --     else
    --         qy.hint:show("您已领取过物资奖励")
    --     end
    -- end)

    -- 查看战力
    self.isShowed = false
    self:OnClick("seePowerBtn", function()
        self:showPower()
    end)

    self:OnClick("seePowerBtn2", function()
        self:showPower()
    end)

    -- 扫荡
    self:OnClick(self.autoFightBtn, function()
        if self.is_true then
            if tonumber(self.selectCheckpointConfigData.status) == 0 then
                    qy.hint:show(qy.TextUtil:substitute(6012))
                return
            end
            local dialog = qy.tank.view.campaign.AutoFightDialog.new(self.is_true,
                {
                    ["checkpoint"] = self.currentCheckpoint
                }
            )
            dialog:show(true)
        else
            if tonumber(self.selectCheckpointConfigData.status) == 0 then
                    qy.hint:show(qy.TextUtil:substitute(6012))
                return
            end
            local dialog = qy.tank.view.campaign.AutoFightDialog.new(self.is_true,
                {
                    ["checkpoint"] = self.currentCheckpoint
                }
            )
            dialog:show(true)
            print("SceneView011苦难",self.currentCheckpoint)
            for k,v in pairs(self.currentCheckpoint) do
                print(k,v)
            end
        end    
    end)

    -- 攻略
    self:OnClick(self.howToPlayBtn, function()
        self:showHowToPlay()
    end)

    self:OnClick("howToPlayBtn2", function()
        self:showHowToPlay()
    end)

    -- self.titleTxt:setString(delegate.sceneName)
    if self.is_common then
        print("普通按钮是否置灰")
        self.sceneAwardBtn:setBright(model:testSceneOver(self.sceneData) == 1)
    else
        print("困难按钮是否置灰")
        self.sceneAwardBtn:setBright(model:testhardSceneOver(self.sceneData) == 1)
    end

    self:prepareCheckpointData()
    self.isFirstIn = true
    -- self.canUpdate = true
    self.ended = false
    self.selectIdx = 1
    self.currentUserSelected = -1
    self:showCheckpintList()
    print("走这里的？？")
    --self:updateEnergy()

    self.isFirstIn = false
    self:saodang()
end

-- 准备关卡数据
function SceneView:prepareCheckpointData()
    self.checkpointsConfig = model:getCheckpointList(self.sceneId)
    table.insert(self.checkpointsConfig,1,{})
end

-- 显示某一关卡信息
function SceneView:showCheckpointStory(str , titleStr)
    self.checkTitleTxt:setString(titleStr)
    local frontSpace = ""
    local strArr = qy.tank.utils.String.split(str ,"|")
    if #strArr>1 then
            self.authorTxt:setString("--"..strArr[2])
            self.storyTxt:setString(frontSpace..strArr[1])
        else
            self.authorTxt:setString("")
            self.storyTxt:setString(frontSpace..str)
    end

    -- self.authorTxt:setPosition(40.00,610)
    self.authorTxt:setPosition(40.00,self.storyTxt:getPositionY()-self.storyTxt:getContentSize().height + 35)

end

-- 显示左侧关卡列表
function SceneView:showCheckpintList(checkpointList)
    -- if self.canUpdate~=true then return end
    -- if self.checkpointTableView~=nil then
    --     self.listBg:removeChild(self.checkpointTableView)
    --     self.checkpointTableView = nil
    -- end

    if not self.checkpointTableView then
        self.checkpointTableView = self:createTableView(891)
        self.listBg:addChild(self.checkpointTableView)
    else
        self.checkpointTableView:reloadData()
    end
    local is_true = model:is_common()

    self:checkAward()
    print("走这里的？")


end

function SceneView:checkAward()
     -- if self.currentCheckpointInTableView==-1 then
        print("SceneView--==",self.isDrawAward)
        if self.is_common then
            print("SceneView普通刷新按钮--",model:testSceneOver(self.sceneData))
            self.sceneAwardBtn:setBright(model:testSceneOver(self.sceneData) == 1)
        else
            print("SceneView困难刷新按钮--",model:testhardSceneOver(self.sceneData))
            self.sceneAwardBtn:setBright(model:testhardSceneOver(self.sceneData) == 1)
        end
        self.sceneAwardBtn:setVisible(self.isDrawAward == 0)
        self.hasGot:setVisible(self.isDrawAward ~= 0)
    -- end
end


local toMoveAndSelect = nil
-- 创建tableview
function SceneView:createTableView(idx)
    local cPtableView
    cPtableView = cc.TableView:create(cc.size(250,535))
    cPtableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
--    cPtableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    cPtableView:setAnchorPoint(0,0)
    cPtableView:setPosition(30,40)
    cPtableView:setDelegate()
    self.checkpointTableView = cPtableView

    --在当前tableView中是否包含当前用户checkpoint
    self.currentCheckpointInTableView = -1
    for i=1 , #self.checkpointsConfig do
        if self.checkpointsConfig[i].checkpointId_ and self.checkpointsConfig[i].checkpointId == model.checkpointCurrentId then
            self.currentCheckpointInTableView = i-1
        end
    end
    local maxNum = #self.checkpointsConfig
    self.tableMax = maxNum

    local function numberOfCellsInTableView(table)
        return maxNum
    end

    local function tableCellTouched(table,cell ,autoClicked , onlyBreakLock)
        -- assert(cell,"tableView的cell为空！！cell:getIdx()－－》"..cell:getIdx())

        if cell == nil then return end

        if(cell.item~=nil and cell.item.updateData~=nil and cell.item.updateData.checkpointData~=nil and cell.item.updateData.checkpointData.checkpointId > model.checkpointCurrentId) then
            qy.hint:show(qy.TextUtil:substitute(6013))
            return
        end

        if self.selectIdx ~= cell:getIdx() then
            qy.QYPlaySound.playEffect(qy.SoundType.SWITCH_CHECKPOINT)
        end

        for i=0, maxNum-1 do
            local thisCell = cPtableView:cellAtIndex(i)
            if thisCell ~= nil then
                cPtableView:cellAtIndex(i).item:ResetSelect()
            end
        end

        self:showDetail(cell:getIdx()+1 , cell)
        self.selectCheckpointConfigData = cell.item:getCheckpointConfigData()
        cell.item:setSelected()
        self.selectIdx = cell:getIdx()
        if autoClicked==nil then
            self.currentUserSelected = cell:getIdx()
        end

       if self.currentUserSelected == self.currentCheckpointInTableView then  --如果当前用户选择的关卡是最新关卡，则将用户选择的当前关卡设置成false。此处用于“自动关卡选择”。
            self.currentUserSelected = -1
       end

       if onlyBreakLock~=nil and onlyBreakLock == true and self.isClickToFight~=nil and  self.isClickToFight == true and self.wasFightCheckpointId~=nil and self.wasFightCheckpointId < self.currentCheckpoint.checkpointId then
            cell.item:showUnlockEffert()
            self.isClickToFight = false
        end

        if self.fightView ~=nil and self.isShowed then
            self:updatePower()
        end
    end

    local function cellSizeForTable(tableView, idx)
        return 268, 158
    end

    local function tableCellAtIndex(table, idx )
        local strValue = string.format("%d",idx)
        local cell = table:dequeueCell()
        local item,label,status
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.campaign.Checkpoint.new()
            cell:addChild(item)
            cell.item = item

            -- label = cc.Label:createWithSystemFont("", "Helvetica", 20.0)
            -- label:setPosition(0,0)
            -- label:setAnchorPoint(0,0)
            -- cell:addChild(label)
            -- cell.label = label

            -- status = cc.Label:createWithSystemFont("", "Helvetica", 24.0)
            -- status:setTextColor(cc.c4b(255,255,0,255))
            -- status:setPosition(125,47)
            -- status:setAnchorPoint(0.5,0.5)
            -- cell:addChild(status)
            -- cell.status = status
        end

        if idx == 0 then
            cell.item:update(
                {
                    ["checkpointNum"] =  "",
                    ["checkpointName"] =  "",
                    ["checkpointData"] = nil,
                    ["isAward"] = true
                }
            )
        else
            cell.item:update(
                {
                    ["checkpointNum"] =  string.gsub(self.checkpointsConfig[idx+1].show_no, "_", "-"),
                    ["checkpointName"] =  self.checkpointsConfig[idx+1].name,
                    ["checkpointData"] = self.checkpointsConfig[idx+1],
                    ["isAward"] = false
                }
            )
        end

        if idx == self.selectIdx then
            cell.item:setSelected()
        else
            cell.item:ResetSelect()
        end
        return cell
    end

    cPtableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    cPtableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    cPtableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    cPtableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    cPtableView:reloadData()




    --选择当前cell
    function toSelectCellAndMove()
        if model:hasCurrentCheckpoint(self.sceneId) == false then --是否通关
            if not self.is_common then
                print("困难模式通关了")
                model:remove_isdrawaward3(self.sceneId)
            end
            if self.isDrawAward ==0 then --是否领过奖励
                self.canGetAward = true
                self.ended = true
                qy.hint:show(qy.TextUtil:substitute(6014))--已全部歼灭敌人，请领取奖励 
                self.currentCheckpointInTableView=-1
            end
        end

        self:checkAward()
        print("还是走这里的？")

        local offsetIdx = 0

        if self.currentUserSelected~=-1 then
            offsetIdx = self.currentUserSelected
        else
            if self.currentCheckpointInTableView~=-1 then
                offsetIdx = self.currentCheckpointInTableView
            else
                offsetIdx = self.tableMax -1
            end
        end

        -- 选中   onlyBreakLock
         function toSelect(onlyBreakLock)
            if onlyBreakLock == true then
                if self.currentUserSelected==-1 and self.currentCheckpointInTableView~=-1 then
                    tableCellTouched(nil , cPtableView:cellAtIndex(self.currentCheckpointInTableView) , true , true)
                end
                return
            end
            if self.currentUserSelected~=-1 then
                tableCellTouched(nil , cPtableView:cellAtIndex(self.currentUserSelected) , true)
            else
                if self.currentCheckpointInTableView~=-1 then
                    tableCellTouched(nil , cPtableView:cellAtIndex(self.currentCheckpointInTableView) , true)
                else
                     if self.canGetAward~=nil and self.canGetAward == true then
                        cPtableView:setContentOffset(cc.p(0,0) )
                        tableCellTouched(nil , cPtableView:cellAtIndex(0) , true)
                     else
                        tableCellTouched(nil , cPtableView:cellAtIndex(maxNum-1) , true)
                     end
                end
            end
        end

        -- 关卡移动
        local moveTime = 0.4
        if self.tableMax>3 and offsetIdx>2 then
            if (self.isFirstIn ==true or model.checkpointCurrentId == self.wasFightCheckpointId ) or self.isSeeReplay == true then
                cPtableView:setContentOffset(cc.p(0,-158* (offsetIdx-2) + 60) )
                moveTime = 0
            else
                if ( offsetIdx == self.tableMax -1) then
                    cPtableView:setContentOffset(cc.p(0,-158* (offsetIdx-2) + 60) )
                else
                    cPtableView:setContentOffset(cc.p(0,-158* (offsetIdx-1) + 60) )
                    cPtableView:setContentOffsetInDuration(cc.p(0,-158* (offsetIdx-2) + 60)  , moveTime)
                end

            end
        else
            moveTime = 0
            cPtableView:setContentOffset(cc.p(0, 0 ) )
        end

        local seq = cc.Sequence:create(
                    cc.DelayTime:create(moveTime) ,
                    cc.CallFunc:create(function()
                        toSelect(true)
                    end) ,
                    cc.DelayTime:create(0.2) ,
                    cc.CallFunc:create(function()
                        toSelect(false)
                    end)
                    )

        if self.isFirstIn == true  or ( offsetIdx == self.tableMax -1) then
            toSelect(false)
        else
            self:runAction(seq)
        end
    end

    toSelectCellAndMove()

    toMoveAndSelect = function()
        toSelectCellAndMove()
    end

    return cPtableView
end

-- 更新关卡列表
function SceneView:updateCheckpintList()


    for i=1 , #self.checkpointsConfig do
        if self.checkpointsConfig[i].checkpointId and self.checkpointsConfig[i].checkpointId == model.checkpointCurrentId then
            self.currentCheckpointInTableView = i-1
        end
    end

    self.checkpointTableView:reloadData()
    if type(toMoveAndSelect) == "function" then
        toMoveAndSelect()
    end
end

-- 显示关卡细节
function SceneView:showDetail(index , cell)
    local singleCheckpointConfig = self.checkpointsConfig[index]
    self.story:setVisible(false)
    self.award:setVisible(false)
    self:showCheckpointStory("" , "")

    if 1 == index then
        self.award:setVisible(true)
        -- self.awardItem1:setVisible(false)
        -- self.awardItem2:setVisible(false)
        -- self.awardItem3:setVisible(false)
        if self.is_true then
            print("普通通关奖励显示")
            local awardItem
            local awardData = self.sceneData.award
            local awardItemView
            -- local awardItemDesc
            for i=1, #awardData do
                -- awardItemView = self:findViewByName("awardItem"..i)
                -- awardItemDesc = self:findViewByName("awardDesc"..i)
                -- awardItemView:setVisible(true)
                awardItem = qy.tank.view.common.AwardItem.createAwardView(awardData[i],1)
                -- awardItem:setTitlePosition(1)
                self.awardBg:addChild(awardItem)
                -- awardItemDesc:setString(awardItem.params.desc)
                awardItem:setPosition(170 * (i - 1) + 115, 150)
            end
            return
        else
            print("困难通关奖励显示")
            print("困难通关奖励显示",self.sceneId)
            print("",qy.Config.hard_scene[tostring(self.sceneId)].award)
            local awardItem
            local awardData = qy.Config.hard_scene[tostring(self.sceneId)].award
            for i=1, #awardData do
                awardItem = qy.tank.view.common.AwardItem.createAwardView(awardData[i],1)
                self.awardBg:addChild(awardItem)
                awardItem:setPosition(170 * (i - 1) + 115, 150)
            end
            return
        end
    end
    self.story:setVisible(true)
    self.currentCheckpoint = singleCheckpointConfig
    local contentStr = "寄予：\n    中文啊锕锕锕锕锕锕锕锕锕锕锕锕锕锕锕锕|锕dsadsaad文"
    contentStr = singleCheckpointConfig.desc
    self:showCheckpointStory(contentStr , singleCheckpointConfig.name)
--   关卡 战斗力
    if self.fightView == nil then
        self.fightView = qy.tank.widget.Attribute.new({
            ["numType"] = 18, --num_15.png
            ["hasMark"] = 0, --0没有加减号，1:有 默认为0
            ["value"] = 0,--支持正负，但图必须是由加减号 ["hasMark"] = 1,
            ["attributeImg"] = qy.ResConfig.IMG_FIGHT_POWER, --属性字：例如攻击力
            ["picType"] = 2, --1：- + 0123456789，2：+ - 0123456789 默认是1
        })
        self.story:addChild(self.fightView)
        self.fightView:setPosition( 75 , 10)
        -- self.fightView:setScale(2)
        self.fightView:setVisible(false)
    end
    -- self.fightView:update(model:getFightPowerByCheckpointData(singleCheckpointConfig))
    self:updateTimes()
end

-- 更细挑战次数  只有booos才有次数限制
function SceneView:updateTimes()
    local checkpointConfigData = self.currentCheckpoint
    print("普通",self.currentCheckpoint.checkpointId)
    if self.is_true then
        print("普通checkpointConfigData.type",checkpointConfigData.type)
        -- local checkPointUserData = model:getCheckpointUserDataByCheckpointId(checkpointConfigData.checkpointId)
        if checkpointConfigData ~=nil and checkpointConfigData.type == 2 then
            local times = model.bossTotalTimes - checkpointConfigData:getTimes()
            times = times >= 0 and times or 0
            self.timeTxt:setString(qy.TextUtil:substitute(6015)..times.."/"..model.bossTotalTimes)
            self.needUseEnergy = 15
        else
            self.needUseEnergy = 5
            self.timeTxt:setString("")
        end
        self.delSpiritNum:setString("X" .. self.needUseEnergy)
    else
        if checkpointConfigData ~=nil and checkpointConfigData.type == 2 then
            local tm = model.openPointList[tostring(self.currentCheckpoint.checkpointId)].times_uptime
            print("1000000000",tm)
            local startTime = os.date("%d",os.time())
            local startTime2 = os.date("%d",tm)
            if startTime ~= startTime2 then
                print("不是同一天")
                local times = model.booshardToalTimes 
                times = times >= 0 and times or 0
                self.timeTxt:setString(qy.TextUtil:substitute(6015)..times.."/"..model.booshardToalTimes)
            else
                 print("同一天")
                local times = model.booshardToalTimes - model.openPointList[tostring(self.currentCheckpoint.checkpointId)].times
                times = times >= 0 and times or 0
                self.timeTxt:setString(qy.TextUtil:substitute(6015)..times.."/"..model.booshardToalTimes)
            end

            -- local times = model.booshardToalTimes - model.openPointList[tostring(self.currentCheckpoint.checkpointId)].times
            -- times = times >= 0 and times or 0
            -- self.timeTxt:setString(qy.TextUtil:substitute(6015)..times.."/"..model.booshardToalTimes)
            
        else
            
            self.timeTxt:setString("")
        end
    end

    
end

-- 奖励预览
function SceneView:showAward()
    function callBack(flag)
        print(flag)
    end
    local extendObj = {
            ["titleUrl"] = "Resources/campaign/jiangliyulan.png",
        }
    local isFirstAttack =  false
    print("model.checkointCompleteId===",model.checkointCompleteId)
    print("self.selectCheckpointConfigData.checkpointId===",self.selectCheckpointConfigData.checkpointId)
    if model.checkointCompleteId < self.selectCheckpointConfigData.checkpointId then
        isFirstAttack = true
    end
    local alertTitle = isFirstAttack == true and qy.TextUtil:substitute(6016) or qy.TextUtil:substitute(6017)
    local checkPointContent = qy.tank.view.campaign.CheckpointAwardDialog.new(self.is_true,{
        ["checkPointData"] = self.selectCheckpointConfigData,
        ["isFirstAttack"] = isFirstAttack
    })

    qy.alert:showWithNode(alertTitle  ,  checkPointContent , cc.size(560,290) ,{{qy.TextUtil:substitute(6018), 4, "Resources/common/txt/guanbi.png"} } ,callBack ,extendObj)
end

-- 攻略
function SceneView:showHowToPlay()
    if self.is_true then
         local service = qy.tank.service.CampaignService
            local param = {}
            param["checkpoint_id"] = self.currentCheckpoint.checkpointId

            service:passReport(param,function(data)
                if data~=nil and #data>0 then
                    self.isSeeReplay = true
                    local dialog = qy.tank.view.campaign.HowToPlayDialog.new(
                        {
                            ["data"] = data,
                            ["checkpoint"] = self.currentCheckpoint,
                            ["isClose"] = function()
                                self.isSeeReplay = false
                            end
                        }
                    )
                    dialog:show(true)
                else
                    qy.hint:show(qy.TextUtil:substitute(6019))
                end

            end)
    else
        local service = qy.tank.service.CampaignService

            service:passhardReport(self.currentCheckpoint.checkpointId,function(data)
                if data~=nil and #data>0 then
                    self.isSeeReplay = true
                    local dialog = qy.tank.view.campaign.HowToPlayDialog.new(
                        {
                            ["data"] = data,
                            ["checkpoint"] = self.currentCheckpoint,
                            ["isClose"] = function()
                                self.isSeeReplay = false
                            end
                        }
                    )
                    dialog:show(true)
                else
                    qy.hint:show(qy.TextUtil:substitute(6019))
                end

            end)
    end
end

-- 显示战力
function SceneView:showPower()
    if self.fightView ~=nil then
        self.fightView:setVisible(not self.isShowed)
        -- if not self.isShowed then
        --     service:getPower(self.currentCheckpoint, function(data)
        --        self.fightView:update(data.fight_power)
        --     end)
        -- end
        if not self.isShowed then
            self:updatePower()
        end
    end
    self.isShowed = not self.isShowed
end

function SceneView:updatePower()
    if self.is_true then
        service:getPower(self.currentCheckpoint, function(data)
           self.fightView:update(data.fight_power)
        end)
    else
        service:gethardPower(self.currentCheckpoint.checkpointId, function(data)
           self.fightView:update(data.fight_power)
        end)
    end    
end

function SceneView:onEnter()
    qy.QYPlaySound.playMusic(qy.SoundType.CAMP_BG_MS)
    --新手引导：注册控件
    qy.GuideCommand:addUiRegister({
        {["ui"] = self.fightBtn,["step"] = {"SG_14","SG_40","SG_68","SG_81","SG_106"}},
        {["ui"] = self.homeBtn,["step"] = {"SG_21","SG_50","SG_96"}},
        {["ui"] = self.prepareBtn, ["step"] = {"SG_60"}},
        {["ui"] = self.sceneAwardBtn, ["step"] = {"SG_122"}},
    })

    -- qy.QYPlaySound.resumeMusic()   
    self.listener = qy.Event.add(qy.Event.CAMPAIGN_UPDATE_CHECKPOINT,function(event)
        if model:hasCurrentCheckpoint(self.sceneId) == false and self.ended == true then
            self:updateTimes()
        else
            self:updateCheckpintList()
            self:updateTimes()
        end
    end)

    self.listener2 = qy.Event.add(qy.Event.CAMPAIGN_UPDATE_TIMES,function(event)
        self:updateTimes()
    end)

    self.listener_3 = qy.Event.add(qy.Event.HARDATTACK,function(event)
        self:refresh()
        --调用你想调用的某个方法
    end)
end

function SceneView:onEnterFinish()
    local model = qy.tank.model.RoleUpgradeModel
    if model:isRoleUpgrade() then
        model:redirectRoleUpgrade()
        model:setRoleUpgrade(false)
    else
        qy.Event.dispatch(qy.Event.CAMPAIGN_UPDATE_CHECKPOINT)
    end
    if qy.language == "en" then
        -- print("self.sceneData.chapter_id===="..self.sceneData.chapter_id.."   self.sceneData.sceneId==="..self.sceneData.sceneId .." "..cc.UserDefault:getInstance():getIntegerForKey("campaign1").." ".. cc.UserDefault:getInstance():getIntegerForKey("campaign2"))
        -- if (self.sceneData.chapter_id == 2 and self.sceneData.sceneId == 7) and cc.UserDefault:getInstance():getIntegerForKey("campaign1", 100) == 100 then
        --     cc.UserDefault:getInstance():setIntegerForKey("campaign1", 2)
        --     qy.tank.view.common.ShareView.new():show(2)
        -- else
        if (self.sceneData.chapter_id == 2  and self.sceneData.sceneId == 9) and cc.UserDefault:getInstance():getIntegerForKey("campaign2", 100) == 100 then
            cc.UserDefault:getInstance():setIntegerForKey("campaign2", 2)
            qy.tank.view.common.ShareView.new():show(3)
        end
    end
end

function SceneView:onExit()
    qy.Event.remove(self.listener)
    qy.Event.remove(self.listener2)
    qy.Event.remove(self.listener_3)
    self.listener_2 = nil

    --新手引导：移除控件注册
    qy.GuideCommand:removeUiRegister({"SG_14", "SG_21","SG_40","SG_50","SG_60","SG_68","SG_81","SG_96","SG_106","SG_122"})
end

function SceneView:clear()
    -- self.closeBtn:cleanup()
    -- self.checkpointAwardBtn:cleanup()
    -- self.prepareBtn:cleanup()
    -- self.fightBtn:cleanup()
    -- self.sceneAwardBtn:cleanup()
    -- self.autoFightBtn:cleanup()
    -- self.howToPlayBtn:cleanup()
    -- self:removeAllChildren()
end
--刷新攻打次数困难模式
function SceneView:refresh()
    if not self.is_true then
        self.Txt_times:setString(model.all_times - model.attack_times)
        self.Txt_all_times:setString(model.all_times)
    end
end

--屏蔽扫荡按钮
function SceneView:saodang(  )
    if self.is_true then
        self.autoFightBtn:setVisible(true)
    else
        self.autoFightBtn:setVisible(false)
    end
end

return SceneView
