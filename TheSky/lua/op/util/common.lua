--[[
    基础工具类。目前包括一些 字符串、table 的扩展处理
    修改了部分方法名，如 split 修改为 string.split 加了前缀 以便增加可读性！
--]]
--_mainLayerAllActions = 1

mainBgScale = 2

Screen_Unknown = (-1)
Screen_iphone3_7Inch = 0
Screen_iphone4Inch = 1
Screen_iPad = 2
Screen_NewIPad = 3

FirstOpenMainLayer = true

_loadingLayer = nil

-- // 字体文件
Purple_Blue_File = "fight_Purple_Blue.fnt"
Blue_White_File = "fight_Blue_White.fnt"
Blue_File = "fight_Blue.fnt"
Red_File = "fight_Red.fnt"
Green_File = "fight_Green.fnt"
Orange_Red_File = "fight_Orange_Red.fnt"

Purple_Blue = "wordColor_Purple_Blue"
Blue_White = "wordColor_Blue_White"
Blue = "wordColor_Blue"
Red = "wordColor_Red"
Green = "wordColor_Green"
Orange_Red = "wordColor_Orange_Red"

-- 特殊组件

-- 场景定义
SceneType = {
    loginScene = 1,         -- 登陆页
    
}

PayCallBack = {
    IAPSucc = "iapPaySucc",
    IAPFail = "iapPayFail",
    GPPaySucc = "gpPaySucc",
    GPPayFail = "gpPayFail",
}

-- 输出
cclog = function(...)
    print(string.format(...))
end

PLATFORM_TYPE = {
    debug = "debug", -- 测试
    tw = "tw",    -- 安卓混服2
    ["9158"] = "9158",
    mobgame = "mobgame", 
    gameview = "gameview", 
}

function isPlatform(platform)
    return opPCL == platform
end


function langType()
    if isPlatform(IOS_TEST_ZH)
        or isPlatform(ANDROID_TEST_ZH)
        or isPlatform(ANDROID_BAIDU_ZH)
        or isPlatform(ANDROID_MM_ZH)
        or isPlatform(ANDROID_BAIDUIAPPPAY_ZH)
        or isPlatform(ANDROID_MMY_ZH)
        or isPlatform(IOS_TGAME_ZH)
        or isPlatform(IOS_TW_ZH)
        or isPlatform(ANDROID_TW_ZH)
        or isPlatform(IOS_APPLE_ZH)
        or isPlatform(IOS_91_ZH)
        or isPlatform(IOS_KY_ZH)
        or isPlatform(IOS_KYPARK_ZH)
        or isPlatform(ANDROID_KY_ZH)
        or isPlatform(IOS_PPZS_ZH)
        or isPlatform(IOS_PPZSPARK_ZH)
        or isPlatform(IOS_ITOOLS)
        or isPlatform(IOS_ITOOLSPARK)
        or isPlatform(ANDROID_AGAME_ZH)
        or isPlatform(ANDROID_91_ZH)
        or isPlatform(ANDROID_DK_ZH)
        or isPlatform(ANDROID_WDJ_ZH)
        or isPlatform(ANDROID_XIAOMI_ZH)
        or isPlatform(ANDROID_UC_ZH)
        or isPlatform(IOS_TBT_ZH)
        or isPlatform(IOS_TBTPARK_ZH) 
        or isPlatform(ANDROID_360_ZH)
        or isPlatform(ANDROID_GV_MFACE_ZH)
        or isPlatform(ANDROID_GV_XJP_ZH)
        or isPlatform(IOS_GAMEVIEW_ZH)
        or isPlatform(ANDROID_GV_MFACE_TC)
        or isPlatform(ANDROID_OPPO_ZH) 
        or isPlatform(ANDROID_DOWNJOY_ZH)
        or isPlatform(IOS_DOWNJOYPARK_ZH)
        or isPlatform(ANDROID_HUAWEI_ZH)
        or isPlatform(IOS_GAMEVIEW_TC)
        or isPlatform(ANDROID_COOLPAY_ZH) 
        or isPlatform(ANDROID_GIONEE_ZH)
        or isPlatform(IOS_AISI_ZH)
        or isPlatform(ANDROID_TGAME_ZH)
        or isPlatform(ANDROID_MYEPAY_ZH)
        or isPlatform(ANDROID_ANFENG_ZH)
        or isPlatform(ANDROID_GV_MFACE_TC_GP)
        or isPlatform(ANDROID_JAGUAR_TC) 
        or isPlatform(IOS_XYZS_ZH) 
        or isPlatform(ANDROID_XYZS_ZH) 
        or isPlatform(IOS_TGAME_TH)
        or isPlatform(IOS_TGAME_TC) 
        or isPlatform(ANDROID_TGAME_TC) then
        
         return LANG_TYPE.zh

    elseif isPlatform(IOS_VIETNAM_VI)
        or isPlatform(ANDROID_VIETNAM_VI)
        or isPlatform(WP_VIETNAM_VN) then

        return LANG_TYPE.vn

    elseif isPlatform(IOS_VIETNAM_EN) 
        or isPlatform(IOS_VIETNAM_ENSAGA)
        or isPlatform(IOS_MOBNAPPLE_EN)
        or isPlatform(ANDROID_GV_MFACE_EN)
        or isPlatform(ANDROID_GV_MFACE_EN_OUMEI)
        or isPlatform(ANDROID_GV_MFACE_EN_OUMEINEW)
        or isPlatform(IOS_GAMEVIEW_EN)
        or isPlatform(IOS_GVEN_BREAK)
        or isPlatform(ANDROID_VIETNAM_EN)
        or isPlatform(ANDROID_VIETNAM_EN_ALL)
        or isPlatform(WP_VIETNAM_EN) then

        return LANG_TYPE.en

    elseif isPlatform(IOS_MOB_THAI)
    or isPlatform(ANDROID_VIETNAM_MOB_THAI) or isPlatform(ANDROID_TGAME_THAI) then
        return LANG_TYPE.th

    elseif isPlatform(IOS_INFIPLAY_RUS)
    or isPlatform(ANDROID_INFIPLAY_RUS) then
        return LANG_TYPE.rus
        
    elseif isPlatform(ANDROID_TGAME_KR)  or isPlatform(ANDROID_TGAME_KRNEW) 
     or isPlatform(IOS_TGAME_KR) then

        return LANG_TYPE.kr

    elseif isPlatform(IOS_MOBGAME_SPAIN) or isPlatform(ANDROID_MOBGAME_SPAIN) then
        return LANG_TYPE.spain
    end
end

