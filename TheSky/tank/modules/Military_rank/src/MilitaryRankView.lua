

local MilitaryRankView = qy.class("MilitaryRankView", qy.tank.view.BaseView, "Military_rank/ui/MilitaryrankView")

local Service = qy.tank.service.MilitaryRankService
local  model = qy.tank.model.MilitaryRankModel
local StorageModel = qy.tank.model.StorageModel
local userInfoModel = qy.tank.model.UserInfoModel


function MilitaryRankView:ctor(delegate)
    MilitaryRankView.super.ctor(self)
    self.delegate = delegate
    local style = qy.tank.view.style.ViewStyle1.new({
        titleUrl = "Resources/common/title/junxian.png",
        ["onExit"] = function()
            if model:GetExperienceValue() ~= 0 then
                local function callBack(flag)
                    if flag == qy.TextUtil:substitute(70054) then
                        delegate:finish()
                    end
                end       
                local alertMesg = "您当前有"..model:GetExperienceValue().."点历练值，每天6点会被清零，您确定要退出吗？"
                qy.alert:show({"提示" ,{255,255,255} }  ,  alertMesg , cc.size(450 , 220),{{qy.TextUtil:substitute(70057) , 4}   , {qy.TextUtil:substitute(70054) , 5}} ,callBack,"")
            else
                delegate:finish()
            end
        end
    })
    self:addChild(style, 13)
    self.Num = 0
    --注册pannel1的控件
    self:OnClick("help_btn",function()
        qy.tank.view.common.HelpDialog.new(29):show(true)
    end)
    self:InjectView("checkallBtn")--查看所有按钮
    self:InjectView("checkjsBtn")--查看晋升
    self:InjectView("rankimage") --军衔图片
    self:InjectView("ranktext")--军衔名
    self:InjectView("titletext")--特权
    self:InjectView("actext")--攻击力
    self:InjectView("anoac")--额外攻击力
    self:InjectView("fangtext")--防御力
    self:InjectView("anofang")--额外防御力
    self:InjectView("lifetext")--生命值
    self:InjectView("anolife")--额外生命值
    self:InjectView("lingquBtn")--领取薪资按钮
    self:InjectView("awad_bg")--薪资背景
    self:InjectView("huoquBtn")
    self:InjectView("Image_155")
    self:InjectView("Image_83")
    self:InjectView("Sprite_4")
    self.Image_83:setVisible(false)
    self.Image_155:setVisible(false)
    self:OnClick("huoquBtn", function(sender)
        qy.tank.command.ActivitiesCommand:showActivity(qy.tank.view.type.ModuleType.OFFER_A_REWARD)
    end)
    self:OnClick("checkjsBtn", function(sender)
        if  model:getRankLevel() == 24 then
            qy.hint:show("已达到最大军衔")
        else
            self.pannel2:setVisible(false)
            self.pannel3:setVisible(true)
            self.pannel4:setVisible(false)
        end
    end)
    self:OnClick("checkallBtn", function(sender)
        delegate:showScenelistView()
    end)
    self:OnClick("lingquBtn", function(sender)
        --领取奖励
        Service:ReceiveSalary(function()
            -- body
            print("领取薪资")
        self.lingquBtn:setTouchEnabled(false)
        self.lingquBtn:setEnabled(false)
        self.lingquBtn:setVisible(false)
        self.Image_155:setVisible(false)
        self.Image_83:setVisible(true)
        qy.Event.dispatch(qy.Event.USER_RESOURCE_DATA_UPDATE)
        end)
    end)
    self:UpdatePannel1()--初始化更新pannel1
    
    --注册pannel2
    self:InjectView("pannel2") --进修属性pannel
    self.pannel2:setVisible(false)
    self:InjectView("jungongNum") --所需军功数目
    self:InjectView("meneytext") --所需银币数目
    self:InjectView("jinxiuBtn") --进修
    
    for i=1,4 do
        local a = "jinxiubg"..i
        self:InjectView(a)
    end
      --星图的node
    self:InjectView("NodeParent")
 
    self:OnClick("jinxiuBtn", function(sender)
        --进修
        if self._jungongtype == true then
            qy.hint:show("军功不足")
        else
            if self.silverType == true then
                qy.hint:show("银币不足")
            else
                if model:getRankLevel() == 24 and model:GetNumById(4) == 30 then
                    qy.hint:show("进修已满")
                else
                    Service:uplevel(function(data)
                        if data.status == 100 then
                            -- qy.hint:show("恭喜你，本次进修效果显著")
                            self:showUtil(data.upattr)
                            self:updatepannels()
                            self:UpdatePannel1()
                            self:UpdatePannel2()
                            self:UpdatePannel4()
                        else
                            qy.hint:show("很遗憾，本次进修未通过")
                        end
                        self:Update()
                    end)
                end
            end
        end
       
    end)
    self:UpdatePannel2()--初始化更新pannel2

    --注册pannel3
    self:InjectView("backjxBtn")--返回进修按钮
    self:InjectView("pannel3") --晋升预览pannel
    self.pannel3:setVisible(false)
    self:InjectView("rankicon1") --军衔图片
    self:InjectView("ranktext1")--军衔名
    self:InjectView("title1")--特权
    self:InjectView("actext1")--攻击力
    self:InjectView("fangtext1")--防御力
    self:InjectView("lifetext1")--生命值
    self:InjectView("awad_bg1")--薪资背景
    self:InjectView("Sprite_41")
    self:OnClick("backjxBtn", function(sender)
        self.pannel3:setVisible(false)
        if model:GetType() == 100 then
            self.pannel4:setVisible(true)
            self.pannel2:setVisible(false)
        else
            self.pannel4:setVisible(false)
            self.pannel2:setVisible(true)
        end
    end)
    self:UpdatePannel3()--初始化更新pannel3

    --注册pannel4
    self:InjectView("pannel4") --晋升pannel
    -- self.pannel4:setVisible(false)
    self:InjectView("tequan2")--特权
    self:InjectView("actnum2")--攻击力
    self:InjectView("anoactnum2")--额外攻击力
    self:InjectView("fangnum2")--防御力
    self:InjectView("anofang2")--额外防御力
    self:InjectView("lifenum2")--生命值
    self:InjectView("anolife2")--额外生命值
    self:InjectView("jungongNum1")--所需军功证
    self:InjectView("jinshennum")--所需晋升领
    self:InjectView("LNum")--历练值
    self:InjectView("jinduimage")--进度条
    self:InjectView("jinshengBtn")
    self:InjectView("jinshengtext")
    self:InjectView("jinshengimage")--晋升种类icon精灵
    self:InjectView("buyBtn")--购买军功令按钮
    self:OnClick("jinshengBtn", function(sender)
       --晋升
        local _level = model:getRankLevel()
        local uplevel = model:getlocalDateById(_level).level
        if userInfoModel.userInfoEntity.level >= uplevel then
            if self.jungongType == true then
                qy.hint:show("军功不足")
            else 
                if self.buyType == true then
                    self:buyDialog()   
                else
                    Service:uprank(function ( data )
                        local x 
                        if data.status == 100 then
                            x = data.militaryrank_level-1
                            local _datas = model:getlocalDateById(x)
                            StorageModel:remove(_datas.props_id , _datas.consume1)
                            qy.hint:show("晋升成功")
                            self:updatepannels()
                            self:UpdatePannel1()
                            self:UpdatePannel2()
                            self:UpdatePannel3()
                            self:showUtil1(data)
   
                        else
                            qy.hint:show("很遗憾！本次晋升失败，获得"..data.upexp.."点历练值")
                        end

                        self:UpdatePannel4()  
                    end)
                end
            end
        else
            qy.hint:show("指挥官等级达到"..uplevel.."级开启下级晋升")
        end

    end)
    self:UpdatePannel4()--初始化更新pannel4
    self:OnClick("buyBtn", function(sender)
        self:buyDialog()
    end)
    self:updatepannels()
    	
end
function MilitaryRankView:updatepannels()
    local types = model:GetType()
    local  level = model:getRankLevel()
    if types == 100 and level ~= 24 then
        self.pannel2:setVisible(false)
        self.pannel4:setVisible(true)
    else
        self.pannel2:setVisible(true)
        self.pannel4:setVisible(false)
    end
end
function MilitaryRankView:UpdatePannel1()
    local level  = model:getRankLevel()
    local att = 0
    local def = 0
    local blod = 0
    if level ~= 1 then 
        for i=1,level-1 do
            local data2 =  model:getlocalLevelDateById(i)
            att = att + data2.attack*10
            def = def + data2.defense*10
            blod = blod + data2.blood*10
        end
    end
    local _data = model:getlocalDateById(level)
    local _data1 = model:getlocalLevelDateById(level)
    self.ranktext:setString(_data.nickname)
    local png = "Military_rank/res/rank/"..level..".png"
    print("-------",png)
    self.rankimage:loadTexture(png,1)
    local dess = model:getDescInfoByStr(_data.desc,1)
    self.titletext:setString("")
    dess:setPosition(-10,0)
     self.titletext:removeAllChildren()
    self.titletext:addChild(dess)

    local totalatt = _data.total_attack
    local totaldef = _data.total_defense
    local totalblod = _data.total_blood
    if level == 1 then
        self.actext:setString("当前攻击力")
        self.fangtext:setString("当期防御力")
        self.lifetext:setString("当前生命值") 
    else
        self.actext:setString("攻击力+"..totalatt)
        self.fangtext:setString("防御力+"..totaldef)
        self.lifetext:setString("生命值+"..totalblod)
    end

    self.anoac:setString("(+"..model:GetNumById(1)*_data1.attack..")")
    self.anofang:setString("(+"..model:GetNumById(2)*_data1.defense..")")
    self.anolife:setString("(+"..model:GetNumById(3)*_data1.blood..")")

    --判断是否领取按钮
    local status = model:getBtn()
    if status == 100 then
        self.lingquBtn:setTouchEnabled(true)
        self.lingquBtn:setEnabled(true)
        self.lingquBtn:setVisible(true)
        self.Image_155:setVisible(true)
        self.Image_83:setVisible(false)
    else
        self.lingquBtn:setTouchEnabled(false)
        self.lingquBtn:setEnabled(false)
        self.lingquBtn:setVisible(false)
        self.Image_155:setVisible(false)
        self.Image_83:setVisible(true)
    end

    self.awad_bg:removeAllChildren()
    local award =  _data.award
      for i=1,#award do
        local item = qy.tank.view.common.AwardItem.createAwardView(award[i] ,1)
        self.awad_bg:addChild(item)
        item:setPosition(80 + 120*(i - 1), 60)
        item:setScale(0.8)
        item.name:setVisible(false)
    end
end
function MilitaryRankView:UpdatePannel2()
    local level = model:getRankLevel()
    self.NodeParent:removeAllChildren()
     local item = require("Military_rank.src.Rank1").new({
                    ["csdName"] = "Military_rank/ui/Rank"..level..".lua",  
            })
    -- local item = require("Military_rank.src.Rank1").new(self)
    self.NodeParent:addChild(item)
    local data =  model:getlocalLevelDateById(level)
    local jungong = userInfoModel.userInfoEntity.military_exploit
    self.jungongNum:setString(data.consume1.."/"..jungong)
    if jungong >= data.consume1 then
        self._jungongtype = false 
        self.jungongNum:setColor(cc.c3b(255, 255, 255))
    else
        self._jungongtype = true
        self.jungongNum:setColor(cc.c3b(178, 34, 34))
    end
    local silver = userInfoModel.userInfoEntity.silver
     if silver >= data.consume then
        self.silverType = false 
        self.meneytext:setColor(cc.c3b(255, 255, 255))
    else
        self.silverType = true 
        self.meneytext:setColor(cc.c3b(178, 34, 34))
    end
    self.meneytext:setString(data.consume)
    if level <=4 then
        self.jinxiubg1:setVisible(true)
        self.jinxiubg2:setVisible(false)
        self.jinxiubg3:setVisible(false)
        self.jinxiubg4:setVisible(false)
    elseif level>4 and level<=8 then
        self.jinxiubg1:setVisible(false)
        self.jinxiubg2:setVisible(true)
        self.jinxiubg3:setVisible(false)
        self.jinxiubg4:setVisible(false)
    elseif level>8 and level<=12 then
        self.jinxiubg1:setVisible(false)
        self.jinxiubg2:setVisible(false)
        self.jinxiubg3:setVisible(true)
        self.jinxiubg4:setVisible(false)
    else
        self.jinxiubg1:setVisible(false)
        self.jinxiubg2:setVisible(false)
        self.jinxiubg3:setVisible(false)
        self.jinxiubg4:setVisible(true)
    end

    
end
function MilitaryRankView:UpdatePannel3()
    cc.SpriteFrameCache:getInstance():addSpriteFrames("Military_rank/res/rank/ranks.plist")
    local level = model:getRankLevel()
    local _att = 0
    local _def = 0
    local _blod = 0
    for i=1,level do
        local data2 =  model:getlocalLevelDateById(i)
        _att = _att + data2.attack*10
        _def = _def  + data2.defense*10
        _blod = _blod  + data2.blood*10
    end
    local idx = level>=24 and 24 or (level+1)
    local data = model:getlocalDateById(idx)
    local data2 =  model:getlocalLevelDateById(idx)
    local png = "Military_rank/res/rank/"..idx..".png"
    self.rankicon1:loadTexture(png,1)
    self.ranktext1:setString(data.nickname)
    local dess = model:getDescInfoByStr(data.desc,2)
    dess:setPosition(-15,0)
    self.title1:setString("")
    self.title1:removeAllChildren()
    self.title1:addChild(dess)
    

    local _data = model:getlocalDateById(level)

    local att = data.attack -_data.attack - _att
    self.actext1:setString("攻击力+"..data.total_attack)

    local defense = data.defense -_data.defense - _def
    self.fangtext1:setString("防御力+"..data.total_defense)

    local blood = data.blood -_data.blood - _blod
    self.lifetext1:setString("生命值+"..data.total_blood)
    self.awad_bg1:removeAllChildren()
    local award =  data.award
    for i=1,#award do
        local item = qy.tank.view.common.AwardItem.createAwardView(award[i] ,1)
        self.awad_bg1:addChild(item)
        item:setPosition(80 + 120*(i - 1), 60)
        item:setScale(0.8)
        item.name:setVisible(false)
    end
