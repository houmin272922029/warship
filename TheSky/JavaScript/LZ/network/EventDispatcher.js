var dispatcher = {
		doAction:function(action, httpParam, successEvent, failedEvent){
			var n = HttpDelegate.getInstance();
			n.doAction(action, httpParam, {
				success_callback : function(data) {
					postNotifcation(NOTI.NOTI_DATA_UPDATE, data);
					if (typeof successEvent === "string") {
						postNotifcation(successEvent, data);
					} else if (typeof successEvent == "function") {
						successEvent(data);
					}
				},
				error_callback : function(data) {
					postNotifcation(NOTI.NOTI_DATA_UPDATE, data);
					if (typeof failedEvent === "string") {
						postNotifcation(failedEvent, data);
					} else if (typeof failedEvent == "function") {
						failedEvent(data);
					}
				}
			});
		}
}