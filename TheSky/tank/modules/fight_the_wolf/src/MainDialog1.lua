--[[
	战狼归来
	
]]

local MainDialog1 = qy.class("RushPurchaseDialog", qy.tank.view.BaseDialog, "fight_the_wolf.ui.MainDialog1")

function MainDialog1:ctor(index,delegate)--index是从MainDialog传过来的那个i
    MainDialog1.super.ctor(self)
    self:InjectView("Title")
    self:InjectView("Image_1")
    self:InjectView("Close")
    self:InjectView("Panel_2")
    self:InjectView("Text_award")
    self:InjectView("Lingqubtn")

    --触摸dialog以外退出
    --self:setCanceledOnTouchOutside(true)
    self.model = require("fight_the_wolf.src.Model")
    self.service = require("fight_the_wolf.src.Service")
    --刷新拿到的奖励在主界面上的显示
    userInfoModel = qy.tank.model.UserInfoModel
    self.index = index
    --self.userInfo = qy.tank.model.UserInfoModel

    
    --拿到model中返回的六条数据
    self.data = self.model:getChapterByid(self.index)
    --self.data={{},{},{},{},{},{}}
   
    --改变标题
    for i=1,6 do
        if self.index==i then
            self.Title:loadTexture("fight_the_wolf/res/ftw"..i..".png",0)
        end
    end
    --点击领奖
    self:OnClick("Lingqubtn", function()
         local function callBack(flag)
                if qy.TextUtil:substitute(37011) == flag then
                  --走领奖操作  
                   self.service:getAward1(self.index,2,function(response) 
                    print("领奖完了")
                    --显示恭喜获得奖励
                    qy.tank.command.AwardCommand:add(self.model.awardlist[tostring(self.index)])
                    qy.tank.command.AwardCommand:show(self.model.awardlist[tostring(self.index)])
                    userInfoModel:updateUserInfo(response.data.award)
                    self.Lingqubtn:setTouchEnabled(false)
                    self.Lingqubtn:setBright(false)
                    print("回调函数",self.index)
                    delegate.Callback(self.index)
                    end)
                end
         end
            qy.alert:show(qy.TextUtil:substitute(37032),  "领取后将无法继续攻打本关卡，确认领取?", 
            cc.size(560,250), {{qy.TextUtil:substitute(37015) , 4},
            {qy.TextUtil:substitute(37011) , 5} }, callBack, {})
    
    end)

    --设置领取按钮在被领取过后是灰色的
    local received = self.model.extendsdata
    if received~=nil then             
        for i=0,#received do
             if tonumber(self.index)==tonumber(i) then
                self.Lingqubtn:setTouchEnabled(false)
                self.Lingqubtn:setBright(false)
             else
                print("error---received的数据")
             end
        end
    end 

    --滑动事件
    self.Panel_2:removeAllChildren()
    self.Panel_2:addChild(self:createView())
    self:render()
   
    --关闭当前页面
	self:OnClick("Close", function()       
        self:removeSelf()
    end,{["audioType"] = qy.SoundType.COMMON_CLICK, ["isScale"] = false})	
end
--显示所能领取的奖励
function MainDialog1:render()
   

    self.Image_1:removeAllChildren(true)
    local status = self.model:getStatusBy(self.index)   
    self.Text_award:setVisible(tonumber(status)==0)         
    local data=self.model.awardlist[tostring(self.index)]    
    if data ~=nil then
        for i=1,#data do            
         local item = qy.tank.view.common.AwardItem.createAwardView(data[i] ,1)

           self.Image_1:addChild(item)
           item:setPosition(-50 + 100 * i, 50)
           item:setScale(0.8)
           item.fatherSprite:setSwallowTouches(false)
           item.name:setVisible(false)
        end
    else
        print("error======data数据为空")
    end
end

--创建列表item
function MainDialog1:createView()
    local tableView = cc.TableView:create(cc.size(640, 320))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    --tableView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    -- tableView:setSwallowTouches(false)
    tableView:setTouchEnabled(true)
    tableView:setPosition(1,1)   
    local function numberOfCellsInTableView(tableView)       
        return #self.data
    end

    local function cellSizeForTable(tableView,idx)       
        return 631,150
    end

    local function tableCellAtIndex(tableView, idx)
       
        local cell = tableView:dequeueCell()
        local item = nil
        local label = nil

        -- local data = model:getList(idx)
        -- local height = model:getHeight(idx)
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("fight_the_wolf.src.ItemView").new({
                ["callback"] = function (  )
                    self:render()
                    local listCury = self.tableView:getContentOffset()
                    self.tableView:reloadData()
                    self.tableView:setContentOffset(listCury)--设置滚动距离
                end
                })
            cell:addChild(item)
            cell.item = item
        end
        --idx是从0开始的
        cell.item:render(self.data[idx + 1],idx + 1)        
        return cell
    end

    tableView:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)  
    tableView:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
    
    tableView:reloadData()
    self.tableView = tableView
    return tableView
end
--在战斗结束的时候会再一次的调用这个方法
function MainDialog1:onEnter()
    print("MainDialog1onEnter")
   self:render()   
end

return MainDialog1

