local MainView = qy.class("MainView", qy.tank.view.BaseView, "view/main/MainView2")

local ChatWidget = require("module.chat.Widget")
local BroadcastView = qy.tank.view.main.BroadcastView
local smodel = qy.tank.model.ServiceWarModel

local MOVE_INCH = 7.0/160.0
local function convertDistanceFromPointToInch(pointDis)
    local glview = cc.Director:getInstance():getOpenGLView()
    local factor = (glview:getScaleX() + glview:getScaleY())/2
    return pointDis * factor / cc.Device:getDPI()
end

function MainView:ctor(delegate)
    MainView.super.ctor(self)
    -- print("MainView ctor =============")
    self.delegate = delegate
    -- self:InjectView("commandCenterBtn")
    -- self:InjectView("trainingBtn")
    -- self:InjectView("tankFactoryBtn")
    self:InjectView("refreshBtn")
    self:InjectView("res")
    -- self.energyNode = qy.tank.view.common.EnergyNode.new()
    -- self.res:addChild(self.energyNode)
    -- self.energyNode:setPosition(0, -26)
    -- self:InjectView("technologyBtn")
    self:InjectView("Image_3")
    self:InjectView("cityScrollView")
    self:InjectView("silverTxt")
    self:InjectView("diamondTxt")
    self:InjectView("nameTxt")
    self:InjectView("lvTxt")
    self:InjectView("energyTxt")
    self:InjectView("huodong_img")
    self:InjectView("TopBg")
    self:InjectView("Btn_LegionWar")
    self:InjectView("legion_sign_action")

    self:InjectView("storageBtn")
    self:InjectView("embattleBtn")
    self:InjectView("garageBtn")
    self:InjectView("campaignBtn")
    self:InjectView("equipBtn")
    self:InjectView("activityBtn1")
    self:InjectView("activityBtn2")
    self:InjectView("legionBtn")
    self:InjectView("userMesg")
    --功能开启提示
    self:InjectView("open_name")
    self:InjectView("openBtn")
    self:InjectView("openBtn1")
    self:InjectView("Sprite_115")
    --我要变强按钮
    self:InjectView("strongBtn")
    --左边的控件
    self:InjectView("mailBtn")
    self:InjectView("task")--任务
    self:InjectView("task_bg")
    self:InjectView("taskBtn")
    self:InjectView("taskTips")
    self.taskTips:enableOutline(cc.c4b(0,0,0,255),1)
    self:InjectView("supply")--补给
    self:InjectView("supply_bg")
    self:InjectView("supplyBtn")
    self:InjectView("supplyTips")
    self.supplyTips:enableOutline(cc.c4b(0,0,0,255),1)
    self:InjectView("arena")--竞技场
    self:InjectView("arena_bg")
    self:InjectView("arenaBtn")
    self:InjectView("arenaTips")
    self.arenaTips:enableOutline(cc.c4b(0,0,0,255),1)
    self:InjectView("userExpBar")--指挥官经验
    self:InjectView("userExpPercent")
    -- self.userExpPercent:enableOutline(cc.c4b(0,0,0,255),1)

    self:InjectView("commandCenterBtn")
    self:InjectView("trainingBtn")
    self:InjectView("extractionCardBtn")
    self:InjectView("tankFactoryBtn")
    self:InjectView("technologyBtn")
    self:InjectView("mineBtn")
    self:InjectView("HidePic")

    self:InjectView("commandLight")
    self:InjectView("extractionCardLight")
    self:InjectView("factoryLight")
    self:InjectView("mineLight")
    self:InjectView("techLight")
    self:InjectView("trainLight")
    self:InjectView("tankFactoryMask")
    self:InjectView("trainMask")

    self:InjectView("bottomModules")
    self:InjectView("leftModules")
    self:InjectView("topModules")
    -- self.topModules:setScale(0.8)
    self:InjectView("hideBig")
    self:InjectView("hideBtn")
    self:InjectView("hideLight")
    self:InjectView("chargeBtn")
    self:InjectView("Message1")
    self:InjectView("Message2")
    self:InjectView("Message3")
    self:InjectView("Message4")
    self:InjectView("Message5")
    self:InjectView("Message6")
    self:InjectView("headImg")
    self:InjectView("Btn_Achievement")
    self:InjectView("Functions")
    self:InjectView("Btn_funcitons")
    self:InjectView("Btn_Resolve")
    self:InjectView("Fun_bg")
    self:InjectView("vipBtn")
    self:InjectView("Right")
    self:InjectView("campainImg")
    self:InjectView("cross_service_btn")
    self:InjectView("TimeLimitBtn")
    self:InjectView("cross_service_icon")
    self:InjectView("help_btn")
    self:InjectView("passengerBtn")
    self:InjectView("level1")
    self:InjectView("level2")
    self:InjectView("level3")
    self:InjectView("Btn_Rank")
    self:InjectView("Btn_Medal")
    self:InjectView("Btn_Fittings")
    self:InjectView("svipBtn")
    self:InjectView("Tank918Bt")
    self:updatetank918bt()

    -- self.chargeBtn:setVisible(false)
    local canSwallow = false
    self.isHide = false
    self.commandLight:setVisible(false)
    self.extractionCardLight:setVisible(false)
    self.factoryLight:setVisible(false)
    self.mineLight:setVisible(false)
    self.techLight:setVisible(false)
    self.trainLight:setVisible(false)
    -- self.Functions:setSwallowTouches(false)

    -- self.FunctionsStatus = true

    -- self.commandLight:setSwallowTouches(canSwallow)
    -- self.extractionCardLight:setSwallowTouches(canSwallow)
    -- self.factoryLight:setSwallowTouches(canSwallow)
    -- self.mineLight:setSwallowTouches(canSwallow)
    -- self.techLight:setSwallowTouches(canSwallow)
    -- self.trainLight:setSwallowTouches(canSwallow)

    self.commandCenterBtn:setSwallowTouches(canSwallow)
    self.trainingBtn:setSwallowTouches(canSwallow)
    self.tankFactoryBtn:setSwallowTouches(canSwallow)
    self.mineBtn:setSwallowTouches(canSwallow)
    self.technologyBtn:setSwallowTouches(canSwallow)
    self.extractionCardBtn:setSwallowTouches(canSwallow)

    -- self:InjectView("taskRewardTips")
    -- self:InjectView("taskTips_1")
    -- self:InjectView("taskTips_2")

    -- self.taskRewardTips:setVisible(false)

    self.model = qy.tank.model.UserInfoModel
    self.taskModel = qy.tank.model.TaskModel

    qy.tank.model.TankShopModel:init()
    qy.tank.model.PropShopModel:init()


    -- 渲染界面
    self:showMainBg(delegate)

    -- local tab = qy.tank.widget.TabButtonGroup.new("widget/TabButton1",{"1","2","3"},cc.size(160,40),"h",function(idx)
    --     print("++++++++++++++++++++++++++++++ tab idx = "..idx)
    -- end)
    -- self:addChild(tab)
    -- tab:setPosition(200,300)

    -- self:updateLeftModuleData()

    --自动播放主城动画
    self:createCityAnimations()

    -- 隐藏按钮动画处理
    -- self:HideAnimationInit()

    self:createActivityIcons()

    -- qy.tank.utils.ScreenShotUtil:takePoto("potPoto" , true , function(poto)

    -- end)

    --启动新手引导
    self:startGuide()

    -- 聊天窗口
    self.chatWidget = ChatWidget.new()
    self.chatWidget:addTo(self)

    self.broadcastView = BroadcastView.new()
    self.broadcastView:setVisible(false)
    self.broadcastView:setPosition(display.cx, display.height - 150)
    self.broadcastView:addTo(self)

    -- self:changeFunctionsStatus()
    if self.cityScrollView.setScrollBarEnabled then
        self.cityScrollView:setScrollBarEnabled(false)
    end

    -- 设置是否跳转到appstore或googlepay商店   2：不弹出
    print(cc.UserDefault:getInstance():getIntegerForKey("campaign1").." ------是否弹出跳转appstore  googlepay页面------ "..cc.UserDefault:getInstance():getIntegerForKey("campaign2").."  "..cc.UserDefault:getInstance():getIntegerForKey("shareArena"))
    -- local levelLabel = ccui.TextAtlas:create("5", "font/num/level_number.png", 22, 22, '0')
    -- levelLabel:setPosition(5, 12)
    -- levelLabel:setAnchorPoint(1,0.5)
    -- levelLabel:addTo(self.Sprite_115)
    -- self.levelLabel = levelLabel

    qy.Timer.create(tostring(math.random()),function()        
        qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.LOGIN_ANNOUNCE)
    end, 0.1, 1)
