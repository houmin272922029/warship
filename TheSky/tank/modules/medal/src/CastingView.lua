
--精铸pannel
local CastingView = qy.class("CastingView", qy.tank.view.BaseView, "medal/ui/CastingView")

local service = qy.tank.service.MedalService
local garageModel = qy.tank.model.GarageModel
local  model = qy.tank.model.MedalModel
local StorageModel = qy.tank.model.StorageModel
local userInfoModel = qy.tank.model.UserInfoModel

function CastingView:ctor(delegate)
    CastingView.super.ctor(self)
    self.delegate = delegate
    qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync(qy.ResConfig.XUNZHANG_KUANG)

    for i=1,2 do
        self:InjectView("j_item"..i)
        self:InjectView("j_name"..i)--勋章名字
        self:InjectView("j_fram"..i)
    end
       for i=1,3 do
        self:InjectView("j_shuxing"..i)
        self:InjectView("j_extra"..i)
        self:InjectView("j_box"..i)--锁定
        self:InjectView("j_boxchild"..i)--锁定
        self:InjectView("j_xinlist"..i)
        self:InjectView("j_x_shuxing"..i)
        self:InjectView("j_x_extra"..i)
    end
    self:InjectView("j_jihuo2")--未激活字
    self:InjectView("j_jihuo3")--未激活字
    self:InjectView('jingzhunum')--cishu
    self:InjectView("j_jingzhuBt")
    self:InjectView("j_jingzhutenBt")
    self:InjectView("xiaohaonum1")
    self:InjectView("xiaohaonum2")
    self:InjectView("xiaohaonum3")
    self:InjectView("xiaohaonum4")
    self:InjectView("fangda1")
    self:InjectView("fangda2")
    self:OnClick("fangda1",function ( sender )
        local node = require("medal.src.FuDongTip").new({
            ["data"] = self.data,
            ["type"] = 1
            })
            node:show()
    end)
    self:OnClick("fangda2",function ( sender )
        if self.newdata.attr  then
            local node = require("medal.src.FuDongTip").new({
            ["data"] = self.newdata,
            ["type"] = 1
            })
            node:show()
        else
            qy.hint:show("请精铸后查看")
            return
        end
    end)
    self:OnClick1("j_jingzhuBt",function ( sender )
        if self.j_boxflag == -1 then
            qy.hint:show("请勾选要精铸的属性")
            return
        end
        local num = self.j_boxflag + 1
        -- if self["tag"..num] == 1 then
        --     qy.hint:show("该条属性已满，不能精铸")
        --     return
        -- end
        local lock = {}
        table.insert(lock,self.j_boxflag)
        print("lock",json.encode(lock))
        self:EliteAttr(lock)
    end)
    self:OnClick1("j_jingzhutenBt",function ( sender )
        if self.tenflag == 1 then
            if self.j_boxflag == -1 then
                qy.hint:show("请勾选要精铸的属性")
                return
            end
            local lock = {}
            table.insert(lock,self.j_boxflag)
            service:ElitetenAttr(self.data.unique_id,lock,function ( datas )
                self.tenflag = 0
                local data = datas.medal
                self.baocunflag = true
                local list = {}
                for k,v in pairs(data) do
                    table.insert(list,v)
                end
                if self.newdata.attr  then
                    self.data =  self.newdata
                end
                qy.Event.dispatch(qy.Event.XUNZHANG)
                qy.QYPlaySound.playEffect(qy.SoundType.TANK_UPGRADE)
                self.newdata = list[1]
                self.delegate:callback()
                self:showEff1(lock)
                self:update()
                self:updatenum1(self.j_boxflag+ 1)
                if model.chonghzutype == 0 then
                    qy.tank.utils.Timer.new(0.8,1,function()
                        require("medal.src.ResultTip").new({
                            ["data"] = datas,
                            ["callback"] = function (  )
                               self.tenflag = 1
                            end
                        }):show()
                    end):start()
                else
                    self.tenflag = 1
                end
              
            end)
        end
    end)
    self:OnClickForBuilding1("j_box1",function ( sender )
        if self.j_boxflag ~= 0 then
            if tonumber(self.color["1"]) < 4 then
                qy.hint:show("紫色及以上属性品质可精铸")
                return
            end
            self.j_boxchild1:setVisible(true)
            self.j_boxchild2:setVisible(false)
            self.j_boxchild3:setVisible(false)
            self.j_boxflag = 0
            self:updatenum(1)
        end
    end)
    self:OnClickForBuilding1("j_box2",function ( sender )
         if self.j_boxflag ~= 1 then
             if tonumber(self.color["2"]) < 4 then
                qy.hint:show("紫色及以上属性品质可精铸")
                return
            end
            self.j_boxchild1:setVisible(false)
            self.j_boxchild2:setVisible(true)
            self.j_boxchild3:setVisible(false)
            self.j_boxflag = 1
            self:updatenum(2)
        end
    end)
    self:OnClickForBuilding1("j_box3",function ( sender )
        if self.j_boxflag ~= 2 then
            if tonumber(self.color["3"]) < 4 then
                qy.hint:show("紫色及以上属性品质可精铸")
                return
            end
            self.j_boxchild1:setVisible(false)
            self.j_boxchild2:setVisible(false)
            self.j_boxchild3:setVisible(true)
            self.j_boxflag = 2
            self:updatenum(3)
        end
    end)
    self.data = delegate.data
    self.newdata = {}
    self.j_boxflag = -1--精炼默认进来勾选值
    self.color = {
        ["1"] = 0,
        ["2"] = 0,
        ["3"] = 0
    }
    self.tag1 = 0
    self.tag2 = 0
    self.tag3 = 0
    self.tenflag = 1
    self.xiaohaonum1:setString("0")
    self.xiaohaonum2:setString("0")
    self.xiaohaonum3:setString("0")
    self.xiaohaonum4:setString("0")
    self:update()

    -- self:updatenum()
end
function CastingView:EliteAttr( lock )
    local functions = function (  )
            service:EliteAttr(self.data.unique_id,lock,function ( data )
            self.baocunflag = true
            local list = {}
            for k,v in pairs(data) do
                table.insert(list,v)
            end
            if self.newdata.attr  then
                self.data =  self.newdata
            end
            qy.Event.dispatch(qy.Event.XUNZHANG)
            qy.QYPlaySound.playEffect(qy.SoundType.TANK_UPGRADE)
            self.newdata = list[1]
            self.delegate:callback()
            self:showEff1(lock)
            self:update()
            self:updatenum1(self.j_boxflag+ 1)
        end)
    end
    if userInfoModel.userInfoEntity.afliquid < self.totalnum1 or userInfoModel.userInfoEntity.exliquid < self.totalnum2 then
        local function callBack(flag)
            if flag == qy.TextUtil:substitute(4012) then
                self:runAction(cc.CallFunc:create(functions))
            else
                qy.QYPlaySound.playEffect(qy.SoundType.COMMON_CLICK)
            end
        end
        local image = ccui.ImageView:create()
        image:setContentSize(cc.size(500,120))
        image:setScale9Enabled(true)
        image:loadTexture("Resources/common/bg/c_12.png")

        local image1 = ccui.ImageView:create()
        image1:loadTexture("Resources/common/icon/coin/1a.png")
        image1:setPosition(cc.p(265,60))
        image:addChild(image1)

        local richTxt = ccui.RichText:create()
        richTxt:ignoreContentAdaptWithSize(false)
        richTxt:setContentSize(500, 150)
        richTxt:setAnchorPoint(0,0.5)
        local tempnum = 0
        if userInfoModel.userInfoEntity.afliquid < self.totalnum1 then
            tempnum = self.totalnum1 - userInfoModel.userInfoEntity.afliquid
        end
        if userInfoModel.userInfoEntity.exliquid < self.totalnum2 then
            tempnum = tempnum + (self.totalnum2 - userInfoModel.userInfoEntity.exliquid ) * 2
        end
        local stringTxt1 = ccui.RichElementText:create(1, cc.c3b(255,255,255), 255, "所需资源不足,确定花费      ", qy.res.FONT_NAME_2, 24)
        richTxt:pushBackElement(stringTxt1)
        local stringTxt2 = ccui.RichElementText:create(1, cc.c3b(255, 165, 0), 255, tempnum, qy.res.FONT_NAME_2, 24)
        richTxt:pushBackElement(stringTxt2)
        local stringTxt3 = ccui.RichElementText:create(1, cc.c3b(255,255,255), 255, "继续精铸吗？", qy.res.FONT_NAME_2, 24)
        richTxt:pushBackElement(stringTxt3)
        image:addChild(richTxt)

        qy.alert1:showWithNode(qy.TextUtil:substitute(9004),  image, cc.size(560,250), {{qy.TextUtil:substitute(4011) , 4},{qy.TextUtil:substitute(4012) , 5} }, callBack, {})
        image:setPosition(image:getPositionX() + 5, image:getPositionY() - 30)
    else
        self:runAction(cc.CallFunc:create(functions))
    end
   
