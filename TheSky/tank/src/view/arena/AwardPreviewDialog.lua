--[[
	奖励预览
	Author: Aaron Wei
	Date: 2015-11-10 15:06:12
]]

local AwardPreviewDialog = qy.class("AwardPreviewDialog", qy.tank.view.BaseDialog,"view/arena/AwardPreviewDialog")

function AwardPreviewDialog:ctor()
	AwardPreviewDialog.super.ctor(self)
	self:setCanceledOnTouchOutside(true)
	-- 通用弹窗样式
    local style = qy.tank.view.style.DialogStyle5.new({
        size = cc.size(896,587),
        position = cc.p(0,0),
        offset = cc.p(0,0),
        -- ["onClose"] = function()
        --     self:dismiss()
        -- end
    })
    self:addChild(style,-1)

    self.model = qy.tank.model.ArenaModel
    self:InjectView("panel")

    local px,py = -320,310
    self.richTxt1 = ccui.RichText:create()
    self.richTxt1:setAnchorPoint(0,1)
    self.richTxt1:ignoreContentAdaptWithSize(false)
    self.richTxt1:setContentSize(700,50)
    self.panel:addChild(self.richTxt1)
   	self.richTxt1:setPosition(px,py)

    self.richTxt2 = ccui.RichText:create()
    self.richTxt2:setAnchorPoint(0,1)
    self.richTxt2:ignoreContentAdaptWithSize(false)
    self.richTxt2:setContentSize(700,50)
    self.panel:addChild(self.richTxt2)
   	self.richTxt2:setPosition(px,py-40)

    local label1 = cc.Label:createWithTTF(qy.TextUtil:substitute(4018),qy.res.FONT_NAME, qy.InternationalUtil:getLabel1FontSize(),cc.size(0,0),1)
    label1:setAnchorPoint(0,1)
    label1:setTextColor(cc.c4b(254, 228, 144,255))
    -- label1:enableShadow(cc.c4b(0,0,0),cc.size(-2,-2),0)
 	label1:enableOutline(cc.c4b(0,0,0),1)
    label1:setPosition(px, py - qy.InternationalUtil:getLabel1Height())
    self.panel:addChild(label1)

    local label2 = cc.Label:createWithTTF(qy.TextUtil:substitute(4019),qy.res.FONT_NAME, qy.InternationalUtil:getLabel1FontSize(),cc.size(0,0),1)
    label2:setAnchorPoint(0,1)
    label2:setTextColor(cc.c4b(254, 228, 144,255))
    label2:enableOutline(cc.c4b(0,0,0),1)
    label2:setPosition(px,py-130)
    self.panel:addChild(label2)
end

function AwardPreviewDialog:onEnter()
    local rank = self.model.rank
    local max_rank = self.model.max_rank
	local my_awards

	for i=1,15 do
        if self.model.awardList[i].max_rank>0 then
            if rank <= self.model.awardList[i].max_rank and rank >= self.model.awardList[i].min_rank then
                my_awards = self.model.awardList[i].award
                break
            end
        else
            my_awards = self.model.awardList[i].award
			break
		end
	end

	local txt1 = {
		{font=qy.res.FONT_NAME,size=qy.InternationalUtil:getAwardPreviewDialogFontSize(),color=cc.c3b(255,242,207),text=qy.TextUtil:substitute(4020)},
		{font=qy.res.FONT_NAME,size=qy.InternationalUtil:getAwardPreviewDialogFontSize(),color=cc.c3b(255,136,0),text=qy.TextUtil:substitute(4021,tostring(rank))},
		{font=qy.res.FONT_NAME,size=qy.InternationalUtil:getAwardPreviewDialogFontSize(),color=cc.c3b(255,242,207),text=qy.TextUtil:substitute(4023)},
		-- {font=qy.res.FONT_NAME,size=24,color=cc.c3b(255,242,207),text=tostring(my_awards[1].num)},
		-- {img=qy.tank.utils.AwardUtils.getAwardIconByType(my_awards[1].type,my_awards[1].id)},
		-- {font=qy.res.FONT_NAME,size=24,color=cc.c3b(255,242,207),text=tostring(my_awards[2].num)},
		-- {img="Resources/common/icon/coin/1a.png"},
		-- {font=qy.res.FONT_NAME,size=24,color=cc.c3b(255,242,207),text=tostring(my_awards[3].num)},
		-- {img="Resources/common/icon/coin/1a.png"}
	}

    for i=1,#txt1 do
    	if txt1[i].font then
	        local re = ccui.RichElementText:create(i,txt1[i].color,255,txt1[i].text,txt1[i].font,txt1[i].size)
	        self.richTxt1:pushBackElement(re)
    	else
	        local icon = ccui.RichElementImage:create(i,cc.c3b(255,255,255),255,txt1[i].img)
	    	self.richTxt1:pushBackElement(icon)
    	end
    end

    local px = 40+math.floor(math.log10(rank))*16
    for i=1,3 do
        local num = cc.Label:createWithTTF(tostring(my_awards[i].num),qy.res.FONT_NAME, qy.InternationalUtil:getAwardPreviewDialogFontSize(),cc.size(0,0),1)
        num:setAnchorPoint(0,0.5)
        num:setTextColor(cc.c4b(255,242,207,255))
        num:setPosition(px,295)
        self.panel:addChild(num)

        if i == 1 then
            px = num:getPositionX()+num:getContentSize().width-5
        else
            px = num:getPositionX()+num:getContentSize().width+3
        end

        local icon = cc.Sprite:create(qy.tank.utils.AwardUtils.getAwardIconByType(my_awards[i].type,my_awards[i].id))
        icon:setAnchorPoint(0,0.5)
        icon:setScale(0.6)
        icon:setPosition(px,295)
        self.panel:addChild(icon)

        if i == 1 then
            px = icon:getPositionX()+icon:getContentSize().width*0.6 - 2
        else
            px = icon:getPositionX()+icon:getContentSize().width*0.6+3
        end
    end


    -- local num1 = cc.Label:createWithTTF(my_awards[1].num,qy.res.FONT_NAME, 24.0,cc.size(0,0),0)
    -- num1:setAnchorPoint(0,0.5)
    -- num1:setTextColor(cc.c4b(255,242,207,255))
    -- num1:setPosition(px,295)
    -- self.panel:addChild(num1)
    -- px = num1:getPositionX()+num1:getContentSize().width

    -- local icon1 = cc.Sprite:create(qy.tank.utils.AwardUtils.getAwardIconByType(my_awards[1].type,my_awards[1].id))
    -- icon1:setAnchorPoint(0,0.5)
    -- icon1:setScale(0.6)
    -- icon1:setPosition(px,295)
    -- self.panel:addChild(icon1)
    -- px = icon1:getPositionX()+icon1:getContentSize().width*0.6

    -- local num2 = cc.Label:createWithTTF(my_awards[2].num,qy.res.FONT_NAME, 24.0,cc.size(0,0),0)
    -- num2:setAnchorPoint(0,0.5)
    -- num2:setTextColor(cc.c4b(255,242,207,255))
    -- num2:setPosition(px,295)
    -- self.panel:addChild(num2)
    -- px = num2:getPositionX()+num2:getContentSize().width

    -- local icon2 = cc.Sprite:create(qy.tank.utils.AwardUtils.getAwardIconByType(my_awards[2].type,my_awards[1].id))
    -- icon2:setAnchorPoint(0,0.5)
    -- icon2:setScale(0.6)
    -- icon2:setPosition(px,295)
    -- self.panel:addChild(icon2)
    -- px = icon2:getPositionX()+icon2:getContentSize().width*0.6

    -- local num3 = cc.Label:createWithTTF(my_awards[3].num,qy.res.FONT_NAME, 24.0,cc.size(0,0),0)
    -- num3:setAnchorPoint(0,0.5)
    -- num3:setTextColor(cc.c4b(255,242,207,255))
    -- num3:setPosition(px,295)
    -- self.panel:addChild(num3)
    -- px = num3:getPositionX()+num3:getContentSize().width

    -- local icon3 = cc.Sprite:create(qy.tank.utils.AwardUtils.getAwardIconByType(my_awards[3].type,my_awards[1].id))
    -- icon3:setAnchorPoint(0,0.5)
    -- icon3:setScale(0.6)
    -- icon3:setPosition(px,295)
    -- self.panel:addChild(icon3)


    local txt2 = {
		{font=qy.res.FONT_NAME,size=qy.InternationalUtil:getAwardPreviewDialogFontSize(),color=cc.c3b(255,242,207),text=qy.TextUtil:substitute(4024)},
		{font=qy.res.FONT_NAME,size=qy.InternationalUtil:getAwardPreviewDialogFontSize(),color=cc.c3b(255,136,0),text=tostring(max_rank)},
		{font=qy.res.FONT_NAME,size=qy.InternationalUtil:getAwardPreviewDialogFontSize(),color=cc.c3b(0,255,255),text=qy.TextUtil:substitute(4025)}}

    for i=1,#txt2 do
        local re = ccui.RichElementText:create(i,txt2[i].color,255,txt2[i].text,txt1[i].font,txt2[i].size)
        self.richTxt2:pushBackElement(re)
    end

    local h = 300
    -- local layer = cc.LayerColor:create(cc.c4b(0,255,255,100),800,h)
    self.list = cc.TableView:create(cc.size(800,h))
    self.list:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.list:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.list:setPosition(-290,140-h)
    self.panel:addChild(self.list)
    -- self.list:addChild(layer)
    self.list:setDelegate()

    local function numberOfCellsInTableView(table)
        return #self.model.awardList
    end

    local function tableCellTouched(table,cell)
        print("cell touched at index: " .. cell:getIdx())
    end

    local function cellSizeForTable(tableView, idx)
        return 800, 50
    end

    local function tableCellAtIndex(table, idx)
        local strValue = string.format("%d",idx)
        local cell = table:dequeueCell()
        local item
        if nil == cell then
            cell = cc.TableViewCell:new()
            item = qy.tank.view.arena.AwardPreviewCell.new()
            cell:addChild(item)
            cell.item = item
        end
        cell.item:render(self.model.awardList[idx+1])
        return cell
    end

    self.list:registerScriptHandler(numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.list:registerScriptHandler(tableCellTouched,cc.TABLECELL_TOUCHED)
    self.list:registerScriptHandler(cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
    self.list:registerScriptHandler(tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)

    self.list:reloadData()
end


return AwardPreviewDialog