end

function MainView:createActivityIcons()
    if not self.actIcons then

        self.actIcons = qy.tank.view.activity.ActivitiesIcons.new()
        -- local list = qy.tank.model.ActivityIconsModel:getIconList()
        -- local len = #list

        -- if len == 0 or not list then
        --     self.TopBg:setVisible(false)
        -- end
        -- self.TopBg:setContentSize(115 * len, 86)
        -- self:addChild(actIcons)
        self.TopBg:addChild(self.actIcons)
        self.actIcons:setPosition(20, 80)
    end
    self:changeTopBg()
end

function MainView:changeTopBg()
    local list = qy.tank.model.ActivityIconsModel:getIconList()
    local len = #list


    if len == 0 or not list then
          print(1111)
        self.TopBg:setVisible(false)
    else
          print(112222211)
        self.TopBg:setVisible(true)
    end
    self.TopBg:setContentSize(115 * len, 86)
end

--主城动态元素
function MainView:createCityAnimations(autoPlay)
    self:InjectView("animationContainer")

    -- cc.SpriteFrameCache:getInstance():addSpriteFrames("fx/ui/mainCity/truck/truck.plist" ,"fx/ui/mainCity/truck/truck.png")
    -- local truck = qy.tank.widget.FrameAnimation.new("truck" , 8 , .2 , 0)
    -- truck:play()
    -- self.animationContainer:addChild(truck)
    -- truck:setScale(0.75)

    cc.SpriteFrameCache:getInstance():addSpriteFrames("fx/".. qy.language .."/ui/mainCity/man/man.plist" ,"fx/".. qy.language .."/ui/mainCity/man/man.png")
    self.man = qy.tank.widget.FrameAnimation.new("man" , 40 , .2 , 0)
    self.man:play()
    self.animationContainer:addChild(self.man)
    self.man:setPosition(30,-10)

    -- cc.SpriteFrameCache:getInstance():addSpriteFrames("fx/ui/mainCity/door/door.plist" ,"fx/ui/mainCity/door/door.png")
    -- local door = qy.tank.widget.FrameAnimation.new("door" , 18 , .2 , 0)
    -- door:play()
    -- self.animationContainer:addChild(door)

    -- cc.SpriteFrameCache:getInstance():addSpriteFrames("fx/ui/mainCity/tr/tr.plist" ,"fx/ui/mainCity/tr/tr.png")
    -- local tr = qy.tank.widget.FrameAnimation.new("tr" , 52 , .2 , 0)
    -- tr:play()
    -- self.animationContainer:addChild(tr)

end

--刷新主界面
function MainView:refreshMainInterface()
    qy.tank.service.LoginService:login(function (data)
        qy.tank.model.UserInfoModel:init(data.main)
    end)
end

