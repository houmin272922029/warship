local Cell = qy.class("Cell", qy.tank.view.BaseView, "offer_a_reward.ui.Cell")

local model = qy.tank.model.OfferARewardModel
local NumberUtil = qy.tank.utils.NumberUtil


function Cell:ctor()
   	Cell.super.ctor(self)

    self:InjectView("Bg")
    self:InjectView("Text_task_name")
    self:InjectView("Text_boss_name")
    self:InjectView("Text_time")
    self:InjectView("Text_reward_num")
    self:InjectView("Text_quality")

    
    
end

function Cell:render(data, idx)
	self.idx = idx

	data.reward = model:getRewardById(data.id)
	data.reward_intell_content = model:getRewardContent()
	data.reward_intell_consume = model:getRewardConsumeById(data.information_id)


	self.Text_task_name:setString(data.reward.title)
	self.Text_boss_name:setString(data.reward.commander)
	self.Text_time:setString(NumberUtil.secondsToTimeStr(data.reward.time, 3))
	self.Text_reward_num:setString("x "..data.reward.military_exploit)
	if data.reward.quality == 1 then
		self.Text_quality:setString("白色")
		self.Text_quality:setColor(cc.c3b(255, 255, 255))
		self.Text_task_name:setColor(cc.c3b(255, 255, 255))
	elseif data.reward.quality == 2 then
		self.Text_quality:setString("绿色")
		self.Text_quality:setColor(cc.c3b(46, 190, 83))
		self.Text_task_name:setColor(cc.c3b(46, 190, 83))
	elseif data.reward.quality == 3 then
		self.Text_quality:setString("蓝色")
		self.Text_quality:setColor(cc.c3b(36, 174, 242))
		self.Text_task_name:setColor(cc.c3b(36, 174, 242))
	elseif data.reward.quality == 4 then
		self.Text_quality:setString("紫色")
		self.Text_quality:setColor(cc.c3b(172, 54, 249))
		self.Text_task_name:setColor(cc.c3b(172, 54, 249))
	elseif data.reward.quality == 5 then
		self.Text_quality:setString("橙色")
		self.Text_quality:setColor(cc.c3b(255, 153, 0))
		self.Text_task_name:setColor(cc.c3b(255, 153, 0))
	end

	self.data = data
end

function Cell:getCellData()
	return self.data

end


function Cell:getCellIdx()
	return self.idx

end


function Cell:hightLight()
	self.Bg:setColor(cc.c4b(100,100,100,255))
	self.Bg:setOpacity(180)
    self.Bg:setScale(0.95)
end

function Cell:unhightLight()
	self.Bg:setColor(cc.c4b(150,150,150,255))
	 
	self.Bg:setColor(cc.c4b(255,255,255,255))
	self.Bg:setOpacity(255)
    self.Bg:setScale(1)
end



return Cell