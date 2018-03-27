--[[
    关卡主入口
]]
local ChapterView = qy.class("ChapterView", qy.tank.view.BaseView, "view/campaign/ChapterView")

local model = qy.tank.model.CampaignModel
local service = qy.tank.service.CampaignService
function ChapterView:ctor(delegate)
    ChapterView.super.ctor(self)
    print("-----ChapterView- ctor----" , os.time())
    self:InjectView("pageViewContainer")
    self:InjectView("closeBtn")
    self:InjectView("homeBtn")
    self:InjectView("toLeftArrBtn")
    self:InjectView("toRightArrBtn")
    for i = 1, 3 do
        self:InjectView("guide_target_" .. i)
    end

    self:InjectView("Button_off")
    self:InjectView("Button_on")
    self:InjectView("Image_16")
    self:InjectView("Image_17")

    self:refreshbtn()

    self:OnClick("Button_on",function (  )
        print("ChapterView-=-",self.currentPageIndex)
        service:getHardMainData(1,function(data)
            self.Image_16:setVisible(true)
            self.Image_17:runAction(cc.Sequence:create(cc.FadeTo:create(0.5, 220), cc.DelayTime:create(0.1), cc.CallFunc:create(function()


                self.Image_16:setSwallowTouches(true)
            end), cc.FadeTo:create(0.5, 0), cc.CallFunc:create(function()
                self.Image_16:setVisible(false)                    
            end))) 

            model:add_is_common()
            for i=1,20 do
                model:add_is_true(i)
            end
            self:refreshbtn()
            if tonumber(self.currentPageIndex + 1) == tonumber(data.hard_chapter.current) then
                self:scrollPage( self.currentPageIndex-1)
                --self:scrollPage( self.currentPageIndex+1)
                self.chapterSingleView:updateMap()
                qy.Event.dispatch(qy.Event.HARDATTACKTWO)
                self:scrollPage(data.hard_chapter.current - 1) 
            else
               self:scrollPage(data.hard_chapter.current - 1)
                self.chapterSingleView:updateMap()
                qy.Event.dispatch(qy.Event.HARDATTACKTWO) 
            end

            
        end)        
        
    end)

    self:OnClick("Button_off",function (  )        
        service:getMainData(1,function(data)
            self.Image_16:setVisible(true)
            self.Image_17:runAction(cc.Sequence:create(cc.FadeTo:create(0.5, 220), cc.DelayTime:create(0.1), cc.CallFunc:create(function()


                self.Image_16:setSwallowTouches(true)
            end), cc.FadeTo:create(0.5, 0), cc.CallFunc:create(function()
                self.Image_16:setVisible(false)                    
            end)))

            model:remove_is_common()
            for i=1,20 do
                model:remove_is_true(i)
            end
            self:refreshbtn()
            print("ChapterView-=-",data.chapter.current)
            
            self:scrollPage(data.chapter.current - 1)
            self.chapterSingleView:updateMap()
            qy.Event.dispatch(qy.Event.HARDATTACKTWO)
        end)
        
    end)

    self.openTip = qy.tank.view.campaign.ChapterOpenTip.new()

    self:addChild(self.openTip)

    self.delegate = delegate
    model.ChapterViewDelegate = delegate
    -- self.isInited = true
    -- self.canUpdate = false
    self.maxChapterNum = model:getChapterNums()
    self.chaptersUserData = model.chapterList
    self.maxPageIndex = table.nums(model.openChapterList)
    


    self:OnClick(self.closeBtn, function()
        model:remove_is_common()
        
        service:getMainDataNoLoding(1,function(data)
        
            model:remove_is_common()
            for i=1,20 do
                model:remove_is_true(i)
            end
            
            print("ChapterView-=-",data.chapter.current)
            
           
            qy.Event.dispatch(qy.Event.HARDATTACKTWO)
        end)
        self:clear()
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})

    self:OnClick(self.homeBtn, function()
        model:remove_is_common()
         for i=1,20 do
            model:remove_is_true(i)
        end
        self:clear()
        delegate.goHome()
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})

    self:OnClick(self.toLeftArrBtn, function()
        print("走了向左靠拢",self.currentPageIndex)
        local x = model:is_common()
        --if x then

            qy.QYPlaySound.playEffect(qy.SoundType.SWITCH_CHAPTER)
            self:scrollPage( self.currentPageIndex-1)
       -- else
         --   service:getHardMainData(nil,function ( data)
         --       self:scrollPage( self.currentPageIndex)
         --       qy.Event.dispatch(qy.Event.HARDATTACKTWO)
         --   end)
       -- end
    end, {["hasAudio"] = false})

    self:OnClick(self.toRightArrBtn, function()
        local arraylist = model.list
        local x = model:is_common()
        if x then
            print("右击普通")
            local btnEnabled = self.currentPageIndex < self.maxPageIndex - 1 and true  or  false
            if btnEnabled then
                qy.QYPlaySound.playEffect(qy.SoundType.SWITCH_CHAPTER)
                self:scrollPage( self.currentPageIndex+1)
            else
                qy.hint:show(qy.TextUtil:substitute(6005))
            end
        else
            --service:getHardMainData(nil,function (data)
                
                -- local btnEnabled = tonumber(self.currentPageIndex) < tonumber(data.hard_chapter.current-1)  and true  or  false
                -- if btnEnabled then
                --     qy.QYPlaySound.playEffect(qy.SoundType.SWITCH_CHAPTER)
                --     self:scrollPage( self.currentPageIndex+1)
                --     qy.Event.dispatch(qy.Event.HARDATTACKTWO)
                -- else
                --     qy.hint:show("下一章节未解锁")
                -- end
            --end)
            print("右击困难",self.maxPageIndex)--当前普通章节
            print("右击困难2",self.currentPageIndex)--当前页面id
            print("右击困难3",arraylist.current)--当前困难章节
            print("右击困难4",self.currentPageIndex)
            if arraylist.current < self.maxPageIndex then
                if self.currentPageIndex < arraylist.current - 1 then
                    self:scrollPage( self.currentPageIndex+1)
                else
                    qy.hint:show("下一章节未解锁")
                end
            else
                if self.currentPageIndex < arraylist.current - 2 then
                    self:scrollPage( self.currentPageIndex+1)
                else
                    qy.hint:show("下一章节未解锁")
                end
            end
            -- local btnEnabled = tonumber(self.currentPageIndex) < tonumber(arraylist.current-1)  and true  or  false
            -- if btnEnabled then
            --     qy.QYPlaySound.playEffect(qy.SoundType.SWITCH_CHAPTER)
            --     self:scrollPage( self.currentPageIndex+1)
            -- else
            --     qy.hint:show("下一章节未解锁")
            -- end

        end
    end, {["hasAudio"] = false})

    self:createPageView()

    -- self:updatePageView()
end

function ChapterView:onEnter()
    print("-----ChapterView- onEnter----" , os.time())
    -- qy.tank.utils.cache.CachePoolUtil.addArmatureFile("fx/ui/campaign/ui_fx_bihua")
    -- qy.tank.utils.cache.CachePoolUtil.addArmatureFile("fx/ui/campaign/ui_fx_kuangzi")
    -- qy.tank.utils.cache.CachePoolUtil.addArmatureFile("fx/ui/campaign/ui_fx_saodang")
    -- qy.tank.utils.cache.CachePoolUtil.addArmatureFile("fx/ui/campaign/ui_fx_tubiaojiang")
    -- qy.tank.utils.cache.CachePoolUtil.addArmatureFile("fx/ui/campaign/ui_fx_xiangziguang")
    -- qy.tank.utils.cache.CachePoolUtil.addArmatureFile("fx/ui/campaign/ui_fx_cqyan")
    -- qy.tank.utils.cache.CachePoolUtil.addArmatureFile("fx/ui/campaign/UI_fx_guankajiesuo")

--    local effect = ccs.Armature:create("UI_fx_guankajiesuo")
--    self:addChild(effect,999)
--    effect:setPosition(qy.winSize.width/2, qy.winSize.height/2)
--    effect:getAnimation():playWithIndex(0)
    self.listener_2 = qy.Event.add(qy.Event.HARDATTACKTWOTHREE,function(event)
        print("多大的")
            self:clear()
            self:updatePageView()
    end)
end

function ChapterView:onEnterFinish()
    print("-----ChapterView- onEnterFinish----" , os.time())
    self:updatePageView()
    --新手引导：注册控件
    qy.GuideCommand:addUiRegister({
        {["ui"] = self.guide_target_1,["step"] = {"SG_13","SG_39","SG_59","SG_67","SG_80","SG_105","SG_120"}},
        {["ui"]= self.guide_target_2,["step"] = {"SG_124"}}
    })

     qy.QYPlaySound.playMusic(qy.SoundType.CAMP_BG_MS)
end

function ChapterView:createSingleView(i)
     self.chapterSingleView = qy.tank.view.campaign.ChapterSingleView.new(self,
            {

                ["chapterUserData"] = self.chaptersUserData[tostring(i)],
                ["index"] = i,
                ["maxIndex"] =self.maxPageIndex,
            }
        )
        self.singleViewArr[i] = self.chapterSingleView
        local layout = ccui.Layout.new(self)

        layout:setPosition(0, 0)
        layout:setAnchorPoint(0, 0)
        layout:addChild(self.chapterSingleView)
        self.pageView:addPage(layout)
end

function ChapterView:createPageView()
    self.pageView = ccui.PageView:create()
    self.pageView:setContentSize(1280,720)
    self.pageViewContainer:addChild(self.pageView)
    self.pageView:setCustomScrollThreshold(100)
    self.singleViewArr = {}
    self.currentPageIndex = -1

    for i = 1, self.maxPageIndex do
        self:createSingleView(i)
    end

    function pageViewCallBack()
        if self.currentPageIndex == self.pageView:getCurPageIndex() then
            return
        end

        self.currentPageIndex = self.pageView:getCurPageIndex()

        if model.currentUserChapterId ~= self.currentPageIndex + 1 then
            self.singleViewArr[self.currentPageIndex + 1]:createChapterMap()
            self.singleViewArr[self.currentPageIndex + 1]:start()
            self:showOpenTip()
        end

        model.currentUserChapterId = self.currentPageIndex + 1
        self.toLeftArrBtn:setVisible(self.currentPageIndex > 0 and true  or  false)

        if self.currentPageIndex == table.nums(self.chaptersUserData) - 1 then
            self.toRightArrBtn:setVisible(false)
        else
            self.toRightArrBtn:setVisible(true)
            local btnEnabled = self.currentPageIndex < self.maxPageIndex - 1 and true  or  false
            self.toRightArrBtn:setBright(btnEnabled)
        end
    end

    self.pageView:addEventListener(pageViewCallBack)
end

function ChapterView:updatePageView()
    -- if self.canUpdate == nil or self.canUpdate==false then return end
    local x = model:is_common()
    if x then
        local newNum = table.nums(model.openChapterList)

        -- 有新章节开启时，需要先添加一个章节到 pageView 中，再跳到最新章节
        if self.maxPageIndex <  newNum then
            model.currentUserChapterId = newNum
            self:createSingleView(newNum)
            self.maxPageIndex = newNum
        end

         -- 当 model.currentUserChapterId 为，默认值时直接滚动到最新章节 否则滚动到指定章节
        if model.currentUserChapterId ~= -1 then
            self:scrollPage( model.currentUserChapterId - 1)
        else
            self:scrollPage( self.maxPageIndex - 1)
            self.currentPageIndex = self.maxPageIndex - 1
        end
    else
        self.maxhardPageIndex = model.hard_chapter_current
        local newNum = table.nums(model.openhardChapterList)
        -- 有新章节开启时，需要先添加一个章节到 pageView 中，再跳到最新章节
        if self.maxhardPageIndex <  newNum -1 then
            model.currentUserChapterId = newNum -1
            self:createSingleView(newNum -1)
            self.maxhardPageIndex = newNum -1
        end

         -- 当 model.currentUserChapterId 为，默认值时直接滚动到最新章节 否则滚动到指定章节
        if model.currentUserChapterId ~= -1  then
            if model.currentUserChapterId  < self.maxPageIndex -1 then
                service:getHardMainData(nil,function (data)
                    
                    local btnEnabled = tonumber(self.currentPageIndex) < tonumber(data.hard_chapter.current-1)  and true  or  false
                    if btnEnabled then
                        qy.QYPlaySound.playEffect(qy.SoundType.SWITCH_CHAPTER)
                        self:scrollPage( model.currentUserChapterId )
                        self.currentPageIndex = model.currentUserChapterId 
                        qy.Event.dispatch(qy.Event.HARDATTACKTWO)
                        self.toLeftArrBtn:setVisible(true)
                    else
                        
                    end
                end)
            else                
                service:getHardMainData(nil,function (data)
                    local btnEnabled = tonumber(self.currentPageIndex) < tonumber(data.hard_chapter.current-1)  and true  or  false
                    if btnEnabled then
                        qy.QYPlaySound.playEffect(qy.SoundType.SWITCH_CHAPTER)
                        --self:scrollPage( model.currentUserChapterId - 1)
                        self.currentPageIndex = model.currentUserChapterId 
                        qy.Event.dispatch(qy.Event.HARDATTACKTWO)
                        self.toLeftArrBtn:setVisible(true)
                    else
                        --qy.hint:show("打死你")
                    end
                end)
            end
            --self:scrollPage( model.currentUserChapterId - 1)
        else
            self:scrollPage( self.maxhardPageIndex - 1)
            self.currentPageIndex = self.maxhardPageIndex - 1
            qy.Event.dispatch(qy.Event.HARDATTACKTWO)
        end
    end
    self.singleViewArr[self.pageView:getCurPageIndex() + 1]:updateMap()

    -- 初始化的时候 pageView 回调中 会重复调用
    if model.userSceneCurrentId ~= -1  then
        self.singleViewArr[self.pageView:getCurPageIndex() + 1]:start()
    else
        model.userSceneCurrentId = model.sceneCurrentId
    end

    self:showOpenTip()
