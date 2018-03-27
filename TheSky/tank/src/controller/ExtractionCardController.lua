--[[
    抽卡控制类（军火商店）
]]
local ExtractionCardController = qy.class("ExtractionCardController", qy.tank.controller.BaseController)

function ExtractionCardController:ctor(data)
    ExtractionCardController.super.ctor(self)

    self.viewStack = qy.tank.widget.ViewStack.new()
    self.viewStack:addTo(self)
    
    self.viewStack:push(qy.tank.view.extractionCard.ExtractionCardView.new({
        ["dismiss"] = function()
            -- self.viewStack:pop()
            -- self.viewStack:removeFrom(self)
            -- self:finish()
            self:onBackClicked()
        end,
        ["showResult"] = function(award , isTen, side , updateFunc)
            self:showResult(award , isTen, side , updateFunc)
        end,
        ["showAwardView"] = function()
            self:showAwardView()
        end
        }))
end


function ExtractionCardController:showResult(award , isTen, side , updateFunc)
    if not tolua.cast(self.resultView,"cc.Node") then
        print("bbbbbb --- " , updateFunc)
        self.resultView = qy.tank.view.extractionCard.ExtractionCardResultView.new({
            ["data"] = award,
            ["isTen"] = isTen,
            ["side"] = side,
            ["dismiss"] = function()
                print("cccccc --- " , updateFunc)
                updateFunc()
                self.viewStack:pop()
                -- self:removeResult()
            end
        })
        self.viewStack:push(self.resultView)
    end
end

function ExtractionCardController:showAwardView()
    if not tolua.cast(self.awardView,"cc.Node") then
        self.awardView = qy.tank.view.extractionCard.ExtractionCardAward.new({
            ["dismiss"] = function()
                self.viewStack:pop()
            end
        })
        self.viewStack:push(self.awardView)
    end
end


function ExtractionCardController:removeResult()
    if tolua.cast(self.resultView,"cc.Node") and self.resultView:getParent() then
        self.resultView:getParent():removeChild(self.resultView)
        self.resultView = nil
    end
end

return ExtractionCardController
