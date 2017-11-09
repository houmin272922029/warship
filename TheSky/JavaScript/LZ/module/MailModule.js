var MailModule = {
		getSystemMails:function() {
			var sysmails = maildata.mails.system;
			return sysmails;
		},
		getAwardMails:function() {
			var awards = maildata.mails.attachment;
			return awards;
		},
		getMessage:function() {
			var message = maildata.mails.message;
			return message;
		},
		deleteAwardMails:function(mailId){
			maildata.pay(mailId);
		},
		/**
		 * 网络接口 
		 */
		/**
		 *  领取邮件奖励
		 *  mailId 邮件唯一ID
		 */
		doOnGetMailAwards:function(mailId, succ, fail){
			dispatcher.doAction(ACTION.MAIL_GET_MAIL_AWARDS, [mailId], succ, fail);
		},
		
		
}