-- 背景滚动层
function MainView:showMainBg(delegate)
    -- self.cityScrollView:setTouchEnabled(true)
    -- self.cityScrollView:setSwallowTouches(true)
    self.cityScrollView:setContentSize(qy.winSize.width, qy.winSize.height)
    local touchMoved, touchPoint
    touchMoved = false

    self.onTouchBegan = function(touch, event)
        touchPoint = touch:getLocation()
        touchMoved = false
        return true
    end

    self.onTouchMoved = function(touch, event)
        local moveDistance = touch:getLocation()
        moveDistance.x = moveDistance.x - touchPoint.x
        moveDistance.y = moveDistance.y - touchPoint.y
        local dis = math.sqrt(moveDistance.x * moveDistance.x + moveDistance.y * moveDistance.y)
        if math.abs(convertDistanceFromPointToInch(dis)) >= MOVE_INCH then
            touchMoved = true
        end
    end

    -- 功能开启提示
    self:OnClick("openBtn", function(sender)
        qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.OPEN_HELP)
    end)

    -- 我要变强
    self:OnClick("strongBtn", function(sender)        
        qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.STRONG)
    end)
       -- 至尊战神
    self:OnClick("svipBtn", function(sender)        
        qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.GODWAR)
    end)

    -- 隐藏/展开 功能按钮
    self:OnClick("HidePic", function(sender)
        self:hideAction()
        -- qy.tank.utils.NumberUtil.numRefreshAnim(self.silverTxt)
        -- self:removeRedDotSignal()
    end)

    --  暂时用于刷新主接口
    self:OnClick("refreshBtn", function(sender)
        self:refreshMainInterface()
        -- qy.tank.utils.NumberUtil.numRefreshAnim(self.silverTxt)
        -- self:removeRedDotSignal()
    end)

    -- 进入仓库
    self:OnClick("storageBtn", function(sender)
        --qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.LOGIN_ANNOUNCE)
        qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.STORAGE)
    end)

    -- 进入布阵
    self:OnClick("embattleBtn", function(sender)
        qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.EMBATTLE)
    end)

    -- 进入车库
    self:OnClick("garageBtn", function(sender)
        if delegate and delegate.enterGarage and touchMoved~=true then
            delegate.enterGarage()
        end
    end)

    -- 进入战役
    self:OnClick("campaignBtn", function(sender)
        if delegate and delegate.enterChapter and touchMoved~=true then
            delegate.enterChapter()
        end
    end,{["audioType"] = qy.SoundType.CLICK_BATTLE})

    -- 装备
    self:OnClick("equipBtn", function(sender)
        if delegate and delegate.enterEquip and touchMoved~=true then
            delegate.enterEquip(self)
        end
    end)

    -- 合金
    self:OnClick("alloyBtn", function(sender)
        if delegate and delegate.enterAlloy and touchMoved~=true then
            delegate.enterAlloy(self)
        end
    end)

    -- 军团
    self:OnClick("legionBtn", function(sender)
        if delegate and delegate.enterLegion and touchMoved~=true then
            delegate.enterLegion(self)
        end
    end)

    --信箱
    self:OnClick("mailBtn", function(sender)
        if delegate and delegate.enterMail and touchMoved~=true then
            self.emailFlag = false
            delegate.enterMail(self)
        end
    end)

    -- 军团战
    self:OnClick("Btn_LegionWar", function(sender)
        qy.tank.command.LegionCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.LE_WAR)
    end)

    -- 活动-经典战役
    self:OnClick("activityBtn1", function(sender)
        if delegate and delegate.onActivity and touchMoved~=true then
            qy.tank.command.ActivitiesCommand:getList(1 , function( )
                delegate.onActivity()
            end)
        end
    end,{["isScale"] = false})

     -- 运营活动
    self:OnClick("activityBtn2", function(sender)
        if delegate and delegate.enterOperatingActivities and touchMoved~=true then
            qy.tank.command.ActivitiesCommand:getList(2  , function( )
                if #qy.tank.model.OperatingActivitiesModel:getActivityIndex() > 0 then
                    delegate.enterOperatingActivities()
                else
                    qy.hint:show(qy.TextUtil:substitute(20001))
                end
            end)
        end
    end,{["isScale"] = false})

    --左侧 任务
    self:OnClick("taskBtn", function(sender)
        if delegate and delegate.enterTask and touchMoved~=true then
            delegate.enterTask(self)
        end
        -- qy.tank.module.Helper:register("iron_mine")
        -- qy.tank.module.Helper:start("iron_mine",self)
    end)

    --左侧--补给
     self:OnClick("supplyBtn",function(sender)
        if delegate and delegate.enterSupply and touchMoved~=true then
            delegate.enterSupply()
        end
    end)

     --左侧--竞技场
     self:OnClick("arenaBtn",function(sender)
        if delegate and delegate.onArena then
            delegate.onArena()
        end
    end)

      --钻石
    self:OnClick("Image_3",function(sender)
        -- if delegate and delegate.onArena then
        --     delegate.onArena()
        -- end
        qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.RECHARGE)
    end)

    -- 进入指挥部
    self:OnClickForBuilding("commandCenterBtn", function(sender)
        self.commandLight:setVisible(false)
        if delegate and delegate.enterSupply and touchMoved~=true then
            delegate.enterSupply()
        end
        end
        ,{["beganFunc"] = function () self.commandLight:setVisible(true) end,
        ["canceledFunc"] = function () self.commandLight:setVisible(false) end,
        -- ["audioType"] = qy.SoundType.CLICK_BUILDING,
    }
    )

    -- 训练场
    self:OnClickForBuilding("trainingBtn", function(sender)
        self.trainLight:setVisible(false)
        self.trainMask:setVisible(true)
        if delegate and delegate.enterTraining and touchMoved~=true then
            delegate.enterTraining(self)
        end
    end,{["beganFunc"] = function ()
            self.trainLight:setVisible(true)
            self.trainMask:setVisible(false)
        end,
        ["canceledFunc"] = function ()
            self.trainLight:setVisible(false)
            self.trainMask:setVisible(true)
        end,
        -- ["audioType"] = qy.SoundType.CLICK_BUILDING,
    })

    -- 抽卡
    self:OnClickForBuilding("extractionCardBtn", function(sender)
        -- if #qy.tank.model.GarageModel.totalTanks >= 500 then
        --     qy.hint:show(qy.TextUtil:substitute(90308))
        -- else
            self.extractionCardLight:setVisible(false)
            if delegate and delegate.enterExtractionCard and touchMoved~=true then
                delegate.enterExtractionCard(self)
            end
        --end
    end,{["beganFunc"] = function () self.extractionCardLight:setVisible(true) end,
        ["canceledFunc"] = function () self.extractionCardLight:setVisible(false) end,
        -- ["audioType"] = qy.SoundType.CLICK_BUILDING,
    })

    -- 商城
    self:OnClickForBuilding("tankFactoryBtn", function(sender)
        self.factoryLight:setVisible(false)
        self.tankFactoryMask:setVisible(true)
        if delegate and delegate.enterShop and touchMoved~=true then
            delegate.enterShop(self)
        end
    end,{["beganFunc"] = function ()
            self.factoryLight:setVisible(true)
            self.tankFactoryMask:setVisible(false)
    end,
        ["canceledFunc"] = function ()
            self.factoryLight:setVisible(false)
            self.tankFactoryMask:setVisible(true)
        end,
        -- ["audioType"] = qy.SoundType.CLICK_BUILDING,
    })

    -- 科技
    self:OnClickForBuilding("technologyBtn", function(sender)

        self.techLight:setVisible(false)
        if delegate and delegate.enterTechnology and touchMoved~=true then
            qy.Event.dispatch(qy.Event.SERVICE_LOADING_SHOW)
            local playSeq = cc.Sequence:create(cc.DelayTime:create(.1) , cc.CallFunc:create(function()
                    delegate.enterTechnology(self)
            end))
            self:runAction(playSeq)
        end
    end,{["beganFunc"] = function () self.techLight:setVisible(true) end,
        ["canceledFunc"] = function () self.techLight:setVisible(false) end,
        -- ["audioType"] = qy.SoundType.CLICK_BUILDING,
    })

    -- 矿区
    self:OnClickForBuilding("mineBtn", function(sender)
        self.mineLight:setVisible(false)
        if delegate and delegate.enterMine and touchMoved~=true then
            delegate.enterMine(self)
        end
    end,{["beganFunc"] = function () self.mineLight:setVisible(true) end,
        ["canceledFunc"] = function () self.mineLight:setVisible(false) end,
        -- ["audioType"] = qy.SoundType.CLICK_BUILDING,
    })

    -- VIP
    self:OnClick("vipBtn",function(sender)
        if delegate and delegate.vip and touchMoved~=true then
            delegate.vip(self)
        end
    end)

    self:OnClick("vipAwardBtn",function(sender)
        if delegate and delegate.vipAward and touchMoved~=true then
            delegate.vipAward(self)
        end
    end)

    -- 大锅饭
    self:OnClick("potBtn",function(sender)
        if delegate and delegate.enterPot and touchMoved~=true then
            delegate.enterPot(self)
        end
    end)

    -- 伞兵入侵
    self:OnClick("invadeBtn",function(sender)

        if delegate and delegate.enterInvade and touchMoved~=true then
            delegate.enterInvade()
        end
    end)

    self:OnClick("settingBtn",function(sender)
        if delegate and delegate.enterSet and touchMoved~=true then
            delegate.enterSet(self)
        end
    end)

    self:OnClick("guideBattleBtn",function(sender)
        qy.tank.service.BattleService:new():getGuideBattle(function()
            -- qy.tank.manager.ScenesManager:pushScene(qy.tank.view.scene.BattleScene.new())
            qy.tank.manager.ScenesManager:pushBattleScene()
        end)
    end)

    -- 图鉴、成就
    self:OnClick("Btn_Achievement",function(sender)
        delegate.showAchievement()

        -- qy.tank.command.ActivitiesCommand:showActivity(qy.tank.view.type.ModuleType.RECHARGE_DOYEN)
    end)

    -- 军魂
    self:OnClick("soulBtn",function(sender)
        -- delegate.showAchievement()
            qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.SOUL)
    end)

    -- 乘员系统
    self:OnClick("passengerBtn",function(sender)
        local passenger = {["idx1"] = 1, ["idx2"] = 1}
        qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.PASSENGER, passenger)
    end)
     -- 军衔系统
    self:OnClick("Btn_Rank",function(sender)
        qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.MILITARY_RANK)
    end)
        -- 勋章系统
    self:OnClick("Btn_Medal",function(sender)
        qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.MEDAL)
    end)
    -- 配件系统
    self:OnClick("Btn_Fittings",function(sender)
        qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.FITTINGS)
    end)

    -- 分解
    self:OnClick("Btn_Resolve",function(sender)
        delegate.showResolve()
    end)

    -- 充值
    self:OnClick("chargeBtn", function(sender)
        if qy.isAudit and qy.product == "sina" then
            -- 因为审核要屏蔽 VIP 所以屏蔽状态下直接跳到充值界面
            qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.RECHARGE)
        else
            -- 正常状态下，点击充值按钮先跳到vip特权
            qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.VIP)
        end

    end)

     -- 跨服玩法
    -- self:OnClick("cross_service_btn", function(sender)
    --     -- qy.tank.module.Helper:register("help")
    --     -- qy.tank.module.Helper:start("help", qy.App.runningScene.dialogStack)
    --     qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.GREATEST_RACE)
    -- end)
    self:OnClick("cross_service_btn", function(sender)
        if delegate and delegate.enterServiceActivities and touchMoved~=true then
            qy.tank.command.ActivitiesCommand:getList(4  , function( )
                if #qy.tank.model.OperatingActivitiesModel:getServiceActivityIndex() > 0 then
                    delegate.enterServiceActivities()
                else
                    qy.hint:show(qy.TextUtil:substitute(90312))
                end
            end)
        end
    end,{["isScale"] = false})


    self:OnClick("help_btn", function(sender)
        qy.tank.module.Helper:register("help")
        qy.tank.module.Helper:start("help", qy.App.runningScene.dialogStack)
    end)

    if self.model.userInfoEntity.level >= 28 then
        self.cross_service_btn:setVisible(true)
        self.help_btn:setVisible(false)
    else
        self.cross_service_btn:setVisible(false)
        self.help_btn:setVisible(true)
    end
    self:OnClick("Tank918Bt",function (  )
         qy.tank.command.ActivitiesCommand:showActivity(qy.tank.view.type.ModuleType.TANK_918)
    end)
    self:OnClick("TimeLimitBtn", function(sender)
        if delegate and delegate.enterTimeLimitActivities and touchMoved~=true then
            qy.tank.command.ActivitiesCommand:getList(3  , function()
                if #qy.tank.model.OperatingActivitiesModel:getTimeLimitActivityIndex() > 0 then
                    delegate.enterTimeLimitActivities()
                else
                    qy.hint:show(qy.TextUtil:substitute(90313))
                end
            end)
        end
    end,{["isScale"] = false})

    if qy.tank.model.OperatingActivitiesModel:getTimeLimitActivityNun() > 0 then
        self.TimeLimitBtn:setVisible(true)
    else
        self.TimeLimitBtn:setVisible(false)
    end



    --
    -- self:OnClick("Btn_funcitons",function(sender)
    --     self:changeFunctionsStatus()
    -- end)

    --  self:OnClick("Functions",function(sender)
    --     self:changeFunctionsStatus()
    -- end)

    -- 消息
    for i = 1, 6 do
        self:OnClick("Message" .. i,function(node, sender)
            if delegate and delegate.showMessage  then
                if i == 6 then
                   delegate.showMessage1(sender.mType)--阵营战跟之前的不一样，不弹详细面板直接进功能
                else
                    delegate.showMessage(sender.mType)
                end
            end
        end)

        self["Message" .. i]:setVisible(false)
        self["Message" .. i].mType = i
    end

    local award = {["type"] = 14, ["num"] = 1, ["id"] = 1}
    local _data = {award}
    self:OnClick("addEnergyBtn", function(sender)
        qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.BUY_OR_USE,_data)
    end)

    self.Btn_Achievement:setVisible(qy.tank.model.AchievementModel:testPicOpen())

    -- self.vipNum = ccui.TextAtlas:create()
    -- self.vipNum:setProperty("1", "font/num/num_19.png", 20, 18, "0")
    -- self.vipNum:setPosition(68, 26)
    -- self.vipNum:setAnchorPoint(0, 0.5)
    -- self.vipBtn:addChild(self.vipNum)
end

-- function MainView:HideAnimationInit( )
--     self.isRuning = false
--     self:OnClick("hideBtn",function(sender)
--         if self.isRuning == true then return end
--         -- self.isRuning  = true
--         function hidAnimationRun( item , direct , time ,  angleNum , scale , isEnd)
--             qy.QYPlaySound.playEffect(qy.SoundType.OPEN_MENU)
--             local rotate = cc.RotateBy:create(time,direct* angleNum) -- 旋转
--             local scale = cc.ScaleTo:create(time,scale) -- 匀速
--             local spawn = cc.Spawn:create(rotate,scale)
--             local seq = cc.Speed:create(cc.Sequence:create(spawn , cc.CallFunc:create(function()
--                 if isEnd==true then
--                     self.isRuning = false
--                     -- self.bottomModules:setVisible(not self.isHide)
--                     -- self.leftModules:setVisible(not self.isHide)
--                     -- self.topModules:setVisible(not self.isHide)
--                 end
--           end)) ,1)
--           item:runAction(seq)
--         end

--         if self.isHide == nil or self.isHide == false then
--             self.direct = -1
--             self.scale = 1
--             self.isIn = false
--             self.isHide = true
--             --qy.QYPlaySound.playEffect(qy.SoundType.CLOSE_MENU)
--             print("qy.QYPlaySound.playEffect(qy.SoundType.CLOSE_MENU)")
--         else
--             self.direct = 1
--             self.scale = 1
--             self.isIn = true
--             self.isHide = false
--             --qy.QYPlaySound.playEffect(qy.SoundType.OPEN_MENU)
--             print("qy.QYPlaySound.playEffect(qy.SoundType.OPEN_MENU)")
--         end

--         function showAndHidAnnimation(item1 , time)
--             qy.QYPlaySound.playEffect(qy.SoundType.OPEN_MENU)
--             local fade = self.isIn==true and cc.FadeIn:create(time) or  cc.FadeOut:create(time)

--             local seq1 = cc.Speed:create(cc.Sequence:create(fade , cc.CallFunc:create(function()

--           end)) ,1)
--           item1:runAction(seq1)
--         end

--         hidAnimationRun(self.hideBig , self.direct , 0.8 , 180 , 1 , true)
--         hidAnimationRun(self.hideBtn , -1*self.direct , 0.3 , 180 , self.scale , false)
--         hidAnimationRun(self.hideLight , -1*self.direct , 1 , 360 ,  self.scale , false)

--         showAndHidAnnimation(self.bottomModules , 0.3)
--         showAndHidAnnimation(self.leftModules, 0.3)
--         showAndHidAnnimation(self.topModules, 0.3)
--         showAndHidAnnimation(self.chatWidget, 0.3)
--         self.bottomModules:setVisible(not self.isHide)
--         self.leftModules:setVisible(not self.isHide)
--         self.topModules:setVisible(not self.isHide)
--         self.chatWidget:setVisible(not self.isHide)
--     end,
--     {["hasAudio"] = false}
--     -- {["audioType"] = qy.SoundType.CLOSE_MENU}
--     )
-- end

-- 展示/隐藏
function MainView:hideAction()
    self.isHide = not self.isHide
    local pic = self.isHide and "zhankai" or "shouna"
    cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/main_city/main_city.plist")
    self.HidePic:loadTexture("Resources/main_city/" .. pic .. ".png", ccui.TextureResType.plistType)

    function showAndHidAnnimation(item1 , time)
        qy.QYPlaySound.playEffect(qy.SoundType.OPEN_MENU)
        local fade = self.isHide == false and cc.FadeIn:create(time) or  cc.FadeOut:create(time)

        local seq1 = cc.Speed:create(cc.Sequence:create(fade , cc.CallFunc:create(function()
        end)) ,1)
        item1:runAction(seq1)
    end

    showAndHidAnnimation(self.leftModules, 0.3)
    showAndHidAnnimation(self.topModules, 0.3)
    showAndHidAnnimation(self.chatWidget, 0.3)
    showAndHidAnnimation(self.Right, 0.3)
    showAndHidAnnimation(self.bottomModules , 0.3)

    local y = self.isHide and -120 or 120
    self.bottomModules:runAction(cc.MoveBy:create(0.3, cc.p(0, y)))

    local x = self.isHide and 360 or -360
    self.Right:runAction(cc.MoveBy:create(0.3, cc.p(x, 0)))
    -- self.bottomModules:setVisible(not self.isHide)
    self.leftModules:setVisible(not self.isHide)
    self.topModules:setVisible(not self.isHide)
    self.chatWidget:setVisible(not self.isHide)

    if self.clip then
        self.clip:runAction(cc.MoveBy:create(0.3, cc.p(0, y)))
    end

    if self.sprite1 then
        self.sprite1:runAction(cc.MoveBy:create(0.3, cc.p(0, y)))
    end
end

--更新所有用户数据
function MainView:updateAllUserData()
    if self.model.userInfoEntity==nil then
        return
    end
    self:updateBaseInfo()
    self:updateResource()
    self:updateRecharge()
end
function MainView:updatetank918bt(  )
    local status = qy.tank.model.Tank918Model.activittstatus
    self.Tank918Bt:setVisible(status == 1)
end

--用户基础数据更新
function MainView:updateBaseInfo()
    self.nameTxt:setString(self.model.userInfoEntity.name)
    self.lvTxt:setString("Lv. "..self.model.userInfoEntity.level)

    if self.fightPower == nil then
        self.fightPower = qy.tank.view.common.FightPower.new()
        self.userMesg:addChild(self.fightPower)
        self.fightPower:setPosition(190 , -75)
    end
    self.fightPower:update()
    --更新指挥官经验
    self:__updateUserExpData()
    --更新功能开启
    self:checkOpenHelp()
    self.headImg:setTexture(self.model:getRoleIcon())
