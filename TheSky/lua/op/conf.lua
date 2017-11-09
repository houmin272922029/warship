-- 常用变量定义
pDirector = CCDirector:sharedDirector()
winSize = pDirector:getWinSize()

-- 配置文件名
CONF_FILE_NAME = "conf.json"
-- 更新用版本文件名
VERSION_JSON = "version.json"
-- avoid memory leak
collectgarbage("setpause", 100)
collectgarbage("setstepmul", 5000)

-- 文件操作简化
fileUtil = CCFileUtils:sharedFileUtils()
-- 配置文件存放路径
CONF_PATH = fileUtil:getWritablePath()
-- 默认配置存放模块
uDefault = CCUserDefault:sharedUserDefault()

-- 屏幕类型
screenType = Global:instance().screenType
-- 
retina = CCBReader:getResolutionScale()
-- 默认字体
MainFont = Global.MainFont

-- 应用id
opAppId = "pirate1"

-- 版本、平台、渠道
opPCL = Global:instance():getPCLStr()
-- 版本、渠道定义
WP_VIETNAM_VN = "WP_VIETNAM_VN"
WP_VIETNAM_EN = "WP_VIETNAM_EN"
IOS_TEST_ZH = "IOS_TEST_ZH"
ANDROID_TEST_ZH = "ANDROID_TEST_ZH"
IOS_APPLE_ZH = "IOS_APPLE_ZH"
IOS_IIAPPLE_ZH = "IOS_IIAPPLE_ZH"
IOS_APPLE2_ZH = "IOS_APPLE2_ZH"
IOS_TW_ZH = "IOS_TW_ZH"
ANDROID_TW_ZH = "ANDROID_TW_ZH"
IOS_91_ZH = "IOS_91_ZH"
ANDROID_91_ZH = "ANDROID_91_ZH"
ANDROID_360_ZH = "ANDROID_360_ZH"
ANDROID_MMY_ZH = "ANDROID_MMY_ZH"   --木蚂蚁
IOS_KY_ZH = "IOS_KY_ZH" 
IOS_KYPARK_ZH = "IOS_KYPARK_ZH"            -- 快用
ANDROID_KY_ZH = "ANDROID_KY_ZH"
IOS_PPZS_ZH = "IOS_PPZS_ZH"         -- pp助手
IOS_XYZS_ZH = "IOS_XYZS_ZH"         -- xy助手
ANDROID_XYZS_ZH = "ANDROID_XYZS_ZH"
IOS_TBT_ZH = "IOS_TBT_ZH"           -- 同步推
IOS_TBTPARK_ZH = "IOS_TBTPARK_ZH"           -- 同步推
IOS_HAIMA_ZH = "IOS_HAIMA_ZH"           -- 同步推
-- IOS_APPLE_ZH = "IOS_Korea_ZH"            
-- IOS_Korea_ZH = "IOS_VIETNAM_VI"       --韩语
ANDROID_XIAOMI_ZH = "ANDROID_XIAOMI_ZH" -- 小米
ANDROID_BAIDU_ZH = "ANDROID_BAIDU_ZH"   -- 百度安卓
ANDROID_OPPO_ZH = "ANDROID_OPPO_ZH"   -- OPPO
ANDROID_DOWNJOY_ZH = "ANDROID_DOWNJOY_ZH" -- 当乐安卓
ANDROID_UC_ZH = "ANDROID_UC_ZH"      --UC
ANDROID_MM_ZH = "ANDROID_MM_ZH"      --MM
IOS_ITOOLS = "IOS_ITOOLS" 
IOS_ITOOLSPARK = "IOS_ITOOLSPARK"          -- itools
ANDROID_AGAME_ZH = "ANDROID_AGAME_ZH"   -- AGame 阿游戏
ANDROID_DK_ZH = "ANDROID_DK_ZH"
IOS_VIETNAM_VI = "IOS_VIETNAM_VI"               -- 越南 ios
IOS_VIETNAM_EN = "IOS_VIETNAM_EN"  
IOS_VIETNAM_ENSAGA = "IOS_VIETNAM_ENSAGA" 
IOS_MOBGAME_SPAIN = "IOS_MOBGAME_SPAIN"
ANDROID_MOBGAME_SPAIN = "ANDROID_MOBGAME_SPAIN"
IOS_MOBNAPPLE_EN = "IOS_MOBNAPPLE_EN"           -- 越南英文非AppStore版本
IOS_MOB_THAI = "IOS_MOB_THAI"           -- mob的泰国语版本
ANDROID_VIETNAM_MOB_THAI = "ANDROID_VIETNAM_MOB_THAI" --android mob的泰国版本
ANDROID_VIETNAM_VI = "ANDROID_VIETNAM_VI"       -- 越南 android
ANDROID_VIETNAM_EN = "ANDROID_VIETNAM_EN"       --越南 android 英文
ANDROID_VIETNAM_EN_ALL = "ANDROID_VIETNAM_EN_ALL" --越南 android 英文 2
ANDROID_WDJ_ZH = "ANDROID_WDJ_ZH"       --豌豆荚
ANDROID_HUAWEI_ZH = "ANDROID_HUAWEI_ZH"       --华为
ANDROID_GV_MFACE_ZH = "ANDROID_GV_MFACE_ZH" --MFACE
ANDROID_GV_MFACE_EN = "ANDROID_GV_MFACE_EN" --mface 英文
ANDROID_GV_MFACE_EN_OUMEI = "ANDROID_GV_MFACE_EN_OUMEI" --mface 欧美
ANDROID_GV_MFACE_EN_OUMEINEW = "ANDROID_GV_MFACE_EN_OUMEINEW"   --mface 欧美（0803）
ANDROID_GV_MFACE_TC = "ANDROID_GV_MFACE_TC" -- GameView MFace TC
ANDROID_GV_MFACE_TC_GP = "ANDROID_GV_MFACE_TC_GP" --GameView MFace TC GP
ANDROID_JAGUAR_TC  = "ANDROID_JAGUAR_TC" --Jaguar繁体
IOS_JAGUAR_TC =  "IOS_JAGUAR_TC"
ANDROID_GV_XJP_ZH = "ANDROID_GV_XJP_ZH" --MFACE 新加坡 
ANDROID_BAIDUIAPPPAY_ZH = "ANDROID_BAIDUIAPPPAY_ZH"--百度爱贝
IOS_GAMEVIEW_ZH = "IOS_GAMEVIEW_ZH"      --新马 ios mface
IOS_GAMEVIEW_EN = "IOS_GAMEVIEW_EN"      --新马 ios mface
IOS_GVEN_BREAK = "IOS_GVEN_BREAK"      --新马 ios 欧美
IOS_GAMEVIEW_TC = "IOS_GAMEVIEW_TC"      --新马 ios mface繁体
IOS_TGAME_ZH = "IOS_TGAME_ZH"
IOS_TGAME_KR = "IOS_TGAME_KR"
IOS_TGAME_TC = "IOS_TGAME_TC"       -- TGame 自营繁体
IOS_TGAME_TH = "IOS_TGAME_TH"       -- TGame 自营泰语
IOS_INFIPLAY_RUS = "IOS_INFIPLAY_RUS"
ANDROID_INFIPLAY_RUS = "ANDROID_INFIPLAY_RUS"
ANDROID_TGAME_KR = "ANDROID_TGAME_KR"
ANDROID_TGAME_KRNEW = "ANDROID_TGAME_KRNEW"
ANDROID_COOLPAY_ZH = "ANDROID_COOLPAY_ZH" -- cool pay
ANDROID_GIONEE_ZH = "ANDROID_GIONEE_ZH"     -- 金立
ANDROID_TGAME_ZH = "ANDROID_TGAME_ZH"
ANDROID_ANFENG_ZH = "ANDROID_ANFENG_ZH"    --安锋网
ANDROID_HTC_ZH = "ANDROID_HTC_ZH"           --HTC 接入 TGame 平台
IOS_AISI_ZH = "IOS_AISI_ZH"                --爱思
IOS_AISIPARK_ZH = "IOS_AISIPARK_ZH"        --新版本爱思
ANDROID_MYEPAY_ZH = "ANDROID_MYEPAY_ZH"   --指游
IOS_DOWNJOYPARK_ZH = "IOS_DOWNJOYPARK_ZH" --当乐ios
ANDROID_TGAME_THAI = "ANDROID_TGAME_THAI"   --tgame泰语
ANDROID_TGAME_TC = "ANDROID_TGAME_TC"

-- 游戏小版本
-- *****下面的这个注释不能删掉*****

-- 内更新序号，也就是上传CDN资源次数的序号，每一次完整目录的上传（不包括修改bug的临时上传）序号 + 1
local releaseIndex = 2

-- 功能版本编号，与策划处的记录一致，每次开发新功能编号 + 0.1
local featureIndex = 2.7

-- 修改bug编号，每次修补漏洞编号 + 1
local fixIndex = 0011

opVersion = releaseIndex.."."..featureIndex.."."..fixIndex
print("opversion is :",opVersion)

if opPCL == IOS_TEST_ZH then        -- ios 测试
    opPCLId = "000000000"
elseif opPCL == IOS_APPLE_ZH then      -- ios apple
    opPCLId = "iosTalentwalker"
elseif opPCL == IOS_IIAPPLE_ZH then      -- iiApple越狱平台
    opPCLId = "chinaTwIapple"
elseif opPCL == IOS_HAIMA_ZH then      -- iiApple越狱平台
    opPCLId = "haimaTWIos"
elseif opPCL == IOS_APPLE2_ZH then      -- ios apple
    opPCLId = "iosTalentwalker2"
elseif opPCL == IOS_APPLE2_ZH then      -- ios apple
    opPCLId = "iosTalentwalker2"
