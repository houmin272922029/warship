--[[
    科技详细页面（升级用）
]]
local TechnologyDetailView = qy.class("TechnologyDetailView", qy.tank.view.BaseView, "view/technology/TechnologyDetailView")

function TechnologyDetailView:ctor(delegate)
    TechnologyDetailView.super.ctor(self)

    self.service = qy.tank.service.TechnologyService
    self.userInfoModel = qy.tank.model.UserInfoModel
    self.model = qy.tank.model.TechnologyModel

    self.delegate = delegate
    self.index = delegate.listData.index
    self.technologyConfigList = self.model:getTechnologyConfigListByTemplateIndex(self.index)
    self.technologyUserList = self.model.technologyList

    self.currentSubIndex = 1
    self.totalSubIndex = #self.technologyConfigList

    print("888---1111",self.technologyConfigList)
    for k,v in pairs(self.technologyConfigList) do
      for k,v in pairs(v) do
          print(k,v)
      end
    end

    self:InjectView("totalTxt")
    self:InjectView("technologyImg")
    self:InjectView("upgradeBtn")
    self:InjectView("lock")
    self:InjectView("lockTxt")
    self:InjectView("nameTxt")
    self.nameTxt:enableOutline(cc.c4b(0,0,0,255),1)
    self:InjectView("lvContainer")
    self:InjectView("precessTxt")
    self:InjectView("needNumTxt")
    self:InjectView("progressContainer")
    self:InjectView("allBg")
    self:InjectView("redDot")
    self:InjectView("leftArrBtn")
    self:InjectView("rightArrBtn")
    self:InjectView("active")
    self:InjectView("research")
    self:InjectView("title1")
    self:InjectView("title2")
    self:InjectView("infoText")
    self:InjectView("Super_upgradeBtn")

    self:OnClick("closeBtn", function(sender)
        self.delegate.dismiss()
    end,{["audioType"] = qy.SoundType.BTN_CLOSE,["isScale"] = false})

    self:OnClick("upgradeBtn", function(sender)
        if self:checkCanOpenOrNot()==false then
            qy.hint:show(qy.TextUtil:substitute(35001))
            return
        end
        local param = {}
        param["tech_id"] = self.currentTechConfigData.id
        local techList = {}
        if self:checkIsFirstOpenOrNot() then
            print("9999449444",self:checkIsFirstOpenOrNot())
            self.service:activate(param,function(data)
                table.insert(techList,data.technology)
                self.model:updateTechnologyList(techList)
                self:updateView()
                self:__showEffert()
                if data.add_fight_power > 0 then
                    qy.hint:show(qy.TextUtil:substitute(35002) .. data.add_fight_power)
                else
                    qy.hint:show(qy.TextUtil:substitute(35003))
                end
                qy.GuideManager:nextTiggerGuide()
            end)
        else
            print("999944945555",self:checkIsFirstOpenOrNot())
            qy.GuideManager:nextTiggerGuide()
            if self.currentTechUserData.level >= 200 then
                qy.hint:show("后续等级暂未开放")
            else
                self.service:upgrade(param,function(data)

                    qy.QYPlaySound.playEffect(qy.SoundType.TECH_UPGRADE)
                    -- qy.hint:show("升级成功")
                    self:__showEffert()
                    if data.technology.level > self.currentTechUserData.level then
                        qy.hint:show({
                            ["text"]=self.addNameAndValue,
                            ["critMultiple"]=data.crit or 1
                        })
                    else
                        qy.hint:show(qy.TextUtil:substitute(35004))
                    end
                    table.insert(techList,data.technology)
                    self.model:updateTechnologyList(techList)
                    self:updateView()

                end)
            end
        end
    end, {["hasAudio"] = false})

    self:OnClick("Super_upgradeBtn",function (  )
        local param = {}
        param["tech_id"] = self.currentTechConfigData.id -- 1  2  3
        local techList = {}
        qy.GuideManager:nextTiggerGuide()
        if self.currentTechUserData.level >= 200 then
            qy.hint:show("后续等级暂未开放")
        else
           
            self.service:upgrade_plus(param,function(data)
                print("999--111",param)
                for k,v in pairs(param) do
                    print(k,v)
                end
                qy.QYPlaySound.playEffect(qy.SoundType.TECH_UPGRADE)
                -- qy.hint:show("升级成功")
                self:__showEffert()
                if data.technology.level > self.currentTechUserData.level then
                    qy.hint:show({
                        ["text"]=self.addNameAndValue,
                        ["critMultiple"]=data.crit or 1
                    })--全体加多少攻击力
                else
                    qy.hint:show(qy.TextUtil:substitute(35004))--成功研发
                end
                table.insert(techList,data.technology)
                self.model:updateTechnologyList(techList)
                self:updateView()

            end)
        
        end
    end)
    
    self:OnClick("getBookBtn", function(sender)
        qy.tank.view.technology.TechnologyHelpDialog.new():show(true)
    end)

    self.leftArrBtn:setVisible(false)
    self:OnClick("leftArrBtn", function(sender)
        self.leftArrBtn:setVisible(true)
        self.rightArrBtn:setVisible(true)
        self.currentSubIndex = self.currentSubIndex - 1
        if self.currentSubIndex <= 1 then
            self.currentSubIndex = 1
            self.leftArrBtn:setVisible(false)
        end
        self.prePercentNum = nil
        self:updateCurrentTechnology()
    end)

    self:OnClick("rightArrBtn", function(sender)
        self.leftArrBtn:setVisible(true)
        self.rightArrBtn:setVisible(true)
        self.currentSubIndex = self.currentSubIndex + 1
        if self.currentSubIndex >= self.totalSubIndex then
            self.rightArrBtn:setVisible(false)
            self.currentSubIndex = self.totalSubIndex

        end
        self.prePercentNum = nil
        self:updateCurrentTechnology()
    end)

    self.title1:setVisible(false)
    self.title2:setVisible(false)
    if self.index == 1 then
         self.title1:setVisible(true)
    elseif self.index ==2 then
        self.title2:setVisible(true)
    end
    self:updateView()