end

--用户资源数据更新
function MainView:updateResource()
    self:showUpdateResourceAmin()
    self.silverTxt:setString(self.model.userInfoEntity:getSilverStr())
    self.energyTxt:setString(self.model.userInfoEntity:getEnergyStr() .. "/" .. self.model:getEnergyLimitByVipLevel())
end

--[[--
--显示资源更新动画
--]]
function MainView:showUpdateResourceAmin()
    local addResource = self.model:getAddResourceType()
    for i = 1, #addResource do
        if addResource[i] == qy.tank.view.type.ResourceType.SILVER then
            qy.tank.utils.NumberUtil.numRefreshAnim(self.silverTxt, 1)
        elseif addResource[i] == qy.tank.view.type.ResourceType.ENERGY then
            qy.tank.utils.NumberUtil.numRefreshAnim(self.energyTxt, 1)
        elseif addResource[i] == qy.tank.view.type.ResourceType.DIAMOND then
            qy.tank.utils.NumberUtil.numRefreshAnim(self.diamondTxt, 1)
        end
    end

    local subResource = self.model:getSubtractResourceType()
    for i = 1, #subResource do
        if subResource[i] == qy.tank.view.type.ResourceType.SILVER then
            qy.tank.utils.NumberUtil.numRefreshAnim(self.silverTxt, 2)
        elseif subResource[i] == qy.tank.view.type.ResourceType.ENERGY then
            qy.tank.utils.NumberUtil.numRefreshAnim(self.energyTxt, 2)
        elseif subResource[i] == qy.tank.view.type.ResourceType.DIAMOND then
            qy.tank.utils.NumberUtil.numRefreshAnim(self.diamondTxt, 2)
        end
    end
end

--用户充值数据更新
function MainView:updateRecharge()
    -- self.vipNum:setString(self.model.userInfoEntity.vipLevel)
    cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/main_city/vip/main_vip_icon.plist")
    local vip_url = "Resources/main_city/vip/v" .. self.model.userInfoEntity.vipLevel..".png"
    print(vip_url)
    if cc.SpriteFrameCache:getInstance():getSpriteFrame(vip_url) then
        self.vipBtn:loadTexture(vip_url,1)
    else
        self.vipBtn:loadTexture("Resources/common/bg/c_11.png")
    end
    self.diamondTxt:setString(self.model.userInfoEntity:getDiamondStr())
end

function MainView:__taskTipsAmin()
    if self.taskTips:getNumberOfRunningActions() == 0 then
        local x = 39.4
        self.taskTips:setPosition(x, 14)
        local move1 = cc.MoveTo:create(0.2,cc.p(x, 40))
        local move2 = cc.MoveTo:create(0.2,cc.p(x, 14))
        local callFunc = cc.CallFunc:create(function ()
            self.taskTips:setPosition(x, -15)
            self.taskTips:setString(self.taskModel:getNextTips())
        end)
        local delay1 = cc.DelayTime:create(15)
        local delay2 = cc.DelayTime:create(15)
        local seq = cc.Sequence:create(delay1, move1, callFunc,move2,delay2)
        self.taskTips:runAction(cc.RepeatForever:create(seq))
    end
end

function MainView:__stopTaskTipAnim()
    self.taskTips:stopAllActions()
    self.taskTips:setPosition(39.4, 14)
end

--任务
function MainView:__updateTaskData()
    self.taskTips:stopAllActions()
    if self.taskModel:getTaskNum() > 0 then
        self.taskTips:setString(self.taskModel:getNextTips(1))
        self:__taskTipsAmin()
    end
end

function MainView:__updateSupplyData()
    local model = qy.tank.model.SupplyModel
    self.supplyTips:setString(model:getMainViewSupplyTxt())
    -- if model:getRemainSupplyNum() > 0 then
    --     --如果还有补给次数
    --     self.supplyTips:setString(model:getSupplyTxt())
    --     -- self.supply_bg:setVisible(true)
    -- else
    --     --没有补给次数
    --     -- self.supply_bg:setVisible(false)
    -- end
end

function MainView:__updateArenaData()
    local _needLevel = qy.tank.model.FunctionOpenModel:getLevelOfOpenArena()
    if self.model.userInfoEntity.level < _needLevel then
        self.arena:setVisible(false)
    else
        self.arena:setVisible(true)
        local rank = qy.tank.model.ArenaModel.rank
        rank = rank > 0 and rank or 20000 .. "+"

        self.arenaTips:setString(qy.TextUtil:substitute(50011) .. rank .. qy.TextUtil:substitute(50012))
    end
end

function MainView:__updateUserExpData()
    local _percent = self.model:getUserExpPercent()
    local w = 180 * _percent / 100
    self.userExpBar:setPercent(_percent)
    -- self.expLight:setPosition(0 + w, 6.5)
    self.userExpPercent:setString(_percent .. "%")
end

--[[--
--更新左边模块数据
--]]
function MainView:updateLeftModuleData()
    --更新任务数据
    self:__updateTaskData()
    --更新补给数据
    self:__updateSupplyData()
    --更新竞技场数据
    self:__updateArenaData()
end

function MainView:__updateCityPosByGuide()
    print("MainView:__updateCityScrollViewPos()")
    if qy.isTriggerGuide then
        if self.model.userInfoEntity.level == qy.GuideModel:getOpenLevelByName("mine_view") then
            --矿区开启，回到主城设置偏移量
            self.cityScrollView:jumpToRight()
        end
    end

    if qy.isNoviceGuide then
        --训练场
        self.cityScrollView:jumpToRight()
    end

end

-- 显示首冲动画
function MainView:showFirstPayAction()
    if self.model.userInfoEntity.level == 5 or self.model.userInfoEntity.level == 9 or self.model.userInfoEntity.level == 12 then
        self.actIcons:showFirstPayAction()
    end
end

function MainView:onEnter()

    if qy.isNoviceGuide then
        self.TopBg:setVisible(false)
    else
        self:changeTopBg()
    end
    qy.QYPlaySound.playMusic(qy.SoundType.M_W_BG_MS)
    qy.tank.model.UserInfoModel:clearUpdateResourceType()
    self:__taskTipsAmin()
    if self.listener == nil then
        self.listener = cc.EventListenerTouchOneByOne:create()
        self.listener:setSwallowTouches(false)
        self.listener:registerScriptHandler(self.onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
        self.listener:registerScriptHandler(self.onTouchMoved, cc.Handler.EVENT_TOUCH_MOVED)
        self:getEventDispatcher():addEventListenerWithFixedPriority(self.listener, -1)
    end
    --用户基础数据更新
    self.userBaseInfoDatalistener = qy.Event.add(qy.Event.USER_BASE_INFO_DATA_UPDATE,function(event)
        self:updateBaseInfo()
    end)

    --用户资源数据更新
    self.userResourceDatalistener = qy.Event.add(qy.Event.USER_RESOURCE_DATA_UPDATE,function(event)
        self:updateResource()
    end)
    --用户充值数据更新
    self.userRechargeDatalistener = qy.Event.add(qy.Event.USER_RECHARGE_DATA_UPDATE,function(event)
        self:updateRecharge()
    end)
     --更新任务提示
    self.taskRewardDatalistener = qy.Event.add(qy.Event.TASK_REWARD_UPDATE,function(event)
        self:__updateTaskData()
    end)

    --补给次数
    self.supplyDatalistener = qy.Event.add(qy.Event.SUPPLY_NUM_UPDATE,function(event)

        self:__updateSupplyData()
    end)

     --活动刷新
    self.activityListener = qy.Event.add(qy.Event.ACTIVITY_REFRESH,function(event)
        -- if not qy.isNoviceGuide then
            self.actIcons:update()
            self:changeTopBg()
            self:showFirstPayAction()
        -- end
    end)

    --活动刷新
    self.messageListener = qy.Event.add(qy.Event.MESSAGE_UPDATE,function(event)
        local mType = event._usedata.mType
        local flag = event._usedata.flag
        local messages = event._usedata.messages

        self:showMessageButton(mType, flag)
        if messages then
            self:updateMessagePosition(messages)
        end
    end)

    --竞技场刷新
    self.arenaRankListener = qy.Event.add(qy.Event.ARENA_RANK_UPDATE,function(event)
        self:__updateArenaData()
    end)

    --邮件刷新
    self.mailListener = qy.Event.add(qy.Event.MAIL_NEW,function(event)
        self.emailFlag = true
        -- self:showEmailAction()
    end)

    --邮件刷新
    self.racingListener = qy.Event.add(qy.Event.RACING_TIME,function(event)
        self.actIcons:showRacingTime()
    end)
     --邮件tank918
    self.racingListener = qy.Event.add(qy.Event.TANK918,function(event)
        self:updatetank918bt()
    end)

    self:updateAllUserData()
    self:addRedDotSignal()
    self:updateLeftModuleData()

    -- if self.man ~=nil then
    --     self.man:play()
    -- end
    --触发式引导 & 新手引导
    self:__updateCityPosByGuide()

    for i, v in pairs(qy.tank.model.RedDotModel.messages) do
        self:showMessageButton(v, true)
        self:updateMessagePosition(qy.tank.model.RedDotModel.messages)
        -- qy.Event.dispatch(qy.Event.MESSAGE_UPDATE, {["mType"] = v, ["flag"] = true, ["messages"] = qy.tank.model.RedDotModel.messages})
    end

    -- qy.tank.command.BattleCommand:removeResources()

    self:showCampainActions()

    for i = 1, 5 do
        self:playMessageAnimation(self["Message" .. i])
    end

    if self.emailFlag then
        -- self:showEmailAction()
    end

    self:showFirstPayAction()
    self:showBattleRoomAction()
    self:showActivityAction()

    self:checkWorldBossNotice()

    self:checkLegionBossNotice()

    self:setCityViewMoved()

    if qy.tank.model.LegionWarModel:isNeedGuide() then
        self.Btn_LegionWar:setVisible(true)
        self:showLegionSignActions(true)
    else
        self.Btn_LegionWar:setVisible(false)
        self:showLegionSignActions(false)
    end

    self:checkOpenHelp()

    self:dealAuditLogic()

     -- --跨服战福利弹框
    if qy.language == "cn" then
        if self.model.userInfoEntity.level >= 40 then
            local award = smodel:getAllAwardsList()
            if #award ~= 0 then
                require("view/service_war/Welfare").new(award):show(true)
            end

        end
    end
end

-- 检测功能开启按钮
function MainView:checkOpenHelp()
    if self.model.userInfoEntity.level > 4 and self.model.userInfoEntity.level < 70 then
        self.openBtn:setVisible(true)
        local OpenModel = qy.tank.model.OpenModel
        local array = OpenModel:getOpenArray(self.model.userInfoEntity.level)
        cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/open/open.plist")
        cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/activity/activity.plist")
        self.open_name:setString(array[1].note)
        -- self.openBtn1
        local func1 = cc.FadeTo:create(1.7, 0)
        local func2 = cc.FadeTo:create(1.5, 255)
        local func3 = cc.DelayTime:create(1)
        local func4 = cc.DelayTime:create(0.5)

        self.openBtn1:runAction(cc.RepeatForever:create(cc.Sequence:create(func4,func3,func2,func4,func1)))
        -- self.levelLabel:setString(array[1].open_level)
        string.len(array[1].open_level)
        if string.len(array[1].open_level) == 3 then
            self["level"..3]:setSpriteFrame("Resources/activity/s".. string.sub(array[1].open_level, 1, 1) ..".png")
            self["level"..2]:setSpriteFrame("Resources/activity/s".. string.sub(array[1].open_level, 2, -2) ..".png")
            self["level"..1]:setSpriteFrame("Resources/activity/s".. string.sub(array[1].open_level, 3, -1) ..".png")
        elseif string.len(array[1].open_level) == 2 then
            self["level"..3]:setVisible(false)
            self["level"..2]:setSpriteFrame("Resources/activity/s".. string.sub(array[1].open_level, 1, 1) ..".png")
            self["level"..1]:setSpriteFrame("Resources/activity/s".. string.sub(array[1].open_level, 2, -1) ..".png")
        elseif string.len(array[1].open_level) == 1 then
            self["level"..3]:setVisible(false)
            self["level"..2]:setVisible(false)
            self["level"..1]:setSpriteFrame("Resources/activity/s".. string.sub(array[1].open_level, 1, -1) ..".png")
        end

        for i=1,3 do
            self["level"..i]:setVisible(false)
        end
        for i=1,string.len(array[1].open_level) do
            self["level"..i]:setVisible(true)
        end
    else
        self.openBtn:setVisible(false)
    end
end

--处理AppStore 审核隐藏
function MainView:dealAuditLogic()
    if qy.isAudit and qy.product == "sina" then
        self.vipBtn:setVisible(false)
        -- self.chargeBtn:setVisible(false)
        self.activityBtn2:setVisible(false)
        self.cross_service_btn:setVisible(false)
        self.task:setVisible(false)
        self.TopBg:setVisible(false)
        self.legionBtn:setVisible(false)
        self.mailBtn:setVisible(false)
    end
end

function MainView:setCityViewMoved()
    --新手引导和触发引导，主城不能移动
    if qy.isNoviceGuide or qy.isTriggerGuide then--||||||
        print("=======================================>>>>>>>>>>>>>>>>>>>>>>>>>触发式引导期间：不能移动主城")
        self.cityScrollView:setTouchEnabled(false)
    else
        print("=======================================>>>>>>>>>>>>>>>>>>>>>>>>>不是触发式引导期间：可以移动主城")
        self.cityScrollView:setTouchEnabled(true)
    end
end

function MainView:checkWorldBossNotice()
    -- boss是否阵亡
    local isOpen = false
    local serverTime = self.model.serverTime
    local model = qy.tank.model.WorldBossModel
    for i=1,#model.time do
        if serverTime >= model.time[i].start and serverTime <= model.time[i]["end"] then
            isOpen = true
            if cc.UserDefault:getInstance():getIntegerForKey("tank_boss_time") ~= model.time[i].start then
                cc.UserDefault:getInstance():setIntegerForKey("tank_boss_time",model.time[i].start)
                cc.UserDefault:getInstance():setBoolForKey("tank_boss_guide",true)
            end
            break
        end
    end

    if model.boss_is_guide == 1 and isOpen and cc.UserDefault:getInstance():getBoolForKey("tank_boss_guide") then
    -- if model.boss_is_guide == 1 and isOpen then
        local dialog = qy.tank.view.main.WorldBossNoticeDialog.new({
            ["title"] = "Resources/common/title/sjboss0001.png",
            ["description"] = qy.TextUtil:substitute(20002),
            ["award"] = qy.TextUtil:substitute(20003),
            ["callback"] = function()
                qy.tank.command.ActivitiesCommand:showActivity("boss")
            end
        })
        dialog:show()
        cc.UserDefault:getInstance():setBoolForKey("tank_boss_guide",false)
    end

    -- cc.UserDefault:getInstance():setBoolForKey("tank_boss_guide",true)
end

function MainView:checkLegionBossNotice()
    -- boss是否阵亡
    local isOpen = false
    local serverTime = self.model.serverTime
    local model = qy.tank.model.LegionBossModel
    for i=1,#model.time do
        if serverTime >= model.time[i].start and serverTime <= model.time[i]["end"] then
            isOpen = true
            if cc.UserDefault:getInstance():getIntegerForKey("legion_boss_time") ~= model.time[i].start then
                cc.UserDefault:getInstance():setIntegerForKey("legion_boss_time",model.time[i].start)
                cc.UserDefault:getInstance():setBoolForKey("legion_boss_guide",true)
            end
            break
        end
    end

    if model.boss_is_guide == 1 and isOpen and cc.UserDefault:getInstance():getBoolForKey("legion_boss_guide") then
    -- if model.boss_is_guide == 1 and isOpen then
        local dialog = qy.tank.view.main.WorldBossNoticeDialog.new({
            ["title"] = "Resources/common/title/jtboss_01.png",
            ["description"] = qy.TextUtil:substitute(20004),
            ["award"] = qy.TextUtil:substitute(20005),
            ["callback"] = function()
                qy.tank.command.ActivitiesCommand:showActivity("legion_boss")
            end
        })
        dialog:show()
        cc.UserDefault:getInstance():setBoolForKey("legion_boss_guide",false)
    end

    -- cc.UserDefault:getInstance():setBoolForKey("tank_boss_guide",true)
end



function MainView:onExit()
    self:removeRedDotSignal()
    -- self:getEventDispatcher():removeEventListener(self.listener)
    qy.Event.remove(self.userBaseInfoDatalistener)
    qy.Event.remove(self.userResourceDatalistener)
    qy.Event.remove(self.userRechargeDatalistener)
    qy.Event.remove(self.taskRewardDatalistener)
    qy.Event.remove(self.supplyDatalistener)
    qy.Event.remove(self.messageListener)
    qy.Event.remove(self.arenaRankListener)
    qy.Event.remove(self.triggerGuideListener)
    qy.Event.remove(self.mailListener)
    qy.Event.remove(self.activityListener)
    qy.Event.remove(self.racingListener)

    -- self.listener = nil
    -- self.userBaseInfoDatalistener = nil
    -- self.userResourceDatalistener = nil
    -- self.userRechargeDatalistener = nil
    -- self.taskRewardDatalistener = nil
    -- self.supplyDatalistener = nil
    -- self.activityListener = nil
    -- self.triggerGuideListener = nil

    --移除控件的动画
    self:removeUiAmin()
    self:__stopTaskTipAnim()
    display.removeSpriteFrames("Resources/main_city/action.plist","Resources/main_city/action.jpg")
    -- cc.Director:getInstance():getTextureCache():removeAllTextures()
end

--[--
--添加红点信息
--]
function MainView:addRedDotSignal()
    qy.RedDotCommand:addSignal({
        [qy.RedDotType.M_TASK] = self.taskBtn,
        [qy.RedDotType.M_MAIL] = self.mailBtn,
        [qy.RedDotType.M_TECH] = self.technologyBtn,
        [qy.RedDotType.M_SUPPLY] = self.commandCenterBtn,
        [qy.RedDotType.M_TANK_FAC] = self.tankFactoryBtn,
        [qy.RedDotType.M_EX_CARD] = self.extractionCardBtn,
        [qy.RedDotType.M_TRAIN] = self.trainingBtn,
        [qy.RedDotType.M_MINE] = self.mineBtn,
        [qy.RedDotType.M_OP_ACTIVI] = self.huodong_img,
        [qy.RedDotType.M_EQUIP] = self.equipBtn,
        [qy.RedDotType.M_EMBAT] = self.embattleBtn,
        [qy.RedDotType.M_STOR] = self.storageBtn,
        [qy.RedDotType.M_GARAGE] = self.garageBtn,
        [qy.RedDotType.M_CAMPA] = self.campaignBtn,
        [qy.RedDotType.M_BATTLE_R] = self.activityBtn1,
        [qy.RedDotType.M_LEGION] = self.legionBtn,
        [qy.RedDotType.M_PASSENGER] = self.passengerBtn,
        [qy.RedDotType.M_CROSS_SER] = self.cross_service_icon,
        [qy.RedDotType.M_SER] = self.cross_service_btn,
        [qy.RedDotType.M_TIME_LIMIT] = self.TimeLimitBtn,
    })
    print("=RedDotType========================")
    qy.RedDotCommand:initMainViewRedDot()
    
end

--[--
--移除红点信息
--]
function MainView:removeRedDotSignal()
    qy.RedDotCommand:removeSignal({
        -- RedDotType.M_TASK,
        qy.RedDotType.M_MAIL,qy.RedDotType.M_TECH,qy.RedDotType.M_SUPPLY,qy.RedDotType.M_TANK_FAC,qy.RedDotType.M_EX_CARD,qy.RedDotType.M_TRAIN,qy.RedDotType.M_LEGION,qy.RedDotType.M_CROSS_SER,qy.RedDotType.M_SER,qy.RedDotType.M_TIME_LIMIT,
        qy.RedDotType.M_MINE,qy.RedDotType.M_OP_ACTIVI,qy.RedDotType.M_BATTLE_R,qy.RedDotType.M_EQUIP,qy.RedDotType.M_STOR,qy.RedDotType.M_EMBAT,qy.RedDotType.M_GARAGE,qy.RedDotType.M_CAMPA,qy.RedDotType.M_PASSENGER,
    })
end

-- 显示或隐藏各种消息图标
function MainView:showMessageButton(mType, flag)
    self["Message" .. mType]:setVisible(flag)

    if flag then
        self:playMessageAnimation(self["Message" .. mType])
    end
end

function MainView:updateMessagePosition(messages)
    local display = cc.Director:getInstance():getWinSize()
    for i, v in pairs(messages) do
        self["Message" .. v]:setPositionX(display.width / 2 - (#messages / 2 - i + 1 / 2) * 120)
    end
end

function MainView:playMessageAnimation(node)
    if node:getNumberOfRunningActions() == 0 then
        local func1 = cc.FadeTo:create(1, 210)
        local func2 = cc.FadeTo:create(1, 255)
        local func3 = cc.ScaleTo:create(1, 1.2)
        local func4 = cc.ScaleTo:create(1, 1)
        local func5 = cc.DelayTime:create(0.5)

        node:runAction(cc.RepeatForever:create(cc.Sequence:create(func1, func2, func5)))
        node:runAction(cc.RepeatForever:create(cc.Sequence:create(func4, func3, func5)))
    end
end

-- -- 功能区
-- function MainView:changeFunctionsStatus()
--     self.FunctionsStatus = not self.FunctionsStatus
--     self.Fun_bg:setVisible(self.FunctionsStatus)
--     self.Btn_Achievement:setVisible(self.FunctionsStatus)
--     self.Btn_Resolve:setVisible(self.FunctionsStatus)
--     -- self.Btn_Resolve:setVisible(self.FunctionsStatus and qy.tank.model.ResolveModel:testOpen())
--     self.Btn_funcitons:setFlippedX(not self.FunctionsStatus)

--     -- self.Fun_bg:setContentSize(self.Btn_Resolve:isVisible() and 235 or 120, 43)
-- end

--军团报名
function MainView:showLegionSignActions(_isShow)
    if self.legionSignAction then
        return
    end
    if _isShow then
        display.loadSpriteFrames("Resources/main_city/legion_sign/legion_sign.plist","Resources/main_city/legion_sign/legion_sign.jpg")
        local frames = display.newFrames("Resources/main_city/legion_sign/legion_%d.png",1,22)
        local animation = display.newAnimation(frames,0.1)     --0.5s里面播放2帧
        self.legionSignAction = self.legion_sign_action:playAnimationForever(animation)
    else
        if self.legionSignAction then
            self.legionSignAction = nil
        end
    end
end

function MainView:showCampainActions()
    if self.campainAction and self.model.userInfoEntity.level < 10 then
        return
    end
    if self.model.userInfoEntity.level < 10 then
        display.loadSpriteFrames("Resources/main_city/action.plist","Resources/main_city/action.jpg")

        local position = self.campaignBtn:getParent():convertToWorldSpace(cc.p(self.campaignBtn:getPositionX(),self.campaignBtn:getPositionY()))
        if not self.sprite1 then
            self.sprite1 = cc.Sprite:createWithSpriteFrameName("Resources/main_city/a1.jpg")
            self.sprite1:setPosition(position.x, position.y)
        end
        local frames = display.newFrames("Resources/main_city/a%d.jpg",1,13)
        local animation = display.newAnimation(frames,0.125)     --0.5s里面播放2帧
        self.campainAction = self.sprite1:playAnimationForever(animation)
        if not self.clip then
            local sprite = cc.Sprite:createWithSpriteFrameName("Resources/main_city/q.png")
            self.clip = cc.ClippingNode:create()
            self.clip:setInverted(false)
            self.clip:setAlphaThreshold(0)
            self:addChild(self.clip)
            self.clip:addChild(self.sprite1)
            sprite:setPosition(self.sprite1:getPositionX(), self.sprite1:getPositionY())

            -- sprite:setPosition(500, 400)
            -- self:addChild(sprite)
            self.clip:setStencil(sprite)

        end
    else
        if self.clip then
            self.clip:removeSelf()
            self.clip = nil
        end

        if self.sprite1 then
            self.sprite1 = nil
        end

        if self.campainAction then
            self.campainAction = nil
        end
    end
end

-- 作战室动画
function MainView:showBattleRoomAction()
    if (self.battleRoomWriteLine and self.battleRoomWriteLine:getNumberOfRunningActions() > 0) and (self.model.userInfoEntity.level >= 20 and self.model.userInfoEntity.level <= 35) then
        return
    end
    if self.model.userInfoEntity.level >= 20 and self.model.userInfoEntity.level <= 35 then
        local position = self.activityBtn1:getParent():convertToWorldSpace(cc.p(self.activityBtn1:getPositionX(),self.activityBtn1:getPositionY()))
        if not self.sprite2 then
            self.sprite2 = cc.Sprite:createWithSpriteFrameName("Resources/main_city/10.png")
            self.sprite2:setPosition(position.x , position.y)

            local sprite = cc.Sprite:createWithSpriteFrameName("Resources/common/txt/zuozhanshi.png")
            sprite:setPosition(100, 65)
            self.sprite2:addChild(sprite)
            -- self:addChild(self.sprite2)
        end

        if not self.battleRoomWriteLine then
            self.battleRoomWriteLine = cc.Sprite:createWithSpriteFrameName("Resources/main_city/q2.png")
            self.sprite2:addChild(self.battleRoomWriteLine)
            self.battleRoomWriteLine:setPositionY(40)
        end

        local func2 = cc.CallFunc:create(function()
            self.battleRoomWriteLine:setPositionX(-10)
        end)
        local func1 = cc.MoveTo:create(1, cc.p(200, 40))
        local func4 = cc.DelayTime:create(5)
        local seq = cc.Sequence:create(func1, func2, func4)
        local func3 = cc.RepeatForever:create(seq)
        self.battleRoomWriteLine:runAction(func3)

        if not self.clip1 then
            cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/main_city/main_city.plist")
            local sprite = cc.Sprite:createWithSpriteFrameName("Resources/main_city/q1.png")
            self.clip1 = cc.ClippingNode:create()
            self.clip1:setInverted(false)
            self.clip1:setAlphaThreshold(100)
            self:addChild(self.clip1)
            self.clip1:addChild(self.sprite2)
            sprite:setPosition(self.sprite2:getPositionX(), self.sprite2:getPositionY() + 10)

            self.clip1:setStencil(sprite)
        end
    else
        if self.clip1 then
            self.clip1:removeSelf()
            self.clip1 = nil
        end

        if self.battleRoomWriteLine then
            self.battleRoomWriteLine = nil
        end
    end
end

-- 显示活动动画
function MainView:showActivityAction()
    -- AppStore审核时，要屏蔽活动
    if qy.isAudit and qy.product == "sina" then
        return
    end

    if (self.acvitityLine and self.acvitityLine:getNumberOfRunningActions() > 0)  and (self.model.userInfoEntity.level >= 10 and self.model.userInfoEntity.level <= 19) then
        return
    end
    if self.model.userInfoEntity.level >= 10 and self.model.userInfoEntity.level <= 19 then
        local position = self.activityBtn2:getParent():convertToWorldSpace(cc.p(self.activityBtn2:getPositionX(),self.activityBtn2:getPositionY()))
        if not self.sprite3 then
            self.sprite3 = cc.Sprite:createWithSpriteFrameName("Resources/main_city/11.png")
            self.sprite3:setPosition(position.x , position.y)
        end

        if not self.acvitityLine then
            self.acvitityLine = cc.Sprite:createWithSpriteFrameName("Resources/main_city/q2.png")
            self.sprite3:addChild(self.acvitityLine)
            self.acvitityLine:setPositionY(40)
        end

        local func2 = cc.CallFunc:create(function()
            self.acvitityLine:setPositionX(-10)
        end)
        local func1 = cc.MoveTo:create(1, cc.p(200, 40))
        local func4 = cc.DelayTime:create(5)
        local seq = cc.Sequence:create(func1, func2, func4)
        local func3 = cc.RepeatForever:create(seq)
        self.acvitityLine:runAction(func3)

        if not self.clip2 then
            local sprite = cc.Sprite:createWithSpriteFrameName("Resources/common/img/shade2.png")
            self.clip2 = cc.ClippingNode:create()
            self.clip2:setInverted(false)
            self.clip2:setAlphaThreshold(0)
            self:addChild(self.clip2)
            self.clip2:addChild(self.sprite3)
            sprite:setPosition(self.sprite3:getPositionX(), self.sprite3:getPositionY())

            self.clip2:setStencil(sprite)
        end
    else
        if self.clip2 then
            self.clip2:removeSelf()
            self.clip2 = nil
        end

        if self.acvitityLine then
            self.acvitityLine = nil
        end
    end
end

-- 新邮件动画
function MainView:showEmailAction()
    if self.mailBtn:getNumberOfRunningActions() > 0 then
        return
    end
    local func1 = cc.RotateTo:create(0.3, -15)
    local func2 = cc.RotateTo:create(0.3, 15)
    local func8 = cc.RotateTo:create(0.15, 0)

    local func3 = cc.RotateTo:create(0.15, -15)
    local func4 = cc.RotateTo:create(0.15, 15)
    local func5 = cc.RotateTo:create(0.15, -15)
    local func6 = cc.RotateTo:create(0.15, 15)
    local func7 = cc.RotateTo:create(0.0775, 0)
    local delay = cc.DelayTime:create(0.2)

    local seq = cc.Sequence:create(func1, func2, func8, delay, func3, func4, func5, func6, func7)
    local func9 = cc.RepeatForever:create(seq)
    self.mailBtn:runAction(func9)
end

--[[
--移除控件的动画
--]]
function MainView:removeUiAmin()
    -- self.taskTips_1:stopAllActions()
    -- self.taskTips_2:stopAllActions()
    -- self.taskRewardTips:stopAllActions()
    self.silverTxt:stopAllActions()
    self.diamondTxt:stopAllActions()
    self.campainImg:stopAllActions()
end

--[[--
--启动新手引导(特例：不会销毁)
--]]
function MainView:startGuide()
    --新手引导：注册控件
    qy.GuideCommand:addUiRegister({
        {["ui"] = self.campaignBtn,["step"] = {"SG_12","SG_38","SG_58","SG_66","SG_79","SG_104","SG_119"}},
        {["ui"] = self.garageBtn,["step"] = {"SG_23","SG_26","SG_29","SG_32"}},
        {["ui"] = self.extractionCardBtn, ["step"] = {"SG_51"}},
        {["ui"] = self.trainingBtn, ["step"] = {"SG_98","SG_100"}},
    })
    --触发式引导
    qy.GuideCommand:addTriggerUiRegister({
        {["ui"] = self.technologyBtn, ["step"] = {"T_TE_3"}},
        {["ui"] = self.activityBtn1, ["step"] = {"T_CB_3","T_AR_3","T_EX_3", "T_GB_3", "T_BO_3"}},
        {["ui"] = self.mineBtn, ["step"] = {"T_MV_3"}},
        {["ui"] = self.garageBtn, ["step"] = {"T_AD_3"}},
    })
end

return MainView
