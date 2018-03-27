--[[--
--充值返利cell
--Author: H.X.Sun
--Date: 2015-06-24
--]]--

local AchieveShareCell = qy.class("AchieveShareCell", qy.tank.view.BaseView, "share/ui/sharecell")

local tankType = qy.tank.view.type.AwardType.TANK
local _moduleType = qy.tank.view.type.ModuleType.ACHIEVE_SHARE

function AchieveShareCell:ctor(delegate)
    AchieveShareCell.super.ctor(self)
    self.model = qy.tank.model.OperatingActivitiesModel
    local service = qy.tank.service.OperatingActivitiesService
    self.type = 1
    self:InjectView("bg")
    self:InjectView("title")
    self:InjectView("lingqu_bt")--
    self:InjectView("sprite")
    self:InjectView("Bt2")
    self:InjectView("bttext")
    self:InjectView("Sp")
    self:OnClick("lingqu_bt", function(sender)
        if self.type==1 then
            self.model:setShareAwardByIndex(self.lingqu_bt:getTag())
            qy.tank.view.operatingActivities.achieve_share.ChooseShare.new():show(true)--打开选择分享渠道界面
        else
            --领取接口
            print("第几个啊 ",self.lingqu_bt:getTag())
            service:getCommonGiftAward(self.lingqu_bt:getTag(), "achieve_share",true, function(reData)
                self.lingqu_bt:setVisible(false)
                self.Sp:setVisible(true)
                -- qy.tank.view.operatingActivities.achieve_share.AchieveShareDialog:dismiss()
                -- qy.tank.view.operatingActivities.achieve_share.AchieveShareDialog.new():show(true)
            end,true,false,false)    
        end
    end)
   
   

    

end

function AchieveShareCell:render(_idx)
    self.data = self.model:getShareAwardByIndex(_idx)
    self:updateButton(_idx);
    local cfgdata = self.model:getLocalShareByIndex(_idx);
    self.awardList = qy.AwardList.new({
        ["award"] = cfgdata.award,
        ["cellSize"] = cc.size(80,80),
        ["type"] = cfgdata.award.type,
        ["itemSize"] = 2,
        ["hasName"] = false,
    })
    self.awardList:setPosition(10,160)
    self.bg:removeAllChildren()
    self.bg:addChild(self.awardList)
    self.title:setString(cfgdata.title)	
end

function AchieveShareCell:updateButton( idx)
    local _status = self.data.status;
    self.lingqu_bt:setTag(self.data.id);
    if _status == 0 then
        self.Sp:setVisible(false)
        self.lingqu_bt:setVisible(false);
        self.Bt2:setVisible(true);
        self.bttext:setString("未完成")
    elseif _status == 1 then
        self.type = 1;
        self.Sp:setVisible(false)
        self.Bt2:setVisible(false);
        self.lingqu_bt:setVisible(true);
        self.sprite:setSpriteFrame("Resources/common/txt/xuanyao.png")--lingqu2.png
    elseif _status == 2 then
        self.type = 2;
        self.Bt2:setVisible(false);
        self.Sp:setVisible(false)
        self.lingqu_bt:setVisible(true);
        self.sprite:setSpriteFrame("Resources/common/txt/lingqu2.png")--lingqu2.png
    elseif _status == 3 then
        self.Sp:setVisible(true)
        self.Bt2:setVisible(false);
        self.lingqu_bt:setVisible(false);
        -- self.bttext:setString("已领取")
    end

end


return AchieveShareCell
