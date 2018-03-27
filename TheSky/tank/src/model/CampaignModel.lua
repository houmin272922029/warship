--[[
    关卡机制 model
    add by lianyi
]]
local CampaignModel = qy.class("CampaignModel", qy.tank.model.BaseModel)

    CampaignModel.ChapterViewDelegate = nil
    CampaignModel.currentUserChapterId = -1  -- 用于记录选定的章节默认是 -1, 当为 -1时表示初始化，此时滚动到最新关卡

function CampaignModel:init(data) -- 这个data是后端接口返回的数据
    print("-----CampaignModel-- init---" , os.time())
    -- self:initConfigs()
    self.chapterList = {}
    self.openChapterList = {}

    self.openhardChapterList = {}

    self.sceneList = {}
    self.openSceneList = {}
    self.openhardSceneList = {}
    self.pointList = {}
    self.openPointList = {}
    self.chapterCompleteId = 1
    self.chapterCurrentId = 2
    self.userSceneCurrentId = -1
    self.sceneCurrentId = 2
    self.sceneCompleteId = 1
    self.checkointCompleteId = 1
    self.checkpointCurrentId = 2
    self.bossTotalTimes = 0
    self.booshardToalTimes = 0
    self.currentUserChapterId = -1
    --困难模式 0 普通模式  1 困难模式
    self.is_difficulty = true 
    for i=1,2000 do
        self["is_true_"..i] = true
    end

    self.award_status = 0 

    self.chapterSceneList = {}
    self.currentSceneCheckpointList = {}

    for i, v in pairs(qy.Config.chapter) do
        if not self.chapterList[tostring(v.chapter_id)] then
            self.chapterList[tostring(v.chapter_id)] = qy.tank.entity.CampaignChapterEntity.new(v)
        end
    end
end

function CampaignModel:update(data)
    print("-----CampaignModel-- update start---" , os.time())
     -- self:initConfigs()
    self.chapterCompleteId = data.chapter.complete
    self.sceneCompleteId = data.scene.complete
    self.sceneCurrentId = data.scene.current
    self.checkpointCompleteId = data.checkpoint.complete
    self.checkpointCurrentId = data.checkpoint.current
    self.openSceneList = data.scene.list
    self.openPointList = data.checkpoint.list
    self.checkointCompleteId =  data.checkpoint.complete  


    -- if data.chapter.current~= self.chapterCurrentId then
    --     self:resetUserChapter()
    -- end
    -- self.chapterCurrentId = data.chapter.current

    for chapterId , chapterData in pairs(data.chapter.list) do
        self.chapterList[tostring(chapterData.chapter_id)]:upData(chapterData)
        if not self.openChapterList[tostring(chapterData.chapter_id)] then
            self.openChapterList[tostring(chapterData.chapter_id)] = self.chapterList[tostring(chapterData.chapter_id)]
        end
    end

    if data.free_times~=nil then
        self.bossTotalTimes = data.free_times
    end
    print("-----CampaignModel-- update end---" , os.time())
