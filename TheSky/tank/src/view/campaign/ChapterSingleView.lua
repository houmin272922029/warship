--[[
    章节view
]]
local ChapterSingleView = qy.class("ChapterSingleView", qy.tank.view.BaseView, "view/campaign/ChapterSingleView")
local model = qy.tank.model.CampaignModel
local service = qy.tank.service.CampaignService
function ChapterSingleView:ctor(ChapterV,delegate)
    print("ChapterSingleView987",delegate.chapterUserData.status)

    ChapterSingleView.super.ctor(self)
    print("-----ChapterSingleView- ctor----" , os.time())
    self:InjectView("chapterTitleBg")
    self:InjectView("chapter")
    -- self:InjectView("helpBtn")
    self:InjectView("chestOffBtn")
    self:InjectView("chestOnBtnNode")
    self:InjectView("chestOnBtn")
    self:InjectView("chestOpenBtn")
    self:InjectView("container")
    self:InjectView("Button_difficulty")
    self:InjectView("Button_common")--按钮为普通 点击跳转到普通
    self:InjectView("Image_16")
    self:InjectView("Image_17")
   
    self.chapterData = delegate.chapterUserData
    self:updateBtn()
    -- self.chapterConfig = delegate.chapterConfigData
    
    --设置章节名称
    -- self.chapterTitleTxt:setString(self.chapterData.name)
    self.chapter:setSpriteFrame("Resources/campaign/zj" .. delegate.chapterUserData.chapterId .. ".png")
   
    -- self:OnClick("helpBtn", function()
    --     qy.tank.view.common.HelpDialog.new(
    --         {
    --             ["title"] = "关卡帮助",   -- 帮助标题
    --             ["content"] = "这里是帮助内容\n这里是帮助内容\n这里是帮助内容\n这里是帮助内容\n这里是帮助内容\n这里是帮助内容\n这里是帮助内容\n这里是帮助内容\n这里是帮助内容\n这里是帮助内容\n这里是帮助内容\n",
    --             ["size"] = cc.size(750 , 200) -- 可滚动区域，因为只上下滚动，所以只需要改Y值即可
    --         }
    --     ):show(true)
    -- end)
    -- --TODO:由于帮助按钮美术资源没有到位，暂时隐藏帮助按钮，待资源到位后，再将其显示出来
    -- self.helpBtn:setVisible(false)
    
    self:OnClick("chestOffBtn", function()
       self:showChapterReward(self.chapterData)

    end)
    
    self:OnClick("chestOnBtn", function()
        self:showChapterReward(self.chapterData)

    end)
    
    self:OnClick("chestOpenBtn", function()
        self:showChapterReward(self.chapterData)

    end)
    
    --设定各个元件的位置
    self:resetPosition()
    self.chestEffect = ccs.Armature:create("ui_fx_xiangziguang") 
    self.chestOnBtnNode:addChild(self.chestEffect,999)
    self.chestEffect:setAnchorPoint(0.5,0.5)
    self.chestEffect:setPosition(0,0)
    -- self.chestAnimationContainer:setPosition(self.chestOnBtnNode:getPosition())
    
    self:createChapterMap()
    
end

function ChapterSingleView:showChapterReward(data)
    local arraylist = model.list
    if arraylist ~= nil and arraylist.list[tostring(self.chapterData.chapterId)] ~= nil then
           qy.tank.view.campaign.ChapterRewardDialog.new(
        {
            ["data"] = data,
            ["updateFunc"] = function()
                self.chapterData.isDrawAward = 1
                arraylist.list[tostring(self.chapterData.chapterId)].is_draw_award = 1
                self:updateChestStatus()
            end 
        }
    ):show(true)
           print("走的上边")
    else 
        print("走的xia边")
    qy.tank.view.campaign.ChapterRewardDialog.new(
        {
            ["data"] = data,
            ["updateFunc"] = function()
                self.chapterData.isDrawAward = 1
                self:updateChestStatus()
            end 
        }
    ):show(true)
    end
