--[[--
--拜访名将dialog
--Author: lianyi
--Date: 2015-06-29
--]]--

local VisitGeneralDialog = qy.class("VisitGeneralDialog", qy.tank.view.BaseView, "view/operatingActivities/visitGeneral/VisitGeneralDialog")

function VisitGeneralDialog:ctor(delegate)
    VisitGeneralDialog.super.ctor(self)
	self.model = qy.tank.model.OperatingActivitiesModel
	
	self:InjectView("getTxt1")
	self:InjectView("getTxt2")
	self:InjectView("getTxt3")
	self:InjectView("needTxt1")
	self:InjectView("needTxt2")
	self:InjectView("needTxt3")
	self:InjectView("timeTxt")

	self:OnClick("visitBtn1",function(sender)
		self:getAward(1)
	end)

	self:OnClick("visitBtn2",function(sender)
		self:getAward(2)
	end)

	self:OnClick("visitBtn3",function(sender)
		self:getAward(3)
	end)

	-- 初始化配置信息
	local itemData
	for i=1,3 do
		itemData = self.model:getVisiGeneralConfigItemDataById(i)
		self:findViewByName("getTxt"..i):setString("x"..itemData.award[1].num)
	end
	self:createTimer1()
	self:updateHValue()
end

function VisitGeneralDialog:getAward(id)
	local service = qy.tank.service.OperatingActivitiesService
		service:getCommonGiftAward(id, "visit_general", true, function(reData)
			-- local itemData = self.model:getVisiGeneralConfigItemDataById(id)
			-- local awardItem = qy.tank.view.common.AwardItem.createAwardView(itemData.award[1] , 1 , 1)
			-- self:addChild(awardItem)
			-- local name = awardItem:getTitle()
			--qy.hint:show("获得"..name.."x"..itemData.award[1].num)
			qy.tank.model.OperatingActivitiesModel:updateVisitGeneralData(reData)
			self:updateHValue()
		end)	
end

function VisitGeneralDialog:createTimer1()
    local remainTime1 = self.model:getVisitGeneralLeftTime()
   
    if remainTime1 <=0 then 
        self:clearTimer()
        self:updateLeftTime(0)
        return
    end
    if self.timer1 == nil then
        self.timer1 = qy.tank.utils.Timer.new(1,remainTime1,function(leftTime)
            self:updateLeftTime(leftTime)
        end)
        self.timer1:start()
    end
    self:updateLeftTime(remainTime1)
end

--更新剩余时间
function VisitGeneralDialog:updateLeftTime( leftTime)
    if leftTime == 0 then     
        self:clearTimer()
        self.timeTxt:setString(qy.TextUtil:substitute(63027)..leftTime)
    else   
       local timeStr = qy.tank.utils.DateFormatUtil:toDateString(leftTime , 1)
        self.timeTxt:setString(qy.TextUtil:substitute(63027)..timeStr)
    end
end

function VisitGeneralDialog:updateHValue()
	local value
	for i=1,3 do
		value = self.model:getVisitGeneralUserListItemValueById(i)
		self:findViewByName("needTxt"..i):setString("x"..value)
	end

	
end

-- 清除时钟
function VisitGeneralDialog:clearTimer( )
    if self.timer1 ~=nil then
        self.timer1:stop()
    end   
    
    self.timer1 = nil
end

function VisitGeneralDialog:onExit()
    self:clearTimer()
end

return VisitGeneralDialog