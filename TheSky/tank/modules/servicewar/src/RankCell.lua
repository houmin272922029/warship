--[[--
	跨服排名cell
--]]--

local RankCell = qy.class("RankCell", qy.tank.view.BaseView, "servicewar.ui.RankCell")

local model = qy.tank.model.ServiceWarModel
local userModel = qy.tank.model.UserInfoModel

function RankCell:ctor(delegate)
	RankCell.super.ctor(self)

	self:InjectView("rank")
    self:InjectView("service")
    self:InjectView("player")
    self:InjectView("yazhu")
    self:InjectView("attack")
    self:InjectView("albet")

    self.delegate = delegate
end
	
function RankCell:setData(data)
	self.data = data
	self.rank:setString(self.data.currentranking .. ".")
	self.service:setString("【".. self.data.serviceid .. "】")
	self.player:setString(self.data.nickname)
	self:judgeStatus()
end

function RankCell:judgeStatus()
	if self.data.kid == userModel.kid then
    	self.player:setTextColor(cc.c4b(0, 255, 0, 255))
    else
    	self.player:setTextColor(cc.c4b(255, 255, 255, 255))
    end
	local function setIconVisible()
		self.yazhu:setVisible(false)
		self.albet:setVisible(false)
		self.attack:setVisible(false)
	end
	if model.userinfo.role == 100 then  --参赛者
		setIconVisible()
		if self.data.is_hit == 100 then  --可攻打
			self.attack:setVisible(true)
			self:OnClick("attack", function(sender)
				if self.data.is_hit == 100 and model.userinfo.remaining >= 1 then  --可攻打
		            local service = qy.tank.service.ServiceWarService
		                  service:Battle(self.data.kid, model.userinfo.currentranking, self.data.currentranking, function(data)
		                  qy.tank.manager.ScenesManager:pushScene(qy.tank.view.scene.BattleScene.new())
		                  self.delegate.tableView:reloadData()
		            end)
		        else
		            qy.hint:show(qy.TextUtil:substitute(90063))
	        	end
			end)
		end
	elseif model.userinfo.role == 200 and model.userinfo.is_bet == 100 then  --普通用户
	 	setIconVisible()
	 	if self.data.is_bet == 100 then
	 		self.yazhu:setVisible(true)
	 	end
	elseif model.userinfo.role == 200 then
		setIconVisible()
	    if model.userinfo.is_bet ~= 100 then   --未押注
			self.albet:setVisible(true)
			self:OnClick("albet", function(sender)
	        	function callBack(flag)
			        if flag == qy.TextUtil:substitute(21004) then
			            local service = qy.tank.service.ServiceWarService
			            	service:Bet(self.data.kid,function(data)
			            		-- model:setAllAttendListNotBet()
			            		-- self.data.is_bet = 200
			              		qy.Event.dispatch(qy.Event.SERVICE_WAR)	
			              		-- qy.Event.dispatch(qy.Event.SERVICE_WARVIEW) 
			            end)
			        end
			    end
	        local alertMesg = qy.TextUtil:substitute(90064)
	        	qy.alert:show({qy.TextUtil:substitute(90065), {255,255,255}},  alertMesg, cc.size(465, 260), {{qy.TextUtil:substitute(21003), 4}, {qy.TextUtil:substitute(21004), 5}}, callBack, "")
	    	end)
		else --已押注
			self.yazhu:setVisible(true)
			self.albet:setVisible(false)
		end
	end
end
function RankCell:onEnter()
	self:judgeStatus()
end

function RankCell:onExit()
	
end
return RankCell