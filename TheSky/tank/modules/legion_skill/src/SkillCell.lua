local SkillCell = qy.class("SkillCell", qy.tank.view.BaseView, "legion_skill.ui.SkillCell")

local service = qy.tank.service.LegionService
local model = qy.tank.model.LegionModel
local cfg = qy.Config.legion_skill_level

function SkillCell:ctor(delegate)
	SkillCell.super.ctor(self)
   self:InjectView("icon_bg")
   self:InjectView("name")
   self:InjectView("des")
   self:InjectView("level")
   self:InjectView("next")
   self:InjectView("nextDes")
   self:InjectView("Text_1")
   self:InjectView("Text_2")
   self:InjectView("cost1")
   self:InjectView("Sprite_4")
   self:InjectView("cost2")
   self:InjectView("has")
   self:InjectView("Button_1")

   
   self:OnClick("Button_1", function()
      if self.isLast then
         qy.hint:show("技能已满级")
         return
      end
      if self.isHight then
         qy.hint:show("技能不可超过指挥官等级")
         return
      end
      service:skillUpGrade({
            ["skill_id"] = self.skill_id,
            ["contribution"] = self.nextContribution,
            ["silver"] = self.nextSilver
         },function(reData)
            qy.hint:show(self.nextAdd)
            qy.Event.dispatch(qy.Event.SEARCH_TREASURE)
            if self.skill_id ~= 4 then
               self.showUtil()
            end
      end)
   end)
end

function SkillCell:setData(idx)
   cc.SpriteFrameCache:getInstance():addSpriteFrames("legion_skill/res/legion_skill.plist")
   self.icon_bg:setSpriteFrame("legion_skill/res/jtjlb_1".. idx ..".png")
   self.name:setSpriteFrame("legion_skill/res/jtjlb_0".. idx ..".png")

   local level = model["skillLevel"..idx]
   self.level:setString(level.."级")
   self.des:setString(model.skillTypeNameList[(idx == 4 and 14 or idx)..""].."+"..model.finalReturn[idx..""] .. (idx == 4 and "%" or ""))
   local contribution_skill = model.contribution_skill
   local contribution = model.contributions
   self.has:setString(contribution_skill)

   if cfg[level..""]["silver_"..idx] ~= 0 then
      self.nextDes:setVisible(true)
      self.nextDes:setString(model.skillTypeNameList[(idx == 4 and 14 or idx)..""].."+"..model.nextAddList[idx..""] .. (idx == 4 and "%" or ""))
      self.next:setVisible(true)
      self.Text_2:setVisible(true)
      self.has:setVisible(true)
      self.cost1:setString("军团贡献"..cfg[level..""]["contribution_"..idx])
      self.cost2:setString(cfg[level..""]["silver_"..idx])
      self.skill_id = idx
      self.nextContribution = cfg[level..""]["contribution_"..idx]
      self.nextSilver = cfg[level..""]["silver_"..idx]
      self.nextAdd = (model.skillTypeNameList[(idx == 4 and 14 or idx)..""].."+"..model.nextAddList[idx..""] .. (idx == 4 and "%" or ""))
      if contribution_skill < cfg[level..""]["contribution_"..idx] then
         self.has:setColor(cc.c3b(255,0,0))
      else
         self.has:setColor(cc.c3b(255,255,255))
      end
      if level < qy.tank.model.UserInfoModel.userInfoEntity.level then
         self.isHight = false
         self.Button_1:loadTextureNormal("Resources/common/button/btn_3.png", 1)
         self.Button_1:loadTextureDisabled("Resources/common/button/anniuhong02.png", 1)
      else
         self.isHight = true
         self.Button_1:loadTextureNormal("Resources/common/button/anniuhui.png", 1)
         self.Button_1:loadTextureDisabled("Resources/common/button/anniuhui.png", 1)
      end
      self.isLast = false
   else
      self.has:setVisible(false)
      self.isHight = false
      self.isLast = true
      self.Button_1:loadTextureNormal("Resources/common/button/anniuhui.png", 1)
      self.Button_1:loadTextureDisabled("Resources/common/button/anniuhui.png", 1)
      self.nextDes:setVisible(false) 
      self.next:setVisible(false)
      self.Sprite_4:setVisible(false)
      self.cost2:setVisible(false)
      self.Text_2:setVisible(false)
      self.Text_1:setString("无法学习：")
      self.cost1:setString("技能已达等级上限")
      self.Text_1:setColor(cc.c3b(255,0,0))
      self.cost1:setColor(cc.c3b(255,0,0))
   end
   
end

-- 战斗力飘字
function SkillCell:showUtil()
    local _aData = {}
    local fightPower = qy.tank.model.UserInfoModel.userInfoEntity.fightPower - qy.tank.model.UserInfoModel.userInfoEntity.oldfight_power
    if fightPower then
        local numType = 0
        if fightPower > 0 then
            numType = 15
        else
            numType = 14
        end
        _data = {
            ["value"] = fightPower,
            ["url"] = qy.ResConfig.IMG_FIGHT_POWER,
            ["type"] = numType,
            ["picType"] = 2,
         }
        table.insert(_aData, _data)
        qy.tank.utils.HintUtil.showSomeImageToast(_aData,cc.p(qy.winSize.width / 3 * 2, qy.winSize.height * 0.7))
    end
end

return SkillCell