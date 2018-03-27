<GameProjectFile>
  <PropertyGroup Type="Layer" Name="MailDialog" ID="389620c0-1442-4ccb-8bc2-85df9b7fe4fb" Version="2.3.1.2" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="0" Speed="1.0000" />
      <ObjectData Name="Layer" Tag="126" ctype="GameLayerObjectData">
        <Size X="1080.0000" Y="720.0000" />
        <Children>
          <AbstractNodeData Name="panel" ActionTag="514467182" Tag="221" IconVisible="False" HorizontalEdge="BothEdge" LeftMargin="91.5000" RightMargin="93.5000" TopMargin="43.0000" BottomMargin="92.0000" TouchEnable="True" ClipAble="True" BackColorAlpha="102" ColorAngle="90.0000" ctype="PanelObjectData">
            <Size X="895.0000" Y="585.0000" />
            <Children>
              <AbstractNodeData Name="notice" CanEdit="False" ActionTag="-781889836" Tag="210" IconVisible="True" LeftMargin="27.7502" RightMargin="867.2498" TopMargin="489.6437" BottomMargin="95.3563" ctype="SingleNodeObjectData">
                <Size X="0.0000" Y="0.0000" />
                <Children>
                  <AbstractNodeData Name="scrollView" ActionTag="1694907579" Tag="161" IconVisible="False" LeftMargin="20.0000" RightMargin="-820.0000" TopMargin="-342.0897" BottomMargin="-107.9103" TouchEnable="True" ClipAble="True" BackColorAlpha="102" ColorAngle="90.0000" IsBounceEnabled="True" ScrollDirectionType="Vertical" ctype="ScrollViewObjectData">
                    <Size X="800.0000" Y="450.0000" />
                    <AnchorPoint ScaleY="1.0000" />
                    <Position X="20.0000" Y="342.0897" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition />
                    <PreSize X="0.0000" Y="0.0000" />
                    <SingleColor A="255" R="255" G="150" B="100" />
                    <FirstColor A="255" R="255" G="150" B="100" />
                    <EndColor A="255" R="255" G="255" B="255" />
                    <ColorVector ScaleY="1.0000" />
                    <InnerNodeSize Width="800" Height="450" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint />
                <Position X="27.7502" Y="95.3563" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.0310" Y="0.1630" />
                <PreSize X="0.0000" Y="0.0000" />
              </AbstractNodeData>
              <AbstractNodeData Name="message" CanEdit="False" Visible="False" ActionTag="-953136376" Tag="135" IconVisible="True" LeftMargin="17.0000" RightMargin="878.0000" TopMargin="495.0000" BottomMargin="90.0000" ctype="SingleNodeObjectData">
                <Size X="0.0000" Y="0.0000" />
                <Children>
                  <AbstractNodeData Name="messageList" CanEdit="False" ActionTag="-1815200985" Tag="129" IconVisible="True" LeftMargin="-3.0000" RightMargin="3.0000" ctype="SingleNodeObjectData">
                    <Size X="0.0000" Y="0.0000" />
                    <Children>
                      <AbstractNodeData Name="bg2" ActionTag="-742310914" Tag="201" IconVisible="False" LeftMargin="1.4995" RightMargin="-404.4995" TopMargin="-301.6317" BottomMargin="-20.3683" Scale9Width="404" Scale9Height="322" ctype="ImageViewObjectData">
                        <Size X="403.0000" Y="322.0000" />
                        <Children>
                          <AbstractNodeData Name="listEmptyTips" ActionTag="-2062788057" Tag="140" IconVisible="False" LeftMargin="82.5000" RightMargin="89.5000" TopMargin="112.3680" BottomMargin="184.6320" FontSize="20" LabelText="You don't have any mail" OutlineEnabled="True" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="TextObjectData">
                            <Size X="231.0000" Y="25.0000" />
                            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                            <Position X="198.0000" Y="197.1320" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="230" G="219" B="116" />
                            <PrePosition X="0.4913" Y="0.6122" />
                            <PreSize X="0.0000" Y="0.0000" />
                            <FontResource Type="Normal" Path="Resources/font/ttf/black_body_2.TTF" Plist="" />
                            <OutlineColor A="255" R="0" G="0" B="0" />
                            <ShadowColor A="255" R="110" G="110" B="110" />
                          </AbstractNodeData>
                        </Children>
                        <AnchorPoint ScaleX="1.0000" ScaleY="0.5000" />
                        <Position X="404.4995" Y="140.6317" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="MarkedSubImage" Path="Resources/mail/03.png" Plist="Resources/mail/mail.plist" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint />
                    <Position X="-3.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition />
                    <PreSize X="0.0000" Y="0.0000" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="messContent" CanEdit="False" ActionTag="1569112519" Tag="134" IconVisible="True" LeftMargin="421.0000" RightMargin="-421.0000" ctype="SingleNodeObjectData">
                    <Size X="0.0000" Y="0.0000" />
                    <Children>
                      <AbstractNodeData Name="readBg" CanEdit="False" ActionTag="-530667347" Tag="201" IconVisible="False" LeftMargin="-42.5000" RightMargin="-444.5000" TopMargin="-319.0000" BottomMargin="-29.0000" Scale9Enable="True" LeftEage="151" RightEage="151" TopEage="103" BottomEage="103" Scale9OriginX="151" Scale9OriginY="103" Scale9Width="185" Scale9Height="142" ctype="ImageViewObjectData">
                        <Size X="487.0000" Y="348.0000" />
                        <Children>
                          <AbstractNodeData Name="readList" ActionTag="-2036788042" Tag="204" IconVisible="True" LeftMargin="34.3626" RightMargin="452.6374" TopMargin="317.7627" BottomMargin="30.2373" ctype="SingleNodeObjectData">
                            <Size X="0.0000" Y="0.0000" />
                            <Children>
                              <AbstractNodeData Name="Sprite_48" CanEdit="False" ActionTag="-1998874869" Tag="144" IconVisible="False" LeftMargin="21.9999" RightMargin="-397.9999" TopMargin="-284.5000" BottomMargin="241.5000" ctype="SpriteObjectData">
                                <Size X="376.0000" Y="43.0000" />
                                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                                <Position X="209.9999" Y="263.0000" />
                                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                                <CColor A="255" R="255" G="255" B="255" />
                                <PrePosition />
                                <PreSize X="0.0000" Y="0.0000" />
                                <FileData Type="MarkedSubImage" Path="Resources/common/img/06.png" Plist="Resources/common/img/common_img.plist" />
                                <BlendFunc Src="1" Dst="771" />
                              </AbstractNodeData>
                              <AbstractNodeData Name="sendTitle" ActionTag="1986511355" Tag="203" IconVisible="False" LeftMargin="39.7467" RightMargin="-103.7467" TopMargin="-276.5000" BottomMargin="251.5000" FontSize="20" LabelText="[From]" OutlineEnabled="True" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="TextObjectData">
                                <Size X="64.0000" Y="25.0000" />
                                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                                <Position X="71.7467" Y="264.0000" />
                                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                                <CColor A="255" R="255" G="255" B="0" />
                                <PrePosition />
                                <PreSize X="0.0000" Y="0.0000" />
                                <FontResource Type="Normal" Path="Resources/font/ttf/black_body_2.TTF" Plist="" />
                                <OutlineColor A="255" R="77" G="77" B="77" />
                                <ShadowColor A="255" R="110" G="110" B="110" />
                              </AbstractNodeData>
                              <AbstractNodeData Name="senderName" ActionTag="-1803847975" Tag="205" IconVisible="False" LeftMargin="127.0000" RightMargin="-127.0000" TopMargin="-264.0000" BottomMargin="264.0000" FontSize="20" LabelText="" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="TextObjectData">
                                <Size X="0.0000" Y="0.0000" />
                                <AnchorPoint ScaleY="0.5000" />
                                <Position X="127.0000" Y="264.0000" />
                                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                                <CColor A="255" R="255" G="255" B="255" />
                                <PrePosition />
                                <PreSize X="0.0000" Y="0.0000" />
                                <OutlineColor A="255" R="255" G="0" B="0" />
                                <ShadowColor A="255" R="110" G="110" B="110" />
                              </AbstractNodeData>
                              <AbstractNodeData Name="sendContent" ActionTag="135269076" Tag="212" IconVisible="False" LeftMargin="3.9999" RightMargin="-403.9999" TopMargin="-236.0000" BottomMargin="66.0000" TouchEnable="True" ClipAble="True" BackColorAlpha="102" ColorAngle="90.0000" IsBounceEnabled="True" ScrollDirectionType="Vertical" ctype="ScrollViewObjectData">
                                <Size X="400.0000" Y="170.0000" />
                                <AnchorPoint ScaleY="1.0000" />
                                <Position X="3.9999" Y="236.0000" />
                                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                                <CColor A="255" R="255" G="255" B="255" />
                                <PrePosition />
                                <PreSize X="0.3704" Y="0.2361" />
                                <SingleColor A="255" R="255" G="150" B="100" />
                                <FirstColor A="255" R="255" G="150" B="100" />
                                <EndColor A="255" R="255" G="255" B="255" />
                                <ColorVector ScaleY="1.0000" />
                                <InnerNodeSize Width="400" Height="300" />
                              </AbstractNodeData>
                            </Children>
                            <AnchorPoint />
                            <Position X="34.3626" Y="30.2373" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition X="0.0706" Y="0.0869" />
                            <PreSize X="0.0000" Y="0.0000" />
                          </AbstractNodeData>
                        </Children>
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="201.0000" Y="145.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="MarkedSubImage" Path="Resources/mail/07.png" Plist="Resources/mail/mail.plist" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="wirteBg" Visible="False" ActionTag="472392097" Tag="215" IconVisible="False" LeftMargin="-44.5000" RightMargin="-442.5000" TopMargin="-320.0000" BottomMargin="-28.0000" Scale9Width="487" Scale9Height="348" ctype="ImageViewObjectData">
                        <Size X="487.0000" Y="348.0000" />
                        <Children>
                          <AbstractNodeData Name="wirteList" ActionTag="-889950344" Tag="208" IconVisible="True" LeftMargin="34.3600" RightMargin="452.6400" TopMargin="317.7600" BottomMargin="30.2400" ctype="SingleNodeObjectData">
                            <Size X="0.0000" Y="0.0000" />
                            <Children>
                              <AbstractNodeData Name="Sprite_48_0" CanEdit="False" ActionTag="-1751712842" Tag="145" IconVisible="False" LeftMargin="31.9999" RightMargin="-407.9999" TopMargin="-282.5000" BottomMargin="239.5000" ctype="SpriteObjectData">
                                <Size X="376.0000" Y="43.0000" />
                                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                                <Position X="219.9999" Y="261.0000" />
                                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                                <CColor A="255" R="255" G="255" B="255" />
                                <PrePosition />
                                <PreSize X="0.0000" Y="0.0000" />
                                <FileData Type="MarkedSubImage" Path="Resources/common/img/06.png" Plist="Resources/common/img/common_img.plist" />
                                <BlendFunc Src="1" Dst="771" />
                              </AbstractNodeData>
                              <AbstractNodeData Name="receiveTitle" ActionTag="-1651178437" Tag="36" IconVisible="False" LeftMargin="15.0000" RightMargin="-133.0000" TopMargin="-276.5000" BottomMargin="251.5000" FontSize="20" LabelText="[Addressee]" OutlineEnabled="True" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="TextObjectData">
                                <Size X="118.0000" Y="25.0000" />
                                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                                <Position X="74.0000" Y="264.0000" />
                                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                                <CColor A="255" R="255" G="255" B="0" />
                                <PrePosition />
                                <PreSize X="0.0000" Y="0.0000" />
                                <FontResource Type="Normal" Path="Resources/font/ttf/black_body_2.TTF" Plist="" />
                                <OutlineColor A="255" R="77" G="77" B="77" />
                                <ShadowColor A="255" R="110" G="110" B="110" />
                              </AbstractNodeData>
                              <AbstractNodeData Name="receiveContent" ActionTag="1023905905" Tag="38" IconVisible="False" LeftMargin="21.0000" RightMargin="-401.0000" TopMargin="-237.5000" BottomMargin="30.5000" TouchEnable="True" FontSize="20" IsCustomSize="True" LabelText="" PlaceHolderText="" MaxLengthText="10" ctype="TextFieldObjectData">
                                <Size X="380.0000" Y="207.0000" />
                                <AnchorPoint ScaleY="1.0000" />
                                <Position X="21.0000" Y="237.5000" />
                                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                                <CColor A="255" R="26" G="26" B="26" />
                                <PrePosition />
                                <PreSize X="0.0000" Y="0.0000" />
                              </AbstractNodeData>
                            </Children>
                            <AnchorPoint />
                            <Position X="34.3600" Y="30.2400" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition X="0.0706" Y="0.0869" />
                            <PreSize X="0.0000" Y="0.0000" />
                          </AbstractNodeData>
                        </Children>
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="199.0000" Y="146.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="MarkedSubImage" Path="Resources/mail/07.png" Plist="Resources/mail/mail.plist" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint />
                    <Position X="421.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition />
                    <PreSize X="0.0000" Y="0.0000" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="top" CanEdit="False" ActionTag="-1792348974" Tag="128" IconVisible="True" LeftMargin="-1.0000" RightMargin="1.0000" TopMargin="-318.5000" BottomMargin="318.5000" ctype="SingleNodeObjectData">
                    <Size X="0.0000" Y="0.0000" />
                    <Children>
                      <AbstractNodeData Name="bg1" CanEdit="False" ActionTag="-1848094376" Tag="191" IconVisible="False" LeftMargin="-1.0000" RightMargin="-869.0000" TopMargin="-24.5000" BottomMargin="-12.5000" Scale9Width="870" Scale9Height="37" ctype="ImageViewObjectData">
                        <Size X="870.0000" Y="37.0000" />
                        <Children>
                          <AbstractNodeData Name="tipTitle" ActionTag="435984740" Tag="192" IconVisible="False" LeftMargin="43.0000" RightMargin="775.0000" TopMargin="-6.5000" BottomMargin="16.5000" FontSize="19" LabelText="Tips:" OutlineEnabled="True" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="TextObjectData">
                            <Size X="45.0000" Y="24.0000" />
                            <AnchorPoint ScaleX="1.0000" ScaleY="0.5000" />
                            <Position X="95.0000" Y="30.0000" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="230" G="219" B="116" />
                            <PrePosition X="0.1092" Y="0.8108" />
                            <PreSize X="0.0000" Y="0.0000" />
                            <FontResource Type="Normal" Path="Resources/font/ttf/black_body_2.TTF" Plist="" />
                            <OutlineColor A="255" R="0" G="0" B="0" />
                            <ShadowColor A="255" R="110" G="110" B="110" />
                          </AbstractNodeData>
                          <AbstractNodeData Name="tip" ActionTag="-1073889100" Tag="193" IconVisible="False" LeftMargin="95.0001" RightMargin="44.9999" TopMargin="-3.5000" BottomMargin="-14.5000" IsCustomSize="True" FontSize="18" LabelText="The mail(s) will exist for 30 days, when your mailbox is full, new mail(s) will overlay oldest ones." OutlineEnabled="True" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="TextObjectData">
                            <Size X="730.0000" Y="55.0000" />
                            <AnchorPoint ScaleY="0.5000" />
                            <Position X="95.0001" Y="13.0000" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition X="0.1092" Y="0.3514" />
                            <PreSize X="0.8391" Y="1.4865" />
                            <FontResource Type="Normal" Path="Resources/font/ttf/black_body_2.TTF" Plist="" />
                            <OutlineColor A="255" R="0" G="0" B="0" />
                            <ShadowColor A="255" R="110" G="110" B="110" />
                          </AbstractNodeData>
                        </Children>
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="434.0000" Y="6.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="MarkedSubImage" Path="Resources/mail/01.png" Plist="Resources/mail/mail.plist" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint />
                    <Position X="-1.0000" Y="318.5000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition />
                    <PreSize X="0.0000" Y="0.0000" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="btnList" CanEdit="False" ActionTag="-253027613" Tag="133" IconVisible="True" LeftMargin="-0.0002" RightMargin="0.0002" TopMargin="73.0000" BottomMargin="-73.0000" ctype="SingleNodeObjectData">
                    <Size X="0.0000" Y="0.0000" />
                    <Children>
                      <AbstractNodeData Name="newMessageBtn" ActionTag="537101553" Tag="194" IconVisible="False" LeftMargin="36.4998" RightMargin="-188.4998" TopMargin="-48.8387" BottomMargin="-16.1613" TouchEnable="True" FontSize="24" Scale9Enable="True" Scale9Width="152" Scale9Height="65" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
                        <Size X="152.0000" Y="65.0000" />
                        <Children>
                          <AbstractNodeData Name="new_msg_title" CanEdit="False" ActionTag="1800381373" Tag="33" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="14.0000" RightMargin="14.0000" TopMargin="19.7000" BottomMargin="22.3000" ctype="SpriteObjectData">
                            <Size X="124.0000" Y="23.0000" />
                            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                            <Position X="76.0000" Y="33.8000" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition X="0.5000" Y="0.5200" />
                            <PreSize X="0.8158" Y="0.3538" />
                            <FileData Type="MarkedSubImage" Path="Resources/common/txt/xinjianyoujian.png" Plist="Resources/common/txt/common_txt.plist" />
                            <BlendFunc Src="1" Dst="771" />
                          </AbstractNodeData>
                        </Children>
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="112.4998" Y="16.3387" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <TextColor A="255" R="255" G="255" B="255" />
                        <DisabledFileData Type="MarkedSubImage" Path="Resources/common/button/anniuhui.png" Plist="Resources/common/button/common_button.plist" />
                        <PressedFileData Type="MarkedSubImage" Path="Resources/common/button/anniulan02.png" Plist="Resources/common/button/common_button.plist" />
                        <NormalFileData Type="MarkedSubImage" Path="Resources/common/button/btn_4.png" Plist="Resources/common/button/common_button.plist" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="allOperationBtn" ActionTag="1051501273" Tag="198" IconVisible="False" LeftMargin="205.4998" RightMargin="-357.4998" TopMargin="-49.8399" BottomMargin="-15.1601" TouchEnable="True" FontSize="24" Scale9Enable="True" Scale9Width="152" Scale9Height="65" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
                        <Size X="152.0000" Y="65.0000" />
                        <Children>
                          <AbstractNodeData Name="all_op_title" CanEdit="False" ActionTag="1614179" Tag="36" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="15.0000" RightMargin="15.0000" TopMargin="19.7000" BottomMargin="22.3000" ctype="SpriteObjectData">
                            <Size X="122.0000" Y="23.0000" />
                            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                            <Position X="76.0000" Y="33.8000" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition X="0.5000" Y="0.5200" />
                            <PreSize X="0.8026" Y="0.3538" />
                            <FileData Type="MarkedSubImage" Path="Resources/common/txt/quanbulingqu.png" Plist="Resources/common/txt/common_txt.plist" />
                            <BlendFunc Src="1" Dst="771" />
                          </AbstractNodeData>
                        </Children>
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="281.4998" Y="17.3399" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <TextColor A="255" R="255" G="255" B="255" />
                        <DisabledFileData Type="MarkedSubImage" Path="Resources/common/button/anniuhui.png" Plist="Resources/common/button/common_button.plist" />
                        <PressedFileData Type="MarkedSubImage" Path="Resources/common/button/anniuhong02.png" Plist="Resources/common/button/common_button.plist" />
                        <NormalFileData Type="MarkedSubImage" Path="Resources/common/button/btn_3.png" Plist="Resources/common/button/common_button.plist" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="delteleBtn" ActionTag="-1482807050" Tag="199" IconVisible="False" LeftMargin="468.4988" RightMargin="-620.4988" TopMargin="-50.8399" BottomMargin="-14.1601" TouchEnable="True" FontSize="24" Scale9Enable="True" Scale9Width="152" Scale9Height="65" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
                        <Size X="152.0000" Y="65.0000" />
                        <Children>
                          <AbstractNodeData Name="delete_title" ActionTag="1900640928" Tag="35" IconVisible="False" LeftMargin="33.0024" RightMargin="32.9976" TopMargin="20.3399" BottomMargin="21.6601" ctype="SpriteObjectData">
                            <Size X="86.0000" Y="23.0000" />
                            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                            <Position X="76.0024" Y="33.1601" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition X="0.5000" Y="0.5102" />
                            <PreSize X="0.0000" Y="0.0000" />
                            <FileData Type="MarkedSubImage" Path="Resources/common/txt/shanchu.png" Plist="Resources/common/txt/common_txt.plist" />
                            <BlendFunc Src="1" Dst="771" />
                          </AbstractNodeData>
                        </Children>
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="544.4988" Y="18.3399" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <TextColor A="255" R="255" G="255" B="255" />
                        <DisabledFileData Type="MarkedSubImage" Path="Resources/common/button/anniuhui.png" Plist="Resources/common/button/common_button.plist" />
                        <PressedFileData Type="MarkedSubImage" Path="Resources/common/button/anniuhong02.png" Plist="Resources/common/button/common_button.plist" />
                        <NormalFileData Type="MarkedSubImage" Path="Resources/common/button/btn_3.png" Plist="Resources/common/button/common_button.plist" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="hasReceiveTip" ActionTag="2125688426" Tag="218" Rotation="10.3792" RotationSkewX="10.3792" RotationSkewY="10.3831" IconVisible="False" LeftMargin="654.0024" RightMargin="-800.0024" TopMargin="-82.9995" BottomMargin="-38.0005" ctype="SpriteObjectData">
                        <Size X="146.0000" Y="121.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="727.0024" Y="22.4995" />
                        <Scale ScaleX="0.8500" ScaleY="0.8500" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <FileData Type="MarkedSubImage" Path="Resources/common/img/D_12.png" Plist="Resources/common/img/common_img.plist" />
                        <BlendFunc Src="1" Dst="771" />
                      </AbstractNodeData>
                      <AbstractNodeData Name="replyBtn" ActionTag="2137130443" Tag="200" IconVisible="False" LeftMargin="645.4996" RightMargin="-797.4996" TopMargin="-48.8399" BottomMargin="-16.1601" TouchEnable="True" FontSize="24" Scale9Enable="True" Scale9Width="152" Scale9Height="65" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
                        <Size X="152.0000" Y="65.0000" />
                        <Children>
                          <AbstractNodeData Name="reply_title" ActionTag="522153980" Tag="34" IconVisible="False" HorizontalEdge="BothEdge" LeftMargin="14.0000" RightMargin="14.0000" TopMargin="20.3399" BottomMargin="21.6601" ctype="SpriteObjectData">
                            <Size X="124.0000" Y="23.0000" />
                            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                            <Position X="76.0000" Y="33.1601" />
                            <Scale ScaleX="1.0000" ScaleY="1.0000" />
                            <CColor A="255" R="255" G="255" B="255" />
                            <PrePosition X="0.5000" Y="0.5102" />
                            <PreSize X="0.0000" Y="0.0000" />
                            <FileData Type="MarkedSubImage" Path="Resources/common/txt/xinjianyoujian.png" Plist="Resources/common/txt/common_txt.plist" />
                            <BlendFunc Src="1" Dst="771" />
                          </AbstractNodeData>
                        </Children>
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="721.4996" Y="16.3399" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition />
                        <PreSize X="0.0000" Y="0.0000" />
                        <TextColor A="255" R="255" G="255" B="255" />
                        <DisabledFileData Type="MarkedSubImage" Path="Resources/common/button/anniuhui.png" Plist="Resources/common/button/common_button.plist" />
                        <PressedFileData Type="MarkedSubImage" Path="Resources/common/button/anniulan02.png" Plist="Resources/common/button/common_button.plist" />
                        <NormalFileData Type="MarkedSubImage" Path="Resources/common/button/btn_4.png" Plist="Resources/common/button/common_button.plist" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint />
                    <Position X="-0.0002" Y="-73.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition />
                    <PreSize X="0.0000" Y="0.0000" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint />
                <Position X="17.0000" Y="90.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.0190" Y="0.1538" />
                <PreSize X="0.0000" Y="0.0000" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="539.0000" Y="384.5000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.4991" Y="0.5340" />
            <PreSize X="0.8287" Y="0.8125" />
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