end
function CastingView:EliteAttrTen( lock )
    local functions = function (  )
            service:EliteAttr(self.data.unique_id,lock,function ( data )
            self.baocunflag = true
            local list = {}
            for k,v in pairs(data) do
                table.insert(list,v)
            end
            if self.newdata.attr  then
                self.data =  self.newdata
            end
            qy.Event.dispatch(qy.Event.XUNZHANG)
            print("精铸了啊")
            qy.QYPlaySound.playEffect(qy.SoundType.TANK_UPGRADE)
            self.newdata = list[1]
            self.delegate:callback()
            self:showEff1(lock)
            self:update()
            self:updatenum1(self.j_boxflag+ 1)
        end)
    end
    if userInfoModel.userInfoEntity.afliquid < self.totalnum1 or userInfoModel.userInfoEntity.exliquid < self.totalnum2 then
        print("资源不足")
        local function callBack(flag)
            if flag == qy.TextUtil:substitute(4012) then
                self:runAction(cc.CallFunc:create(functions))
            else
                qy.QYPlaySound.playEffect(qy.SoundType.COMMON_CLICK)
            end
        end
        local image = ccui.ImageView:create()
        image:setContentSize(cc.size(500,120))
        image:setScale9Enabled(true)
        image:loadTexture("Resources/common/bg/c_12.png")

        local image1 = ccui.ImageView:create()
        image1:loadTexture("Resources/common/icon/coin/1a.png")
        image1:setPosition(cc.p(265,60))
        image:addChild(image1)

        local richTxt = ccui.RichText:create()
        richTxt:ignoreContentAdaptWithSize(false)
        richTxt:setContentSize(500, 150)
        richTxt:setAnchorPoint(0,0.5)
        local tempnum = 0
        if userInfoModel.userInfoEntity.afliquid < self.totalnum1 then
            tempnum = self.totalnum1 - userInfoModel.userInfoEntity.afliquid
        end
        if userInfoModel.userInfoEntity.exliquid < self.totalnum2 then
            tempnum = tempnum + (self.totalnum2 - userInfoModel.userInfoEntity.exliquid ) * 2
        end
        local stringTxt1 = ccui.RichElementText:create(1, cc.c3b(255,255,255), 255, "所需资源不足,确定花费      ", qy.res.FONT_NAME_2, 24)
        richTxt:pushBackElement(stringTxt1)
        local stringTxt2 = ccui.RichElementText:create(1, cc.c3b(255, 165, 0), 255, tempnum, qy.res.FONT_NAME_2, 24)
        richTxt:pushBackElement(stringTxt2)
        local stringTxt3 = ccui.RichElementText:create(1, cc.c3b(255,255,255), 255, "继续精铸吗？", qy.res.FONT_NAME_2, 24)
        richTxt:pushBackElement(stringTxt3)
        image:addChild(richTxt)

        qy.alert1:showWithNode(qy.TextUtil:substitute(9004),  image, cc.size(560,250), {{qy.TextUtil:substitute(4011) , 4},{qy.TextUtil:substitute(4012) , 5} }, callBack, {})
        image:setPosition(image:getPositionX() + 5, image:getPositionY() - 30)
    else
        self:runAction(cc.CallFunc:create(functions))
    end
   
