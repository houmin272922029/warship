<GameProjectFile>
  <PropertyGroup Type="Layer" Name="BuyOrUseDialog" ID="7225ba96-81e8-4c98-96dd-bedce56b5df5" Version="2.3.1.2" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="0" Speed="1.0000" />
      <ObjectData Name="Layer" Tag="34" ctype="GameLayerObjectData">
        <Size X="1080.0000" Y="720.0000" />
        <Children>
          <AbstractNodeData Name="panel" ActionTag="-189757007" Tag="44" IconVisible="False" PositionPercentYEnabled="True" HorizontalEdge="BothEdge" LeftMargin="440.0000" RightMargin="440.0000" TopMargin="293.0000" BottomMargin="227.0000" TouchEnable="True" BackColorAlpha="0" ComboBoxIndex="1" ColorAngle="90.0000" ctype="PanelObjectData">
            <Size X="200.0000" Y="200.0000" />
            <Children>
              <AbstractNodeData Name="Image_5" ActionTag="1409421876" Tag="50" IconVisible="False" LeftMargin="-210.0000" RightMargin="-210.0000" TopMargin="-109.0000" BottomMargin="54.0000" Scale9Enable="True" LeftEage="50" RightEage="50" TopEage="30" BottomEage="30" Scale9OriginX="50" Scale9OriginY="30" Scale9Width="166" Scale9Height="112" ctype="ImageViewObjectData">
                <Size X="620.0000" Y="255.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="1.0000" />
                <Position X="100.0000" Y="309.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="1.5450" />
                <PreSize X="3.1000" Y="1.2750" />
                <FileData Type="MarkedSubImage" Path="Resources/common/img/b2.png" Plist="Resources/common/img/common_img.plist" />
              </AbstractNodeData>
              <AbstractNodeData Name="topTxt" ActionTag="-664901460" Tag="53" IconVisible="False" LeftMargin="-87.0000" RightMargin="-87.0000" TopMargin="-87.5000" BottomMargin="262.5000" FontSize="22" LabelText="体力不足，使用牛肉罐头可恢复体力！" OutlineSize="0" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ShadowEnabled="True" ctype="TextObjectData">
                <Size X="374.0000" Y="25.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="100.0000" Y="275.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="1.3750" />
                <PreSize X="0.0000" Y="0.0000" />
                <FontResource Type="Normal" Path="Resources/font/ttf/black_body_2.TTF" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="0" G="0" B="0" />
              </AbstractNodeData>
              <AbstractNodeData Name="useBtn" ActionTag="-2136136730" Tag="52" IconVisible="False" LeftMargin="163.4922" RightMargin="-115.4922" TopMargin="199.0016" BottomMargin="-64.0016" TouchEnable="True" FontSize="20" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="122" Scale9Height="43" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
                <Size X="152.0000" Y="65.0000" />
                <Children>
                  <AbstractNodeData Name="shiyong_1" ActionTag="1402571426" Tag="23" IconVisible="False" LeftMargin="47.0078" RightMargin="43.9922" TopMargin="21.9977" BottomMargin="21.0023" ctype="SpriteObjectData">
                    <Size X="61.0000" Y="22.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="77.5078" Y="32.0023" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5099" Y="0.4923" />
                    <PreSize X="0.0000" Y="0.0000" />
                    <FileData Type="MarkedSubImage" Path="Resources/common/txt/shiyong.png" Plist="Resources/common/txt/common_txt.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="239.4922" Y="-31.5016" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="1.1975" Y="-0.1575" />
                <PreSize X="0.7600" Y="0.3250" />
                <FontResource Type="Normal" Path="Resources/font/ttf/black_body.TTF" Plist="" />
                <TextColor A="255" R="255" G="255" B="255" />
                <DisabledFileData Type="MarkedSubImage" Path="Resources/common/button/anniuhui.png" Plist="Resources/common/button/common_button.plist" />
                <PressedFileData Type="MarkedSubImage" Path="Resources/common/button/anniulan02.png" Plist="Resources/common/button/common_button.plist" />
                <NormalFileData Type="MarkedSubImage" Path="Resources/common/button/btn_4.png" Plist="Resources/common/button/common_button.plist" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="buyBtn" ActionTag="23079495" Tag="51" IconVisible="False" LeftMargin="-132.5035" RightMargin="180.5035" TopMargin="198.0004" BottomMargin="-63.0004" TouchEnable="True" FontSize="36" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="122" Scale9Height="43" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
                <Size X="152.0000" Y="65.0000" />
                <Children>
                  <AbstractNodeData Name="goumai_1" CanEdit="False" ActionTag="-587351533" Tag="105" IconVisible="False" LeftMargin="50.0035" RightMargin="44.9965" TopMargin="22.4988" BottomMargin="21.5012" ctype="SpriteObjectData">
                    <Size X="57.0000" Y="21.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="78.5035" Y="32.0012" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5165" Y="0.4923" />
                    <PreSize X="0.0000" Y="0.0000" />
                    <FileData Type="MarkedSubImage" Path="Resources/common/txt/goumai.png" Plist="Resources/common/txt/common_txt.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="-56.5035" Y="-30.5004" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="-0.2825" Y="-0.1525" />
                <PreSize X="0.7600" Y="0.3250" />
                <FontResource Type="Normal" Path="Resources/font/ttf/black_body.TTF" Plist="" />
                <TextColor A="255" R="255" G="255" B="255" />
                <DisabledFileData Type="MarkedSubImage" Path="Resources/common/button/anniuhui.png" Plist="Resources/common/button/common_button.plist" />
                <PressedFileData Type="MarkedSubImage" Path="Resources/common/button/anniuhong02.png" Plist="Resources/common/button/common_button.plist" />
                <NormalFileData Type="MarkedSubImage" Path="Resources/common/button/btn_3.png" Plist="Resources/common/button/common_button.plist" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="Text" ActionTag="1840046267" Tag="48" IconVisible="False" LeftMargin="-110.0000" RightMargin="250.0000" TopMargin="161.5000" BottomMargin="15.5000" FontSize="20" LabelText="价格：" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="TextObjectData">
                <Size X="60.0000" Y="23.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="-80.0000" Y="27.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="229" G="204" B="123" />
                <PrePosition X="-0.4000" Y="0.1350" />
                <PreSize X="0.0000" Y="0.0000" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="costIcon" ActionTag="625044287" Tag="49" IconVisible="False" LeftMargin="-59.0000" RightMargin="227.0000" TopMargin="159.0000" BottomMargin="15.0000" ctype="SpriteObjectData">
                <Size X="32.0000" Y="26.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="-43.0000" Y="28.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="-0.2150" Y="0.1400" />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="Normal" Path="Resources/common/icon/coin/1a.png" Plist="" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="costNum" ActionTag="-2943543" Tag="50" IconVisible="False" LeftMargin="-23.0000" RightMargin="212.0000" TopMargin="161.5000" BottomMargin="15.5000" FontSize="20" LabelText="2" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="TextObjectData">
                <Size X="11.0000" Y="23.0000" />
                <AnchorPoint ScaleY="0.5000" />
                <Position X="-23.0000" Y="27.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="229" G="204" B="123" />
                <PrePosition X="-0.1150" Y="0.1350" />
                <PreSize X="0.0000" Y="0.0000" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="Text_0" ActionTag="-605663208" Tag="51" IconVisible="False" LeftMargin="175.5000" RightMargin="-75.5000" TopMargin="160.5000" BottomMargin="16.5000" FontSize="20" LabelText="当前拥有：" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="TextObjectData">
                <Size X="100.0000" Y="23.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="225.5000" Y="28.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="229" G="204" B="123" />
                <PrePosition X="1.1275" Y="0.1400" />
                <PreSize X="0.0000" Y="0.0000" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="remainNum" ActionTag="11725320" Tag="53" IconVisible="False" LeftMargin="275.5000" RightMargin="-86.5000" TopMargin="160.5000" BottomMargin="16.5000" FontSize="20" LabelText="2" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="TextObjectData">
                <Size X="11.0000" Y="23.0000" />
                <AnchorPoint ScaleY="0.5000" />
                <Position X="275.5000" Y="28.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="229" G="204" B="123" />
                <PrePosition X="1.3775" Y="0.1400" />
                <PreSize X="0.0000" Y="0.0000" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="540.0000" Y="327.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.5000" Y="0.4542" />
            <PreSize X="0.1852" Y="0.2778" />
            <SingleColor A="255" R="150" G="200" B="255" />
            <FirstColor A="255" R="150" G="200" B="255" />
            <EndColor A="255" R="255" G="255" B="255" />
            <ColorVector ScaleY="1.0000" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameProjectFile>