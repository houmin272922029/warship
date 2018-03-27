local AwardDialog = qy.class("AwardDialog", qy.tank.view.BaseDialog, "lucky_indiana.ui.AwardDialog")

local service = qy.tank.service.OperatingActivitiesService
local model = qy.tank.model.OperatingActivitiesModel
local activity = qy.tank.view.type.ModuleType
function AwardDialog:ctor(delegate)
   	AwardDialog.super.ctor(self)
    self:InjectView("bg")
   	self:InjectView("queren")
   	self:InjectView("continiuBt")
   	self:InjectView("closeBt")
    self:InjectView("img1")--icon
    self:InjectView("img2")--几次
 

    self:OnClick("closeBt", function()
        delegate.callback(false)
        self:removeSelf()
    end,{["isScale"] = false})


    self:OnClick("queren", function()
        delegate.callback(false)
        self:removeSelf()
    end)
    self:OnClick("continiuBt", function()
       print("继续抽")
       delegate.callback(false)
       delegate:callback2(delegate.num)
       self:removeSelf()
    end)
    if delegate.type == 1 then
        self.img2:setSpriteFrame("lucky_indiana/res/juan.png")
    else
        self.img2:setSpriteFrame("lucky_indiana/res/1a.png")
    end
    if delegate.num == 1 then
        if delegate.type == 1 then
             self.img1:setString("260买一个")
        else
             self.img1:setString("60买一个")
        end
    else
        if delegate.type == 1 then
             self.img1:setString("1170买五个")
        else
             self.img1:setString("270买五个")
        end
    end
    if delegate.list == 1 then
        self.awardList = qy.AwardList.new({
            ["award"] = delegate.data[delegate.index].award,
            ["cellSize"] = cc.size(120,80),
            ["type"] = delegate.data[delegate.index].award.type,
            ["itemSize"] = 2,
            ["hasName"] = true,
            ["len"] = 5
        })
        self.awardList:setPosition(80,270)
        self.bg:addChild(self.awardList)
    else
        local list = {}
        for i=1,5 do
            table.insert(list, delegate.data[delegate.list[i]].award)
            local item = qy.tank.view.common.AwardItem.createAwardView( delegate.data[delegate.list[i]].award[1] ,1)
            self.bg:addChild(item)
            item:setPosition(80 + 120 * (i - 1), 200)
            item:setScale(0.8)
            item.name:setScale(1.2)
        end
  
    end
  
end



function AwardDialog:onEnter()
   
    
end

function AwardDialog:onExit()
   
  
end

return AwardDialog