end
function CastingView:update(  )
    self.tag1 = 0
    self.tag2 = 0
    self.tag3 = 0
    if self.j_boxflag == -1 then
        self.j_boxchild1:setVisible(false)
        self.j_boxchild2:setVisible(false)
        self.j_boxchild3:setVisible(false)
    elseif self.j_boxflag == 0 then
        self.j_boxchild1:setVisible(true)
        self.j_boxchild2:setVisible(false)
        self.j_boxchild3:setVisible(false)
    elseif self.j_boxflag == 1 then
        self.j_boxchild1:setVisible(false)
        self.j_boxchild2:setVisible(true)
        self.j_boxchild3:setVisible(false)
    else
        self.j_boxchild1:setVisible(false)
        self.j_boxchild2:setVisible(false)
        self.j_boxchild3:setVisible(true)
    end
    local medal_id = self.data.medal_id--勋章id
    local medaldata = model.medalcfg[medal_id..""]
    local color = qy.tank.utils.ColorMapUtil.qualityMapColorFor3b(medaldata.medal_colour)
    for i=1,2 do
        self["j_name"..i]:setString(medaldata.name)
        self["j_name"..i]:setColor(color)
        self["j_item"..i]:loadTexture("res/medal/"..medaldata.foreign_id.."_0"..medaldata.position..".jpg")
        local png = "Resources/common/item/item_bg_"..medaldata.medal_colour..".png"
        self["j_fram"..i]:loadTexture(png,1)
    end
    local isfulllist2 = model:IsFull(self.data,1)
    local attr = self.data.attr
    local tempnum = 1
    if #attr == 1 then
        tempnum = 1 
        self["j_box1"]:setVisible(true)
        self["j_box2"]:setVisible(false)
        self["j_box3"]:setVisible(false)
    elseif #attr == 2 then
        tempnum = 2
        self["j_box1"]:setVisible(true)
        self["j_box2"]:setVisible(true)
        self["j_box3"]:setVisible(false)
    else
        tempnum = 3
        self["j_box1"]:setVisible(true)
        self["j_box2"]:setVisible(true)
        self["j_box3"]:setVisible(true)
    end
    for i=1,tempnum do
        self["j_shuxing"..i]:setVisible(true)
        self["j_extra"..i]:setVisible(true)
        if self["j_jihuo"..i] then
            self["j_jihuo"..i]:setVisible(false)
        end
    end
    for i=(tempnum+1),3 do
        self["j_shuxing"..i]:setVisible(false)
        self["j_extra"..i]:setVisible(false)
        if self["j_jihuo"..i] then
            self["j_jihuo"..i]:setVisible(true)
        end
    end
    for j=1,#attr do
        local id = attr[j].attr_id
        local medalattr = model.medalattribute[id..""]
        local attribute = medalattr.attribute--类型
        local color = medalattr.colour_id --颜色 
        if color > 6 then color = 6 end
        self.color[j..""] = color
        local color = qy.tank.utils.ColorMapUtil.qualityMapColorFor3b(color)
        self["j_shuxing"..j]:setColor(color)
        local  totalnum = attr[j].attr_val
       if isfulllist2["id"..j] == -1 then
            local tempnum1 = isfulllist2["min"..j]/10
            local tempnum2 = isfulllist2["max"..j]/10
            if attribute < 6 then
                self["j_extra"..j]:setString("("..isfulllist2["min"..j].."-"..isfulllist2["max"..j]..")")
            else
                self["j_extra"..j]:setString("("..tempnum1.."%-"..tempnum2.."%)")
            end
            self["j_extra"..j]:setString("")
            self["j_extra"..j]:setColor(cc.c3b(255,255,255))
        elseif isfulllist2["id"..j] == 1 then
            self["j_extra"..j]:setString("(满)")
            totalnum = totalnum + isfulllist2["num"..j]
            self["j_extra"..j]:setColor(cc.c3b(255,255,255))
        else
            totalnum = totalnum + isfulllist2["num"..j]
            self["j_extra"..j]:setString("(共鸣)")
            self["j_extra"..j]:setColor(color)
        end
        if attribute < 6 then
            self["j_shuxing"..j]:setString(model.tujianTypeNameList[tostring(attribute)]..":+"..totalnum)
        else
            local tempnum = totalnum/10
            self["j_shuxing"..j]:setString(model.tujianTypeNameList[tostring(attribute)]..":+"..tempnum.."%")
        end
    end
    if self.newdata.attr then
        self.mod_attr = self.newdata.attr
        local isfulllist = model:IsFull(self.newdata,1)
        if #self.mod_attr == 0 then
            for i=1,3 do
                self["j_xinlist"..i]:setVisible(false)
            end
        elseif #self.mod_attr == 1 then
            self["j_xinlist1"]:setVisible(true)
            self["j_xinlist2"]:setVisible(false)
            self["j_xinlist3"]:setVisible(false)
        elseif #self.mod_attr == 2 then
            self["j_xinlist1"]:setVisible(true)
            self["j_xinlist2"]:setVisible(true)
            self["j_xinlist3"]:setVisible(false)
        else
            for i=1,3 do
                self["j_xinlist"..i]:setVisible(true)
            end
        end
        for j=1,#self.mod_attr do
            local id = self.mod_attr[j].attr_id
            local medalattr = model.medalattribute[id..""]
            local attribute = medalattr.attribute--类型
            local color = medalattr.colour_id --颜色 
            if color > 6 then color = 6 end
            local color = qy.tank.utils.ColorMapUtil.qualityMapColorFor3b(color)
            self["j_x_shuxing"..j]:setColor(color)
            local  totalnum = self.mod_attr[j].attr_val
                     --判断属性满不满
            if isfulllist["id"..j] == -1 then
                local tempnum1 = isfulllist["min"..j]/10
                local tempnum2 = isfulllist["max"..j]/10
                if attribute < 6 then
                    self["j_x_extra"..j]:setString("("..isfulllist["min"..j].."-"..isfulllist["max"..j]..")")
                else
                    self["j_x_extra"..j]:setString("("..tempnum1.."%-"..tempnum2.."%)")
                end
                self["j_x_extra"..j]:setString("")
                self["j_x_extra"..j]:setColor(cc.c3b(255,255,255))
            elseif isfulllist["id"..j] == 1 then
                self["j_x_extra"..j]:setString("(满)")
                totalnum = totalnum + isfulllist["num"..j]
                self["j_x_extra"..j]:setColor(cc.c3b(255,255,255))
                self["tag"..j] = 1
            else
                totalnum = totalnum + isfulllist["num"..j]
                self["j_x_extra"..j]:setString("(共鸣)")
                self["j_x_extra"..j]:setColor(color)
                self["tag"..j] = 1
            end
            if attribute < 6 then
                self["j_x_shuxing"..j]:setString(model.tujianTypeNameList[tostring(attribute)]..":+"..totalnum)
            else
                local tempnum = totalnum/10
                self["j_x_shuxing"..j]:setString(model.tujianTypeNameList[tostring(attribute)]..":+"..tempnum.."%")
            end
        end
    else
        for i=1,3 do
            self["j_xinlist"..i]:setVisible(false)
        end
    end
