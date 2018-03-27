--[[--
    连充惊喜
--]]--


local MainDialog = qy.class("MainDialog", qy.tank.view.BaseDialog, "you_choose_me/ui/MainDialog")



function MainDialog:ctor(delegate)
    MainDialog.super.ctor(self)
    self.model = qy.tank.model.YouChooseMeModel
    self.service = qy.tank.service.YouChooseMeService

    cc.SpriteFrameCache:getInstance():addSpriteFrames("you_choose_me/res/Plist.plist")
    self:InjectView("Txt_time")
    self:InjectView("Btn_up")
    self:InjectView("Btn_Close")
    self:InjectView("Txt_propting")
    self:InjectView("Txt_propting2")
    self:InjectView("Img_picked")
    self:InjectView("Img_pick")
    self:InjectView("Img_ok")
    self:InjectView("Node_6")

    for i=1,5 do
        self:InjectView("Button_"..i)
        self:InjectView("Node_"..i)
    end
    self.selected_id = 0

    self:OnClick("Btn_Close",function (  )
        self:removeSelf()
    end)

    self:OnClick("Btn_up",function (  )
        
        local status = self.model.step
        print("按钮对应状态",status)
        if status == -1 then --已领取
            qy.hint:show("活动已经结束")
        elseif status == 0 then -- 隐藏

        elseif status == 1 then --确定
            print("选中id",self.selected_id)
            local idxx = self.model:change_about_gift_id(self.selected_id)
            print("选中id2",idxx)
            if self.selected_id ~= 0 then
                self.service:getAward(1,idxx,function (data)
                    self.model:changeStatus() -- 减一
                    self:setButtonStatus()
                    self:yingcang(false)
                    self.model:change_about_gift_id(self.selected_id)
                    self:setAward2()
                end)
            else
                qy.hint:show("请选择你想要的东西")
            end
        elseif status == 2 then -- 领取
            local id = self.model.about_gift_id
            print("领取物品id",id)
            self.service:getAward(2,id,function (data)
                if data.step ~= -1  then --平常跳转到状态1
                    self.model:changeStatus2()
                    self:setButtonStatus()
                    self:yingcang(true)
                    self:setAward()
                else --最后一天
                    self.model:changeStatus3()
                    self:setButtonStatus()

                end
            end)
        end
    end)
    
    for i=1,5 do
        self:OnClick("Button_"..i,function (  )
            self.selected_id = i
            self:setBianKuang(i)
        end)
    end
    
    local status = self.model.step
    if status == -1 then
        local about_gift_id = self.model.about_gift_id
        if about_gift_id ~= 0 then
            self:setAward2()
        end
        self:setAward()
        self.Img_ok:setVisible(true)
        self.Img_pick:setVisible(false)
        self.Img_picked:setVisible(false)
        self.Btn_up:setVisible(true)
        self.Txt_propting:setVisible(false)
        self.Txt_propting2:setVisible(false)
        self.Node_6:setVisible(false)
        --self:setButtonStatus()
    elseif status == 0 then
        self:setAward2()
        self:setButtonStatus()
    elseif status == 1 then
        self:setAward()
        self:setButtonStatus()
    elseif status == 2 then
        self:setAward2()
        self:setButtonStatus()
    end

    self:setTime()
    
end

function MainDialog:yingcang(data)
    for i=1,5 do
        self["Node_"..i]:setVisible(data)
    end
    self.Node_6:setVisible(not data)
end

function MainDialog:setAward()
    local award = self.model:getAward()
    for i=1,#award do
        local item = qy.tank.view.common.AwardItem.createAwardView(award[i].award[1] ,1)
        self["Node_"..i]:addChild(item)
        item:setScale(0.8)
        item.fatherSprite:setSwallowTouches(false)
        item.name:setVisible(false)
    end
end

function MainDialog:setAward2(  )
    local data = self.model:getAward2()
    local item = qy.tank.view.common.AwardItem.createAwardView(data.award[1] ,1)
    self.Node_6:addChild(item)
    item:setScale(0.8)
    item.fatherSprite:setSwallowTouches(false)
    item.name:setVisible(false)
end

function MainDialog:setButtonStatus()
    -- 1 未选择  0 隐藏  2 领取  -1 已领取
    local status = self.model.step
    self.Img_ok:setVisible(status == 1)
    self.Img_pick:setVisible(status == 2)
    self.Img_picked:setVisible(status == -1)
    self.Btn_up:setVisible(status ~= 0)
    self.Txt_propting:setVisible(status == 0)
    self.Txt_propting2:setVisible(status == 2)
    self.Node_6:setVisible(status ~= 1)
    for i=1,5 do
        self["Button_"..i]:setVisible(status == 1)
    end
end

function MainDialog:setBianKuang(id)
    if not self.effert then
        self.effert = ccs.Armature:create("Flame")
        self.effert:setScale(0.9)
        self["Node_"..id]:addChild(self.effert,999)
        self.effert:getAnimation():playWithIndex(0)
    else
        for i=1,5 do
            self["Node_"..i]:removeChild(self.effert)
        end
        
        self.effert = ccs.Armature:create("Flame")
        self.effert:setScale(0.9)
        self["Node_"..id]:addChild(self.effert,999)
        self.effert:getAnimation():playWithIndex(0)
    end
end

function MainDialog:setTime(  )
    --显示活动持续时间
    local startTime = os.date("%Y年%m月%d日",self.model.start_time)
    local endTime = os.date("%Y年%m月%d日",self.model.end_time)
    self.Txt_time:setString(startTime..qy.TextUtil:substitute(52003)..endTime)
end


function MainDialog:onExit()
end

function MainDialog:onEnter()
end





return MainDialog