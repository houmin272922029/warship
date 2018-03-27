local MainDialog = qy.class("MainDialog", qy.tank.view.BaseView, "quiz/ui/MainDialog")

local model = qy.tank.model.OperatingActivitiesModel
local service = qy.tank.service.OperatingActivitiesService

function MainDialog:ctor(delegate)
   	MainDialog.super.ctor(self)
    
    self:addChild(qy.tank.view.style.ViewStyle1.new({
        ["onExit"] = function()
            delegate.dismiss()
        end,
        ["titleUrl"] = "Resources/common/title/zhishijingsai.png",
    }))
    self:InjectView("Time")
    for i=1,10 do
    	self:InjectView("cell" .. i)
    	self:InjectView("Name" .. i)
    	self:InjectView("Score" .. i)
    end
    for i=1,3 do
    	self:InjectView("AnswerBtn" .. i)
    	self:InjectView("answer" .. i)
    end
    self:InjectView("Button_3")
    self:InjectView("endSprite")
    self:InjectView("bottomDes")
    self:InjectView("LeftNum")
    self:InjectView("Des")
    self:InjectView("Des_0")
    self:InjectView("startTitle")
    self:InjectView("endTitle")
    self:InjectView("TipNum")
    self:InjectView("rank")
    self:InjectView("score")
    self:InjectView("bg1")
    self:InjectView("bg2")


    self:refreshLayer()

    self:OnClick("Button_3", function()
        service:getStartQuiz(
            100,nil,nil,function(reData)
                if qy.tank.model.UserInfoModel.serverTime > model.quizCurBeginTime and qy.tank.model.UserInfoModel.serverTime < model.quizCurEndTime then
                    self:refreshLayer()
                elseif qy.tank.model.UserInfoModel.serverTime > model.quizCurEndTime then
                    if model.quizStatus ~= 300 then
                        qy.hint:show(qy.TextUtil:substitute(90021))
                    end
                elseif qy.tank.model.UserInfoModel.serverTime < model.quizCurBeginTime then
                    qy.hint:show(qy.TextUtil:substitute(90022))
                end
        end)
        
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})

    self:OnClick("AnswerBtn1", function()
        self:showBtnEffect(1)
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})
    self:OnClick("AnswerBtn2", function()
        self:showBtnEffect(2)
        
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})
    self:OnClick("AnswerBtn3", function()
        self:showBtnEffect(3)
    end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})

end

function MainDialog:showBtnEffect(idx)
    self["AnswerBtn"..idx]:runAction(cc.Sequence:create(
        cc.CallFunc:create(function()
            for i=1,3 do
                self["AnswerBtn"..i]:loadTextureDisabled("quiz/res/6.png")
                self["AnswerBtn"..i]:setScale9Enabled(true)
                self["AnswerBtn"..i]:setCapInsets(cc.rect(15,11,100,66))
                self["AnswerBtn"..i]:ignoreContentAdaptWithSize(false)
                layout = ccui.LayoutComponent:bindLayoutComponent(self["AnswerBtn"..i])
                layout:setSize(cc.size(510, 88))
            end

            local curTitleid = self.curTitleid
            if curTitleid then
                local answer = tonumber(string.sub(model.quizList[curTitleid].correct, -1)) 

                self["AnswerBtn"..answer]:loadTextureDisabled("quiz/res/7.png")
                self["AnswerBtn"..answer]:setScale9Enabled(true)
                self["AnswerBtn"..answer]:setCapInsets(cc.rect(15,11,100,66))
                self["AnswerBtn"..answer]:ignoreContentAdaptWithSize(false)
                layout = ccui.LayoutComponent:bindLayoutComponent(self["AnswerBtn"..answer])
                layout:setSize(cc.size(510, 88))

                if answer == idx then
                    qy.hint:show(qy.TextUtil:substitute(90023))
                else
                    qy.hint:show(qy.TextUtil:substitute(90024))
                    self["AnswerBtn"..tonumber(idx)]:loadTextureDisabled("quiz/res/8.png")
                    self["AnswerBtn"..tonumber(idx)]:setScale9Enabled(true)
                    self["AnswerBtn"..tonumber(idx)]:setCapInsets(cc.rect(15,11,100,66))
                    self["AnswerBtn"..tonumber(idx)]:ignoreContentAdaptWithSize(false)
                    layout = ccui.LayoutComponent:bindLayoutComponent(self["AnswerBtn"..tonumber(idx)])
                    layout:setSize(cc.size(510, 88))
                end
                for i=1,3 do
                    self["AnswerBtn"..i]:setEnabled(false)
                end
            else
                qy.hint:show(qy.TextUtil:substitute(90025))
            end
        end),cc.DelayTime:create(0.5), cc.CallFunc:create(function()
            for i=1,3 do
                self["AnswerBtn"..i]:loadTextureNormal("quiz/res/6.png")
                self["AnswerBtn"..i]:loadTextureNormal("quiz/res/6.png")
                self["AnswerBtn"..i]:loadTextureDisabled("quiz/res/6.png",0)
                self["AnswerBtn"..i]:setScale9Enabled(true)
                self["AnswerBtn"..i]:setCapInsets(cc.rect(15,11,100,66))
                self["AnswerBtn"..i]:ignoreContentAdaptWithSize(false)
                layout = ccui.LayoutComponent:bindLayoutComponent(self["AnswerBtn"..i])
                layout:setSize(cc.size(510, 88))
                self["AnswerBtn"..i]:setEnabled(true)
            end
            if model.quizTitleId then
                service:getStartQuiz(
                    200,model.quizTitleId,("answer"..idx),function(reData)
                        self:refreshLayer()
                end)
            else
                qy.hint:show(qy.TextUtil:substitute(90025))
            end
    end)))
