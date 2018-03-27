--[[
	军奥排行tab
	Author: Aaron Wei
	Date: 2016-09-12 18:58:06
]]

local RankView = qy.class("RankView", qy.tank.view.BaseView, "olympic.ui.RankView")

function RankView:ctor(delegate)
	print("RankView:ctor")
	self.model = qy.tank.model.OlympicModel
    RankView.super.ctor(self)

    self:InjectView("myRank")
    self:InjectView("totalScore")
    self:InjectView("duration")

    for i=1,3 do
    	self:InjectView("rank"..i)
	    self:InjectView("server"..i)
	    self:InjectView("player"..i)
	    self:InjectView("num"..i)
	    self:InjectView("score"..i)
    end

	self.delegate = delegate

	self:OnClick("totalRankBtn",function(sender)
		local rank = require("olympic.src.RankListDialog").new()
       	rank:show(true)
	end, {["isScale"] = false})
	
	self:OnClick("awardReviewBtn",function(sender)
	 	local award = require("olympic.src.AwardPreviewDialog").new()
        award:show(true)
	end, {["isScale"] = false})
end

function RankView:render()
	for i=1,3 do
		local data = self.model.rank_list[i]
		if data then

			if data.headicon == "head_1" then
				self["rank"..i]:setSpriteFrame("olympic/res/13.png")
			elseif data.headicon == "head_2" then
				self["rank"..i]:setSpriteFrame("olympic/res/14.png")
			elseif data.headicon == "head_3" then
				self["rank"..i]:setSpriteFrame("olympic/res/11.png")
			elseif data.headicon == "head_4" then
				self["rank"..i]:setSpriteFrame("olympic/res/12.png")
			end

			self["score"..i]:setVisible(true)
			self["server"..i]:setString(data.server.."服")
			self["player"..i]:setString(data.nickname)
			self["num"..i]:setString(data.source)
		else
			self["rank"..i]:setSpriteFrame("olympic/res/1123.png")
			self["score"..i]:setVisible(false)
			self["server"..i]:setString("")
			self["player"..i]:setString("")
			self["num"..i]:setString("")
		end
	end
	self.myRank:setString(tostring(self.model.my_rank))
	self.totalScore:setString(tostring(self.model.total_score))
	self.duration:setString(os.date("%Y年%m月%d日%H:%M:%S",self.model.start_time).."——"..os.date("%Y年%m月%d日%H:%M:%S",self.model.end_time))
end


function RankView:update()
	-- self.myRank:setString(tostring(self.model.my_rank))
	-- self.totalScore:setString(tostring(self.model.total_score))
end

return RankView