function platformType()
    if isPlatform(IOS_TEST_ZH)
        or isPlatform(ANDROID_TEST_ZH) then

        return PLATFORM_TYPE.debug

    elseif isPlatform(ANDROID_BAIDU_ZH)
        or isPlatform(ANDROID_MM_ZH)
        or isPlatform(ANDROID_BAIDUIAPPPAY_ZH)
        or isPlatform(ANDROID_MMY_ZH)
        or isPlatform(IOS_TGAME_ZH)
        or isPlatform(IOS_TW_ZH)
        or isPlatform(ANDROID_GIONEE_ZH)
        or isPlatform(ANDROID_ANFENG_ZH)
        or isPlatform(ANDROID_TGAME_ZH)
        or isPlatform(ANDROID_MYEPAY_ZH)
        or isPlatform(ANDROID_TW_ZH) then

        return PLATFORM_TYPE.tw

    elseif isPlatform(IOS_APPLE_ZH)
        or isPlatform(IOS_APPLE2_ZH)
        or isPlatform(IOS_INFIPLAY_RUS)
        or isPlatform(ANDROID_INFIPLAY_RUS)
        or isPlatform(IOS_91_ZH)
        or isPlatform(IOS_KY_ZH)
        or isPlatform(IOS_KYPARK_ZH)
        or isPlatform(IOS_PPZS_ZH)
        or isPlatform(IOS_PPZSPARK_ZH)
        or isPlatform(IOS_ITOOLS)
        or isPlatform(IOS_ITOOLSPARK)
        or isPlatform(ANDROID_AGAME_ZH)
        or isPlatform(ANDROID_91_ZH)
        or isPlatform(ANDROID_DK_ZH)
        or isPlatform(ANDROID_WDJ_ZH)
        or isPlatform(ANDROID_XIAOMI_ZH)
        or isPlatform(ANDROID_UC_ZH)
        or isPlatform(IOS_TBT_ZH)
        or isPlatform(IOS_TBTPARK_ZH) 
        or isPlatform(ANDROID_COOLPAY_ZH)
        or isPlatform(ANDROID_360_ZH)
        or isPlatform(IOS_XYZS_ZH) 
        or isPlatform(ANDROID_DOWNJOY_ZH)
        or isPlatform(IOS_DOWNJOYPARK_ZH) then

        return PLATFORM_TYPE["9158"]

    elseif isPlatform(IOS_VIETNAM_VI)
        or isPlatform(IOS_VIETNAM_EN) 
        or isPlatform(IOS_VIETNAM_ENSAGA)
        or isPlatform(IOS_MOBNAPPLE_EN)
        or isPlatform(IOS_MOB_THAI)
        or isPlatform(ANDROID_VIETNAM_VI)
        or isPlatform(ANDROID_VIETNAM_EN)
        or isPlatform(ANDROID_VIETNAM_MOB_THAI)
        or isPlatform(ANDROID_VIETNAM_EN_ALL)
        or isPlatform(IOS_MOBGAME_SPAIN)
        or isPlatform(ANDROID_MOBGAME_SPAIN)
        or isPlatform(WP_VIETNAM_VN)
        or isPlatform(WP_VIETNAM_EN) then

        return PLATFORM_TYPE.mobgame

    elseif isPlatform(ANDROID_GV_MFACE_ZH)
        or isPlatform(ANDROID_GV_MFACE_EN)
        or isPlatform(ANDROID_GV_MFACE_EN_OUMEI)
        or isPlatform(ANDROID_GV_MFACE_EN_OUMEINEW)
        or isPlatform(ANDROID_GV_MFACE_TC)
        or isPlatform(ANDROID_GV_XJP_ZH)
        or isPlatform(IOS_GAMEVIEW_ZH)
        or isPlatform(IOS_GAMEVIEW_TC)
        or isPlatform(IOS_GAMEVIEW_EN)
        or isPlatform(IOS_GVEN_BREAK)
        or isPlatform(ANDROID_GV_MFACE_TC_GP) then

        return PLATFORM_TYPE.gameview

    end

end

-- 根据不同渠道得到talkingdata的key
local function getTalkingdataKeyForPlatform()
    if platformType() == PLATFORM_TYPE["9158"] then
        return "BBEAAC1F0E3A929FD62569EAE8DB38D6"
    elseif platformType() == PLATFORM_TYPE["mobgame"] then
        return "E8D932548C7260A7362E1C7FD5C17E41"
    elseif isPlatform(ANDROID_GV_MFACE_EN_OUMEI) or isPlatform(ANDROID_GV_MFACE_EN_OUMEINEW) then
        return "A9F14DB3710BB7C137B61361CA539CCA"
    else
        return "46E4D79203659DABF36309957ED78676"
    end
end

-- 读取json文件 返回字符串
function readJsonFileStr(fileName)
    local data = CCString:createWithContentsOfFile("json/"..fileName..".json")
    if not data then
        print(" Json File Maybe Error !!! ")
        return
    end
    return json.decode(data:getCString())
end

-- 根据rank获取字体颜色
function HLGetColorWithRank( rank )
    if rank == 0 then
        return ccc3(142, 95, 33)
    elseif rank == 1 then
        return ccc3(255, 255, 255)
    elseif rank == 2 then
        return ccc3(63, 178, 31)
    elseif rank == 3 then
        return ccc3(22, 138, 209)
    elseif rank == 4 then
        return ccc3(125, 24, 173)
    elseif rank == 5 then
        return ccc3(228, 195, 33)
    end
    return ccc3(255, 255, 255)
end


function replaceAttr( attr )
    if not attr then
        return nil
    end
    if string.find(attr,"patk") then
        return (string.gsub(attr,"patk",HLNSLocalizedString("basic.patk")))
    elseif string.find(attr,"matk") then
        return (string.gsub(attr,"matk",HLNSLocalizedString("basic.matk")))
    elseif string.find(attr,"pdef") then
        return (string.gsub(attr,"pdef",HLNSLocalizedString("basic.pdef")))
    elseif string.find(attr,"mdef") then
        return (string.gsub(attr,"mdef",HLNSLocalizedString("basic.mdef")))
    elseif string.find(attr,"hp") then
        return (string.gsub(attr,"hp",HLNSLocalizedString("basic.hp")))
    elseif string.find(attr,"cri") then
        return (string.gsub(attr,"cri",HLNSLocalizedString("basic.cri")))
    elseif string.find(attr,"hit") then
        return (string.gsub(attr,"hit",HLNSLocalizedString("basic.hit")))
    elseif string.find(attr,"dodge") then
        return (string.gsub(attr,"dodge",HLNSLocalizedString("basic.dodge")))
    end
    return attr
