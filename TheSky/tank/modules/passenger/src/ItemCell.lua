local ItemCell = qy.class("ItemCell", qy.tank.view.BaseView, "passenger.ui.ItemCell")
local PassengerModel = qy.tank.model.PassengerModel

function ItemCell:ctor(delegate)
   	ItemCell.super.ctor(self)

   	for i=1,4 do
   		self:InjectView("name"..i)
   		self:InjectView("Info"..i)
   		self:InjectView("Button_"..i)
   		self:InjectView("Sprite_"..i)
        self:InjectView("Panel_"..i)
        self:InjectView("Sprite"..i)
        self["Panel_" .. i]:setVisible(true)
        self["Sprite" .. i]:setVisible(false)
        self["Button_" .. i]:setSwallowTouches(false)
   	end
   	
   	cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/common/item/common_item.plist")

    for i=1,4 do
        -- self:OnClick("Button_"..i, function()
        --     delegate.callback(self["data_" .. i])
        -- end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})

        self:OnClickForBuilding("Button_"..i, function()
            delegate.callback(self["data_" .. i])
        end,{["audioType"] = qy.SoundType.BTN_CLOSE, ["isScale"] = false})
    end
end

function ItemCell:setData(data)
	for i=1,4 do
        self["Panel_" .. i]:setVisible(true)
        self["Sprite" .. i]:setVisible(false)
		if data[i] then
			self["data_" .. i] = data[i]
            local passid = data[i].id
            local collect = PassengerModel.collect
            if collect and #collect ~= 0 then
                for j=1,#collect do
                    if collect[j] == tonumber(passid) then
                        self["Panel_" .. i]:setVisible(false)
                        self["Sprite" .. i]:setVisible(true)
                    end
                end
            end
            
			self["Button_" .. i]:setVisible(true)
			self["Button_" .. i]:loadTexture("Resources/common/item/item_bg_" .. data[i].quality .. ".png", 1)
			-- self["Button_" .. i]:loadTextureDisabled("Resources/common/item/item_bg_" .. data[i].quality .. ".png", 1)
            -- self["Button_" .. i]:loadTexturePressed("Resources/common/item/item_bg_" .. data[i].quality .. ".png", 1)
        	self["Sprite_" .. i]:setTexture("res/passenger/" .. data[i].id .. "_" .. 1 .. ".png")
            self["Sprite_" .. i]:setScale(0.9)
        	self["name" .. i]:setString(data[i].name)
              
            local tujian_type = tonumber(data[i].tujian_type)
            if tujian_type == 6 or tujian_type == 9 or tujian_type == 10 or tujian_type == 11 or tujian_type == 12 or tujian_type == 13 then
                self["Info" .. i]:setString(PassengerModel.tujianTypeNameList[data[i].tujian_type .. ""] .. " +" .. (data[i].tujian_val or 0).."%")
            else
                self["Info" .. i]:setString(PassengerModel.tujianTypeNameList[data[i].tujian_type .. ""] .. " +" .. (data[i].tujian_val or 0))
            end
        else
        	self["Button_" .. i]:setVisible(false)
        end
	end
end

return ItemCell