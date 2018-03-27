--[[--
    国际化转换工具类
    主要用于多语言的代码差别的一些换算，目的是为了减少热更的文件
    如果是一些多语言的判断，尽量抽取出来放到该工具类

    用法：qy.InternationalUtil:getResNumString(100)
--]]--

local InternationalUtil = {}

--获取资源单位自动转换后的数值：当资源大于8位时，自动变成“万”为单位的字符串，否则，依然显示当前数字
function InternationalUtil:getResNumString(num)
    local cNum = tonumber(num)
    if qy.language == "en" then
        -- 英文 k
        if cNum > 9999999 then
            return math.floor(cNum/1000).."K"
        else
            return num
        end
    else
        -- 中文 W
        if cNum > 9999999 then
            return math.floor(cNum/10000).."W"
        else
            return num
        end
    end
end

-- 战斗结算页面是否添加遮罩 1:胜利 2:失败
function InternationalUtil:isShowView(sender, type)
    if qy.language == "en" then
        if type == 1 then
            sender:initWithSpriteFrameName("Resources/battle/fight_0006.png")
        elseif type == 2 then
            sender:initWithSpriteFrameName("Resources/battle/fight_0013.png")
        end
    end
end

-- 邮件内容是否显示
function InternationalUtil:isShowMailContents()
    if qy.language == "en" then
        return false
    else
        return true
    end
end

-- 设置页面 bind 按钮字是否显示
function InternationalUtil:isShowBinding()
    if qy.language == "en" then
        return false
    else
        return true
    end
end

-- 邮件是否显示名字
function InternationalUtil:isShowMailName()
    if qy.language == "en" then
        return false
    else
        return true
    end
end

--即将开放-黄色
function InternationalUtil:StatusTxt1()
    if qy.language == "en" then
        return "COME SOON"
    else
        return "(即将开放)"
    end
end

--新服-绿色
function InternationalUtil:StatusTxt2()
    if qy.language == "en" then
        return "NEW"
    else
        return "(新服)"
    end
end

--火爆-红色
function InternationalUtil:StatusTxt3()
    if qy.language == "en" then
        return "HOT"
    else
        return "(火爆)"
    end
end

--维护-灰色
function InternationalUtil:StatusTxt4()
    if qy.language == "en" then
        return "Maint"
    else
        return "(维护)"
    end
end

--获取稀有矿区等级段描述
function InternationalUtil:isShowLv()
    if qy.language == "en" then
        return "Lv."
    else
        return ""
    end
end

function InternationalUtil:isShow1()
    if qy.language == "en" then
        return ""
    else
        return qy.TextUtil:substitute(70016)
    end
end

function InternationalUtil:isShow2()
    if qy.language == "en" then
        return ""
    else
        return qy.TextUtil:substitute(70025)
    end
end

function InternationalUtil:gettLevelHeight()
    if qy.language == "en" then
        return 18
    else
        return 20.0
    end
end

function InternationalUtil:getLabel1FontSize()
    if qy.language == "en" then
        return 20
    else
        return 24
    end
end

function InternationalUtil:getLabel1Height()
    if qy.language == "en" then
        return 100
    else
        return 80
    end
end

function InternationalUtil:getAwardPreviewDialogFontSize()
    if qy.language == "en" then
        return 20
    else
        return 24
    end
end

function InternationalUtil:getBattleResultViewExpBarWidth()
    if qy.language == "en" then
        return 56
    else
        return 16
    end
end

function InternationalUtil:getBattleResultViewAwardListWidth()
    if qy.language == "en" then
        return 150
    else
        return 110
    end
end

function InternationalUtil:getBattleResultViewRefreshLabelX()
    if qy.language == "en" then
        return 66
    else
        return 52
    end
end

function InternationalUtil:getItemIconNameFontSize()
    if qy.language == "en" then
        return 20
    else
        return 18
    end
end

function InternationalUtil:getTankInfoListLayoutHeight()
    if qy.language == "en" then
        return 1
    else
        return 2
    end
end

function InternationalUtil:getTankItemNameY()
    if qy.language == "en" then
        return 25
    else
        return 20
    end
end

function InternationalUtil:getTankFontSize()
    if qy.language == "en" then
        return 19
    else
        return 22
    end
end

function InternationalUtil:getInspectionDialogX()
    if qy.language == "en" then
        return (-55 + 280)
    else
        return (-55 + 310)
    end