end

function convertAttr( attr )
    if attr == "patk" or attr == "atk" then
        return HLNSLocalizedString("basic.patk")
    elseif attr == "matk" then
        return HLNSLocalizedString("basic.matk")
    elseif attr == "pdef" or attr == "def" then
        return HLNSLocalizedString("basic.pdef")
    elseif attr == "mdef" then
        return HLNSLocalizedString("basic.mdef")
    elseif attr == "hp" then
        return HLNSLocalizedString("basic.hp")
    elseif attr == "crit" or attr == "cri" then
        return HLNSLocalizedString("basic.cri")
    elseif attr == "hit" then
        return HLNSLocalizedString("basic.hit")
    elseif attr == "dodge" or attr == "dod" then
        return HLNSLocalizedString("basic.dodge")
    elseif attr == "agi" then
        return HLNSLocalizedString("basic.agi")
    end
    return attr
end


function convertType( iType )
    if iType == "pweapon" then
        return HLNSLocalizedString("basic.pweapon")
    elseif iType == "mweapon" then
        return HLNSLocalizedString("basic.mweapon")
    elseif iType == "belt" then
        return HLNSLocalizedString("basic.belt")
    elseif iType == "cloak" then
        return HLNSLocalizedString("basic.cloak")
    elseif iType == "armor" then
        return HLNSLocalizedString("basic.armor")
    elseif iType == "item" then
        return HLNSLocalizedString("basic.item")
    elseif iType == "book" then
        return HLNSLocalizedString("basic.book")
    elseif iType == "seed" then
        return HLNSLocalizedString("basic.seed")
    elseif iType == "gem" then
        return HLNSLocalizedString("basic.gem")
    end
    return nil
end

function convertBuildingName(name)
    -- body
    if name == "training" then
        return HLNSLocalizedString("buildingName.training")
    elseif name == "blacksmith" then
        return HLNSLocalizedString("buildingName.blacksmith")
    elseif name == "tavern" then
        return HLNSLocalizedString("buildingName.tavern")
    elseif name == "roster" then
        return HLNSLocalizedString("buildingName.roster")
    else
        return HLNSLocalizedString("buildingName.null")
    end
end

-- 处理多语言返回字符串
function HLNSLocalizedString( key, ... )
    if Localizable then
        if nil == Localizable[key] then 
            return key
        end 
        
        if ... then
            return string.format(Localizable[key], ...)
        else
            return Localizable[key]
        end
    else 
        return key
    end
end

-- 文字大小处理
function HLFontSize( fontSize )
    -- body
    -- if fontSize then
    --     if screenType >= Screen_iPad then
    --         return fontSize * retina * 2 - 2
    --     else
    --         return fontSize * retina
    --     end
    -- else
    --     return 8 * retina
    -- end
    return fontSize*retina
end

-- table 排序 
function HLSortDicInArray( tableTmp, key, asc)
    -- body
    local tranTable = {}
    for _key, _tmpAgs in pairs(tableTmp) do
        table.insert(tranTable, {k = _key, v = _tmpAgs})
    end

    -- print ("------------", key, asc)
    local function sortFun( a, b )
        -- print("------------"..a.v[key], b.v[key])
        -- body
        if a and a.v[key] then
            if asc == true then
                return a.v[key] < b.v[key]
            elseif asc == false then
                return a.v[key] > b.v[key]
            end
        end
    end
    table.sort(tranTable, sortFun)
    return tranTable
end

-- 获取英雄头像的图片名字
function HLGetHeroHeadIconPicNameById(heroId)
    local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
    cache:addSpriteFramesWithFile("ccbResources/hero_head2.plist")
    if not heroId then
        return nil
    end
    return heroId.."_head.png"
end


-- 获取用户头像的图片资源名字
function HLGetUserHeadIconPicName( userPic )
    local ret = "user_head_1.png"
    if not userPic or string.find(userPic, "user_head_") == nil then
        return ret
    end
    
    return userPic..".png"
end

-- /*
--  获取道具的图片名字
--  */
function HLGetItemIconPicNameById(itemIcon)

    if not itemIcon then
        return nil
    end
    
    if string.find(itemIcon,".png") then
        return itemIcon
    end
    
    return itemIcon..".png"
end

 -- 获取英雄半身像的图片名字
function HLGetHeroBustIconPicNameById(heroId)
    -- print(" Print By lixq")
    local ret =  "hero_000101_bust.png"

    if not heroId then
    -- if true then
        return ret
    end
    return heroId.."_bust.png"
end

-- 根据屏幕区分位置
function CGHeroLegendPointMake( x, y )
    -- body
    local p = ccp(x, y)
    
    -- 检查是否是ipad
    -- 1 设备是ipad,1024*768
    -- 2 设备是new pad, 2048*1536
    if screenType >= Screen_iPad then
        p.x = x * 2.132
        p.y = y * 2.4
    end
    
    return p
end

-- 对不同设备生成不同的size的方法
function CGHeroLegendSizeMake( width, height )
    local size = CCSizeMake(width, height)
    
    -- 检查是否是ipad

    -- 1 设备是ipad,1024*768
    -- 2 设备是new pad, 2048*1536
    if screenType >= Screen_iPad then
        size.width = width * 2
        size.height = height * 2
    end
    
    return size
end

-- 对不同设备生成不同的高度值,(y值)
function CGHeroLegendPointPosition_y( position_y )
    local thePosition_y = position_y
    
    -- 检查是否是ipad
    -- 1 设备是ipad,1024*768
    -- 2 设备是new pad, 2048*1536
    if screenType >= Screen_iPad then
        thePosition_y = position_y * 2.4
    end
    
    return thePosition_y
end

-- 读取配置文件
function loadAllConfigureFile()
    -- body
    GameHelper:decrypt(CONF_PATH..CONF_FILE_NAME)
    -- local file = io.open(CONF_PATH..CONF_FILE_NAME)
    -- local data = file:read("*a")
    -- file:flush()
    -- file:close()
    -- local data = GameHelper:decrypt(CONF_PATH..CONF_FILE_NAME)
    -- ConfigureStorage:fromDictionary(json.decode(data)["setting"])
    -- PrintTable(ConfigureStorage["shopConfig"]["recommendShopV2"])
end


-- 获取 table 全部元素个数
function table.getTableCount( tableTmp )
    -- body
    local i = 0
    if tableTmp and type(tableTmp) == "table" then
        for k,v in pairs(tableTmp) do
            if v then
                i = i +1
            end
        end
    end
    return i
end

