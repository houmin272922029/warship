friendData = {
	friends = {}
}
-- 获得好友数目	
function friendData:getFriendCount( )
	return getMyTableCount(friendData.friends)
end

function friendData:isFriend( uid )
	for k,v in pairs(friendData.friends) do
		if tonumber(v.id) == tonumber(uid) then
			return 1
		end
	end
	return 0
end

function friendData:resetFriendData(  )
	friendData.friends = {}
end