end

function InternationalUtil:getInspectionDialogFontSize()
    if qy.language == "en" then
        return 18
    else
        return 22
    end
end

function InternationalUtil:getInspectionDialogContentSize()
    if qy.language == "en" then
        return 670
    else
        return 650
    end
end

function InternationalUtil:getFarmMsgCellFontSize()
    if qy.language == "en" then
        return 17
    else
        return 21
    end
end

function InternationalUtil:getOpenPCellFontSize()
    if qy.language == "en" then
        return 16
    else
        return 21
    end
end

function InternationalUtil:getMailDialogReceiverNameX()
    if qy.language == "en" then
        return 140
    else
        return 125
    end
end

function InternationalUtil:getMailDialogReceiverNameFontSize()
    if qy.language == "en" then
        return 20
    else
        return 24
    end
end

function InternationalUtil:getPlunderLogCellNameFontSize()
    if qy.language == "en" then
        return 20
    else
        return 24
    end
end

function InternationalUtil:getPlunderLogCellx()
    if qy.language == "en" then
        return -5
    else
        return 0
    end
end

function InternationalUtil:getPlunderLogCelly()
    if qy.language == "en" then
        return 10
    else
        return 0
    end
end

function InternationalUtil:getLoginGiftCellX()
    if qy.language == "en" then
        return 48
    else
        return 110
    end
end

function InternationalUtil:getServerGiftCelldayPicX()
    if qy.language == "en" then
        return 120
    else
        return 155
    end
end

function InternationalUtil:getServerGiftCelldayPicX1()
    if qy.language == "en" then
        return 147
    else
        return 182
    end
end

function InternationalUtil:getServerGiftCelldayPicX2()
    if qy.language == "en" then
        return 37
    else
        return 114
    end
end

function InternationalUtil:getRechargeItemPrice()
    if qy.language == "en" then
        return "$"
    else
        return "￥"
    end
end

function InternationalUtil:getRechargeViewVip()
    if qy.language == "en" then
        return 40
    else
        return 80
    end
end

function InternationalUtil:getSupplyInfoCellFontSize()
    if qy.language == "en" then
        return 18
    else
        return 24
    end
end

function InternationalUtil:getTankTipBasisTitleX()
    if qy.language == "en" then
        return 65
    else
        return 60
    end
end

function InternationalUtil:getTankTipTalentTitleX()
    if qy.language == "en" then
        return 65
    else
        return 50
    end
end

function InternationalUtil:getTankDesTitleX()
    if qy.language == "en" then
        return 65
    else
        return 60
    end
end

function InternationalUtil:getTankBgX()
    if qy.language == "en" then
        return 370
    else
        return 400
    end
end

function InternationalUtil:getTankBgY()
    if qy.language == "en" then
        return -60
    else
        return 100
    end
end

function InternationalUtil:getTankTipFontSize()
    if qy.language == "en" then
        return 18
    else
        return 20
    end
end

function InternationalUtil:getTankTipAdvanceCheckTitleX()
    if qy.language == "en" then
        return 98
    else
        return 82
    end
end

function InternationalUtil:getPrivilegeTxt()
    if qy.language == "en" then
        return 20
    else
        return 24
    end
end

function InternationalUtil:getPrivilegeTxtBtnX()
    if qy.language == "en" then
        return 550
    else
        return 340
    end
end

function InternationalUtil:getVipPrivilegeCellX()
    if qy.language == "en" then
        return 110
    else
        return 160
    end
end

function InternationalUtil:getVipPrivilegeCellAwardListX()
    if qy.language == "en" then
        return 180
    else
        return 230
    end
end

function InternationalUtil:getAttributeValueLabelX()
    if qy.language == "en" then
        return 57
    else
        return 0
    end
end

function InternationalUtil:getAttributeValueLabelAnchor()
    if qy.language == "en" then
        return 0
    else
        return 1
    end
end

function InternationalUtil:getAttributeValueLabelNameX()
    if qy.language == "en" then
        return -40
    else
        return 0
    end
end

function InternationalUtil:getAttributeValueLabelY()
    if qy.language == "en" then
        return 2
    else
        return 0
    end
end

function InternationalUtil:hasTankReform()
    if qy.language == "cn" then
        return true
    else
        return false
    end
end

function InternationalUtil:hasLegionMail()
    if qy.language == "cn" then
        return true
    else
        return false
    end
end

return InternationalUtil