end

--更新view
function TechnologyDetailView:updateView()
   self:updateCurrentTechnology()
end

--更新当前科技显示信息
function TechnologyDetailView:updateCurrentTechnology()
    cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/technology/technology.plist")
    self.currentTechConfigData = self.technologyConfigList[self.currentSubIndex]
    self.technologyUserList = self.model.technologyList
    self.currentTechUserData = self.model:getCurrentTechUserData(self.currentTechConfigData.id)
    local currentLevel = self.currentTechUserData == nil and 1 or self.currentTechUserData.level
    self.currentTechConfigLevelValue = self.model:getTechnologyConfigValueByLevel(currentLevel)
    self.technologyImg:setSpriteFrame(self.model:getImgUrlByIndex(self.currentTechConfigData.id))
    self.totalTxt:setString(qy.TextUtil:substitute(35005)..self.userInfoModel.userInfoEntity.technologyHammer)
    self.nameTxt:setString(self.currentTechConfigData.name)
    self.lvContainer:removeAllChildren()
    -- 等级
     local levelAttr = qy.tank.widget.Attribute.new({
            ["attributeImg"] = "Resources/technology/science_lv.png", --属性字：例如攻击力
            ["numType"] = 12, --num_12.png
            ["hasMark"] = 0, --0没有加减号，1:有 默认为0
            ["value"] = currentLevel,--支持正负，但图必须是由加减号 ["hasMark"] = 1,
        })
        self.lvContainer:addChild(levelAttr)

    local currentId = self.currentTechConfigData.id
    self.needNumTxt:setString("x"..self.currentTechConfigLevelValue["tech_hammer"..currentId])
    local currentExp = self.currentTechUserData == nil and 0 or self.currentTechUserData.currentExp
    self.precessTxt:setString(currentExp.."/"..self.currentTechConfigLevelValue["total"..currentId])
    local percentNum = math.floor(currentExp/self.currentTechConfigLevelValue["total"..currentId] *100)
    print(currentExp .." / "..self.currentTechConfigLevelValue["total"..currentId].." * 100 = "..percentNum)

    self:checkIsFirstOpenOrNot()
    self:checkCanOpenOrNot()

    -- 科技加成
    -- 增加的属性
    -- 1=攻击力
    -- 2=防御力
    -- 3=生命值
    -- 4=攻击力系数
    -- 5=防御力系数
    -- 6=生命系数
    local nameArr = {qy.TextUtil:substitute(35006),qy.TextUtil:substitute(35007) , qy.TextUtil:substitute(35008) , qy.TextUtil:substitute(35009) , qy.TextUtil:substitute(35010) , qy.TextUtil:substitute(35011)}
    local nextTechConfig = self.model:getTechnologyConfigValueByLevel(currentLevel+1)
    local addValue = self.currentTechConfigLevelValue["value"..currentId]

    local addIndex = self.currentTechConfigLevelValue["attribute"..currentId]

    if currentId >= 7 then
        addValue = (addValue - 1) * 100
    end
    local addStr =  nameArr[addIndex] ..addValue..(addIndex>3 and "%" or "")
    self.addNameAndValue = addStr

    self.infoText:setString(addStr)
    if self.currentTechUserData then
        if self.currentTechUserData:hasRedDot() and self.model:canUpgradeOrNotByTechId(currentId) then
            self.redDot:setVisible(true)
        else
            self.redDot:setVisible(false)
        end
    elseif self.currentTechConfigData.level <=self.userInfoModel.userInfoEntity.level then
        self.redDot:setVisible(true)
    else
        self.redDot:setVisible(false)
    end

    -- 进度条
    if self.bar == nil then
    	local sp = cc.Sprite:createWithSpriteFrameName("Resources/technology/science_icon_00029.png")

    	-- sp:setContentSize(330.00 , 38)
        self.bar = cc.ProgressTimer:create(sp)
        self.bar:setType(cc.PROGRESS_TIMER_TYPE_BAR)
        -- Setup for a self.bar starting from the left since the midpoint is 0 for the x
        self.bar:setMidpoint(cc.p(0,0))
        -- Setup for a horizontal self.bar since the self.bar change rate is 0 for y meaning no vertical change
        self.bar:setBarChangeRate(cc.p(1, 0))
        self.bar:setPosition(0,-2)
     --    self.bar:setScaleX(330/270)
    	-- self.bar:setScaleY(38/26)
        self.progressContainer:addChild(self.bar ,-1)
    end
    if self.prePercentNum == nil then
        self.prePercentNum = 0
    end
    self.bar:stopAllActions()
    self.bar:setPercentage(self.prePercentNum)
    if percentNum then
        if percentNum >= self.prePercentNum then
            local to = cc.ProgressTo:create(0.3,percentNum)
            self.bar:runAction(cc.Repeat:create(to , 1))
        else
            local to1 = cc.ProgressTo:create(0.3,100)
            local callFunc = cc.CallFunc:create(function ()
                self.bar:setPercentage(0)
            end)
            local to2 = cc.ProgressTo:create(0.3,percentNum)
            self.bar:runAction(cc.Sequence:create(to1,callFunc, to2))
        end
        self.prePercentNum = percentNum
    end
