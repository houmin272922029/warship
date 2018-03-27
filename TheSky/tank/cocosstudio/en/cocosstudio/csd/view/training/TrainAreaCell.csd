<GameProjectFile>
  <PropertyGroup Type="Node" Name="TrainAreaCell" ID="005fde6d-8975-4338-becd-00883c62cda4" Version="2.3.1.2" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="0" Speed="1.0000" />
      <ObjectData Name="Node" Tag="69" ctype="GameNodeObjectData">
        <Size X="0.0000" Y="0.0000" />
        <Children>
          <AbstractNodeData Name="bgQuality" ActionTag="-568841606" Tag="70" IconVisible="False" LeftMargin="8.9402" RightMargin="-202.9402" TopMargin="-183.4998" BottomMargin="64.4998" Scale9Width="194" Scale9Height="119" ctype="ImageViewObjectData">
            <Size X="194.0000" Y="119.0000" />
            <Children>
              <AbstractNodeData Name="tankSprite" ActionTag="-1845784659" Tag="71" IconVisible="False" LeftMargin="65.4000" RightMargin="64.6000" TopMargin="15.7708" BottomMargin="21.2292" ctype="SpriteObjectData">
                <Size X="64.0000" Y="82.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="97.4000" Y="62.2292" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5021" Y="0.5229" />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="MarkedSubImage" Path="Resources/common/icon/XL_10.png" Plist="Resources/common/icon/common_icon.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="tankLevel" ActionTag="864569639" Tag="72" IconVisible="False" LeftMargin="17.2524" RightMargin="132.7476" TopMargin="14.0011" BottomMargin="83.9989" FontSize="18" LabelText="LV.30" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="TextObjectData">
                <Size X="44.0000" Y="21.0000" />
                <AnchorPoint ScaleY="0.5000" />
                <Position X="17.2524" Y="94.4989" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.0889" Y="0.7941" />
                <PreSize X="0.0000" Y="0.0000" />
                <OutlineColor A="255" R="0" G="0" B="0" />
                <ShadowColor A="255" R="0" G="0" B="0" />
              </AbstractNodeData>
              <AbstractNodeData Name="tankName" ActionTag="1537737271" Tag="73" IconVisible="False" LeftMargin="8.0000" RightMargin="11.0000" TopMargin="74.0016" BottomMargin="4.9984" IsCustomSize="True" FontSize="17" LabelText="虎王坦克" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="TextObjectData">
                <Size X="175.0000" Y="40.0000" />
                <AnchorPoint ScaleX="1.0000" ScaleY="0.5000" />
                <Position X="183.0000" Y="24.9984" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.9433" Y="0.2101" />
                <PreSize X="0.9021" Y="0.3361" />
                <OutlineColor A="255" R="0" G="0" B="0" />
                <ShadowColor A="255" R="0" G="0" B="0" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="105.9402" Y="123.9998" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="194.0000" Y="119.0000" />
            <FileData Type="MarkedSubImage" Path="Resources/common/item/bg1.png" Plist="Resources/common/item/common_item.plist" />
          </AbstractNodeData>
          <AbstractNodeData Name="trainLevel" ActionTag="-276659947" Tag="74" IconVisible="False" LeftMargin="49.4278" RightMargin="-162.4278" TopMargin="-220.9844" BottomMargin="193.9844" ctype="SpriteObjectData">
            <Size X="113.0000" Y="27.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="105.9278" Y="207.4844" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
            <FileData Type="MarkedSubImage" Path="Resources/training/train_level_2.png" Plist="Resources/training/training.plist" />
            <BlendFunc Src="1" Dst="771" />
          </AbstractNodeData>
          <AbstractNodeData Name="upgradeBtn" ActionTag="25148857" Tag="75" IconVisible="False" LeftMargin="35.9351" RightMargin="-167.9351" TopMargin="-60.0018" BottomMargin="5.0018" TouchEnable="True" FontSize="24" ButtonText="Upgrade" Scale9Enable="True" Scale9Width="152" Scale9Height="65" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
            <Size X="132.0000" Y="55.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="101.9351" Y="32.5018" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="132.0000" Y="55.0000" />
            <FontResource Type="Normal" Path="Resources/font/ttf/black_body.TTF" Plist="" />
            <TextColor A="255" R="255" G="255" B="255" />
            <DisabledFileData Type="Default" Path="Default/Button_Disable.png" Plist="" />
            <PressedFileData Type="MarkedSubImage" Path="Resources/common/button/anniulan02.png" Plist="Resources/common/button/common_button.plist" />
            <NormalFileData Type="MarkedSubImage" Path="Resources/common/button/btn_4.png" Plist="Resources/common/button/common_button.plist" />
            <OutlineColor A="255" R="0" G="0" B="0" />
            <ShadowColor A="255" R="0" G="0" B="0" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameProjectFile>