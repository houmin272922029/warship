

local MainView = qy.class("MainView", qy.tank.view.BaseView, "attack_berlin/ui/MainView")

local model = qy.tank.model.AttackBerlinModel
local service = qy.tank.service.AttackBerlinService

function MainView:ctor(delegate)
    MainView.super.ctor(self)
    local style = qy.tank.view.style.ViewStyle1.new({
        titleUrl = "attack_berlin/res/weigongbolin.png",
        ["onExit"] = function()
            model:initdata()
            delegate:finish()
        end
    })
    self:addChild(style, 13)
    self.delegate = delegate
    self:InjectView("helpBt")
    self:InjectView("Text_1")--难度
    self:InjectView("chatBt")
    self:InjectView("awardBt")
    self:InjectView("ScrollView")
    self:InjectView("mainbg")
    self.ScrollView:setScrollBarEnabled(false)

    self:OnClick("helpBt",function()
        qy.tank.view.common.HelpDialog.new(50):show(true)
    end)
    self:OnClick("chatBt", function(sender)
       local ChatController = require("module.chat.Controller")
        ChatController:startController(ChatController.new())
    end)
    self:OnClick("awardBt", function(sender)
        service:checkAward(function (  )
             require("attack_berlin.src.LegionAwardDIalog"):new():show()
        end)
        
    end)
    self.ScrollView:setContentSize(qy.winSize.width, qy.winSize.height)
    self.delegate = delegate
    self:updateChapter()
end
function MainView:updateChapter(  )
    local data = {}
    self.mainbg:removeAllChildren(true)
    if model.difficuty == 1 then
        self.Text_1:setString("简单")
        self.Text_1:setColor(cc.c3b(255, 255, 255))
        data = model.checkpointlist1
    elseif model.difficuty == 2 then
        self.Text_1:setString("困难")
        self.Text_1:setColor(cc.c3b(255, 153, 0))
        data = model.checkpointlist2
    else
        self.Text_1:setString("炼狱")
        self.Text_1:setColor(cc.c3b(251, 48, 0))
        data = model.checkpointlist3
    end
    for i=1,#data do
        local types = data[i].difficulty
        -- print("+++++++++++++",json.encode(data[i]))
        local item = require("attack_berlin.src.Chapter"..tostring(types)).new({
            ["datas"] = data[i],
            ["callback"] = function (  )
                self:updateChapter()
            end,
            ["delegate"] = self.delegate
            })
        item:setPosition(data[i].x , data[i].y)
        self.mainbg:addChild(item)
    end
  
end
function MainView:onEnter()
    self:updateChapter()
    self.listener_1 = qy.Event.add(qy.Event.ATTACKBERLIN2,function(event)
        qy.tank.service.AttackBerlinService:get1(function()
             self:updateChapter()
        end)
    end)   
end
function MainView:onExit()
    qy.Event.remove(self.listener_1)

    self.listener_1 = nil
end
function MainView:onEnterFinish(  )
    local data = {}
    if model.chatinto == 1 then
        if model.difficuty == 1 then
            data = model.checkpointlist1
        elseif model.difficuty == 2 then
            data = model.checkpointlist2
        else
            data = model.checkpointlist3
        end
        local datas = {}
        for k,v in pairs(data) do
            if v.id == model.copy_id then
                datas = v
                break
            end
        end
        local view  = require("attack_berlin.src.GroupBattlesLayer").new({
          ["data"] = datas,
          ["callback"] = function (  )
              self:updateChapter()
          end
        })
        self.delegate:addChild(view)
        model.chatinto = 0
    end  
end

return MainView
