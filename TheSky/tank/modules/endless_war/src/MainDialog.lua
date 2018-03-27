

local MainDialog = qy.class("MainDialog", qy.tank.view.BaseDialog, "endless_war/ui/MainDialog")

local StorageModel = qy.tank.model.StorageModel
local userInfoModel = qy.tank.model.UserInfoModel
local service = qy.tank.service.EndlessWarService
local garageModel = qy.tank.model.GarageModel

function MainDialog:ctor(delegate)
    MainDialog.super.ctor(self)
    self.model = qy.tank.model.EndlessWarModel
    qy.tank.utils.cache.CachePoolUtil.addArmatureFileByModules("endless_war/fx/ui_fx_warboom")
	self:InjectView("zhandouli1")
	self:InjectView("zhandouli2")
    self:InjectView("tankbgs")
    self:InjectView("tank_node1")
    self:InjectView("tank_node2")
    self:InjectView("fightname")
    self:InjectView("parts")
    self:InjectView("nums")
    self:InjectView("rankBt")
    self:InjectView("getawardBt")
    self:InjectView("quickBt")
    self:InjectView("bossBt")
    self:InjectView("closeBt")

    self:InjectView("tank1")
    self:InjectView("tank2")
    for i=1,6 do
        self:InjectView("tank1_"..i)
        self["tank1_"..i]:setScaleX(-0.9)
    end
    for i=1,6 do
        self:InjectView("tank2_"..i)
    end
    self.moveDis = 30
    self:OnClick("closeBt", function(sender)
         delegate:finish()
    end,{["isScale"] = false})
    self:OnClick("getawardBt", function(sender)
        service:getAward(function (  )
            self:updatescore()
        end)
    end)
    self:OnClick("bossBt", function(sender)
        -- if self.model.score > 0 then
        --     qy.hint:show("累积战利品为0方可挑战BOSS，请先领取战利品")
        --     return
        -- end
        service:Tobattle(function (  )
            self.data = self.model:getdataByid()
            self:updates()
            self:updatescore()
        end)
    end)
    self:OnClick("quickBt", function(sender)
        local num  = self.model:getnumByvip()-self.model.buytimes
        if num <= 0 then
            qy.hint:show("加速次数不足")
            return
        end
        if self.model.score >= 100 then
            qy.hint:show("战利品数量已达上限，请先领取战利品")
            return
        end
        local buyDialog = require("endless_war.src.BuyDialog").new({
            ["callback"]= function (  )
                self:updates()
                self:updatescore()
            end
            })
        buyDialog:show(true)
    end)

	self:OnClick("rankBt", function(sender)
        service:getRankList(function (  )
             local dialog = require("endless_war.src.LeaderboardDialog").new()
            dialog:show(true)
        end)
    end)
    self.data = self.model:getdataByid()
    self:update()
    self:updates()
    self:updatescore()
    self:updatetank2()
    

end
function MainDialog:update(  )
    self.zhandouli1:setString(userInfoModel.userInfoEntity.name)
    for i = 1, 6 do
        local icon 
        if type( garageModel.formation[i]) == "table" then
            local tank_id = garageModel.formation[i].tank_id
            icon = qy.tank.model.GarageModel:getLittleIconByTankId(tank_id)
        else
            icon = "Resources/common/bg/c_11.png"
        end
        self["tank1_"..i]:setTexture(icon)
    end
 
end
function MainDialog:updates(  )
    for i=1,6 do
        local ids = self.data["monster"..i]
        local tank_id = self.model.mosterdata[tostring(ids)].icon
        local icon = qy.tank.model.GarageModel:getLittleIconByTankId(tank_id)
        self["tank2_"..i]:setTexture(icon)
    end
    self.zhandouli2:setString(self.data.monster_name)
    self.fightname:setString(self.data.name)
    self.parts:setString(self.data.desc)
    local nextid = self.data.next_id
    self.bossBt:setBright(nextid ~= 0)
    self.bossBt:setTouchEnabled(nextid ~= 0)
end
function MainDialog:updatescore(  )

    self.nums:setString(self.model.score)
end
function MainDialog:updatetank2(  )
    self.tank2:setPositionX(1100)
    local moveto = cc.MoveBy:create(1.0,cc.p(-480,0))
    local func2 = cc.CallFunc:create(function()

        local move1 = cc.MoveBy:create(0.3,cc.p(self.moveDis,0))
        local move2 = cc.MoveBy:create(0.3,cc.p(-self.moveDis,0))
        local func = cc.CallFunc:create(function()
            local effertArr = ccs.Armature:create("ui_fx_warboom")
            effertArr:setPosition(485,115)
            self.tankbgs:addChild(effertArr,999)
            effertArr:getAnimation():playWithIndex(0)
        end)
        local spawn = cc.Spawn:create(move1,func)
        local seq = cc.Sequence:create(move1,move2,spawn,move2)
        self.tank_node1:runAction(seq)
        local move1_1 = cc.MoveBy:create(0.3,cc.p(-self.moveDis,0))
        local move2_1 = cc.MoveBy:create(0.3,cc.p(self.moveDis,0))
        local func1 = cc.CallFunc:create(function()
            self.tank2:setPositionX(1100)
        end)
        local spawn1 = cc.Spawn:create(move2_1,func1)
        local seq1 = cc.Sequence:create(move1_1,move2_1,move1_1,move2_1,func1)
        self.tank_node2:runAction(seq1)
    end)
    local spawn2 = cc.Spawn:create(moveto,func2)
    local seq2 = cc.Sequence:create(moveto,func2,cc.DelayTime:create(1.2))
    self.tank2:runAction(cc.RepeatForever:create(seq2))
end

function MainDialog:onEnter()
    local scheduler = cc.Director:getInstance():getScheduler()  
    self.schedulerID = nil  
    self.schedulerID = scheduler:scheduleScriptFunc(function()  
        if self.model.score <= 100 then
            service:get(function (  )
                self:updatescore()
            end)
        end
    end,300,false) 
end

function MainDialog:onExit()
    cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
  
end


return MainDialog
