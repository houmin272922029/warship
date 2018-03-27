
-- local level = model:getRankLevel()
-- print("sssss",level)
-- local src = "Military_rank/ui/Rank"..level
-- local Rank1 = qy.class("Rank1", qy.tank.view.BaseView, src)
-- local ChapterMap = qy.class("ChapterMap", qy.tank.view.BaseView)
local Rank1 = qy.class("Rank1", qy.tank.view.BaseView)
Rank1.__create = function(delegate)
    return Rank1.super.__create(delegate.csdName)
end
local  model = qy.tank.model.MilitaryRankModel
function Rank1:ctor(delegate)
    Rank1.super.ctor(self)
    --十个点
    for i=1,10 do
    	local a = "icon"..i
    	self:InjectView(a)
    end
    --三十个星
    for i=1,30 do
    	local b = "star" ..i
    	self:InjectView(b)
        self["star"..i]:loadTexture("Military_rank/res/q1.png",1)
    end
    self:update()
   
end
function Rank1:update()
    local total = model:GetNumById(4)
    local icon = math.floor(total/3)
    for i=1,icon do
        self["icon"..i]:loadTexture("Military_rank/res/9.png",1)
    end
    for i=1,total do
        self["star"..i]:loadTexture("Military_rank/res/10.png",1)
    end
    if model:getuplevel() == true then
        self:__showEffert()
    end
end
function Rank1:__showEffert()
    local total = model:GetNumById(4)
    total = 1 and  total == 0 or  total
    if self.currentEffert == nil then
        self.currentEffert = ccs.Armature:create("ui_fx_jinxiu")
        self["star"..total]:addChild(self.currentEffert,999)
        self.currentEffert:setScale(1.25)
        local size = self["star"..total]:getContentSize()
        self.currentEffert:setPosition(size.width/2,size.height/2)
    end

    self.currentEffert:getAnimation():setMovementEventCallFunc(function(armatureBack,movementType,movementID)
        if movementType == ccs.MovementEventType.complete then
            self.isEffertShow = false
        end
    end)
    if not self.isEffertShow then
        self.isEffertShow = true
        self.currentEffert:getAnimation():playWithIndex(0)
    end
    self.currentEffert = nil
end
function Rank1:onEnter()
    self.currentEffert = nil
    qy.tank.utils.cache.CachePoolUtil.addArmatureFileAsync(qy.ResConfig.JINXIU)
end
function Rank1:onExit()
       self.currentEffert = nil
end




return Rank1
