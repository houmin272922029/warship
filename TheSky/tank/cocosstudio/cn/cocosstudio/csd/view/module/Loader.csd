<GameProjectFile>
  <PropertyGroup Type="Layer" Name="Loader" ID="536298d1-001e-4b6e-987f-62125fc4e5ca" Version="2.3.1.2" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="0" Speed="1.0000" />
      <ObjectData Name="Layer" Tag="7" ctype="GameLayerObjectData">
        <Size X="1080.0000" Y="720.0000" />
        <Children>
          <AbstractNodeData Name="Sprite_1" ActionTag="434472" Tag="4" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="257.0000" RightMargin="257.0000" TopMargin="261.0000" BottomMargin="261.0000" ctype="SpriteObjectData">
            <Size X="566.0000" Y="198.0000" />
            <Children>
              <AbstractNodeData Name="LoadingBar_1" ActionTag="-1668115137" Tag="6" IconVisible="False" LeftMargin="30.5000" RightMargin="30.5000" TopMargin="44.5000" BottomMargin="132.5000" ProgressInfo="0" ctype="LoadingBarObjectData">
                <Size X="505.0000" Y="21.0000" />
                <AnchorPoint ScaleY="0.5000" />
                <Position X="30.5000" Y="143.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.0539" Y="0.7222" />
                <PreSize X="0.8922" Y="0.1694" />
                <ImageFileData Type="MarkedSubImage" Path="Resources/module/5.png" Plist="Resources/plist/module.plist" />
              </AbstractNodeData>
              <AbstractNodeData Name="Sprite_3" ActionTag="-702646698" Tag="7" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="19.5000" RightMargin="19.5000" TopMargin="34.5000" BottomMargin="120.5000" ctype="SpriteObjectData">
                <Size X="527.0000" Y="43.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="283.0000" Y="142.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="0.7172" />
                <PreSize X="0.9311" Y="0.3468" />
                <FileData Type="MarkedSubImage" Path="Resources/module/2.png" Plist="Resources/plist/module.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="Cursor_1" ActionTag="-355605859" Tag="11" IconVisible="False" LeftMargin="23.0000" RightMargin="528.0000" TopMargin="31.5000" BottomMargin="119.5000" ctype="SpriteObjectData">
                <Size X="15.0000" Y="47.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="30.5000" Y="143.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.0539" Y="0.7222" />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="MarkedSubImage" Path="Resources/module/7.png" Plist="Resources/plist/module.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="Text_1" ActionTag="2051450264" Tag="13" Rotation="15.0000" RotationSkewX="15.0000" IconVisible="False" LeftMargin="208.4160" RightMargin="223.5840" TopMargin="85.5000" BottomMargin="85.5000" FontSize="22" LabelText="正在加载资源" OutlineEnabled="True" ShadowOffsetX="1.0000" ShadowOffsetY="-1.0000" ShadowEnabled="True" ctype="TextObjectData">
                <Size X="134.0000" Y="27.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="275.4160" Y="99.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="244" G="227" B="32" />
                <PrePosition X="0.4866" Y="0.5000" />
                <PreSize X="0.0000" Y="0.0000" />
                <FontResource Type="Normal" Path="Resources/font/ttf/black_body_2.TTF" Plist="" />
                <OutlineColor A="255" R="0" G="0" B="0" />
                <ShadowColor A="255" R="0" G="0" B="0" />
              </AbstractNodeData>
              <AbstractNodeData Name="Text_1_0" ActionTag="-1659976585" Tag="14" Rotation="15.0000" RotationSkewX="15.0000" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="206.5059" RightMargin="286.4941" TopMargin="132.5000" BottomMargin="38.5000" FontSize="22" LabelText="总进度:" OutlineEnabled="True" ShadowOffsetX="1.0000" ShadowOffsetY="-1.0000" ShadowEnabled="True" ctype="TextObjectData">
                <Size X="73.0000" Y="27.0000" />
                <AnchorPoint ScaleY="0.5000" />
                <Position X="206.5059" Y="52.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.3649" Y="0.2626" />
                <PreSize X="0.1908" Y="0.1694" />
                <FontResource Type="Normal" Path="Resources/font/ttf/black_body_2.TTF" Plist="" />
                <OutlineColor A="255" R="0" G="0" B="0" />
                <ShadowColor A="255" R="0" G="0" B="0" />
              </AbstractNodeData>
              <AbstractNodeData Name="Text_progress" ActionTag="2131690778" Tag="16" Rotation="15.0000" RotationSkewX="15.0000" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="286.4942" RightMargin="245.5058" TopMargin="132.5000" BottomMargin="38.5000" FontSize="22" LabelText="0%" OutlineEnabled="True" ShadowOffsetX="1.0000" ShadowOffsetY="-1.0000" ShadowEnabled="True" ctype="TextObjectData">
                <Size X="34.0000" Y="27.0000" />
                <AnchorPoint ScaleY="0.5000" />
                <Position X="286.4942" Y="52.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5062" Y="0.2626" />
                <PreSize X="0.1378" Y="0.1694" />
                <FontResource Type="Normal" Path="Resources/font/ttf/black_body_2.TTF" Plist="" />
                <OutlineColor A="255" R="0" G="0" B="0" />
                <ShadowColor A="255" R="0" G="0" B="0" />
              </AbstractNodeData>
              <AbstractNodeData Name="Sprite_7" ActionTag="2087123266" Tag="15" IconVisible="False" LeftMargin="5.0000" RightMargin="471.0000" TopMargin="-42.0000" BottomMargin="194.0000" ctype="SpriteObjectData">
                <Size X="90.0000" Y="46.0000" />
                <AnchorPoint ScaleY="0.5000" />
                <Position X="5.0000" Y="217.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.0088" Y="1.0960" />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="MarkedSubImage" Path="Resources/module/4.png" Plist="Resources/plist/module.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="540.0000" Y="360.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.5000" Y="0.5000" />
            <PreSize X="0.5241" Y="0.1722" />
            <FileData Type="MarkedSubImage" Path="Resources/module/d1.png" Plist="Resources/plist/module.plist" />
            <BlendFunc Src="1" Dst="771" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameProjectFile>