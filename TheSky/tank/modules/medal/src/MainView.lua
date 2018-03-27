

local MainView = qy.class("MainView", qy.tank.view.BaseView, "medal/ui/MainVIew1")

local service = qy.tank.service.MedalService
local garageModel = qy.tank.model.GarageModel
local  model = qy.tank.model.MedalModel
local StorageModel = qy.tank.model.StorageModel
local userInfoModel = qy.tank.model.UserInfoModel
local medal_list = {}

function MainView:ctor(delegate)
    MainView.super.ctor(self)
    self.delegate = delegate
    qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync(qy.ResConfig.XUNZHANG)
    cc.SpriteFrameCache:getInstance():addSpriteFrames("medal/res/medal.plist")
    cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/common/item/common_item.plist")
    cc.SpriteFrameCache:getInstance():addSpriteFrames("medal/res/medal/medals.plist")
    local style = qy.tank.view.style.ViewStyle1.new({
        titleUrl = "medal/res/xunzhang.png",
            ["onExit"] = function()
            print("关闭的flag啊",self.closeflag)
            model.chonghzutype = 0
            if self.closeflag == 0 then
                 delegate:finish()
            elseif self.closeflag == 1 then
                self.closeflag = 0
                self.garageflag = 1
                self.yeshulist = {}
                self.tempchoosemedal = self.choosemedal
                self:updatepannel1(false)
                self.pannel1:setVisible(true)
                self.pannel2:setVisible(false)
                self.pannel3:setVisible(false)
                self.node1:setVisible(false)
            else
                self.closeflag = 0
                self:updatepannel2(1,2)
                self.pannel2:setVisible(true)
                self.pannel3:setVisible(false)
                self.node1:setVisible(true)
             end
            if self:getChildByTag(999) then
                self:removeChildByTag(999,true)
            end
        end
    })
    self:addChild(style, 13)
    for i=1,3 do
        self:InjectView("Bt"..i)
        self:InjectView("pannel"..i)
        self:InjectView("iconnum"..i)
    end
    self:InjectView("help")--帮助
    --pannel1
    self:InjectView("tanklist")
    self:InjectView("huoquBt")
    self:InjectView("fangda")
    self:InjectView("name")--名称
    self:InjectView("yizhilist")
    self:InjectView("texiaobg")
    for i=1,3 do
        self:InjectView("shuxing"..i)
        self:InjectView("extra"..i)
        self:InjectView("extrabg"..i)
    end
    for i=1,6 do
        self:InjectView("fram"..i)
        self:InjectView("item"..i)
        self:InjectView("add"..i)
        self:InjectView("weizhi"..i)
    end
    self:InjectView("fenjieBt")--分解
    self:InjectView("zhanshiBt")--展示
    self:InjectView("jingzhuBt")--经注
    self:InjectView("xiexiaBt")--写下
    self:InjectView("chongzhuBt")--重铸
    self:InjectView("Text")--无意志文字
    self:InjectView("dangqianwenzi")--当前意志文字
    self:InjectView("nomedal")
    self:InjectView("mingchengwenzi")
    self:InjectView("xuanzhong")

    --pannel2
    self:InjectView("zhuanhuaBt")
    self:InjectView("xuanzeall")
    self:InjectView("quedingBt")
    self:InjectView("leftBt")
    self:InjectView("rightBt")
    self:InjectView("listbg")
    self:InjectView("totalnum")--页数
    self:InjectView("pannel2_2")--只有分解才显示的
    self:InjectView("num1")
    self:InjectView("num2")--转化获得道具的数量
    self:InjectView("jingzhuyeimg")--精铸液图标
    --pannnel3
    self:InjectView("medallist")
    self:InjectView("texiao")
    self:InjectView("medal_item")
    self.node1  = ccui.ImageView:create()
    self.node1:loadTexture("Resources/common/bg/c_12.png")
    self.node1:setScaleX(450)
    self.node1:setScaleY(210)
    self.node1:setPosition(cc.p(420,150))
    self.pannel2:addChild(self.node1,200,200)
    for i=1,9 do
        self:InjectView("tujian"..i)
    end
    for i=1,3 do
        self:InjectView("miaoshu"..i)
        self:InjectView("yizhi"..i)
    end

    self:OnClick("Bt1",function ( sender )
        self:updateBt(1)
    end)
    self:OnClick("Bt2",function ( sender )
        -- self.closeflag = 0
        self:updateBt(2)
    end)
    self:OnClick("Bt3",function ( sender )
        self.closeflag = 0
        self:updateBt(3)
        -- body
    end)
    self:OnClick("help",function ( sender )
         qy.tank.view.common.HelpDialog.new(qy.tank.model.HelpTxtModel:getHelpDataByIndx(40)):show(true)
    end)
    self:OnClick("extrabg1",function ( sender )
        if self.tip1 == 1 then
            local node = require("medal.src.Tip").new()
            node:show()
        elseif self.tip1  == 2 then
            local node = require("medal.src.Tip2").new()
            node:show()
        else
        end
    end)
    self:OnClick("extrabg2",function ( sender )
        if self.tip2 == 1 then
            local node = require("medal.src.Tip").new()
            node:show()
        elseif self.tip2  == 2 then
            local node = require("medal.src.Tip2").new()
            node:show()
        else
        end
    end)
    self:OnClick("extrabg3",function ( sender )
        if self.tip3  == 1 then
            local node = require("medal.src.Tip").new()
            node:show()
        elseif self.tip3  == 2 then
            local node = require("medal.src.Tip2").new()
            node:show()
        else
        end
    end)
    self:OnClick("fenjieBt",function ( sender )
        -- local list = model.explainlist--分解的id
        -- if #list == 0 then
        --     qy.hint:show("没有可分解的勋章")
        --     return
        -- end
        self.closeflag = 1
        self.explainlist = {}
        self:updatepannel2(2)
    end)
    self:OnClick("zhanshiBt",function ( sender )
        if self.Btflag == 1 then
            qy.hint:show("请装备勋章后展示")
            return
        end
        service:showMedalToWorld(self.attr.unique_id,function (  )
            qy.hint:show("指挥官,已为您展示到世界聊天频道")
        end)
    end)
    self:OnClick("jingzhuBt",function ( sender )
        if self.Btflag == 1 then
            qy.hint:show("请装备蓝色及以上的勋章后精铸")
            return
        end
        if self.attrcolor1 < 4 and self.attrcolor2 < 4 and self.attrcolor3 < 4 then
            qy.hint:show("紫色及以上属性品质可精铸")
            return
        end
        if self.attrcolor2 == 0 and self.atttfull1 == true then
            qy.hint:show("紫色及以上属性已满，不可精铸")
            return
        end
        if self.attrcolor2 ~=0 then
            if self.attrcolor3 == 0 and self.atttfull2 == true then
                qy.hint:show("紫色及以上属性已满，不可精铸")
                return
            end
        end
        if self.atttfull1== true and self.atttfull2== true and self.atttfull3== true then
            print("进这里来了")
            qy.hint:show("紫色及以上属性已满，不可精铸")
            return
        end
        self.closeflag = 1
        self.pannel1:setVisible(false)
        local nodes =  require("medal.src.CastingView").new({
            ["data"] = self.attr,
            ["callback"] = function (  )
                self:updateziyuan()
            end
            })
        self:addChild(nodes,999,999)
    end)
    self:OnClick("xiexiaBt",function ( sender )
        if self.Btflag == 1 then
            qy.hint:show("没有可卸下的勋章")
            return
        end
        print("卸下第几个tank的",self.choosetank)
        print("位置呢",self.choosemedal)
        if self.choosemedal ~= 0 then
            service:medalTakeOff(self.selectTankdata[self.choosetank..""].unique_id,self.choosemedal,function (  )
                local listCury = self.tanklistbg:getContentOffset()
                if self.tanklist:getChildByTag(666) then
                    self.tanklist:removeChildByTag(666,true)
                end
                self.tanklistbg = self:createView2()
                self.tanklist:addChild(self.tanklistbg,666,666)
                self.tanklistbg:setContentOffset(listCury)--设置滚动距离
                self:updatepannel1(true)
            end)
        end
    end)
    self:OnClick("chongzhuBt",function ( sender )
         if self.Btflag == 1 then
            qy.hint:show("请装备勋章后重铸")
            return
        end
        self.closeflag = 1
        self.pannel1:setVisible(false)
        local nodes =  require("medal.src.RecastView").new({
            ["data"] = self.attr,
            ["callback"] = function (  )
                self:updateziyuan()
            end
            })
        self:addChild(nodes,999,999)
    end)
    self:OnClickForBuilding1("item1",function ( sender )
        if medal_list["1"] == 0 then
            self:addMedal(1)
        else
            self.choosemedal = 1
            self:updateshuxing()
        end
    end)
    self:OnClickForBuilding1("item2",function ( sender )
        if medal_list["2"] == 0 then
            self:addMedal(2)
        else
            self.choosemedal = 2
            self:updateshuxing()
        end
    end)
    self:OnClickForBuilding1("item3",function ( sender )
        if medal_list["3"] == 0 then
            self:addMedal(3)
        else
            self.choosemedal = 3
            self:updateshuxing()
        end
    end)
    self:OnClickForBuilding1("item4",function ( sender )
        if medal_list["4"] == 0 then
            self:addMedal(4)
        else
            self.choosemedal = 4
            self:updateshuxing()
        end
    end) 
    self:OnClickForBuilding1("item5",function ( sender )
        if medal_list["5"] == 0 then
            self:addMedal(5)
        else
            self.choosemedal = 5
            self:updateshuxing()
        end
    end)
    self:OnClickForBuilding1("item6",function ( sender )
        if medal_list["6"] == 0 then
            self:addMedal(6)
        else
            self.choosemedal = 6
            self:updateshuxing()
        end
    end)
    self:OnClick("fangda",function()
        if self.Btflag == 1 then
            qy.hint:show("请装备勋章后查看")
            return
        end
        local nodes =  require("medal.src.CheckView").new({
            ["tank_id"] = self.selectTankdata[self.choosetank..""].unique_id
            })
        nodes:show()  
    end)
    self:OnClick("huoquBt",function()
        local node =  require("medal.src.JumpView").new({
            ["callback"] = function (  )
                delegate:finish()
            end
            })
        node:show()  
    end)
    --pannnel2
    self:OnClick("zhuanhuaBt",function()
        local node =  require("medal.src.MedelChangeView").new()
        node:show()  
    end)
    self:OnClick("xuanzeall",function ( sender )
        local list = model.explainlist--分解的id
        if #list == 0 then
            qy.hint:show("没有可分解的勋章")
            return
        end
        for i=1,#self.yeshulist do
            if self.yeshulist[i] == self.garageflag then
                return
            end
        end
        local minnum 
        local tempnum = self.garageflag * 6
        if self.garageflag == 1 then
            minnum = 1
        else
            minnum = (self.garageflag-1) * 6 + 1
        end
        if #list < tempnum then
            tempnum = #list
        end
        for i=minnum,tempnum do
            self:updateexplain(i,false)
        end
        table.insert(self.yeshulist,self.garageflag)
        self:_updatepannel2()
    end)
    self:OnClick("quedingBt",function ( sender )
        if self.explainlist == nil or #self.explainlist == 0 then
            qy.hint:show("请勾选要分解的勋章")
            return
        end
        local list = {}
        local data = model.explainlist
        for i=1,#self.explainlist do
            table.insert(list,data[self.explainlist[i]].unique_id)
        end
        local function callBack(flag)
            if flag == qy.TextUtil:substitute(4012) then
                service:fenjie(list,function (  )
                    self.yeshulist = {}
                    self:updateziyuan()
                    self.explainlist = {}
                    self:updatepannel2(2)
                end)
            end
        end
        local image = ccui.ImageView:create()
        image:setContentSize(cc.size(500,120))
        image:setScale9Enabled(true)
        image:loadTexture("Resources/common/bg/c_12.png")


        local richTxt = ccui.RichText:create()
        richTxt:ignoreContentAdaptWithSize(false)
        richTxt:setContentSize(500, 150)
        richTxt:setAnchorPoint(0,0.5)
        local stringTxt1 = ccui.RichElementText:create(1, cc.c3b(255,255,255), 255, "确定要分解", qy.res.FONT_NAME_2, 24)
        richTxt:pushBackElement(stringTxt1)
        local stringTxt2 = ccui.RichElementText:create(1, cc.c3b(255, 165, 0), 255, #list, qy.res.FONT_NAME_2, 24)
        richTxt:pushBackElement(stringTxt2)
        local stringTxt3 = ccui.RichElementText:create(1, cc.c3b(255,255,255), 255, "个勋章将获得", qy.res.FONT_NAME_2, 24)
        richTxt:pushBackElement(stringTxt3)
        local stringTxt8 = ccui.RichElementText:create(1, cc.c3b(172, 54, 249), 255, self.fenjienum1, qy.res.FONT_NAME_2, 24)
        richTxt:pushBackElement(stringTxt8)
        if self.fenjienum2 ~= 0 then
            local stringTxt4 = ccui.RichElementText:create(1, cc.c3b(255,255,255), 255, "重铸液和", qy.res.FONT_NAME_2, 24)
            richTxt:pushBackElement(stringTxt4)
            local stringTxt44 = ccui.RichElementText:create(1, cc.c3b(255, 153, 0), 255, self.fenjienum2, qy.res.FONT_NAME_2, 24)
            richTxt:pushBackElement(stringTxt44)
            local stringTxt5 = ccui.RichElementText:create(1, cc.c3b(255,255,255), 255, "精铸液吗？", qy.res.FONT_NAME_2, 24)
            richTxt:pushBackElement(stringTxt5)
        else
            local stringTxt6 = ccui.RichElementText:create(1, cc.c3b(255,255,255), 255, "重铸液吗？", qy.res.FONT_NAME_2, 24)
            richTxt:pushBackElement(stringTxt6)
        end
        image:addChild(richTxt)

        qy.alert:showWithNode(qy.TextUtil:substitute(9004),  image, cc.size(560,250), {{qy.TextUtil:substitute(4011) , 4},{qy.TextUtil:substitute(4012) , 5} }, callBack, {})
        image:setPosition(image:getPositionX() -5, image:getPositionY() - 30)
    end)
    self:OnClick("leftBt",function ( sender )
        if self.leftBtflag1 == 1 then
            self.leftBtflag1 = 2
            self.garageflag = self.garageflag -1
            self:updategaragenum()
            local listCurX = self.garagelist:getContentOffset().x
            self.garagelist:setContentOffsetInDuration(cc.p((1-self.garageflag)*900,0),0.800)
            local delay = cc.DelayTime:create(1)
            self:runAction(cc.Sequence:create(delay,cc.CallFunc:create(function()
                self.leftBtflag1 = 1
            end)))
        end
    end)
    self:OnClick("rightBt",function ( sender )
        if self.leftBtflag1 == 1 then
            self.leftBtflag1 = 2
            self.garageflag = self.garageflag +1
            self:updategaragenum()
            local listCurX = self.garagelist:getContentOffset().x
            -- self.garagelist:setContentOffset(cc.p(listCurX-900,0),false)
            self.garagelist:setContentOffsetInDuration(cc.p((1-self.garageflag)*900,0),0.800)
            local delay = cc.DelayTime:create(1)
            self:runAction(cc.Sequence:create(delay,cc.CallFunc:create(function()
                self.leftBtflag1 = 1
            end)))
        end
    
    end)
    self.fenjienum1 = 0 --分解获得重铸液
    self.fenjienum2 = 0 --分解获得精铸液
    self.choosetank = 0
    self.tempchoosemedal = 0
    self.zhuangbeiflag = false
    self.Btflag = 0
    self.type = true --不可一直滑动
    self.closeflag = 0
    self:updateBt(1)
    self.leftBtflag1 = 1
    self.tujianflag = 1--图鉴默认选择第一个
    self.garageflag = 1 --仓库默认选择第一页
    self.explainlist = {} --分解list
    self.addflag = 1 --装备勋章默认第一个
    self.choosemedal = 0 --当前选择第一个位置的勋章，0为无勋章\
    self.attr = {}--当前选中的属性勋章 重铸和精铸用
    self.mod_attr = {}
    self.yeshulist = {}--分解的页数列表
    self.selectTankdata = {}
    local list = model.medallist
    self.totalgragenum = #list
    self.tanklistbg = self:createView2()
    self.tanklist:addChild(self.tanklistbg,666,666)
    self.tanklists = self:createView()
    self.tanklist:addChild(self.tanklists,667,667)
    self.modelslist = self:createmedalView()
    self.medallist:addChild(self.modelslist)
    self.garagelist = self:creategrageView(1,list)
    self.listbg:addChild(self.garagelist)
    self:updatepannel3(1)
    self:updatepannel1(true)
    self:updateziyuan()
    self:updategaragenum()
    self:addBT()
end
function MainView:updateziyuan(  )
   self.iconnum1:setString(userInfoModel.userInfoEntity.diamond)
   self.iconnum2:setString(userInfoModel.userInfoEntity.afliquid)
   self.iconnum3:setString(userInfoModel.userInfoEntity.exliquid)
end
function MainView:addBT( list )
    local action = cc.FadeOut:create(1)--淡出
    local action2 = cc.FadeIn:create(1)--淡入
    local callback1 = function (  )
        self["add1"]:setOpacity(0)
    end
    local action_1 = cc.RepeatForever:create( cc.Sequence:create(action, cc.CallFunc:create(callback1),action2))
    self["add1"]:runAction(action_1)
    local action3 = cc.FadeOut:create(1)--淡出
    local action4 = cc.FadeIn:create(1)--淡入
    local callback2 = function (  )
        self["add2"]:setOpacity(0)
    end
    local action_2 = cc.RepeatForever:create( cc.Sequence:create(action3, cc.CallFunc:create(callback2),action4))
    self["add2"]:runAction(action_2)
    local action5 = cc.FadeOut:create(1)--淡出
    local action6 = cc.FadeIn:create(1)--淡入
    local callback3 = function (  )
        self["add3"]:setOpacity(0)
    end
    local action_3 = cc.RepeatForever:create( cc.Sequence:create(action5, cc.CallFunc:create(callback3),action6))
    self["add3"]:runAction(action_3)
    local action7 = cc.FadeOut:create(1)--淡出
    local action8 = cc.FadeIn:create(1)--淡入
      local callback4 = function (  )
        self["add4"]:setOpacity(0)
    end
    local action_4 = cc.RepeatForever:create( cc.Sequence:create(action7, cc.CallFunc:create(callback4),action8))
    self["add4"]:runAction(action_4)
    local action9 = cc.FadeOut:create(1)--淡出
    local action10 = cc.FadeIn:create(1)--淡入
    local callback5 = function (  )
        self["add5"]:setOpacity(0)
    end
    local action_5 = cc.RepeatForever:create( cc.Sequence:create(action9, cc.CallFunc:create(callback4),action10))
    self["add5"]:runAction(action_5)
    local action11 = cc.FadeOut:create(1)--淡出
    local action12 = cc.FadeIn:create(1)--淡入 
    local callback6 = function (  )
        self["add6"]:setOpacity(0)
    end
    local action_6 = cc.RepeatForever:create( cc.Sequence:create(action11, cc.CallFunc:create(callback6),action12))
    self["add6"]:runAction(action_6)
end
function MainView:addMedal( position )
    --做判断如果没有可添加的给提示就好了
    local list = model:GetMedalByPos(position)
    if #list == 0 then
        qy.hint:show("没有此类型的勋章")
        return
    end
    self.tempchoosemedal = position
    print("mmmmmmmmmmm",self.tempchoosemedal)
    self.addflag = position
    self:updatepannel2(3,position)
end
function MainView:updateBt( type1 )
    if type1 == 1 then
        self.Bt1:setEnabled(false)
        self.Bt2:setEnabled(true)
        self.Bt3:setEnabled(true)
        self.pannel1:setVisible(true)
        self.pannel2:setVisible(false)
        self.pannel3:setVisible(false)
        self.node1:setVisible(false)
    elseif type1 == 2 then
        self.Bt1:setEnabled(true)
        self.Bt2:setEnabled(false)
        self.Bt3:setEnabled(true)
        self.pannel1:setVisible(false)
        self:updatepannel2(1,2)
        self.pannel2:setVisible(true)
        self.pannel3:setVisible(false)
        self.node1:setVisible(true)
    else
        self.Bt1:setEnabled(true)
        self.Bt2:setEnabled(true)
        self.Bt3:setEnabled(false)
        self.pannel1:setVisible(false)
        self.pannel2:setVisible(false)
        self.pannel3:setVisible(true)
        self.node1:setVisible(false)
    end
    if self:getChildByTag(999) then
        self:removeChildByTag(999,true)
    end

 
end
function MainView:updateshuxing(  )
    self.attrcolor1 = 0--每个属性的品质记录下，可不可以精铸用这个判断
    self.attrcolor2 = 0
    self.attrcolor3 = 0
    self.tip1 = 0
    self.tip2 = 0
    self.tip3 = 0
    self.atttfull1 = false--每个属性是否为满
    self.atttfull2 = false
    self.atttfull3 = false
    -- print("刷属性",self.choosemedal)
    self["name"]:setVisible(true)
    for i=1,3 do
        self["shuxing"..i]:setVisible(true)
        self["extra"..i]:setVisible(true)
        self["extrabg"..i]:setVisible(true)
    end
    local actions = {}
    print("11111111111",self.choosemedal)
    self.xuanzhong:setPosition(self["item"..self.choosemedal]:getPosition())
    self.xuanzhong:setOpacity(255)
    for i=1,2 do
        local action = cc.FadeOut:create(0.3)--淡出
        local action2 = cc.FadeIn:create(0.3)--淡入
        local callback = cc.CallFunc:create(function()
            self.xuanzhong:setOpacity(0)
        end)
        table.insert(actions, action)
        table.insert(actions, callback)
        table.insert(actions, action2)
    end
    local callback1 = cc.CallFunc:create(function()
        self.xuanzhong:setOpacity(0)
    end)
    table.insert(actions, callback1)
    self.xuanzhong:runAction(cc.Sequence:create(actions))
    --数值
    local medal_id = medal_list[tostring(self.choosemedal)]
 
    self.attr = model.totallist[tostring(medal_id)]
    -- print("11111111111",self.choosemedal)
    print("222222222222",json.encode(self.attr))
    print("333333333",medal_id)
    local medaldata = model.medalcfg[self.attr.medal_id..""]
    self["name"]:setString(medaldata.name)
    local color = qy.tank.utils.ColorMapUtil.qualityMapColorFor3b(medaldata.medal_colour)
    self["name"]:setColor(color)
    local isfulllist = model:IsFull(self.attr,1)
    -- print("判断是否为满属性",json.encode(isfulllist))
    for i=1,3 do
        local data = self.attr.attr
        if data[i] then
            -- self["shuxing"..i]:setVisible(true)
            self["extra"..i]:setVisible(true)
            self["extrabg"..i]:setVisible(true)
            local id = data[i].attr_id
            local medalattr = model.medalattribute[id..""]
            local attribute = medalattr.attribute--类型
            local color = medalattr.colour_id --颜色 
            if color > 6 then color = 6 end
            -- self["attrcolor1"..i
            self["attrcolor"..i] = color
            local color = qy.tank.utils.ColorMapUtil.qualityMapColorFor3b(color)
            self["shuxing"..i]:setColor(color)
            local  totalnum = data[i].attr_val
            --判断属性满不满
            if isfulllist["id"..i] == -1 then
                local tempnum = isfulllist["num"..i]/10
                if attribute < 6 then
                    self["extra"..i]:setString(isfulllist["num"..i])
                else
                    self["extra"..i]:setString(tempnum.."%")
                end
                self["tip"..i] = 1
                self["extra"..i]:setColor(cc.c3b(170,170,170))
            elseif isfulllist["id"..i] == 1 then
                local tempnum = isfulllist["nothernum"..i]/10
                if attribute < 6 then
                    self["extra"..i]:setString(isfulllist["nothernum"..i])
                else
                    self["extra"..i]:setString(tempnum.."%")
                end
                -- self["extra"..i]:setString("+"..isfulllist["nothernum"])
                totalnum = totalnum + isfulllist["num"..i]
                self["extra"..i]:setColor(cc.c3b(170,170,170))
                self["atttfull"..i] = true
                self["tip"..i] = 1
            else
                self["atttfull"..i] = false
                totalnum = totalnum + isfulllist["num"..i]
                self["extra"..i]:setString("(共鸣)")
                self["extra"..i]:setColor(color)
                self["tip"..i] = 2
            end
            if isfulllist["id"..i] == 1 then
                if attribute < 6 then
                    self["shuxing"..i]:setString("·"..model.tujianTypeNameList[tostring(attribute)]..":+"..totalnum.."(满)")
                else
                    local tempnum = totalnum/10
                    self["shuxing"..i]:setString("·"..model.tujianTypeNameList[tostring(attribute)]..":+"..tempnum.."%".."(满)")
                end
            else
                if attribute < 6 then
                    self["shuxing"..i]:setString("·"..model.tujianTypeNameList[tostring(attribute)]..":+"..totalnum)
                else
                    local tempnum = totalnum/10
                    self["shuxing"..i]:setString("·"..model.tujianTypeNameList[tostring(attribute)]..":+"..tempnum.."%")
                end
            end
        else
            self["shuxing"..i]:setString(" 未激活")
            self["shuxing"..i]:setColor(cc.c3b(255,255,255))
            self["extra"..i]:setVisible(false)
            self["extrabg"..i]:setVisible(false)
        end
    end
end
function MainView:updatepannel1( choosetype,_choosemedal )--choosetype 为一个flag 当为false 的时候不改变当前选择的勋章数
    local num = 0
    if self.texiaobg:getChildByTag(699) then
        self.texiaobg:removeChildByTag(699,true)
    end
    print("第几个tank啊",self.choosetank)
    medal_list = {}
    self.yizhilist:removeAllChildren(true)
    self.selectTank.item.light:setVisible(true)
    print("kkkkkkk",self.selectTankdata[self.choosetank..""].unique_id)
    local list = model:atTank(self.selectTankdata[self.choosetank..""].unique_id)
    -- local list  = self.selectTank.item.entity.medal
    local ta = table.nums(list)
    if ta ~= 0 then
        num = 1
        -- medal_list = {}
        for i=1,6 do
            if list[tostring(i)] then
                medal_list[tostring(i)] = list[tostring(i)]
            else
                medal_list[tostring(i)] = 0 
            end
        end
        print("=========",json.encode(medal_list))
        if medal_list["1"] == 0 and medal_list["2"] == 0 and medal_list["3"] == 0 and medal_list["4"] == 0 and medal_list["5"] == 0 and medal_list["6"] == 0 then
            self:initpannel1()
        else
            --先初始化图标
            self.Btflag  = 0
            local yizhilist = {}
            local noyizhi = {}
            for i=1,6 do
                self.nomedal:setVisible(false)
                self.mingchengwenzi:setVisible(true)
                if medal_list[tostring(i)] ~= 0 then
                    self["weizhi"..i]:setVisible(false)
                    self["add"..i]:setVisible(false)
                    self["fram"..i]:setVisible(true)
                    local medal_id = model.totallist[tostring(medal_list[tostring(i)])].medal_id--勋章id
                    local medaldata = model.medalcfg[medal_id..""]
                    table.insert(yizhilist,medaldata.foreign_id)
                    self["item"..i]:loadTexture("res/medal/"..medaldata.foreign_id.."_0"..medaldata.position..".jpg")
                    self["item"..i]:setScale(0.84)
                    -- print("yanshe",medaldata.medal_colour)
                    local png = "Resources/common/item/item_bg_"..medaldata.medal_colour..".png"
                    self["fram"..i]:loadTexture(png,1)
                else
                    table.insert(yizhilist,-1)
                    self["fram"..i]:setVisible(false)
                    self["item"..i]:setScale(1)
                    self["item"..i]:loadTexture("medal/res/lvse.png",1)
                    self["weizhi"..i]:setVisible(true)
                    self["add"..i]:setVisible(true)
                end
            end
            --然后刷新意志
            -- print("意志力组团了",json.encode(yizhilist))
            --每天添加勋章，这里要增加的现状一共有七个
            for i=1,7 do
                noyizhi[i] = 0
                for j=1,#yizhilist do
                    if i == yizhilist[j] then
                        noyizhi[i] =  noyizhi[i] + 1
                    end
                end
            end
            -- print("组完团之后呢",json.encode(noyizhi))
            local www = 0
            for i=1,#noyizhi do
                local tag = 9999 + www
                if noyizhi[i] >= 2 and noyizhi[i] < 4 then
                    www = www + 1
                    local node1 = require("medal.src.TextCell2").new({
                        ["num"] = 1,
                        ["id"] =i
                        })
                    node1:setPosition(cc.p(-70,40 - www * 35))
                    self.yizhilist:addChild(node1)
                elseif noyizhi[i] >=4 and noyizhi[i] < 6  then
                    for k=1,2 do
                        www = www + 1
                        local node1 = require("medal.src.TextCell2").new({
                            ["num"] = k,
                            ["id"] = i
                        })
                        node1:setPosition(cc.p(-70,40 - www * 35))
                        self.yizhilist:addChild(node1)
                    end
                elseif noyizhi[i] == 6 then
                    for k=1,3 do
                        www = www + 1
                        local node1 = require("medal.src.TextCell2").new({
                            ["num"] = k,
                            ["id"] = i
                        })
                        node1:setPosition(cc.p(-70,40 - www * 35))
                     self.yizhilist:addChild(node1)
                    end
                else
                end
                if www == 3 then
                    break
                end
            end
            if www == 0 then
                self.Text:setVisible(true)
                self.dangqianwenzi:setVisible(false)
            else
                self.Text:setVisible(false)
                self.dangqianwenzi:setVisible(true)
            end
            for i=1,#noyizhi do
                if noyizhi[i]== 6 then
                    for i=1,6 do
                        self["item"..i]:setScale(1)
                        self["fram"..i]:setVisible(false)
                    end
                    self:__showEffert(self.texiaobg)
                    break
                end
            end
        end

        if choosetype == true then
            self.choosemedal = 0
            for i=1,6 do
                if medal_list[tostring(i)] ~= 0 then
                    self.choosemedal = i
                    break
                end
            end
        end
    self:updateshuxing()--刷新数值
    else
        for i=1,6 do
            medal_list[i..""] = 0
        end
        self:initpannel1()
        self.tip1 = 0
        self.tip2 = 0
        self.tip3 = 0
    end
end
function MainView:__showEffert(node1)
    if node1:getChildByTag(699) then
        node1:removeChildByTag(699,true)
    end
    local isEffertShow = false
    if self.currentEffert == nil then
        self.currentEffert = ccs.Armature:create("ui_fx_huizhang")
        node1:addChild(self.currentEffert,699,699)
        -- self.currentEffert:setScale(1.25)
        local size = node1:getContentSize()
        self.currentEffert:setPosition(size.width/2-96,size.height/2+135)
    end

    self.currentEffert:getAnimation():setMovementEventCallFunc(function(armatureBack,movementType,movementID)
        if movementType == ccs.MovementEventType.complete then
            isEffertShow = false
        end
    end)
    if not self.isEffertShow then
        isEffertShow = true
        self.currentEffert:getAnimation():playWithIndex(0)
    end
    self.currentEffert = nil
end
function MainView:initpannel1(  )
    self.Btflag = 1
    self.choosemedal = 0
    print("initpannel1 初始化0")
    for i=1,6 do
        self["item"..i]:loadTexture("medal/res/lvse.png",1)
        self["item"..i]:setScale(1)
        self["weizhi"..i]:setVisible(true)
        self["add"..i]:setVisible(true)
        self["fram"..i]:setVisible(false)
    end
    self["name"]:setVisible(false)
    for i=1,3 do
        self["shuxing"..i]:setVisible(false)
        self["extra"..i]:setVisible(false)
    end
    self.nomedal:setVisible(true)
    self.Text:setVisible(true)
    self.dangqianwenzi:setVisible(false)
    self.mingchengwenzi:setVisible(false)
end
function MainView:updatepannel1ByPosition( id )
    self.pannel1:setVisible(true)
    self.pannel2:setVisible(false)
    self.node1:setVisible(false)
    local list = model:GetMedalByPos(self.addflag)[id]
    
    local medal_id = list.medal_id--勋章id
    local medaldata = model.medalcfg[medal_id..""]
    
    service:medalPutOn(list.unique_id,self.selectTankdata[self.choosetank..""].unique_id, function (  )
        self.choosemedal = self.tempchoosemedal
        print("iiiiiiiiiii期",self.choosemedal)
        local listCury = self.tanklistbg:getContentOffset()
        if self.tanklist:getChildByTag(666) then
            self.tanklist:removeChildByTag(666,true)
        end
        self.tanklistbg = self:createView2()
        self.tanklist:addChild(self.tanklistbg,666,666)
        self.tanklistbg:setContentOffset(listCury)--设置滚动距离
        self:updatepannel1(false)
    end )
    

end
function MainView:updatepannel2( type ,position)
    --types = 1 仓库，都显示， types = 2 分解，只显示未分解的 type = 3 要装备
    local list = {}
    if type == 2 then
        self.pannel2_2:setVisible(true)
        list = model.explainlist
        self.closeflag = 1
    elseif type == 1 then
        list = model.medallist
        self.pannel2_2:setVisible(false)
        self.closeflag = 0
    else
        self.pannel2_2:setVisible(false)
        list = model:GetMedalByPos(position)
        self.closeflag = 1
    end
    self.num1:setString(0)
    self.num2:setString(0)
    self.totalgragenum = #list
    self.garageflag  = 1
    self:updategaragenum()
    self.listbg:removeAllChildren(true)
    self.garagelist = self:creategrageView(type,list)
    self.listbg:addChild(self.garagelist)
    self.pannel1:setVisible(false)
    self.pannel2:setVisible(true)
    self.node1:setVisible(true)

end
function MainView:_updatepannel2( )--全选刷新
    local list = {}
    self.pannel2_2:setVisible(true)
    list = model.explainlist
    self.closeflag = 1

    self.totalgragenum = #list
    self.listbg:removeAllChildren(true)
    self.garagelist = self:creategrageView(2,list)
    self.listbg:addChild(self.garagelist)
    self.garagelist:setContentOffsetInDuration(cc.p((1-self.garageflag)*900,0),0)
    self.pannel1:setVisible(false)
    self.pannel2:setVisible(true)
    self.node1:setVisible(true)

end
function MainView:RollNode( x )
    if self.garageflag == 1 and x > 0 then
        return
    end
    if self.garageflag == math.ceil(self.totalgragenum/6) and x < 0 then
        return
    end
    -- if self.totalgragenum == 0 or self.totalgragenum == 1 then
    --     return
    -- end
    local listCurX = self.garagelist:getContentOffset().x
    local tempnum = listCurX + x
    self.garagelist:setContentOffsetInDuration(cc.p(tempnum,0),0)
end
function MainView:updateNode( x )
    self.type = false
    if x <= 0 then--往左滑动
        if self.garageflag == math.ceil(self.totalgragenum/6) then
            self.type = true
            return
        end
        if math.abs(x) > 200 then
            self.garageflag = self.garageflag + 1
        end
        local callback1 = function (  )
             self.garagelist:setContentOffsetInDuration(cc.p((1-self.garageflag)*900,0),0.400)
        end
        local actionByBack = function ( )
            self.type = true
        end
        local action = cc.DelayTime:create(0.4)
        self:runAction( cc.Sequence:create(cc.CallFunc:create(callback1),action, cc.CallFunc:create(actionByBack)));
    else
        if self.garageflag == 1 then
            self.type = true
            return
        end
          if math.abs(x) > 200 then
            self.garageflag = self.garageflag - 1
        end
        local callback1 = function (  )
            self.garagelist:setContentOffsetInDuration(cc.p((1-self.garageflag)*900,0),0.400)
        end
        local actionByBack = function ( )
            self.type = true
        end
        local action = cc.DelayTime:create(0.4)
        self:runAction( cc.Sequence:create(cc.CallFunc:create(callback1),action, cc.CallFunc:create(actionByBack)));
    end
    self:updategaragenum()
end
function MainView:updategaragenum(  )
    if self.garageflag == 1 then
        self.leftBt:setVisible(false)
    else
        self.leftBt:setVisible(true)
    end
    if self.garageflag == math.ceil(self.totalgragenum/6) then
        self.rightBt:setVisible(false)
    else
        self.rightBt:setVisible(true)
    end
    if self.totalgragenum == 0 then
         self.totalnum:setString("第0/0页")
         self.leftBt:setVisible(false)
         self.rightBt:setVisible(false)
    else
        self.totalnum:setString("第"..self.garageflag.."/"..math.ceil(self.totalgragenum/6).."页")
    end
end
function MainView:updatepannel3( index )
    -- body
    local data = model.localmedalcfg
    local shuxingdata = model.medalattribute
    self.miaoshu1:setString("("..data[tostring(index)].group1_desc..")")
    self.miaoshu2:setString("("..data[tostring(index)].group2_desc..")")
    self.miaoshu3:setString("("..data[tostring(index)].group3_desc..")")
    self.yizhi1:setString(data[tostring(index)].name1)
    self.yizhi2:setString(data[tostring(index)].name2)
    self.yizhi3:setString(data[tostring(index)].name3)
    local id = data[tostring(index)].id
    for i=7,12 do
        self["medal_item"]:loadTexture("medal/res/medal_"..id..".jpg",1)
    end
    local style = data[tostring(index)].medal_colour + 1
    local style1 = data[tostring(index)].medal_colour + 1
    if style1 > 6 then
        style1 = 6
    end
    local list  = {}
    for k,v in pairs(shuxingdata) do
        if v.colour_id == (style) then
            table.insert(list,v)
        end
    end
    table.sort(list,function(a,b)
          return a.attribute<b.attribute
    end)
    -- print("图鉴1111111111",json.encode(list))
    local color = qy.tank.utils.ColorMapUtil.qualityMapColorFor3b(style1)
    local ii = 1
    for i=1,7 do
        self["tujian"..i]:setColor(color)
        local totalnum = (list[i].max + list[i].full + list[i].total_full) * 6
        if list[i].attribute < 6 then
            self["tujian"..i]:setString("·"..model.tujianTypeNameList[tostring(list[i].attribute)]..":+"..totalnum)
        else
            local tempnum = totalnum/10
            self["tujian"..i]:setString("·"..model.tujianTypeNameList[tostring(list[i].attribute)]..":+"..tempnum.."%")
        end
    end
    self:__showEffert(self.texiao)

end
function MainView:updateexplain( id ,type1)
    local flag = 0
    local totalnum1 = 0
    local totalnum2 = 0
    for i=1,#self.explainlist do
        if self.explainlist[i] == id then
            flag = 1
            if type1 then
                table.remove(self.explainlist, i)
                break
            end
        end
    end
    if flag == 0 then
        table.insert(self.explainlist,id)
    end
    -- print("分解的id",json.encode(self.explainlist))
    local list = model.explainlist--分解的id
    local localrevise = model.localrevise--本地消耗表
    local medallist = model.medalcfg
    for i=1,#self.explainlist do
        local num = self.explainlist[i]
        totalnum1 = list[num].af + totalnum1
        totalnum2 = list[num].ex + totalnum2
        local medal_id = list[num].medal_id
        local qulity = medallist[medal_id..""].medal_colour
        local decompose = localrevise[qulity..""].decompose
        for i=1,#decompose do
            if decompose[i].type == 42 then
                 totalnum1 =  totalnum1 + decompose[i].num
            else
                totalnum2 =  totalnum2 + decompose[i].num
            end
        end
    end
    self.fenjienum1 = totalnum1
    self.fenjienum2 = totalnum2
    self.num1:setString(totalnum1)
    self.num2:setString(totalnum2)
end
function MainView:createView()
    local tableView = cc.TableView:create(cc.size(255, 485))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(3, 5)
    tableView:setDelegate()

    self.tanks = {}

    local function numberOfCellsInTableView(tableView)
        return #garageModel.formation
    end

    local function cellSizeForTable(tableView,idx)
        return 255, 175
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        local item1 = nil
        print("-------------ppp",idx)
        self.selectTankdata[idx..""] = garageModel.formation[idx+1]
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.garage.GarageTankCell.new(garageModel.formation[idx+1], idx + 1,true)
            item:setPosition(cc.p(20,45))
            cell:addChild(item,2)
            cell.item = item
            
            if idx == self.choosetank then
                print("第几个啊",self.choosetank)
                cell.item.light:setVisible(true)
                self.selectTank = cell
                self:updatepannel1(true)
            end
            table.insert(self.tanks, cell)
        end
        -- item1 =  require("medal.src.TanklistBg").new()
        -- item1:render(idx + 1,garageModel.formation[idx+1])
        -- cell:addChild(item1,-1)
      
        cell.item:render(garageModel.formation[idx+1], idx+1)
        cell.item.entity = garageModel.formation[idx+1]
        cell.idx = idx + 1
        return cell
    end

    local function tableAtTouched(table, cell)
        if type(cell.item.entity) == "table" then
            for i, v in pairs(self.tanks) do
                v.item.light:setVisible(false)
            end
            print("已经改变了啊1",self.choosetank)
            cell.item.light:setVisible(true)
            self.choosetank = cell.idx - 1
            print("已经改变了啊2",self.choosetank)
            self.selectTank = cell
            self:updatepannel1(true)
        elseif cell.item.entity == 0 then
            qy.tank.command.GarageCommand:showUnselectedTankListDialog(false,function(uid)
                local service = qy.tank.service.GarageService
                service:lineup(1,1,"p_"..cell.idx,uid,function()
                    self.choosetank = cell.idx - 1
                    qy.Event.dispatch(qy.Event.LINEUP_SUCCESS)
                    qy.tank.command.GarageCommand:hideTankListDialog()
                end)
            end)
        elseif cell.item.entity == -1 then
            qy.hint:show(qy.TextUtil:substitute(66012),0.5)
        end
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:registerScriptHandler(tableAtTouched,cc.TABLECELL_TOUCHED)

    tableView:reloadData()

    self.tankViewList = tableView

    return tableView
end
function MainView:createView2()
    local tableView = cc.TableView:create(cc.size(255, 485))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(3, 5)
    tableView:setDelegate()

    local function numberOfCellsInTableView(tableView)
        return #garageModel.formation
    end

    local function cellSizeForTable(tableView,idx)
        return 255, 175
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        cell = cc.TableViewCell:new()
        item =  require("medal.src.TanklistBg").new()
        cell.item = item
        item:render(idx + 1,garageModel.formation[idx+1])
        cell:addChild(item,-1)

        cell.idx = idx + 1
        return cell
    end

    local function tableAtTouched(table, cell)
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:registerScriptHandler(tableAtTouched,cc.TABLECELL_TOUCHED)

    tableView:reloadData()

    return tableView
end
function MainView:createmedalView()
    local tableView = cc.TableView:create(cc.size(260, 480))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(0,0)
    tableView:setDelegate()
    -- print("ssssssssssss",table.nums(model.localmedalcfg))
    local num = table.nums(model.localmedalcfg)
    local function numberOfCellsInTableView(table)
        return num
    end

    local function tableCellTouched(table,cell)
    end

    local function cellSizeForTable(tableView, idx)
        return 260, 90
    end

    local function tableCellAtIndex(table, idx)
        local cell = table:dequeueCell()
        local item
        if nil == cell then
            cell = cc.TableViewCell:new()
            item =  require("medal.src.MedalCell").new({
                ["callback"] = function ( ii )
                    if self.tujianflag ~= ii then
                        self:updatepannel3(ii)
                        self.tujianflag = ii
                        print("dddddddddddd",ii)
                        local listCury = self.modelslist:getContentOffset()
                        self.medallist:removeAllChildren()
                        self.modelslist = self:createmedalView()
                        self.medallist:addChild(self.modelslist)
                        self.modelslist:setContentOffset(listCury)--设置滚动距离
                    end
                end
                })
            cell:addChild(item)
            cell.item = item
        end
        cell.item.idx = idx
        cell.item:render(idx+1,self.tujianflag)
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:reloadData()
    return tableView
end
function MainView:creategrageView(types,list)--types = 1 仓库，都显示， types = 2 分解，只显示未分解的 type = 3 要装备
    local tableView = cc.TableView:create(cc.size(900, 420))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(10,5)
    tableView:setTouchEnabled(false)
    tableView:setDelegate()
    local tempnum = #list--总数
    print("list--总数",tempnum)
    print("sss",types)
    local function numberOfCellsInTableView(table)
        return  math.ceil(tempnum/6)
    end

    local function tableCellTouched(table,cell)
    end

    local function cellSizeForTable(tableView, idx)
        return 900, 420
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item
        if nil == cell then
            cell = cc.TableViewCell:new()
            item =  require("medal.src.GarageCell").new({
                ["totalnum"] = math.ceil(tempnum/6),
                ["type"] = types,
                ["self1"] = self,
                ["callback"] = function ( id )
                    self:updatepannel1ByPosition(id)
                end,
                ["callback2"] = function ( id )
                    -- 分解id
                    print("========",id)
                    self:updateexplain(id,true)--刷新
                end,
                ["explainlist"] = self.explainlist,
                ["data"] = list,
                ["callback_c"] = function ( datas ,ttype)
                    if ttype == 2 then
                    else
                    self.closeflag = -2
                    end
                    self.pannel2:setVisible(false)
                    local nodes =  require("medal.src.RecastView").new({
                        ["data"] = datas,
                        ["callback"] = function (  )
                            self:updateziyuan()
                        end
                    })
                    self:addChild(nodes,999,999)
                end,
                ["callback_j"] = function ( data ,ttype)
                    if ttype == 2 then
                    else
                    self.closeflag = -2
                    end
                    self.pannel2:setVisible(false)
                        local nodes =  require("medal.src.CastingView").new({
                        ["data"] = data,
                        ["callback"] = function (  )
                            self:updateziyuan()
                        end
                    })
                    self:addChild(nodes,999,999)
                end
                })
            cell:addChild(item)
            cell.item = item
        end
        cell.item.idx = idx
        cell.item:render(idx+1,tempnum%6)
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:reloadData()
    tableView:setContentOffset(cc.p((1 - self.garageflag)*900,0))
    return tableView
end
function MainView:onEnter()
    cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/common/item/common_item.plist")
    self.listener_2 = qy.Event.add(qy.Event.XUNZHANG,function(event)
        print("走了一次，，，，，，")
        self:updateshuxing()
    end)
    self.listener_1 = qy.Event.add(qy.Event.LINEUP_SUCCESS,function(event)
        local listCury = self.tanklistbg:getContentOffset()
        if self.tanklist:getChildByTag(666) then
            self.tanklist:removeChildByTag(666,true)
        end
        self.tanklistbg = self:createView2()
        self.tanklist:addChild(self.tanklistbg,666,666)
        self.tanklistbg:setContentOffset(listCury)--设置滚动距离
        local listCury = self.tanklistbg:getContentOffset()
        if self.tanklist:getChildByTag(667) then
            self.tanklist:removeChildByTag(667,true)
        end
        self.tanklists = self:createView()
        self.tanklist:addChild(self.tanklists,667,667)
        self.tanklists:setContentOffset(listCury)--设置滚动距离
        -- self:updatepannel1(true)
    end)
    self.listener = cc.EventListenerTouchOneByOne:create()
  
    local function onTouchBegan(touch, event)
        self.touchPoint1 = touch:getLocation()
        self.touchPoint4 = touch:getLocation()
        -- print("点击圈",self.touchPoint1.x)
        -- print(self.touchPoint1.y)
        if  self.type == true and self.touchPoint1.x>90 and self.touchPoint1.x < 1000 and self.touchPoint1.y > 130 and self.touchPoint1.y < 540 then
            return true
        else
            return false
        end
        
    end

    local function onTouchMoved(touch, event)
        self.touchPoint2 = touch:getLocation()

        self:RollNode(self.touchPoint2.x - self.touchPoint1.x)
            self.touchPoint1 = self.touchPoint2
        end

    local function onTouchEnded(touch, event)
        self.touchPoint3 = touch:getLocation()
        -- if math.abs(self.touchPoint1.y - touch:getLocation().y)>=5 then
            self:updateNode(self.touchPoint3.x - self.touchPoint4.x)
        -- end
    end

    self.listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN)
    self.listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED)
    self.listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED)
    self.eventDispatcher = self:getEventDispatcher()
    self.eventDispatcher:addEventListenerWithSceneGraphPriority(self.listener,self.node1)
end

function MainView:Update()

end
function MainView:onExit()
    qy.Event.remove(self.listener_2)
    self.listener_2 = nil
end


return MainView
