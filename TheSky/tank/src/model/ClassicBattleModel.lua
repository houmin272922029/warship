--[[
	经典战役数据
	Author: Aaron Wei
	Date: 2015-04-28 18:01:33
]]

local ClassicBattleModel = qy.class("ClassicBattleModel", qy.tank.model.BaseModel)
ClassicBattleModel.color = {cc.c3b(0,255,0),cc.c3b(255,255,0),cc.c3b(255,0,0)}

function ClassicBattleModel:init(data)
    self.is_free = data.is_free
    self.red_heart_num = data.red_heart_num
    self.fight_power = data.fight_power
    self.cardList = {} 
   	for k,v in pairs(data.list) do
   		local entity = ClassicBattleModel.CardEntity.new(v)
   		table.insert(self.cardList,entity)
   	end
end 

function ClassicBattleModel:update(data)
    if data.is_free ~= nil then
      self.is_free = data.is_free
    end
      
    if data.red_heart_num ~= nil then
      self.red_heart_num = data.red_heart_num   
    end

    self.cardList = {}
   	for k,v in pairs(data.update_list.list) do
   		local entity = ClassicBattleModel.CardEntity.new(v)
   		table.insert(self.cardList,entity)
   	end
end

function ClassicBattleModel:battleResult(data)
  self.red_heart_num = data.red_heart_num
  self.three_experience = data.three_experience
end

ClassicBattleModel.CardEntity = qy.class("CardEntity", qy.tank.entity.BaseEntity)

function ClassicBattleModel.CardEntity:ctor(data)
  self.id = data.id
	self.power = data.rec_power
  self.energy = data.energy
  self.color = qy.tank.model.ClassicBattleModel.color[data.color]

	local cfg = qy.Config.classicbattle[tostring(self.id)]
	self.name = cfg.name
	self.story = cfg.story
	self.battle_img = "classicbattle/"..cfg.battle_img..".jpg"
	self.star = cfg.battle_star

  --[[闪电战：出击！三回合内击败对手！
      突破重围：敌人围剿重重，连续消灭三波敌人方可取得胜利
      坚盾之躯：敌军会集火我方第一辆战车，坚持到最后，消灭全部敌人即可取得胜利
      BOSS战：攻坚！消灭敌方BOSS！]]
  if cfg.play_type == 1 then
    self.typeDes = qy.TextUtil:substitute(7004)
  elseif cfg.play_type == 2 then
    self.typeDes = qy.TextUtil:substitute(7005)
  elseif cfg.play_type == 3 then
    self.typeDes = ""
  elseif cfg.play_type == 4 then
    self.typeDes = qy.TextUtil:substitute(7006)
  elseif cfg.play_type == 5 then
    self.typeDes = qy.TextUtil:substitute(7007)
  end

  self.awards = {}
  for i=1,7 do
    local award = cfg["award"..i]
    if award and #award > 0 then
      table.insert(self.awards,award[1])
    end
  end

  self.awards_show = {}
  for i=1,3 do
    table.insert(self.awards_show,self.awards[i])
  end

end

return ClassicBattleModel

