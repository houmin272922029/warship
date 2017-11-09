var FriendModule = {
		/**
		 * 获取好友列表
		 * @param type
		 */
		getFriendList:function(type){
			if (type == "friends") {
				return frienddata.friends.flist;
			} else if(type == "enemy"){
				return frienddata.friends.elist;
			} else if (type == "attention") {
				return frienddata.friends.alist;
			}
		},
		/**
		 * 获得好友数目
		 * @param type
		 */
		getFriendCount:function(type){
			if (type == "friends") {
				return getJsonLength(frienddata.friends.flist);
			} else if(type == "enemy"){
				return getJsonLength(frienddata.friends.elist);
			} else if (type == "attention") {
				return getJsonLength(frienddata.friends.alist);
			}
		},
		/**
		 * 判断某一个玩家是不是好友
		 */
		isFriend:function(uid){
			for (var k in frienddata.friends) {
				if (frienddata.friends[k].id == uid) {
					return 1;
				}
			}
			return 0;
		},
		/**
		 * 重置好友列表
		 */
		resetFriendData:function(){
			frienddata.friends = {};
		},
		/**
		 * 添加好友页面 获取好友列表
		 */
		getFriendListOnAdd:function(){
			return frienddata.friends;
		},
		/**
		 * 添加好友页面 获取好友数
		 */
		getFriendCountOnAdd:function(){
			return getJsonLength(frienddata.friends);
		},
		/**
		 * 网络接口
		 */
		/**
		 * 获取 好友列表信息
		 */
		doOnGetFriendList:function(succ, fail){
			dispatcher.doAction(ACTION.GET_FRIEND_LIST, [], succ, fail);
		},
		/**
		 * 通过等级获取玩家信息
		 */
		doOnGetPlayersByLevel:function(level, succ, fail){
			dispatcher.doAction(ACTION.GETPLAYER_BY_LEVEL, [level], succ, fail);
		},
		/**
		 * 通过名字获取玩家信息
		 */
		doOnPlayerByName:function(name, succ, fail){
			dispatcher.doAction(ACTION.GETPLAYER_BY_NAME, [name], succ, fail);
		},
		/**
		 * 给另一玩家发好友邀请
		 * @param string $friendId
		 */
		doOnInviteFriend:function(friendId, succ, fail){
			dispatcher.doAction(ACTION.INVITE_FRIEND, [friendId], succ, fail);
		},
		/**
		 * 接受好友邀请。
		 * @param string $mailId
		 */
		doOnAcceptFriend:function(mailId, succ, fail){
			dispatcher.doAction(ACTION.ACCEPT_FRIEND, [mailId], succ, fail);
		},
		/**
		 * 删除好友，同时也会将自己从对方好友列表中移除。
		 * @param string $friendId
		 */
		doOnDeleteFriend:function(friendId, succ, fail){
			dispatcher.doAction(ACTION.DELETE_FRIEND, [friendId], succ, fail);
		},
		/**
		 * 关注仇敌
		 * @param $enemyId
		 */
		doOnAttentionFriend:function(enemyId, succ, fail){
			dispatcher.doAction(ACTION.ATTENTION_FRIEND, [enemyId], succ, fail);
		},
		/**
		 * 取消关注仇敌
		 * @param $enemyId
		 */
		doOnUnAttentionFriend:function(enemyId, succ, fail){
			dispatcher.doAction(ACTION.UNATTENTION_FRIEND, [enemyId], succ, fail);
		},
		/**
		 * 好友间互送体力
		 * @param string $friendId 当$friendId为空或为小于0的数时表示全部好友发送
		 */
		doOnSendEachStrength:function(friendId, succ, fail){
			dispatcher.doAction(ACTION.SEND_EACH_STRENGTH, [friendId], succ, fail);
		},
		/**
		 * 好友留言
		 * @param array $friendId 好友
		 * @param string $message 消息内容
		 */
		doOnLevelMessage:function(friendId, message, succ, fail){
			dispatcher.doAction(ACTION.LEVEL_MESSAGE_FRIEND, [friendId, message + ""], succ, fail);
		},
}