elseif opPCL == IOS_TW_ZH then      -- ios talentwalker
    opPCLId = "iosTalentwalker"
elseif opPCL == ANDROID_TEST_ZH then    -- android内网测试
    opPCLId = "test"
elseif opPCL == ANDROID_TW_ZH then      -- android外网
    opPCLId = "test"
elseif opPCL == IOS_KY_ZH then      -- 快用
    opPCLId = "kuaiyong"
elseif opPCL == IOS_KYPARK_ZH then      -- 快用
    opPCLId = "kyTWIos"
elseif opPCL == ANDROID_KY_ZH then
    opPCL = "kyTWAndroid"
elseif opPCL == IOS_XYZS_ZH then      -- 快用
    opPCLId = "xyzsTWIos"
elseif opPCL == ANDROID_XYZS_ZH then      -- 快用
    opPCLId = "xyzsTWAndroid"
elseif opPCL == IOS_ITOOLS then      -- ITOOLS
    opPCLId = "itools" 
elseif opPCL == IOS_ITOOLSPARK then
   opPCLId = "iToolsTWIos"
elseif opPCL == IOS_PPZS_ZH then      -- pp助手
    opPCLId = "ppzs"
elseif opPCL == IOS_PPZSPARK_ZH then      -- pp助手
    opPCLId = "ppzsTW"
elseif opPCL == IOS_TBT_ZH then      -- 同步推
    opPCLId = "tongbutui"
elseif opPCL == IOS_TBTPARK_ZH then      -- 同步推
    opPCLId = "tbtTWIos"
elseif opPCL == IOS_91_ZH then      -- 91
    opPCLId = "91"
elseif opPCL == IOS_VIETNAM_VI then      -- 越南 ios
    opPCLId = "mobgameios" 
elseif opPCL == IOS_VIETNAM_EN then      -- 越南 iosEN
    opPCLId = "mobgameiosEn" 
elseif opPCL == IOS_VIETNAM_ENSAGA then
    opPCLId = "mobgameiosEn3"        -- 越南Pirate Saga
elseif opPCL == IOS_MOBGAME_SPAIN then      -- mobgame ios spain
    opPCLId = "mobgameiosSpa" 
elseif opPCL == ANDROID_MOBGAME_SPAIN then      -- mobgame 安卓spain
    opPCLId = "mobgameandroidSpa" 
elseif opPCL == IOS_MOBNAPPLE_EN then     --  越南iOS英文非AppStore版本
    opPCLId = "mobgameiosEn2"
elseif opPCL == IOS_MOB_THAI then     --  越南iOS泰国语版本
    opPCLId = "mobgameiosThai"
elseif opPCL == ANDROID_VIETNAM_MOB_THAI then     --  越南iOS泰国语版本
    opPCLId = "mobgameandroidThai"
elseif opPCL == ANDROID_VIETNAM_VI then  -- 越南 android
    opPCLId = "mobgameandroid" 
elseif opPCL == ANDROID_VIETNAM_EN then  -- 越南 androidEN
    opPCLId = "mobgameandroidEn" 
elseif opPCL == ANDROID_VIETNAM_EN_ALL then
    opPCLId = "mobgameandroidEn"
elseif opPCL == ANDROID_XIAOMI_ZH then  -- 小米
    opPCLId = "xiaomi"
elseif opPCL == ANDROID_BAIDU_ZH then   -- 百度 rom
    opPCLId = "baidurom" --百度
elseif opPCL == ANDROID_BAIDUIAPPPAY_ZH then   -- 百度 四核
    opPCLId = "xmshAndroid"
elseif opPCL == ANDROID_OPPO_ZH then    -- OPPO
    opPCLId = "oppo"
elseif opPCL == ANDROID_DOWNJOY_ZH then -- 当乐安卓
    opPCLId = "dangleTWAndroid"
elseif opPCL == IOS_DOWNJOYPARK_ZH then -- 当乐ios
    opPCLId = "dangleTWIos"
