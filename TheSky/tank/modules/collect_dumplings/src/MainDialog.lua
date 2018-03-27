

local MainDialog = qy.class("MainDialog", qy.tank.view.BaseDialog, "collect_dumplings/ui/MainDialog")

local StorageModel = qy.tank.model.StorageModel
local userInfoModel = qy.tank.model.UserInfoModel
local service = qy.tank.service.CollectDumpingsService

function MainDialog:ctor(delegate)
    MainDialog.super.ctor(self)
    self.model = qy.tank.model.CollectDumpingsModel
	self:InjectView("closeBt")
	self:InjectView("time")--时间
	self:InjectView("shopBt")
	self:InjectView("helpBt")
	self:InjectView("freetimes")
	for i=1,3 do
        self:InjectView("fightBt"..i)
        self:InjectView("saodangBt"..i)
        self:InjectView("totalnum"..i)
        self:InjectView("fightimg"..i)
    end
    self:OnClick("helpBt",function()
        qy.tank.view.common.HelpDialog.new(47):show(true)
    end)
	self:OnClick("closeBt", function(sender)
        self:removeSelf()
    end)
    self:OnClick("fightBt1", function(sender)
    	if self.type1 == 0 then
    		self:fight1(1,128)
		else
			self:saodang1(10,1,128)
		end
    end)
    self:OnClick("fightBt2", function(sender)
    	if self.type2 == 0 then
    		self:fight(2,129)  
		else
			self:saodang(10,2,129)
		end
    end)
    self:OnClick("fightBt3", function(sender)
    	if self.type3 == 0 then
    		self:fight(3,130)
		else
			self:saodang(10,3,130)
		end
    end)
    self:OnClick("saodangBt1", function(sender)
       self:saodang1(1,1,128)
    end)
    self:OnClick("saodangBt2", function(sender)
         self:saodang(1,2,129)
    end)
    self:OnClick("saodangBt3", function(sender)
         self:saodang(1,3,130)
    end)

	self:OnClick("shopBt", function(sender)
        local dialog = require("collect_dumplings.src.ShopDialog").new()
        dialog:show(true)
    end)
    self.type1 = 0
    self.type2 = 0
    self.type3 = 0
    self:uptatestatus()
 
end
function MainDialog:fight1( ids ,propid)
	local data = self.model.list
	local freetime = self.model.free_time - data["1"].attack_num
	if StorageModel:getPropNumByID(propid) <=0 and freetime <= 0 then
		self:Buy(1,128)
	else
		service:Attack(ids,propid,function (  )
			self:uptatestatus()
		end)
	end
end
function MainDialog:fight( ids ,propid)
	if StorageModel:getPropNumByID(propid) <=0 then
		self:Buy(ids,propid)
	else
		service:Attack(ids,propid,function (  )
			self:uptatestatus()
		end)
	end
end
function MainDialog:saodang1(times, ids ,propid)
	local data = self.model.list
	local freetime = self.model.free_time - data["1"].attack_num
	if StorageModel:getPropNumByID(propid) <=0 and freetime <= 0 then
		self:Buy(1,128)
	else
		service:saodang(times,ids,propid,function (  )
			self:uptatestatus()
		end)
	end
end
function MainDialog:saodang(times, ids ,propid)
	if StorageModel:getPropNumByID(propid) <=0 then
		self:Buy(ids,propid)
	else
		service:saodang(times,ids,propid,function (  )
			self:uptatestatus()
		end)
	end
end
function MainDialog:uptatestatus(  )
	local data = self.model.list
	self:updatenums()
	local freetime = self.model.free_time - data["1"].attack_num
	self.freetimes:setString("免费次数："..freetime)
	self.freetimes:setVisible(freetime > 0)
	for i=1,3 do
		self["saodangBt"..i]:setEnabled(data[tostring(i)].challenge_num > 0)
		self["saodangBt"..i]:setBright(data[tostring(i)].challenge_num > 0)
		if data[tostring(i)].challenge_num > 0 then
			self["fightimg"..i]:setSpriteFrame("collect_dumplings/res/saodangshici.png")
			self["type"..i] = 1
		else
			self["fightimg"..i]:setSpriteFrame("collect_dumplings/res/tiaozhan.png")
			self["type"..i] = 0
		end
	end

end
function MainDialog:Buy( type,id )
	local entity = qy.Config.props
	local data  = entity[tostring(id)]
    local buyDialog = require("collect_dumplings.src.PurchaseDialog").new(type,data,function(num)
        service:buyProp(type,num,function(data)
        
            -- if data and data.consume then
            --     qy.hint:show(qy.TextUtil:substitute(12002).."x"..data.consume.num)
            -- end

           	self:updatenums()
        end)
    end)
    buyDialog:show(true)
end
function MainDialog:updatenums(  )
	self.totalnum1:setString(StorageModel:getPropNumByID(128))
	self.totalnum2:setString(StorageModel:getPropNumByID(129))
	self.totalnum3:setString(StorageModel:getPropNumByID(130))
end

function MainDialog:onEnter()
	if self.model.endtime - qy.tank.model.UserInfoModel.serverTime <= 0 then
         self.time:setString("活动已结束")
    else
    	self.time:setString(qy.tank.utils.DateFormatUtil:toDateString(self.model.endtime - qy.tank.model.UserInfoModel.serverTime, 7))
    	self.listener_1 = qy.Event.add(qy.Event.BONUS_TIME,function(event)
        self.time:setString(qy.tank.utils.DateFormatUtil:toDateString(self.model.endtime - qy.tank.model.UserInfoModel.serverTime, 7))
    end)
    end
 
    
end

function MainDialog:onExit()
    qy.Event.remove(self.listener_1)
  
end


return MainDialog
