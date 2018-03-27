local CampaignChapterController = qy.class("CampaignChapterController", qy.tank.controller.BaseController)

function CampaignChapterController:ctor(data)
    CampaignChapterController.super.ctor(self)

    self.viewStack = qy.tank.widget.ViewStack.new()
    self.viewStack:addTo(self)

    local fucdelegate = nil
    fucdelegate = {
        
        ["showScene"] = function(thisController,data)
            local controller = qy.tank.controller.CampaignSceneController.new(
                {
                    ["sceneId"] = data.sceneId,
                    ["sceneName"] = data.sceneName,
                    ["isDrawAward"] = data.isDrawAward,
                    ["sceneData"] = data.sceneData,
                    ["chapterId"] = data.chapterId,
                    ["goHome"] = function()
                        self:goHome()
                    end
                }
            )
            self:startController(controller)
        end,
        ["showGarage"] = function()
                local service = qy.tank.service.GarageService
                service:getMainData(nil,function(data)
                    local controller = qy.tank.controller.GarageController.new()
                    self:startController(controller)
                end)
        end,
        ["showBattle"] = function(thisController,battleData , autoUpdateData)
                if autoUpdateData ~= nil and autoUpdateData==false then
                    print("仅仅显示战斗")
                else 
                    print("CampaignChapterController---")
                    qy.tank.model.CampaignModel:update(battleData)
                end 
                
                -- qy.Event.dispatch(qy.Event.CAMPAIGN_UPDATE_CHECKPOINT)
                qy.tank.model.BattleModel:init(battleData.fight_result)
                -- qy.tank.manager.ScenesManager:pushScene(qy.tank.view.scene.BattleScene.new())
                qy.tank.manager.ScenesManager:pushBattleScene()
        end,
        ["dismiss"] = function()
            qy.tank.model.CampaignModel.ChapterView = nil
            qy.tank.model.CampaignModel:resetUserChapter() 
            qy.tank.model.CampaignModel:release()
            self.viewStack:pop()
            self.viewStack:removeFrom(self)
            self:finish()
        end,
        ["goHome"] = function()
            qy.App.runningScene:disissAllView()
        end
        }

    local view = qy.tank.view.campaign.ChapterView.new(fucdelegate)

    self.viewStack:push(view)
end

function CampaignChapterController:goHome()
    self.viewStack:popToRoot()
    self:finish()
end

return CampaignChapterController