elseif opPCL == ANDROID_UC_ZH then
    opPCLId = "uc"
elseif opPCL == ANDROID_MM_ZH then
    opPCLId = "ydmm"
elseif opPCL == ANDROID_AGAME_ZH then -- AGame 阿游戏
    opPCLId = "agame"
elseif opPCL == ANDROID_91_ZH then -- 91android
    opPCLId = "91Android"
elseif opPCL == ANDROID_WDJ_ZH then -- wdj android
    opPCLId = "wdj"
elseif opPCL == ANDROID_DK_ZH then -- dk android
    opPCLId = "baidudk"
elseif opPCL == ANDROID_360_ZH then -- 360 android
    opPCLId = "360"
elseif opPCL == ANDROID_GV_XJP_ZH then
    opPCLId = "maGooglePlay_Singa"
elseif opPCL == ANDROID_GV_MFACE_ZH then
    opPCLId = "maMface360"
elseif opPCL == ANDROID_GV_MFACE_EN then
    opPCLId = "maMface360En"
elseif opPCL == ANDROID_GV_MFACE_EN_OUMEI then
    opPCLId = "maAndroidEurope"
elseif opPCL == ANDROID_GV_MFACE_EN_OUMEINEW then
    opPCLId = "gvAndroidEn1"
elseif opPCL == ANDROID_GV_MFACE_TC or opPCL == ANDROID_GV_MFACE_TC_GP  then
    opPCLId = "maGooglePlayTW"
elseif opPCL ==  ANDROID_JAGUAR_TC then
    opPCLId = "jaguarTwAndroid"
elseif opPCL ==  IOS_JAGUAR_TC then
    opPCLId = "jaguarTwIos" 
elseif opPCL == IOS_GAMEVIEW_ZH then
    opPCLId = "maApple"
elseif opPCL == IOS_GAMEVIEW_TC then
    opPCLId = "maAppleTW"
elseif opPCL == IOS_GAMEVIEW_EN then
    opPCLId = "maAppleEn"
elseif opPCL == IOS_GVEN_BREAK then
    opPCLId = "gvIosEn1"
elseif opPCL == ANDROID_MMY_ZH then
    opPCLId = "mumayi"
elseif opPCL == IOS_TGAME_ZH then
    opPCLId = "cnTgameApple"
elseif opPCL == ANDROID_HUAWEI_ZH then
    opPCLId = "huawei"
elseif opPCL == IOS_TGAME_KR then
    opPCLId = "koTgameApple"
elseif opPCL == IOS_TGAME_TC then
    opPCLId = "talentwalkerTgameIos"
elseif opPCL == ANDROID_TGAME_TC then
    opPCLId = "talentwalkerTgameAndroid"
elseif opPCL == IOS_TGAME_TH then
    opPCLId = "talentwalkerThaiTgameIos"
elseif opPCL == ANDROID_TGAME_THAI then    --tgame泰语
    opPCLId = "talentwalkerThaiTgameAndroid"
elseif opPCL == IOS_INFIPLAY_RUS then
    opPCLId = "rusInfiplayIos"
elseif opPCL == ANDROID_INFIPLAY_RUS then
    opPCLId = "rusInfiplayAndroid"
elseif opPCL == ANDROID_TGAME_KR then
    opPCLId = "koTgameAndroid"
 elseif opPCL == ANDROID_TGAME_KRNEW then
    opPCLId = "koTgameAndroid1"
elseif opPCL == ANDROID_COOLPAY_ZH then
    opPCLId = "kupai"
elseif opPCL == ANDROID_GIONEE_ZH then
    opPCLId = "jinli"
elseif opPCL == ANDROID_TGAME_ZH then
    opPCLId = "cnTgameAndroid"
elseif opPCL == ANDROID_ANFENG_ZH then
    opPCLId = "anfeng"
elseif opPCL == ANDROID_HTC_ZH then
    opPCLId = "htcTgame"
elseif opPCL == IOS_AISI_ZH then
    opPCLId = "aisi"
elseif opPCL == IOS_AISIPARK_ZH then
    opPCLId = "i4TWIos"
elseif opPCL == ANDROID_MYEPAY_ZH then
    opPCLId = "zhiyou"
elseif opPCL == WP_VIETNAM_VN then
    opPCLId = "mobgamewindows"
elseif opPCL == WP_VIETNAM_EN then
    opPCLId = "mobgamewindowsEn"
else
    opPCLId = "000000000"
end

function isFuncExist( funName )
    -- body
    if funName then
        return 1
    end
    return 0
end
