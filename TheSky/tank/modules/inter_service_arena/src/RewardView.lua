local RewardView = qy.class("RewardView", qy.tank.view.BaseView, "inter_service_arena.ui.RewardView")

function RewardView:ctor(delegate)
   	RewardView.super.ctor(self)

    self.model = qy.tank.model.InterServiceArenaModel
    self.service = qy.tank.service.InterServiceArenaService

    local style = qy.tank.view.style.ViewStyle1.new({
        titleUrl = "Resources/activity/title_inter_service_arena.png", 
        showHome = false,
        ["onExit"] = function()
            if delegate and delegate.dismiss then
                delegate.dismiss()
            end
        end
    })
    self:addChild(style)


    self:InjectView("bg")
    self:InjectView("Img")
    self:InjectView("Img_hd1")
    self:InjectView("Img_hd2")
    self:InjectView("Img_hd3")

    self.Img_hd1:setLocalZOrder(1)
    self.Img_hd2:setLocalZOrder(1)
    self.Img_hd3:setLocalZOrder(1)

    self.tab_host = qy.tank.widget.TabHost.new({
        delegate = self,
        csd = "widget/TabButton2",
        tabs = {qy.TextUtil:substitute(90286), qy.TextUtil:substitute(90287), qy.TextUtil:substitute(90311), qy.TextUtil:substitute(90288)},
        size = cc.size(165,50),
        layout = "h",
        idx = 1,

        ["onCreate"] = function(tabHost, idx)       
            local node 
            if idx == 1 then
                node = require("inter_service_arena.src.RewardPointsNode").new(self)
            elseif idx == 2 then
                node = require("inter_service_arena.src.RewardRiseInRankNode").new(self)
            elseif idx == 3 then
                node = require("inter_service_arena.src.RewardSeasonNode").new(self)
            else
                node = require("inter_service_arena.src.RewardStageNode").new(self)
            end
            node:setPosition(self.Img:getContentSize().width / 2 - 150, -25)
            return node
        end,
        
        ["onTabChange"] = function(tabHost, idx)

        end
    })
    self.Img:addChild(self.tab_host, -1)
    self.tab_host:setPosition(150,10)


    self:OnClick("Btn_formation", function()

    end,{["isScale"] = false})

    self:update()
end


function RewardView:update()

    self.Img_hd1:setVisible(false)
    self.Img_hd2:setVisible(false)
    self.Img_hd3:setVisible(false)


    for i = 1, 19 do
        local data = self.model.stage_award[tostring(i)]
        if data == 0 and self.model.max_stage <= i then
            self.Img_hd2:setVisible(true)
        end
    end


    for i = 1, #self.model.score_award do
        local data = self.model:getScoreAwardByScore(i)
        local source = data["source"]
        local lingqu = self.model.source_award[tostring(source)]
        if lingqu == 0 and self.model.source >= source then
            self.Img_hd1:setVisible(true)
        end
    end


    local day = self.model:getTime()   
    if (self.model.day_7_get == 1 and tonumber(day) >= 7) or (self.model.day_14_get == 1 and tonumber(day) >= 14) then
        self.Img_hd3:setVisible(true)
    end   
end




return RewardView
