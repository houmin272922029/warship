

vnc://192.168.100.76


==================
更换molde 纯配置文件
view/type
AwardItem
ColorMapUtil
AwardUtils
ResConfig
MonsterConfig
BattleConfig




vnc://192.168.100.76
afp://192.168.100.76

                        
-------------------
--在终端显示手机上的DEBUG信息方法
--指令 telnet 192.168.100.132 6050
--     debugmsg on

========= 新moldle========

            jp
    outstanding [精英招募]
    pay_everyday [每日充值]  
    passenger [乘员系统] 
    assembly [集结号]
    soldiers_war [将士之战]   


            kr
    legion_war [军团战]
    pay_everyday [每日充值]  
    assembly [集结号]
    head_treasure [元首宝藏] 
    rush_purchase [限时抢购]  


==============韩文IOS打包账户密码&沙盒测试账户===========
pw:             dreamplay
all file pw:    dreamplay
sanbox tester 
linfan1127@126.com (password : Tankwar2017)


192.168.100.76
192.168.100.244


=========== 坦克1 分之 =======
runtime-src    Client
front          develop2
tmp            tank1_tpm



============ 孙华雄最后的更新======

tank1 国内版本，更新了Cocos2d-x 库，先拉一下 develop2，在 切换到framework 下 命令行执行 
./cocos2d-x-bin，然后拉一下 runtime-src 的库

============wifi passworld ======
1234QWER
hulaikeji
北京市朝阳区天辰东路7号国家会议中心北区四层胡来游戏
========热更新  模块发布记录=======

tools/config.yaml    里面新增 csv 读表的配置

plugin_check.py      里面新增 新modle的配置 

plugin_config.py     里面新增  新modle热更新的地址等信息

plugin_publish.py    里面新增  注册发布的modle热更新信息

==================

PreloadView  预加载视图

xiaoao-oversea-publish   海外英文热更新


    mode: release                           # 编译模式 release debug
    is_remote: 1                            # 是否是远程 远程服务器为1 开发机为0
    prefix: tthy/                           # 文件上传到 UCloud 的前缀
    package_url: http://androidtank         #热更新下载文件路径
    manifest_url: http://tank.9173.         # 用于构建热更新时，动态替换%s，访问latest_version_url获得值后动态+1,然后覆盖打包的 remote_manifest_url
    latest_version_url: http://192.         # 线上最新的code版本，构建热更会动态+1
    remote_manifest_url: http://192         # 打包时取的正式服热更新的比对文件查询地址
    remote_publish_url: http://192.         # 热更新的 版本信息提交的路径
    config_domain: tank.9173.com            # 项目 src/config.lua 下的 SERVER_DOMAIN [服务器域名或IP]
    config_port: 80                         # 项目 src/config.lua 下的 SERVER_PORT [服务器端口]
    config_path: vms/index.php?mod=         # 项目 src/config.lua 下的 SERVER_PATH [服务器的路径]
    config_product: release                 # 项目 src/config.lua 下的 product [产品类型：release, test, develop, local, appstore]
    config_debug: false                     # 项目 src/config.lua 下的 DEBUG [是否是debug模式]
    ios_proj: frameworks/runtime-sr         # 项目tank.xcodeproj 位置
    ios_scheme: tank-mobile-master          # 用于 IOS build 的 scheme
    android_proj: frameworks/runtim         # 项目 android-studio 位置
    android_name: master                    # 用于打 android 包的名字
    deploy_id: testonline
    platform: [ios, android]                # 需要打的平台
    language: cn                            # 语言
    up_way: ucloud                          # 上传方式 目前有 ucloud 和 ftp
    bucket: androidtank                     #存储空间域名,ucloud的 filemgr-mac 必须配套相应的存储空间域名 和 API 密钥(API 密钥存储在 config.cfg 中)


src main  jnilib 

$   ￥  

