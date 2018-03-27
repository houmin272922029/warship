local MainView = qy.class("MainView", qy.tank.view.BaseView, "soul_road.ui.MainView")

local model = qy.tank.model.SoulRoadModel
function MainView:ctor(delegate)
   	MainView.super.ctor(self)

    for i = 1, 6 do
        self:InjectCustomView("Scene" .. i, require("soul_road.src.SceneView"), delegate)
        local idx = i - 1
        self:InjectView("Point" .. idx)
    end

    for i = 1, 5 do
        self:InjectView("Road" .. i)
    end

    local style = qy.tank.view.style.ViewStyle1.new({
        titleUrl = "Resources/activity/title_soul_road.png", 
        showHome = false,
        ["onExit"] = function()
            delegate:finish()
        end
    })
    self:addChild(style)
    self:update()
end

function MainView:update()
    for i = 1, 6 do
        self["Scene" .. i]:setData(i)
    end

    for i = 1, 5 do
        if model.current_scene > i then
            self["Road" .. i]:setSpriteFrame("soul_road/res/road" .. i .. ".png")
            self["Point" .. i]:setSpriteFrame("soul_road/res/1.png")
        else
            self["Road" .. i]:setSpriteFrame("soul_road/res/road" .. i .. "_" .. i .. ".png")
            self["Point" .. i]:setSpriteFrame("soul_road/res/2.png")
        end
    end
end

function MainView:onEnter()
    self:update()
end

return MainView
