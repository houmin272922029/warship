--[[
    章节奖励面板
]]
local ChapterRewardDialog = qy.class("ChapterRewardDialog", qy.tank.view.BaseDialog, "view/campaign/ChapterRewardView")
local model = qy.tank.model.CampaignModel
function ChapterRewardDialog:ctor(delegate)
    ChapterRewardDialog.super.ctor(self)

    self.awardCommand = qy.tank.command.AwardCommand
    -- 通用弹窗样式
    local style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(700,350),   
        position = cc.p(0,0),
        offset = cc.p(0,0), 
        bgOpacity = 200,
        titleUrl = "Resources/common/title/zhangjiejiangli.png",

        ["onClose"] = function()
            self:dismiss()
        end
    })
    self:addChild(style, -1)
    
    self:InjectView("getBtn")
    self:InjectView("hasGot")
    -- self:InjectView("canNotGet")
    self:InjectView("itemList")
    self.delegate = delegate
    self.chapterData = delegate.data
    self.updateFunc = delegate.updateFunc

    local is_true = model:is_common()
    
    self:OnClick(self.getBtn, function()
        if is_true then
            if tonumber(self.chapterData.status) == 1 then
                self:getAward()
            else
                qy.hint:show(qy.TextUtil:substitute(6004))
            end
        else
            local arraylist = model.list
            if tonumber(tonumber(arraylist.list[tostring(self.chapterData.chapterId)].status)) == 1 then
                self:getAward()
            else
                qy.hint:show("困难模式歼灭所有敌军")
            end
        end 
    end)

    --  self:OnClick(self.canNotGet, function()
    --     qy.hint:show("请歼灭该地区所有敌军！")
    -- end)
    
    --self.hasGot:setVisible(false)
    -- self.canNotGet:setVisible(false)

    --self.getBtn:setBright(tonumber(self.chapterData.status) == 1)
    
    -- if tonumber(self.chapterData.status) == 1 then
    --     if self.chapterData.isDrawAward==1 then
    --         self.hasGot:setVisible(true)
    --         self.getBtn:setVisible(false)
    --     else 
    --         self.getBtn:setVisible(true)
    --     end
    -- -- else
    -- --     self.canNotGet:setVisible(true)
    -- end
    --local champaignModel = qy.tank.model.CampaignModel
     local chapterAwardData = self.chapterData.award
    -- local awardItem
    -- local x = 0

    -- for i=1, #chapterAwardData do
    --     awardItem = qy.tank.view.common.AwardItem.createAwardView(chapterAwardData[i],1)
    --     self.itemList:addChild(awardItem)
    --     x = (awardItem:getWidth()+60)*(i-1)
    --     awardItem:setPosition(x+50,-50)       
    -- end
    local is_true = model:is_common()
    if is_true then
        self.hasGot:setVisible(false)
        self.getBtn:setBright(tonumber(self.chapterData.status) == 1)
        if tonumber(self.chapterData.status) == 1 then
            if self.chapterData.isDrawAward==1 then
                self.hasGot:setVisible(true)
                self.getBtn:setVisible(false)
            else 
                self.getBtn:setVisible(true)
            end
        end

        self.itemView = qy.AwardList.new({
            ["award"] = chapterAwardData,
            ["cellSize"] = cc.size(160,180),
        })
        self.itemView:setPosition(40,150)
        self.itemList:addChild(self.itemView)
    else
        local arraylist = model.list
        self.hasGot:setVisible(false)
        self.getBtn:setBright(tonumber(arraylist.list[tostring(self.chapterData.chapterId)].status) == 1)

        if tonumber(arraylist.list[tostring(self.chapterData.chapterId)].status) == 1 then
            if arraylist.list[tostring(self.chapterData.chapterId)].is_draw_award==1 then
                self.hasGot:setVisible(true)
                self.getBtn:setVisible(false)
            else 
                self.getBtn:setVisible(true)
            end

        end

        local x = qy.Config.hard_chapter[tostring(self.chapterData.chapterId)].award
        self.itemView = qy.AwardList.new({
            ["award"] = x,
            ["cellSize"] = cc.size(160,180),
        })
        self.itemView:setPosition(40,150)
        self.itemList:addChild(self.itemView)
    end

    
end

function ChapterRewardDialog:getAward()
    local is_true = model:is_true(self.chapterData.chapterId)
    if is_true then
        print("普通章节奖励")
        local service = qy.tank.service.CampaignService
        local param = {}
        param["chapter_id"] = self.chapterData.chapterId
        
        service:getChapterAward(param,function(data)
            -- qy.hint:show("领取成功")
            self.getBtn:setVisible(false)
            self.hasGot:setVisible(true)
            -- self.canNotGet:setVisible(false)
            self.chapterData.isDrawAward_:set(1)
            self.delegate.updateFunc()
            
            local awardData = data.award
            self.awardCommand:add(awardData)
            function tpClose( ... )
                self:dismiss()
            end
            self.awardCommand:show(awardData ,{["callback"] = tpClose})
        end)
    else
        print("困难章节奖励")
        local service = qy.tank.service.CampaignService
        local arraylist = model.list
        
        service:gethardChapterAward(self.chapterData.chapterId,function(data)
            -- qy.hint:show("领取成功")
            self.getBtn:setVisible(false)
            self.hasGot:setVisible(true)
            -- self.canNotGet:setVisible(false)
            --arraylist.list[tostring(self.chapterData.chapterId)].is_draw_award:set(1)
            self.delegate.updateFunc()
            
            --local x = qy.Config.hard_chapter[tostring(self.chapterData.chapterId)].award
            local awardData = data.award
            self.awardCommand:add(awardData)
            function tpClose( ... )
                self:dismiss()
            end
            self.awardCommand:show(awardData ,{["callback"] = tpClose})
        end)
    end
    
end

return ChapterRewardDialog