end
--困难模式
function CampaignModel:update2(id,data)
    if id == 1 then
        print("-----CampaignModel-- update start---" , os.time())
         -- self:initConfigs()
        self.chapterCompleteId = data.hard_chapter.complete
        self.sceneCompleteId = data.hard_scene.complete
        self.sceneCurrentId = data.hard_scene.current
        self.checkpointCompleteId = data.hard_checkpoint.complete
        self.checkpointCurrentId = data.hard_checkpoint.current
        self.openhardSceneList = data.hard_scene.list
        self.openPointList = data.hard_checkpoint.list
        self.checkointCompleteId =  data.hard_checkpoint.complete
        self.attack_times = data.attack_times
        self.all_times = data.free_times 
        self.list = data.hard_chapter 
        self.boostimes = data.hard_checkpoint
        self.is_draw_award = data.hard_scene.list
        self.hard_chapter_current = data.hard_chapter.current


        -- if data.chapter.current~= self.chapterCurrentId then
        --     self:resetUserChapter()
        -- end
        -- self.chapterCurrentId = data.chapter.current

        for chapterId , chapterData in pairs(data.hard_chapter.list) do
            self.chapterList[tostring(chapterData.chapter_id)]:upData(chapterData)
            if not self.openhardChapterList[tostring(chapterData.chapter_id)] then
                self.openhardChapterList[tostring(chapterData.chapter_id)] = self.chapterList[tostring(chapterData.chapter_id)]
            end
        end

        if data.free_times~=nil then
            self.booshardToalTimes = 3
        end
        print("-----CampaignModel-- update end---" , os.time())
    else
        print("-----CampaignModel-- update start---" , os.time())
         -- self:initConfigs()
        self.chapterCompleteId = data.chapter.complete
        self.sceneCompleteId = data.scene.complete
        self.sceneCurrentId = data.scene.current
        self.checkpointCompleteId = data.checkpoint.complete
        self.checkpointCurrentId = data.checkpoint.current
        self.openSceneList = data.scene.list
        self.openPointList = data.checkpoint.list
        self.checkointCompleteId =  data.checkpoint.complete 


        -- if data.chapter.current~= self.chapterCurrentId then
        --     self:resetUserChapter()
        -- end
        -- self.chapterCurrentId = data.chapter.current

        for chapterId , chapterData in pairs(data.chapter.list) do
            self.chapterList[tostring(chapterData.chapter_id)]:upData(chapterData)
            if not self.openhardChapterList[tostring(chapterData.chapter_id)] then
                self.openhardChapterList[tostring(chapterData.chapter_id)] = self.chapterList[tostring(chapterData.chapter_id)]
            end
        end

        if data.free_times~=nil then
            self.booshardToalTimes = 3
        end
        print("-----CampaignModel-- update end---" , os.time())   
    end
end

-- 获取指定章节下的scene列表信息
function CampaignModel:getSceneList(chapterID)
    self.chapterID = chapterID
    -- if not self.chapterSceneList[tostring(chapterID)] then
    local is_true = self:is_true(chapterID)
    if is_true then
        self.chapterSceneList = {}
        self:release()
        local staticData = require("data/scene/scene_" .. chapterID)
        for i, v in pairs(staticData) do
            local entity = qy.tank.entity.CampaignSceneEntity.new(v,is_true)
            if self.openSceneList[tostring(i)] then
                entity:upData(self.openSceneList[tostring(i)])
            end

            table.insert(self.chapterSceneList, entity)
        end
        -- else
        --     for i, entity in pairs(self.chapterSceneList[tostring(chapterID)]) do
        --         if self.openSceneList[tostring(i)] then
        --             entity:upData(self.openSceneList[tostring(i)])
        --         end
        --     end
        -- end
        return self.chapterSceneList
    else
        print("困难显示文字",chapterID)
        self.chapterSceneList2 = {}
        self:release()
        if chapterID < 6 then
            local staticData = require("data/hard_scene/scene_" .. chapterID)
            for i, v in pairs(staticData) do
                local entity2 = qy.tank.entity.CampaignSceneEntity.new(v,is_true)
                if self.openhardSceneList[tostring(i)] then
                    entity2:upData(self.openhardSceneList[tostring(i)])
                end

                table.insert(self.chapterSceneList2, entity2)
            end
            return self.chapterSceneList2
        else
            return self.chapterSceneList2
        end
    end    
end

-- 获取指定scene下的checkpoint
function CampaignModel:getCheckpointList(sceneID)
    local is_true = self:is_true(self.chapterID)
    if is_true then
        self.currentSceneCheckpointList = {}
        self:release()
        local staticData = require("data/checkpoint/checkpoint_" .. sceneID)
        --print("staticData====",qy.json.encode(staticData))

        for i, v in pairs(staticData) do
            local pointEntity = qy.tank.entity.CampaignCheckpointEntity.new(v,is_true)
            table.insert(self.currentSceneCheckpointList, pointEntity)
            if self.openPointList[tostring(i)] then
                pointEntity:upData(self.openPointList[tostring(i)])
            end
        end

        table.sort(self.currentSceneCheckpointList, function(a, b)
            return a.checkpointId > b.checkpointId
        end)
        return self.currentSceneCheckpointList
    else
        self.currentSceneCheckpointList = {}
        self:release()
        local staticData = require("data/hard_checkpoint/checkpoint_" .. sceneID)
        print("staticData====",qy.json.encode(staticData))

        for i, v in pairs(staticData) do
            local pointEntity = qy.tank.entity.CampaignCheckpointEntity.new(v,is_true)
            table.insert(self.currentSceneCheckpointList, pointEntity)
            if self.openPointList[tostring(i)] then
                pointEntity:upData(self.openPointList[tostring(i)])
            end
        end

        table.sort(self.currentSceneCheckpointList, function(a, b)
            return a.checkpointId > b.checkpointId
        end)
        return self.currentSceneCheckpointList
    end    