end
function CastingView:showEff1( lock )
    local nums =lock[1] + 1
    if self["j_xinlist"..nums]:getChildByTag(699) then
        self["j_xinlist"..nums]:removeChildByTag(699,true)
    end
    local currentEffert = nil
    if currentEffert == nil then
        qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync("fx/".. qy.language .."/ui/ui_fx_shuaxinshuxing1",function()
            currentEffert = ccs.Armature:create("ui_fx_shuaxinshuxing1")
            currentEffert:setScaleX(0.91)
            self["j_xinlist"..nums]:addChild(currentEffert,699,699)
            local size = self["j_xinlist"..nums]:getContentSize()
            currentEffert:setPosition(size.width/2,size.height/2)
            currentEffert:getAnimation():playWithIndex(0)
        end)
        currentEffert:getAnimation():setMovementEventCallFunc(function(armatureBack,movementType,movementID)
            if movementType == ccs.MovementEventType.complete then
                currentEffert:removeFromParent()
            end
        end)

    end
end
function CastingView:updatenum( id )
    self.totalnum1 = 0
    self.totalnum2 = 0
    local list = model.explainlist--分解的id
    local localrevise = model.localrevise--本地消耗表
    local medallist = model.medalcfg
   
    -- local medal_id = self.data.medal_id
    -- local qulity = medallist[medal_id..""].medal_colour
    -- local precast_afliquid_cost = localrevise[qulity..""].precast_afliquid_cost
    -- local percast_exliquid_cost = localrevise[qulity..""].percast_exliquid_cost

    local id = self.data.attr[id].attr_id
    local medalattr = model.medalattribute[id..""]
    local attribute = medalattr.attribute--类型
    local color = medalattr.colour_id --颜色 
    local precast_afliquid_cost = localrevise[color..""].precast_afliquid_cost
    local percast_exliquid_cost = localrevise[color..""].percast_exliquid_cost
    self.totalnum1 = precast_afliquid_cost
    self.totalnum2 = percast_exliquid_cost
    self.xiaohaonum1:setString(self.totalnum1)
    self.xiaohaonum2:setString(self.totalnum2)
    self.xiaohaonum3:setString(self.totalnum1 * 10)
    self.xiaohaonum4:setString(self.totalnum2 * 10)
    if userInfoModel.userInfoEntity.afliquid < self.totalnum1 then
        self.xiaohaonum1:setColor( cc.c3b(251, 48, 0))
    else
        self.xiaohaonum1:setColor( cc.c3b(255, 255, 255))
    end
    if userInfoModel.userInfoEntity.exliquid < self.totalnum2 then
        self.xiaohaonum2:setColor( cc.c3b(251, 48, 0))
    else
        self.xiaohaonum2:setColor( cc.c3b(255, 255, 255))
    end

    if userInfoModel.userInfoEntity.afliquid < self.totalnum1*10 then
        self.xiaohaonum3:setColor( cc.c3b(251, 48, 0))
    else
        self.xiaohaonum3:setColor( cc.c3b(255, 255, 255))
    end
    if userInfoModel.userInfoEntity.exliquid < self.totalnum2*10 then
        self.xiaohaonum4:setColor( cc.c3b(251, 48, 0))
    else
        self.xiaohaonum4:setColor( cc.c3b(255, 255, 255))
    end
  
