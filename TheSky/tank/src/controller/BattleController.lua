--[[
	战斗场景控制器
	Author: Aaron Wei
	Date: 2015-01-14 17:56:59
]]


local BattleController = qy.class("BattleController", qy.tank.controller.BaseController)

function BattleController:ctor()
    BattleController.super.ctor(self)
	self.model = qy.tank.model.BattleModel
	self.manager = qy.tank.manager.BattleRoundManager
    self.viewStack = qy.tank.widget.ViewStack.new()
    self.viewStack:addTo(self)
end

function BattleController:onEnter()
	self.view = qy.tank.view.battle.BattleView.new({
		["onSkip"] = function()
			self.model:skip()
			self.view:skip()
			self.manager:skip()
		end,

		["onEnded"] = function()
			self.manager:stop()
			if self.model.battleData.fight_type == 2 and self.model.battleData.ext.type == 2 then
				-- 经典战役-突破重围
				if self.model.currentIdx < self.model.len then
					local timer = qy.tank.utils.Timer.new(2,1,function()
						self.view:play()
					end)
					timer:start()
				else
					self:delayShowResult()
				end
			else
				self:delayShowResult()
			end
		end
	})
	self.viewStack:push(self.view)
	self.view:init()
	self.model.battleView = self.view

	--用于新手引导显示战斗结算
	if qy.isNoviceGuide then -- |||||||
		if self.showBattleResult == nil then
			self.showBattleResult = qy.Event.add(qy.Event.BATTLE_RESULT,function(event)
    			self:showResult()
			end)
		end
	end
end

function BattleController:onExit()
	if qy.isNoviceGuide then --||||||
		qy.Event.remove(self.showBattleResult)
	end
end

function BattleController:onCleanup()
end

function BattleController:delayShowResult()
	self.timer = qy.tank.utils.Timer.new(1,1,function()
		if qy.isNoviceGuide then --||||||
			--如果是新手引导，则先对话，后弹出结算
			--print("qy.tank.model.GuideModel:getCurrentBigStep()==" .. qy.tank.model.GuideModel:getCurrentBigStep())
			-- if qy.tank.model.GuideModel:getCurrentBigStep() == 1 then
				--第一场战斗没有结算
				-- qy.GuideManager:popContainer()
				-- qy.tank.manager.ScenesManager:popScene()
				-- qy.tank.manager.ScenesManager:showMainScene()
			-- end
            if not self.hasNext then
                qy.GuideManager:next(11)
                self.hasNext = true
            end
		else
			self:showResult()
		end
	end)
	self.timer:start()
end

function BattleController:showResult()
	if not tolua.cast(self.resultView,"cc.Node") then
		local BattleResultView
		-- if qy.tank.utils.SDK:channel() == "xinlang" or "qiyou" then
        if self.model.fight_type == 20 then
            -- 最强之战
            BattleResultView = qy.tank.view.battle.BattleResultView2
		elseif qy.language == "cn" then
			BattleResultView = qy.tank.view.battle.BattleResultView1
		else
			BattleResultView = qy.tank.view.battle.BattleResultView
		end
		self.resultView = BattleResultView.new({
			["share"] = function()
				-- todo

			end,

			["replay"] = function()
				self:removeResult()
				self.view:destroy()
				self.model:reset()
		    	self.view:init()
		    end,

			["confirm"] = function(data)
				self.view:destroy()
				-- self.view:exit()
				qy.GuideManager:popContainer()
				qy.tank.manager.ScenesManager:popScene()

				if qy.isNoviceGuide then --||||||
					local delay = qy.tank.utils.Timer.new(0.2,1,function()
						qy.GuideManager:next(12)
					end)
					delay:start()
				end
				-- qy.QYPlaySound.playMusic(qy.SoundType.CAMP_BG_MS)
	    	end
		})
		-- self:addChild(self.resultView)
		self.resultView:show()
	end
end

function BattleController:removeResult()
	if tolua.cast(self.resultView,"cc.Node") and self.resultView:getParent() then
		self.resultView:getParent():removeChild(self.resultView)
		self.resultView = nil
	end
end

return BattleController
