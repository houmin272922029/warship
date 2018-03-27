--[[
    场景切换用
]]
local ChapterMapRender = qy.class("ChapterMapRender", qy.tank.view.BaseView)

function ChapterMapRender:ctor(delegate)
    ChapterMapRender.super.ctor(self)
    self.delegate = delegate
    -- self.BgContainer = cc.Node:create()
    -- self.BgContainer:setPosition(qy.winSize.width/2 , qy.winSize.height/2)
    -- self:addChild(self.BgContainer)
    --self:createBgMap(delegate.chapterId)
    self:createBgMap()
end

--创建背景地图
function  ChapterMapRender:createBgMap()
    print("ChapterMapRender00更新背景-------",self.delegate.chapterId)
    self.BgContainer = cc.Node:create()
    self.BgContainer:setPosition(qy.winSize.width/2 , qy.winSize.height/2)
    self:addChild(self.BgContainer)
    local model = qy.tank.model.CampaignModel
    local x = model:is_common()
    if x then
        mapAddr = "Resources/campaign/GK_38.jpg"
    else
        mapAddr = "Resources/campaign/GK_39.jpg"
    end
    --local chapterId = self.delegate.chapterId
    --local mapAddr = "Resources/campaign/GK_38.jpg"
    -- if tonumber(chapterId) == 1 then
    --     mapAddr  = mapAddr.."Map1_bg.jpg"
    -- elseif tonumber(chapterId ==2) then
    --     mapAddr  = mapAddr.."Map2_bg.jpg"
    -- else
    --     mapAddr  = mapAddr.."Map3_bg.jpg"
    -- end
    qy.Utils.preloadJPG(mapAddr)
    self.BgContainer:addChild(cc.Sprite:create(mapAddr))
end

function ChapterMapRender:createMap()
    -- if not self.chapterMap then
    --     self.chapterMap = qy.tank.view.campaign.chapterMap.ChapterMap.new({
    --                 ["csdName"] = self.delegate.csdName,
    --                 ["chapterId"] = self.delegate.chapterId
    --         })
    --     self:addChild(self.chapterMap)
    -- end
    if self.chapterMap then
        self:removeChild(self.chapterMap)
        self.chapterMap = qy.tank.view.campaign.chapterMap.ChapterMap.new({
                    ["csdName"] = self.delegate.csdName,
                    ["chapterId"] = self.delegate.chapterId
            })
        self:addChild(self.chapterMap)
    else
        self.chapterMap = qy.tank.view.campaign.chapterMap.ChapterMap.new({
                    ["csdName"] = self.delegate.csdName,
                    ["chapterId"] = self.delegate.chapterId
            })
        self:addChild(self.chapterMap)
    end
end

function ChapterMapRender:playAction()
    self.chapterMap:setOpacity(0)
    local fadeIn = cc.FadeIn:create(1)
    local seq = cc.Sequence:create(fadeIn ,cc.CallFunc:create(function()

    end))
    self.chapterMap:runAction(seq)
end

function ChapterMapRender:update( )
    self:createMap()
    self:playAction()
	self.chapterMap:updateAttr()
end
--困难
function ChapterMapRender:updatebg( )
    -- local model = qy.tank.model.CampaignModel
    -- local x = model:is_common()
    -- self.BgContainer2 = cc.Node:create()
    -- self.BgContainer2:setPosition(qy.winSize.width/2 , qy.winSize.height/2)
    -- self:addChild(self.BgContainer2)
    -- if x then
    --     mapAddr2 = "Resources/campaign/GK_38.jpg"
    -- else
    --     mapAddr2 = "Resources/campaign/GK_39.jpg"
    -- end
    -- qy.Utils.preloadJPG(mapAddr2)
    -- self.BgContainer2:addChild(cc.Sprite:create(mapAddr2),-1)
    self:createBgMap()
end

function ChapterMapRender:startRunAnimaiton()
    if self.chapterMap == nil then
        local delay =  cc.DelayTime:create(.1)
        local seq = cc.Sequence:create(delay ,cc.CallFunc:create(function()
            self:createMap()
            self:playAction()
            self.chapterMap:startRunAnimaiton()
        end))
        self:runAction(seq)
    else
        self:createMap()
        self:playAction()
        self.chapterMap:startRunAnimaiton()
    end

end

function ChapterMapRender:clear()
    -- if self.chapterMap ~=nil then
    --     -- self.chapterMap:clear()
    --     self:removeChild(self.chapterMap)
    --     self.chapterMap = nil
    -- end
end

return ChapterMapRender