end

function  ChapterView:scrollPage(pageIndex)
    -- self:clearTip()
    -- self.singleViewArr[self.pageView:getCurPageIndex() + 1]:createChapterMap()
    self.pageView:scrollToPage(pageIndex)
end

function ChapterView:showOpenTip()
    -- self:clearTip()
    self.openTip:setVisible(true)
    local chapterId = self.pageView:getCurPageIndex() + 1
    self.openTip:update(chapterId)
    self.openTip:setOpacity(0)
    self.openTip:setAnchorPoint(0.5, 0.5)
    self.openTip:setPosition(qy.winSize.width / 2 , qy.winSize.height / 2 + 100)


    local fadeIn = cc.FadeIn:create(1)
    local delay = cc.DelayTime:create(1)
    local fadeOut = cc.FadeOut:create(1)
    local seq = cc.Sequence:create(fadeIn , delay , fadeOut ,cc.CallFunc:create(function()
        -- self:removeChild(self.openTip)
        -- self.openTip = nil
        self.openTip:setVisible(false)
    end))
    self.openTip:runAction(seq)
end

function ChapterView:clearTip(  )
   if self.openTip ~= nil then
        self.openTip:stopAllActions()
        self:removeChild(self.openTip)
        self.openTip = nil
    end
end

function ChapterView:clear()
    self:clearTip()

    for i = 1, #self.singleViewArr do
       self.singleViewArr[i]:clear()
    end
    self.singleViewArr = nil
    self.pageView:removeAllPages()
    self.pageView:cleanup()
    self.pageViewContainer:removeChild(self.pageView)
    self.pageView = nil

    -- findObjectInGlobal(self.delegate)
    qy.tank.model.CampaignModel.ChapterViewDelegate = nil
    -- findObjectInGlobal(self.delegate)

    -- self.closeBtn:cleanup()
    -- self.toLeftArrBtn:cleanup()
    -- self.toRightArrBtn:cleanup()
    self:removeAllChildren()
    self.delegate:dismiss()
    self.delegate = nil
end

function ChapterView:onExit()
    qy.Event.remove(self.listener_2)
    self.listener_2 = nil
    print("-----ChapterView- onExit----" , os.time())
    --新手引导：移除控件注册
    qy.GuideCommand:removeUiRegister({"SG_13","SG_39","SG_59","SG_67","SG_80","SG_105","SG_120", "SG_124"})
    -- qy.QYPlaySound.playMusic(qy.SoundType.M_W_BG_MS)
end

function ChapterView:onCleanup()
    print("-----ChapterView- onCleanup----" , os.time())
end

function ChapterView:refreshbtn()
    self.level = qy.tank.model.UserInfoModel.userInfoEntity.level
    if self.level < 60 then
        self.Button_off:setVisible(false)
        self.Button_on:setVisible(false)
    else
        local x = model:is_common()
        self.Button_off:setVisible(not x)
        self.Button_on:setVisible(x)
    end
    
end

return ChapterView
