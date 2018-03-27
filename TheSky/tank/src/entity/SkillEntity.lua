--[[
    skill
    Author: Aaron Wei
    Date: 2015-03-20 11:58:36
]]

local SkillEntity = qy.class("SkillEntity", qy.tank.entity.BaseEntity)

-- local GradeStr = {"白色", "绿色", "蓝色", "紫色", "金色"}
-- local GradeColor = {cc.c3b(255, 255, 255), cc.c3b(0, 140, 52), cc.c3b(0, 142, 227), cc.c3b(255, 0, 255), cc.c3b(255, 216, 0)}

function SkillEntity:ctor(id)
    -- local skill = assert(qy.Model.Game:getSkillDataByTag(tag), "技能 " .. tag .. " 不存在")

    -- self:setproperty("id", skill.tag)
    -- self:setproperty("name", qy.I18N.getString(skill.skillName))
    -- self:setproperty("desc", qy.I18N.getString(skill.skillExplain) or "没有描述!!")

    -- -- 激活需要的英雄品质
    -- self:setproperty("opengrade", 0)
    -- -- 是否激活
    -- self:setproperty("isopen", false)
    -- -- 品质
    -- self:setproperty("grade", 1)
    -- -- 在英雄技能列表中的位置
    -- self:setproperty("pos", 0)

    -- -- 升级需要的银两
    -- self:setproperty("needmoney", 0)

    -- -- 等级变化后, 英雄需要变化属性
    -- self:setproperty("level", 0, didSet = function(level)
    --     -- 更新升级需要的银两
    --     self.needmoney_:set(qy.Model.Skill.NeedMoney[tostring(level)].money)
    -- end})

    -- -- 技能所属英雄
    -- self.hero = nil

    local config = qy.Config.skill[tostring(id)]
    self:setproperty("id",id)    
    self:setproperty("name",config.name)
    self:setproperty("desc",config.desc)

    self.commonSign = "Resources/common/icon/c_12.png" 
    self.compatSign = "Resources/common/icon/c_13.png" 
end

return SkillEntity