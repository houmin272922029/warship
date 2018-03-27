--
--设置Dialog
--Author: H.X.Sun
--Date: 2015-06-17
--]]
local SettingDialog = qy.class("SettingDialog", qy.tank.view.BaseDialog, "view/setting/SettingDialog")

function SettingDialog:ctor(delegate)
    SettingDialog.super.ctor(self)
    self.model = qy.tank.model.SettingModel

	self:__addStyle()
	--初始化ui
	self:__initView()
	--绑定点击事件
	self:__bindingClickEvent()

	self:__changeSoundOn()

	self:updateBindInfo()
end

function SettingDialog:__changeSoundOn()
	if qy.QYPlaySound.soundOn == false then
		self.sound_text:setSpriteFrame("Resources/common/txt/kaiqiyinyue.png")
	else
		self.sound_text:setSpriteFrame("Resources/common/txt/guanbiyinyue.png")
	end
end

function SettingDialog:__bindingClickEvent()
	--绑定
	self:OnClick("binding",function(sender)
		self:dismiss()
		qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.BIND_ACCOUNT)
		-- qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.REGISTER, {["action"] = 2})
	end)

	--更换服务器
	self:OnClick("changeServer",function(sender)
		-- qy.hint:show("更换服务器开发中")
        self.model:clearData()
		qy.tank.manager.ScenesManager:showLoginScene()
	end)

	--声音
	self:OnClick("soundBtn",function(sender)
		cc.UserDefault:getInstance():setBoolForKey("local_SoundOn", not qy.QYPlaySound.soundOn)
		if qy.QYPlaySound.soundOn then
			qy.QYPlaySound.soundOn = false
			qy.QYPlaySound.pauseMusic()
		else
			qy.QYPlaySound.soundOn = true
			qy.QYPlaySound.playMusic(qy.SoundType.M_W_BG_MS, true, true)
		end
		-- cc.UserDefault:getInstance():setBoolForKey("local_SoundOn", qy.QYPlaySound.soundOn)
		self:__changeSoundOn()
	end)

	--查看公告
	self:OnClick("announceBtn",function(sender)
        self:dismiss()
		qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.MAIL)
	end)

	--账号安全
	self:OnClick("accountBtn",function(sender)
		qy.hint:show(qy.TextUtil:substitute(30001))
	end)

	--游戏帮助
	self:OnClick("helpBtn",function(sender)
		-- qy.hint:show("游戏帮助开发中")
		self:dismiss()
		qy.tank.module.Helper:register("help")
    	qy.tank.module.Helper:start("help", qy.App.runningScene.dialogStack)
	end)

	--cn:推送按钮 en：绑定 fb 账号
	self:OnClick("pushBtn",function(sender)
        if qy.language == "cn" then
		    qy.hint:show(qy.TextUtil:substitute(30002))
        else
            qy.tank.utils.SDK:bindAccount(function()
	            qy.hint:show("Facebook account bind successful")
            end,function()
	            -- qy.hint:show("Facebook account bind failed")
            end)
        end
	end)

	--礼包兑换
	self:OnClick("giftBtn",function(sender)
		-- qy.hint:show("礼包兑换开发中")
        self:dismiss()
		qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.CD_KEY)
	end)

	--联系客服
	self:OnClick("cusServiceBtn",function(sender)
        self:dismiss()
		qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.MAIL, {["defaultIdx"] = 4})
	end)

	--聊天黑名单
	self:OnClick("chatBtn",function(sender)
		self:dismiss()
		qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.BLACKLIST)
		-- qy.hint:show(qy.TextUtil:substitute(30003))
	end)

    if qy.isAudit and qy.product == "sina" then
        self:InjectView("chatBtn")
        self:InjectView("giftBtn")
        self:InjectView("pushBtn")
        self:InjectView("helpBtn")
        self:InjectView("accountBtn")
        self:InjectView("binding")
        self:InjectView("cusServiceBtn")
        self.chatBtn:setVisible(false)
        self.giftBtn:setVisible(false)
        self.helpBtn:setVisible(false)
        self.pushBtn:setVisible(false)
        self.accountBtn:setVisible(false)
        self.binding:setVisible(false)
        self.cusServiceBtn:setVisible(false)
    end

    self.binding:setVisible(qy.InternationalUtil:isShowBinding())
end

function SettingDialog:updateBindInfo()
	if qy.tank.model.LoginModel:getPlayerInfoEntity().is_visitor == 1 then
		self.binding:setString(qy.TextUtil:substitute(30004))
		-- self.pushBtn:setVisible(true)
	else
		self.binding:setString(qy.TextUtil:substitute(30005))
        -- if qy.language == "en" then
            -- 如果是 英文版 这个是绑定 FB 按钮 ，不是游客时隐藏
    		-- self.pushBtn:setVisible(false)
        -- end
	end
	local _nickname = qy.tank.model.LoginModel:getPlayerInfoEntity().nickname
	self.account:setString(_nickname)
end

function SettingDialog:__initView()
	self:InjectView("account")
	self:InjectView("id")
	self:InjectView("server")
	self:InjectView("binding")

	self:InjectView("sound_text")
	self:InjectView("binding")
    self:InjectView("pushBtn")
	-- self:InjectView("bg")
	-- self.bg:setLocalZOrder(-4)
	-- self:InjectView("hasBind")

	-- qy.tank.utils.TextUtil:drawLine(self.binding)

	-- self:InjectView("announceTxt")
	-- self.announceTxt:enableOutline(cc.c4b(0,0,0,255),1)

	self.id:setString(qy.tank.model.UserInfoModel.userInfoEntity.kid)
	local _entity = qy.tank.model.LoginModel:getLastDistrictEntity()
	self.server:setString( _entity.s_name .. "-" .. _entity.name)
end

function SettingDialog:__addStyle()
	local style = qy.tank.view.style.DialogStyle1.new({
		size = cc.size(560,540),
		position = cc.p(0,0),
		offset = cc.p(0,0),
		titleUrl = "Resources/common/title/youxishezhi.png",

		["onClose"] = function()
			self:dismiss()
		end
	})
	-- style:removeChild(style.bg)
	-- style.bg:setContentSize(530,536-15)
	-- style.bg:setContentSize(60 ,536-15)
	self:addChild(style, -1)
end
return SettingDialog
