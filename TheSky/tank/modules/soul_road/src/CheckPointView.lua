local CheckPointView = qy.class("CheckPointView", qy.tank.view.BaseView, "soul_road.ui.CheckPointView")

local model = qy.tank.model.SoulRoadModel
function CheckPointView:ctor(delegate)
   	CheckPointView.super.ctor(self)

   	self:InjectView("Img")
   	self:InjectView("Frame")
   	self:InjectView("FirstWin")
   	self:InjectView("Light")
   	self:InjectView("Num")
   	self:InjectView("Name")
   	self:InjectView("Level")
   	self:InjectView("Block")
    -- -- self:InjectView("star1_7")
   	-- -- self:InjectView("Resource1")
   	-- -- self:InjectView("Resource2")
   	-- -- self:InjectView("IsMy")
   	-- -- self:InjectView("Name")
   	-- -- self:InjectView("NameBg")
   	-- -- self:InjectView("Btn_view")

    -- self:OnClick("Frame", function()
    --   -- if self.Block:isVisible() then
    --   --     qy.hint:show("此场景尚未解锁")
    --   -- else
    --   --     delegate:showSceneList()
    --   -- end
    -- end,{["isScale"] = false})

    -- self.idx = idx

    -- self:initCar()
    -- self:setData(delegate)
end

function CheckPointView:render(data, idx)
    self.Light:setVisible(false)
    self.Name:setString(data.name)
    self.Block:setVisible(data.checkpoint_id > model.current)
    self.FirstWin:setVisible(data.checkpoint_id > model.complete)

    local color = data.checkpoint_id <= model.current and cc.c3b(255, 255, 255) or cc.c3b(150, 150, 150)
    -- if not (data.complete or data.current) then
    --   self.Img:runAction(cc.TintTo:create(0, cc.c3b(255, 255, 255)))
    -- end
    self.Img:setColor(color)
    self.Frame:setColor(color)

    self.Name:setTextColor(color)
    self.Num:setTextColor(color)
    self.Level:setTextColor(color)

    local sceneData = model:atSecne(idx)
    self.Name:setString(data.name)
    self.Num:setString(sceneData.name)
    if data.type == 2 then
        self.Level:setString("Lv." .. data.level .. qy.TextUtil:substitute(67010))
    else
        self.Level:setString("Lv." .. data.level)
    end
    
    self.Img:setSpriteFrame("soul_road/res/g" .. idx .. ".png")
end

return CheckPointView
