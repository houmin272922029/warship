local ChapterMap = qy.class("ChapterMap", qy.tank.view.BaseView)

ChapterMap.__create = function(delegate)
    return ChapterMap.super.__create("view/campaign/chapterMap/" .. delegate.csdName)
end

local model = qy.tank.model.CampaignModel
function ChapterMap:ctor(delegate)
    ChapterMap.super.ctor(self)
    print("----ChapterMap- ctor-----" ,delegate.chapterId)
    self:InjectView("container")
    self:InjectView("BgContainer")
    self.delegate = delegate
    self.sceneConfig = model:getSceneList(delegate.chapterId)

    for i, v  in pairs(self.sceneConfig)  do
        local sceneID = v.sceneId
        self:InjectCustomView("scene" .. sceneID, qy.tank.view.campaign.ScenePoint, {
                ["sceneData"] = v,
                ["container"] = self.container,
                ["chapterId"] = self.delegate.chapterId
            })
        self:InjectView("arr" .. sceneID)
    end
    print("CampaignSceneController444",self.delegate.chapterId)
    self:update()
end

function ChapterMap:update()
    self:updateScene()
    self:updateAttr()
end

function ChapterMap:updateScene()
    for i, v  in pairs(self.sceneConfig)  do
        local sceneID = v.sceneId
        local flag = model:testSceneOpen(v) and true or false

        if self["scene" .. sceneID] then
            self["scene" .. sceneID]:setVisible(flag)
            self["scene" .. sceneID]:update()
        end
    end
end

function ChapterMap:updateAttr()
     for i, v  in pairs(self.sceneConfig)  do
        local sceneID = v.sceneId
        local flag = model:testSceneOpen(v) and true or false

        if self["arr" .. sceneID - 1] then
            self["arr" .. sceneID - 1]:setVisible(flag)
        end
    end
end

function ChapterMap:startRunAnimaiton()
    if self["scene" .. model.sceneCurrentId] then
        self["scene" .. model.sceneCurrentId]:startRunAnimaiton(self.container)
    end
end

return ChapterMap