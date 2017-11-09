-- 地址管理
HostTable = {}

-- 平台 版本区别


if opPCL == IOS_TEST_ZH then             -- ios 测试
    HostTable.DEFAULT_HOST = "http://test.hzdw.com/public"    -- 外网测试服务器
    HostTable.SSO_DEFAULT_HOST = "http://188.188.188.106/pirate/public/" -- 外网sso服务器
    HostTable.CDN_ROOT_OP2DXUP = "http://god.cdn.tainengmiao.com/onepiece/Octopus/" -- cdn地址

elseif opPCL == ANDROID_TEST_ZH then     -- android内网测试   
    HostTable.DEFAULT_HOST = "http://test.hzdw.com/public"    -- 测试服务器
    HostTable.SSO_DEFAULT_HOST = "http://test.hzdw.com/public/" -- 正式服务器
    HostTable.CDN_ROOT_OP2DXUP = "http://192.168.1.133/appstore/public/resource/op2dxUp/" -- cdn地址

--------- 苹果官方中文 ios ---------
elseif opPCL == IOS_APPLE_ZH  then     
    HostTable.DEFAULT_HOST = "http://ios.ky.hzdw.com/public"    -- 外网测试服务器
    HostTable.SSO_DEFAULT_HOST = "http://ios.ky.hzdw.com/public/" -- 外网sso服务器
    HostTable.CDN_ROOT_OP2DXUP = "http://god.cdn.tainengmiao.com/onepiece/Apple/" -- cdn地址

--------- IIAPPLE中文 ios ---------
elseif opPCL == IOS_IIAPPLE_ZH or opPCL == IOS_KYPARK_ZH or opPCL == IOS_ITOOLSPARK or opPCL == ANDROID_KY_ZH or opPCL == IOS_PPZSPARK_ZH 
    or opPCL == IOS_TBTPARK_ZH or opPCL == IOS_HAIMA_ZH or opPCL == IOS_XYZS_ZH or opPCL == ANDROID_XYZS_ZH or opPCL == IOS_AISIPARK_ZH or opPCL == IOS_DOWNJOYPARK_ZH
    or opPCL == ANDROID_DOWNJOY_ZH then
    HostTable.DEFAULT_HOST = "http://park.sso.hzdw.com/public/"    -- 外网测试服务器
    HostTable.SSO_DEFAULT_HOST = "http://park.sso.hzdw.com/public/" -- 外网sso服务器
    HostTable.CDN_ROOT_OP2DXUP = "" -- cdn地址

--------- 苹果官方中文2 ios ---------
elseif opPCL == IOS_APPLE2_ZH then     
    HostTable.DEFAULT_HOST = "http://ios.ky.hzdw.com/public"    -- 外网测试服务器
    HostTable.SSO_DEFAULT_HOST = "http://ios.ky.hzdw.com/public/" -- 外网sso服务器
    HostTable.CDN_ROOT_OP2DXUP = "http://god.cdn.tainengmiao.com/onepiece/Apple/" -- cdn地址

--------- 太能中文 ios ---------
elseif opPCL == IOS_TW_ZH then         
    HostTable.DEFAULT_HOST = "http://ios.91.hzdw.com/public"    -- 默认游戏区
    HostTable.SSO_DEFAULT_HOST = "http://ios.91.hzdw.com/public/" -- sso服务器
    HostTable.CDN_ROOT_OP2DXUP = "http://ios.91.hzdw.com/public/resource/op2dxUp/" -- 测试服

--------- 太能中文测试 android ---------
elseif opPCL == ANDROID_TW_ZH then
    HostTable.DEFAULT_HOST = "http://test.hzdw.com/public"    -- 外网测试服务器
    HostTable.SSO_DEFAULT_HOST = "http://test.hzdw.com/public/" -- 外网sso服务器
    HostTable.CDN_ROOT_OP2DXUP = "http://god.cdn.tainengmiao.com/onepiece/Octopus/" -- cdn地址

-- --------- 快用中文 ios ---------
elseif opPCL == IOS_KY_ZH then         
    HostTable.DEFAULT_HOST = "http://ios.ky.hzdw.com/public"    -- 外网测试服务器
    HostTable.SSO_DEFAULT_HOST = "http://ios.ky.hzdw.com/public/" -- 外网sso服务器
    HostTable.CDN_ROOT_OP2DXUP = "http://god.cdn.tainengmiao.com/onepiece/KuaiYong/" -- cdn地址

--------- ITOOLS中文 ios ---------
elseif opPCL == IOS_ITOOLS then         
    HostTable.DEFAULT_HOST = "http://ios.ky.hzdw.com/public"    -- 外网测试服务器
    HostTable.SSO_DEFAULT_HOST = "http://ios.ky.hzdw.com/public/" -- 外网sso服务器
    HostTable.CDN_ROOT_OP2DXUP = "http://god.cdn.tainengmiao.com/onepiece/KuaiYong/" -- cdn地址

--------- pp中文 ios ---------
elseif opPCL == IOS_PPZS_ZH then         
    HostTable.DEFAULT_HOST = "http://ios.ky.hzdw.com/public"    -- 外网测试服务器
    HostTable.SSO_DEFAULT_HOST = "http://ios.ky.hzdw.com/public/" -- 外网sso服务器
    HostTable.CDN_ROOT_OP2DXUP = "http://god.cdn.tainengmiao.com/onepiece/KuaiYong/" -- cdn地址

--------- 同步推中文 ios ---------
elseif opPCL == IOS_TBT_ZH then         
    HostTable.DEFAULT_HOST = "http://ios.ky.hzdw.com/public"    -- 外网测试服务器
    HostTable.SSO_DEFAULT_HOST = "http://ios.ky.hzdw.com/public/" -- 外网sso服务器
    HostTable.CDN_ROOT_OP2DXUP = "http://god.cdn.tainengmiao.com/onepiece/KuaiYong/" -- cdn地址

--------- 91中文 ios ---------
elseif opPCL == IOS_91_ZH then         
    HostTable.DEFAULT_HOST = "http://ios.ky.hzdw.com/public"    -- 外网测试服务器
    HostTable.SSO_DEFAULT_HOST = "http://ios.ky.hzdw.com/public/" -- 外网sso服务器
    HostTable.CDN_ROOT_OP2DXUP = "http://god.cdn.tainengmiao.com/onepiece/KuaiYong/" -- cdn地址

--------- MobGame 越南 ios ---------
elseif opPCL == IOS_VIETNAM_VI then         
    HostTable.DEFAULT_HOST = "http://op.vn.apple.7talent.com/public"    -- 外网测试服务器
    HostTable.SSO_DEFAULT_HOST = "http://op.vn.apple.7talent.com/public/" -- 外网sso服务器
    HostTable.CDN_ROOT_OP2DXUP = "http://dwahp0epjgbcd.cloudfront.net/" -- cdn地址

--------- MobGame 越南 ios ---------
elseif opPCL == IOS_VIETNAM_EN or opPCL == IOS_MOBNAPPLE_EN or opPCL == ANDROID_VIETNAM_EN 
    or opPCL == ANDROID_VIETNAM_EN_ALL or opPCL == IOS_VIETNAM_ENSAGA then
    HostTable.DEFAULT_HOST = "http://op.sea.7talent.com/public/"    -- 外网测试服务器
    HostTable.SSO_DEFAULT_HOST = "http://op.sea.7talent.com/public/" -- 外网sso服务器
    HostTable.CDN_ROOT_OP2DXUP = "http://d3dnmlb6mepg43.cloudfront.net/" -- cdn地址

--------- MobGame 西班牙 ---------
elseif opPCL ==  IOS_MOBGAME_SPAIN or opPCL == ANDROID_MOBGAME_SPAIN then
    HostTable.DEFAULT_HOST = "http://op.la.7talent.com/public/"    -- 外网测试服务器
    HostTable.SSO_DEFAULT_HOST = "http://op.la.7talent.com/public/" -- 外网sso服务器
    HostTable.CDN_ROOT_OP2DXUP = "http://d3dnmlb6mepg43.cloudfront.net/" -- cdn地址

--------- MobGame 越南 ios thai ---------
elseif opPCL == IOS_MOB_THAI then
    HostTable.DEFAULT_HOST = "http://op.th.7talent.com/public/"    -- 外网测试服务器
    HostTable.SSO_DEFAULT_HOST = "http://op.th.7talent.com/public/" -- 外网sso服务器
    HostTable.CDN_ROOT_OP2DXUP = "http://d17318cjgpzurb.cloudfront.net/" -- cdn地址

--------- MobGame 越南 android thai ---------
elseif opPCL == ANDROID_VIETNAM_MOB_THAI then
    HostTable.DEFAULT_HOST = "http://op.th.7talent.com/public/"    -- 外网测试服务器
    HostTable.SSO_DEFAULT_HOST = "http://op.th.7talent.com/public/" -- 外网sso服务器
    HostTable.CDN_ROOT_OP2DXUP = "http://d17318cjgpzurb.cloudfront.net/" -- cdn地址

--------- MobGame 越南 android ---------
elseif opPCL == ANDROID_VIETNAM_VI then          
    --HostTable.DEFAULT_HOST = "http://op.vn.android.test.7talent.com/public"    -- 外网测试服务器
    --HostTable.SSO_DEFAULT_HOST = "http://op.vn.android.test.7talent.com/public/" -- 外网sso服务器
    --HostTable.CDN_ROOT_OP2DXUP = "http://dwahp0epjgbcd.cloudfront.net/" -- cdn地址
    HostTable.DEFAULT_HOST = "http://op.vn.apple.7talent.com/public"    -- 外网测试服务器
    HostTable.SSO_DEFAULT_HOST = "http://op.vn.apple.7talent.com/public/" -- 外网sso服务器
    HostTable.CDN_ROOT_OP2DXUP = "http://dwahp0epjgbcd.cloudfront.net/" -- cdn地址
--------- 小米 中文 android ---------
elseif opPCL == ANDROID_XIAOMI_ZH then
    HostTable.DEFAULT_HOST = "http://android.mi.hzdw.com/public/"    -- 外网测试服务器
    HostTable.SSO_DEFAULT_HOST = "http://android.mi.hzdw.com/public/" -- 外网sso服务器
    HostTable.CDN_ROOT_OP2DXUP = "http://god.cdn.tainengmiao.com/onepiece/XiaoMi/" -- cdn地址
--------- OPPO 中文 android ---------
elseif opPCL == ANDROID_OPPO_ZH then
    HostTable.DEFAULT_HOST = "http://android.oppo.hzdw.com/public"    -- 测试服务器
    HostTable.SSO_DEFAULT_HOST = "http://android.oppo.hzdw.com/public/" -- 正式服务器
    HostTable.CDN_ROOT_OP2DXUP = "http://god.cdn.tainengmiao.com/onepiece/OPPO/" -- cdn地址
    --------- UC 中文 android ---------
elseif opPCL == ANDROID_UC_ZH then
    HostTable.DEFAULT_HOST = "http://android.mi.hzdw.com/public/"    -- 外网测试服务器
    HostTable.SSO_DEFAULT_HOST = "http://android.mi.hzdw.com/public/" -- 外网sso服务器
    HostTable.CDN_ROOT_OP2DXUP = "http://god.cdn.tainengmiao.com/onepiece/XiaoMi/" -- cdn地址

elseif opPCL == ANDROID_MM_ZH then             -- ios 测试
    HostTable.DEFAULT_HOST = "http://android.baidu.hzdw.com/public"    -- 外网测试服务器
    HostTable.SSO_DEFAULT_HOST = "http://android.baidu.hzdw.com/public/" -- 外网sso服务器
    HostTable.CDN_ROOT_OP2DXUP = "http://god.cdn.tainengmiao.com/onepiece/ydmm/" -- cdn地址
--------- 百度中文测试 android ---------
elseif opPCL == ANDROID_BAIDU_ZH then
    HostTable.DEFAULT_HOST = "http://android.baidu.hzdw.com/public"    -- 测试服务器
    HostTable.SSO_DEFAULT_HOST = "http://android.baidu.hzdw.com/public/" -- 正式服务器
    HostTable.CDN_ROOT_OP2DXUP = "http://god.cdn.tainengmiao.com/onepiece/BaiDu/" -- cdn地址
    
elseif opPCL == ANDROID_BAIDUIAPPPAY_ZH then
    HostTable.DEFAULT_HOST = "http://android.baidu.hzdw.com/public"    -- 测试服务器
    HostTable.SSO_DEFAULT_HOST = "http://android.baidu.hzdw.com/public/" -- 正式服务器
    HostTable.CDN_ROOT_OP2DXUP = "http://god.cdn.tainengmiao.com/onepiece/BaiDu/" -- cdn地址
--------- 阿游戏中文测试 android ---------
elseif opPCL == ANDROID_AGAME_ZH then
    HostTable.DEFAULT_HOST = "http://android.mi.hzdw.com/public"    -- 测试服务器
    HostTable.SSO_DEFAULT_HOST = "http://android.mi.hzdw.com/public/" -- 正式服务器
    HostTable.CDN_ROOT_OP2DXUP = "http://god.cdn.tainengmiao.com/onepiece/AGame/" -- cdn地址
    
elseif opPCL == ANDROID_91_ZH then
    HostTable.DEFAULT_HOST = "http://android.mi.hzdw.com/public/"    -- 测试服务器
    HostTable.SSO_DEFAULT_HOST = "http://android.mi.hzdw.com/public/" -- 正式服务器
    HostTable.CDN_ROOT_OP2DXUP = "http://god.cdn.tainengmiao.com/onepiece/XiaoMi/" -- cdn地址

elseif opPCL == ANDROID_WDJ_ZH then
    HostTable.DEFAULT_HOST = "http://android.mi.hzdw.com/public/"    -- 测试服务器
    HostTable.SSO_DEFAULT_HOST = "http://android.mi.hzdw.com/public/" -- 正式服务器
    HostTable.CDN_ROOT_OP2DXUP = "http://god.cdn.tainengmiao.com/onepiece/XiaoMi/" -- cdn地址

elseif opPCL == ANDROID_360_ZH then
    HostTable.DEFAULT_HOST = "http://android.mi.hzdw.com/public/"    -- 外网测试服务器
    HostTable.SSO_DEFAULT_HOST = "http://android.mi.hzdw.com/public/" -- 外网sso服务器
    HostTable.CDN_ROOT_OP2DXUP = "http://god.cdn.tainengmiao.com/onepiece/XiaoMi/" -- cdn地址

elseif opPCL == ANDROID_GV_MFACE_ZH or opPCL == ANDROID_GV_XJP_ZH then
    HostTable.DEFAULT_HOST = "http://op.ms.7talent.com/public/"    -- 外网测试服务器
    HostTable.SSO_DEFAULT_HOST = "http://op.ms.7talent.com/public/" -- 外网sso服务器
    HostTable.CDN_ROOT_OP2DXUP = "http://data-kdhzw.mface.me/" -- cdn地址

elseif opPCL == IOS_GAMEVIEW_ZH then
    HostTable.DEFAULT_HOST = "http://op.ms.7talent.com/public/"    -- 外网测试服务器
    HostTable.SSO_DEFAULT_HOST = "http://op.ms.7talent.com/public/" -- 外网sso服务器
    HostTable.CDN_ROOT_OP2DXUP = "http://data-kdhzw.mface.me/" -- cdn地址

elseif opPCL == IOS_GAMEVIEW_EN or opPCL == ANDROID_GV_MFACE_EN or opPCL == IOS_GVEN_BREAK
or  opPCL == ANDROID_GV_MFACE_EN_OUMEI or opPCL == ANDROID_GV_MFACE_EN_OUMEINEW  then
    HostTable.DEFAULT_HOST = "http://op.msen.7talent.com/public/"    -- 外网测试服务器
    HostTable.SSO_DEFAULT_HOST = "http://op.msen.7talent.com/public/" -- 外网sso服务器
    HostTable.CDN_ROOT_OP2DXUP = "http://data-plusop.mface.me/" -- cdn地址data-plusop.mface.me

elseif opPCL == IOS_GAMEVIEW_TC or opPCL == ANDROID_GV_MFACE_TC or opPCL == ANDROID_GV_MFACE_TC_GP  then
    HostTable.DEFAULT_HOST = "http://op.tw.7talent.com/public/"    -- 外网测试服务器
    HostTable.SSO_DEFAULT_HOST = "http://op.tw.7talent.com/public/" -- 外网sso服务器
    HostTable.CDN_ROOT_OP2DXUP = "http://data-kdhzw.mface.me/tc/" -- cdn地址
