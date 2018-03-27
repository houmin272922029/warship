<GameProjectFile>
  <PropertyGroup Type="Layer" Name="BatchTrainDialog" ID="57844d87-037d-444e-aa87-ae5b8439176d" Version="2.3.1.2" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="0" Speed="1.0000" />
      <ObjectData Name="Layer" Tag="170" ctype="GameLayerObjectData">
        <Size X="1080.0000" Y="720.0000" />
        <Children>
          <AbstractNodeData Name="bg" CanEdit="False" ActionTag="368470930" Tag="104" IconVisible="False" HorizontalEdge="BothEdge" LeftMargin="220.0000" RightMargin="220.0000" TopMargin="332.5000" BottomMargin="34.5000" Scale9Width="640" Scale9Height="353" ctype="ImageViewObjectData">
            <Size X="640.0000" Y="353.0000" />
            <Children>
              <AbstractNodeData Name="frame" CanEdit="False" ActionTag="2054602639" Tag="133" IconVisible="False" LeftMargin="-11.0000" RightMargin="-9.0000" TopMargin="-15.0000" BottomMargin="-22.0000" TouchEnable="True" Scale9Enable="True" LeftEage="179" RightEage="179" TopEage="70" BottomEage="30" Scale9OriginX="179" Scale9OriginY="70" Scale9Width="185" Scale9Height="263" ctype="ImageViewObjectData">
                <Size X="660.0000" Y="390.0000" />
                <Children>
                  <AbstractNodeData Name="closeBtn" CanEdit="False" ActionTag="1562537938" Tag="134" IconVisible="False" HorizontalEdge="RightEdge" VerticalEdge="TopEdge" LeftMargin="539.4994" RightMargin="-7.4994" TopMargin="-25.4975" BottomMargin="325.4975" TouchEnable="True" FontSize="14" Scale9Enable="True" Scale9Width="128" Scale9Height="90" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
                    <Size X="128.0000" Y="90.0000" />
                    <AnchorPoint ScaleX="1.0000" ScaleY="1.0000" />
                    <Position X="667.4994" Y="415.4975" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="1.0114" Y="1.0654" />
                    <PreSize X="0.0000" Y="0.0000" />
                    <TextColor A="255" R="65" G="65" B="70" />
                    <DisabledFileData Type="Default" Path="Default/Button_Disable.png" Plist="" />
                    <PressedFileData Type="MarkedSubImage" Path="Resources/common/button/guanbi01.png" Plist="Resources/common/button/common_button.plist" />
                    <NormalFileData Type="MarkedSubImage" Path="Resources/common/button/guanbi01.png" Plist="Resources/common/button/common_button.plist" />
                    <OutlineColor A="255" R="0" G="0" B="0" />
                    <ShadowColor A="255" R="0" G="0" B="0" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="319.0000" Y="173.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.4984" Y="0.4901" />
                <PreSize X="1.0313" Y="1.1048" />
                <FileData Type="MarkedSubImage" Path="Resources/common/frame/kuang01.png" Plist="Resources/common/frame/common_frame.plist" />
              </AbstractNodeData>
              <AbstractNodeData Name="title_bg" CanEdit="False" ActionTag="-211266826" Tag="135" IconVisible="False" LeftMargin="119.0000" RightMargin="119.0000" TopMargin="-66.5000" BottomMargin="330.5000" ctype="SpriteObjectData">
                <Size X="402.0000" Y="89.0000" />
                <Children>
                  <AbstractNodeData Name="title" CanEdit="False" ActionTag="-401606851" Tag="136" IconVisible="False" HorizontalEdge="BothEdge" VerticalEdge="BothEdge" LeftMargin="76.0000" RightMargin="76.0000" TopMargin="19.5014" BottomMargin="31.4986" ctype="SpriteObjectData">
                    <Size X="250.0000" Y="38.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="201.0000" Y="50.4986" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5000" Y="0.5674" />
                    <PreSize X="0.0000" Y="0.0000" />
                    <FileData Type="MarkedSubImage" Path="Resources/training/XL_4.png" Plist="Resources/training/training.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="320.0000" Y="375.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="1.0623" />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="MarkedSubImage" Path="Resources/common/frame/biaoti01.png" Plist="Resources/common/frame/common_frame.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="listBg" ActionTag="-1357209632" Tag="176" IconVisible="False" LeftMargin="15.4976" RightMargin="270.5024" TopMargin="57.9998" BottomMargin="5.0002" Scale9Enable="True" LeftEage="20" RightEage="20" TopEage="20" BottomEage="20" Scale9OriginX="20" Scale9OriginY="20" Scale9Width="95" Scale9Height="95" ctype="ImageViewObjectData">
                <Size X="354.0000" Y="290.0000" />
                <Children>
                  <AbstractNodeData Name="btn_tick_1" ActionTag="-285054825" Tag="180" IconVisible="False" LeftMargin="18.9147" RightMargin="285.0853" TopMargin="23.3217" BottomMargin="216.6783" TouchEnable="True" Scale9Width="50" Scale9Height="50" ctype="ImageViewObjectData">
                    <Size X="50.0000" Y="50.0000" />
                    <Children>
                      <AbstractNodeData Name="card1" ActionTag="1470936166" Tag="83" IconVisible="False" LeftMargin="260.5002" RightMargin="-281.5002" TopMargin="-18.0002" BottomMargin="-7.9998" ctype="SpriteObjectData">
                        <Size X="71.0000" Y="76.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="296.0002" Y="30.0002" />
                        <Scale ScaleX="0.9000" ScaleY="0.9000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="5.9200" Y="0.6000" />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="Normal" Path="Resources/common/icon/coin/4.png" Plist="" />
                        <BlendFunc Src="1" Dst="771" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_24" ActionTag="1217408082" Tag="84" IconVisible="False" LeftMargin="75.0001" RightMargin="-170.0001" TopMargin="6.5000" BottomMargin="16.5000" FontSize="22" LabelText="消耗1张经验卡&#xA;" OutlineEnabled="True" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="TextObjectData">
                        <Size X="145.0000" Y="27.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="75.0001" Y="30.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="1.5000" Y="0.6000" />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FontResource Type="Normal" Path="Resources/font/ttf/black_body_2.TTF" Plist="" />
                        <OutlineColor A="255" R="0" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="card_tick_1" CanEdit="False" ActionTag="1797493699" Tag="102" IconVisible="False" LeftMargin="-2.0000" RightMargin="-12.0000" TopMargin="-1.5001" BottomMargin="2.5001" ctype="SpriteObjectData">
                        <Size X="64.0000" Y="49.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="30.0000" Y="27.0001" />
                        <Scale ScaleX="0.7500" ScaleY="0.7500" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.6000" Y="0.5400" />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="MarkedSubImage" Path="Resources/common/img/XL_3.png" Plist="Resources/common/img/common_img.plist" />
                        <BlendFunc Src="1" Dst="771" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5217" ScaleY="0.4565" />
                    <Position X="44.9997" Y="239.5033" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.1271" Y="0.8259" />
                    <PreSize X="0.1412" Y="0.1724" />
                    <FileData Type="MarkedSubImage" Path="Resources/common/img/BK_t6.png" Plist="Resources/common/img/common_img.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="btn_tick_2" ActionTag="1705077650" Tag="137" IconVisible="False" LeftMargin="18.9150" RightMargin="285.0850" TopMargin="91.3217" BottomMargin="148.6783" TouchEnable="True" Scale9Width="50" Scale9Height="50" ctype="ImageViewObjectData">
                    <Size X="50.0000" Y="50.0000" />
                    <Children>
                      <AbstractNodeData Name="card2" CanEdit="False" ActionTag="276066792" Tag="138" IconVisible="False" LeftMargin="260.5002" RightMargin="-281.5002" TopMargin="-18.0002" BottomMargin="-7.9998" ctype="SpriteObjectData">
                        <Size X="71.0000" Y="76.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="296.0002" Y="30.0002" />
                        <Scale ScaleX="0.9000" ScaleY="0.9000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="5.9200" Y="0.6000" />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="Normal" Path="Resources/common/icon/coin/4.png" Plist="" />
                        <BlendFunc Src="1" Dst="771" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_24" CanEdit="False" ActionTag="-1738883015" Tag="139" IconVisible="False" LeftMargin="75.0001" RightMargin="-170.0001" TopMargin="6.5000" BottomMargin="16.5000" FontSize="22" LabelText="消耗50张经验卡&#xA;" OutlineEnabled="True" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="TextObjectData">
                        <Size X="158.0000" Y="27.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="75.0001" Y="30.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="1.5000" Y="0.6000" />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FontResource Type="Normal" Path="Resources/font/ttf/black_body_2.TTF" Plist="" />
                        <OutlineColor A="255" R="0" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="card_tick_2" CanEdit="False" ActionTag="1583799888" Tag="140" IconVisible="False" LeftMargin="-2.0000" RightMargin="-12.0000" TopMargin="-1.5001" BottomMargin="2.5001" ctype="SpriteObjectData">
                        <Size X="64.0000" Y="49.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="30.0000" Y="27.0001" />
                        <Scale ScaleX="0.7500" ScaleY="0.7500" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.6000" Y="0.5400" />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="MarkedSubImage" Path="Resources/common/img/XL_3.png" Plist="Resources/common/img/common_img.plist" />
                        <BlendFunc Src="1" Dst="771" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5217" ScaleY="0.4565" />
                    <Position X="45.0000" Y="171.5033" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.1271" Y="0.5914" />
                    <PreSize X="0.1412" Y="0.1724" />
                    <FileData Type="MarkedSubImage" Path="Resources/common/img/BK_t6.png" Plist="Resources/common/img/common_img.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="btn_tick_3" ActionTag="-1923450339" Tag="141" IconVisible="False" LeftMargin="18.9150" RightMargin="285.0850" TopMargin="159.3250" BottomMargin="80.6750" TouchEnable="True" Scale9Width="50" Scale9Height="50" ctype="ImageViewObjectData">
                    <Size X="50.0000" Y="50.0000" />
                    <Children>
                      <AbstractNodeData Name="card3" ActionTag="-347965856" Tag="142" IconVisible="False" LeftMargin="260.5002" RightMargin="-281.5002" TopMargin="-18.0002" BottomMargin="-7.9998" ctype="SpriteObjectData">
                        <Size X="71.0000" Y="76.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="296.0002" Y="30.0002" />
                        <Scale ScaleX="0.9000" ScaleY="0.9000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="5.9200" Y="0.6000" />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="Normal" Path="Resources/common/icon/coin/4.png" Plist="" />
                        <BlendFunc Src="1" Dst="771" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_24" ActionTag="-1030800780" Tag="143" IconVisible="False" LeftMargin="75.0001" RightMargin="-183.0001" TopMargin="6.5000" BottomMargin="16.5000" FontSize="22" LabelText="消耗500张经验卡&#xA;" OutlineEnabled="True" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="TextObjectData">
                        <Size X="171.0000" Y="27.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="75.0001" Y="30.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="1.5000" Y="0.6000" />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FontResource Type="Normal" Path="Resources/font/ttf/black_body_2.TTF" Plist="" />
                        <OutlineColor A="255" R="0" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="card_tick_3" CanEdit="False" ActionTag="-456462817" Tag="144" IconVisible="False" LeftMargin="-2.0000" RightMargin="-12.0000" TopMargin="-1.5001" BottomMargin="2.5001" ctype="SpriteObjectData">
                        <Size X="64.0000" Y="49.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="30.0000" Y="27.0001" />
                        <Scale ScaleX="0.7500" ScaleY="0.7500" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.6000" Y="0.5400" />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="MarkedSubImage" Path="Resources/common/img/XL_3.png" Plist="Resources/common/img/common_img.plist" />
                        <BlendFunc Src="1" Dst="771" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5217" ScaleY="0.4565" />
                    <Position X="45.0000" Y="103.5000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.1271" Y="0.3569" />
                    <PreSize X="0.1412" Y="0.1724" />
                    <FileData Type="MarkedSubImage" Path="Resources/common/img/BK_t6.png" Plist="Resources/common/img/common_img.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="btn_tick_4" ActionTag="-290262539" Tag="145" IconVisible="False" LeftMargin="18.9150" RightMargin="285.0850" TopMargin="227.3250" BottomMargin="12.6750" TouchEnable="True" Scale9Width="50" Scale9Height="50" ctype="ImageViewObjectData">
                    <Size X="50.0000" Y="50.0000" />
                    <Children>
                      <AbstractNodeData Name="card1" ActionTag="-1723308107" Tag="146" IconVisible="False" LeftMargin="260.5002" RightMargin="-281.5002" TopMargin="-18.0002" BottomMargin="-7.9998" ctype="SpriteObjectData">
                        <Size X="71.0000" Y="76.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="296.0002" Y="30.0002" />
                        <Scale ScaleX="0.9000" ScaleY="0.9000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="5.9200" Y="0.6000" />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="Normal" Path="Resources/common/icon/coin/4.png" Plist="" />
                        <BlendFunc Src="1" Dst="771" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="Text_24" ActionTag="-439899332" Tag="147" IconVisible="False" LeftMargin="75.0001" RightMargin="-196.0001" TopMargin="6.5000" BottomMargin="16.5000" FontSize="22" LabelText="消耗3000张经验卡&#xA;" OutlineEnabled="True" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="TextObjectData">
                        <Size X="184.0000" Y="27.0000" />
                        <AnchorPoint ScaleY="0.5000" />
                        <Position X="75.0001" Y="30.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="1.5000" Y="0.6000" />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FontResource Type="Normal" Path="Resources/font/ttf/black_body_2.TTF" Plist="" />
                        <OutlineColor A="255" R="0" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="card_tick_4" CanEdit="False" ActionTag="1501790059" Tag="148" IconVisible="False" LeftMargin="-2.0000" RightMargin="-12.0000" TopMargin="-1.5001" BottomMargin="2.5001" ctype="SpriteObjectData">
                        <Size X="64.0000" Y="49.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="30.0000" Y="27.0001" />
                        <Scale ScaleX="0.7500" ScaleY="0.7500" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.6000" Y="0.5400" />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="MarkedSubImage" Path="Resources/common/img/XL_3.png" Plist="Resources/common/img/common_img.plist" />
                        <BlendFunc Src="1" Dst="771" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5217" ScaleY="0.4565" />
                    <Position X="45.0000" Y="35.5000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.1271" Y="0.1224" />
                    <PreSize X="0.1412" Y="0.1724" />
                    <FileData Type="MarkedSubImage" Path="Resources/common/img/BK_t6.png" Plist="Resources/common/img/common_img.plist" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="cardNum" ActionTag="28986296" Tag="189" IconVisible="False" LeftMargin="44.4904" RightMargin="141.5096" TopMargin="-31.6489" BottomMargin="294.6489" FontSize="24" LabelText="x 1750000000" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="TextObjectData">
                    <Size X="168.0000" Y="27.0000" />
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="44.4904" Y="308.1489" />
                    <Scale ScaleX="1.0000" ScaleY="0.8095" />
                    <CColor A="255" R="253" G="225" B="143" />
                    <PrePosition X="0.1257" Y="1.0626" />
                    <PreSize X="0.0000" Y="0.0000" />
                    <FontResource Type="Normal" Path="Resources/font/ttf/black_body_2.TTF" Plist="" />
                    <OutlineColor A="255" R="0" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="cardIcon" ActionTag="-873160107" Tag="188" IconVisible="False" LeftMargin="-10.9996" RightMargin="293.9996" TopMargin="-58.9200" BottomMargin="272.9200" ctype="SpriteObjectData">
                    <Size X="71.0000" Y="76.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="24.5004" Y="310.9200" />
                    <Scale ScaleX="0.4300" ScaleY="0.4300" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.0692" Y="1.0721" />
                    <PreSize X="0.0000" Y="0.0000" />
                    <FileData Type="Normal" Path="Resources/common/icon/coin/4.png" Plist="" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="192.4976" Y="150.0002" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.3008" Y="0.4249" />
                <PreSize X="0.3278" Y="0.4028" />
                <FileData Type="MarkedSubImage" Path="Resources/common/img/XL_21.png" Plist="Resources/common/img/common_img.plist" />
              </AbstractNodeData>
              <AbstractNodeData Name="accessInfoBg" ActionTag="-1161803810" Tag="190" IconVisible="False" LeftMargin="375.9870" RightMargin="19.0130" TopMargin="60.9219" BottomMargin="62.0781" Scale9Enable="True" LeftEage="15" RightEage="25" TopEage="25" BottomEage="15" Scale9OriginX="15" Scale9OriginY="25" Scale9Width="95" Scale9Height="95" ctype="ImageViewObjectData">
                <Size X="245.0000" Y="230.0000" />
                <Children>
                  <AbstractNodeData Name="accessTitle" ActionTag="-924296904" Tag="192" IconVisible="False" LeftMargin="64.4993" RightMargin="48.5007" TopMargin="4.4211" BottomMargin="194.5789" ctype="SpriteObjectData">
                    <Size X="132.0000" Y="31.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="130.4993" Y="210.0789" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5327" Y="0.9134" />
                    <PreSize X="0.0000" Y="0.0000" />
                    <FileData Type="MarkedSubImage" Path="Resources/training/XL_22.png" Plist="Resources/training/training.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="autoBtn" ActionTag="-1863121828" Tag="193" IconVisible="False" LeftMargin="-4.3926" RightMargin="124.3926" TopMargin="235.5257" BottomMargin="-58.5257" TouchEnable="True" FontSize="20" ButtonText="一键升级" Scale9Enable="True" Scale9Width="152" Scale9Height="66" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
                    <Size X="125.0000" Y="53.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="58.1074" Y="-32.0257" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.2372" Y="-0.1392" />
                    <PreSize X="0.5102" Y="0.2304" />
                    <FontResource Type="Normal" Path="Resources/font/ttf/black_body.TTF" Plist="" />
                    <TextColor A="255" R="255" G="255" B="255" />
                    <DisabledFileData Type="Default" Path="Default/Button_Disable.png" Plist="" />
                    <PressedFileData Type="MarkedSubImage" Path="Resources/common/button/anniuhong02.png" Plist="Resources/common/button/common_button.plist" />
                    <NormalFileData Type="MarkedSubImage" Path="Resources/common/button/btn_3.png" Plist="Resources/common/button/common_button.plist" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="confirmBtn" ActionTag="-764599132" Tag="194" IconVisible="False" LeftMargin="120.3055" RightMargin="-0.3055" TopMargin="235.1397" BottomMargin="-58.1397" TouchEnable="True" FontSize="22" ButtonText="确定" Scale9Enable="True" Scale9Width="152" Scale9Height="65" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
                    <Size X="125.0000" Y="53.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="182.8055" Y="-31.6397" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.7461" Y="-0.1376" />
                    <PreSize X="0.5102" Y="0.2304" />
                    <FontResource Type="Normal" Path="Resources/font/ttf/black_body.TTF" Plist="" />
                    <TextColor A="255" R="255" G="255" B="255" />
                    <DisabledFileData Type="Default" Path="Default/Button_Disable.png" Plist="" />
                    <PressedFileData Type="MarkedSubImage" Path="Resources/common/button/anniuhong02.png" Plist="Resources/common/button/common_button.plist" />
                    <NormalFileData Type="MarkedSubImage" Path="Resources/common/button/btn_3.png" Plist="Resources/common/button/common_button.plist" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="498.4870" Y="177.0781" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.7789" Y="0.5016" />
                <PreSize X="0.2269" Y="0.3194" />
                <FileData Type="MarkedSubImage" Path="Resources/common/img/XL_21.png" Plist="Resources/common/img/common_img.plist" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="540.0000" Y="211.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.5000" Y="0.2931" />
            <PreSize X="0.5926" Y="0.4903" />
            <FileData Type="Normal" Path="Resources/training/XL_6.jpg" Plist="" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameProjectFile>