--[[--
--用户协议dialog
--Author: H.X.Sun
--Date: 2015-07-28
--]]

local AgreeDialog = qy.class("AgreeDialog", qy.tank.view.BaseDialog, "view/login/AgreeDialog")

function AgreeDialog:ctor(delegate)
    AgreeDialog.super.ctor(self)

	self:InjectView("panel")
	self:InjectView("container")
	self:InjectView("scrollView")
	self.panel:setContentSize(qy.winSize.width,qy.winSize.height)

	self:OnClick("panel", function()
		self:dismiss()
	end, {["isScale"] = false})

	self:OnClick("closeBtn", function()
		self:dismiss()
	end, {["isScale"] = false})

	if not tolua.cast(self.dynamic_c,"cc.Node") then
		self.dynamic_c = cc.Layer:create()
		self.dynamic_c:setAnchorPoint(0,1)
		self.dynamic_c:setTouchEnabled(false)
	end

	local str0 = "【注意】欢迎申请使用北京奇游互动网络科技有限公司（下列简称为“9173”）提供的服务。请用户仔细阅读以下全部内容。如用户不同意本服务条款任意内容，请不要注册或使用9173服务。如用户通过进入注册程序并勾选“我已阅读并同意9173用户注册协议”，即表示用户与9173已达成协议，自愿接受本服务条款的所有内容。此后，用户不得以未阅读本服务条款内容作任何形式的抗辩。"
	local des0 = cc.Label:createWithTTF(str0,"Resources/font/ttf/black_body_2.TTF", 20.0,cc.size(740,0),0,0)
	des0:setAnchorPoint(0,1)
	des0:setTextColor(cc.c4b(255,255,255,255))
	des0:setPosition(0,0)
	self.dynamic_c:addChild(des0)
	local h = des0:getContentSize().height + 10

	local title1  = cc.Label:createWithTTF("一．总 则", "Resources/font/ttf/black_body.TTF", 20.0,cc.size(0,0),0)
	title1:setAnchorPoint(0,1)
	title1:setTextColor(cc.c4b(255,255,255,255))
	title1:setPosition(0,-h)
	self.dynamic_c:addChild(title1)
	h = h + 30

	local str1 = "1. 用户注册成功后，将给予每个用户帐号及相应的密码，该用户帐号和密码由用户负责保管；用户应当对以其用户帐号进行的所有活动和事件负法律责任。\n\n"
	str1 = str1 .. "2. 用户理解并接受，9173仅提供相关的网络服务，除此之外与相关网络服务有关的设备（如个人电脑.手机.及其他与接入互联网或移动互联网有关的装置）及所需的费用（如为接入互联网而支付的电话费及上网费.为使用移动网而支付的手机费）均应由用户自行负担。\n\n"
	str1 = str1 .. "3. 9173会员服务协议以及各个产品单项服务条款和公告可由9173随时更新，且无需另行通知。您在使用相关服务时,应关注并遵守其所适用的相关条款。\n\n"
	str1 = str1 .. "4.您在使用9173提供的各项服务之前，应仔细阅读本服务协议。如您不同意本服务协议及/或随时对其的修改，您可以主动取消9173提供的服务；您一旦使9173提供的服务，即视为您已了解并完全同意本服务协议各项内容，包括9173对服务协议随时所做的任何修改，并成为9173用户。\n\n"
	
	local des1 = cc.Label:createWithTTF(str1,"Resources/font/ttf/black_body_2.TTF", 20.0,cc.size(740,0),0)
	des1:setAnchorPoint(0,1)
	des1:setTextColor(cc.c4b(255,255,255,255))
	des1:setPosition(0,-h)
	self.dynamic_c:addChild(des1)
	h = h + des1:getContentSize().height + 10

	local title2  = cc.Label:createWithTTF("二.使用规则", "Resources/font/ttf/black_body.TTF", 20.0,cc.size(0,0),0)
	title2:setAnchorPoint(0,1)
	title2:setTextColor(cc.c4b(255,255,255,255))
	title2:setPosition(0,-h)
	self.dynamic_c:addChild(title2)
	h = h + 30

	local str2 = "用户在使用9173服务时，必须遵守中华人民共和国相关法律法规的规定，用户应同意将不会利用本服务进行任何违法或不正当的活动，包括但不限于下列行为∶ \n\n"
	str2 = str2 .. "1.不得为任何非法目的而使用网络服务系统； \n\n"
	str2 = str2 .. "2.不得利用9173网络服务系统进行任何可能对互联网或移动网正常运转造成不利影响的行为； \n\n"
	str2 = str2 .. "3.不得上载.展示.张贴.传播或以其它方式传送含有下列内容的信息： \n"
	str2 = str2 .. "（1）反对宪法所确定的基本原则的； \n"
	str2 = str2 .. "（2）危害国家安全，泄露国家秘密，颠覆国家政权，破坏国家统一的； \n"
	str2 = str2 .. "（3）损害国家荣誉和利益的；\n"
	str2 = str2 .. "（4）煽动民族仇恨.民族歧视.破坏民族团结的；\n"
	str2 = str2 .. "（5）破坏国家宗教政策，宣扬邪教和封建迷信的； \n"
	str2 = str2 .. "（6）散布谣言，扰乱社会秩序，破坏社会稳定的； \n"
	str2 = str2 .. "（7）散布淫秽.色情.赌博.暴力.凶杀.恐怖或者教唆犯罪的；\n"
	str2 = str2 .. "（8）侮辱或者诽谤他人，侵害他人合法权利的； \n"
	str2 = str2 .. "（9）含有虚假.有害.胁迫.侵害他人隐私.骚扰.侵害.中伤.粗俗.猥亵.或其它道德上令人反感的内容； \n"
	str2 = str2 .. "（10）含有中国法律.法规.规章.条例以及任何具有法律效力之规范所限制或禁止的其它内容的； \n\n"
	str2 = str2 .. "4.用户不得利用9173的服务从事以下活动：\n"
	str2 = str2 .. "(1) 未经允许，进入计算机信息网络或者使用计算机信息网络资源的；\n"
	str2 = str2 .. "(2) 未经允许，对计算机信息网络功能进行删除、修改或者增加的；\n"
	str2 = str2 .. "(3) 未经允许，对进入计算机信息网络中存储、处理或者传输的数据和应用程序进行删除、修改或者增加的；\n"
	str2 = str2 .. "(4) 故意制作、传播计算机病毒等破坏性程序的；\n"
	str2 = str2 .. "(5) 其他危害计算机信息网络安全的行为。\n\n"

	local des2 = cc.Label:createWithTTF(str2,"Resources/font/ttf/black_body_2.TTF", 20.0,cc.size(740,0),0)
	des2:setAnchorPoint(0,1)
	des2:setTextColor(cc.c4b(255,255,255,255))
	des2:setPosition(0,-h)
	self.dynamic_c:addChild(des2)
	h = h + des2:getContentSize().height + 10

	local title3  = cc.Label:createWithTTF("三.用户账号和密码安全", "Resources/font/ttf/black_body.TTF", 20.0,cc.size(0,0),0)
	title3:setAnchorPoint(0,1)
	title3:setTextColor(cc.c4b(255,255,255,255))
	title3:setPosition(0,-h)
	self.dynamic_c:addChild(title3)
	h = h + 30

	local str3 = "您应对所有使用您的密码及帐号的活动负完全的责任。您同意：\n\n"
	str3 = str3 .. "1.您的9173帐号遭到未获授权的使用，或者发生其它任何安全问题时，您将立即通知9173；\n\n"
	str3 = str3 .. "2.如果您未保管好自己的帐号和密码，因此而产生的任何损失或损害，9173不负责承担任何责任；\n\n"
	str3 = str3 .. "3.每个用户都要对其帐号中的所有行为和事件负全责。如果您未保管好自己的帐号和密码而对您或对9173或其他第三方造成的损害，您将负全部责任。\n\n"

	local des3 = cc.Label:createWithTTF(str3,"Resources/font/ttf/black_body_2.TTF", 20.0,cc.size(740,0),0)
	des3:setAnchorPoint(0,1)
	des3:setTextColor(cc.c4b(255,255,255,255))
	des3:setPosition(0,-h)
	self.dynamic_c:addChild(des3)
	h = h + des3:getContentSize().height + 10

	local title4  = cc.Label:createWithTTF("四.用户隐私保护", "Resources/font/ttf/black_body.TTF", 20.0,cc.size(0,0),0)
	title4:setAnchorPoint(0,1)
	title4:setTextColor(cc.c4b(255,255,255,255))
	title4:setPosition(0,-h)
	self.dynamic_c:addChild(title4)
	h = h + 30

	local str4 = "1.尊重用户个人隐私是9173的一项基本政策。“隐私”是指用户在注册9173通行证账号时提供给9173个人身份信息，包括用户注册资料中的姓名、个人有效身份证件号码、联系方式、家庭住址等。\n\n"
	str4 = str4 .. "1.您的9173帐号遭到未获授权的使用，或者发生其它任何安全问题时，您将立即通知9173；\n\n"
	str4 = str4 .. "2.9173将采取技术与管理等合理措施保障用户账号的安全、有效；9173将善意使用收集的信息，采取各项有效且必要的措施以保护您的隐私安全，并使用合理的安全技术措施来保护您的隐私不被未经授权的访问、使用或泄漏。\n\n"
	str4 = str4 .. "3.9173将不会向除其关联公司外的任何其他方公开或共享用户注册资料的中的姓名、个人有效身份证件号码、联系方式、家庭住址等个人身份信息，但下列情况除外：\n"
	str4 = str4 .. "（1）用户或用户监护人授权9173游戏平台披露的；\n"
	str4 = str4 .. "（2）有关法律要求9173游戏平台披露的；\n"
	str4 = str4 .. "（3）司法机关或行政机关基于法定程序要求9173游戏平台提供的；\n"
	str4 = str4 .. "（4）9173为了维护自己合法权益而向用户提起诉讼或者仲裁时；\n"
	str4 = str4 .. "（5）应用户监护人的合法要求而提供用户个人身份信息时。\n\n"

	local des4 = cc.Label:createWithTTF(str4,"Resources/font/ttf/black_body_2.TTF", 20.0,cc.size(740,0),0)
	des4:setAnchorPoint(0,1)
	des4:setTextColor(cc.c4b(255,255,255,255))
	des4:setPosition(0,-h)
	self.dynamic_c:addChild(des4)
	h = h + des4:getContentSize().height + 10

	local title5  = cc.Label:createWithTTF("五.知识产权", "Resources/font/ttf/black_body.TTF", 20.0,cc.size(0,0),0)
	title5:setAnchorPoint(0,1)
	title5:setTextColor(cc.c4b(255,255,255,255))
	title5:setPosition(0,-h)
	self.dynamic_c:addChild(title5)
	h = h + 30

	local str5 = "1.9173提供的网络服务中包含的任何文本.图片.图形.音频和/或视频资料均受版权、商标和/或其它财产所有权法律的保护，未经相关权利人同意，上述资料均不得用于任何商业目的。\n\n"
	str5 = str5 .. "2.9173为提供网络服务而使用的任何软件（包括但不限于软件中所含的任何图象.照片.动画.录像.录音.音乐.文字和附加程序.随附的帮助材料）的一切权利均属于该软件的著作权人，未经该软件的著作权人许可，用户不得对该软件进行反向工程（reverse engineer）.反向编译（decompile）或反汇编（disassemble）。\n\n"

	local des5 = cc.Label:createWithTTF(str5,"Resources/font/ttf/black_body_2.TTF", 20.0,cc.size(740,0),0)
	des5:setAnchorPoint(0,1)
	des5:setTextColor(cc.c4b(255,255,255,255))
	des5:setPosition(0,-h)
	self.dynamic_c:addChild(des5)
	h = h + des5:getContentSize().height + 10

	local title6  = cc.Label:createWithTTF("六．免责声明", "Resources/font/ttf/black_body.TTF", 20.0,cc.size(0,0),0)
	title6:setAnchorPoint(0,1)
	title6:setTextColor(cc.c4b(255,255,255,255))
	title6:setPosition(0,-h)
	self.dynamic_c:addChild(title6)
	h = h + 30

	local str6 = "1.9173不担保网络服务一定能满足用户的要求，也不担保网络服务不会中断，对网络服务的及时性.安全性.准确性也都不作担保。\n\n"
	str6 = str6 .. "2.9173不保证为向用户提供便利而设置的外部链接的准确性和完整性，同时，对于该等外部链接指向的不由9173实际控制的任何网页上的内容，9173不承担任何责任。\n\n"
	str6 = str6 .. "3. 对于因电信系统或互联网网络故障.计算机故障或病毒.信息损坏或丢失.计算机系统问题或其它任何不可抗力原因而产生损失，9173不承担任何责任，但将尽力减少因此而给用户造成的损失和影响。\n\n"

	local des6 = cc.Label:createWithTTF(str6,"Resources/font/ttf/black_body_2.TTF", 20.0,cc.size(740,0),0)
	des6:setAnchorPoint(0,1)
	des6:setTextColor(cc.c4b(255,255,255,255))
	des6:setPosition(0,-h)
	self.dynamic_c:addChild(des6)
	h = h + des6:getContentSize().height + 10

	local title7  = cc.Label:createWithTTF("七.其他条款", "Resources/font/ttf/black_body.TTF", 20.0,cc.size(0,0),0)
	title7:setAnchorPoint(0,1)
	title7:setTextColor(cc.c4b(255,255,255,255))
	title7:setPosition(0,-h)
	self.dynamic_c:addChild(title7)
	h = h + 30

	local str7 = "1.如果本协议中的任何条款无论因何种原因完全或部分无效或不具有执行力，或违反任何适用的法律，则该条款被视为删除，但本协议的其余条款仍应有效并且有约束力。\n\n"
	str7 = str7 .. "2.9173有权随时根据有关法律.法规的变化以及公司经营状况和经营策略的调整等修改本协议，而无需另行单独通知用户当发生有关争议时，以最新的协议文本为准。如果不同意9173对本协议相关条款所做的修改，用户有权停止使用网络服务。如果用户继续使用网络服务，则视为用户接受9173对本协议相关条款所做的修改。\n\n"
	str7 = str7 .. "3.9173在法律允许最大范围对本协议拥有解释权与修改权。\n\n"

	local des7 = cc.Label:createWithTTF(str7,"Resources/font/ttf/black_body_2.TTF", 20.0,cc.size(740,0),0)
	des7:setAnchorPoint(0,1)
	des7:setTextColor(cc.c4b(255,255,255,255))
	des7:setPosition(0,-h)
	self.dynamic_c:addChild(des7)
	h = h + des7:getContentSize().height + 10

	self.dynamic_c:setContentSize(600,h)
	self.dynamic_c:setPosition(0,h)
	self.scrollView:addChild(self.dynamic_c)

	self.scrollView:setInnerContainerSize(cc.size(740,h))
end

return AgreeDialog