------------------猎豹繁体---------------
elseif opPCL == ANDROID_JAGUAR_TC  or opPCL == IOS_JAGUAR_TC  then
    HostTable.DEFAULT_HOST = "http://op.liebao.7talent.com/public/"    -- 外网测试服务器
    HostTable.SSO_DEFAULT_HOST = "http://op.liebao.7talent.com/public/" -- 外网sso服务器
    HostTable.CDN_ROOT_OP2DXUP = "http://5978695d26333c09.tan14.net/onepiece/" -- cdn地址

elseif opPCL == ANDROID_MMY_ZH then
    HostTable.DEFAULT_HOST = "http://android.baidu.hzdw.com/public/"    -- 测试服务器
    HostTable.SSO_DEFAULT_HOST = "http://android.baidu.hzdw.com/public/" -- 正式服务器
    -- HostTable.CDN_ROOT_OP2DXUP = "http://god.cdn.tainengmiao.com/onepiece/360/" -- cdn地址
    HostTable.CDN_ROOT_OP2DXUP = "http://god.cdn.tainengmiao.com/onepiece/BaiDu/" -- cdn地址     

elseif opPCL == ANDROID_DK_ZH then
    HostTable.DEFAULT_HOST = "http://android.mi.hzdw.com/public/"    -- 测试服务器
    HostTable.SSO_DEFAULT_HOST = "http://android.mi.hzdw.com/public/" -- 正式服务器
    -- HostTable.CDN_ROOT_OP2DXUP = "http://god.cdn.tainengmiao.com/onepiece/360/" -- cdn地址
    HostTable.CDN_ROOT_OP2DXUP = "http://god.cdn.tainengmiao.com/onepiece/DK/" -- cdn地址
--------- TGame IOS 中文版 ---------
elseif opPCL == IOS_TGAME_ZH then
    HostTable.DEFAULT_HOST = "http://test.hzdw.com/public/"    -- 外网测试服务器
    HostTable.SSO_DEFAULT_HOST = "http://test.hzdw.com/public/" -- 外网sso服务器
    HostTable.CDN_ROOT_OP2DXUP = "http://god.cdn.tainengmiao.com/onepiece/KuaiYong/" -- cdn地址
--------- TGame IOS 中文版 ---------
elseif opPCL == ANDROID_TGAME_ZH then
    HostTable.DEFAULT_HOST = "http://test.hzdw.com/public/"    -- 外网测试服务器
    HostTable.SSO_DEFAULT_HOST = "http://test.hzdw.com/public/" -- 外网sso服务器
    HostTable.CDN_ROOT_OP2DXUP = "http://god.cdn.tainengmiao.com/onepiece/KuaiYong/" -- cdn地址
--------- TGame IOS Android 韩文版 ---------
elseif opPCL == IOS_TGAME_KR or opPCL == ANDROID_TGAME_KR  or opPCL == ANDROID_TGAME_KRNEW  then
    HostTable.DEFAULT_HOST = "http://op.kr.7talent.com/public/"    -- 外网测试服务器
    HostTable.SSO_DEFAULT_HOST = "http://op.kr.7talent.com/public/" -- 外网sso服务器
    HostTable.CDN_ROOT_OP2DXUP = "http://cdn.opkr.7talent.com/onepiece/" -- cdn地址

--------- TGame IOS Android 俄语版 ---------
elseif opPCL == IOS_INFIPLAY_RUS then
    HostTable.DEFAULT_HOST = "http://op.ru.7talent.com/public"    -- 外网测试服务器
    HostTable.SSO_DEFAULT_HOST = "http://op.ru.7talent.com/public/" -- 外网sso服务器
    HostTable.CDN_ROOT_OP2DXUP = "http://opm-cdn.infiplay.ru/onepiece/" -- cdn地址

    --------- TGame Android 俄语版 ---------
elseif opPCL == ANDROID_INFIPLAY_RUS then
    HostTable.DEFAULT_HOST = "http://op.ru.7talent.com/public"    -- 外网测试服务器
    HostTable.SSO_DEFAULT_HOST = "http://op.ru.7talent.com/public/" -- 外网sso服务器
    HostTable.CDN_ROOT_OP2DXUP = "http://opm-cdn.infiplay.ru/onepiece/" -- cdn地址

elseif opPCL == ANDROID_HUAWEI_ZH then
    HostTable.DEFAULT_HOST = "http://ios.ky.hzdw.com/public"    -- 外网测试服务器
    HostTable.SSO_DEFAULT_HOST = "http://ios.ky.hzdw.com/public/" -- 外网sso服务器
    HostTable.CDN_ROOT_OP2DXUP = "http://god.cdn.tainengmiao.com/onepiece/KuaiYong/" -- cdn地址
--------- 酷派支付 百度登陆 android ---------
elseif opPCL == ANDROID_COOLPAY_ZH then
    HostTable.DEFAULT_HOST = "http://ios.ky.hzdw.com/public"    -- 外网测试服务器
    HostTable.SSO_DEFAULT_HOST = "http://ios.ky.hzdw.com/public/" -- 外网sso服务器
    HostTable.CDN_ROOT_OP2DXUP = "http://god.cdn.tainengmiao.com/onepiece/KuaiYong/" -- cdn地址
--------- 金立 android ---------
elseif opPCL == ANDROID_GIONEE_ZH then
    HostTable.DEFAULT_HOST = "http://ios.ky.hzdw.com/public"    -- 外网测试服务器
    HostTable.SSO_DEFAULT_HOST = "http://ios.ky.hzdw.com/public/" -- 外网sso服务器
    HostTable.CDN_ROOT_OP2DXUP = "http://god.cdn.tainengmiao.com/onepiece/KuaiYong/" -- cdn地址
--------- 安锋网 android ---------
elseif opPCL == ANDROID_ANFENG_ZH then
    HostTable.DEFAULT_HOST = "http://ios.ky.hzdw.com/public"    -- 外网测试服务器
    HostTable.SSO_DEFAULT_HOST = "http://ios.ky.hzdw.com/public/" -- 外网sso服务器
    HostTable.CDN_ROOT_OP2DXUP = "http://god.cdn.tainengmiao.com/onepiece/KuaiYong/" -- cdn地址
--------- HTC android ---------
elseif opPCL == ANDROID_HTC_ZH then
    HostTable.DEFAULT_HOST = "http://ios.ky.hzdw.com/public"    -- 外网测试服务器
    HostTable.SSO_DEFAULT_HOST = "http://ios.ky.hzdw.com/public/" -- 外网sso服务器
    HostTable.CDN_ROOT_OP2DXUP = "http://god.cdn.tainengmiao.com/onepiece/KuaiYong/" -- cdn地址
--------- 爱思  ios ---------
elseif opPCL == IOS_AISI_ZH then
    HostTable.DEFAULT_HOST = "http://ios.ky.hzdw.com/public"    -- 外网测试服务器
    HostTable.SSO_DEFAULT_HOST = "http://ios.ky.hzdw.com/public/" -- 外网sso服务器
    HostTable.CDN_ROOT_OP2DXUP = "http://god.cdn.tainengmiao.com/onepiece/KuaiYong/" -- cdn地址
--------- 指游  android --------
elseif  opPCL == ANDROID_MYEPAY_ZH then
    HostTable.DEFAULT_HOST = "http://ios.ky.hzdw.com/public"    -- 外网测试服务器
    HostTable.SSO_DEFAULT_HOST = "http://ios.ky.hzdw.com/public/" -- 外网sso服务器
    HostTable.CDN_ROOT_OP2DXUP = "http://god.cdn.tainengmiao.com/onepiece/KuaiYong/" -- cdn地址
elseif opPCL == WP_VIETNAM_VN then
    HostTable.DEFAULT_HOST = "http://op.vn.apple.7talent.com/public"    -- 外网测试服务器
    HostTable.SSO_DEFAULT_HOST = "http://op.vn.apple.7talent.com/public/" -- 外网sso服务器
    HostTable.CDN_ROOT_OP2DXUP = "http://dwahp0epjgbcd.cloudfront.net/" -- cdn地址
elseif opPCL == WP_VIETNAM_EN then
    HostTable.DEFAULT_HOST = "http://op.sea.7talent.com/public/"    -- 外网测试服务器
    HostTable.SSO_DEFAULT_HOST = "http://op.sea.7talent.com/public/" -- 外网sso服务器
    HostTable.CDN_ROOT_OP2DXUP = "http://d3dnmlb6mepg43.cloudfront.net/" -- cdn地址
elseif opPCL == IOS_TGAME_TC or opPCL == ANDROID_TGAME_TC then
    HostTable.DEFAULT_HOST = "http://op.hk.7talent.com/public/"    -- 外网测试服务器
    HostTable.SSO_DEFAULT_HOST = "http://op.hk.7talent.com/public/" -- 外网sso服务器
    HostTable.CDN_ROOT_OP2DXUP = "http://op.hk.7talent.com/admin" -- cdn地址
elseif opPCL == IOS_TGAME_TH or opPCL == ANDROID_TGAME_THAI then
    HostTable.DEFAULT_HOST = "http://op.koth.7talent.com/public/"    -- 外网测试服务器
    HostTable.SSO_DEFAULT_HOST = "http://op.koth.7talent.com/public/" -- 外网sso服务器
    HostTable.CDN_ROOT_OP2DXUP = "http://op.koth.7talent.com/admin" -- cdn地址
end

-- 动作管理
ActionTable = nil
ActionTable = {
    -- sso action
    SSO_LOGIN_URL = "?action=sLogin",           
    SSO_GENERATEUID_URL = "?action=sGenerateUid",
    SSO_TOURIST_LOGIN_URL = "?action=sgLogin",         -- 游客方式第一次登陆
    SSO_BINDING_ACCOUNT_URL = "?action=sBindingAccount",    -- 绑定账号
    SSO_REGISTER_ACCOUNT_URL = "?action=sRegisterAccount",       -- 注册新账号
    SSO_MODIFY_PWD_URL = "?action=sUpdatePassword",     -- 修改密码
    SSO_GETSERVERLISTBYVERSION_URL = "?action=getServerListByVersion",   -- 从sso服务器取最新的服务器列表
    -- SSO_REGISTER_URL = "?action=sRegister",
    -- SSO_REGISTER_V2_URL = "?action=sRegister_V2",
    -- sso action end

    -- game server action
    LOGIN_URL = "?action=login",
    TEST_LOGIN_URL = "?action=testlogin",
    REGISTER_URL = "?action=register",
    ADDAPPLEORDER_URL = "?action=addAppleOrder",
    GET_SERVERLISTBYVERSION_URL = "/?action=getServerListByVersion",
    GET_SERVERLIST_URL = "/?action=getServerList",
    SERVERTIME_URL = "?action=getServerTime",
    CONFIGURE_URL = "?action=getSetting",
    GETVIEWER_URL = "?action=getViewer",

    PICKNAME_URL = "?action=pickName",

    GET_LASTEST_VERSION = "?action=getLatestAppVersion",

    GET_LASTEST_VERSION_V2 = "?action=public_getVersionInfo",
    SSO_GETSERVERLISTBYVERSION_URL_V2 = "?action=public_getServerList",
    SSO_LOGIN_URL_V2 = "?action=sLoginNew",
}


SERVERCODE = {
    SSO = "serverSso",
    LIST = "serverList",
}

--  ERROR CODE
ErrorCodeTable = {
    ERR_401 = 401,          -- 用户未登陆
    ERR_402 = 402,          -- 在其他设备登陆
    ERR_1118 = 1118,        -- 字符串太长
    ERR_1201 = 1201,        -- 账号或密码错误
    ERR_1202 = 1202,        -- sso已经绑定过账号，不是游客账号了
    ERR_1203 = 1203,        -- 账号不合法
    ERR_1204 = 1204,        -- 注册账号长度过长或者过短
    ERR_1205 = 1205,        -- 当前账号已经被注册
    ERR_1206 = 1206,        -- 注册密码长度过长或者过短
    ERR_1207 = 1207,        -- 登录游戏区时，玩家没有初始化
    ERR_1208 = 1208,        -- 账号被封
    ERR_1209 = 1209,        -- 玩家已经注册过了
    ERR_1210 = 1210,        -- sso账号索引对应的ssoId对应的ssouser不存在
    ERR_1211 = 1211,        -- sso账号是游客账号，不能改密码
    ERR_1212 = 1212,        -- sso账号不存在
    ERR_1213 = 1213,        -- sso服务器校验失败（需要踢到登陆sso页面）

    ERR_1116 = 1116,        -- 并发操作问题，提示玩家重试
    
    ERR_9999 = 9999,        -- 未知错误

}

-- 发送请求
local function getTaskFun( url, serverCode, callBackFun, callbackErrorFun, isSSO, isLoading )
    -- body
    --print("xixixixixixixixi")
    print(url)
    url = string.gsub(url, "%%", "%%25")
    url = string.gsub(url,"%s","%%20")
    -- url = string.urlencode(url)
    url = string.gsub(url,"%+","%%2B")

    local requestItem = CCHttpRequest:open(url, kHttpGet)
    local httpHeaders = requestItem:getHeaders()
    if httpHeaders == nil then
        httpHeaders = CCArray:create()
    end
    if userdata and userdata.sessionId and string.len(userdata.sessionId) > 0 and isSSO ~= 1 then
        httpHeaders:addObject(CCString:create("sid:" .. userdata.sessionId))
    end

    httpHeaders:addObject(CCString:create("aid:" .. opPCLId))         -- 韩语版的aid
    if serverCode then
        httpHeaders:addObject(CCString:create("serverCode:" .. serverCode))   -- 区服编码
    end
    
    -- 添加 MAC \ IDFA \ OpenUUID \ CurrSysVer
    -- httpHeaders:addObject(CCString:create("MACInfo:" .. Global:getMACInfo()))
    -- httpHeaders:addObject(CCString:create("IDFAInfo:" .. Global:getIDFAInfo()))
    -- httpHeaders:addObject(CCString:create("CurrSysVer:" .. Global:getCurrSysVer()))
    -- httpHeaders:addObject(CCString:create("OpenUUIDInfo:" .. Global:getOpenUUIDInfo()))

    requestItem:setHeaders(httpHeaders)
    -- requestItem:setTimeoutForRead(5)
    requestItem:sendWithHandler(
    function(res, hnd)

        rtnRes = {data = res:getResponseData(), code = res:getResponseCode()}
        --print("++++++++++"..rtnRes.code)


        -- rtnData check        
        -- print("==="..rtnRes.code.."       " ..string.len(rtnRes.data).."==="..rtnRes.data)

        -- HTTP code check
        if rtnRes.code ~= 200 then 
            if isLoading then
                userdata:subDCount()
            end
            print("network error", res:getErrorBuffer())
            local layer = CCDirector:sharedDirector():getRunningScene():getChildByTag(65525)
            if layer then
                layer:removeFromParentAndCleanup(true)
                layer = nil
            end
            if tonumber(rtnRes.code) == -1 then
                if ShowText then
                    ShowText(HLNSLocalizedString("Network_Error_TimeOut"))
                    local scene = CCDirector:sharedDirector():getRunningScene()
                    scene:addChild(createLoginErrorPopUpLayer(-1000), 10000)
                else
                    -- 只有再自动更新的时候 才会走这里  强制 切到登陆界面
                    updateErrorFun()
                end
                return
            else
                if ShowText then
                    ShowText(HLNSLocalizedString("Network_Error"))
                else
                    -- 只有再自动更新的时候 才会走这里  强制 切到登陆界面
                    updateErrorFun()
                end
            end 
            if callbackErrorFun ~= nil then
                callbackErrorFun(url, rtnRes.code)
            end
            return
        end 

        if not rtnRes.data or string.len(rtnRes.data) <= 32 then
            return
        end

        --print("=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=")
        local md5Str = string.sub(rtnRes.data, 0, 32)
        -- print(md5Str)

        local deflateData = string.sub(rtnRes.data, 33, string.len(rtnRes.data))
        --print("lingling")
        -- print(deflateData)
        print("----------------dataLen---------"..string.len(rtnRes.data))

        local deflateData = Global.getGzipFile(deflateData, string.len(rtnRes.data) - 32)
        -- print("--------=-------------------==--------"..deflateData)
        --新马 英文版 打开print会飞
        if not isPlatform(ANDROID_GV_MFACE_EN) and not isPlatform(ANDROID_GV_MFACE_EN_OUMEI) and not isPlatform(ANDROID_GV_MFACE_EN_OUMEINEW) then
            print(" Print By lixq ---- meyoumeyou~~")
        end

        local temp = deflateData
        -- print(string.len(deflateData))
        if isSSO ~= 1 then 
            if userdata and userdata.sessionId ~= nil then
                temp = deflateData..userdata.sessionId
            end
        end 
        local sign = Global.getMD5(temp, isSSO)

        if md5Str ~= sign then
            print("---------------md5error------------------")
            return
        end

        -- print(deflateData)
        local rtnData = json.decode(deflateData)
        --print("#######rtnData",rtnData)
        if isLoading then
            -- loading 的 减菊花 且调用 ControlModule
            userdata:subDCount()
        end
        print(" Print By lixq ---- before parseByControlModule sadfadsfafadslfsajlkdsf")
        if parseByControlModule then
            print("parseByControlModule123")
            parseByControlModule( url, rtnData["code"], rtnData )
            --print(url)
        end
        print(" Print By lixq ---- after parseByControlModule asdklfjlksdfjklfslkjfadsjkl")
        if rtnData["code"] ~= 200 and rtnData["code"] ~= ErrorCodeTable.ERR_1207 then
           -- print(" Print By lixq ---- ErrorCodeTable.ERR_1207asdklfjlksdfjklfslkjfadsjkl")
            if callbackErrorFun ~= nil then
                callbackErrorFun(url, rtnData["code"])
            end
            return
        end
        --callbackFun
        print(" ---- rtncode ", rtnRes.code)
        
        if callBackFun ~= nil then
            print("call back fun is not null")
         --PrintTable(json.decode(deflateData))
           -- print("print table done!")
         --print(url)
         
        callBackFun(url, rtnData)
        end
        
    end)
