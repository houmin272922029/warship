local ScenePoint = qy.class("ScenePoint", qy.tank.view.BaseView, "view/campaign/ScenePoint")

function ScenePoint:ctor(delegate)
    ScenePoint.super.ctor(self)

	self.delegate = delegate
	self.data = delegate.sceneData
	-- self.currentId = delegate.currentId

	self:InjectView("okSign")
	self:InjectView("currentSign")
	self:InjectView("sceneName")

	self.sceneName:setString(self.data.name)

    self.sceneName:enableOutline(cc.c4b(0,0,0,255),1)
    self.sceneName:setTextColor(cc.c4b(255, 255, 255,255))

    self:OnClick("iconBtn", function(sender)
        qy.tank.model.CampaignModel.ChapterViewDelegate:showScene(
            {
                ["sceneId"] = self.data.sceneId,
                ["sceneName"] = self.data.name,
                ["isDrawAward"] = self.data.isDrawAward,
                ["sceneData"] = self.data,
                ["chapterId"] = self.delegate.chapterId
            }
        )
        qy.GuideManager:next(6)
    end)

    self.x = self:getPositionX()
    self.y = self:getPositionY()
end

function ScenePoint:startRunAnimaiton()
    -- if self.data.sceneId == self.currentId then  --如果包含当前场景
	self:setVisible(false)
    self.currentSign:setVisible(false)
    self:runAnimationFlag()
    self:runAnimationSmoke()
    -- end
end

function ScenePoint:update()
    self.okSign:setVisible(self.data.status == 1 and true or false)
end

function ScenePoint:runAnimationFlag()
    local effect = ccs.Armature:create("ui_fx_tubiaojiang") 
    self.delegate.container:addChild(effect,999)

    qy.QYPlaySound.playEffect(qy.SoundType.CAMP_FLAG)

    effect:setPosition(self.x - 4.5, self.y + 45.5)
    effect:getAnimation():playWithIndex(0)
    effect:getAnimation():setMovementEventCallFunc(function(armatureBack,movementType,movementID)    
        if movementType == ccs.MovementEventType.complete then
            effect:getParent():removeChild(effect)
            -- self:runAnimationSmoke()
            self:setVisible(true)
        end
    end)
end

function ScenePoint:runAnimationSmoke()
    local effect = ccs.Armature:create("ui_fx_cqyan") 
    self.delegate.container:addChild(effect,999)
    effect:setPosition(self.x, self.y)
    effect:getAnimation():playWithIndex(0)
    effect:getAnimation():setMovementEventCallFunc(function(armatureBack,movementType,movementID)
        if movementType == ccs.MovementEventType.complete then
            effect:getParent():removeChild(effect)
            self:runAnimationCircle()
        end
    end)
end

function ScenePoint:runAnimationCircle()
    local effect = ccs.Armature:create("ui_fx_bihua") 
    self.delegate.container:addChild(effect,999)
    effect:setPosition(self.x + 0.5, self.y + 49.5)
    effect:getAnimation():playWithIndex(0)
    effect:getAnimation():setMovementEventCallFunc(function(armatureBack,movementType,movementID)
        if movementType == ccs.MovementEventType.complete then
            effect:getParent():removeChild(effect)
            self.currentSign:setVisible(true)
        end
    end)
end

return ScenePoint