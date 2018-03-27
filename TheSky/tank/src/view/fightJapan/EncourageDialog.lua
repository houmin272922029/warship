--[[
    元整鼓舞
]]
local EncourageDialog = qy.class("EncourageDialog", qy.tank.view.BaseDialog, "view/fightJapan/EncourageDialog")

function EncourageDialog:ctor(delegate)
    EncourageDialog.super.ctor(self)
    self.model = qy.tank.model.FightJapanModel
    self.userInfoModel = qy.tank.model.UserInfoModel

    self:InjectView("totalWhiskyTxt")
    self:InjectView("effectTxt1")
    self:InjectView("effectTxt2")
    self:InjectView("effectTxt3")
    self:InjectView("effectTxt4")
    self:InjectView("effectTxt5")
    self:InjectView("effectTxt6")
    self:InjectView("sayContentTxt")
    self:InjectView("sayBg")
    self:InjectView("valueTxt1")
    self:InjectView("valueTxt2")
    self:InjectView("valueTxt3")
    self:InjectView("valueTxt4")
    self:InjectView("valueTxt5")
    self:InjectView("valueTxt6")

    function addTxtStyle(txt)
        txt:enableOutline(cc.c4b(0,0,0,255),1)
        txt:setTextColor(cc.c4b(255, 255, 255,255))
    end

    addTxtStyle(self.effectTxt1)
    addTxtStyle(self.effectTxt2)
    addTxtStyle(self.effectTxt3)
    addTxtStyle(self.effectTxt4)
    addTxtStyle(self.effectTxt5)
    addTxtStyle(self.effectTxt6)

    self.sayBg:setOpacity(0)

    -- 通用弹窗样式
    self.style = qy.tank.view.style.DialogStyle2.new({
        size = cc.size(880,515),
        position = cc.p(0,0),
        offset = cc.p(28.5,20.5),
        titleUrl = "Resources/common/title/encourage_title.png",

        ["onClose"] = function()
            self:dismiss()
        end
    })
    self:addChild(self.style , -1)

     -- 攻击
    self:OnClick("encourageBtn1", function(sender)
        self:setEncourage(1)
    end)

    -- 防御"
    self:OnClick("encourageBtn2", function(sender)
        self:setEncourage(2)
    end)

    -- 生命总值
    self:OnClick("encourageBtn3", function(sender)
        self:setEncourage(3)
    end)

    -- 暴击
    self:OnClick("encourageBtn4", function(sender)
        self:setEncourage(4)
    end)

    -- 生命恢复
    self:OnClick("encourageBtn5", function(sender)
        self:setEncourage(5)
    end)

    -- 士气恢复
    self:OnClick("encourageBtn6", function(sender)
        self:setEncourage(6)
    end)

    self:OnClick("girlBtn", function(sender)
        self:showRandomSay()
    end)

    local currentNeed = self:updateCurrentNeed()

    self:OnClick("buyWhiskyBtn", function(sender)
        local fontName = qy.language == "tw" and "res/Resources/font/ttf/black_body_2.TTF" or "Arial"
        local alertMesg = {
                    {id=1,color={255,255,255},alpha=255,text=qy.TextUtil:substitute(13001),font=fontName,size=20},
                    {id=2,color={255,255,0},alpha=255,text=""..currentNeed .. qy.TextUtil:substitute(13002),font=fontName,size=20},
                    {id=3,color={255,255,255},alpha=255,text=qy.TextUtil:substitute(13003),font=fontName,size=20},
                    {id=4,color={0,255,0},alpha=255,text=qy.TextUtil:substitute(13004),font=fontName,size=20},
                    {id=5,color={255,255,255},alpha=255,text=qy.TextUtil:substitute(13005),font=fontName,size=20}
                }
       qy.alert:show(
                {qy.TextUtil:substitute(13006) ,{255,255,255} } ,
                alertMesg ,
                cc.size(533 , 250) ,{{qy.TextUtil:substitute(13007) , 4} , {qy.TextUtil:substitute(13008) , 5} } ,
                function(flag)
                    if qy.TextUtil:substitute(13008) == flag then
                        local service = qy.tank.service.FightJapanService
                            service:buyWhisky(param,function(data)
                                qy.hint:show(qy.TextUtil:substitute(13009))
                                self.model.buyWhiskyCountCurrent = data.whisky_buy_times
                                currentNeed = self:updateCurrentNeed()
                                self:updateWhisky()
                        end)
                    end
                end ,"")
    end)

    local config = self.model:getEncourageConfig()
    self.valueTxt1:setString(config["1"].consume)
    self.valueTxt2:setString(config["2"].consume)
    self.valueTxt3:setString(config["3"].consume)
    self.valueTxt4:setString(config["4"].consume)
    self.valueTxt5:setString(config["5"].consume)
    self.valueTxt6:setString(config["6"].consume)

    self:updateAll()
