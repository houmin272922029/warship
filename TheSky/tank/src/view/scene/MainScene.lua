local MainScene = qy.class("MainScene", qy.tank.view.scene.BaseScene)

local WebSocket = require("utils.WebSocket")

function MainScene:ctor()
    print("MainScene ctor")
    MainScene.super.ctor(self)
    -- 特殊表, 在表里的Controller都使用push提交
    self._pushControllers = {
        ["PetController"] = true,
        ["LineupController"] = true
    }

    -- 启动主控制器
    self:push(qy.tank.controller.MainController.new())
    --qy.GuideManager:start(qy.tank.model.GuideModel:getFirstStep())

    -- 创建切换场景
    self.sceneTransition = qy.tank.widget.SceneTransition.new()
    self.sceneTransition:setLocalZOrder(27)
    self.sceneTransition:addTo(self)
    self.sceneTransition:hide()
end

function MainScene:push(controller)
    local cName = controller.__cname

    -- 如果当前只有1个Controller, 使用push的方式
    if self.controllerStack:size() == 1 or self._pushControllers[cName]==nil then
        MainScene.super.push(self, controller)
    else
        MainScene.super.replace(self, controller)
    end
end

function MainScene:pop()
    MainScene.super.pop(self)
    -- 可能被执行了finish
    local currentController = self.controllerStack:currentView()
end

function MainScene:onEnter()
    print("MainScene enter")
    -- print()
    qy.GuideManager:start(qy.tank.model.GuideModel:getFirstStep())
    MainScene.super.onEnter(self)

    self.listener_c = qy.Event.add(qy.Event.SCENE_TRANSITION_SHOW,function(event)
        if self.sceneTransition and tolua.cast(self.sceneTransition,"cc.Node") then
            self.sceneTransition:show(function ()
            end)
        end
    end)

    self.listener_d = qy.Event.add(qy.Event.SCENE_TRANSITION_HIDE,function(event)
        if self.sceneTransition and tolua.cast(self.sceneTransition,"cc.Node") then
            self.sceneTransition:hide()
        end
    end)

    self.listener_e = qy.Event.add(qy.Event.SHOW_PICADD_TIPS,function(event)
        local addTime = 2
        local picAddList = qy.tank.model.AchievementModel.picAddList
        local list = {}

        table.insert(list, cc.DelayTime:create(1))
        for i, v in pairs(picAddList) do
            local func1 = cc.CallFunc:create(function()
                local model = qy.tank.model.AchievementModel
                if model.totalPicList[tostring(v)] then
                    local data =  model.totalPicList[tostring(v)].entity
                    -- local addFight = qy.tank.model.UserInfoModel.userInfoEntity.fightPower - qy.tank.model.UserInfoModel.userInfoEntity.oldfight_power
                    -- qy.hint:show("激活图鉴:" .. data.name .. "，战斗力+" .. addFight .. " " .. model.attrTypes[tostring(data.tujian_type)] .. "+" .. data.tujian_val)

                    local view = qy.tank.view.achievement.PicAddTips.new()
                    view:setData({["name"] = data.name})
                    qy.hint:showImageToast(view ,3,1)

                    local param = {}
                    local num = data.tujian_val
                    if data.tujian_type == 6 or data.tujian_type == 7 then
                        num = math.ceil(num / 10)
                    end
                    param[tostring(data.tujian_type)] = num
                    -- param["100"] = qy.tank.model.UserInfoModel.userInfoEntity.fightPower - qy.tank.model.UserInfoModel.userInfoEntity.oldfight_power

                    local data_ = qy.tank.model.AchievementModel:getAddAttribute(param)

                    qy.tank.utils.HintUtil.showSomeImageToast(data_, cc.p(qy.winSize.width / 2 + 70, qy.winSize.height * 0.7))
                end
            end)

            local func2 = cc.DelayTime:create(addTime)

            table.insert(list, func1)
            table.insert(list, func2)
        end

        if #list > 0 then
            local func3 = cc.Sequence:create(list)

            self:runAction(func3)
        end
    end)

    -- qy.Event.dispatch(qy.Event.CAMPAIGN_UPDATE_CHECKPOINT)
end

function MainScene:onExit()
    print("MainScene exit")
    MainScene.super.onExit(self)

    qy.Event.remove(self.listener_c)
    qy.Event.remove(self.listener_d)
    qy.Event.remove(self.listener_e)

    if self.sceneTransition and tolua.cast(self.sceneTransition,"cc.Node") then
        self.sceneTransition:hide()
    end
end

function MainScene:onCleanup()
    print("MainScene cleanup")
    MainScene.super.onCleanup(self)

    -- 销毁切换场景
    if self.sceneTransition and tolua.cast(self.sceneTransition,"cc.Node") then
        self.sceneTransition:destroy()
        self:removeChild(self.sceneTransition)
        self.sceneTransition = nil
    end

    WebSocket:close()
end

return MainScene