function getMyTableCount( tableTmp )
    -- body
    local i = 0
    if tableTmp and type(tableTmp) == "table" then
        for k,v in pairs(tableTmp) do
            if v then
                i = i +1
            end
        end
    end
    return i
end

--对字符串进行替换，s是形如"name is ok"的字符串，t为一个table
string.expand = function(s, t)
    return (string.gsub(s, "(%w+)", t))
end

string.split = function( szFullString, szSeparator )
    local nSplitArray = {}
    string.gsub(szFullString, '[^'..szSeparator..']+',
        function(rtnStr)
            table.insert(nSplitArray, rtnStr)
        end
    )
    return nSplitArray
end

string.allCharsOfString = function(aString)
    if not aString or string.len(aString) <= 0 then
        return nil
    end

    local str_len = string.len(aString)

    local retChars = {}
    local index = 1
    local hzTable = {}
    local subStr = aString

    while index <= str_len do
        if string.byte(subStr) < 176 then
            table.insert(retChars,string.sub(aString,index,index))
            index = index + 1
        else
            index = index + 3
            local hz = string.sub(aString,index - 3,index - 1)
            table.insert(retChars,hz)
        end
        subStr = string.sub(aString,index)
    end

    return retChars
end

-- 测试方法
function PrintTable(o)
    -- p = function( str ) print(str) end
    -- if type(o) == "number" or 
    --     type(o) == "function" or
    --     type(o) == "boolean" or
    --     type(o) == "nil" then
    --     p(tostring(o))
    -- elseif type(o) == "string" then
    --     p(string.format("%q",o))
    -- elseif type(o) == "table" then
    --     p("{")
    --     for k,v in pairs(o) do
    --         p("[")
    --         PrintTable(k, p, b)
    --         p("]")
    --         p(" = ")
    --         PrintTable(v, p, b)
    --         p(",")
    --     end
    --     p("}")

    -- end
    -- 20151109 by 赵艳秋，如果是安卓版本禁止打印表格，安卓调试的时候注释掉下面三行
    if havePrefix(opPCL, "ANDROID_") then
        return
    end
    
    print(json.encode(o))
end

