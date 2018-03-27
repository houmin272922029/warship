--声音type
local SoundType = {}
--使用：qy.QYPlaySound.playEffect(qy.SoundType.INVADE)

--[[--音效--]]--
SoundType.CHANNEL_2_TIPS = "sound/channel_2_tips.mp3"--2号频道提示
SoundType.BTN_CLOSE = "sound/close_click.mp3"--关闭按钮
SoundType.COMMON_CLICK = "sound/common_click.mp3"--通用按钮点击
SoundType.SUPPLY_CLICK_TIPS = "sound/supply_click_tips.mp3"--补给
SoundType.EQUIP_STRENGTH = "sound/equip_strength_tips.mp3"--装备强化
SoundType.TANK_UPGRADE = "sound/tank_upgrade.mp3"--坦克升级
SoundType.SWITCH_CHAPTER = "sound/switch_chapter.mp3"--切换章节
SoundType.SWITCH_CHECKPOINT = "sound/switch_checkpoint.mp3"--切换关卡
SoundType.SWITCH_TAB = "sound/switch_tab.mp3"--切换tab
SoundType.TECH_UPGRADE = "sound/technology_upgrade.mp3"--科技升级
SoundType.SALE = "sound/storage_sale.mp3"--出售
SoundType.SWITCH_TANK = "sound/switch_tank_list.mp3"--坦克列表切换
SoundType.INVADE = "sound/invade.mp3"--伞兵入侵
SoundType.ROLE_UP = "sound/role_upgrade.mp3"--主角升级

-- SoundType.LOADING = "sound/loading.mp3"--loading
SoundType.CLICK_BUILDING = "sound/click_building.mp3"--点击建筑物
SoundType.OPEN_MENU = "sound/open_menu.mp3"--开菜单
SoundType.CLOSE_MENU = "sound/close_menu.mp3"--关菜单
SoundType.CLICK_BATTLE = "sound/click_battle.mp3"--点击战役按钮
SoundType.GET_AWARD = "sound/get_award.mp3"--获得物资
SoundType.CAMP_FLAG = "sound/campaign_flag.mp3"--关卡旗子掉落
SoundType.FORMATION_CHANGE = "sound/formation_change.mp3"--改变阵位

--战斗音效
SoundType.SKILL_1 = "sound/dz_fx_1.mp3"--技能大招1
SoundType.SKILL_2 = "sound/dz_fx_2.mp3"--技能大招2
SoundType.SKILL_3 = "sound/dz_fx_3.mp3"--技能大招3
SoundType.SKILL_4 = "sound/dz_fx_4.mp3"--技能大招4

SoundType.BATTEL_BEGAN = "sound/battle_began.mp3"--战斗开始(战斗标题碰撞的声效)
SoundType.BATTEL_WIN = "sound/battle_win.mp3"--战斗胜利
SoundType.TANK_DEATH = "sound/tank_death.mp3"--坦克死亡(双方)
SoundType.TANK_HIT = "sound/tank_hit.mp3"--坦克受击(双方)
SoundType.T_FIRE = "sound/tank_fire_1.mp3"--坦克开火1
SoundType.T_FIRE_2 = "sound/tank_fire_2.mp3"--坦克开火2
SoundType.T_MOVE = "sound/tank_move.mp3"--坦克移动

--[[--音乐--]]--
SoundType.EXPEDI_BG_MS = "sound/expedition_background_music.mp3"--远征背景音乐
SoundType.M_W_BG_MS = "sound/bg_m_mainView.mp3"--主城背景音乐
SoundType.CAMP_BG_MS = "sound/bg_m_campaign.mp3"--章节音乐

--战斗音乐
SoundType.BATTLE_BG_MS = "sound/bg_m_battle.mp3"--战斗音乐
SoundType.BATTLE_W_BG_MS = "sound/bg_m_battle_win.mp3"--战斗胜利
return SoundType
