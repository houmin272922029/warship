

local MainDialog = qy.class("MainDialog", qy.tank.view.BaseDialog, "taste_war/ui/MainDialog")

local StorageModel = qy.tank.model.StorageModel
local userInfoModel = qy.tank.model.UserInfoModel
local service = qy.tank.service.TasteWarService
local garageModel = qy.tank.model.GarageModel

function MainDialog:ctor(delegate)
    MainDialog.super.ctor(self)
    self.model = qy.tank.model.TasteWarModel
    local style = qy.tank.view.style.ViewStyle1.new({
        titleUrl = "taste_war/res/zongweizhengba.png",
        ["onExit"] = function()
            self:removeSelf()
        end
    })
    -- cc.SpriteFrameCache:getInstance():addSpriteFrames("taste_war/res/tastewar.plist")
    qy.tank.utils.cache.CachePoolUtil.addArmatureFileByModules("taste_war/fx/ui_fx_warboom")
    self:addChild(style, 13)
	self:InjectView("time")--时间
	self:InjectView("shopBt")
	self:InjectView("helpBt")
	self:InjectView("freetimes")--次数
	self:InjectView("winimg1")
    self:InjectView("winimg2")
    self.winimg2:setVisible(false)
    self.winimg1:setVisible(false)
	self:InjectView("AttBt")
	for i=1,2 do
        self:InjectView("joinBt"..i)
        self:InjectView("jindu"..i)
        self:InjectView("baifenbi"..i)
        self:InjectView("zhandouli"..i)
        self:InjectView("jidi"..i)
        self:InjectView("tank"..i)
        self:InjectView("tank"..i)
        self:InjectView("total"..i)--总积分
        self:InjectView("text"..i)--显示阵营或者我的积分

    end
    for i=1,6 do
    	self:InjectView("tank1_"..i)
    	self["tank1_"..i]:setScaleX(-0.9)
    end
    for i=1,6 do
    	self:InjectView("tank2_"..i)
    end
    self:OnClick("helpBt",function()
        qy.tank.view.common.HelpDialog.new(48):show(true)
    end)
    self:OnClick("joinBt1", function(sender)
        if self.model:getStatus() == true then
            qy.hint:show("活动已结束")
            return
        end
    	service:jointeam("tian",function (  )
            self:updatefight()
            self:updatejifen()
        end)
    end)
    self:OnClick("joinBt2", function(sender)
         if self.model:getStatus() == true then
            qy.hint:show("活动已结束")
            return
        end
        service:jointeam("xian",function (  )
            self:updatefight()
            self:updatejifen()
        end)
    end)
    self:OnClick("AttBt", function(sender)
        if self.model:getStatus() == true then
            qy.hint:show("活动已结束")
            return
        end
        if self.model.att_nums <= 0 then
            self:buy()
        else
            service:attack(function (  )
            self:showeffect()
            self:updatefight()
            self:updatejifen()
        end)
        end
    
    end)

	self:OnClick("shopBt", function(sender)
        local dialog = require("taste_war.src.ShopDialog").new({
        	["callback"] = function (  )
        		self:updatejifen()
        	end
        	})
        dialog:show(true)
    end)
    self:updatetanks()
    self:updatefight()
    self:updatejifen()
    

end
function MainDialog:updatejifen(  )
	
    if self.model.team == nil or self.model.team == "" then
        self.text1:setString("甜粽子指挥部")
        self.text2:setString("咸粽子指挥部")
        self.jidi1:setVisible(true)
        self.jidi2:setVisible(true)
        self.AttBt:setVisible(false)
        self.freetimes:setVisible(false)
        self.tank1:setVisible(false)
        self.tank2:setVisible(false)
        self.joinBt2:setVisible(true)
        self.joinBt1:setVisible(true)
    elseif self.model.team == "tian" then
        self.text1:setString("我的积分:"..self.model.score)
        self.text2:setString("咸粽子指挥部")
        self.jidi1:setVisible(false)
        self.jidi2:setVisible(true)
        self.AttBt:setVisible(true)
        self.freetimes:setVisible(true)
        self.tank1:setVisible(true)
        self.tank2:setVisible(false)
        self.joinBt2:setVisible(false)
        self.joinBt1:setVisible(false)
    else
        self.text1:setString("甜粽子指挥部")
        self.text2:setString("我的积分:"..self.model.score)
        self.jidi1:setVisible(true)
        self.jidi2:setVisible(false)
        self.AttBt:setVisible(true)
        self.freetimes:setVisible(true)
        self.tank1:setVisible(false)
        self.tank2:setVisible(true)
        self.joinBt2:setVisible(false)
        self.joinBt1:setVisible(false)
    end
    if self.model:getStatus() == true then
        self.freetimes:setVisible(false)
    end
end
function MainDialog:updatefight(  )
	self.freetimes:setString("剩余次数:"..self.model.att_nums)
	local total  = self.model.team_score.xian + self.model.team_score.tian
	local jifen1 = self.model.team_score.tian
	local jifen2 = self.model.team_score.xian
    if total ~= 0 then
    	local num1 = string.format("%.2f", jifen1 /total * 100) 
    	local num2 = string.format("%.2f", jifen2 /total * 100) 
    	local num3 = string.format("%.2f", jifen1 /total ) 
    	local num4 = string.format("%.2f", jifen2 /total ) 
    	self.jindu1:setScaleX(num3)
    	self.jindu2:setScaleX(num4)
    	self.baifenbi1:setString(num1.."%")
    	self.baifenbi2:setString(num2.."%")
        else
            self.jindu1:setScaleX(0.5)
            self.jindu2:setScaleX(0.5)
            self.baifenbi1:setString("50.00%")
            self.baifenbi2:setString("50.00%")
        end
	self.total1:setString("总积分:"..jifen1)
	self.total2:setString("总积分:"..jifen2)
    if self.model:getStatus() == true then
        self.winimg1:setVisible(jifen1>jifen2)
        self.winimg2:setVisible(jifen1<jifen2)
    end
end
function MainDialog:showeffect(  )
    local Positionx = 0
    if self.model.team == "tian" then
        Positionx = 850
    else
        Positionx = 230
    end
	local effertArr = ccs.Armature:create("ui_fx_warboom")
    effertArr:setPosition(120,100)
    if self.model.team == "tian" then
        Positionx = 850
         self.jidi2:addChild(effertArr,999)
    else
        Positionx = 230
       self.jidi1:addChild(effertArr,999)
    end
    effertArr:getAnimation():playWithIndex(0)
    -- self.model:Gettextbyid(2)
    local freetimes = ccui.Text:create()
    freetimes:setFontName("Resources/font/ttf/black_body.TTF")
    freetimes:setFontSize(28)
    freetimes:setString(self.model:Gettextbyid(1))
    local num1 =  math.random(230, 310)
    freetimes:setPosition(num1,350)
    freetimes:setColor(cc.c3b(245, 172, 13))
    self:addChild(freetimes)
    local moveUp = cc.MoveBy:create(1.0, cc.p(0, math.random(150, 200)))
    local actionback = function (  )
        freetimes:removeFromParent()
    end
    freetimes:runAction(cc.Sequence:create(moveUp,cc.CallFunc:create(actionback)))

    local freetimes2 = ccui.Text:create()
    freetimes2:setFontName("Resources/font/ttf/black_body.TTF")
    freetimes2:setFontSize(28)
    freetimes2:setString(self.model:Gettextbyid(2))
    local num2 =  math.random(830, 930)
    freetimes2:setPosition(num2,350)
    freetimes2:setColor(cc.c3b(19, 172, 199))
    self:addChild(freetimes2)
    local moveUp2 = cc.MoveBy:create(1.0, cc.p(0,math.random(150, 200)))
    local actionback2 = function (  )
        freetimes2:removeFromParent()
    end
    freetimes2:runAction(cc.Sequence:create(moveUp2,cc.CallFunc:create(actionback2)))
end
function MainDialog:buy()
	local buyDialog = require("taste_war.src.PurchaseDialog").new(function(num)
        service:Buytime(num,function(data)
           	self.freetimes:setString("剩余次数:"..num)
        end)
    end)
    buyDialog:show(true)
	-- body
end
function MainDialog:updatetanks( id )
	for i=1,2 do
		self["zhandouli"..i]:setString("战斗力:"..userInfoModel.userInfoEntity.fightPower)
	end
	for i = 1, 6 do
  		local icon 
        if type( garageModel.formation[i]) == "table" then
        	local tank_id = garageModel.formation[i].tank_id
        	icon = qy.tank.model.GarageModel:getLittleIconByTankId(tank_id)
    	else
    		icon = "Resources/common/bg/c_11.png"
    	end
        self["tank1_"..i]:setTexture(icon)
        self["tank2_"..i]:setTexture(icon)
    end
end


function MainDialog:onEnter()
    
	if self.model.endtime - qy.tank.model.UserInfoModel.serverTime <= 0 then
         self.time:setString("活动已结束")
    else
    	self.time:setString("活动结束时间:"..qy.tank.utils.DateFormatUtil:toDateString(self.model.endtime - qy.tank.model.UserInfoModel.serverTime, 7))
    	self.listener_1 = qy.Event.add(qy.Event.BONUS_TIME,function(event)
        self.time:setString("活动结束时间:"..qy.tank.utils.DateFormatUtil:toDateString(self.model.endtime - qy.tank.model.UserInfoModel.serverTime, 7))
    end)
    end
 
    
end

function MainDialog:onExit()
	-- qy.tank.utils.cache.CachePoolUtil.removeArmatureFileByModules("war_group/fx/ui_fx_warboom")
    qy.Event.remove(self.listener_1)
  
end


return MainDialog