end

function EncourageDialog:updateCurrentNeed()
    local currentNeed = 0
    self.model.buyWhiskyCountCurrent = self.model.buyWhiskyCountCurrent +1
    if self.model.buyWhiskyCountCurrent <=self.model.buyWhiskyCountMax then
        currentNeed = self.model.buyWhiskyCountCurrent
    else
        self.model.buyWhiskyCountCurrent = self.model.buyWhiskyCountMax
        currentNeed = self.model.buyWhiskyCountMax
    end
    return currentNeed
end

-- 显示人物提示
function EncourageDialog:showRandomSay( )
    self.sayBg:setOpacity(255)
    -- self.sayBg:stopAction()
    local sayStr = ""
    local num = 3*math.random()
    if(num <=1) then
        sayStr = qy.TextUtil:substitute(13010)
        self.sayBg:setContentSize(510 , 81.00)
    else if(num > 1 and num<=2)then
            sayStr =qy.TextUtil:substitute(13011)
            self.sayBg:setContentSize(550 , 81.00)
        else
            sayStr = qy.TextUtil:substitute(13012)
            self.sayBg:setContentSize(640 , 81.00)
        end
    end
    self.sayContentTxt:setString(sayStr)
    self:HideRandomSay()
end

function  EncourageDialog:HideRandomSay( )
    if self.seq~=nil then
        self.sayBg:stopAction(self.seq)
        self.seq = nil
    end
    local action = cc.FadeTo:create(1,0)
    local delay = cc.DelayTime:create(2)
    self.seq = cc.Sequence:create(delay , action , nil)
    self.sayBg:runAction(self.seq)

end

function EncourageDialog:updateAll()
    self:updateWhisky()
    self:updateEncourageEffects()
end

-- 鼓舞
function EncourageDialog:setEncourage(id)
    local service = qy.tank.service.FightJapanService
    local param ={}
    param.type = id
         service:setEncourage(param,function(data)
            local encourageContentArr = {
                qy.TextUtil:substitute(13013) ,
                qy.TextUtil:substitute(13014) ,
                qy.TextUtil:substitute(13015) ,
                qy.TextUtil:substitute(13016) ,
                qy.TextUtil:substitute(13017) ,
                qy.TextUtil:substitute(13018)
            }
            qy.hint:show(encourageContentArr[tonumber(id)])
            self:updateAll()
        end)
end

-- 更新鼓舞效果
function EncourageDialog:updateEncourageEffects()
    self.encourageInfo = self.model:getEncourageInfo()

    local encourageContentArr = {
        qy.TextUtil:substitute(13019)..self.encourageInfo["1"].val.."%" ,
        qy.TextUtil:substitute(13020)..self.encourageInfo["2"].val.."%" ,
        qy.TextUtil:substitute(13021)..self.encourageInfo["3"].val.."%",
        qy.TextUtil:substitute(13022)..self.encourageInfo["4"].val.."%",
        qy.TextUtil:substitute(13023)..self.encourageInfo["5"].val.."%",
        qy.TextUtil:substitute(13024)..self.encourageInfo["6"].val
    }
    self.effectTxt1:setString(encourageContentArr[1])
    self.effectTxt2:setString(encourageContentArr[2])
    self.effectTxt3:setString(encourageContentArr[3])
    self.effectTxt4:setString(encourageContentArr[4])
    self.effectTxt5:setString(encourageContentArr[5])
    self.effectTxt6:setString(encourageContentArr[6])

end
--刷新威士忌
function EncourageDialog:updateWhisky( )
    self.totalWhiskyTxt:setString(self.userInfoModel.userInfoEntity.whisky)
end

return EncourageDialog
