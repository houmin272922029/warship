local AnotherawardDialog = qy.class("AnotherawardDialog", qy.tank.view.BaseDialog, "lucky_indiana.ui.AnotherawardDialog")

local service = qy.tank.service.OperatingActivitiesService
local model = qy.tank.model.OperatingActivitiesModel
local activity = qy.tank.view.type.ModuleType
function AnotherawardDialog:ctor(delegate)
   	AnotherawardDialog.super.ctor(self)
    
   	self:InjectView("queren")
   	self:InjectView("continiuBt")
   	self:InjectView("closeBt")
    self:InjectView("num")--个数
    self:InjectView("img")
    self:InjectView("img2")--左边按钮上的icon
    self:InjectView("bg")
    self:InjectView("img1")
 
    self:OnClick("closeBt", function()
        delegate.callback(false)
        self:removeSelf()
    end,{["isScale"] = false})

    self.flag = 1
    self:OnClick("queren", function()
        if self.flag == 1 then
            local str = ""--get_fussion_2_1
            if delegate.type == 1 then
                str = "get_fussion_2_"..delegate.index
            else
                str = "get_fission_1_"..delegate.index
            end
            service:getCommonGiftAward(0, qy.tank.view.type.ModuleType.LUCKY_INDIANA,false, function(data)
                self.flag = 2
                delegate.callback3()
                self.img:loadTexture("lucky_indiana/res/yilingqu.png",1)
            end,true,false,false,str)
          
        else
          delegate.callback(false)
          self:removeSelf()
        end
       
    end)
    self:OnClick("continiuBt", function()
      delegate.callback(false)
       delegate:callback2()
       self:removeSelf()
    end)
    local data = {}
    local types = 0
    local totlenum = 0
    if delegate.type == 1 then
        self.img2:setSpriteFrame("lucky_indiana/res/juan.png")
        data = model.fussionlist.list
        totlenum = model.fussionlist.times
        self.img1:setString("260买一个")
    else
        self.img2:setSpriteFrame("lucky_indiana/res/1a.png")
        data = model.fissionlist.list
        totlenum = model.fissionlist.times
        self.img1:setString("60买一个")
    end
    if data[tostring(delegate.index)].status == 0 then
        self.img:loadTexture("lucky_indiana/res/quwancheng.png",1)--去完成
        self.flag = 2
        types = 1
    elseif data[tostring(delegate.index)].status == 1 then
        self.img:loadTexture("lucky_indiana/res/lingqu.png",1)
        self.flag = 1
        types = 2
    else
        self.img:loadTexture("lucky_indiana/res/yilingqu.png",1)
        self.flag = 2
        types = 2
    end
    local chanum = delegate.data[tostring(delegate.index)].num - totlenum
    if chanum <= 0 then
        chanum = 0
    end
    local richTxt = ccui.RichText:create()
    richTxt:ignoreContentAdaptWithSize(false)
    richTxt:setContentSize(500, 30)
    richTxt:setAnchorPoint(0.5,0.5)
    local stringTxt1 = ccui.RichElementText:create(1, cc.c3b(255,255,255), 255,"您已累计购买", qy.res.FONT_NAME_2, 22)
    richTxt:pushBackElement(stringTxt1)
    local stringTxt2 = ccui.RichElementText:create(2, cc.c3b(255,165,0), 255, totlenum , qy.res.FONT_NAME_2, 22)
    richTxt:pushBackElement(stringTxt2)
    local stringTxt11 = ccui.RichElementText:create(1, cc.c3b(255,255,255), 255, "个",qy.res.FONT_NAME_2, 22)
    richTxt:pushBackElement(stringTxt11)
    if types == 1 then
        local stringTxt3 = ccui.RichElementText:create(3, cc.c3b(255,255,255), 255, ",再购买", qy.res.FONT_NAME_2, 22)
        richTxt:pushBackElement(stringTxt3)
        local stringTxt33 = ccui.RichElementText:create(2, cc.c3b(255,165,0), 255, chanum, qy.res.FONT_NAME_2, 22)
        richTxt:pushBackElement(stringTxt33)
        local stringTxt111 = ccui.RichElementText:create(1, cc.c3b(255,255,255), 255, "个即可领取以下奖励",qy.res.FONT_NAME_2, 22)
        richTxt:pushBackElement(stringTxt111)
        richTxt:setPosition(cc.p(320,260))
    else
        richTxt:setPosition(cc.p(480,260))
    end
    
    self.bg:addChild(richTxt)
    
    self.awardList = qy.AwardList.new({
        ["award"] = delegate.data[tostring(delegate.index)].award,
        ["cellSize"] = cc.size(120,80),
        ["type"] = delegate.data[tostring(delegate.index)].award.type,
        ["itemSize"] = 2,
        ["hasName"] = true,
        ["len"] = 5
    })
    self.awardList:setPosition(80,270)
    self.bg:addChild(self.awardList)
  
end



function AnotherawardDialog:onEnter()
   
    
end

function AnotherawardDialog:onExit()
   
  
end

return AnotherawardDialog
