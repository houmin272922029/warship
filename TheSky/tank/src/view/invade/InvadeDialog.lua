--[[
    伞兵入侵
]]
local InvadeDialog = qy.class("InvadeDialog", qy.tank.view.BaseDialog)

function InvadeDialog:ctor(delegate)
    InvadeDialog.super.ctor(self)
	-- self.model = qy.tank.model.InvadeModel
 --    self.userModel = qy.tank.model.UserInfoModel
    

 --    self:InjectView("enemy1")
 --    -- self:InjectView("enemy2")
 --    -- self:InjectView("enemy3")
 --    -- self:InjectView("enemy4")
 --    self:InjectView("tank")
 --    self:InjectView("eventTitle")
 --    -- self:InjectView("tank3")
 --    -- self:InjectView("tank4")
 --    self:InjectView("cdTitleTxt")
 --    self:InjectView("cdTxt")
 --    self:InjectView("noCdTxt")
 --    self:InjectView("enemyDiamondTxt")
 --    self:InjectView("enemyDiamond")
 --    self:InjectView("doneTxt")
 --    self:InjectView("extraTxt")
 --    self:InjectView("fightBtn")
 --    self:InjectView("chestOnBtn")
 --    self:InjectView("chestOffBtn")
 --    self:InjectView("chestOpenBtn")
	-- self:InjectView("effertNode")

	-- qy.tank.utils.cache.CachePoolUtil.addArmatureFile("fx/ui/campaign/ui_fx_cqyan")

    self.style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(795,510),
        position = cc.p(0,0),
        offset = cc.p(-4,4), 
        titleUrl = "Resources/common/title/sanbingruqin.png",


        ["onClose"] = function()
            self:dismiss()
        end
    })
    self:addChild(self.style , -1)

    local view = qy.tank.view.invade.InvadeDialog2.new(self)

    local winSize = cc.Director:getInstance():getWinSize()
    local fix = (winSize.width - 1080) / 2
    view:setPosition(-150 - fix, -110)
    self.style.bg:addChild(view)
    -- self:updataAll()

    -- self:OnClick(self.chestOnBtn, function(sender)
    --     local service = qy.tank.service.InvadeService
    --     local param = {}
    --     param.id = i
    --     service:getAward(param,function(data)
    --             qy.tank.command.AwardCommand:add(data.award)
    --             qy.tank.command.AwardCommand:show(data.award)
    --             self.userData.is_receive = 1
    --             self:updataAll()
    --     end)
    -- end)

    -- self:OnClick(self.fightBtn, function(sender)
    --     --播放动画过程中点击击退无效
    --     if self.isPlay ~=nil and self.isPlay == true then
    --         return
    --     end

    -- 	local service = qy.tank.service.InvadeService
    --     local param = {}
    --     param.fight_id = self.fightId
    --     service:fight(param , function(data)
    --         if data.win ~=0 then
    --             self.canFightUpdate = true
                
    --         end
    --         qy.tank.model.BattleModel:init(data.fight_result)
            -- -- qy.tank.manager.ScenesManager:pushScene(qy.tank.view.scene.BattleScene.new())
            --     qy.tank.manager.ScenesManager:pushBattleScene()
    --     end)
    -- end)
    -- self.canFightUpdate = false
    -- self.isCreated = true
end

return InvadeDialog