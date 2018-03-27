local AwardDialog = qy.class("AwardDialog", qy.tank.view.BaseDialog)

local service = qy.tank.service.OperatingActivitiesService
local model = qy.tank.model.OperatingActivitiesModel
local activity = qy.tank.view.type.ModuleType
function AwardDialog:ctor(delegate)
   	AwardDialog.super.ctor(self)
    -- self:InjectView("BG")
   	-- self:InjectView("BG2")
   	-- self:InjectView("Pages")
    -- self:InjectView("Btn_choose")
    -- self:InjectView("Btn_carray")
    -- self:InjectView("arrowTip")  

    local style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(685, 545),   
        position = cc.p(0, 0),
        offset = cc.p(0, 0),
        titleUrl = "Resources/campaign/jiangliyulan.png",
        
        ["onClose"] = function()
            self:removeSelf()
        end
    })
    self:addChild(style)
    style:setLocalZOrder(-1)
    self.style = style


    if not tolua.cast(self.infoList,"cc.Node") then
            self.infoList = ccui.ScrollView:create()
            style.bg:addChild(self.infoList)
            self.infoList:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
            self.infoList:ignoreAnchorPointForPosition(false)
            self.infoList:setAnchorPoint(0,1)
            self.infoList:setPosition(25,505)
            -- self.infoList:setViewSize(cc.size(650,490))
            -- self.infoList:setContainer(self.info_c)
        end

    local h = 0
   for i = 1, 3 do
        local view = require("head_treasure.src.ListView").new(model.headTreasureList[tostring(i)], i)       
        self.infoList:addChild(view)
        h = h + math.ceil(#model.headTreasureList[tostring(i)] / 4) * 150 + 60
        view:setPositionY(h)
   end

   self.infoList:setContentSize(cc.size(650,490))

    self.infoList:setInnerContainerSize(cc.size(650,h + 20))

    -- self.infoList:updateInset()
    -- self.infoList:setDelegate()

    -- self.infoList:setContentOffset(cc.p(0,self.infoList:getViewSize().height-self.info_c:getContentSize().height),false)




    -- local view = require("head_treasure.src.MainDialog2").new(self)
    -- style.bg:addChild(view)
    -- local x = (display.width - 1080) / 2 
    -- view:setPosition(-80 - x, -80)

    --  local digview = require("head_treasure.src.DigView").new()
    -- digview:setVisible(false)
    -- self:addChild(digview)

    -- self.digview = digview

    -- self.Buttom:setLocalZOrder(5)

    -- self:OnClick("Btn_choose", function()
    --     local dialog = require("carray.src.ChooseDialog").new(self)
    --     dialog:show()
    -- end,{["isScale"] = false})

end

return AwardDialog