end
function MilitaryRankView:UpdatePannel4()
    local level = model:getRankLevel()
    -- local att = 0
    -- local def = 0
    -- local blod = 0
    -- for i=1,level do
    --     local data = model:getlocalDateById(i)
    --     local data2 =  model:getlocalLevelDateById(i)
    --     att = att + data.attack + data2.attack*10
    --     def = def + data.defense + data2.defense*10
    --     blod = blod + data.blood + data2.blood*10
    -- end
    local data = model:getlocalDateById(level)
    local data2 =  model:getlocalLevelDateById(level)
    local att =data.attack + data2.attack*10 + data2.total_attack
    local def = data.defense + data2.defense*10 + data2.total_defense
    local blod =  data.blood + data2.blood*10 + data2.total_blood
    local idx = level>=24 and 24 or (level+1)
    local _data = model:getlocalDateById(idx)
    local _data2 =  model:getlocalLevelDateById(idx)
    
    self.tequan2:setString("")
    local dess = model:getDescInfoByStr(_data.desc,3)
    dess:setPosition(0,0)
    self.tequan2:removeAllChildren()
    self.tequan2:addChild(dess)

    self.actnum2:setString("攻击力+"..att)
    self.anoactnum2:setString("(+".._data.attack-data.attack..")")

    self.fangnum2:setString("防御力+"..def)
    self.anofang2:setString("(+".._data.defense-data.defense..")")

    self.lifenum2:setString("生命值+"..blod)
    self.anolife2:setString("(+".._data.blood-data.blood..")")

    --消耗
    local _datas = model:getlocalDateById(level)
    local jungong = userInfoModel.userInfoEntity.military_exploit
    self.jungongNum1:setString(_datas.consume.."/"..jungong)
    if jungong >= _datas.consume then
        self.jungongType = false 
        self.jungongNum1:setColor(cc.c3b(255, 255, 255))
    else
        self.jungongType = true 
        self.jungongNum1:setColor(cc.c3b(178, 34, 34))
    end
    self.types = _datas.props_id
    local png = "Military_rank/res/".._datas.props_id..".png"
    self.jinshengimage:setSpriteFrame(png)
    local  values = model:GetExperienceValue()
    self.LNum:setString("历练值："..values.."/10")
    if values == 0 then
        self.jinduimage:setScaleX(0)
    else
        self.jinduimage:setScaleX(values/10)
    end

    self.Num = StorageModel:getPropNumByID(_datas.props_id)
    
    self.jinshennum:setString(_datas.consume1.."/"..self.Num)
    if self.Num >= _datas.consume1 then
        self.buyType = false
        self.jinshennum:setColor(cc.c3b(255, 255, 255))
    else
        self.jinshennum:setColor(cc.c3b(178, 34, 34))
        self.buyType = true
    end
   if self.types == 68 then 
        self.jinshengtext:setString("所需士官晋升令:")
    elseif self.types == 69 then 
        self.jinshengtext:setString("所需尉官晋升令:")
    elseif self.types == 70 then 
        self.jinshengtext:setString("所需校官晋升令:")
    elseif self.types == 71 then 
        self.jinshengtext:setString("所需将官晋升令:")
    end
    
end

-- 飘字
function MilitaryRankView:showUtil(data)
    local url
    local value 
    local fightPower = qy.tank.model.UserInfoModel.userInfoEntity.fightPower - qy.tank.model.UserInfoModel.userInfoEntity.oldfight_power
    if data =="attack" then 
        url = qy.ResConfig.IMG_ATTACK
        value = model:GetValueById(1)
    elseif data =="defense" then 
        url = qy.ResConfig.IMG_DEFENSE
        value = model:GetValueById(2)
    elseif data =="blood" then 
        url = qy.ResConfig.IMG_BLOOD
        value = model:GetValueById(3)
    end
    
    local _aData = {}
    _data = {
        ["value"] = value,
        ["url"] = url,
        ["type"] = 15,
        ["picType"] = 2,
     }
    table.insert(_aData, _data)
    local _aDatas = {}
    _datas = {
        ["value"] = fightPower,
        ["url"] = qy.ResConfig.IMG_FIGHT_POWER,
        ["type"] = 15,
        ["picType"] = 2,
     }
    table.insert(_aDatas, _datas)
    qy.tank.utils.HintUtil.showSomeImageToast(_aDatas,cc.p(qy.winSize.width / 3 * 2, qy.winSize.height * 0.7-20))
    qy.tank.utils.HintUtil.showSomeImageToast(_aData,cc.p(qy.winSize.width / 3 * 2, qy.winSize.height * 0.7))
end
function MilitaryRankView:showUtil1(data)
    local level = data.militaryrank_level
    local attack = model:getlocalDateById(level).attack - model:getlocalDateById(level-1).attack 
    local defense = model:getlocalDateById(level).defense - model:getlocalDateById(level-1).defense 
    local blood = model:getlocalDateById(level).blood - model:getlocalDateById(level-1).blood 
    local fightPower = qy.tank.model.UserInfoModel.userInfoEntity.fightPower - qy.tank.model.UserInfoModel.userInfoEntity.oldfight_power
    local _aData1 = {}
    _data1 = {
        ["value"] = attack,
        ["url"] = qy.ResConfig.IMG_ATTACK,
        ["type"] = 15,
        ["picType"] = 2,
     }
    table.insert(_aData1, _data1)
     local _aData2 = {}
    _data2 = {
        ["value"] = defense,
        ["url"] = qy.ResConfig.IMG_DEFENSE,
        ["type"] = 15,
        ["picType"] = 2,
     }
    table.insert(_aData2, _data2)
     local _aData3 = {}
    _data3 = {
        ["value"] = blood,
        ["url"] = qy.ResConfig.IMG_BLOOD,
        ["type"] = 15,
        ["picType"] = 2,
     }
    table.insert(_aData3, _data3)
    local _aDatas = {}
    _datas = {
        ["value"] = fightPower,
        ["url"] = qy.ResConfig.IMG_FIGHT_POWER,
        ["type"] = 15,
        ["picType"] = 2,
     }
    table.insert(_aDatas, _datas)
    qy.tank.utils.HintUtil.showSomeImageToast(_aDatas,cc.p(qy.winSize.width / 3 * 2, qy.winSize.height * 0.7-60))
    qy.tank.utils.HintUtil.showSomeImageToast(_aData1,cc.p(qy.winSize.width / 3 * 2, qy.winSize.height * 0.7))
    qy.tank.utils.HintUtil.showSomeImageToast(_aData2,cc.p(qy.winSize.width / 3 * 2, qy.winSize.height * 0.7-20))
    qy.tank.utils.HintUtil.showSomeImageToast(_aData3,cc.p(qy.winSize.width / 3 * 2, qy.winSize.height * 0.7+40))
end
function MilitaryRankView:buyDialog()
        --购买 id 25,26,27
       local ids = 0
        if self.types == 68 then 
            ids  = 25
        elseif self.types == 69 then 
            ids  = 26
        elseif self.types == 70 then 
            ids  = 27
        elseif self.types == 71 then 
            ids  = 28
        end
        if self.types == 68 or self.types == 69 then
            local entity = qy.tank.model.PropShopModel:getShopPropsEntityById(ids)
            local buyDialog = qy.tank.view.shop.PurchaseDialog.new(entity,function(num)
                local service = qy.tank.service.ShopService
                service:buyProp(entity.id,num,function(data)
                    if data and data.consume then
                        qy.hint:show(qy.TextUtil:substitute(8029)..data.consume.num)
                        self.Num = self.Num + data.consume.num
                        self:UpdatePannel4()
                    end
                end)
            end)
            buyDialog:show(true)
        end
        if self.types == 70 or self.types == 71 then
            local function callBack(flag)
                if flag == qy.TextUtil:substitute(70054) then
                    print("前往最强之战")--moduleType.
                    self.delegate:finish()
                   qy.tank.command.MainCommand:viewRedirectByModuleType(qy.tank.view.type.ModuleType.GREATEST_RACE)
                end
            end       
            local alertMesg = "最强之战可获得高级晋升令，是否前往最强之战"
            qy.alert:show({"提示" ,{255,255,255} }  ,  alertMesg , cc.size(450 , 220),{{qy.TextUtil:substitute(70057) , 4}   , {qy.TextUtil:substitute(70054) , 5}} ,callBack,"")
        end
end
function MilitaryRankView:onEnter()
    cc.SpriteFrameCache:getInstance():addSpriteFrames("Military_rank/res/rank/ranks.plist")
    self:Update()--刷新军功
end
function MilitaryRankView:Update()
    local level = model:getRankLevel()
    local data =  model:getlocalLevelDateById(level)
    local jungong = userInfoModel.userInfoEntity.military_exploit
    self.jungongNum:setString(data.consume1.."/"..jungong)
    if jungong >= data.consume1 then
        self._jungongtype = false  
        self.jungongNum:setColor(cc.c3b(255, 255, 255))
    else
        self._jungongtype = true 
        self.jungongNum:setColor(cc.c3b(178, 34, 34))
    end
    local _datas = model:getlocalDateById(level)
    self.jungongNum1:setString(_datas.consume.."/"..jungong)
    if jungong >= _datas.consume then
        self.jungongType = false  
        self.jungongNum1:setColor(cc.c3b(255, 255, 255))
    else
        self.jungongType = true 
        self.jungongNum1:setColor(cc.c3b(178, 34, 34))
    end
end
function MilitaryRankView:onExit()
    self.currentEffert = nil
end


return MilitaryRankView
