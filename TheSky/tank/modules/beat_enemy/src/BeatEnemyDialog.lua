local BeatEnemyDialog = qy.class("BeatEnemyDialog", qy.tank.view.BaseDialog, "beat_enemy.ui.BeatEnemyDialog")

local model = qy.tank.model.BeatEnemyModel
local service = qy.tank.service.BeatEnemyService
function BeatEnemyDialog:ctor(delegate)
   	BeatEnemyDialog.super.ctor(self)


   	self:InjectView("Time")
   	self:InjectView("Num")
    self:InjectView("scrollView")


    self:OnClick("Btn_Close", function()
        self:removeSelf()
    end,{["isScale"] = false})


    self:OnClick("Btn_Rank", function()
        require("beat_enemy.src.BeatEnemyRankDialog").new(self):show()
    end,{["isScale"] = false})


    self:OnClick("Btn_Pay", function()
        require("beat_enemy.src.BeatEnemyPayDialog").new(self):show()
    end,{["isScale"] = false})

    
    for i = 1, 9 do
        self:OnClick("CheckPoint_"..i, function()
            require("beat_enemy.src.BeatEnemyFireDialog").new(self, i):show()            
        end,{["isScale"] = false})
    end



    self.chest_cell_list = {}

    self.chest_data = model:getChestList()
    self:createChestView()
end

function BeatEnemyDialog:createChestView()

    local size_width = 150 * #self.chest_data
    local node = cc.Node:create()
    node:setPosition(40, 0)
    node:setContentSize(cc.size(size_width, 139))
    self.scrollView:setInnerContainerSize(cc.size(size_width + 80, 139))
    self.scrollView:addChild(node)
    self.scrollView:setScrollBarEnabled(false)


    for i, v in pairs(self.chest_data) do
        item = require("beat_enemy.src.ChestBoxCell").new(i)
        item:setPosition(150 * i, 55)

        node:addChild(item)

        table.insert(self.chest_cell_list, item)
    end


    self.ps_bg = ccui.ImageView:create()
    cc.SpriteFrameCache:getInstance():addSpriteFrames("beat_enemy/res/Plist.plist")
    self.ps_bg:loadTexture("beat_enemy/res/17.png",1)
    self.ps_bg:setScale9Enabled(true)
    self.ps_bg:setAnchorPoint(0, 0.5)
    self.ps_bg:setContentSize(cc.size(size_width, 24))
    self.ps_bg:setPosition(0, 45)
    self.ps_bg:setCapInsets(cc.rect(181,12,189,14))
    node:addChild(self.ps_bg)

    self.LoadingBar = ccui.LoadingBar:create()
    self.LoadingBar:loadTexture("beat_enemy/res/16.png", 1)
    self.LoadingBar:ignoreContentAdaptWithSize(false)
    self.LoadingBar:setDirection(0)
    self.LoadingBar:setPercent(0)
    self.LoadingBar:setAnchorPoint(0, 0.5)
    self.LoadingBar:setPosition(0, 13)
    self.LoadingBar:setContentSize(cc.size(size_width, 16)) --10是进度条与背景长度的偏移， 33是为了最后一关的点正好指向进度条结尾
    self.ps_bg:addChild(self.LoadingBar)

end


function BeatEnemyDialog:updateChest()
    local last_point = 0;
    self.LoadingBar:setPercent(0)

    for i, v in pairs(self.chest_data) do
        local item = self.chest_cell_list[i]

        print(v.is_obtain)
        if v.is_obtain then
            item:render(self, v, "empty")
        elseif model.total_point >= v.point then
            item:render(self, v, "open")
        else
            item:render(self, v, "")
        end

        if model.total_point >= v.point then
            self.LoadingBar:setPercent(self.LoadingBar:getPercent() + 100 / #self.chest_data)
        elseif model.total_point > last_point then
            self.LoadingBar:setPercent(self.LoadingBar:getPercent() + 100 / #self.chest_data * (model.total_point - last_point) / (v.point - last_point))
        end




        last_point = v.point
    end

end





function BeatEnemyDialog:update()
    self:updateChest()

    self.Num:setString(model:getTotalPoint())

end

function BeatEnemyDialog:updateTime()
    if self.Time then
        self.Time:setString(model:getRemainTime())
    end
end


function BeatEnemyDialog:onEnter()

    self:update()

    self:updateTime()
    self.timeListener = qy.Event.add(qy.Runtime.TIMER_UPDATE,function(event)
        self:updateTime()
    end)

    self.listener_1 = qy.Event.add(qy.Event.BEAT_ENEMY,function(event)
        self:removeSelf()
    end)

end

function BeatEnemyDialog:onExit()
    qy.Event.remove(self.timeListener)
    qy.Event.remove(self.listener_1)
    self.timeListener = nil
    self.listener_1 = nil
end


return BeatEnemyDialog