end
--判断当前科技是否允许开启
function TechnologyDetailView:checkCanOpenOrNot()
    self.lockTxt:setString(qy.TextUtil:substitute(35012, self.currentTechConfigData.level))
    if self.currentTechConfigData.level <=self.userInfoModel.userInfoEntity.level then
        self.upgradeBtn:setBright(true)
        self.lock:setVisible(false)
        return true
    end
    self.lock:setVisible(true)
    self.upgradeBtn:setBright(false)
    return false
end

--判断当前科技是否是第一次激活
function TechnologyDetailView:checkIsFirstOpenOrNot()
    self.Super_upgradeBtn:setTouchEnabled(false)
    self.Super_upgradeBtn:setBright(false)
     self.active:setVisible(false)
     self.research:setVisible(false)
    if self.currentTechUserData == nil then
        self.active:setVisible(true)
        self.Super_upgradeBtn:setTouchEnabled(false)
        self.Super_upgradeBtn:setBright(false)
        return true
    end
    self.research:setVisible(true)
    self.Super_upgradeBtn:setTouchEnabled(true)
    self.Super_upgradeBtn:setBright(true)
    return false
end

function TechnologyDetailView:__showEffert()
    if self.currentEffert == nil then
        self.currentEffert = ccs.Armature:create("ui_fx_kejishengji")
        self.technologyImg:addChild(self.currentEffert,999)
        local size = self.technologyImg:getContentSize()
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

function TechnologyDetailView:onEnter()
    qy.tank.utils.cache.CachePoolUtil.addArmatureFile(qy.ResConfig.TECHNOLOGY_UPGRADE)
    --触发式引导
    qy.GuideCommand:addTriggerUiRegister({
        {["ui"] = self.upgradeBtn, ["step"] = {"T_TE_5"}}
    })
end

function TechnologyDetailView:onExit()
    qy.tank.utils.cache.CachePoolUtil.removeArmatureFile(qy.ResConfig.TECHNOLOGY_UPGRADE)
    self.currentEffert = nil
    --触发式引导
    qy.GuideCommand:removeTriggerUiRegister({"T_TE_5"})
end

return TechnologyDetailView
