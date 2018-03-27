local ContinuousChallengeDialog = qy.class("ContinuousChallengeDialog", qy.tank.view.BaseDialog, "inter_service_arena.ui.ContinuousChallengeDialog")

--data2 防守方排位信息
function ContinuousChallengeDialog:ctor(data)
   	ContinuousChallengeDialog.super.ctor(self)

    self.model = qy.tank.model.InterServiceArenaModel
    self.service = qy.tank.service.InterServiceArenaService

    self:InjectView("bg")
    self:InjectView("Img_user_icon1")
    self:InjectView("Img_user_icon2")
    self:InjectView("Text_user_name1")
    self:InjectView("Text_user_name2")
    self:InjectView("Text_power1")
    self:InjectView("Text_power2")
    self:InjectView("Img_stage")
    self:InjectView("Img_stage_num")
    self:InjectView("Text_rank")
    self:InjectView("Text_consume")
    self:InjectView("Btn_again")
    self:InjectView("Btn_close")
    self:InjectView("Btn_close2")
    self:InjectView("Img_challenge5")

    self.data = data
    self.flag = false


    self:OnClick("Btn_close", function()
        self:dismiss()
    end,{["isScale"] = false})

    self:OnClick("Btn_close2", function()
        self:dismiss()
    end,{["isScale"] = false})

    self:OnClick("Btn_again", function()
        if self.flag then
            if self.model.times >= 5 then
                self.service:sweep(function(data)
                    self:update()                    
                    self.flag = false
                end, self.data.rank)
            else
                self.service:attendnumserver(function(data)
                    if data.pay then
                        self.service:sweep(function(data)
                            self:update()
                            self.flag = false
                        end, self.data.rank)
                    end
                end, self.model.sweep_need_times)
            end
        end
    end,{["isScale"] = false})


    self:update()
end


function ContinuousChallengeDialog:update()
    local data = self.data
    self.Img_user_icon1:loadTexture(qy.tank.utils.UserResUtil.getRoleIconByHeadType(qy.tank.model.UserInfoModel.userInfoEntity.headicon))
    self.Img_user_icon2:loadTexture(qy.tank.utils.UserResUtil.getRoleIconByHeadType(data.headicon))

    self.Text_user_name1:setString(qy.tank.model.UserInfoModel.userInfoEntity.name)
    self.Text_user_name2:setString(data.nickname)

    self.Text_power1:setString(qy.tank.model.UserInfoModel.userInfoEntity.fightPower)
    self.Text_power2:setString(data.fight_power)

    local icon, num = self.model:getStageIcon()
    self.Img_stage:loadTexture("inter_service_arena/res/stage_name2_".. icon ..".png",0)
    if num and num > 0 then
        self.Img_stage_num:loadTexture("inter_service_arena/res/stage_num2_".. num ..".png",0)
    end

    self.Text_rank:setString(qy.TextUtil:substitute(4003, self.model.stage_rank))
    
    self.Text_consume:setString(self.model.sweep_need_diamond)

    if self.model.sweep_need_times == 0 then
        self.Text_consume:setVisible(false)
        self.Img_challenge5:setVisible(false)
    else
        self.Text_consume:setVisible(true)
        self.Img_challenge5:setVisible(true)
    end

    self.Text_consume:setString(self.model.sweep_need_diamond)


    self.tableMax = 5
    if self.fightTableView~=nil then
        self.bg:removeChild(self.fightTableView )
        self.fightTableView = nil
    end
   
    self:runAutoFight()
end



function ContinuousChallengeDialog:runAutoFight()
    local count = -2;
    self.callBackFunc = function(index)
        if self.fightTableView then
            self.fightTableView:setTouchEnabled(false)
        end

        if(index == -1) then return end
        function scrollTableView()
            local offsetY = self.fightTableView:getContentOffset().y
            if self.tableMax >1 and index <self.tableMax then
                count = count+1
                if(count >0) then
                    self.fightTableView:setContentOffset(cc.p(0,offsetY + 150) , true)
                end
            end

            local cell = self.fightTableView:cellAtIndex(index)

            if(cell==nil) then  
                self.fightTableView:setTouchEnabled(true)
                self.flag = true
                return 
            end
            cell.item:runThisAnimation(index+1)
        end
        self:runAction(cc.Sequence:create(cc.DelayTime:create(0.5) ,cc.CallFunc:create(scrollTableView)))  
    end
    if self.fightTableView == nil then
        self.fightTableView = self:createTableView()
        self.bg:addChild(self.fightTableView)
    end
    self.callBackFunc(0)
    
end

function ContinuousChallengeDialog:createTableView()
    tableView = cc.TableView:create(cc.size(900,300))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setAnchorPoint(0,0)
    tableView:setPosition(5, 15)
    tableView:setDelegate()
    
    local function numberOfCellsInTableView(table)
        return self.tableMax
    end
    
    local function tableCellTouched(table,cell)

    end

    local function cellSizeForTable(tableView, idx)
        return 900, 149
    end

    local function tableCellAtIndex(table, idx)
        local cell = table:dequeueCell()
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("inter_service_arena.src.ContinuousChallengeCell").new(self.callBackFunc)
            cell:addChild(item)
            cell.item = item
        end
        cell.item:render(idx)
       
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    tableView:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    tableView:reloadData()
    return tableView
end


return ContinuousChallengeDialog
