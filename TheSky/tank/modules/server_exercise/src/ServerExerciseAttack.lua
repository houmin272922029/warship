local ServerExerciseAttack = qy.class("ServerExerciseAttack", qy.tank.view.BaseView, "server_exercise/ui/ServerExerciseAttack")

local model = qy.tank.model.ServerExerciseModel
local service = qy.tank.service.ServerExerciseService

function ServerExerciseAttack:ctor(delegate)
	ServerExerciseAttack.super.ctor(self)
    self.delegate = delegate

    local style = qy.tank.view.style.ViewStyle1.new({
        titleUrl = "Resources/activity/title_exercise.png",
        ["onExit"] = function()
            delegate.viewStack:pop()
        end
    })
    self:addChild(style, 13)

    self:InjectView("bg")--
    self:InjectView("buzhenBt")--布阵
    self:InjectView("shauxinBt")--刷新
    self:InjectView("zhanbao")--战报
    self:InjectView("challengeBt")--挑战
    self:InjectView("noplayer")
    self.noplayer:setVisible(false)
    self:OnClick("buzhenBt",function()
        qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.EMBATTLE)
    end)
    self:OnClick("shauxinBt",function()
        if model.mainlist.up_num <= 0 then
            qy.hint:show("请先挑战对手")
            return
        end
       service:Changeopponent(function (  )
            if model.mainlist.opponent_uid ~= 0 and model.data.exercise_opponent_info then 
                 
            else
                qy.hint:show("参战人数不足请稍后再试")
            end
             self:createplayer()
       end)
    end)
    self:OnClick("zhanbao",function()
        service:WatchDetailList(200,1,4,function (  )
             local item = require("server_exercise.src.WarDetail").new()
             item:show()
        end)
      
    end)
    self:OnClick("challengeBt",function()
      	local model = qy.tank.model.UserInfoModel
    	if model.userInfoEntity.energy < 10 then
    		 qy.hint:show("体力不足,挑战需要花费10体力")
    		 return
    	end
        service:ToChallenge(function ( data )
            qy.QYPlaySound.pauseMusic()
            local time = 0
            print("状态",data.status)
                     -- status 100 为正常打  200 没有对手 所以我给了用户刷新次数   300对手退赛或不存在 400 对手资源不足
            if data.status == 100 then 
                time = 0.8
                qy.tank.model.BattleModel:initserver(data,1)--跨服专用
                qy.tank.manager.ScenesManager:pushBattleScene()
            elseif data.status == 200 then
                qy.hint:show("没有对手，请手动刷新对手")
            elseif data.status == 300 then
                qy.hint:show("对手已退赛，请手动刷新对手")
            elseif data.status == 400 then
                print("ss")
                qy.hint:show("对手资源不足，请手动刷新对手")
            end
            local delay = cc.DelayTime:create(time)
            local seq = cc.Sequence:create(delay , cc.CallFunc:create(function()
                   self:createplayer()
            end))
            self:runAction(seq)
            
        end)
        
    end)
    self:createplayer()

end
function ServerExerciseAttack:createplayer(  )
    if self.bg:getChildByTag(99) then
            self.bg:removeChildByTag(99,true)
    end
    if self.bg:getChildByTag(100) then
        self.bg:removeChildByTag(100,true)
    end
	local item = require("server_exercise.src.PlayerCell").new({
        ["type"] = 1,
        ["data"] = model.mainlist
        })
	item:setPosition(cc.p(210,75))
	self.bg:addChild(item,2,99)
    if model.mainlist.opponent_uid ~= 0 and model.data.exercise_opponent_info then
        self.noplayer:setVisible(false)
        local item = require("server_exercise.src.PlayerCell").new({
            ["type"] = 2,
            ["data"] = model.oppenentlist
        })
        item:setPosition(cc.p(700,75))
        self.bg:addChild(item,2,100)
    else
        self.noplayer:setVisible(true)
    end
end

return ServerExerciseAttack