--去重
table.removeRepeat = function( table )
    -- body
    local values = {}
    local Repeats = false
    for k,v in pairs(table) do
        --检查是否和已写入的相重复
        for i = 1,#values do
            if v == values[i] then
                Repeats = true
                break
            end
        end

        if not Repeats then
            values[#values + 1] = v
        end
        Repeats = false
    end
    -- print("去重了的table")
    -- PrintTable(values)
    return values
    
end

table.allKey = function( table )
    -- body
    local keys = {}
    for k,v in pairs(table) do
        keys[#keys + 1] = k
    end
    return keys
end

table.allValue = function( table )
    local values = {}
    for k,v in pairs(table) do
        values[#values + 1] = v
    end
    return values
end

table.ContainsObject = function( theTable,object )
    -- body
    if not theTable or table.getTableCount(theTable) <= 0 or type(theTable) ~= "table" then
        return false
    end
    for i,v in pairs(theTable) do
        if v == object then
            return true
        end
    end
    return false
end

-- 输入一个key可转换为数字的字典，对key排序 {k1 = v1, k2 = v2}
-- 返回一个数组，{1 = {key = k1, value = v1}, 2 = {key = k2, value = v2}}
table.sortKey = function(theTable, bAcs)
    local kArr = table.allKey(theTable)
    local function sortFun( a, b )
        if bAcs then
            return tonumber(a) < tonumber(b)
        else
            return tonumber(a) > tonumber(b)
        end
    end
    table.sort( kArr, sortFun )
    local ret = {}
    for i,v in ipairs(kArr) do
        local dic = {key = v, value = theTable[v]}
        table.insert(ret, dic)
    end
    return ret
end

--判断一个字符串是否包含某个前缀
function havePrefix( sourceStr,str )
    local flag = false
    local min,max = string.find(sourceStr,str)
    if min and min == 1 then
        flag = true
    end
    return flag
end


function deepcopy(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end  -- if
        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end  -- for
        return setmetatable(new_table, getmetatable(object))
    end  -- function _copy
    return _copy(object)
end  -- function deepcopy

function firstKeyInDic( dic )
    -- body
    if not dic then
        return nil
    end
    for k,v in pairs(dic) do
        return k
    end
end

function HLGetWidthWithStr(string, fontName, fontSize)
    local label = CCLabelTTF:create(string, fontName, fontSize)
    return label:getContentSize().width
end

-- 获得文件名
-- e.g. images/mainScene/mainScene.plist
-- rtn  mainScene.plist
function getFileNameByPath( fullName )
    local tmpSplite = split(fullName, "/")
    return tmpSplite[table.getn(tmpSplite)]
end

-- 获得文件路径
-- e.g. images/mainScene/mainScene.plist
-- rtn  images/mainScene/
function getPathByFileName( fullName )
    -- body
    local tmpSplite = split(fullName, "/")
    local rtnStr = ""
    for i,v in ipairs(tmpSplite) do
        print(i,v)
        if i == table.getn(tmpSplite) then
            break
        end
        rtnStr = rtnStr..v.."/"
    end
    return rtnStr
end

-- 得到一段文本的大小
function HLGetSizeWithStr( string, fontName, fontSize )
    if not string or not fontName then
        return CCSizeMake(0, 0)
    end

    local label = CCLabelTTF:create(string, fontName, fontSize, CCSizeMake(0,0), kCCTextAlignmentCenter)
    if label:getContentSize().width > winSize.width * 0.96 then
        label = CCLabelTTF:create(string, fontName, fontSize, CCSizeMake(winSize.width * 0.96,0), kCCTextAlignmentCenter)
    end

    return label:getContentSize()
end


-- 根据传入的代表颜色的字符串返回颜色值:ccc3()
function getColorByString(colorString)  --颜色名字

    local retColor = {}
    retColor.mainColor = ccc3(0,0,0)
    retColor.outLineColor = ccc3(255,255,255)
    -- 默认返回黑色白边
    if not colorString then
        return retColor
    end

    if colorString == Red then
        retColor.mainColor = ccc3(220,59,22)
        retColor.outLineColor = ccc3(100,0,0)
    elseif colorString == Blue then
        retColor.mainColor = ccc3(51,208,226)
        retColor.outLineColor = ccc3(0,66,94)
    elseif colorString == Green then
        retColor.mainColor = ccc3(88,182,31)
        retColor.outLineColor = ccc3(34,85,24)
    elseif colorString == Purple_Blue then
        retColor.mainColor = ccc3(111,137,229)
        retColor.outLineColor = ccc3(28,0,0)
    elseif colorString == Blue_White then
        retColor.mainColor = ccc3(84,224,243)
        retColor.outLineColor = ccc3(36,62,84)
    elseif colorString == Orange_Red then
        retColor.mainColor = ccc3(226,77,26)
        retColor.outLineColor = ccc3(248,187,43)
    end

    return retColor
end

function trim (s) return (string.gsub(s, "^%s*(.-)%s*$", "%1")) end


-- 根据传入的代表颜色的字符串返回颜色值:ccc3()
function getColorByString(colorString)  --颜色名字

    local retColor = {}
    retColor.mainColor = ccc3(0,0,0)
    retColor.outLineColor = ccc3(255,255,255)
    -- 默认返回黑色白边
    if not colorString then
        return retColor
    end

    if colorString == Red then
        retColor.mainColor = ccc3(220,59,22)
        retColor.outLineColor = ccc3(100,0,0)
    elseif colorString == Blue then
        retColor.mainColor = ccc3(51,208,226)
        retColor.outLineColor = ccc3(0,66,94)
    elseif colorString == Green then
        retColor.mainColor = ccc3(88,182,31)
        retColor.outLineColor = ccc3(34,85,24)
    elseif colorString == Purple_Blue then
        retColor.mainColor = ccc3(111,137,229)
        retColor.outLineColor = ccc3(28,0,0)
    elseif colorString == Blue_White then
        retColor.mainColor = ccc3(84,224,243)
        retColor.outLineColor = ccc3(36,62,84)
    elseif colorString == Orange_Red then
        retColor.mainColor = ccc3(226,77,26)
        retColor.outLineColor = ccc3(248,187,43)
    end

    return retColor
end

function hl_playScaleAnimation(object,delayTime ,scale)

    local seq = CCSequence:createWithTwoActions(CCScaleBy:create(delayTime,scale),CCScaleBy:create(delayTime,1/scale))    
    object:runAction(CCRepeatForever:create(seq))
end


function createMultiColorLabel( text,fontName,size,color)
    if not text then
        cclog("text is nil")
        return
    end

    if not fontName then
        cclog("fontName is nil")
        fontName = "FZPangWa-M18S"
    end

    local textColors = getColorByString(color)

    -- 主体颜色字
    local mainTextLabel = CCLabelTTF:create(text,fontName, size)
    mainTextLabel:setColor(textColors.mainColor)

    -- 描边
    local function labelWithOffset(centerPos,offset)
        local outLineTextLabel = CCLabelTTF:create(text,fontName,size)
        outLineTextLabel:setColor(textColors.outLineColor)
        mainTextLabel:addChild(outLineTextLabel,-1)
        outLineTextLabel:setAnchorPoint(ccp(0.5,0.5))
        outLineTextLabel:setPosition(ccpAdd(centerPos,offset))
    end

    absOffset = 1 * retina
    local centerPosition = ccp(mainTextLabel:getContentSize().width/2,mainTextLabel:getContentSize().height/2)

    labelWithOffset(centerPosition,ccp(0,absOffset))
    labelWithOffset(centerPosition,ccp(0,-absOffset))
    labelWithOffset(centerPosition,ccp(-absOffset,0))
    labelWithOffset(centerPosition,ccp(absOffset,0))

    return mainTextLabel
end

-- C++报上来的方法
-- 摇一摇手机
function sensorCallBack()
    -- if postNotification then
    --     postNotification(NOTI_SHAKE_PHONE, nil)
    -- end
end

-- EnterForeground
function EnterForeground()
    cclog("EnterForeground")
    if UDefKey then
        if getUDBool(UDefKey.Setting_PlayMusicSound, true) then 
            SimpleAudioEngine:sharedEngine():resumeBackgroundMusic()
        end
    end
    local function serverTimeCallBack( url,rtnData )
        local newServerTime = rtnData["info"]["now"]
        local oldServerTime = userdata.loginTime 
        if oldServerTime > 0 and newServerTime > oldServerTime then
            time_tick(newServerTime - oldServerTime)
        end 
        userdata.loginTime = newServerTime

        -- 如果当前是登陆进游戏的状态，则取一下本地保存的日期，与服务器最新日期比较一下，如果不一样，则把游戏踢回到登陆页面
        local dateStr = getUDString(UDefKey.KEY_LOCAL_GAME_DATE)
        local newDateStr = DateUtil:formatDateTime(userdata.loginTime)
        if dateStr ~= newDateStr then
            if not getLoginLayer() then 
                userdata:resetAllData()
                local loginScene = CCScene:create()
                loginScene:addChild(LoginLayer())
                CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(0.6, loginScene))
            end
        end
    end
    if userdata then
        if userdata.sessionId and string.len(userdata.sessionId) > 0 then
            -- 已登陆
            doActionNoLoadingFun("SERVERTIME_URL", {}, serverTimeCallBack)
        end
        if SSOPlatform.GetUid() and userdata.selectServer and userdata.selectServer.serverName and userdata.userId and userdata.name and userdata.level then
            Global:instance():TDGAsetAccount(SSOPlatform.GetUid().."_"..userdata.selectServer.serverName.."_"..userdata.userId)
            Global:instance():TDGAsetAccountType(1);
            Global:instance():TDGAsetAccountName(userdata.name);
            Global:instance():TDGAsetLevel(userdata.level)
            Global:instance():TDGAsetGameServer(userdata.selectServer.serverName)
        end
    end
end

-- EnterBackground
function EnterBackground()
    cclog("EnterBackground")
    if userdata then
        if userdata.sessionId and string.len(userdata.sessionId) > 0 and userdata.loginTime > 0 then
            local dateStr = DateUtil:formatDateTime(userdata.loginTime)
            print(dateStr)
            setUDString(UDefKey.KEY_LOCAL_GAME_DATE, dateStr)
        end 
        
        -- 长时间未登陆
        local function getPushTextByTbl( tbl )
            local idx = RandomManager.randomRange(1, #tbl)
            if tbl[idx] then
                print(tbl[idx])
                return tbl[idx]
            else
                return ""
            end
        end
        if not ConfigureStorage.pushConfig then
            PrintTable(ConfigureStorage.pushConfig)
            return
        end
        -- 2天未登陆
        local ts = ConfigureStorage.pushConfig.offline1.condition1 * 3600
        Global:instance().localNotificationPush(ts, getPushTextByTbl(ConfigureStorage.pushConfig.offline1.text))
        -- 7天未登陆
        ts = ConfigureStorage.pushConfig.offline2.condition1 * 3600
        Global:instance().localNotificationPush(ts, getPushTextByTbl(ConfigureStorage.pushConfig.offline2.text))
        -- 30天未登陆
        ts = ConfigureStorage.pushConfig.offline3.condition1 * 3600
        Global:instance().localNotificationPush(ts, getPushTextByTbl(ConfigureStorage.pushConfig.offline3.text))

        if not userdata.sessionId or userdata.sessionId == "" then
            return
        end
        -- 体力恢复满
        ts = userdata:getAllStrengthTime()
        if ts > 0 then
            Global:instance().localNotificationPush(ts, getPushTextByTbl(ConfigureStorage.pushConfig.strength.text))
        end
        -- 精力恢复满
        ts = userdata:getAllEnergyTime()
        if ts > 0 then
            Global:instance().localNotificationPush(ts, getPushTextByTbl(ConfigureStorage.pushConfig.energy.text))
        end

        -- 连续10天推送
        local begin = DateUtil:beginDay(userdata.loginTime)
        for i=0,9 do
            -- 吃饭
            -- 中午12点
            ts = begin + 3600 * (12 + 24 * i) - userdata.loginTime
            if ts > 0 then
                Global:instance().localNotificationPush(ts, getPushTextByTbl(ConfigureStorage.pushConfig.eating.text))
            end
            -- 晚上6点
            ts = begin + 3600 * (18 + 24 * i) - userdata.loginTime
            if ts > 0 then
                Global:instance().localNotificationPush(ts, getPushTextByTbl(ConfigureStorage.pushConfig.eating1.text))
            end
            -- 恶魔谷
            -- 中午12点半
            ts = begin + 3600 * (12.5 + 24 * i) - userdata.loginTime
            if ts > 0 then
                Global:instance().localNotificationPush(ts, getPushTextByTbl(ConfigureStorage.pushConfig.boss.text))
            end
            -- 晚上8点半
            ts = begin + 3600 * (20.5 + 24 * i) - userdata.loginTime
            if ts > 0 then
                Global:instance().localNotificationPush(ts, getPushTextByTbl(ConfigureStorage.pushConfig.boss.text))
            end
            -- 盟战
            -- 晚上6点半
            ts = begin + 3600 * (18.5 + 24 * i) - userdata.loginTime
            if ts > 0 then
                Global:instance().localNotificationPush(ts, getPushTextByTbl(ConfigureStorage.pushConfig.leagueWar.text))
            end
            -- 海战
            ts = begin + 3600 * (10 + 24 * i) - userdata.loginTime
            if ts > 0 then
                Global:instance().localNotificationPush(ts, getPushTextByTbl(ConfigureStorage.pushConfig.seawar2.text))
            end
            ts = begin + 3600 * 22 * i - userdata.loginTime
            if ts > 0 then
                Global:instance().localNotificationPush(ts, getPushTextByTbl(ConfigureStorage.pushConfig.seawar.text))
            end
        end
    -- Global:instance().localNotificationPush(20, "191817161615151414")
    -- Global:instance().localNotificationPush(getRemainTime4CurrentByDayTime("20:00:00"), "191817161615151414")
    end
end

function AppDidFinishLaunching(  )
    print("onstart", platformType())
    
    if platformType() == PLATFORM_TYPE["9158"] then
        -- Global:TDGAcpaStartWithAppidAndChannel("2997989bbba44e24b6f91738ee9c8451",opPCL)
    end
    Global:instance():TDGAonStartWithChannelId(getTalkingdataKeyForPlatform(), opPCL)
    Global:instance():listenToSensor()
    -- body

    -- if opPCL == IOS_KY_ZH then
    --     local pDetailsArr = {}
    --     table.insert(pDetailsArr, "KEY")
    --     table.insert(pDetailsArr, "VALUE")
    --     Global:SSOLogin(pDetailsArr, table.getn(pDetailsArr), "ssoLoginSucc", "ssoLoginFail")
    -- end
end

--*********************************************add weixin call back start
function getValuesOfSensors()
    print("getvaluesofsensor")
    local x = 14
    return x
end
function ShareToWeiboSucceeded()
    print("hello share to weibo succeeded!")
    doActionNoLoadingFun("SHARE_BYCHANNEL_URL", {"weibo"}, nil)
end
function ShareToWeixinSucceeded()
    print("hello share to weixin succeeded!")
    doActionNoLoadingFun("SHARE_BYCHANNEL_URL", {"weixin"}, nil)
end
function  BindingToWeiboSucceeded(userid,token)
    print("hello BindingToWeiboSucceeded!") 
    -- print(getUDString(UDefKey.Setting_WeiboUserId, nil))
    -- print(getUDString(UDefKey.Seting_weiboToken, nil))
    userdata.weiboId = userid
    userdata.weiboToken = token
    doActionNoLoadingFun("SHARE_SETSHAREBINDINGSTATUS_URL", {"weibo", "2", userid, token}, nil)
    postNotification(NOTI_WEIBO_BIND_RESULT, nil)
end
function  RemoveBindingToWeiboSucceeded()
    print("hello RemoveBindingToWeiboSucceeded!")
    userdata.weiboId = ""
    userdata.weiboToken = ""
    doActionNoLoadingFun("SHARE_SETSHAREBINDINGSTATUS_URL", {"weibo", "1", "", ""}, nil)
    postNotification(NOTI_WEIBO_BIND_RESULT, nil)
end

--[[ 支付调用接口
    
    opPayType 类型从下列定义中选择、C++中定义枚举、已经报到LUA中
    ------ 支付类型 Begin ------
    pTypeAppleIAP  // 苹果 应用内支付
    pTypeGoogleIAB // 安卓 应用内支付
    pTypeKY        // 快用 支付
    pTypePP        // PP助手 支付
    pTypeTBT       // 同步推 支付
    pTypeAliPay    // 支付宝 支付
    pTypeTenPay    // 财付通 支付
    pTypeMyCard    // 台湾 MyCard 支付
    pType91pay     // 91助手 支付
    pTypeMobgamePay // mobgame 越南支付
    pTypeIAPPPAY    // 爱贝支付
    pTypeAGame      // 阿游戏 AGame
    ------ 支付类型  end  ------
    
    pDetails Table 类型  K, V 形式的table
    e.g.
    local pDetails = {}
    table.insert(key1, value1)
    table.insert(key2, value2)
    table.insert(key3, value3)
    …… 
    
    succCallBack 可为空 同步支付 成功反馈
    unsuccCallBack 可为空 同步支付 失败反馈
-- ]]
function executePayFun( opPayType, pDetails, succCallBack, unsuccCallBack )
    -- body
    print("支付类型"..opPayType)
    if opPayType and pDetails then
        if not succCallBack then
            succCallBack = ""
        end
        if not unsuccCallBack then
            unsuccCallBack = ""
        end

        local pDetailsArr = {}
        for pKey, pValue in pairs(pDetails) do
            print(" ---- Print By lixq ---- executePayFun pDetails", pKey, pValue)
            table.insert(pDetailsArr, pKey)
            table.insert(pDetailsArr, pValue)
        end
        Global:executePay(opPayType, pDetailsArr, table.getn(pDetailsArr), succCallBack, unsuccCallBack)

    else
        -- TODO 代码容错机制 比如 弹出框
    end
end

function addSwallowLayer()
    local tag = 65525
    local layer = CCDirector:sharedDirector():getRunningScene():getChildByTag(tag)
    if layer then
        layer:removeFromParentAndCleanup(true)
        layer = nil
    end
    local function onTouchBegan(x, y)
        return true
    end

    local function onTouchEnded(x, y)

    end

    local function onTouch(eventType, x, y)
        if eventType == "began" then   
            return onTouchBegan(x, y)
        elseif eventType == "moved" then
        else
            return onTouchEnded(x, y)
        end
    end
    local layer = CCLayer:create()
    layer:registerScriptTouchHandler(onTouch, false, -999, true)
    layer:setTouchEnabled(true)
    CCDirector:sharedDirector():getRunningScene():addChild(layer, 0, tag)
    return layer
end

--[[ facebook 分享

    pDetails Table 类型  K, V 形式的table
    e.g.
    local pDetails = {}
    table.insert(key1, value1)
    table.insert(key2, value2)
    table.insert(key3, value3)
    …… 

    succCallBack 可为空 成功反馈
    unsuccCallBack 可为空 失败反馈

--]]
function executeFBShare(pDetails, succCallBack, unsuccCallBack)
    if not succCallBack then
        succCallBack = ""
    end
    if not unsuccCallBack then
        unsuccCallBack = ""
    end
    local pDetailsArr = {}
    for pKey,pValue in pairs(pDetails) do
        table.insert(pDetailsArr, pKey)
        table.insert(pDetailsArr, pValue)
    end
    Global:executeFBShare(pDetailsArr, table.getn(pDetailsArr), succCallBack, unsuccCallBack)
end

-- 苹果 iap 成功的回调
function iapPaySucc(receipt)
    print("receipt = ", receipt)
    if isPlatform(IOS_INFIPLAY_RUS) then
        if vipdata:isFirstRecharge() then
            Global:instance():AFTrackEvent("firstPaySucceed","isFirstPay")
        end
        Global:instance():AFTrackEvent("af_revenue",runtimeCache.payCashAmount)
        runtimeCache.payCashAmount = 0.00
        Global:instance():GATrackEvent("iap","Pay","recharge",1)
    end
    if receipt and string.len(receipt) > 0 then
        postNotification(NOTI_APPLE_IAP_SUCC, receipt)
    end
    userdata:subDCount()
end

-- 苹果 iap 失败的回调
function iapPayFail()
    print("pay fail") 
    postNotification(NOTI_APPLE_IAP_FAIL, nil)
    userdata:subDCount()
end

---------- 第三方平台SSO相关 -------------
function tpSSOLogin( pDetails, succCallBack, unsuccCallBack )
    -- body
    --金立要求一定要解决闪屏问题，所以将云停止，ssologin成功后再恢复
    -- if isPlatform(ANDROID_GIONEE_ZH) then
    -- _G._mainLayerAllActions = CCDirector:sharedDirector():getActionManager():pauseAllRunningActions()
    -- _G._mainLayerAllActions = tolua.cast(_G._mainLayerAllActions, "CCSet")
    -- print("stop **********************" .. "　　" .. _G._mainLayerAllActions:count() .. "  ")
    -- end
    if pDetails and getMyTableCount(pDetails) > 0 then
        if not succCallBack then
            succCallBack = ""
        end
        if not unsuccCallBack then
            unsuccCallBack = ""
        end

        local pDetailsArr = {}
        for pKey, pValue in pairs(pDetails) do
            table.insert(pDetailsArr, pKey)
            table.insert(pDetailsArr, pValue)
        end
        Global:SSOLogin(pDetailsArr, table.getn(pDetailsArr), succCallBack, unsuccCallBack)
    else
        Global:SSOLogin({}, 0, succCallBack, unsuccCallBack)
    end
end

function ssoLoginSucc( ... )
    
    if isPlatform(IOS_PPZS_ZH) 
        or isPlatform(IOS_PPZSPARK_ZH)
        or isPlatform(ANDROID_UC_ZH)
        or isPlatform(ANDROID_BAIDU_ZH)
        or isPlatform(ANDROID_BAIDUIAPPPAY_ZH)
        or isPlatform(ANDROID_AGAME_ZH)
        or isPlatform(ANDROID_MM_ZH)
        or isPlatform(ANDROID_COOLPAY_ZH) then
        print("PP助手平台登陆回调")

        local x1 = ...
        postNotification(HL_PLATFORM_LOGIN, {x1})

    elseif isPlatform(ANDROID_360_ZH) then

        local x1 = ...
        if x1 == "0" then
            getLoginMainLayer():menuEnabled(true)
        else
            postNotification(HL_PLATFORM_LOGIN, {x1})
        end

    elseif isPlatform(IOS_VIETNAM_VI) 
        or isPlatform(IOS_VIETNAM_EN) 
        or isPlatform(IOS_VIETNAM_ENSAGA)
        or isPlatform(IOS_KY_ZH)
        or isPlatform(IOS_KYPARK_ZH)
        or isPlatform(ANDROID_KY_ZH)
        or isPlatform(IOS_MOBNAPPLE_EN)
        or isPlatform(IOS_MOB_THAI)
        or isPlatform(ANDROID_VIETNAM_VI)
        or isPlatform(ANDROID_VIETNAM_EN)
        or isPlatform(ANDROID_VIETNAM_MOB_THAI)
        or isPlatform(ANDROID_VIETNAM_EN_ALL)
        or isPlatform(IOS_MOBGAME_SPAIN)
        or isPlatform(ANDROID_MOBGAME_SPAIN)
        or isPlatform(IOS_ITOOLS)
        or isPlatform(IOS_ITOOLSPARK)
        or isPlatform(ANDROID_JAGUAR_TC) 
        or isPlatform(IOS_IIAPPLE_ZH) then
        
        local x1, x2 = ...
        if postNotification then
	        postNotification(HL_PLATFORM_LOGIN, {x1, x2})
	    end        
    elseif isPlatform(ANDROID_GIONEE_ZH)
        or isPlatform(ANDROID_ANFENG_ZH)
        or onPlatform("TGAME")
        or isPlatform(ANDROID_MYEPAY_ZH)
        or isPlatform(IOS_AISI_ZH)
        or isPlatform(IOS_AISIPARK_ZH)
        or isPlatform(ANDROID_HTC_ZH) 
        or isPlatform(IOS_TBTPARK_ZH) 
        or isPlatform(IOS_DOWNJOYPARK_ZH)
        or isPlatform(IOS_HAIMA_ZH)
        or isPlatform(IOS_XYZS_ZH)  
        or isPlatform(ANDROID_XYZS_ZH) then

    	local x1, x2, x3 = ...
        if postNotification then
            print("postNotification is not nil")
            postNotification(HL_PLATFORM_LOGIN, {x1, x2, x3})
        end
        if isPlatform(IOS_AISI_ZH) then
            getLoginMainLayer():menuEnabled(true)
        end
        -- if _mainLayerAllActions and _mainLayerAllActions ~= nil then
        --     local mainLayerAllActions = tolua.cast(_mainLayerAllActions, "CCSet")
        --     print("resume actions *****************************",mainLayerAllActions:count())

        --     CCDirector:sharedDirector():getActionManager():resumeTargets(mainLayerAllActions)
        -- end
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
        -- if isPlatform(ANDROID_GIONEE_ZH) then
        --     CCDirector:sharedDirector():getActionManager():pauseAllRunningActions()
        -- end

    elseif isPlatform(IOS_TBT_ZH) 
        or isPlatform(IOS_91_ZH) 
        or isPlatform(ANDROID_91_ZH) 
        or isPlatform(ANDROID_WDJ_ZH)
        or isPlatform(ANDROID_ANFENG_ZH)
        or isPlatform(ANDROID_DK_ZH) then

        local x1, x2, x3 = ...
        if postNotification then
            postNotification(HL_SSO_Login, {x1, x2, x3})
        end

    elseif isPlatform(ANDROID_MMY_ZH)
        or isPlatform(ANDROID_HUAWEI_ZH)   
        or isPlatform(ANDROID_DOWNJOY_ZH) then

        local x1, x2, x3, x4 = ...
        if postNotification then
            postNotification(HL_PLATFORM_LOGIN, {x1, x2, x3, x4})
        end

    elseif isPlatform(ANDROID_GV_MFACE_ZH) 
        or isPlatform(ANDROID_GV_MFACE_EN) 
        or isPlatform(ANDROID_GV_MFACE_EN_OUMEI)
        or isPlatform(ANDROID_GV_MFACE_EN_OUMEINEW)
        or isPlatform(IOS_GAMEVIEW_ZH) 
        or isPlatform(IOS_GAMEVIEW_EN)
        or isPlatform(IOS_GVEN_BREAK) 
        or isPlatform(ANDROID_GV_XJP_ZH)
        or isPlatform(ANDROID_GV_MFACE_TC)
        or isPlatform(IOS_GAMEVIEW_TC)
        or isPlatform(ANDROID_GV_MFACE_TC_GP) then

        local x1, x2, x3, x4 = ...
        if postNotification then
            postNotification(HL_SSO_Login, {x1, x2, x3, x4})
        end

    end
end

function ssoLogin91Succ( ... )
    if isPlatform(IOS_91_ZH) then

        local x1, x2, x3 = ...
        if postNotification then
            postNotification(HL_SSO91_Login, {x1, x2, x3})
        end

    end
end

function ssoLoginXiaoMiSucc( ... )
    local x1, x2, x3 = ...
    if postNotification then
        postNotification(HL_SSOXIAOMI_Login, {x1, x2, x3})
    end
end

function ssoLoginOPPOSucc( ... )
    local x1, x2, x3, x4 = ...
    if postNotification then
        postNotification(HL_SSOOPPO_Login, {x1, x2, x3, x4})
    end
end

function ssoLoginFail()
    print("ssoLoginFail")
    if isPlatform(IOS_AISI_ZH) then
        getLoginMainLayer():menuEnabled(true)
    end
end

function fbShareSuccCallback()
    print("fbShareSuccCallback")
end

function fbShareUnsuccCallback()
    print("fbShareUnsuccCallback")
end

-- mobGame收到了平台的通知新闻，上报一下数量，显示在主页的Dashboard icon上
function MobGameGetNotiNews( notiCount )
    print("MobGameGetNotiNews", notiCount)
    if postNotification then
        postNotification(NOTI_MOBGAME_NEWSCOUNT, notiCount)
    end
end

-- 平台登出成功回调
function logOutSuccCallBack(...)

    if logoutAction then
        -- 游戏中登出
        logoutAction()
    else
        -- 在登陆界面登出
        if isPlatform(IOS_KYPARK_ZH) or isPlatform(ANDROID_KY_ZH) then
            -- 没有登陆游戏，就登出
            tpSSOLogin({}, "ssoLoginSucc", "ssoLoginFail")
        end
    end
end

-- 判断是否开启分享
function isOpenShare()
    -- 默认是关闭分享
    return false
end

-- 生成tableview每条cell的滑动效果
function generateCellAction(cellArray, count)
    local actiongArray = {}
    for i=0,count - 1 do
        local cell = tolua.cast(cellArray[tostring(i)], "CCLayer") 
        if cell then
            local tempArray = {}
            tempArray.sort = i
            tempArray.content = cell
            table.insert(actiongArray,tempArray)
        end
    end 
    local function sorFun(a, b)
        return a.sort < b.sort 
    end
    table.sort(actiongArray, sorFun)
    local zeroPoint = 0
    local zeroVlue = 0
    if getMyTableCount(actiongArray) > 0 then
        for i=1,getMyTableCount(actiongArray) do
            local cell = tolua.cast(actiongArray[i].content, "CCLayer") 
            if cell then
                if actiongArray[i].sort - zeroPoint > 1 then
                    zeroVlue = actiongArray[i].sort
                end
                zeroPoint = actiongArray[i].sort
                cell:stopAllActions()
                local posX = cell:getPositionX()
                local posY = cell:getPositionY()
                cell:setPosition(ccp(posX + winSize.width, posY))
                local array = CCArray:create()
                array:addObject(CCDelayTime:create(0.12 * (actiongArray[i].sort - zeroVlue)))
                array:addObject(CCMoveTo:create(0.2, ccp(posX, posY)))
                array:addObject(CCMoveTo:create(0.08, ccp(posX + 15 * retina, posY)))
                array:addObject(CCMoveTo:create(0.08, ccp(posX, posY)))
                cell:runAction(CCSequence:create(array))
            end
        end
    end
end