end

function ChapterSingleView:updateChestStatus()
    local is_true = model:is_common()
    print("ChapterSingleView---",is_true)
    self.chestOffBtn:setVisible(false)
    self.chestOnBtnNode:setVisible(false)
    self.chestOpenBtn:setVisible(false)
    local arraylist = model.list
    
    -- if self.chestEffect == nil then return end
    if is_true then
        print("普通箱子")
        self.chestEffect:setVisible(false)
        if tonumber(self.chapterData.status) == 1 then
            if self.chapterData.isDrawAward==1 then
                self.chestOpenBtn:setVisible(true)
            else 
                self.chestOnBtnNode:setVisible(true)
                self.chestEffect:setVisible(true)
                self.chestEffect:getAnimation():playWithIndex(0, 1, 1)
            end
        else
            self.chestOffBtn:setVisible(true)
        end
    else
        if arraylist.list[tostring(self.chapterData.chapterId)] ~= nil then
            self.chestEffect:setVisible(false)       
            if tonumber(arraylist.list[tostring(self.chapterData.chapterId)].status) == 1 then
                if arraylist.list[tostring(self.chapterData.chapterId)].is_draw_award == 1 then
                    print("困难箱子打开")
                    self.chestOpenBtn:setVisible(true)
                else 
                    print("困难箱子闪烁")
                    self.chestOnBtnNode:setVisible(true)
                    self.chestEffect:setVisible(true)
                    self.chestEffect:getAnimation():playWithIndex(0, 1, 1)
                end
            else
                self.chestOffBtn:setVisible(true)
                print("困难箱子关闭")
            end
        end    
    end
end

function ChapterSingleView:updateMap()
    self.ChapterMapRender:update()
    -- self:start()
end
--困难
function ChapterSingleView:updatebg(  )
    self.ChapterMapRender:updatebg()
end

--创建地图数据
function ChapterSingleView:createChapterMap()
    --if not self.ChapterMapRender then
        local chapterId = self.chapterData.chapterId
        self.ChapterMapRender = qy.tank.view.campaign.chapterMap.ChapterMapRender.new(
        {
                ["csdName"] = "ChapterMap"..chapterId,
                ["chapterId"] = chapterId
        }  
        )
        self:addChild(self.ChapterMapRender , -1)
    --end
    -- self.ChapterMapRender:setPosition(qy.winSize.width/2 , qy.winSize.height/2)
end

function ChapterSingleView:start()
    self.ChapterMapRender:startRunAnimaiton()
end

function ChapterSingleView:resetPosition()
    self.chestOffBtn:setPosition(self.chestOnBtnNode:getPosition())
    self.chestOpenBtn:setPosition(self.chestOnBtnNode:getPosition())
end

function ChapterSingleView:clear()
    -- self.ChapterMapRender:clear()

    -- self.chestOpenBtn:cleanup()
    -- self.chestOffBtn:cleanup()
    -- self.chestOnBtn:cleanup()
    
    -- self:removeChild(self.ChapterMapRender)
    -- self.ChapterMapRender = nil
    -- if self.chestEffect~=nil then
    --     self.chestEffect:getParent():removeChild(self.chestEffect)
    --     self.chestEffect = nil
    -- end
    
end

function ChapterSingleView:onEnter()
    self:updateChestStatus()
    --self:updatebg()
    --self:updateMap()
    self.listener_2 = qy.Event.add(qy.Event.HARDATTACKTWO,function(event)
        self:updatebg()
        self:updateChestStatus()
        self:updateMap()

    end)
end
function ChapterSingleView:onExit(  )
    qy.Event.remove(self.listener_2)
    self.listener_2 = nil
end

--困难模式
function ChapterSingleView:updateBtn( )
    local is_true = model:is_true(self.chapterData.chapterId)
        self.Button_difficulty:setVisible(false)
        self.Button_common:setVisible(false)
end

return ChapterSingleView