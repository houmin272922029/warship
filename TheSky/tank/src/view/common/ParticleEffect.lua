--[[
    粒子效果
]]
local ParticleEffect = qy.class("ParticleEffect")

--下雪
function ParticleEffect:showSnow(conttainer , num)
    if num ==nil then num = 100 end
    local snow = cc.ParticleSnow:create()
    local texture = cc.Sprite:create("Resources/common/particle/2.png"):getTexture()

    snow:setTexture(texture)

    snow:setPosition(qy.winSize.width/2 , qy.winSize.height)
    snow:setTotalParticles(num)
    conttainer:addChild(snow)

    return snow
end

--流星
function ParticleEffect:showMeteor(conttainer, num, url)
    if num ==nil then num = 100 end
    if url == nil then
        url = "Resources/common/particle/2.png"
    end
    local snow = cc.ParticleMeteor:create()
    local texture = cc.Sprite:create(url):getTexture()

    snow:setTexture(texture)

    --snow:setPosition(qy.winSize.width/2 , qy.winSize.height - 100)
    snow:setTotalParticles(num)
    conttainer:addChild(snow)
    return snow
end

--烟
function ParticleEffect:showSmoke(conttainer , num)
    if num ==nil then num = 100 end
    local snow = cc.ParticleSmoke:create()
    local texture = cc.Sprite:create("Resources/common/particle/2.png"):getTexture()

    snow:setTexture(texture)

    snow:setPosition(qy.winSize.width/2 , qy.winSize.height/2)
    snow:setTotalParticles(num)
    conttainer:addChild(snow)
end

--爆炸
function ParticleEffect:showExplosion(conttainer , num)
    if num ==nil then num = 500 end
    local snow = cc.ParticleExplosion:create()
    local texture = cc.Sprite:create("Resources/common/particle/2.png"):getTexture()

    snow:setTexture(texture)

    snow:setPosition(qy.winSize.width - 200 , qy.winSize.height/2)
    snow:setTotalParticles(num)
    conttainer:addChild(snow)
end

--火焰
function ParticleEffect:showFire(conttainer , num)
    if num ==nil then num = 100 end
    local snow = cc.ParticleFire:create()
    local texture = cc.Sprite:create("Resources/common/particle/2.png"):getTexture()

    snow:setTexture(texture)

    snow:setPosition(qy.winSize.width - 200 , qy.winSize.height/2)
    snow:setTotalParticles(num)
    conttainer:addChild(snow)
end

--烟花效果
function ParticleEffect:showFireworks(conttainer , num)
    if num ==nil then num = 100 end
    local snow = cc.ParticleFireworks:create()
    local texture = cc.Sprite:create("Resources/common/particle/2.png"):getTexture()

    snow:setTexture(texture)

    snow:setPosition(200 , qy.winSize.height/2)
    snow:setTotalParticles(num)
    conttainer:addChild(snow)
end

--花粒效果
function ParticleEffect:showFlower(conttainer , num)
    if num ==nil then num = 100 end
    local snow = cc.ParticleFlower:create()
    local texture = cc.Sprite:create("Resources/common/particle/2.png"):getTexture()

    snow:setTexture(texture)

    snow:setPosition(200 ,200)
    snow:setTotalParticles(num)
    conttainer:addChild(snow)
end

--花粒效果
function ParticleEffect:showGalaxy(conttainer , num)
    if num ==nil then num = 100 end
    local snow = cc.ParticleGalaxy:create()
    local texture = cc.Sprite:create("Resources/common/particle/2.png"):getTexture()

    snow:setTexture(texture)

    snow:setPosition(100 ,150)
    snow:setTotalParticles(num)
    conttainer:addChild(snow)
end

--漩涡效果
function ParticleEffect:showSpiral(conttainer , num)
    if num ==nil then num = 100 end
    local snow = cc.ParticleSpiral:create()
    local texture = cc.Sprite:create("Resources/common/particle/2.png"):getTexture()

    snow:setTexture(texture)

    snow:setPosition(100 ,300)
    snow:setTotalParticles(num)
    conttainer:addChild(snow)
end

--太阳效果
function ParticleEffect:showSun(conttainer , num)
    if num ==nil then num = 100 end
    local snow = cc.ParticleSun:create()
    local texture = cc.Sprite:create("Resources/common/particle/2.png"):getTexture()

    snow:setTexture(texture)

    snow:setPosition(qy.winSize.width - 100 ,300)
    snow:setTotalParticles(num)
    conttainer:addChild(snow)
end
--雨效果
function ParticleEffect:showRain(conttainer , num)
    if num ==nil then num = 100 end
    local snow = cc.ParticleRain:create()
    local texture = cc.Sprite:create("Resources/common/particle/2.png"):getTexture()

    snow:setTexture(texture)

    snow:setPosition(qy.winSize.width/2 , qy.winSize.height - 100)

    snow:setTotalParticles(num)
    conttainer:addChild(snow)
    return snow
end

return ParticleEffect
