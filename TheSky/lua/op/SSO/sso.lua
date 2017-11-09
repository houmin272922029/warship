SSOPlatform = {
	m_uid = nil,
	m_guid = nil,
	m_pwd = nil,
	m_sid = nil,
	m_nickname = nil,
	m_token = nil,
	m_secret = nil,
	vn_access_token = nil,
}

local function ssoErrorCallback(url, errCode)
	postNotification(HL_SSO_ERROR, errCode)
end

function SSOPlatform.setSecret(secret)
	SSOPlatform.m_secret = secret
end

function SSOPlatform.setUid(uid)
	-- if uid == nil or string.len(uid) <= 0 then
	-- 	return
	-- end
	SSOPlatform.m_uid = uid

	if isPlatform(IOS_TEST_ZH) 
        or isPlatform(ANDROID_TEST_ZH) 
        or isPlatform(IOS_TW_ZH) 
        or isPlatform(ANDROID_TW_ZH)
        or isPlatform(IOS_APPLE_ZH)
        or isPlatform(IOS_APPLE2_ZH) then

		setUDString(UDefKey.KEY_LOCAL_UID, uid)

	end
end

function SSOPlatform.setNickname(nickname)
	-- print("SSOPlatform setNickname = " .. nickname)
	SSOPlatform.m_nickname = nickname

	if isPlatform(IOS_TEST_ZH) 
        or isPlatform(ANDROID_TEST_ZH) 
        or isPlatform(IOS_TW_ZH) 
        or isPlatform(ANDROID_TW_ZH)
        or isPlatform(IOS_APPLE_ZH)
        or isPlatform(IOS_APPLE2_ZH) then

		setUDString(UDefKey.KEY_LOCAL_NICKNAME, nickname)
	end
end

function SSOPlatform.setSid(sid)
	if sid == nil or string.len(sid) <= 0 then
		return
	end 
	SSOPlatform.m_sid = sid
end

function SSOPlatform.setToken(token)
	if token == nil or string.len(token) <= 0 then
		return
	end
	SSOPlatform.m_token = token
end

-- 从sso服务器获取各个平台版本的server list
function SSOPlatform.GetServerListByVersion(userGUid)
	local CFBundleVersion = uDefault:getStringForKey(opPCL.."_ver")
	if isPlatform(WP_VIETNAM_VN)  or isPlatform(WP_VIETNAM_EN) then
		CFBundleVersion = "1.0"
	end
	local param = {CFBundleVersion, userGUid}
	local function ssoGetServerListCallbackFun(url, rtnData)
		if rtnData.code == 200 then
	    	postNotification(HL_SSO_GetServerList, rtnData)
		end
	end
	local actionName = "SSO_GETSERVERLISTBYVERSION_URL"
	if newUpdate and newUpdate() then
		actionName = actionName .. "_V2"
	end
	doSSOActionFun(actionName, param, ssoGetServerListCallbackFun, ssoErrorCallback)
end

-- 生成游客uid
function SSOPlatform.GenerateUid()
	local param = {Global:instance():getDeviceID()}
	
	if isPlatform(ANDROID_360_ZH) then
		param = {SSOPlatform.m_sid}
	end

	if isPlatform(IOS_KY_ZH)
		or isPlatform(IOS_KYPARK_ZH) 
		or isPlatform(ANDROID_KY_ZH)
        or isPlatform(IOS_PPZS_ZH)
        or isPlatform(IOS_PPZSPARK_ZH)
		or isPlatform(ANDROID_UC_ZH)
		or isPlatform(IOS_ITOOLS) 
		or isPlatform(IOS_ITOOLSPARK)
		or isPlatform(IOS_XYZS_ZH) 
		or isPlatform(ANDROID_XYZS_ZH) 
		or isPlatform(ANDROID_XYZS_ZH) then

		param = {SSOPlatform.m_token}

	end
	if isPlatform(IOS_91_ZH) then

		param = {"", ""}

	end
	local function ssoGenerateUidCallbackFun(url, rtnData)
		if rtnData.code == 200 then
			-- 设置uid和nickname
	    	SSOPlatform.setUid(rtnData.info.uid)
	    	SSOPlatform.m_nickname = rtnData.info.userName
	    	if isPlatform(ANDROID_360_ZH) then
	    		SSOPlatform.setToken(rtnData.info.refresh_token)
	    	end
            postNotification(HL_SSO_GenerateUid, nil)
            print("-----------新生成uid:",SSOPlatform.GetUid())
		end
	end
	doSSOActionFun("SSO_GENERATEUID_URL", param, ssoGenerateUidCallbackFun, ssoErrorCallback)