end
--困难模式
function CampaignModel:add_putong( idx)
    self.chapterSceneList[tostring(idx)].isDrawAward = 1
    return 1
end

-- 测试是否已经通关（scene）
function CampaignModel:testSceneOver(entity)
    return tonumber(self.openSceneList[tostring(entity.sceneId)].status) or 0
end

-- 困难测试是否已经通关（scene）
function CampaignModel:testhardSceneOver(entity)
    return tonumber(self.openhardSceneList[tostring(entity.sceneId)].status) or 0
end

function CampaignModel:resetUserChapter()
    self.currentUserChapterId = -1
end

function CampaignModel:release()
    -- collectgarbage("collect")  --垃圾回收
end

function CampaignModel:getChapterNums()
    return table.nums(self.chapterList)
end

------------------chapter 数据相关－－－－－－－－－
function CampaignModel:atSecne(sceneId)
    return self.sceneList[tostring(sceneId)]
end
-- function CampaignModel:getChapterRewardUserDataByChapterId(chapterId)

--     local tempChapterEntity
--     for i=1, #CampaignModel.chapterList do
--         tempChapterEntity =  CampaignModel.chapterList[i]
--         if tonumber(tempChapterEntity.chapterId) == tonumber(chapterId) then
--         	return tempChapterEntity
--         end
--     end
--     return nil
-- end

--获取章节实体
function CampaignModel:atChapter(chapterId)
    return self.chapterList[tostring(chapterId)]
end

-- function CampaignModel:getMaxChapterNumInConfig()
--     -- local count = 0
--     -- for k,chapter in pairs(self.chapterConfig) do
--     --     count = count + 1
--     -- end
--     return table.nums(self.chapterConfig)
-- end
------------------scene 数据相关－－－－－－－－－

--通过chapterId获取隶属于该章节的所有场景配置数组
-- function CampaignModel:getScenesConfigByChapterId(chapterId)
--     -- local list = qy.Config.scene
--     -- local temp = {}
--     -- for i, v in pairs(list) do
--     --     if tonumber(v.chapter_id) == tonumber(chapterId) then
--     --         if self.sceneList[tostring(v.scene_id)] then
--     --             table.insert(temp, self.sceneList[tostring(v.scene_id)])
--     --         else
--     --             table.insert(temp, qy.tank.entity.CampaignSceneEntity.new(v))
--     --         end
--     --     end
--     -- end
--     -- return temp
--     return self:atChapter(chapterId):getList()
-- end

-- function CampaignModel:getOpenSceneAtChapter(chapterId)
--     -- local list = self.chapterList[tostring(chapterId)]:getList()

--     -- table.sort(list, function(a, b)
--     --     return a.sceneId < b.sceneId
--     -- end)

--     -- return list
-- end

-- scene是否开启
function CampaignModel:testSceneOpen(entity)
    return tonumber(entity.sceneId) <= tonumber(self.sceneCurrentId)
end

-- point是否开启
function CampaignModel:testOpenPoint(entity)
    return tonumber(entity.checkpointId) <= tonumber(self.checkpointCurrentId)
end

--通过sceneId获取场景配置数据
-- function CampaignModel:getSceneConfigBySceneId(sceneId)
--     return self.sceneConfig[tostring(sceneId)]
-- end

-- 检测是否已通关
function CampaignModel:hasCurrentCheckpoint(sceneId)
    return sceneId >= self.sceneCurrentId
    -- for i, v in pairs(checkpointDatas) do
    --     if v.checkpointId and tonumber(v.checkpointId) == tonumber(self.checkpointCurrentId) then
    --         return true
    --     end
    -- end
    -- return false
end

------------------checkpoint 数据相关－－－－－－－－－

--通过sceneId获取隶属于该章节的所有关卡配置数组
-- function CampaignModel:getCheckpointsConfigBySceneId(sceneId)
--     local list = qy.Config.checkpoint

--     local temp = {}

