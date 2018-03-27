--[[
    群战流程管理器
    Author: H.X.Sun
]]

local GroupWarManager = class("GroupWarManager")

function GroupWarManager:start(c)
	self.view = c
	self.model = qy.tank.model.WarGroupModel
    self:next(self.model.TRACK_1)
    self:next(self.model.TRACK_2)
    self:next(self.model.TRACK_3)
end

function GroupWarManager:next(_track)
	print("next=====>>>",_track)
	local round = self.model:getTrackRound(_track)
	if round <= 1 then
		if not self.model:getStopStatusByIndex(_track) then
		    local data = self.model:getBattleDataByIndex(_track)
		    if data then
				self.model:setTrackRound(_track,#data.fight_data.fight)
		        self:playNext(data,_track)
		    end
		end
		self.view:updateMemberList()
	else
		self.model:setTrackRound(_track, round - 1)
		self.view:playNextRound(_track)
	end
end

function GroupWarManager:dealPlay(_prefix,data,_track)
    local isMoved = false
    local last_track = self.model:getIndexByUserFormation(_prefix,data[_prefix .. "_kid"])
    if last_track > 0 and _track ~= last_track then
		self.view:play({
            ["track"] = _track,
            ["battle_data"] = data,
            ["has_Move"] = true,
			["prefix"] = _prefix,
			["track"] = _track,
			["last_track"] = last_track,
        })
        other_track = last_track
        isMoved = true
		self.model:setUserFormation(_prefix,last_track,0)
    end
    self.model:setUserFormation(_prefix,_track,data[_prefix .. "_kid"])

    return isMoved
end

function GroupWarManager:playNext(data, _track)
    local otherAttTrack = 0
    local otherDefTrack = 0
    local isAttMoved = false
    local isDefMoved = false
    isAttMoved, otherAttTrack = self:dealPlay(self.model.LEFT_KEY,data,_track)
    isDefMoved, otherDefTrack = self:dealPlay(self.model.RIGHT_KEY,data,_track)

    if (not isAttMoved) and (not isDefMoved) then
        self.view:play({
            ["track"] = _track,
            ["battle_data"] = data,
            ["has_Move"] = false,
        })
    end
end

-- function GroupWarManager:nextRound()
--
-- end

return GroupWarManager