end

-- 获取secret
function SSOPlatform.GetSecret()
	if SSOPlatform.m_secret then
		return SSOPlatform.m_secret
	end
	return SSOPlatform.m_secret
end
function SSOPlatform.GetToken()
	return SSOPlatform.m_token
end
-- 获取uid
function SSOPlatform.GetUid()
	if SSOPlatform.m_uid then
		return SSOPlatform.m_uid
	end
	SSOPlatform.m_uid = getUDString(UDefKey.KEY_LOCAL_UID)
	return SSOPlatform.m_uid
end

-- 获取nickname （第三方平台）
function SSOPlatform.GetNickname()
	if SSOPlatform.m_nickname then
		return SSOPlatform.m_nickname
	end
	SSOPlatform.m_nickname = getUDString(UDefKey.KEY_LOCAL_NICKNAME)
	return SSOPlatform.m_nickname
end

-- 获取pwd
function SSOPlatform.GetPwd()
	if SSOPlatform.m_pwd then
		return SSOPlatform.m_pwd
	end
	SSOPlatform.m_pwd = getUDString(UDefKey.KEY_LOCAL_PWD)
	return SSOPlatform.m_pwd
end

-- 获取sid
function SSOPlatform.GetSid()
	return SSOPlatform.m_sid
end

-- 检查是否已经登陆成功SSO服务器
function SSOPlatform.IsLogin()
	if SSOPlatform.GetSid() and string.len(SSOPlatform.GetSid()) > 0 then
		return true
	end
	return false
end

-- 检查是否是游客登陆
function SSOPlatform.IsTourist()
	local pwd = getUDString(UDefKey.KEY_LOCAL_PWD)
	if pwd == nil or string.len(pwd) <= 0 then
		return true
	end
	return false
end

