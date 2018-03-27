--[[
	跨服军团战
	Author: 
]]

local AttackView = qy.class("AttackView", qy.tank.view.BaseDialog, "service_legion_war/ui/AttackView")

local userModel = qy.tank.model.UserInfoModel
local service = qy.tank.service.ServiceLegionWarService
local model = qy.tank.model.ServiceLegionWarModel

function AttackView:ctor(delegate)
    AttackView.super.ctor(self)
    self:InjectView("name")
    self:InjectView("listbg")
    self:InjectView("closeBt")
    self:InjectView("totalnum")--弹药储备
    self:InjectView("addbt")
    self:InjectView("sitename")
    self:OnClick("closeBt",function()
        self:dismiss()
    end)
    self:OnClick("addbt",function()
        if model.ammo_store >= 20 then
            qy.hint:show("弹药储备最大为20 ，无需补充")
            return
        end
        if model.buytime >= 3 then
             qy.hint:show("每轮军团战最多购买三次弹药储备")
            return
        end
        self:Buy()
    end)
    self.delegate = delegate
    self.type = delegate.type -- 1代表攻击  2 代表不妨自己军团
    self.num = delegate.totalnum1
    self.id = delegate.id
    self.list = self:createView()
    self.listbg:addChild(self.list)
    self.name:setString(delegate.legionname.."军团")
    self.sitename:setString(model.typeNameList[tostring(self.id)])
    local x = model.ammo_store < 0 and 0 or model.ammo_store
    self.totalnum:setString("当前弹药储备:"..x)
 
end
function AttackView:createView()
    local tableView = cc.TableView:create(cc.size(900, 490))
    tableView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    tableView:setPosition(3, 0)
    tableView:setDelegate()

    local num = self.num
    local function numberOfCellsInTableView(tableView)
        return num/2
    end

    local function tableCellTouched(table, cell)
       
    end
    
    local function cellSizeForTable(tableView, idx)
        return 320, 480
    end

    local function tableCellAtIndex(tableView, idx)
        local cell = tableView:dequeueCell()
        local item = nil
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = require("service_legion_war.src.AttackCell").new({
            	["site"]= self.delegate.site,
            	["id"] = self.delegate.id,
            	["callback"] = function (  )
                    local x = model.ammo_store < 0 and 0 or model.ammo_store
            		self.totalnum:setString("当前弹药储备:"..x)
            		local listCury = self.list:getContentOffset()
                    self.list:reloadData()
                    self.list:setContentOffset(listCury)--设置滚动距离
                    local list = model.site_member
                    local temp = 0
                    for i=1,#list do
                    	if list[i].ammo_store > 0 then
                    		temp = 1
                    		break
                    	end
                    end
                    if temp == 0 then
                    	table.insert(model.passlist,self.delegate.id)
                    	-- print("这是插入后的",json.encode(model.passlist))
                    	self.delegate:callback()
                    end
            	end
            	})
            cell:addChild(item)
            cell.item = item
        end
        cell.item.idx = idx
        cell.item:render(idx+1)
        return cell
    end
    tableView:registerScriptHandler(numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    tableView:registerScriptHandler(cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
    tableView:registerScriptHandler(tableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX)
    tableView:registerScriptHandler(tableCellTouched, cc.TABLECELL_TOUCHED)

    tableView:reloadData()
    return tableView
end
function AttackView:Buy(  )
    local function callBack(flag)
        if flag == qy.TextUtil:substitute(4012) then
            service:Buy(function (  )
                qy.Event.dispatch(qy.Event.LEGION_WAR)
                local x = model.ammo_store < 0 and 0 or model.ammo_store
                self.totalnum:setString("当前弹药储备:"..x)
            end)
        end
    end
    local image = ccui.ImageView:create()
    image:setContentSize(cc.size(500,120))
    image:setScale9Enabled(true)
    image:loadTexture("Resources/common/bg/c_12.png")

    local image1 = ccui.ImageView:create()
    image1:loadTexture("Resources/common/icon/coin/1a.png")
    image1:setPosition(cc.p(138,60))
    image:addChild(image1)

    local richTxt = ccui.RichText:create()
    richTxt:ignoreContentAdaptWithSize(false)
    richTxt:setContentSize(500, 150)
    richTxt:setAnchorPoint(0,0.5)
    local tempnum = 0
    local huafei = 100
    if model.buytime == 1 then
        huafei = 300
    elseif model.buytime == 2 then
        huafei = 500
    end
    local stringTxt1 = ccui.RichElementText:create(1, cc.c3b(255,255,255), 255, "是否要花费      ", qy.res.FONT_NAME_2, 24)
    richTxt:pushBackElement(stringTxt1)
    local stringTxt2 = ccui.RichElementText:create(1, cc.c3b(0,120, 255), 255, huafei, qy.res.FONT_NAME_2, 24)
    richTxt:pushBackElement(stringTxt2)
    local stringTxt3 = ccui.RichElementText:create(1, cc.c3b(255,255,255), 255, "购买", qy.res.FONT_NAME_2, 24)
    richTxt:pushBackElement(stringTxt3)
    local stringTxt3 = ccui.RichElementText:create(1, cc.c3b(255,165,0), 255, "10", qy.res.FONT_NAME_2, 24)
    richTxt:pushBackElement(stringTxt3)
    local stringTxt3 = ccui.RichElementText:create(1, cc.c3b(255,255,255), 255, "点弹药储备？", qy.res.FONT_NAME_2, 24)
    richTxt:pushBackElement(stringTxt3)
      local stringTxt3 = ccui.RichElementText:create(1, cc.c3b(255,15,0), 255, "(弹药储备上限为20点,请谨慎购买)", qy.res.FONT_NAME_2, 24)
    richTxt:pushBackElement(stringTxt3)
    image:addChild(richTxt)

    qy.alert1:showWithNode(qy.TextUtil:substitute(9004),  image, cc.size(560,250), {{qy.TextUtil:substitute(4011) , 4},{qy.TextUtil:substitute(4012) , 5} }, callBack, {})
    image:setPosition(image:getPositionX() + 5, image:getPositionY() - 30)
end
function AttackView:onEnter()
  
end

function AttackView:onExit()
    
end

return AttackView
