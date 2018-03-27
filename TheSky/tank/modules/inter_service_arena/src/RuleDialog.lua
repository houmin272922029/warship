local RuleDialog = qy.class("RuleDialog", qy.tank.view.BaseDialog, "inter_service_arena.ui.RuleDialog")


function RuleDialog:ctor(callback)
   	RuleDialog.super.ctor(self)

   	self.model = qy.tank.model.InterServiceArenaModel
    self.service = qy.tank.service.InterServiceArenaService

   	self.style = qy.tank.view.style.DialogStyle1.new({
        size = cc.size(590,530),
        position = cc.p(0,0),
        offset = cc.p(0,0),
        titleUrl = "inter_service_arena/res/guize2.png",
        bgShow = false,

        ["onClose"] = function()
            self:removeSelf()
        end
    })
    self:addChild(self.style)

   	self:InjectView("Text_server_name")
   	self:InjectView("Node_award")
   	self:InjectView("Img_stage")
   	self:InjectView("Img_stage_num")
   	self:InjectView("Img_stage2")
   	self:InjectView("Img_stage_num2")
   	self:InjectView("Text_rank")
   	self:InjectView("Text_rank2")
   	self:InjectView("Text_server_size")
    self:InjectView("Text_date")


    self:OnClick("Btn_close", function()
        self:removeSelf()
    end,{["isScale"] = false})


    function function1()
  		local icon, num = self.model:getStageIcon(self.model.max_stage)
  	    self.Img_stage:loadTexture("inter_service_arena/res/stage_name2_".. icon ..".png",0)
  	    if num and num > 0 then
  	        self.Img_stage_num:setVisible(true)
  	        self.Img_stage_num:loadTexture("inter_service_arena/res/stage_num2_".. num ..".png",0)
  	    else
  	        self.Img_stage_num:setVisible(false)
  	    end

  	    self.Text_rank:setString(qy.TextUtil:substitute(4003, self.model.max_current_rank))
  	end
      
  	function function2()
  		local icon, num = self.model:getStageIcon(self.model.stage_num)
  	    self.Img_stage2:loadTexture("inter_service_arena/res/stage_name2_".. icon ..".png",0)
  	    if num and num > 0 then
  	        self.Img_stage_num2:setVisible(true)
  	        self.Img_stage_num2:loadTexture("inter_service_arena/res/stage_num2_".. num ..".png",0)
  	    else
  	        self.Img_stage_num2:setVisible(false)
  	    end

  	    self.Text_rank2:setString(qy.TextUtil:substitute(4003, self.model.stage_rank))
  	end

  	function1()
  	function2()



  	local txt = ""
  	for i = 1, #self.model.server_list do
  		local server = string.sub(self.model.server_list[i], 2)
  	    txt = txt..server..qy.TextUtil:substitute(90296)

  	    if i < #self.model.server_list then
  	    	txt = txt.. " , "
  	    end
  	end
  	self.Text_server_name:setString(txt)

  	self.Text_server_size:setString(qy.TextUtil:substitute(90302, #self.model.server_list))


  	self.award = qy.AwardList.new({
          ["award"] = self.model:getEndAwardByStage()["award"],
          ["cellSize"] = cc.size(110,180),
          ["type"] = 1,
          ["itemSize"] = 2,
          ["len"] = 4,
          ["hasName"] = false,
    })
    self.award:setPosition(50,230)
    self.Node_award:addChild(self.award)


    self.Text_date:setString(qy.TextUtil:substitute(90306, os.date(qy.TextUtil:substitute(1012), self.model.start_time) .."-" .. os.date(qy.TextUtil:substitute(1012), self.model.end_time)))

end

return RuleDialog
