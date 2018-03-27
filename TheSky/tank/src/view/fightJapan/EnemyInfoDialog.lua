--[[
    关卡信息
]]
local EnemyInfoDialog = qy.class("EnemyInfoDialog", qy.tank.view.BaseDialog, "view/garage/EmbattleDialog")

function EnemyInfoDialog:ctor(param)
    EnemyInfoDialog.super.ctor(self)
    qy.tank.utils.cache.CachePoolUtil.addArmatureFile(qy.ResConfig.F_J_GO)

    local style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(916,580),
        position = cc.p(0,0),
        offset = cc.p(0,0),
        titleUrl = "Resources/common/title/enemy_title.png",

        ["onClose"] = function()
            self:dismiss()
        end
    })
    style.bg:loadTexture("Resources/common/bg/deploy_0006.jpg")
    self:addChild(style,-1)

    self.model = qy.tank.model.FightJapanModel
    self.data = param.data
    self.index = param.index
    self:InjectView("panel")
    self:InjectView("titleSp")
    self.posArr = {}

    for i = 1, 6 do
        self:InjectView("p"..i)
        self["p"..i]:loadTexture("Resources/garage/ZC_2.png",1)
        -- self.posArr[7-i] = self["p"..i]
        if i > 3 then
            -- 4->1;5->2;6->3
            self.posArr[i - 3] = self["p"..i]
        else
            -- 1->4;2->5;3->6
            self.posArr[i + 3] = self["p"..i]
        end
    end

    self:InjectView("goBtn")
    -- self:InjectView("circleSp")
    self:InjectView("roleIcon")

    self:OnClick("goBtn", function(sender)
       local service = qy.tank.service.FightJapanService
       local param = {}

       --布阵
        local p = {}
        p.fightJapan = true
        param = nil
        service:getFormation(param,function(data)
            qy.tank.model.FightJapanGarageModel:updateFormation(data)
            qy.tank.command.GarageCommand:showFormationDialog(qy.tank.model.FightJapanGarageModel.formation)
        end)


    end)
    self:updateTankList()
    self:__createUserInfo()
    self._effert = self:createEffert(self.goBtn)
end

function EnemyInfoDialog:__createUserInfo()
    self.userInfo = qy.tank.view.fightJapan.ExUserCell.new({
        ["data"] = self.data
    })
    self.panel:addChild(self.userInfo)
    self.userInfo:setPosition(-353,-190)
end

-- 更新坦克列表
function  EnemyInfoDialog:updateTankList()
    local tankList = self.data.tank
    -- print("%%%%%%%%%%%%", qy.json.encode(self.data.formation))
    local isMonster = self.data:isMonster()
    local count = 0
    if self.data.is_pass == 1 then
        self.goBtn:setVisible(false)
    else
        self.goBtn:setVisible(true)
    end

    for tankUId,tankData in pairs(tankList) do
        -- print("tankUId ==".. tankData.unique_id)
        local tankEntity = nil
        if isMonster == true then
            tankEntity = qy.tank.entity.TankEntity.new(tankData , 5)
        else
            tankEntity = qy.tank.entity.TankEntity.new(tankData)
        end

        local tankImg = qy.tank.view.garage.TankImg.new(tankEntity , 2)
        if self.data.is_pass == 1 then
            tankImg:showBloodAndMorale(true , true)
            tankImg:setStatus(0)
        else
            tankImg:showBloodAndMorale(true , false)
            tankImg:setStatus(1)
            tankImg:updateHp(1, 1)
            tankImg:updateMorale(0 , 4)
        end
        local idx = self.model:getFormationById(tonumber(tankData.unique_id), self.index)
        local posX =  self.posArr[idx]:getPositionX()
        local posY =  self.posArr[idx]:getPositionY() + 13
        tankImg:setPosition(posX,posY)
        self.panel:addChild(tankImg)
    end
end

function EnemyInfoDialog:createEffert(_target)
    _effert = ccs.Armature:create("yuanzhengjiantou")
    _target:addChild(_effert,999)
    _effert:setPosition(170,80)
    _effert:getAnimation():playWithIndex(0)
    return _effert
end

function EnemyInfoDialog:onCleanup()
    qy.tank.utils.cache.CachePoolUtil.removeArmatureFile(qy.ResConfig.F_J_GO)
end

return EnemyInfoDialog
