--[[--
--总部支援dialog
--Author: lianyi
--Date: 2015-06-29
--]]--

local HeadquartersSupportDialog = qy.class("HeadquartersSupportDialog", qy.tank.view.BaseDialog, "view/operatingActivities/headquartersSupport/HeadquartersSupportDialog")

function HeadquartersSupportDialog:ctor()
    HeadquartersSupportDialog.super.ctor(self)
	self.model = qy.tank.model.OperatingActivitiesModel 
	--通用弹窗样式
	local style = qy.tank.view.style.DialogStyle3.new({
		size = cc.size(647,535),
		position = cc.p(0,0),
		offset = cc.p(0,0), 
		titleUrl = "Resources/common/title/zongbuzhiyuan.png",


		["onClose"] = function()
			self:dismiss()
		end
	})

	self:addChild(style, -1)

	local view = qy.tank.view.operatingActivities.headquartersSupport.PicView.new()
	view:setPosition(314, 387)
	-- local sprite = cc.Sprite:create("Resources/operatingActivities/headquartersSupport/support_0006.png")
	style.bg:addChild(view)
	
	self:InjectView("timeTxt")
	self:InjectView("getBtn")
	self:InjectView("itemContainer")
	self:OnClick("getBtn",function(sender)
		local service = qy.tank.service.OperatingActivitiesService
		service:getCommonGiftAward(nil, "headquarters_support", true, function(reData)
			self.model:updateHeadquartersData(reData)
			self:update()
		end)
	end, {["isScale"] = true})
	self:update()
end

function HeadquartersSupportDialog:showList(  )
	-- local x = 1
end

function HeadquartersSupportDialog:create()
	self:createTimer1()
end

function HeadquartersSupportDialog:showOrHideBtn( show)
	self.timeTxt:setVisible(not show)
	self.getBtn:setVisible(show)
end

--创建定时器1
function HeadquartersSupportDialog:createTimer1()
    local remainTime1 = self.model:getHeadquartersLeftTime()
   
    if remainTime1 <=0 then 
        -- self:clearTimer()
        self:showOrHideBtn(true)
        self:updateLeftTime(0)
        return
    end
    if self.timer1 == nil then
    	self:showOrHideBtn(false)
        self.timer1 = qy.tank.utils.Timer.new(1,remainTime1,function(leftTime)
            self:updateLeftTime(leftTime)
        end)
        self.timer1:start()
    end
    self:updateLeftTime(remainTime1)
end

--更新剩余时间
function HeadquartersSupportDialog:updateLeftTime(leftTime)
    if leftTime == 0 then        
        self:clearTimer()
        self.timeTxt:setString("")
    else
       local timeStr = qy.tank.utils.DateFormatUtil:toDateString(leftTime , nil)
        self.timeTxt:setString(timeStr)
    end
end

function HeadquartersSupportDialog:update( )
	self:createTimer1()
	self:showAwards()
end

function HeadquartersSupportDialog:showAwards( )
	self.itemContainer:removeAllChildren(true)
	local awards = self.model:getHeadquartersShowList()["award"]	
	-- table.insert(awards , {["type"] = 3 , ["num"] = 100})
	for i=1,#awards do
		local item = qy.tank.view.common.AwardItem.createAwardView(awards[i] ,1)
		 self.itemContainer:addChild(item)
		 item:setPosition( (i-1) *150, 0 )
		 self.itemContainer:setPosition( 150 + (1-i) *150, -50.00)
	end
   -- awardList:setPosition(0,-awardList:getHeight())
end

-- 清除时钟
function HeadquartersSupportDialog:clearTimer( )
    if self.timer1 ~=nil then
        self.timer1:stop()
    end   
    
    self.timer1 = nil
end

function HeadquartersSupportDialog:onExit()
	self:clearTimer()
end

return HeadquartersSupportDialog