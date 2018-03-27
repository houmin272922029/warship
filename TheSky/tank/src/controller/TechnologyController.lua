--[[
    抽卡控制类（军火商店）
]]
local TechnologyController = qy.class("TechnologyController", qy.tank.controller.BaseController)

function TechnologyController:ctor(data)
    TechnologyController.super.ctor(self)

    self.viewStack = qy.tank.widget.ViewStack.new()
    self.viewStack:addTo(self)

    self.viewStack:push(qy.tank.view.technology.TechnologyView.new({
        ["showDetail"] = function(list)
            self:showDetail(list)
        end ,
        ["showDetail2"] = function(num)
            self:showDetail2(num)
        end ,
        ["dismiss"] = function()
            self.viewStack:pop()
            self.viewStack:removeFrom(self)
            self:finish()
        end
    }))

end

function TechnologyController:showDetail(list)
    if not tolua.cast(self.detailView,"cc.Node") then
        self.detailView = qy.tank.view.technology.TechnologyDetailView.new({
            ["listData"] = list,
            ["dismiss"] = function()
                self:removeDetail()
                qy.RedDotCommand:updateTechTemplateRedDot()
            end
        })
        self:addChild(self.detailView)
    end
end



function TechnologyController:showDetail2(num)
    if not tolua.cast(self.detailView2,"cc.Node") then
        self.detailView2 = qy.tank.view.technology.TechnologyDetailNewView.new({
            ["index"] = num,
            ["dismiss"] = function()
                self:removeDetail2()
                qy.RedDotCommand:updateTechTemplateRedDot()
            end
        })
        self:addChild(self.detailView2)
    end
end


function TechnologyController:removeDetail()
    if tolua.cast(self.detailView,"cc.Node") and self.detailView:getParent() then
        self.detailView:getParent():removeChild(self.detailView)
        self.detailView = nil
    end
end


function TechnologyController:removeDetail2()
    if tolua.cast(self.detailView2,"cc.Node") and self.detailView2:getParent() then
        self.detailView2:getParent():removeChild(self.detailView2)
        self.detailView2 = nil
    end
end

return TechnologyController
