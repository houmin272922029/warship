--[[
    关卡攻略  item
]]
local HowToPlayItem = qy.class("HowToPlayItem", qy.tank.view.BaseView, "view/campaign/HowToPlayItem")
local model = qy.tank.model.CampaignModel
function HowToPlayItem:ctor(delegate)
    HowToPlayItem.super.ctor(self)
    print("HowToPlayItem111")
    for k,v in pairs(delegate) do
        print(k,v)
    end

    self:InjectView("nameTxt")
    self:InjectView("lvTxt")
    self:InjectView("seeBtn")
    self.checkpoint = delegate.checkpoint
    -- self.data = delegate.data
    
    -- self.nameTxt:setString(self.data.nickname)
    -- self.lvTxt:setString("LV."..self.data.level)
    
    self:OnClick(self.seeBtn, function()
        local service = qy.tank.service.CampaignService
        local param = {}
        param["checkpoint_id"] = self.checkpoint.checkpointId
        param["att_kid"] = self.data.kid
        if model:is_common() then
            service:passReportDetail(param,function(data)
                qy.tank.model.CampaignModel.ChapterViewDelegate:showBattle(data , false)
            end)
        else
            service:passhardReportDetail(param,function(data)
            qy.tank.model.CampaignModel.ChapterViewDelegate:showBattle(data , false)
        end)
        end
--        print("去观看战斗  self.data.fight_result")
    end)
end

function HowToPlayItem:update(data)
    self.nameTxt:setString(data.nickname)
    self.lvTxt:setString("LV."..data.level)
    self.data = data
end

return HowToPlayItem