-- 默认方式登录平台
function SSOPlatform.Login()
	print("SSOPlatform.Login", SSOPlatform.GetUid())
	if SSOPlatform.GetUid() and string.len(SSOPlatform.GetUid()) > 0 then			-- 非首次登陆
		local CFBundleVersion = uDefault:getStringForKey(opPCL.."_ver")
		
		if isPlatform(WP_VIETNAM_VN)  or isPlatform(WP_VIETNAM_EN) then
			CFBundleVersion = "1.0"
		end
		local function ssoLoginCallbackFun(url, rtnData)
		    print("-----------ssoLoginCallbackFun------- url = "..url)
		    PrintTable(rtnData)
	    -- print(rtnData.info.session.."  "..rtnData.info.uid)
		    if rtnData.code == 200 then
		    	if isPlatform(IOS_INFIPLAY_RUS) 
		    		or isPlatform(ANDROID_INFIPLAY_RUS)
		    		or isPlatform(IOS_TEST_ZH) 
        			or isPlatform(IOS_APPLE_ZH) then
		    		SSOPlatform.m_guid = rtnData.info.guid
		    	end
		    	if isPlatform(WP_VIETNAM_VN) then
		    		SSOPlatform.m_guid = rtnData.info.guid
				    SSOPlatform.vn_access_token = rtnData.info.access_token
		    	end
		    	if isPlatform(WP_VIETNAM_EN) then
		    		SSOPlatform.m_guid = rtnData.info.guid
				    SSOPlatform.vn_access_token = rtnData.info.access_token
		    	end
		    	if rtnData.info.session then
				    SSOPlatform.m_sid = rtnData.info.session
				else
					if not isPlatform(IOS_ITOOLS)
						and not isPlatform(IOS_ITOOLSPARK) 
						and not onPlatform("TGAME")
						and not isPlatform(IOS_TBTPARK_ZH)
						and not isPlatform(IOS_HAIMA_ZH)
        				and not isPlatform(ANDROID_MYEPAY_ZH)
                        and not isPlatform(ANDROID_HTC_ZH) then

						SSOPlatform.m_sid = SSOPlatform.m_token
					end
			    end
			    postNotification(HL_SSO_Login, rtnData)
		    end
		end

		local pwd = nil
		if SSOPlatform.IsTourist() then
			pwd = string.lower(Global:instance():getDeviceID())
		else
			pwd = SSOPlatform.GetPwd()
		end

		local params

		if isPlatform(IOS_VIETNAM_VI) 
            or isPlatform(IOS_VIETNAM_EN) 
	        or isPlatform(IOS_VIETNAM_ENSAGA)
            or isPlatform(IOS_MOBNAPPLE_EN)
            or isPlatform(IOS_MOB_THAI)
			or isPlatform(IOS_KY_ZH)
			or isPlatform(IOS_PPZS_ZH) 
			or isPlatform(IOS_PPZSPARK_ZH)
			or isPlatform(ANDROID_UC_ZH) 
			or isPlatform(ANDROID_BAIDU_ZH) 
			or isPlatform(ANDROID_BAIDUIAPPPAY_ZH) 
			or isPlatform(ANDROID_MM_ZH) 
			or isPlatform(ANDROID_VIETNAM_MOB_THAI)
			or isPlatform(ANDROID_VIETNAM_VI) 
			or isPlatform(ANDROID_VIETNAM_EN)
			or isPlatform(ANDROID_VIETNAM_EN_ALL)
	        or isPlatform(IOS_MOBGAME_SPAIN)
	        or isPlatform(ANDROID_MOBGAME_SPAIN)
			or isPlatform(ANDROID_COOLPAY_ZH) then

			params = {SSOPlatform.GetUid(), "", "", CFBundleVersion}

		elseif isPlatform(ANDROID_360_ZH)
        	or isPlatform(ANDROID_GIONEE_ZH)
            or isPlatform(ANDROID_JAGUAR_TC)
            or isPlatform(IOS_IIAPPLE_ZH)
			or isPlatform(IOS_KYPARK_ZH)
			or isPlatform(ANDROID_KY_ZH) 
			or isPlatform(IOS_XYZS_ZH) 
			or isPlatform(ANDROID_XYZS_ZH) then

			params = {SSOPlatform.GetUid(), SSOPlatform.GetToken(), "", CFBundleVersion}

		elseif isPlatform(IOS_91_ZH) 
			or isPlatform(ANDROID_AGAME_ZH) 
			or isPlatform(ANDROID_MMY_ZH) 
			or onPlatform("TGAME")
			or isPlatform(IOS_AISI_ZH)
			or isPlatform(IOS_TBTPARK_ZH)
			or isPlatform(IOS_HAIMA_ZH)
        	or isPlatform(ANDROID_MYEPAY_ZH)
            or isPlatform(ANDROID_HTC_ZH) then

			params = {SSOPlatform.GetUid(), SSOPlatform.GetSid(), "", CFBundleVersion}

		elseif isPlatform(IOS_AISIPARK_ZH)
			or isPlatform(IOS_DOWNJOYPARK_ZH)  
        	or isPlatform(ANDROID_DOWNJOY_ZH) then
			params = {SSOPlatform.GetUid(), SSOPlatform.GetToken(), opAppId, CFBundleVersion}
			
		elseif isPlatform(IOS_ITOOLSPARK) then

			params = {SSOPlatform.GetUid(), SSOPlatform.GetSid(), opAppId, CFBundleVersion}
		else

			if isPlatform(IOS_INFIPLAY_RUS) or isPlatform(ANDROID_INFIPLAY_RUS) then
				params = {SSOPlatform.GetUid(), pwd, opAppId, CFBundleVersion}
			elseif isPlatform(WP_VIETNAM_VN) then
				params = {SSOPlatform.GetUid(), pwd, opAppId, CFBundleVersion}
			elseif isPlatform(WP_VIETNAM_EN) then
				params = {SSOPlatform.GetUid(), pwd, opAppId, CFBundleVersion}
			else
				params = {SSOPlatform.GetUid(), Global.getMD5(SSOPlatform.GetUid()..pwd, 1), opAppId, CFBundleVersion}
			end

		end
		local actionName = "SSO_LOGIN_URL"
		if newUpdate and newUpdate() then
			actionName = actionName .. "_V2"
		end
		doSSOActionFun(actionName, params, ssoLoginCallbackFun, ssoErrorCallback)
	end
end

-- 账号密码登录平台
function SSOPlatform.LoginWithAccount(account, pwd)
	local tempPwd = nil
	local CFBundleVersion = uDefault:getStringForKey(opPCL.."_ver")
	
	if isPlatform(WP_VIETNAM_VN)  or isPlatform(WP_VIETNAM_EN) then
		CFBundleVersion = "1.0"
	end
	-- http callback
	local function ssoLoginCallbackFun(url, rtnData)
	    print("-----------ssoLoginCallbackFun------- url = "..url)
	    -- print(rtnData.info.session.."  "..rtnData.info.uid)
	    if rtnData.code == 200 then
		    SSOPlatform.m_sid = rtnData.info.session
		    SSOPlatform.m_uid = rtnData.info.uid
		    if isPlatform(IOS_INFIPLAY_RUS) or isPlatform(ANDROID_INFIPLAY_RUS) then
		    	SSOPlatform.m_guid = rtnData.info.guid
		    end
		    if isPlatform(WP_VIETNAM_VN) then
		    	SSOPlatform.m_guid = rtnData.info.guid
			    SSOPlatform.vn_access_token = rtnData.info.access_token
		    end
		    if isPlatform(WP_VIETNAM_EN) then
		    	SSOPlatform.m_guid = rtnData.info.guid
			    SSOPlatform.vn_access_token = rtnData.info.access_token
		    end
		    setUDString(UDefKey.KEY_LOCAL_UID, SSOPlatform.m_uid)
		    SSOPlatform.m_pwd = tempPwd
		    setUDString(UDefKey.KEY_LOCAL_PWD, SSOPlatform.m_pwd)
			postNotification(HL_SSO_Login, rtnData)
		else
			SSOPlatform.m_pwd = nil
	    end
	end
	local function infiPlaySsoLoginError(url, errCode)
		if HLNSLocalizedString("ERR_"..errCode) ~= nil then
			ShowText(HLNSLocalizedString("ERR_"..errCode))
		end
	end

	tempPwd = Global.getMD5(pwd, 2)
	local params = {}
	if isPlatform(IOS_INFIPLAY_RUS) or isPlatform(ANDROID_INFIPLAY_RUS) then
		params = {account, tempPwd, opAppId, CFBundleVersion}
	elseif isPlatform(WP_VIETNAM_VN) then
		params = {account, pwd, opAppId, CFBundleVersion}
	elseif isPlatform(WP_VIETNAM_EN) then
		params = {account, pwd, opAppId, CFBundleVersion}
	else
		params = {account, Global.getMD5(account..tempPwd, 1), opAppId, CFBundleVersion}
	end
	local actionName = "SSO_LOGIN_URL"
	if newUpdate and newUpdate() then
		actionName = actionName .. "_V2"
	end
	if isPlatform(IOS_INFIPLAY_RUS) or isPlatform(ANDROID_INFIPLAY_RUS) then
		doSSOActionFun(actionName, params, ssoLoginCallbackFun, infiPlaySsoLoginError)
	else
		doSSOActionFun(actionName, params, ssoLoginCallbackFun)
	end
