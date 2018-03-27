local Controller = qy.class("Controller", qy.tank.controller.BaseController)

local Model = require("gold_bunker.src.Model")
local MainView = require("gold_bunker.src.MainView")
local BunkerView = require("gold_bunker.src.BunkerView")
local LeaderboardDialog = require("gold_bunker.src.LeaderboardDialog")
local RewardsDialog = require("gold_bunker.src.RewardsDialog")
local RewardsPreviewDialog = require("gold_bunker.src.RewardsPreviewDialog")
local DailyRewardsDialog = require("gold_bunker.src.DailyRewardsDialog")

local UserInfoModel = qy.tank.model.UserInfoModel

function Controller:ctor()
    Controller.super.ctor(self)

    local viewStack = qy.tank.widget.ViewStack.new()
    viewStack:addTo(self)

    local bunkerViewMiddleware = function(bunkerView)
        bunkerView.onBack = function(_, sender)
            viewStack:pop()
        end

        bunkerView.onShowRewardsPreviewDialog = function(_, sender)
            RewardsPreviewDialog.new():show()
        end

        bunkerView.onShowDailyRewardsDialog = function(_, sender)
            if Model:getInitData().max_id == 0 then
                qy.hint:show(qy.TextUtil:substitute(46002))
            elseif Model:getInitData().is_draw_award == 1 then
                qy.hint:show(qy.TextUtil:substitute(46003))
            else
                DailyRewardsDialog
                    .new()
                    :show()
            end
        end

        bunkerView.onBattle = function(_, sender)
            Model:getBattleData()
        end

        bunkerView.finish = function(_)
            viewStack:pop()
        end

        bunkerView.onLineup = function(_, sender)
            qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.EMBATTLE)
        end

        bunkerView.onReset = function(_, sender)
            qy.alert:show({qy.TextUtil:substitute(46004), {255,255,255}}, qy.TextUtil:substitute(46005), cc.size(450 , 220), {{qy.TextUtil:substitute(46006), 4}, {qy.TextUtil:substitute(46007) , 5}}, function(flag)
                if flag == qy.TextUtil:substitute(46007) then
                    Model:reset(function()
                        viewStack:pop()
                    end)
                end
            end,"")
        end
    end

    MainView
        .new()
        :use(function(mainView)
            -- 退出
            mainView.onFinish = function(_, sender)
                self:finish()
            end

            -- 显示排行榜
            mainView.onShowLeaderboardDialog = function(_, sender)
                Model:getLeaderboardList(function(data)
                    LeaderboardDialog
                        .new()
                        :setData(data.myrank, data.rank, Model:getInitData().max_id)
                        :show()
                end)
            end

            -- 进入地堡
            mainView.onEnterBunker = function(_, sender)
                -- 检查体力是否足够
                if Model:getInitData().status ~= 1 and UserInfoModel.userInfoEntity.energy < Model:getInitData().need_energy then
                    qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.BUY_OR_USE)
                    return
                end

                Model:getBunkerData(function(award)
                    BunkerView
                        .new()
                        :use(bunkerViewMiddleware)
                        :pushTo(viewStack)

                    -- 自动完成奖励
                    if award and #award > 0 then
                        qy.tank.command.AwardCommand:add(award)
                        RewardsDialog
                            .new()
                            :setData(award)
                            :show()
                    end
                end)
            end

            -- 切换难度
            mainView.onChangeMode = function(_, sender)
                if Model.is_hard == 0 and Model:getInitData().max_id < 400 then
                    qy.hint:show("需通过普通模式400关才能开启")
                else
                    mainView.ui.Image_4:setVisible(true)
                    mainView.ui.Image_3:runAction(cc.Sequence:create(cc.FadeTo:create(0.5, 220), cc.DelayTime:create(0.1), cc.CallFunc:create(function()
                        if Model.is_hard == 0 then
                            Model.is_hard = 1
                            mainView.ui.bg:loadTexture("gold_bunker/res/bg2.jpg")
                            mainView.ui.Btn_mode:loadTexture("gold_bunker/res/b.png")
                        else
                            Model.is_hard = 0
                            mainView.ui.bg:loadTexture("gold_bunker/res/bg1.jpg")
                            mainView.ui.Btn_mode:loadTexture("gold_bunker/res/c.png")
                        end
                        cc.UserDefault:getInstance():setIntegerForKey(qy.tank.model.UserInfoModel.userInfoEntity.kid .."_gold_bunker_is_hard", Model.is_hard)
                        mainView:update()
                    end), cc.FadeTo:create(0.5, 0), cc.CallFunc:create(function()
                        mainView.ui.Image_4:setVisible(false)                    
                    end))) 
                end    
            end

            -- 帮助
            mainView.onShowHelpDialog = function(_, sender)
                qy.tank.view.common.HelpDialog.new(12):show(true)
            end

            -- 添加体力
            mainView.addEnergyBtn = function(sender)
                qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.BUY_OR_USE)
                qy.Event.dispatch(qy.Event.USER_RESOURCE_DATA_UPDATE)
            end
        end)
        :pushTo(viewStack)
end

return Controller