end

-- 生成签名函数
local function getSign( actionType, params, isSSO)
    -- body

    -- 截取action等号后面部分
    local i,j = string.find(actionType, "=")
    --print("-----"..i.."======"..j)
    actionType = string.sub(actionType, j + 1, string.len(actionType))
    -- print("-----------"..actionType)

    local session = ""
    if userdata then
        session = userdata.sessionId
    end
    if isSSO == 1 then
        session = ""
    end

    -- local appId4Md5 = "pirate1"

    local sign = ""
    if isSSO == 1 then
        local md5Str = actionType
        if params and params ~= nil then
            md5Str = md5Str..params
        end
        -- md5Str = md5Str..appId4Md5
        --PrintTable(Global.getMD5)
        sign = Global.getMD5(md5Str, isSSO)
    else
        local md5Str = actionType
        if params and params ~= nil then
            md5Str = md5Str..params
        end
        if session ~= nil then 
            md5Str = md5Str..session
        end
        
        print(" ----------- md5Str ", md5Str)
        sign = Global.getMD5(md5Str, isSSO)
    end
    return sign
end

local function doAction( actionType, serverCode, params, callBackFun, callbackErrorFun, isLoading, isSSO )
    -- body
    if params and params ~= nil and params ~= "" then
        params = json.encode(params)
    else
        params = nil
    end
    local sign = getSign(ActionTable[actionType], params, 0)
    -- print(params)
    local url = HostTable.DEFAULT_HOST
    if not isSSO and userdata and userdata.selectServer then
        url = userdata.selectServer["url"]
    end
    url = url..ActionTable[actionType]
    if params and params ~= nil and params ~= "" then
        url = url.."&params="..params
    end
    url = url.."&sign="..sign

    getTaskFun(url, serverCode, callBackFun, callbackErrorFun, 0, isLoading)
end

-- 公开调用方法
function doActionNoLoadingFun( actionType, params, callBackFun, serverCode, isSSO )
    -- body
    if not serverCode and userdata then
        serverCode = userdata.serverCode
    end
    doAction(actionType, serverCode, params, callBackFun, nil, nil, isSSO)
end

-- 公开调用方法
function doActionFun( actionType, params, callBackFun, callbackErrorFun, serverCode )
    -- body
    userdata:addDCount()
    if not serverCode then
        serverCode = userdata.serverCode
    end
    doAction(actionType, serverCode, params, callBackFun, callbackErrorFun, true)
end

-- SSO公开调用方法
function doSSOActionFun( actionType, params, callBackFun, errorFun )
    -- body
    userdata:addDCount()
    print(" Print By lixq ---- doSSOActionFun 1")
    params = json.encode(params)
    print(" Print By lixq ---- doSSOActionFun 2")
    local sign = getSign(ActionTable[actionType], params, 0)
    print(" Print By lixq ---- doSSOActionFun 3")
    -- print(sign)
    -- print(HostTable.SSO_DEFAULT_HOST)
    -- print(ActionTable[actionType]) 
    -- print(params)
    local url = HostTable.SSO_DEFAULT_HOST..ActionTable[actionType].."&params="..params.."&sign="..sign
    -- print("url = "..url)
    getTaskFun(url, SERVERCODE.SSO, callBackFun, errorFun, 0, true)
end

-- downloadFile
function downloadFile( url, filePath, callBackFun, isLoading, fileName )
    -- body
    if isLoading then
        userdata:addDCount()
    end
    -- print(" Print by lixq downfile ---- ", url, filePath)
    local req = CCHttpRequest:open(url, kHttpGet)
    local httpHeaders = req:getHeaders()
    if httpHeaders == nil then
        httpHeaders = CCArray:create()
    end
    httpHeaders:addObject(CCString:create("aid:"..opPCLId))         -- 韩语版的aid
    if userdata then
        httpHeaders:addObject(CCString:create("serverCode:"..userdata.serverCode))   -- 区服编码
        httpHeaders:addObject(CCString:create("sid:"..userdata.sessionId))
    end
    req:setHeaders(httpHeaders)
    req:sendWithHandler(
    function(res, hnd)
        rtnRes = {data = res:getResponseData(), code = res:getResponseCode()}
         print("downloadFile ++++++++++", rtnRes.code)
        
        -- HTTP code check
        if rtnRes.code == 200 then
            if GameHelper:createDir(filePath) then
                -- print("---- filePath --- "..filePath)
                local file = io.open(filePath, "w+")
                file:write(rtnRes.data)
                file:close()
            end
        end
        
        --callbackFun
        if isLoading then
            userdata:subDCount()
        end
        if callBackFun ~= nil then
            callBackFun(rtnRes.code, fileName)
        end
        
    end)
