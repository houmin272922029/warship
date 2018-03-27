--[[--
--折扣贩售cell
--Author: lijian ren
--Date: 2015-08-04
--]]--

local Cell = qy.class("Cell", qy.tank.view.BaseView, "diamond_rebate/ui/Cell")


function Cell:ctor(delegate)
    Cell.super.ctor(self)
    self.model = qy.tank.model.OperatingActivitiesModel
    local service = qy.tank.service.OperatingActivitiesService
    self:InjectView("title")
    self:InjectView("jindu")--进度
    self:InjectView("lingquBt")--
    self:InjectView("Btimg")
    self:InjectView("lingqul")
    self:InjectView("bg")
    self:InjectView("awardlist")
    self.lingqul:setVisible(false)
    self:OnClick("lingquBt", function(sender)
        local id = self.model.endlist[self.index].id
        print("lingqu"..id)
        service:getCommonGiftAward(id, qy.tank.view.type.ModuleType.DIAMOND_REBATE,false, function(data)
            self.lingqul:setVisible(true)
            self.lingquBt:setVisible(false)
            self.model.endlist[self.index].status = -1
        end)
    end)
end

function Cell:render(_idx)
    print("第几个",_idx)
    self.index = _idx
    self.data = self.model.endlist[_idx]
    local id = self.data.id
    local configlist  = self.model.diamondrebatecfg[tostring(id)]
    self.awardlist:removeAllChildren()
    local award =  configlist.award
      for i=1,#award do
        local item = qy.tank.view.common.AwardItem.createAwardView(award[i] ,1)
        self.awardlist:addChild(item)
        item:setPosition(20 + 100*(i - 1), 0)
        item:setScale(0.8)
        item.fatherSprite:setSwallowTouches(false)
        item.name:setVisible(false)
    end
    self.title:setString("累计消耗"..configlist.num.."钻石")
    local consumes 
    if self.model.consume > configlist.num then
        consumes = configlist.num
    else
        consumes = self.model.consume
    end
    self.jindu:setString(consumes.."/"..configlist.num)

    local status = self.data.status
    if status == -1 then
        self.lingqul:setVisible(true)
        self.lingquBt:setVisible(false)
    elseif status == 0 then
        self.lingqul:setVisible(false)
        self.lingquBt:setVisible(true)
        self.lingquBt:setTouchEnabled(false)
        self.lingquBt:setEnabled(false)
        self.Btimg:loadTexture("Resources/common/txt/weidacheng.png",1)
    else
        self.lingqul:setVisible(false)
        self.lingquBt:setVisible(true)
        self.lingquBt:setTouchEnabled(true)
        self.lingquBt:setEnabled(true)
        self.Btimg:loadTexture("Resources/common/txt/lingqu1.png",1)
    end
end

return Cell