--     for i, v in pairs(list) do
--         if tonumber(v.scene_id) == tonumber(sceneId) then
--             if self.pointList[tostring(v.checkpoint_id)] then
--                 table.insert(temp, self.pointList[tostring(v.checkpoint_id)])
--             else
--                 table.insert(temp, qy.tank.entity.CampaignCheckpointEntity.new(v))
--             end
--         end
--     end

--     table.sort(temp, function(a, b)
--         return a.checkpointId > b.checkpointId
--     end)
--     return temp
-- end

-- 通过关卡ID获取该关卡的用户数据
function CampaignModel:getCheckpointUserDataByCheckpointId( checkpointId )
    return  self.pointList[tostring(checkpointId)]
end

-- 通过关卡ID获取关卡配置数据
function CampaignModel:getCheckpointConfigDataByCheckpointId(checkpointId )
    return self.checkpointConfig[tostring(checkpointId)]
end

--计算当前关卡的战斗力
-- function CampaignModel:getFightPowerByCheckpointData(checkConfigData)

--     local monsterConfig = qy.Config.monster
--     local talentConfig = qy.Config.talent
--     local fightPower = 0

--     function getMonsterDataById(id)
--         return monsterConfig[tostring(id)]

--     end

--     function getTalentById(id)
--         return talentConfig[tostring(id)]
--     end

--     function calculateMonsterFightPowerByMonsterId(id)
--         if id == nil or id ==0 then return 0 end
--         local monster = getMonsterDataById(id)

--         if monster == nil then return 0 end

--         local talent = getTalentById(monster.talent_id)
--         if talent == nil then  return 0 end

--         if monster["crit_hurt"] == nil then monster["crit_hurt"]  = 0 end
--         local singleFightPower = math.floor((1+monster["wear"]/500)*(1+talent["crit_rate"]/2000)
--                            *(1+(1.5+monster["crit_hurt"]-1.5)/2)
--                            *monster["attack"]*talent["attack_plus"]*1
--                            +(1+talent["dodge_rate"]/2000)*(1+talent["disarm_anti"]/2000)
--                            *(1+monster["anti_wear"]/500)*monster["defense"]
--                            *talent["defense_plus"]*1
--                            +monster["blood"]*talent["blood_plus"]*0.25)
--         return singleFightPower
--     end

--     for i=1,6 do
--         fightPower = fightPower +  calculateMonsterFightPowerByMonsterId(checkConfigData["monster"..i .."_"]:get())
--     end
--     return fightPower
-- end

-- 释放数据占用内存
function CampaignModel:freeData()
    -- self.chapterList = {}
    -- self.sceneList = {}
    -- self.pointList = {}
    -- self:release()
end

--困难模式
function CampaignModel:is_common(  )--true 普通模式 false 困难模式
    return self.is_difficulty
end

function CampaignModel:add_is_common(  )
     self.is_difficulty = false
end

function CampaignModel:remove_is_common(  )
    self.is_difficulty = true
end

function CampaignModel:is_true(idx)
    return  self["is_true_"..idx]
end

function CampaignModel:add_is_true(idx)
     self["is_true_"..idx] = false
end

function CampaignModel:remove_is_true(idx)
    self["is_true_"..idx] = true
end

--攻击次数减一
function CampaignModel:remove_one(  )
    self.attack_times = self.attack_times + 1
end

function CampaignModel:remove_all(idx)
    self.attack_times = self.attack_times + idx
end
--boos困难模式
function CampaignModel:boostime(idx)
    self.openPointList[tostring(idx)].times = self.openPointList[tostring(idx)].times 
end

function CampaignModel:boostime_all(idx1,idx2)
    self.openPointList[tostring(idx1)].times = self.openPointList[tostring(idx1)].times + idx2 
end

function CampaignModel:add_isdrawaward()
    return self.award_status
end

function CampaignModel:remove_isdrawaward(scenceid)
    -- self.award_status = 1
    if self.openSceneList then
        self.openSceneList[tostring(scenceid)].is_draw_award = 1
    end
end

function CampaignModel:remove_isdrawaward2(scenceid)
    if self.openhardSceneList then
        self.openhardSceneList[tostring(scenceid)].is_draw_award = 1
    end
end

function CampaignModel:remove_isdrawaward3(scenceid)
    if self.openhardSceneList then
        self.openhardSceneList[tostring(scenceid)].status = 1
    end
end
-- CampaignModel:init()

return CampaignModel