end

-- download Configure File
function downloadConfFile( url, filePath, callBackFun, isLoading )
    -- body
    if isLoading then
        userdata:addDCount()
    end
    print(" Print by lixq downfile ---- ", url, filePath)
    local req = CCHttpRequest:open(url, kHttpGet)
    local httpHeaders = req:getHeaders()
    if httpHeaders == nil then
        httpHeaders = CCArray:create()
    end
    httpHeaders:addObject(CCString:create("aid:"..opPCLId))         -- 韩语版的aid
    httpHeaders:addObject(CCString:create("serverCode:"..userdata.serverCode))   -- 区服编码
    httpHeaders:addObject(CCString:create("sid:"..userdata.sessionId))
    req:setHeaders(httpHeaders)
    req:sendWithHandler(
    function(res, hnd)
        rtnRes = {data = res:getResponseData(), code = res:getResponseCode()}
        -- print("++++++++++"..rtnRes.code)

        -- HTTP code check
        if rtnRes.code ~= 200 then 
            if isLoading then
                userdata:subDCount()
            end
            print("network error", res:getErrorBuffer())
            if tonumber(rtnRes.code) == -1 then
                ShowText(HLNSLocalizedString("Network_Error_TimeOut"))
            else
                ShowText(HLNSLocalizedString("Network_Error"))
            end 
            postNotification(NOTI_DOWNLOAD_ERR, tonumber(rtnRes.code))
            return
        end 

        -- print("----------"..string.len(rtnRes.data).."==="..rtnRes.data)
        if not rtnRes.data or string.len(rtnRes.data) <= 32 then
            return
        end

        print("=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=")
        local md5Str = string.sub(rtnRes.data, 0, 32)
        -- print(md5Str)

        local deflateData = string.sub(rtnRes.data, 33, string.len(rtnRes.data))
        -- print(deflateData)
        print("downloadConfFile----------------dataLen---------"..string.len(rtnRes.data))

        local deflateData = Global.getGzipFile(deflateData, string.len(rtnRes.data) - 32)
        --print("downloadConfFile--------=-------------------==--------"..deflateData)
        local temp = deflateData
        if userdata.sessionId ~= nil then
            temp = deflateData..userdata.sessionId
        end
        local sign = Global.getMD5(temp, false)

        if md5Str ~= sign then
            print("---------------md5error------------------")
            return
        end

        -- local rtnData = json.decode(deflateData)
        -- print("Conf rtnData =",deflateData)

        -- HTTP code check
        if GameHelper:createDir(filePath) then
            -- print("---- filePath --- "..filePath)
            local file = io.open(filePath, "w+")
            file:write(deflateData)
            file:close()
            GameHelper:encrypt(filePath)
        end
        --callbackFun
        if isLoading then
            userdata:subDCount()
        end
        if callBackFun ~= nil then
            callBackFun(rtnRes.code)
        end
        
    end)
end

-- do download Configure
function doDownLoadConf( actionType, filePath, callBackFun )
    -- body
    print(" ---- doDownLoadConf config ---- ")
    local url = HostTable.DEFAULT_HOST
    if userdata.selectServer then
        url = userdata.selectServer["url"]
    end
    url = url..ActionTable[actionType]
    downloadConfFile(url, filePath, callBackFun, true)
end

-- 检查订单有效性 发放道具
function buyItemCheckFun( itemId, orderId )
    -- body
    
    local function checkBuyCallBack( url, rtnData )
        userdata:addDCount()
        -- body
        -- print("123123123123123123123123-----------123")
        Global.succPay4GetItem()
        -- print("123123123123123123123123-----------321")
        -- PrintTable(rtnData["info"])
    end
    print("Print By lixq ---- buyItemCheckFun !!!!!!!!!!!!")
    local params = {}
    table.insert(params, userdata.userId)  -- userid
    table.insert(params, userdata.selectServer["id"])  -- 服务器ID
    table.insert(params, orderId)  -- 订单号
    table.insert(params, itemId)  -- 物品ID
    table.insert(params, 1)  -- 数量
    table.insert(params, 1)  -- 是否直接使用 1 是 0 否
    doActionFun("CHECK_BUY_ORDER", params, checkBuyCallBack)
end

function startHttpRequest(url, callBackFun)
    local requestItem = CCHttpRequest:open(url, kHttpGet)

    requestItem:sendWithHandler(
    function(res, hnd)
        rtnRes = {data = res:getResponseData(), code = res:getResponseCode()}
        -- print(rtnRes.code)
        -- PrintTable(rtnRes.data)
        -- if rtnRes.code ~= 200 then 
        --     if isLoading then
        --         userdata:subDCount()
        --     end
        --     print("network error", res:getErrorBuffer())
        --     if tonumber(rtnRes.code) == -1 then
        --         ShowText(HLNSLocalizedString("Network_Error_TimeOut"))
        --     else
        --         ShowText(HLNSLocalizedString("Network_Error"))
        --     end 
        --     return
        -- end 
        if callBackFun ~= nil then
            -- PrintTable(json.decode(deflateData))
            callBackFun(url, rtnData)
        end
        
    end)
end

function googlePlayConsumeFin(  )
    -- body
    userdata:subDCount()
end

function decryptConfFileCallBack( data )
    -- body
    -- print(" Print By lixq ---- decryptConfFileCallBack ---- ", json.decode(data))
    -- PrintTable(json.decode(data))
    ConfigureStorage:fromDictionary(json.decode(data)["setting"])
end