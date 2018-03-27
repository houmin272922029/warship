
--[[--
--界面的跳转
--]]

local MainCommand = qy.class("MainCommand", qy.tank.command.BaseCommand)
local RoleUpgradeModel = qy.tank.model.RoleUpgradeModel

--[[--
--根据模块type界面跳转
--@param #string sType 模块type
--@extendData  扩展数据
--]]
function MainCommand:viewRedirectByModuleType(sType , extendData, extendData2)
    local moduleType = qy.tank.view.type.ModuleType
    if moduleType.STORAGE == sType then
        --仓库
        local service = qy.tank.service.StorageService
        service:getPropList(nil,function()
            local storage = qy.tank.view.storage.StorageDialog.new()
            storage:show(true)
            service = nil
        end)
    elseif moduleType.EMBATTLE == sType then
        --布阵
        if extendData~=nil and extendData.fightJapan~=nil then
            qy.tank.model.UserInfoModel.isInFightJapan = true
        else
            qy.tank.model.UserInfoModel.isInFightJapan = false
        end
        qy.tank.command.GarageCommand:showFormationDialog()
        qy.GuideManager:next(92)
    elseif moduleType.GARAGE == sType then
        --车库
        qy.tank.command.GarageCommand:showGarageView()
        qy.GuideManager:next(93)
        -- qy.Timer.create("aaaaaaaa",function()
        --     qy.tank.command.GarageCommand:showGarageView()
        -- end,0.1,1)
    elseif moduleType.OPEN_HELP == sType then
        --功能开启提示
        qy.tank.view.open.OpenDialog.new():show(true)
    elseif moduleType.STRONG == sType then
        --我要变强
        -- qy.tank.service.StrongService:getMainData(function()
            qy.tank.module.Helper:register("strong")
            qy.tank.module.Helper:start("strong",self)
        -- end)
    elseif moduleType.GODWAR == sType then
        --至尊战神
        qy.tank.service.GodWarService:get(function()
            qy.tank.module.Helper:register("god_of_war")
            qy.tank.module.Helper:start("god_of_war",self)
        end)     
    elseif moduleType.MILITARY_RANK == sType then
        --军衔
        local open_level = RoleUpgradeModel:getOpenLevelByModule(sType)
        print("ssssss",open_level)
        if qy.tank.model.UserInfoModel.userInfoEntity.level >= open_level then
            local service = qy.tank.service.MilitaryRankService
            service:init(function()
                qy.tank.module.Helper:register("Military_rank")
                qy.tank.module.Helper:start("Military_rank",self)
            end)
        else
            qy.hint:show("军衔系统"..qy.TextUtil:substitute(70044, open_level))
        end
    elseif moduleType.MEDAL == sType then
        --勋章
        local open_level = RoleUpgradeModel:getOpenLevelByModule(sType)
        if qy.tank.model.UserInfoModel.userInfoEntity.level >= open_level then
            local service = qy.tank.service.MedalService
            service:init(function()
                qy.tank.module.Helper:register("medal")
                qy.tank.module.Helper:start("medal",self)
            end)
        else
            qy.hint:show("勋章系统"..qy.TextUtil:substitute(70044, open_level))
        end
     elseif moduleType.FITTINGS == sType then
        --配件
        local open_level = RoleUpgradeModel:getOpenLevelByModule(sType)
        if qy.tank.model.UserInfoModel.userInfoEntity.level >= open_level then
            qy.tank.module.Helper:register("accessories")
            qy.tank.module.Helper:start("accessories",self)
        else
            qy.hint:show("配件系统"..qy.TextUtil:substitute(70044, open_level))
        end
    elseif moduleType.SUPPLY == sType then
        --补给
        local service = qy.tank.service.SupplyService
        service:getSupplyInfo(nil,function(data)
            qy.tank.view.supply.SupplyDialog.new( {

                }):show(true)
            qy.GuideManager:next(94)
        end)
    elseif moduleType.CHAPTER == sType then
        --关卡
        print("--------Campaign start--------" , os.time())
        local service = qy.tank.service.CampaignService
        service:getMainData(nil,function(data)

            print("--------controller start--------" , os.time())
            local controller = qy.tank.controller.CampaignChapterController.new()
            self:startController(controller)
            print("--------controller end--------" , os.time())
            qy.GuideManager:next(95)
        end)
    elseif moduleType.TRAINING == sType then
        --训练场
        local service = qy.tank.service.TrainingService
        service:getTrainInfo(nil,function(data)
            -- qy.tank.view.training.TrainingView.new(
            --     extendData
            -- ):show(true)
            local controller = qy.tank.controller.TrainingController.new(extendData)
            self:startController(controller)
            qy.GuideManager:next(96)
        end)
    elseif moduleType.INHERIT == sType then
        --坦克置换
        local service = qy.tank.service.InheritService
        --service:getTrainInfo(nil,function(data)
            local controller = qy.tank.controller.InheritController.new(extendData)
            self:startController(controller)
        --    qy.GuideManager:next(96)
        --end)
    elseif moduleType.EQUIP == sType then
        --装备
        local sType = nil
        if extendData and extendData.type then
            sType = extendData.type
        end
        if qy.tank.model.EquipModel:getEquipListLength(sType) > 0 then
            -- qy.tank.view.equip.EquipDialog.new( {
            --     ["updateUserData"] = function()
            --     end
            -- }):show(true)
            local controller = qy.tank.controller.EquipController.new(extendData)
            self:startController(controller)
            qy.GuideManager:next(97)
        else
            qy.hint:show(qy.TextUtil:substitute(70035))
        end
    elseif moduleType.MAIL == sType then
        --邮箱
        -- qy.tank.view.mail.MailDialog.new({
        --     ["defaultIdx"] = extendData.idx
        --     }):show(true)
        qy.tank.view.mail.MailDialog.new(extendData):show(true)
        qy.GuideManager:next(98)
    elseif moduleType.CLASSIC_BATTLE == sType then
        --经典战役
        local service = qy.tank.service.ClassicBattleService
        service:getlist(function()
            local controller = qy.tank.controller.ClassicBattleController.new()
            self:startController(controller)
        end)
    elseif moduleType.EXTRACTION_CARD == sType then
        --抽卡
        local service = qy.tank.service.ExtractionCardService
        service:getMainData(nil,function(data)
            local controller = qy.tank.controller.ExtractionCardController.new()
            self:startController(controller)
            qy.GuideManager:next(99)
        end)
    elseif moduleType.TASK == sType then
        --任务
        local service = qy.tank.service.TaskService
        service:getList(function()
            qy.tank.view.task.TaskDialog.new( {
                }):show(true)
        end)
    elseif moduleType.SHOP == sType then
        --商店
        local shop = qy.tank.controller.ShopController.new()
        self:startController(shop)
    elseif moduleType.TANK_SHOP == sType then
        --坦克工厂
        local factory = qy.tank.controller.TankShopController.new(extendData)
        self:startController(factory)
    elseif moduleType.PROP_SHOP == sType then
        --军需商店
        local service = qy.tank.service.ShopService
        service:propsList(nil,function(data)
            local shop = qy.tank.controller.PropShopController.new(extendData)
            self:startController(shop)
        end)
    elseif moduleType.MINE_MAIN_VIEW == sType then
        --矿区
        local service = qy.tank.service.MineService
        service:getMineInfo(function(data)
            local controller = qy.tank.controller.MineController.new()
            self:startController(controller)
            qy.GuideManager:nextTiggerGuide()
        end)
    elseif moduleType.BATTLE_ROOM == sType then
        -- 活动导航
        local controller = qy.tank.controller.BattleRoomController.new()
        self:startController(controller)
        qy.GuideManager:nextTiggerGuide()
    elseif moduleType.ROLE_UPGRADE == sType then
        --主角升级
        local roleUpgrade = qy.tank.view.user.upgrade.RoleUpgradeDialog.new()
        roleUpgrade:show(true)
    elseif moduleType.FUNCTION_OPEN_TIP == sType then
        --功能开启提示
        -- qy.tank.manager.ScenesManager:getRunningScene():disissAllDialog()
        qy.tank.manager.ScenesManager:getRunningScene():disissAllDialog()
        qy.tank.manager.ScenesManager:getRunningScene():disissAllView()
        local functionOpen = qy.tank.view.guide.triggerGuide.FunctionOpenDialog.new()
        functionOpen:show(true)
    -- elseif moduleType.INSPECTION == sType then
    --     --每日检阅
    --     local service = qy.tank.service.InspectionService
    --     service:getList(nil , function(data)
    --         qy.tank.view.inspection.InspectionDialog.new():show(true)
    --     end)
    -- elseif moduleType.INVADE == sType then
    --     --伞兵入侵
    --     local service = qy.tank.service.InvadeService
    --     service:main(nil , function(data)
    --         qy.tank.view.invade.InvadeDialog.new():show(true)
    --     end)
    -- elseif moduleType.INSPECTION == sType then
    --     --每日检阅
    --     local service = qy.tank.service.InspectionService
    --         service:getList(nil , function(data)
    --             qy.tank.view.inspection.InspectionDialog.new():show(true)
    --     end)
    elseif moduleType.SET == sType then
        -- 设置
       qy.tank.view.setting.SettingDialog.new():show(true)
    elseif moduleType.PUSH_SET == sType then
        -- 推送设置
       qy.tank.view.setting.PushListDialog.new():show(true)
    elseif moduleType.TECHNOLOGY == sType then
        --科技
        if qy.tank.model.UserInfoModel.userInfoEntity.level > 14 then
            local controller = qy.tank.controller.TechnologyController.new()
            self:startController(controller)
            qy.GuideManager:nextTiggerGuide()
        else
             qy.hint:show(qy.TextUtil:substitute(70036))
             qy.Event.dispatch(qy.Event.SERVICE_LOADING_HIDE)
        end
    elseif moduleType.VIP == sType then
        --vip特权
        qy.tank.command.VipCommand:showPrivilegeView(extendData)
    elseif moduleType.VIP_AWARD == sType then
        --vip award
         qy.tank.command.VipCommand:showAwardDialog()
    elseif moduleType.ACTIVITY_LIST == sType then
        --活动列表
        -- local service = qy.tank.service.OperatingActivitiesService
        -- service:getList(function(data)
            qy.tank.view.operatingActivities.ActivitiesList.new():show(true)
            qy.GuideManager:next(991)
        -- end)
    elseif moduleType.SERVICE_ACTIVITY_LIST == sType then
        --跨服活动列表
        qy.tank.view.operatingActivities.serviceActivities.ServiceActivitiesList.new():show(true)
    
    elseif moduleType.TIME_LIMIT_ACTIVITY_LIST == sType then
        --限时活动列表
        qy.tank.view.operatingActivities.timeLimitActivities.TimeLimitActivitiesList.new():show(true) 
    elseif moduleType.REGISTER == sType then
        --快速注册
        qy.tank.view.login.RegisterDialog.new(extendData):show(true)
    elseif moduleType.REMINDER == sType then
    elseif moduleType.DISTRICT == sType then
        --换区
        qy.tank.view.login.DistrictDialog.new({
            ["updateDistrict"] = function ()
                extendData()
            end
            }):show(true)
    elseif moduleType.QY_AGREE == sType then
        qy.tank.view.login.AgreeDialog.new():show(true)
    elseif moduleType.BUY_OR_USE == sType then
        if extendData == nil then
            local award = {["type"] = 14, ["num"] = 1, ["id"] = 1}
            extendData = {award}
        end
        local service = qy.tank.service.ShopService
        service:propsList(nil,function(data)
            qy.tank.view.common.BuyOrUseDialog.new({
                ["award"] = extendData
            }):show(true)
            end)
    elseif moduleType.MESSAGE == sType then
        local model = qy.tank.model.MessageModel
        qy.tank.service.RedDotService:getRemind(qy.tank.model.MessageModel.messageType[tostring(extendData.mType)], function()
            local data = model:getNextMessage()
            if data then
                qy.tank.view.main.MessageDialog.new({
                    ["mType_"] = extendData,
                    ["data"] = data,
                    ["check"] = function(dialog, mType)
                        dialog:dismiss()
                        if mType == 2 then
                            qy.tank.service.MineService:showCombat(data.combat_id, function (data)
                                qy.tank.manager.ScenesManager:pushBattleScene()
                            end)
                            -- qy.tank.command.ActivitiesCommand:showActivity(qy.tank.view.type.ModuleType.ARENA)
                        elseif mType == 1 then
                            -- _MineService:showCombat(data.combat_id, function (data)
                            --     qy.tank.manager.ScenesManager:pushBattleScene()
                            -- end)
                            self:viewRedirectByModuleType(qy.tank.view.type.ModuleType.MAIL, {["defaultIdx"] = 2})
                        elseif mType == 3 then
                            -- qy.hint:show("此功能暂未开放")
                            self:viewRedirectByModuleType(qy.tank.view.type.ModuleType.PLUNDER_LOG)
                        elseif mType == 4 then
                            qy.tank.command.ActivitiesCommand:showActivity(qy.tank.view.type.ModuleType.CARRAY)
                        end
                    end,
                    ["next"] = function(dialog)
                        if model:testNextMessage() then
                            dialog:setData(model:getNextMessage())
                        else
                            qy.hint:show(qy.TextUtil:substitute(70037))
                        end
                    end
                    }):show()
            else
                qy.Event.dispatch(qy.Event.MESSAGE_UPDATE, {["mType"] = extendData.mType, ["flag"] = false})
                -- qy.hint:show("数据出错")
            end
        end)
    elseif "MESSAGE1" == sType then
        qy.tank.command.ActivitiesCommand:showActivity(qy.tank.view.type.ModuleType.SER_CAMP)
    elseif moduleType.ENTER_GAME == sType then
        qy.tank.service.LoginService:login(function (data)
            local start_time = os.clock()
            qy.tank.model.UserInfoModel:init(data.main)
            if qy.isNoviceGuide and qy.tank.model.GuideModel:getCurrentBigStep() == 1 then
                qy.GuideManager:start(qy.tank.model.GuideModel:getFirstStep())
            else
                -- 提前加载main_bg.jpg 占用内存为 3691KB => 2460KB
                qy.Utils.preloadJPG("Resources/main_city/building/main_bg.jpg")
                qy.tank.manager.ScenesManager:showMainScene() --直接进入游戏
            end
            local end_time = os.clock()
             if qy.tank.utils.SDK:channel() == "google" then -- 海外版隐藏facebook登陆
                qy.tank.utils.SDK:hideFacebook()
            end
        end,function ()
            qy.Event.dispatch(qy.Event.SCENE_LOAD_HIDE)
        end,function ()
            qy.Event.dispatch(qy.Event.SCENE_LOAD_HIDE)
        end)
    elseif moduleType.LOGIN_ANNOUNCE == sType then
        if qy.product == "local" or qy.isAudit then
            --本地环境或者审核状态下，不显示公告
            return
        end
        if qy.tank.model.MailModel:getNoticeList() and #qy.tank.model.MailModel:getNoticeList() > 0 and qy.isNoviceGuide == false and qy.tank.model.MailModel:getNoticeflag() == false  then
            qy.tank.view.login.AnnouncementDialog.new():show(true)
        end
    elseif moduleType.FINISH_GUIDE == sType then
        qy.tank.view.guide.noviceGuide.FinishGuideDialog.new():show(true)
    elseif moduleType.SCENE_LOADING == sType then
        -- 提前加载loading_img.jpg 占用内存为 2700KB => 1800KB
        qy.Utils.preloadJPG("Resources/common/img/loading_img.jpg")
        qy.tank.view.common.Loading.new():show(true)
    elseif moduleType.ACHIEVEMENT == sType then
        qy.tank.service.AchievementService:getList(function()
            qy.tank.view.achievement.MainDialog.new({

            }):show()
        end)
    elseif moduleType.PLUNDER_LOG == sType then
        qy.tank.service.MineService:getPlunderLog(function (data)
            print("战报数量==".. #qy.tank.model.MineModel:getLog())
            if #qy.tank.model.MineModel:getLog() > 0 then
                qy.tank.view.mine.PlunderLogDialog.new():show(true)
            else
                qy.hint:show(qy.TextUtil:substitute(70038))
            end
        end)
    elseif moduleType.BIND_ACCOUNT == sType then
        if qy.language ~= "en" then 
            qy.tank.view.login.BindAccountDialog.new():show(true)
        end
    elseif moduleType.ALLOY == sType then
        --合金
        local open_level = RoleUpgradeModel:getOpenLevelByModule(sType)
        if qy.tank.model.UserInfoModel.userInfoEntity.level >= open_level then
            qy.tank.module.Helper:register("alloy")
            qy.tank.module.Helper:start("alloy",self)
        else
            qy.hint:show(qy.TextUtil:substitute(70039)..qy.TextUtil:substitute(70041, open_level))
        end
    elseif moduleType.EXAMINE == sType then
        qy.tank.service.ExamineService:show(extendData, function()
            qy.tank.view.examine.ExamineDialog.new(extendData,extendData2):show()
        end)
    elseif moduleType.EXAMINE_AI == sType then
        qy.tank.service.ExamineService:show_ai(extendData, function()
            qy.tank.view.examine.ExamineDialog.new(extendData,extendData2):show()
        end)
    elseif moduleType.EXAMINE_AI_L == sType then
        qy.tank.service.ExamineService:show_ai1(extendData, function()
            qy.tank.view.examine.ExamineDialog.new(extendData,extendData2):show()
        end)
    elseif moduleType.RESOLVE == sType then
        local controller = qy.tank.controller.ResolveController.new()
        self:startController(controller)
    elseif moduleType.RECHARGE == sType then
        -- if qy.product == "sina" then
        --     qy.hint:show("充值暂未开放，敬请期待")
        --     return
        -- end

        local controller = qy.tank.controller.RechargeController.new(extendData)
        self:startController(controller)
    elseif moduleType.TANK_COMMENT == sType then  -- 战车点评  extendData 是战车的entity
        print(extendData.tank_id)
        qy.tank.service.AchievementService:getCommentList(extendData.tank_id, function()
            qy.tank.view.achievement.CommentDialog.new(extendData):show()
        end,1, (extendData2 and extendData or nil))
    elseif moduleType.ADVANCE == sType then -- 进阶
        local controller = qy.tank.controller.AdvanceController.new(extendData)
        self:startController(controller)
    elseif moduleType.CD_KEY == sType then
        qy.tank.view.exchange.ExCDKeyDialog.new():show()
    elseif moduleType.BLACKLIST == sType then  --黑名单
        local service = qy.tank.service.BlackListService
        local model = qy.tank.model.BlackModel
        service:getBlackList(
            nil, 300,function(reData)
                model:init(reData.list)
                qy.tank.view.setting.BlackListView.new():show()
        end)
    elseif moduleType.LEGION == sType then
        --军团
        local open_level = RoleUpgradeModel:getOpenLevelByModule(sType)
        if qy.tank.model.UserInfoModel.userInfoEntity.level >= open_level then
            qy.tank.service.LegionService:getMainData(function()
                -- qy.tank.module.Helper:register("legion")
                qy.tank.module.Helper:start("legion",nil,function()
                    self:startController(qy.tank.controller.LegionController.new(extendData))
                end)
            end)
        else
            qy.hint:show(qy.TextUtil:substitute(70040) ..qy.TextUtil:substitute(70041, open_level))
        end
    elseif moduleType.DIAMOND_NOT_ENOUGH == sType then
        if qy.isAudit and qy.product == "sina" then
            qy.hint:show(qy.TextUtil:substitute(70042))
        else
            qy.tank.view.common.DiamondDialog.new():show()
        end
    elseif moduleType.SOUL == sType then --军魂
        local open_level = RoleUpgradeModel:getOpenLevelByModule(sType)
        if qy.tank.model.UserInfoModel.userInfoEntity.level >= open_level then
            qy.tank.module.Helper:register("soul")
            qy.tank.module.Helper:start("soul", self)
        else
            qy.hint:show(qy.TextUtil:substitute(70043)..qy.TextUtil:substitute(70044, open_level))
        end
        -- qy.tank.module.Helper:register("soul")
        -- qy.tank.module.Helper:start("soul",nil,function()
        --     self:startController(qy.tank.controller.SoulController.new(extendData))
        -- end)
    elseif moduleType.PASSENGER == sType then --乘员系统
        local open_level = RoleUpgradeModel:getOpenLevelByModule(sType)
        if qy.tank.model.UserInfoModel.userInfoEntity.level >= open_level then
            qy.tank.service.PassengerService:getPassengerlist(function()
                qy.tank.module.Helper:register("passenger")
                qy.tank.module.Helper:start("passenger",nil,function()
                    local controller = require("passenger.src.MainController").new(extendData)
                    self:startController(controller)
                end)
            end)
        else
            qy.hint:show("乘员系统"..qy.TextUtil:substitute(70044, open_level))
        end

    elseif moduleType.SINA_APPSTORE_SCORE == sType then
        -- 星级评价
        qy.tank.manager.ScenesManager:getRunningScene():disissAllDialog()
        qy.tank.manager.ScenesManager:getRunningScene():disissAllView()
        qy.tank.view.common.ShareView.new():show()
    elseif moduleType.F_J_EX_SHOP == sType then
        --远征商店
        local timer = qy.tank.utils.Timer.new(0.02,1,function()
            qy.tank.model.FightJapanModel:initExpeditionGoods()
        end)
        timer:start()
        local service = qy.tank.service.FightJapanService
        service:getExchage(param,function(data)
            qy.tank.view.fightJapan.ExchangeDialog.new(
            {
                ["data"] = data
            }):show(true)
        end)
    elseif moduleType.GREATEST_RACE == sType then
        -- 最强之战
        qy.tank.service.GreatestRaceService:get(true,function()
            qy.tank.module.Helper:register("greatest_race")
            qy.tank.module.Helper:start("greatest_race",nil,function()
                self:startController(qy.tank.controller.GreatestRaceController.new(extendData))
                qy.tank.model.RedDotModel:changeCrossSerRedRod()
            end)
        end)
    elseif moduleType.COUPON_SHOP == sType then
        
        local service = qy.tank.service.CouponShopService
        service:GetpropsList(extendData,function(data)
            qy.tank.module.Helper:register("coupon_shop")
            qy.tank.module.Helper:start("coupon_shop", qy.App.runningScene.controllerStack:currentView())
        end)
    end
end

--[[--
--设置界面跳转的参数
--]]
function MainCommand:setParams(params)
    self.params = params
end

return MainCommand
