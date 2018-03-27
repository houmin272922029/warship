local ContinuousChallengeCell = qy.class("ContinuousChallengeCell", qy.tank.view.BaseView, "inter_service_arena.ui.ContinuousChallengeCell")

function ContinuousChallengeCell:ctor(callBack)
    ContinuousChallengeCell.super.ctor(self)
    self.callBack = callBack
    self:InjectView("Img_round_num")
    self:InjectView("bg")
    self.bg:setVisible(false)
end

function ContinuousChallengeCell:render(idx)
    self.Img_round_num:loadTexture("inter_service_arena/res/".. idx+1 ..".png" ,0)
end


function ContinuousChallengeCell:runThisAnimation(nextIndex)
    self.nextIndex = nextIndex
    self.bg:setVisible(true)
    function callBack2()
        self:runEffert(self.img2, nil , 0.5)
    end

    self:runEffert(cc.CallFunc:create(callBack2))
end

function ContinuousChallengeCell:runEffert(callBack)

    if(callBack~=nil) then
        function toBack()
            self.callBack(self.nextIndex)
        end
        self:runAction(cc.Sequence:create(cc.DelayTime:create(0.4) ,cc.CallFunc:create(toBack)))
    end

end


return ContinuousChallengeCell
