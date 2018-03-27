local BossDialog = qy.class("BossDialog", qy.tank.view.BaseView, "attack_berlin.ui.BossDialog")


local model = qy.tank.model.AttackBerlinModel
local service = qy.tank.service.AttackBerlinService
function BossDialog:ctor(delegate)
   	BossDialog.super.ctor(self)
    local style = qy.tank.view.style.ViewStyle1.new({
        titleUrl = "attack_berlin/res/weigongbolin.png",
        ["onExit"] = function()
            qy.Event.dispatch(qy.Event.ATTACKBERLIN2)
            self:removeSelf()
        end
    })
    self:addChild(style, 13)
   	self:InjectView("awardbg")
    self:InjectView("times")
    self:InjectView("AttackBt")
    self:InjectView("zhanbaoBt")
    self:InjectView("closeBt")
    self:InjectView("name")
    self:InjectView("yigongpo")
    self:InjectView("awardBt")

    self:OnClick("closeBt", function()
        self:removeSelf()
    end,{["isScale"] = false})
    self:OnClick("awardBt", function()
        require("attack_berlin.src.Tip").new({
            ["ids"] = delegate.data.award_id,
            ["types"] = 2,
            }):show()
    end,{["isScale"] = false})
    self:OnClick("AttackBt", function()
        if model.bossis_conquer == 1 then
            qy.hint:show("BOSS已被击破")
            return
        end
        if model:getpower() ~= 1 then
            qy.hint:show("无攻打权限")
            return
        end
        if model.bosstimes <= 0 then
            qy.hint:show("攻打次数不足")
            return
        end
        service:Bossstart(self.data[1].copy_id,self.data[1].id,function (  )
            delegate:callback()
            self:updatetimes()
        end)
    end,{["isScale"] = false})

    self:OnClick("zhanbaoBt", function()
        local view = require("attack_berlin.src.RecordDialog").new({
            ["types"] = 2,
            })
         self:addChild(view)
    end,{["isScale"] = false})
     self:OnClick("helpBt",function()
        qy.tank.view.common.HelpDialog.new(50):show(true)
    end)
    self.data = model:getBossByid(delegate.data.id)
    self:updatetimes()
    self:update()
end
function BossDialog:updatetimes(  )
    -- self.AttackBt:setVisible(model:getpower() == 1 )
    self.times:setString("进攻次数:"..model.bosstimes.."/"..model.bossnums)
    self.yigongpo:setVisible(model.bossis_conquer == 1)
end
function BossDialog:update()
    self.name:setString(self.data[1].name)
    local awards = self.data[1].award
    for i=1,#awards do
        local item = qy.tank.view.common.AwardItem.createAwardView(awards[i], 1)
        item:setPosition( 100 *i -50,42)
        item:showTitle(false)
        item:setScale(0.7)
        self.awardbg:addChild(item,99,99)
    end
    -- local items = require("attack_berlin.src.Awarditem").new({
    --       ["ids"] = self.data[1].award_id,
    --       ["types"] = 1,
    -- })
    -- self.awardbg:addChild(items,99,99)
    -- items:setScale(0.88)
    -- items:setPosition(-50 + (#awards + 1) * 100,42)
end


return BossDialog
