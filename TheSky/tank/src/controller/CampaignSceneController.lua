local CampaignSceneController = qy.class("CampaignSceneController", qy.tank.controller.BaseController)

function CampaignSceneController:ctor(data)
    CampaignSceneController.super.ctor(self)

    qy.Utils.preloadJPG("Resources/campaign/scene/GK_6.jpg")
    qy.Utils.preloadPNG("Resources/campaign/scene/GK_8.png")

    qy.tank.view.campaign.SceneView.new({
        ["sceneId"] = data.sceneId,
        ["sceneName"] = data.sceneName,
        ["isDrawAward"] = data.isDrawAward,
        ["sceneData"] = data.sceneData,
        ["chapterId"] = data.chapterId,
        ["dismiss"] = function()
            self:finish()
        end,
        ["goHome"] = function()
            self:finish()
            data.goHome()
        end
    }):addTo(self)
end

return CampaignSceneController