end
function MainDialog:refreshLayer()
    if model.quizAward and model.quizAward ~= nil then
        qy.tank.view.quiz.ShowAward.new():show(true)
    end

	if table.nums(model.quizRankList) > 0 then
		self.bg2:setVisible(true)
		for i=1, 10 do
			self["cell"..i]:setVisible(i <= table.nums(model.quizRankList))
		end
        local x = 0
		for k,v in pairs(model.quizRankList) do
            x = x + 1
            self["Name"..x]:setString(v.nickname)
            self["Score"..x]:setString(v.score)
		end
	else
		self.bg2:setVisible(false)
	end

    self.startTitle:setVisible(model.quizStatus == 100)
    self.TipNum:setVisible(model.quizStatus == 200)
    self.endTitle:setVisible(model.quizStatus == 300)
    self.LeftNum:setVisible(model.quizStatus == 200)
    self.endSprite:setVisible(model.quizStatus == 300)
    self.AnswerBtn1:setVisible(model.quizStatus == 200)
    self.AnswerBtn2:setVisible(model.quizStatus == 200)
    self.AnswerBtn3:setVisible(model.quizStatus == 200)
    self.Button_3:setVisible(model.quizStatus == 100)
    self.Des_0:setVisible(model.quizStatus == 300)
    self.Des:setVisible(model.quizStatus ~= 300)
    self.bottomDes:setVisible(model.quizStatus ~= 200)
    self.score:setString(model.quizCurScore or 0)
    if model.quizRank then
        self.rank:setString(model.quizRank<=10 and model.quizRank or qy.TextUtil:substitute(90026))
    else
        self.rank:setString(qy.TextUtil:substitute(90026))
    end
    if model.quizStatus == 100 then
        self.Des:setString(qy.TextUtil:substitute(90027))
    elseif model.quizStatus == 200 then
        self.LeftNum:setString(qy.TextUtil:substitute(90037)..(20 - model.quizTotal - 1))
        self.TipNum:setString(qy.TextUtil:substitute(90038,(model.quizTotal + 1)))
        local curTitleid = model.quizTitleId
        self.curTitleid = curTitleid
        self.Des:setString(model.quizList[curTitleid].question)
        self.answer1:setString(model.quizList[curTitleid].answer1)
        self.answer2:setString(model.quizList[curTitleid].answer2)
        self.answer3:setString(model.quizList[curTitleid].answer3) 
    elseif  model.quizStatus == 300 then
        self.Des:setString(qy.TextUtil:substitute(90028))
    end

end

function MainDialog:onEnter()
    self.Time:setString(qy.tank.utils.NumberUtil.secondsToTimeStr(model.quizEndTime - qy.tank.model.UserInfoModel.serverTime, 8)) 
    self.listener_1 = qy.Event.add(qy.Event.BONUS_TIME,function(event)
        self.Time:setString(qy.tank.utils.NumberUtil.secondsToTimeStr(model.quizEndTime - qy.tank.model.UserInfoModel.serverTime, 8))
        
    end)
end

function MainDialog:onExit()
    qy.Event.remove(self.listener_1)
end

return MainDialog
