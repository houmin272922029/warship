MUSIC_EFFECT_0 = "audio/sound101.mp3"
MUSIC_EFFECT_1 = "audio/sound102.mp3"
MUSIC_EFFECT_2 = "audio/sound103.mp3"
MUSIC_EFFECT_3 = "audio/sound104.mp3"
MUSIC_EFFECT_4 = "audio/sound105.mp3"
MUSIC_EFFECT_5 = "audio/sound105.mp3"
MUSIC_EFFECT_6 = "audio/sound106.mp3"
MUSIC_EFFECT_7 = "audio/sound110.mp3"
MUSIC_EFFECT_8 = "audio/sound111.mp3"
MUSIC_EFFECT_9 = "audio/sound112.mp3"
MUSIC_SOUND_0 = "audio/sound001.mp3"
MUSIC_SOUND_1 = "audio/sound002.mp3"
MUSIC_SOUND_2 = "audio/sound003.mp3"
MUSIC_SOUND_3 = "audio/sound004.mp3"
MUSIC_SOUND_4 = "audio/sound005.mp3"

MUSIC_SOUND_FIGHT_BG = "audio/sound005.mp3"
MUSIC_SOUND_FIGHT_NEWPLAYER = "audio/sound003.mp3"
MUSIC_SOUND_FIGHT_LEVELUP = "audio/sound127.mp3"
MUSIC_SOUND_FIGHT_WIN = "audio/sound124.mp3"
MUSIC_SOUND_FIGHT_LOSE = "audio/sound125.mp3"
MUSIC_SOUND_FIGHT_ROUND = "audio/sound126.mp3"
MUSIC_SOUND_FIGHT_BUFF = "audio/sound110.mp3"
MUSIC_SOUND_FIGHT_SMALLSKILL = "audio/sound128.mp3"
MUSIC_SOUND_FIGHT_ANIMATION = "audio/sound003.mp3"
MUSIC_SOUND_DIALOGUE_1 = "audio/sound130.mp3"
MUSIC_SOUND_DIALOGUE_2 = "audio/sound131.mp3"
MUSIC_SOUND_DIALOGUE_3 = "audio/sound132.mp3"
MUSIC_SOUND_WEAPON_REFINE = "audio/sound102.mp3"
MUSIC_SOUND_BOOK_EQUIP = "audio/sound103.mp3"
MUSIC_SOUND_CURRENCY = "audio/sound111.mp3"
MUSIC_SOUND_WEAPON_CHANGE = "audio/sound112.mp3"
MUSIC_SOUND_OPANI_1 = "audio/sound130.mp3"
MUSIC_SOUND_OPANI_2 = "audio/sound131.mp3"
MUSIC_SOUND_OPANI_3 = "audio/sound132.mp3"

MUSIC_SOUND_TOUCH = "audio/sound133.mp3"
MUSIC_SOUND_LOGUETOWN = "audio/sound134.mp3"

MUSIC_SOUND_DAILY_MERMAN = "audio/sound135.mp3"
MUSIC_SOUND_DAILY_BLUCK = "audio/sound136.mp3"
MUSIC_SOUND_DAILY_INSTRUCT = "audio/sound137.mp3"
MUSIC_SOUND_DAILY_EAT = "audio/sound138.mp3"
MUSIC_SOUND_DAILY_ROBIN = "audio/sound139.mp3"
MUSIC_SOUND_DAILY_GOLDBELL = "audio/sound140.mp3"
MUSIC_SOUND_DAILY_LEVELUP = "audio/sound141.mp3"

MUSIC_SOUND_WORLDWOR_MAINLAYER = "audio/war001.mp3"
MUSIC_SOUND_WORLDWOR_ISLAND = "audio/war002.mp3"

-- 加载音效
local function preloadEffect(effect)
    SimpleAudioEngine:sharedEngine():preloadEffect(effect)
end

-- 加载音乐
local function preloadMusic(music)
    SimpleAudioEngine:sharedEngine():preloadBackgroundMusic(music);
end

-- 预加载
function preloadEffectMusic()
    print("--------------preload effect")

    -- 音效
    preloadEffect(MUSIC_EFFECT_0)
    preloadEffect(MUSIC_EFFECT_1)
    preloadEffect(MUSIC_EFFECT_2)
    preloadEffect(MUSIC_EFFECT_3)
    preloadEffect(MUSIC_EFFECT_4)
    preloadEffect(MUSIC_EFFECT_5)
    preloadEffect(MUSIC_EFFECT_6)
    preloadEffect(MUSIC_EFFECT_7)
    preloadEffect(MUSIC_EFFECT_8)
    preloadEffect(MUSIC_EFFECT_9)
    
    -- 音乐
    preloadMusic(MUSIC_SOUND_0)
    preloadMusic(MUSIC_SOUND_1)
    preloadMusic(MUSIC_SOUND_2)
    preloadMusic(MUSIC_SOUND_3)
    preloadMusic(MUSIC_SOUND_4)
end


-- 播放音效
function playEffect(effect)
    if getUDBool(UDefKey.Setting_PlayMusicEffect, true) then
        SimpleAudioEngine:sharedEngine():playEffect(effect)
    end
end

-- 播放音乐
function playMusic(music, loop)
    -- 不重复播放 音乐判断
    --[[
    if musicTypeTemp == musicType then
        return
    end
    --]]
    if not getUDBool(UDefKey.Setting_PlayMusicSound, true) then
        return
    end

    SimpleAudioEngine:sharedEngine():stopBackgroundMusic()

    if not music then
        return
    end

    SimpleAudioEngine:sharedEngine():playBackgroundMusic(music, loop)
end

function stopMusic()
    SimpleAudioEngine:sharedEngine():stopBackgroundMusic()
end