qy.Http.new(qy.Http.Request.new({

进日文开发服   不需要任何验证   签名

==================网页打包说明=================

play.miniserver.io 网页地址

http://jenkins.miniserver.io/

改java代码 xiaoao-jptest-build    打包    右边按钮

改 lua代码     xiaoao-jptest-package-publish  点剪头  开始构建


改 lua 代码，改策划表，需要发热更新，流程：1、切换到 master_jp，然后将 develop_jp 的代码合并到 master_jp。
2、到http://jenkins.miniserver.io/->小奥-海外->xiaoao-jptest-package-publish 
点击Build with Parameters进行热更新。热更完成，即到xiaoao-jptest-package-publish->Console Output 
下看到自己发的记录为 SUCCESS ,然后跟策划说，将日文测试版指到最新版本，策划指向后，手里的日文版包即可以更新到最新


改 OC 代码，java 代码，需要重新打包，流程：1、到 到http://jenkins.miniserver.io/->小奥-海外->xiaoao-jptest-build
 点击立即构建，则可以进行打包
2、打包完成到 xiaoao-jptest-build->Console Output 下看到自己发的记录为 Finished: SUCCESS,即可去 
play.minserver.io 下载最新的包
    ·   小奥·日文版
    ·   タンク・オブ・ウォー - Android - debug


====================公司账户密码区域==============

Cornerstorne 密码 1154195328

GIT 密码  1154195328

topJOY 后台 账户  heqiang@9173.com    密码：a13795833119

AppsFlyer 账户
电子邮件：1154195328@qq.com
密码： xdViKhCx


公司 vpn 账户
422699742@qq.com
qiyouhudong9173


韩文谷歌账户


谷歌要记得key和签名的配置  很重要的


============韩文 ====     
测试版：korean.170508.01
正式版：kr.170518.01      

http://1.201.141.71:8001/vms/vms.php
admin  hello.tank.9173
韩文正式版
===================

小奥-海外 英文 指版本账户
admin
hello.oversea.xiaoao

=======================非凡vpn账户======
422699742@qq.com
qiyouhudong9173
服务器：jp0.0bad.com
端口：30037
加密方式：aes-128-cfb
密码：t55656

=======================苹果账户======
苹果账户
1154195328@qq.com
Aa13795833119

谷歌 keystore
密码：sync-games
别名：vsgandroidkey

谷歌广告 ID
7c9c8160-6c6d-4cb5-8a74-24dbf15663ed

韩文支付MDN码
11541953289



韩文  HanGuo-keystore
密码：1234qwer/1234QWER
别名： vsgandroidkey


浪子的推特  账户
krin@sync-games.com
sync0592

我的谷歌账户
hellohqa@gmail.com   
密码 a13795833119

Twitter  帐号
hellohq1
密码 1154195328
fabric 帐号
hellohq

Xcode 证书密码  tank0592

IOS 日文充值 密码 Tf-lab0592

タンクウォー

苹果 uuid
7e0a2269c4c6be606b25e3f11af71bce68689e69  

IDFA 
44654DBF-335D-4F95-86DF-CC6BBCE100F7 

策划值版本账户
admin
hello.jp.tank

Facebook Qiyou
1294119662@qq.com
密码 1154195328


【邮箱】
用户名：heqiang@9173.com
密码：56MJesx
修改密码：http://exmail.qq.com


【邮箱】  账户密码

用户名：heqiang@9173.com

密码：56MJesx

修改密码：http://exmail.qq.com



=========韩文测试服调试====
账户 宋博文
密码 ujjnx87


==========查看当前的keystore的信息==============
 keytool -v -list -keystore Hguo.jks


=================安卓导表 命令区域================
拷贝本地res src到安卓
proj.android-studio  命令运行   sh sync.sh

导表 
cd 到wall 目录下面 运行 python tool.py


./tools/module ccs publish -n  -l jp


导入 cocos2d.so
android 里面执行 sh build.sh  命令

Login  Login
=================IOS 新增sdk 流程================== 
拷贝ios项目
General 改包名
Build Setting 里面  info.plist file   Product Bundle identifier   Product Module  Name   Product  Name 
改 info.list 地址
改 .a 文件 
 
copy items if needed      如果需要的话复制项目    
create folder references  创建文件夹的引用
create groups               创建组



================git帮助===================
GIT  先抓取  在拉取
上传  右键    选择    记得最后选择 推送   


keytool -v -list -keystore 




==============SDK 有用的地址==============
/Users/zhaoliyuan/Documents/mytool/android-sdk-macosx
/Applications/Android Studio.app/Contents
/Users/zhaoliyuan/Documents/mytool/android-sdk-macosx
/Users/zhaoliyuan/Downloads



===========OC SDK 获得当前的view===============
    //设置登录回调
    api.logindelegate=self;
    
    //设置支付回调
    api.paydelegate=self;
    
    //设置游戏的方向 横屏landscape 竖屏portrait
    [api setDirect:@"landscape"];
    
    // 获得当前主要的view试图
    UIViewController * mainview = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    //初始化api
    [api initWithConf:ClientiID withrootView:mainview Alipay:urlScheme];



cocosdtudio ../../res



angle_icon_1


OC 截取s 变成空格
NSString * _extra = [extra stringByReplacingOccurrencesOfString:@"s" withString:@""];

function RechargeService:paymentBegin(data, onSuccess)


联调 192.168.100.122  端口 8888

Facebook		好友邀请/分享	App ID: 348436532213416

Marketing	AppsFlyer		广告效果监控SDK（监控事件列表稍后提供）
Deeplink（使用AppsFlyer的onelink）"	"Dev 	Key：QzrMERaF86ZBoffVyM6B8B

https://hq1.appsflyer.com/auth/login
包名: com.vsg.tank01

ca sdk 官网地址 https://www.ca-reward.co.jp/service/

git stash pop



android：
apiKey: 20257ecffb10a4e1    
mId(MediaId): 7382     
m_ownerID: 1189     
loadURLString: http://growth.mobadme.jp/ameba/game/top/1189/7382

CA平台IP：
202.234.38.240
59.106.126.70
59.106.126.73
59.106.126.74  
님:

http://plugins.jetbrains.com/files/8002/22275/FabricAndroidStudioPlugin.zip

消费者密钥（API密钥）	GmWwRs90DoVTgqnBHdIhwnhsa
消费者秘密（API秘密）	XK9WDu5p01s1N7bDRbiI97h9SHqtmRfPMAMcvsGNfXkXiXdYjF
					9ff5e11b29f0da8eddb3ddca861f0133458f2b18
	
自己的谷歌哈希  0F:0A:7C:F0:D0:BC:3E:81:48:BC:31:3B:9C:2B:75:3E:46:FE:24:ED
自己的安卓哈希  39:F3:E0:65:5E:F7:F0:25:F1:85:3B:39:4A:8B:97:0C:14:B8:ED:50

Consumer Key (API Key)： Gfhve148jncRcmlOSkdgvozGd
Consumer Secret (API Secret)： R2imLxztXOLEBVbl7TUX0cEOm8FS0xui6tzJChhc+A2:F12


===========android-studio 下载的lib地址============
/Users/zhaoliyuan/.gradle/caches/modules-2/files-2.1


src/view/
├── achievement [图鉴成就]
├── activity [作战室列表]
├── advance [进阶]
├── arena [军神榜]
├── battle [战斗模块]
├── campaign [战役]
├── classicbattle [经典战役]
├── common [公共]
├── equip [装备]
├── examine [查看资料]
├── exchange [兑换]
├── extractionCard [抽卡/军资基地]
├── fightJapan [抗日远征]
├── garage [车库]
├── guide[引导模块]
├── inspection [每日检阅]
├── invade [伞兵入侵]
├── legion [军团]  ==================
├── login [登录]
├── mail [邮件]
├── main [主界面]
├── mine [矿区]
├── module [模块化加载]
├── monthCard [月卡]
├── onlyres
├── operatingActivities [运营活动] =================
├── pot [大锅饭]
├── preload [预加载]
├── recharge [充值]
├── resolve [分解]
├── scene
├── setting [设置]
├── shop [商店]
├── storage [仓库]
├── supply [补给]
├── task [任务]
├── technology [科技]
├── tip
├── training [训练场]
├── user [用户]
├── vip
└── war_group [群战] 

src/module [模块加载 && 聊天]


LoginCell   注册新账户   登录新游戏

RegisterDialog  快速注册 返回  完成

ReminderDialog 快速游戏  返回 go


/Users/zhaoliyuan/Library/Preferences/org.cocos2dx.tank.plist




print("==========="..qy.json.encode(data))

modules

├── advance [进阶]
├── alloy [合金]
├── assembly [集结号]
├── bonus [充值红利]   1
├── carray [军团押运]
├── earth_soul [大地英魂]  1
├── gold_bunker [黄金地堡]
├── head_treasure [元首宝藏]
├── help [战争百科]
├── iron_mine [精铁矿脉]
├── legion [军团]
├── legion_boss [军团boss]
├── legion_war [军团战]
├── login_total [登录作战]  
├── lucky_cat [招财猫]
├── market [黑市商店]
├── newyear_supply [春节特供]
├── onlyres
├── pub [军旅酒馆]
├── recharge_doyen [充值达人]
├── rush_purchase [限时抢购]
├── singlehero [孤胆英雄]
├── soul [军魂]
├── soul_road [军魂之路]
├── spring_gift [猴年吉祥]
├── torch [火炬行动]
├── war_group [群战]
├── allrecharge [全民充值]
├── searchTreasure [探宝日记]
├── single_recharge [单笔充值(白虎来袭)]
├── servicewar [跨服战争]
├── quiz [知识竞赛]
├── grouppurchase [超值购物]
├── pay_rebate_vip [累充返礼]
├── pay_everyday [克虏伯]
├── passenger [乘员系统]
├── share [分享有礼]
├── soldiers_war [将士之战]
├── offer_a_reward [军功悬赏]
├── war_aid [战地援助]
├── offer_a_reward [战地援助]
├── match_fight_power [战力竞赛]
├── war_picture [战争图卷]
├── fame [威震欧亚]
├── beat_enemy [暴打敌营]
├── legion_skill [军团技能]
├── group_battles [多人副本]
├── discount_sale [折扣贩售]
├── sign [签到系统]
├── strong [我要变强]
├── outstanding [精英招募]
├── greatest_race [最强之战]
├── Military_rank [军衔系统]
├── olympic [军奥会]
└── worldboss [世界boss]

    outstanding [精英招募]
    pay_everyday [每日充值] 
    passenger [乘员系统]
    assembly [集结号]
    soldiers_war [将士之战]

--其他
utils、command

进入游戏之前的图片加载   loading_img.jpg



SelectBranchView     点击语言按钮后选服


In progress控制台输出



-- 法规显示在登录的前面
qy.tank.view.login.Law.new():show(true)


login_total singlehero




function class(classname, ...)
    local cls = {__cname = classname}

    local supers = {...}
    for _, super in ipairs(supers) do
        local superType = type(super)
        assert(superType == "nil" or superType == "table" or superType == "function",
            string.format("class() - create class \"%s\" with invalid super class type \"%s\"",
                classname, superType))

        if superType == "function" then
            assert(cls.__create == nil,
                string.format("class() - create class \"%s\" with more than one creating function",
                    classname));
            -- if super is function, set it to __create
            cls.__create = super
        elseif superType == "table" then
            if super[".isclass"] then
                -- super is native class
                assert(cls.__create == nil,
                    string.format("class() - create class \"%s\" with more than one creating function or native class",
                        classname));
                cls.__create = function() return super:create() end
            else
                -- super is pure lua class
                cls.__supers = cls.__supers or {}
                cls.__supers[#cls.__supers + 1] = super
                if not cls.super then
                    -- set first super pure lua class as class.super
                    cls.super = super
                end
            end
        else
            error(string.format("class() - create class \"%s\" with invalid super type",
                        classname), 0)
        end
    end

    cls.__index = cls
    if not cls.__supers or #cls.__supers == 1 then
        setmetatable(cls, {__index = cls.super})
    else
        setmetatable(cls, {__index = function(_, key)
            local supers = cls.__supers
            for i = 1, #supers do
                local super = supers[i]
                if super[key] then return super[key] end
            end
        end})
    end

    if not cls.ctor then
        -- add default constructor
        cls.ctor = function() end
    end
    cls.new = function(...)
        local instance
        if cls.__create then
            instance = cls.__create(...)
        else
            instance = {}
        end
        setmetatableindex(instance, cls)
        instance.class = cls
        instance:ctor(...)
        return instance
    end
    cls.create = function(_, ...)
        return cls.new(...)
    end

    return cls
end





kingoftanks:      # kingoftanks正式包
    parent: clashandcommand
    mode: release
    config_debug: false
    prefix: sea/
    up_package_url: 127.0.0.1
    up_port: 2048 
    up_username: LTAIidf9oycGie8s/qiyotank
    up_password: OzJGEdZVZGut1MwQT6gFOLpnqGdu9Q
    package_url: http://qiyotank.oss-ap-southeast-1.aliyuncs.com/sea
    remote_manifest_url: http://192.168.100.76:8082/api/v2/latest/kingoftanks
    manifest_url: http://47.88.218.178/vms/vms.php?r=api/checkversion&ver=%s
    config_domain: 47.88.218.178
    #config_port: 8002
    config_product: sea
    deploy_id: sea
    android_name: kingoftanks
    ios_scheme: yogrtgames
    platform: android

kingoftanks-test:      # kingoftanks测试包
    parent: clashandcommand
    mode: debug
    config_debug: true
    prefix: seatest/
    up_package_url: 127.0.0.1
    package_url: http://qiyotank.oss-ap-southeast-1.aliyuncs.com/seatest
    up_port: 2048 
    up_username: LTAIidf9oycGie8s/qiyotank
    up_password: OzJGEdZVZGut1MwQT6gFOLpnqGdu9Q
    remote_manifest_url: http://192.168.100.76:8082/api/v2/latest/kingoftanks-test
    manifest_url: http://47.88.218.178:8002/vms/vms.php?r=api/checkversion&ver=%s
    config_domain: 47.88.218.178
    config_port: 8002
    config_product: sea-test
    deploy_id: seatest
    android_name: kingoftanks
    ios_scheme: yogrtgames
    platform: android
clashandcommand-test:      # clashandcommand测试包
    parent: clashandcommand
    mode: debug
    config_debug: true
    remote_manifest_url: http://192.168.100.76:8082/api/v2/latest/clashandcommand-test
    manifest_url: http://45.113.70.110/vms/vms.php?r=api/checkversion&ver=%s
    config_domain: 45.113.70.110
    config_product: oversea-test
    deploy_id: overseatest
clashandcommandhw:  # hw 正式
    parent: clashandcommand
    android_name: xiaoao_clashandcommandhw
    platform: android
    config_debug: false
    mode: release
clashandcommandhw-test:  # hw 测试
    parent: clashandcommand
    android_name: xiaoao_clashandcommandhw
    platform: android
    config_debug: true
    mode: debug
    remote_manifest_url: http://192.168.100.76:8082/api/v2/latest/clashandcommand-test
    manifest_url: http://45.113.70.110/vms/vms.php?r=api/checkversion&ver=%s
    config_domain: 45.113.70.110
    config_product: oversea-test
    deploy_id: overseatest