end
function CastingView:updatenum1( id )
    self.totalnum1 = 0
    self.totalnum2 = 0
    local list = model.explainlist--分解的id
    local localrevise = model.localrevise--本地消耗表
    local medallist = model.medalcfg
   
    -- local medal_id = self.data.medal_id
    -- local qulity = medallist[medal_id..""].medal_colour
    -- local precast_afliquid_cost = localrevise[qulity..""].precast_afliquid_cost
    -- local percast_exliquid_cost = localrevise[qulity..""].percast_exliquid_cost

    local id = self.newdata.attr[id].attr_id
    local medalattr = model.medalattribute[id..""]
    local attribute = medalattr.attribute--类型
    local color = medalattr.colour_id --颜色 
    local precast_afliquid_cost = localrevise[color..""].precast_afliquid_cost
    local percast_exliquid_cost = localrevise[color..""].percast_exliquid_cost
    self.totalnum1 = precast_afliquid_cost
    self.totalnum2 = percast_exliquid_cost
    self.xiaohaonum1:setString(self.totalnum1)
    self.xiaohaonum2:setString(self.totalnum2)
    self.xiaohaonum3:setString(self.totalnum1 * 10)
    self.xiaohaonum4:setString(self.totalnum2 * 10)
    if userInfoModel.userInfoEntity.afliquid < self.totalnum1 then
        self.xiaohaonum1:setColor( cc.c3b(251, 48, 0))
    else
        self.xiaohaonum1:setColor( cc.c3b(255, 255, 255))
    end
    if userInfoModel.userInfoEntity.exliquid < self.totalnum2 then
        self.xiaohaonum2:setColor( cc.c3b(251, 48, 0))
    else
        self.xiaohaonum2:setColor( cc.c3b(255, 255, 255))
    end

    if userInfoModel.userInfoEntity.afliquid < self.totalnum1*10 then
        self.xiaohaonum3:setColor( cc.c3b(251, 48, 0))
    else
        self.xiaohaonum3:setColor( cc.c3b(255, 255, 255))
    end
    if userInfoModel.userInfoEntity.exliquid < self.totalnum2*10 then
        self.xiaohaonum4:setColor( cc.c3b(251, 48, 0))
    else
        self.xiaohaonum4:setColor( cc.c3b(255, 255, 255))
    end
  
end
function CastingView:onEnter()
    
end
function CastingView:onExit()
    
end


return CastingView
