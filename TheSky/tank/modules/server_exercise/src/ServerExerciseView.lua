local ServerExerciseView = qy.class("ServerExerciseView", qy.tank.view.BaseView, "server_exercise/ui/ServerExerciseView")

local model = qy.tank.model.ServerExerciseModel
local service = qy.tank.service.ServerExerciseService

function ServerExerciseView:ctor(delegate)
    ServerExerciseView.super.ctor(self)
    self.delegate = delegate

    local style = qy.tank.view.style.ViewStyle1.new({
        titleUrl = "Resources/activity/title_exercise.png",
        ["onExit"] = function()
            delegate:finish()
        end
    })
    self:addChild(style, 13)

    self:OnClick("helpBtn",function()
        qy.tank.view.common.HelpDialog.new(35):show(true)
    end)
    -- model:init("1")--先放到这
    self:InjectView("IntoBt")--进入
    self:InjectView("checkBt")--预览
    self:InjectView("exitBt")--退赛
    self:InjectView("RankBt")--排行榜
    self:InjectView("icon")--钻石图标加文字
    if model.enterflag  then 
        if model:getstatus() == 100 then
            self.icon:setVisible(true)
        else
            self.icon:setVisible(false)
        end
    else
        self.icon:setVisible(true)
    end
   
    self:OnClick("IntoBt",function()
        if model.enterflag  then 
            if model:getstatus() == 100 then
                local function callBack(flag)
                    if flag == qy.TextUtil:substitute(4012) then
                        service:GoInTo(function()
                            self.icon:setVisible(false)
                            delegate:showScenelistView()
                        end)
                       
                    end
                end
                local image = ccui.ImageView:create()
                image:setContentSize(cc.size(500,120))
                image:setScale9Enabled(true)
                image:loadTexture("Resources/common/bg/c_12.png")

                local image1 = ccui.ImageView:create()
                image1:loadTexture("Resources/common/icon/coin/1a.png")
                image1:setPosition(cc.p(200,60))
                image:addChild(image1)

                local richTxt = ccui.RichText:create()
                richTxt:ignoreContentAdaptWithSize(false)
                richTxt:setContentSize(500, 150)
                richTxt:setAnchorPoint(0,0.5)
                local stringTxt1 = ccui.RichElementText:create(1, cc.c3b(255,255,255), 255, "进入要花费1000      确定要报名吗？", qy.res.FONT_NAME_2, 24)
                richTxt:pushBackElement(stringTxt1)
                image:addChild(richTxt)

                qy.alert:showWithNode(qy.TextUtil:substitute(9004),  image, cc.size(560,250), {{qy.TextUtil:substitute(4011) , 4},{qy.TextUtil:substitute(4012) , 5} }, callBack, {})
                image:setPosition(image:getPositionX() + 5, image:getPositionY() - 30)
            elseif model:getstatus() == 200 then
                 delegate:showScenelistView()
            else
                 qy.hint:show("已退赛，无法再次报名")
            end
        else
            local function callBack(flag)
            if flag == qy.TextUtil:substitute(4012) then
                    service:GoInTo(function()
                        self.icon:setVisible(false)
                        delegate:showScenelistView()
                    end)
                   
                end
            end
            local image = ccui.ImageView:create()
            image:setContentSize(cc.size(500,120))
            image:setScale9Enabled(true)
            image:loadTexture("Resources/common/bg/c_12.png")

            local image1 = ccui.ImageView:create()
            image1:loadTexture("Resources/common/icon/coin/1a.png")
            image1:setPosition(cc.p(200,60))
            image:addChild(image1)

            local richTxt = ccui.RichText:create()
            richTxt:ignoreContentAdaptWithSize(false)
            richTxt:setContentSize(500, 150)
            richTxt:setAnchorPoint(0,0.5)
            local stringTxt1 = ccui.RichElementText:create(1, cc.c3b(255,255,255), 255, "进入要花费1000      确定要报名吗？", qy.res.FONT_NAME_2, 24)
            richTxt:pushBackElement(stringTxt1)
            image:addChild(richTxt)

            qy.alert:showWithNode(qy.TextUtil:substitute(9004),  image, cc.size(560,250), {{qy.TextUtil:substitute(4011) , 4},{qy.TextUtil:substitute(4012) , 5} }, callBack, {})
            image:setPosition(image:getPositionX() + 5, image:getPositionY() - 30)
        end
    end)
    self:OnClick("checkBt",function()
        local node =  require("server_exercise.src.CheckAllView").new()
        node:show()
    end)
    self:OnClick("exitBt",function()
        if model.enterflag then 
            if model:getstatus() == 100 then
                qy.hint:show("您还未报名")
            elseif model:getstatus() == 200 then
                local function callBack(flag)
                    if flag == qy.TextUtil:substitute(70054) then
                       service:Finish(function (  )
                           print("oooooooooooooo")
                       end)
                    end
                end       
                local alertMesg = "手动退赛后会立刻结算当前的钻石，但会清空排名成绩，确定要退赛吗？"
                qy.alert:show({"提示" ,{255,255,255} }  ,  alertMesg , cc.size(450 , 220),{{qy.TextUtil:substitute(70057) , 4}   , {qy.TextUtil:substitute(70054) , 5}} ,callBack,"")
            else
                qy.hint:show("您已经退赛了")
            end
        else
            service:Finish(function (  )
        
            end)
        end
    end)
    self:OnClick("RankBt",function()
        service:GetRanklist(function ( )
            local node =  require("server_exercise.src.RankView").new()
            node:show()
        end)
          
    end)
            


end

return ServerExerciseView