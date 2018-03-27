--
-- Author: Your Name
-- Date: 2016-09-26 14:52:49
--

--
-- Author: Your Name
-- Date: 2016-09-26 11:39:57
--


local ResultDialog = qy.class("ResultDialog", qy.tank.view.BaseDialog, "olympic.ui.ResultDialog")

function ResultDialog:ctor(delegate)
    ResultDialog.super.ctor(self)
	-- self:setCanceledOnTouchOutside(true)
	self.model = qy.tank.model.OlympicModel
     -- 通用弹窗样式
    local style = qy.tank.view.style.DialogStyle5.new({
        size = cc.size(450,230),
        position = cc.p(0,0),
        offset = cc.p(0,0),
    })
    self:addChild(style, -1)

    self:InjectView("panel")
    self:InjectView("title")
    self:InjectView("scoreTitle")
    self:InjectView("score")
    self:InjectView("resultTitle")
    self:InjectView("result")

    self:OnClick("sureBtn", function()
        self:dismiss()
        delegate.dismiss()
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})

    if self.model:isWin() then
        self.title:setSpriteFrame("olympic/res/36.png")
        self.scoreTitle:setString("胜利获得：")
    else
        self.title:setSpriteFrame("olympic/res/37.png")
        self.scoreTitle:setString("失败获得：")
    end

    if self.model.type == 100 then
        self.resultTitle:setString("最终环数：")
        if self.model.times == 1 then
            self.score:setString(self.model.score.."积分")
            self.result:setString(self.model.num.."环")
        else
            self.score:setString(self.model.score.."x10积分")
            self.result:setString(self.model.num.."环")
        end
    elseif self.model.type == 200 then
        self.resultTitle:setString("最终进球：")
        if self.model.times == 1 then
            self.score:setString(self.model.score.."积分")
            self.result:setString(self.model.num.."个")
        else
            self.score:setString(self.model.score.."x10积分")
            self.result:setString(self.model.num.."个")
        end
    end

end

function ResultDialog:onEnter()

end

return ResultDialog