end

-- 游客身份注册（相当于绑定账号）
function SSOPlatform.Binding(account, pwd, phone)
	local function ssoRegCallbackFun(url, rtnData)
	    if rtnData.code == 200 then
		    SSOPlatform.m_sid = rtnData.info.session
		    SSOPlatform.m_uid = rtnData.info.uid
		    SSOPlatform.m_pwd = rtnData.info.token
		    setUDString(UDefKey.KEY_LOCAL_UID, SSOPlatform.m_uid)
		    setUDString(UDefKey.KEY_LOCAL_PWD, SSOPlatform.m_pwd)
			postNotification(HL_SSO_Register, nil)
	    end
	end

	if not SSOPlatform.GetUid() or string.len(SSOPlatform.GetUid()) <= 0 then
		return
	end

	if phone == nil then
		phone = ""
	end
	local params = {SSOPlatform.GetUid(), Global.getMD5(SSOPlatform.GetUid()..string.lower(Global:instance():getDeviceID()), 1), account, pwd, phone}
	doSSOActionFun("SSO_BINDING_ACCOUNT_URL", params, ssoRegCallbackFun)
end

-- 注册新的sso账号
function SSOPlatform.Register(account, pwd, phone)
	local function ssoRegCallbackFun(url, rtnData)
	    if rtnData.code == 200 then
		    SSOPlatform.m_sid = rtnData.info.session
		    SSOPlatform.m_uid = rtnData.info.uid
		    if isPlatform(IOS_INFIPLAY_RUS) or isPlatform(ANDROID_INFIPLAY_RUS) then
		    	SSOPlatform.m_guid = rtnData.info.guid
		    end
		    if isPlatform(WP_VIETNAM_VN) or isPlatform(WP_VIETNAM_EN) then
		    	SSOPlatform.m_guid = rtnData.info.guid
			    SSOPlatform.vn_access_token = rtnData.info.access_token
		        SSOPlatform.m_pwd = pwd
			else
			    SSOPlatform.m_pwd = rtnData.info.token
		    end
		    setUDString(UDefKey.KEY_LOCAL_UID, SSOPlatform.m_uid)
		    setUDString(UDefKey.KEY_LOCAL_PWD, SSOPlatform.m_pwd)
			postNotification(HL_SSO_Register, nil)
	    end
	end
	local function ssoRegErrorCallBack(url, errCode)
	    if HLNSLocalizedString("ERR_"..errCode) ~= nil then
			ShowText(HLNSLocalizedString("ERR_"..errCode))
		end
	end

	if phone == nil then
		phone = ""
	end
	local params = {account, pwd, phone}

	doSSOActionFun("SSO_REGISTER_ACCOUNT_URL", params, ssoRegCallbackFun, ssoRegErrorCallBack)
end

-- 修改sso密码
function SSOPlatform.ModifyPwd(account, oldPwd, newPwd)
	local function ssoModifyPwdCallBack(url, rtnData)
	    if rtnData.code == 200 then
		    SSOPlatform.m_uid = rtnData.info.uid
		    SSOPlatform.m_pwd = rtnData.info.token
		    setUDString(UDefKey.KEY_LOCAL_UID, SSOPlatform.m_uid)
		    setUDString(UDefKey.KEY_LOCAL_PWD, SSOPlatform.m_pwd)
		    postNotification(HL_SSO_ModifyPwd, nil)
	    end
	end
	local params = {account, oldPwd, newPwd}
	doSSOActionFun("SSO_MODIFY_PWD_URL", params, ssoModifyPwdCallBack)
end

-- 从SSO服务器注销
function SSOPlatform.Logout()
	-- TODO
end