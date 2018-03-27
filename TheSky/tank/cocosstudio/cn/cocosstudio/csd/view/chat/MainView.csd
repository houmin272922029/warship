<GameProjectFile>
  <PropertyGroup Type="Layer" Name="MainView" ID="60ac009f-7d77-497b-8937-46267adda32b" Version="2.3.1.2" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="0" Speed="1.0000" />
      <ObjectData Name="Layer" Tag="111" ctype="GameLayerObjectData">
        <Size X="1080.0000" Y="720.0000" />
        <Children>
          <AbstractNodeData Name="bg_1" CanEdit="False" ActionTag="145633814" Tag="13" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="-100.0000" RightMargin="-100.0000" ctype="SpriteObjectData">
            <Size X="1280.0000" Y="720.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="540.0000" Y="360.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.5000" Y="0.5000" />
            <PreSize X="1.1852" Y="1.0000" />
            <FileData Type="MarkedSubImage" Path="Resources/chat/bg.jpg" Plist="Resources/chat/background.plist" />
            <BlendFunc Src="770" Dst="771" />
          </AbstractNodeData>
          <AbstractNodeData Name="Node_Container" CanEdit="False" ActionTag="1688909142" Tag="113" IconVisible="False" HorizontalEdge="BothEdge" LeftMargin="41.0000" RightMargin="41.0000" TopMargin="100.0000" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
            <Size X="998.0000" Y="620.0000" />
            <Children>
              <AbstractNodeData Name="Image_6" CanEdit="False" ActionTag="1997408713" Tag="45" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="19.0000" RightMargin="19.0000" TopMargin="505.0000" BottomMargin="9.0000" Scale9Enable="True" LeftEage="102" RightEage="102" TopEage="37" BottomEage="37" Scale9OriginX="102" Scale9OriginY="37" Scale9Width="107" Scale9Height="39" ctype="ImageViewObjectData">
                <Size X="960.0000" Y="106.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="499.0000" Y="62.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="0.1000" />
                <PreSize X="1.0105" Y="0.1828" />
                <FileData Type="MarkedSubImage" Path="Resources/chat/6.png" Plist="Resources/chat/ui.plist" />
              </AbstractNodeData>
              <AbstractNodeData Name="frame" CanEdit="False" ActionTag="-83884529" Tag="41" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="-8.0000" RightMargin="-8.0000" TopMargin="-9.2100" BottomMargin="109.2100" Scale9Enable="True" LeftEage="50" RightEage="50" TopEage="200" BottomEage="100" Scale9OriginX="50" Scale9OriginY="200" Scale9Width="365" Scale9Height="91" ctype="ImageViewObjectData">
                <Size X="1014.0000" Y="520.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="499.0000" Y="369.2100" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="0.5955" />
                <PreSize X="0.9389" Y="0.7222" />
                <FileData Type="MarkedSubImage" Path="Resources/common/frame/kuang02.png" Plist="Resources/common/frame/common_frame.plist" />
              </AbstractNodeData>
              <AbstractNodeData Name="Node_channel" CanEdit="False" ActionTag="-609512490" Tag="132" IconVisible="False" LeftMargin="36.0000" RightMargin="831.0000" TopMargin="273.0000" BottomMargin="87.0000" TouchEnable="True" Scale9Enable="True" LeftEage="43" RightEage="43" TopEage="70" BottomEage="70" Scale9OriginX="43" Scale9OriginY="70" Scale9Width="45" Scale9Height="73" ctype="ImageViewObjectData">
                <Size X="131.0000" Y="260.0000" />
                <Children>
                  <AbstractNodeData Name="Btn_private" ActionTag="1242199681" CallBackType="Click" CallBackName="onPrivate" Tag="129" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="34.5000" RightMargin="34.5000" TopMargin="91.5700" BottomMargin="146.4300" TouchEnable="True" FontSize="26" Scale9Enable="True" LeftEage="13" RightEage="13" TopEage="6" BottomEage="6" Scale9OriginX="13" Scale9OriginY="6" Scale9Width="36" Scale9Height="10" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                    <Size X="62.0000" Y="22.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="65.5000" Y="157.4300" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5000" Y="0.6055" />
                    <PreSize X="0.4733" Y="0.1033" />
                    <TextColor A="255" R="255" G="225" B="26" />
                    <NormalFileData Type="MarkedSubImage" Path="Resources/chat/siliao.png" Plist="Resources/chat/ui.plist" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Btn_corps" ActionTag="262653304" CallBackType="Click" CallBackName="onCorps" Tag="130" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="34.5000" RightMargin="34.5000" TopMargin="151.9160" BottomMargin="86.0840" TouchEnable="True" FontSize="26" Scale9Enable="True" LeftEage="13" RightEage="13" TopEage="6" BottomEage="6" Scale9OriginX="13" Scale9OriginY="6" Scale9Width="36" Scale9Height="10" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                    <Size X="62.0000" Y="22.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="65.5000" Y="97.0840" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5000" Y="0.3734" />
                    <PreSize X="0.4733" Y="0.1033" />
                    <TextColor A="255" R="119" G="196" B="211" />
                    <NormalFileData Type="MarkedSubImage" Path="Resources/chat/juntuan.png" Plist="Resources/chat/ui.plist" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Btn_world" ActionTag="-1571720540" CallBackType="Click" CallBackName="onWorld" Tag="131" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="34.5000" RightMargin="34.5000" TopMargin="211.3520" BottomMargin="26.6480" TouchEnable="True" FontSize="26" Scale9Enable="True" LeftEage="13" RightEage="13" TopEage="6" BottomEage="6" Scale9OriginX="13" Scale9OriginY="6" Scale9Width="36" Scale9Height="10" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                    <Size X="62.0000" Y="22.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="65.5000" Y="37.6480" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5000" Y="0.1448" />
                    <PreSize X="0.4733" Y="0.1033" />
                    <TextColor A="255" R="185" G="71" B="217" />
                    <NormalFileData Type="MarkedSubImage" Path="Resources/chat/shijie.png" Plist="Resources/chat/ui.plist" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Sprite_8" ActionTag="-1862645953" Tag="46" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="12.5000" RightMargin="12.5000" TopMargin="132.1980" BottomMargin="125.8020" ctype="SpriteObjectData">
                    <Size X="106.0000" Y="2.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="65.5000" Y="126.8020" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5000" Y="0.4877" />
                    <PreSize X="0.8092" Y="0.0094" />
                    <FileData Type="MarkedSubImage" Path="Resources/chat/2.png" Plist="Resources/chat/ui.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Sprite_8_0" ActionTag="-528954764" Tag="47" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="12.5000" RightMargin="12.5000" TopMargin="190.3340" BottomMargin="67.6660" ctype="SpriteObjectData">
                    <Size X="106.0000" Y="2.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="65.5000" Y="68.6660" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5000" Y="0.2641" />
                    <PreSize X="0.8092" Y="0.0094" />
                    <FileData Type="MarkedSubImage" Path="Resources/chat/2.png" Plist="Resources/chat/ui.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Sprite_8_1" ActionTag="2043057925" Tag="146" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="12.4996" RightMargin="12.5004" TopMargin="74.1884" BottomMargin="183.8116" ctype="SpriteObjectData">
                    <Size X="106.0000" Y="2.0000" />
                    <AnchorPoint ScaleX="0.5047" ScaleY="4.0992" />
                    <Position X="65.9978" Y="192.0100" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5038" Y="0.7385" />
                    <PreSize X="0.8092" Y="0.0094" />
                    <FileData Type="MarkedSubImage" Path="Resources/chat/2.png" Plist="Resources/chat/ui.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Btn_camp" ActionTag="168040015" CallBackType="Click" CallBackName="onCamp" Tag="147" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="38.0000" RightMargin="38.0000" TopMargin="30.5740" BottomMargin="207.4260" TouchEnable="True" FontSize="26" Scale9Enable="True" LeftEage="13" RightEage="13" TopEage="6" BottomEage="6" Scale9OriginX="13" Scale9OriginY="6" Scale9Width="29" Scale9Height="10" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                    <Size X="55.0000" Y="22.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="65.5000" Y="218.4260" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5000" Y="0.8401" />
                    <PreSize X="0.4198" Y="0.0846" />
                    <TextColor A="255" R="255" G="225" B="26" />
                    <NormalFileData Type="MarkedSubImage" Path="Resources/chat/zhenying.png" Plist="Resources/chat/ui.plist" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint />
                <Position X="36.0000" Y="87.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.0361" Y="0.1403" />
                <PreSize X="0.1313" Y="0.4194" />
                <FileData Type="MarkedSubImage" Path="Resources/chat/1.png" Plist="Resources/chat/ui.plist" />
              </AbstractNodeData>
              <AbstractNodeData Name="Button_3" ActionTag="-964512641" CallBackType="Click" CallBackName="onShowChannelList" Tag="42" IconVisible="False" LeftMargin="35.5000" RightMargin="789.5000" TopMargin="520.5000" BottomMargin="25.5000" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="143" Scale9Height="52" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="173.0000" Y="74.0000" />
                <Children>
                  <AbstractNodeData Name="channel_name" ActionTag="-136036977" Tag="43" IconVisible="False" LeftMargin="35.5000" RightMargin="75.5000" TopMargin="25.0000" BottomMargin="27.0000" ctype="SpriteObjectData">
                    <Size X="62.0000" Y="22.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="66.5000" Y="38.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.3844" Y="0.5135" />
                    <PreSize X="0.0000" Y="0.0000" />
                    <FileData Type="MarkedSubImage" Path="Resources/chat/shijie.png" Plist="Resources/chat/ui.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="arraw" ActionTag="-1104378186" Tag="49" IconVisible="False" PositionPercentYEnabled="True" LeftMargin="123.5000" RightMargin="11.5000" TopMargin="20.5020" BottomMargin="24.4980" ctype="SpriteObjectData">
                    <Size X="38.0000" Y="29.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="142.5000" Y="38.9980" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.8237" Y="0.5270" />
                    <PreSize X="0.2197" Y="0.3919" />
                    <FileData Type="MarkedSubImage" Path="Resources/chat/5.png" Plist="Resources/chat/ui.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="122.0000" Y="62.5000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.1222" Y="0.1008" />
                <PreSize X="0.1602" Y="0.1028" />
                <TextColor A="255" R="65" G="65" B="70" />
                <DisabledFileData Type="MarkedSubImage" Path="Resources/chat/3.png" Plist="Resources/chat/ui.plist" />
                <PressedFileData Type="MarkedSubImage" Path="Resources/chat/3.png" Plist="Resources/chat/ui.plist" />
                <NormalFileData Type="MarkedSubImage" Path="Resources/chat/4.png" Plist="Resources/chat/ui.plist" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="Sprite_12" ActionTag="1244630511" Tag="50" IconVisible="False" LeftMargin="210.5000" RightMargin="214.5000" TopMargin="530.5000" BottomMargin="39.5000" ctype="SpriteObjectData">
                <Size X="573.0000" Y="50.0000" />
                <AnchorPoint />
                <Position X="210.5000" Y="39.5000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.2109" Y="0.0637" />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="MarkedSubImage" Path="Resources/chat/7.png" Plist="Resources/chat/ui.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="Button_4" ActionTag="527133958" CallBackType="Click" CallBackName="onSend" Tag="51" IconVisible="False" LeftMargin="784.5000" RightMargin="30.5000" TopMargin="525.0000" BottomMargin="30.0000" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="50" RightEage="50" TopEage="11" BottomEage="11" Scale9OriginX="50" Scale9OriginY="11" Scale9Width="127" Scale9Height="63" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="183.0000" Y="65.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="876.0000" Y="62.5000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.8778" Y="0.1008" />
                <PreSize X="0.1834" Y="0.1047" />
                <TextColor A="255" R="65" G="65" B="70" />
                <DisabledFileData Type="MarkedSubImage" Path="Resources/common/button/anniu01.png" Plist="Resources/common/button/common_button.plist" />
                <PressedFileData Type="MarkedSubImage" Path="Resources/common/button/anniu01.png" Plist="Resources/common/button/common_button.plist" />
                <NormalFileData Type="MarkedSubImage" Path="Resources/common/button/anniu01_1.png" Plist="Resources/common/button/common_button.plist" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="fasong_13" ActionTag="-1175879508" Tag="52" IconVisible="False" LeftMargin="845.0000" RightMargin="91.0000" TopMargin="545.0417" BottomMargin="52.9583" ctype="SpriteObjectData">
                <Size X="62.0000" Y="22.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="876.0000" Y="63.9583" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.8778" Y="0.1032" />
                <PreSize X="0.0621" Y="0.0355" />
                <FileData Type="MarkedSubImage" Path="Resources/chat/fasong.png" Plist="Resources/chat/ui.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" />
            <Position X="540.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.5000" />
            <PreSize X="0.9241" Y="0.8611" />
            <SingleColor A="255" R="150" G="200" B="255" />
            <FirstColor A="255" R="150" G="200" B="255" />
            <EndColor A="255" R="255" G="255" B="255" />
            <ColorVector ScaleY="1.0000" />
          </AbstractNodeData>
          <AbstractNodeData Name="Button_5" ActionTag="1620968198" CallBackType="Click" CallBackName="onBack" Tag="53" IconVisible="False" HorizontalEdge="RightEdge" VerticalEdge="TopEdge" LeftMargin="905.9995" RightMargin="0.0005" TopMargin="0.0002" BottomMargin="648.9998" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="144" Scale9Height="49" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="174.0000" Y="71.0000" />
            <AnchorPoint ScaleX="1.0000" ScaleY="1.0000" />
            <Position X="1079.9995" Y="719.9998" />
            <Scale ScaleX="0.9310" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="1.0000" Y="1.0000" />
            <PreSize X="0.1611" Y="0.0986" />
            <TextColor A="255" R="65" G="65" B="70" />
            <DisabledFileData Type="Default" Path="Default/Button_Disable.png" Plist="" />
            <PressedFileData Type="MarkedSubImage" Path="Resources/common/button/guanbi.png" Plist="Resources/common/button/common_button.plist" />
            <NormalFileData Type="MarkedSubImage" Path="Resources/common/button/guanbi.png" Plist="Resources/common/button/common_button.plist" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
          <AbstractNodeData Name="Sprite_15" ActionTag="-1077097011" Tag="56" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="39.5000" RightMargin="39.5000" TopMargin="103.5000" BottomMargin="561.5000" ctype="SpriteObjectData">
            <Size X="1001.0000" Y="55.0000" />
            <Children>
              <AbstractNodeData Name="Text_1" ActionTag="-1741319516" Tag="57" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="60.0000" RightMargin="60.0000" TopMargin="15.0000" BottomMargin="15.0000" FontSize="20" LabelText="公告：请不要相信聊天室内叫卖钻石或其它物资的虚假信息，否则您的帐号会存在被盗和封禁的风险" OutlineEnabled="True" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="881.0000" Y="25.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="500.5000" Y="27.5000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="118" G="116" B="73" />
                <PrePosition X="0.5000" Y="0.5000" />
                <PreSize X="0.8148" Y="0.0319" />
                <FontResource Type="Normal" Path="Resources/font/ttf/black_body_2.TTF" Plist="" />
                <OutlineColor A="255" R="0" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="540.0000" Y="589.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.5000" Y="0.8181" />
            <PreSize X="0.9269" Y="0.0764" />
            <FileData Type="MarkedSubImage" Path="Resources/chat/8.png" Plist="Resources/chat/ui.plist" />
            <BlendFunc Src="1" Dst="771" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameProjectFile>