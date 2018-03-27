--[[
说明: 主界面控制器
作者: 林国锋 <guofeng@9173.com>
日期: 2014-11-13
]]

local MainController = qy.class("MainController", qy.tank.controller.BaseController)

function MainController:ctor(data)
    MainController.super.ctor(self)

    print("MainController:ctor")
    if qy.product == "sina111" then
        qy.tank.view.main.MainView1.new({
        ["enterBattle"] = function(view)
            local service = qy.tank.service.BattleService
            service:getBattleData(nil,function(data)
                -- qy.tank.manager.ScenesManager:pushScene(qy.tank.view.scene.BattleScene.new())
                qy.tank.manager.ScenesManager:pushBattleScene()
            end)
        end,

        ["enterGarage"] = function(view)
            qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.GARAGE)
        end,

        ["enterChapter"] = function(view)
            qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.CHAPTER)
        end,

        ["enterExtractionCard"] = function(view)
            qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.EXTRACTION_CARD)
        end,

        ["enterTechnology"] = function(view)
            qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.TECHNOLOGY)
        end,

        ["enterTraining"] = function(view)
            qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.TRAINING)
        end,

        ["enterEquip"] = function(view)
            qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.EQUIP)
        end,

        ["enterAlloy"] = function(view)
            qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.ALLOY)
        end,

        ["enterLegion"] = function(view)
            qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.LEGION)
        end,

        ["enterSupply"] = function(view)
            qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.SUPPLY)
        end,

        ["enterMail"] = function(view)
            qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.MAIL)
        end,

        ["logout"] = function(view)
            qy.tank.manager.ScenesManager:popScene()
        end,

        ["classicBattle"] = function()
            qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.CLASSIC_BATTLE)
        end,

        ["enterTask"] = function()
            qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.TASK)
        end,

        ["enterShop"] = function()
            qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.SHOP)
        end,
        ["enterMine"] = function()
            --qy.tank.command.MainCommand:setParams({["moduleType"] = qy.tank.view.type.ModuleType.MINE_MAIN_VIEW})
            qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.MINE_MAIN_VIEW)
        end,

        ["onActivity"] = function()
            qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.BATTLE_ROOM)
        end,

        ["onArena"] = function()
            qy.tank.command.ActivitiesCommand:showActivity(qy.tank.view.type.ModuleType.ARENA)
        end,

        ["enterFightJapan"] = function()
            qy.tank.command.ActivitiesCommand:showActivity(qy.tank.view.type.ModuleType.FIGHT_JAPAN)
        end,

        ["enterInspection"] = function()
            qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.INSPECTION)
        end,

        ["enterInvade"] = function()
            qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.INVADE)
        end,

        ["vip"] = function()
            qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.VIP)
        end,

        ["vipAward"] = function()
            qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.VIP_AWARD)
        end,

        ["enterPot"] = function()
            qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.POT)
        end,

        ["enterSet"] = function()
            qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.SET)
        end,

        ["enterOperatingActivities"] = function()
            --运营活动 
            qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.ACTIVITY_LIST)
        end,

        ["enterTimeLimitActivities"] = function()
            --限时活动
            qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.TIME_LIMIT_ACTIVITY_LIST)
        end,

        ["enterServiceActivities"] = function()
            --跨服玩法
            qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.SERVICE_ACTIVITY_LIST)
        end,
        ["showMessage"] = function(mType)
            qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.MESSAGE, {["mType"] = mType})
        end,
        ["showMessage1"] = function(mType)
            qy.tank.command.MainCommand:viewRedirectByModuleType("MESSAGE1", {["mType"] = mType})
        end,
        ["showAchievement"] = function(mType)
            qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.ACHIEVEMENT, {["mType"] = mType})
        end,
        ["showResolve"] = function()
            if qy.tank.model.ResolveModel:testOpen() then
                qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.RESOLVE)
            else
                qy.hint:show(qy.TextUtil:substitute(80009).. " " .. qy.TextUtil:substitute(48036, qy.Config.function_open["21"].open_level))
            end
        end
    }):addTo(self)
    else
        qy.tank.view.main.MainView.new({
            ["enterBattle"] = function(view)
                local service = qy.tank.service.BattleService
                service:getBattleData(nil,function(data)
                    -- qy.tank.manager.ScenesManager:pushScene(qy.tank.view.scene.BattleScene.new())
                    qy.tank.manager.ScenesManager:pushBattleScene()
                end)
            end,

            ["enterGarage"] = function(view)
                qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.GARAGE)
            end,

            ["enterChapter"] = function(view)
                qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.CHAPTER)
            end,

            ["enterExtractionCard"] = function(view)
                qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.EXTRACTION_CARD)
            end,

            ["enterTechnology"] = function(view)
                qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.TECHNOLOGY)
            end,

            ["enterTraining"] = function(view)
                qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.TRAINING)
            end,

            ["enterEquip"] = function(view)
                qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.EQUIP)
            end,

            ["enterAlloy"] = function(view)
                qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.ALLOY)
            end,

            ["enterLegion"] = function(view)
                qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.LEGION)
            end,

            ["enterSupply"] = function(view)
                qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.SUPPLY)
            end,

            ["enterMail"] = function(view)
                qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.MAIL)
            end,

            ["logout"] = function(view)
                qy.tank.manager.ScenesManager:popScene()
            end,

            ["classicBattle"] = function()
                qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.CLASSIC_BATTLE)
            end,

            ["enterTask"] = function()
                qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.TASK)
            end,

            ["enterShop"] = function()
                qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.SHOP)
            end,
            ["enterMine"] = function()
                --qy.tank.command.MainCommand:setParams({["moduleType"] = qy.tank.view.type.ModuleType.MINE_MAIN_VIEW})
                qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.MINE_MAIN_VIEW)
            end,

            ["onActivity"] = function()
                qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.BATTLE_ROOM)
            end,

            ["onArena"] = function()
                qy.tank.command.ActivitiesCommand:showActivity(qy.tank.view.type.ModuleType.ARENA)
            end,

            ["enterFightJapan"] = function()
                qy.tank.command.ActivitiesCommand:showActivity(qy.tank.view.type.ModuleType.FIGHT_JAPAN)
            end,

            ["enterInspection"] = function()
                qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.INSPECTION)
            end,

            ["enterInvade"] = function()
                qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.INVADE)
            end,

            ["vip"] = function()
                qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.VIP)
            end,

            ["vipAward"] = function()
                qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.VIP_AWARD)
            end,

            ["enterPot"] = function()
                qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.POT)
            end,

            ["enterSet"] = function()
                qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.SET)
            end,

            ["enterOperatingActivities"] = function()
                --运营活动 
                qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.ACTIVITY_LIST)
            end,

            ["enterTimeLimitActivities"] = function()
                --限时活动
                qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.TIME_LIMIT_ACTIVITY_LIST)
            end,

            ["enterServiceActivities"] = function()
                --跨服玩法
                qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.SERVICE_ACTIVITY_LIST)
            end,
            ["showMessage"] = function(mType)
                qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.MESSAGE, {["mType"] = mType})
            end,
            ["showMessage1"] = function(mType)
                qy.tank.command.MainCommand:viewRedirectByModuleType("MESSAGE1", {["mType"] = mType})
            end,
            ["showAchievement"] = function(mType)
                qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.ACHIEVEMENT, {["mType"] = mType})
            end,
            ["showResolve"] = function()
                if qy.tank.model.ResolveModel:testOpen() then
                    qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.RESOLVE)
                else
                    qy.hint:show(qy.TextUtil:substitute(80009).. " " .. qy.TextUtil:substitute(48036, qy.Config.function_open["21"].open_level))
                end
            end
        }):addTo(self)
    end
end

return MainController
