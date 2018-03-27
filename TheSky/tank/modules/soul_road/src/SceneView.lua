local SceneView = qy.class("SceneView", qy.tank.view.BaseView, "soul_road.ui.SceneView")


local model = qy.tank.model.SoulRoadModel
function SceneView:ctor(delegate, idx, node)
   	SceneView.super.ctor(self)

   	self:InjectView("Frame")
   	self:InjectView("Img")
   	self:InjectView("Done")
   	self:InjectView("Color")
   	self:InjectView("Name")
   	self:InjectView("Light")
   	self:InjectView("Block")
   	-- self:InjectView("star1_6")
    -- self:InjectView("star1_7")
   	-- self:InjectView("Resource1")
   	-- self:InjectView("Resource2")
   	-- self:InjectView("IsMy")
   	-- self:InjectView("Name")
   	-- self:InjectView("NameBg")
   	-- self:InjectView("Btn_view")

    self:OnClick("Frame", function()
      if self.Block:isVisible() then
          qy.hint:show(qy.TextUtil:substitute(67021))
      else
          delegate:showSceneList(self.idx)
      end
    end,{["isScale"] = false})

    -- self.idx = idx

    -- self:initCar()
    -- self:setData(delegate)
end

function SceneView:setData(idx)
    if idx <= 6 then
        self.Light:setVisible(model.current_scene == idx)
        self.Light:loadTexture("soul_road/res/light" .. idx ..".png", 1)
        self.Block:setVisible(idx > model.current_scene)
        self.Done:setVisible(idx <= model.complete_scene)
        self.Color:setSpriteFrame("soul_road/res/color" .. idx .. ".png")
        self.Name:loadTexture("soul_road/res/name" .. idx ..".png", 1)

        self.Light:setVisible(model.current_scene == idx)
    else
        self.Light:setVisible(false)
        self.Color:setVisible(false)
        self.Done:setVisible(false)
        self.Name:loadTexture("soul_road/res/name0.png", 1)
    end

    local color = idx > model.current_scene and cc.c3b(76,76,76) or cc.c3b(255,255,255)
    self.Img:loadTexture("soul_road/res/g" .. idx ..".png", 1)
    self.Img:setColor(color)

    local staticData = model:atSecne(idx)
    
    self.idx = idx
end

return SceneView
