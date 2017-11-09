function reqFun()
    local requiresTable = {}

    table.insert(requiresTable, "lua/conf")
    table.insert(requiresTable, "lua/util/common")
    table.insert(requiresTable, "lua/util/commonEx")
    table.insert(requiresTable, "lua/util/netWork")
    table.insert(requiresTable, "lua/util/ControlModule")
    table.insert(requiresTable, "lua/util/DateUtil")
    table.insert(requiresTable, "lua/util/extern")
    table.insert(requiresTable, "lua/util/scheduler")
    table.insert(requiresTable, "lua/util/userDefault")
    table.insert(requiresTable, "lua/util/Notification")
    table.insert(requiresTable, "lua/util/OPAnimation")
    table.insert(requiresTable, "lua/util/RandomManager")
    table.insert(requiresTable, "lua/util/SoundUtil")

    table.insert(requiresTable, "lua/SSO/sso")
    table.insert(requiresTable, "lua/SSO/protocolLayer")


    -- 根据渠道 区分语言
    if opPCL == IOS_TEST_ZH then             -- ios内网测试
        table.insert(requiresTable, "lua/Localizable")

    elseif opPCL == ANDROID_TEST_ZH then     -- android内网测试   
        table.insert(requiresTable, "lua/Localizable")

    elseif opPCL == IOS_TW_ZH then           -- ios外网
        table.insert(requiresTable, "lua/Localizable")

    elseif opPCL == ANDROID_TW_ZH then          -- android外网
        table.insert(requiresTable, "lua/Localizable")

    elseif opPCL == IOS_VIETNAM_VI or opPCL == ANDROID_VIETNAM_VI then          -- 越南
        table.insert(requiresTable, "lua/Localizable-vn")
    elseif opPCL == WP_VIETNAM_VN then          -- 越南
        table.insert(requiresTable, "lua/Localizable-vn")
        table.insert(requiresTable, "lua/UI/VNRechargeLayer")
    elseif opPCL == WP_VIETNAM_EN then
        table.insert(requiresTable, "lua/Localizable-en")
        table.insert(requiresTable, "lua/UI/VNRechargeLayer")
    elseif opPCL == IOS_VIETNAM_EN or opPCL == IOS_MOBNAPPLE_EN or opPCL == IOS_GAMEVIEW_EN or opPCL == IOS_GVEN_BREAK or opPCL == ANDROID_VIETNAM_EN 
        or opPCL == ANDROID_VIETNAM_EN_ALL or opPCL == ANDROID_GV_MFACE_EN or opPCL == ANDROID_GV_MFACE_EN_OUMEI 
        or opPCL == ANDROID_GV_MFACE_EN_OUMEINEW  or opPCL == IOS_VIETNAM_ENSAGA then
        table.insert(requiresTable, "lua/Localizable-en")

    elseif opPCL == IOS_MOB_THAI or opPCL == ANDROID_VIETNAM_MOB_THAI or  opPCL == IOS_TGAME_TH or opPCL == ANDROID_TGAME_THAI then          -- MOBGAME
        table.insert(requiresTable, "lua/Localizable-th")

    elseif opPCL == IOS_TGAME_KR or opPCL == ANDROID_TGAME_KR  or opPCL == ANDROID_TGAME_KRNEW then          -- TGAME
        table.insert(requiresTable, "lua/Localizable-kr")

    elseif opPCL == IOS_INFIPLAY_RUS or opPCL == ANDROID_INFIPLAY_RUS then          -- 俄罗斯版
        table.insert(requiresTable, "lua/Localizable-rus")

    elseif opPCL == IOS_GAMEVIEW_TC or opPCL == ANDROID_GV_MFACE_TC or opPCL == ANDROID_GV_MFACE_TC_GP or opPCL == ANDROID_JAGUAR_TC
        or opPCL == IOS_JAGUAR_TC or opPCL == IOS_TGAME_TC or opPCL == ANDROID_TGAME_TC then          -- TGAME
        table.insert(requiresTable, "lua/Localizable-tc")

    elseif opPCL ==  IOS_MOBGAME_SPAIN or opPCL == ANDROID_MOBGAME_SPAIN then        -- spain
        table.insert(requiresTable, "lua/Localizable-spain")
        
    else
        table.insert(requiresTable, "lua/Localizable")
    end

    table.insert(requiresTable, "lua/Activities/ExchangeActivityLayer")
    table.insert(requiresTable, "lua/Activities/PurchaseRebateLayer")
    table.insert(requiresTable, "lua/Activities/ExpenseRebateLayer")
    table.insert(requiresTable, "lua/Activities/ExpenseRebateGoldLayer")
    table.insert(requiresTable, "lua/Activities/PurchaseSingleRebateLayer")
    table.insert(requiresTable, "lua/Activities/QuizMainLayer")
    table.insert(requiresTable, "lua/Activities/QuizLayer")
    table.insert(requiresTable, "lua/Activities/QuizChooseLayer")
    table.insert(requiresTable, "lua/Activities/QuizBetLayer")
    table.insert(requiresTable, "lua/Activities/QuizListLayer")
    table.insert(requiresTable, "lua/Activities/QuizResultLayer")
    table.insert(requiresTable, "lua/Activities/QuizRewardLayer")
    table.insert(requiresTable, "lua/Activities/ActivityOfLevelUp")
    table.insert(requiresTable, "lua/Activities/ActivityOfArenaCompetitionLayer")
    table.insert(requiresTable, "lua/Activities/ThePlanOfBuyBallLayer")

    table.insert(requiresTable, "lua/Activities/ActivityOfGambleStartLayer")
    table.insert(requiresTable, "lua/Activities/ActivityOfGambleHelpLayer")
    
    table.insert(requiresTable, "lua/EquipmentView/equipmentsLayer")
    table.insert(requiresTable, "lua/EquipmentView/allEquipsLayer")
    table.insert(requiresTable, "lua/EquipmentView/weaponsLayer")
    table.insert(requiresTable, "lua/EquipmentView/clothingLayer")
    table.insert(requiresTable, "lua/EquipmentView/decorationsLayer")
    table.insert(requiresTable, "lua/EquipmentView/runesLayer")
    table.insert(requiresTable, "lua/EquipmentView/EquipSellLayerView")
    table.insert(requiresTable, "lua/EquipmentView/EquipUpdateLayer")
    table.insert(requiresTable, "lua/EquipmentView/EquipRefineLayer")
    table.insert(requiresTable, "lua/EquipmentView/EquipChangeSelcetLayer")

    table.insert(requiresTable, "lua/LoginView/LoginView")
    table.insert(requiresTable, "lua/LoginView/CreateNameView")
    table.insert(requiresTable, "lua/LoginView/LoginMainView")
    table.insert(requiresTable, "lua/LoginView/LoginServerView")
    table.insert(requiresTable, "lua/LoginView/LoginLoginLayer")
    table.insert(requiresTable, "lua/LoginView/LoginNewAccountLayer")
    table.insert(requiresTable, "lua/LoginView/LoginModifyPwdLayer")
    if newUpdate and newUpdate() then
        table.insert(requiresTable, "lua/LoginView/LoginUpdateLayerV2")
    else
        table.insert(requiresTable, "lua/LoginView/LoginUpdateLayer")
    end

    table.insert(requiresTable, "lua/Module/userdata")
    table.insert(requiresTable, "lua/Module/ConfigureStorage")
    table.insert(requiresTable, "lua/Module/herodata")
    table.insert(requiresTable, "lua/Module/heroSoulData")
    table.insert(requiresTable, "lua/Module/recruitData")
    table.insert(requiresTable, "lua/Module/shopData")
    table.insert(requiresTable, "lua/Module/VipShopData")
    table.insert(requiresTable, "lua/Module/runtimeCache")
    table.insert(requiresTable, "lua/Module/storydata")
    table.insert(requiresTable, "lua/Module/giftBagData")
    table.insert(requiresTable, "lua/Module/equipdata")
    table.insert(requiresTable, "lua/Module/battledata")
    table.insert(requiresTable, "lua/Module/wareHouseData")
    table.insert(requiresTable, "lua/Module/skilldata")
    table.insert(requiresTable, "lua/Module/battleShipData")
    table.insert(requiresTable, "lua/Module/dailyData")
    table.insert(requiresTable, "lua/Module/blooddata")
    table.insert(requiresTable, "lua/Module/chapterdata")
    table.insert(requiresTable, "lua/Module/arenadata")
    table.insert(requiresTable, "lua/Module/titleData")
    table.insert(requiresTable, "lua/Module/topRollData")
    table.insert(requiresTable, "lua/Module/playerBattleData")
    table.insert(requiresTable, "lua/Module/continueLoginRewardData")
    table.insert(requiresTable, "lua/Module/vipdata")
    table.insert(requiresTable, "lua/Module/announceData")
    table.insert(requiresTable, "lua/Module/hotBalloonData")
    table.insert(requiresTable, "lua/Module/maildata")
    table.insert(requiresTable, "lua/Module/friendData")
    table.insert(requiresTable, "lua/Module/unionData")
    table.insert(requiresTable, "lua/Module/bossdata")
    table.insert(requiresTable, "lua/Module/marineBranchData")
    table.insert(requiresTable, "lua/Module/shadowData")
    table.insert(requiresTable, "lua/Module/LoginActivityData")
    table.insert(requiresTable, "lua/Module/shardData")
    table.insert(requiresTable, "lua/Module/worldwardata")
    table.insert(requiresTable, "lua/Module/veiledSeaData")
    table.insert(requiresTable, "lua/Module/questdata")
    table.insert(requiresTable, "lua/Module/elitedata")
    table.insert(requiresTable, "lua/Module/awakeData")

    table.insert(requiresTable, "lua/LogueTownView/LogueTownView")
    table.insert(requiresTable, "lua/LogueTownView/RecruitView")
    table.insert(requiresTable, "lua/LogueTownView/ZhaohuanAniLayer")
    table.insert(requiresTable, "lua/LogueTownView/ItemsView")
    table.insert(requiresTable, "lua/LogueTownView/GiftBagView")
    table.insert(requiresTable, "lua/LogueTownView/RecruitHeroesView")
    table.insert(requiresTable, "lua/LogueTownView/VipShopView")


    table.insert(requiresTable, "lua/MainView/mainLayer")
    table.insert(requiresTable, "lua/MainView/menuLayer")
    table.insert(requiresTable, "lua/MainView/homeLayer")
    table.insert(requiresTable, "lua/MainView/loginActivityView")
    table.insert(requiresTable, "lua/MainView/LoginActivityCellView")
    table.insert(requiresTable, "lua/MainView/ContinueLoginRewardLayer")

    table.insert(requiresTable, "lua/NewYearActivity/NewYearActivityView")
    table.insert(requiresTable, "lua/NewYearActivity/NewYearRankView")
    table.insert(requiresTable, "lua/NewYearActivity/NewYearActivityIntroView")
    
    table.insert(requiresTable, "lua/FightingView/FightingView")
    table.insert(requiresTable, "lua/FightingView/FightingBg_1")
    table.insert(requiresTable, "lua/FightingView/FightingBg_2")
    table.insert(requiresTable, "lua/FightingView/FightingBg_3")
    table.insert(requiresTable, "lua/FightingView/FightingBg_4")
    table.insert(requiresTable, "lua/FightingView/FightingBg_5")
    table.insert(requiresTable, "lua/FightingView/FightingBg_6")
    table.insert(requiresTable, "lua/FightingView/FightAniCtrl")
    table.insert(requiresTable, "lua/FightingView/BattleLog")
    table.insert(requiresTable, "lua/FightingView/SoldierSprite")
    table.insert(requiresTable, "lua/FightingView/Soldier")
    table.insert(requiresTable, "lua/FightingView/BattleField")

    table.insert(requiresTable, "lua/FriendView/FriendView")
    table.insert(requiresTable, "lua/FriendView/AddFriendLayer")

    table.insert(requiresTable, "lua/HeroesView/heroesLayer")
    table.insert(requiresTable, "lua/HeroesView/cultureLayer")
    table.insert(requiresTable, "lua/HeroesView/farewellLayer")
    table.insert(requiresTable, "lua/HeroesView/selHeroFarewellLayer")
    table.insert(requiresTable, "lua/HeroesView/selectSMPLayer")
    table.insert(requiresTable, "lua/HeroesView/breakLayer")

    table.insert(requiresTable, "lua/HandbookView/handBookView")

    table.insert(requiresTable, "lua/BattleShipView/battleShipLayer")
    table.insert(requiresTable, "lua/BattleShipView/BattleShipUpdateLayer")

    table.insert(requiresTable, "lua/UI/infoLayer")
    table.insert(requiresTable, "lua/UI/equipInfoLayer")
    table.insert(requiresTable, "lua/UI/simpleConfirmCardLayer")
    table.insert(requiresTable, "lua/UI/confirmCardWithTitleAndEditBox")
    table.insert(requiresTable, "lua/UI/callingAnimationLayer")
    table.insert(requiresTable, "lua/UI/callingAnimationLayer2")
    table.insert(requiresTable, "lua/UI/convAnimationLayer")
    table.insert(requiresTable, "lua/UI/breakSkillAniLayer")
    table.insert(requiresTable, "lua/UI/hotBalloonAnimation")
    table.insert(requiresTable, "lua/UI/hotBalloonAnimation2")
    table.insert(requiresTable, "lua/UI/heroInfoLayer")
    table.insert(requiresTable, "lua/UI/SkillDetailView")
    table.insert(requiresTable, "lua/UI/SkillDetailViewCanChange")
    table.insert(requiresTable, "lua/UI/itemDetailInfoLayer")
    table.insert(requiresTable, "lua/UI/SkillHandBookDetailView")
    table.insert(requiresTable, "lua/UI/chapterInfoLayer")
    table.insert(requiresTable, "lua/UI/chapterRobFailLayer")
    table.insert(requiresTable, "lua/UI/chapterRobSuccLayer")
    table.insert(requiresTable, "lua/UI/chapterDetailInfoLayer")
    table.insert(requiresTable, "lua/UI/titleInfoLayer")
    table.insert(requiresTable, "lua/UI/allTitleInfoLayer")
    table.insert(requiresTable, "lua/UI/captainUpdateLayer")
    table.insert(requiresTable, "lua/UI/captainGetNewTitleLayer")
    table.insert(requiresTable, "lua/UI/getSomeRewardLayer")
    table.insert(requiresTable, "lua/UI/leaveMessageLayer")
    table.insert(requiresTable, "lua/UI/friendOptionLayer")
    table.insert(requiresTable, "lua/UI/captainInfoLayer")
    table.insert(requiresTable, "lua/UI/equipRefineResult")
    table.insert(requiresTable, "lua/UI/instructGroupResultLayer")
    table.insert(requiresTable, "lua/UI/instructSelectHeroLayer")
    table.insert(requiresTable, "lua/UI/instructSingleResultLayer")
    table.insert(requiresTable, "lua/UI/ShopRechargeLayer")
    table.insert(requiresTable, "lua/UI/shopBuySomePopUp")
    table.insert(requiresTable, "lua/UI/announceViewLayer")
    table.insert(requiresTable, "lua/UI/vipDetailLayer")
    table.insert(requiresTable, "lua/UI/vipDetailPageView")
    table.insert(requiresTable, "lua/UI/bluckSingHeroSelectLayer")
    table.insert(requiresTable, "lua/UI/singSongCountNotEnough")
    table.insert(requiresTable, "lua/UI/singSongSuccessPopUp")
    table.insert(requiresTable, "lua/UI/shareLayer")
    table.insert(requiresTable, "lua/UI/recoverInfoLayer")
    table.insert(requiresTable, "lua/UI/itemNotEnoughPopUp")
    table.insert(requiresTable, "lua/UI/getSkillStampLayer")
    table.insert(requiresTable, "lua/UI/teamCompLayer")
    table.insert(requiresTable, "lua/UI/teamPopupLayer")
    table.insert(requiresTable, "lua/UI/firstPurchaseTipLayer")
    table.insert(requiresTable, "lua/UI/touchFeedbackLayer")
    table.insert(requiresTable, "lua/UI/logueItemDetailInfoLayer")
    table.insert(requiresTable, "lua/UI/logueVipBagDetailLayer")
    table.insert(requiresTable, "lua/UI/instructHeroGGetLayer")
    table.insert(requiresTable, "lua/UI/instructHeroSGetLayer")
    table.insert(requiresTable, "lua/UI/itemNotEnoughTipsLayer")
    table.insert(requiresTable, "lua/UI/getClickSuccessPopUp")
    table.insert(requiresTable, "lua/UI/loginErrorPopUp")
    table.insert(requiresTable, "lua/UI/vipPackageDetailView")
    table.insert(requiresTable, "lua/UI/buyAndUseLayer")
    table.insert(requiresTable, "lua/UI/loadingLayer")
    table.insert(requiresTable, "lua/UI/UnionConfirmLayer")
    table.insert(requiresTable, "lua/UI/UnionTitleChangeLayer")
    table.insert(requiresTable, "lua/UI/getInviteRewardLayer")
    table.insert(requiresTable, "lua/UI/ShadowGetPopUp")
    table.insert(requiresTable, "lua/UI/yuekaSajiaoPopup")
    table.insert(requiresTable, "lua/UI/UnionDetailInfoLayer")
    table.insert(requiresTable, "lua/UI/DelayBagDetailView")
    
    table.insert(requiresTable, "lua/UI/ThirdPartPayPopUp")
    table.insert(requiresTable, "lua/UI/CommonHelpView")
    table.insert(requiresTable, "lua/UI/MultiItemLayer")
    
    table.insert(requiresTable, "lua/Union/UnionMainView")
    table.insert(requiresTable, "lua/Union/UnionInnerLayer")
    table.insert(requiresTable, "lua/Union/UnionMemberLayer")
    table.insert(requiresTable, "lua/Union/UnionMemberMenu")
    table.insert(requiresTable, "lua/Union/UnionOuterLayer")
    table.insert(requiresTable, "lua/Union/UnionRankLayer")
    table.insert(requiresTable, "lua/Union/UnionRankInfoLayer")
    table.insert(requiresTable, "lua/Union/UnionManageLayer")
    table.insert(requiresTable, "lua/Union/UnionAcceptLayer")
    table.insert(requiresTable, "lua/Union/UnionJuanXianLayer")
    table.insert(requiresTable, "lua/Union/UnionJoinLayer")
    table.insert(requiresTable, "lua/Union/UnionCreateLayer")
    table.insert(requiresTable, "lua/Union/UnionJoinInfoLayer")
    table.insert(requiresTable, "lua/Union/UnionFingerGuessingMainLayer")
    table.insert(requiresTable, "lua/Union/UnionFingerGuessingWinLayer")
    table.insert(requiresTable, "lua/Union/UnionFingerGuessingNoWinLayer")
    table.insert(requiresTable, "lua/Union/UnionInformationLayer")
    table.insert(requiresTable, "lua/Union/UnionBattleLayer")
    table.insert(requiresTable, "lua/Union/UnionRefreshPreviewPopUp")
    table.insert(requiresTable, "lua/Union/UnionShopLayer")
    table.insert(requiresTable, "lua/Union/UnionUpgrateLayer")
    table.insert(requiresTable, "lua/Union/UnionContributionPopUp")
    table.insert(requiresTable, "lua/Union/UnionBattleConfirmCard")
    table.insert(requiresTable, "lua/Union/UnionBattlePayCard")
    table.insert(requiresTable, "lua/Union/UnionBattlePreviewCard")
    table.insert(requiresTable, "lua/Union/UnionCandyLayer")
    table.insert(requiresTable, "lua/Union/UnionArmySelectLayer")
    table.insert(requiresTable, "lua/Union/UnionBattleFixCard")

    table.insert(requiresTable, "lua/WareHouseView/wareHouselayer")

    table.insert(requiresTable, "lua/SailView/sailLayer")
    table.insert(requiresTable, "lua/SailView/sweepLayer")
    table.insert(requiresTable, "lua/SailView/stageTalkLayer")

    table.insert(requiresTable, "lua/SkillView/skillLayer")
    table.insert(requiresTable, "lua/SkillView/breakSkillView")
    table.insert(requiresTable, "lua/SkillView/skillBreakSelectView")
    table.insert(requiresTable, "lua/SkillView/SkillBreakResultView")
    table.insert(requiresTable, "lua/SkillView/SkillChangeSelectView")

    table.insert(requiresTable, "lua/TeamView/teamLayer")
    table.insert(requiresTable, "lua/TeamView/changeTeamLayer")
    table.insert(requiresTable, "lua/TeamView/onFormLayer")
    table.insert(requiresTable, "lua/TeamView/shadowPop")
    table.insert(requiresTable, "lua/TeamView/changeShadowLayer")
    table.insert(requiresTable, "lua/TeamView/LaLaViewUpdataLayer")


    table.insert(requiresTable, "lua/TrainShadow/TrainShadowLayer")
    table.insert(requiresTable, "lua/TrainShadow/ShadowBox")
    table.insert(requiresTable, "lua/TrainShadow/ShadowWave")
    table.insert(requiresTable, "lua/TrainShadow/TrainView")
    table.insert(requiresTable, "lua/TrainShadow/UpdateShadowView")
    table.insert(requiresTable, "lua/TrainShadow/TrainShadowTrainOtherTimes")

    table.insert(requiresTable, "lua/AdventureView/adventureLayer")
    table.insert(requiresTable, "lua/AdventureView/adventureHelp")
    table.insert(requiresTable, "lua/AdventureView/newWorldLayer")
    table.insert(requiresTable, "lua/AdventureView/newWorldFirstLayer")
    table.insert(requiresTable, "lua/AdventureView/newWorldSecondLayer")
    table.insert(requiresTable, "lua/AdventureView/newWorldThirdLayer")
    table.insert(requiresTable, "lua/AdventureView/newWorldFourthLayer")
    table.insert(requiresTable, "lua/AdventureView/newWorldFifthLayer")
    table.insert(requiresTable, "lua/AdventureView/newWorldRankLayer")
    table.insert(requiresTable, "lua/AdventureView/newWorldOverLayer")
    table.insert(requiresTable, "lua/AdventureView/chaptersLayer")
    table.insert(requiresTable, "lua/AdventureView/chapterLayer")
    table.insert(requiresTable, "lua/AdventureView/chapterRobLayer")
    table.insert(requiresTable, "lua/AdventureView/bossLayer")
    table.insert(requiresTable, "lua/AdventureView/bossChallengeLayer")
    table.insert(requiresTable, "lua/AdventureView/bossResultLayer")
    table.insert(requiresTable, "lua/AdventureView/bossRankLayer")
    table.insert(requiresTable, "lua/AdventureView/marineBranchEntrance")
    table.insert(requiresTable, "lua/AdventureView/calmBeltLayer")
    table.insert(requiresTable, "lua/AdventureView/veiledSeaLayer")
    table.insert(requiresTable, "lua/AdventureView/veiledSeaFirstLayer")
    table.insert(requiresTable, "lua/AdventureView/veiledSeaSelectEnemyLayer")
    table.insert(requiresTable, "lua/AdventureView/veiledSeaChallengeLayer")
    table.insert(requiresTable, "lua/AdventureView/veiledSeaSelectAwardLayer")
    table.insert(requiresTable, "lua/AdventureView/veiledSeaSelectedLayer")
    table.insert(requiresTable, "lua/AdventureView/veiledSeaRankLayer")
    table.insert(requiresTable, "lua/AdventureView/veiledSeaLoseLayer")

    table.insert(requiresTable, "lua/AdventureView/awakeFirstLayer")
    table.insert(requiresTable, "lua/AdventureView/awakeSecondLayer")
    table.insert(requiresTable, "lua/AdventureView/awakeChooseHeroLayer")
    table.insert(requiresTable, "lua/AdventureView/awakeTalkLayer")


    table.insert(requiresTable, "lua/MarineBranchView/MarineBranchLayer")
    table.insert(requiresTable, "lua/MarineBranchView/MarineBranchMobs")
    table.insert(requiresTable, "lua/MarineBranchView/marineChallengeBoss")

    table.insert(requiresTable, "lua/DailyView/dailyLayer")
    table.insert(requiresTable, "lua/DailyView/eatLayer")
    table.insert(requiresTable, "lua/DailyView/luoBinFlowerLayer")
    table.insert(requiresTable, "lua/DailyView/goldClockLayer")
    table.insert(requiresTable, "lua/DailyView/mermanLayer")
    table.insert(requiresTable, "lua/DailyView/levelUpReward")
    table.insert(requiresTable, "lua/DailyView/instructGroupLayer")
    table.insert(requiresTable, "lua/DailyView/qingjiaoLayer")
    table.insert(requiresTable, "lua/DailyView/InstructSingleLayer")
    table.insert(requiresTable, "lua/DailyView/treasureLayer")
    table.insert(requiresTable, "lua/DailyView/treasureMapLayer")
    table.insert(requiresTable, "lua/DailyView/bluckSing")
    table.insert(requiresTable, "lua/DailyView/bluckSingHelp")
    table.insert(requiresTable, "lua/DailyView/haiZeiTeam")
    table.insert(requiresTable, "lua/DailyView/treasureInfoLayer")
    table.insert(requiresTable, "lua/DailyView/treasureAwardLayer")
    table.insert(requiresTable, "lua/DailyView/purchaseAwardLayer")
    table.insert(requiresTable, "lua/DailyView/inviteLayer")
    table.insert(requiresTable, "lua/DailyView/bluckToLuogeLayer")
    table.insert(requiresTable, "lua/DailyView/yuekaLayer")
    table.insert(requiresTable, "lua/DailyView/mysteryShopLayer")
    table.insert(requiresTable, "lua/DailyView/luckyRewardLayer")
    table.insert(requiresTable, "lua/DailyView/luckyRankLayer")
    table.insert(requiresTable, "lua/DailyView/luckyShopLayer")
    table.insert(requiresTable, "lua/DailyView/DailySignInViewLayer") -- 新增 日常签到
    table.insert(requiresTable, "lua/DailyView/DailySignInPopUpLayer") -- 新增 

    table.insert(requiresTable, "lua/ChatView/chatView")

    table.insert(requiresTable, "lua/NewsView/newsLayer")

    table.insert(requiresTable, "lua/FightingResultView/fightingResultLayer")

    table.insert(requiresTable, "lua/SystemSetting/systemSettingLayer")
    table.insert(requiresTable, "lua/SystemSetting/HelpLayerView")
    table.insert(requiresTable, "lua/SystemSetting/FeedbackView")
    table.insert(requiresTable, "lua/SystemSetting/CdkeyView")
    table.insert(requiresTable, "lua/SystemSetting/CusserviceView")
    table.insert(requiresTable, "lua/SystemSetting/RegisterView")

    table.insert(requiresTable, "lua/ArenaView/arenaLayer")
    table.insert(requiresTable, "lua/ArenaView/ArenaMenuLayer")

    table.insert(requiresTable, "lua/GuideView/guideLayer")
    table.insert(requiresTable, "lua/GuideView/levelGuideLayer")
    table.insert(requiresTable, "lua/GuideView/OPLayer")
    table.insert(requiresTable, "lua/GuideView/selectRoleLayer")

    table.insert(requiresTable, "lua/WorldWar/WWChooseGroupLayer")
    table.insert(requiresTable, "lua/WorldWar/WWMainLayer")
    table.insert(requiresTable, "lua/WorldWar/WWIslandLayer")
    table.insert(requiresTable, "lua/WorldWar/WWInfoFriendLayer")
    table.insert(requiresTable, "lua/WorldWar/WWInfoEnemyLayer")
    table.insert(requiresTable, "lua/WorldWar/WWDamageLayer")
    table.insert(requiresTable, "lua/WorldWar/WWBuyDurabilityLayer")
    table.insert(requiresTable, "lua/WorldWar/WWExperimentView")
    table.insert(requiresTable, "lua/WorldWar/WWRecordLayer")
    table.insert(requiresTable, "lua/WorldWar/WWRecordRankLayer")
    table.insert(requiresTable, "lua/WorldWar/WWJobLayer")
    table.insert(requiresTable, "lua/WorldWar/WWRewardLayer")
    table.insert(requiresTable, "lua/WorldWar/WWExploreLayer")
    table.insert(requiresTable, "lua/WorldWar/WWGroupLayer")
    table.insert(requiresTable, "lua/WorldWar/WWGroupRankLayer")
    table.insert(requiresTable, "lua/WorldWar/WWGroupChangeLayer")
    table.insert(requiresTable, "lua/WorldWar/WWGroupChangePopupLayer")
    table.insert(requiresTable, "lua/WorldWar/WWDistributeLayer")
    table.insert(requiresTable, "lua/WorldWar/WWShopLayer")
    table.insert(requiresTable, "lua/WorldWar/WWJobChangeLayer")
    table.insert(requiresTable, "lua/WorldWar/WWJobSelectLayer")
    table.insert(requiresTable, "lua/WorldWar/WWUseItemLayer")
    table.insert(requiresTable, "lua/WorldWar/WWAllScoreLayer")

    table.insert(requiresTable, "lua/QuestView/QuestLayer")
    table.insert(requiresTable, "lua/QuestView/QuestPopup")
    table.insert(requiresTable, "lua/WorldWar/WWRecruitLayer")
    table.insert(requiresTable, "lua/WorldWar/WWTradeTransportLayer")
    table.insert(requiresTable, "lua/WorldWar/WWEscortItemLayer")
    table.insert(requiresTable, "lua/WorldWar/WWEscortItemStateLayer")
    table.insert(requiresTable, "lua/WorldWar/WWEscortItemAboutLayer")
    table.insert(requiresTable, "lua/WorldWar/WWRobItemLayer")
    table.insert(requiresTable, "lua/WorldWar/WWRobItemSucLayer")
    table.insert(requiresTable, "lua/WorldWar/WWRobItemFailedLayer")
    table.insert(requiresTable, "lua/NewsView/VipSupportViewLayer")
    table.insert(requiresTable, "lua/WorldWar/WWEscortItemRewardLayer")

    table.insert(requiresTable, "lua/Activities/ActivityOfJigsawLayer")
    table.insert(requiresTable, "lua/Activities/ActivityOfJigsawStartLayer")

    table.insert(requiresTable, "lua/Activities/ActivityOfFanLi") --充值 返利

    table.insert(requiresTable, "lua/AdventureView/StrideServerArenaViewLayer") --大冒险中的跨服决斗入口
    table.insert(requiresTable, "lua/AdventureView/StrideServerArenaMainViewLayer") --大冒险中的跨服主决斗入口
    table.insert(requiresTable, "lua/AdventureView/StrideServerArenaWorshipViewLayer") --大冒险中的膜拜入口
    table.insert(requiresTable, "lua/AdventureView/SSARewardLayer") --奖励界面
    table.insert(requiresTable, "lua/AdventureView/SSAServerListLayer") --服务器列表界面
    table.insert(requiresTable, "lua/AdventureView/SSAEnterPointsRaceViewLayer") --积分排位赛界面
    table.insert(requiresTable, "lua/AdventureView/SSABattleLogsLayer") --战报界面
    table.insert(requiresTable, "lua/AdventureView/SSAPointsRaceRankingViewLayer") -- 排位晋级赛界面
    table.insert(requiresTable, "lua/Module/ssaData")
    table.insert(requiresTable, "lua/AdventureView/StrideServerArenaThirtyTwoRankingLayer") -- 32
    table.insert(requiresTable, "lua/AdventureView/StrideServerArenaRankingViewLayer") -- 32超新星晋升之路
    table.insert(requiresTable, "lua/AdventureView/SSAFourKingContendViewLayer") -- 四皇
    table.insert(requiresTable, "lua/AdventureView/SSABetViewLayer") -- 押注界面
    table.insert(requiresTable, "lua/AdventureView/SSAMyBetViewLayer") -- 我的押注界面
    table.insert(requiresTable, "lua/AdventureView/StrideServerArenaRankEndViewLayer") -- 32排位结束页面
    table.insert(requiresTable, "lua/AdventureView/StrideServerArenaWorshipMakeSureLayer") -- 膜拜方式选择页面
    table.insert(requiresTable, "lua/AdventureView/SSARankNoticeViewLayer") -- 积分榜页面

    -- 跨服联盟战
    table.insert(requiresTable, "lua/Module/racingBattleData") --  数据
    table.insert(requiresTable, "lua/Union/UnionRacingBattleLayer") -- 入口界面
    table.insert(requiresTable, "lua/Union/UnionRacingBattleStartLayer") -- 战斗开始界面
    table.insert(requiresTable, "lua/Union/UnionRacingBattleServerListLayer") -- 参赛服务器界面
    table.insert(requiresTable, "lua/Union/UnionRacingBattleRewardLayer") -- 查看奖励界面
    table.insert(requiresTable, "lua/Union/UnionRacingBattleRecordLayer") -- 战绩界面


    table.insert(requiresTable, "lua/UI/RankingList") --    排行榜
    table.insert(requiresTable, "lua/Module/rankingListData")

    table.insert(requiresTable, "lua/DailyView/drinkWineLayer") -- 饮酒
    table.insert(requiresTable, "lua/DailyView/drinkWineChoseHeroLayer") -- 饮酒-英雄选择
    table.insert(requiresTable, "lua/DailyView/drinkWineCapExchangeLayer") -- 饮酒-瓶盖兑换

    table.insert(requiresTable, "lua/AdventureView/newWorldSweepInfoLayer") -- 新世界冒险 快速战斗结果界面

    table.insert(requiresTable, "lua/DailyView/decomposeAndComposeLayer") -- 装备的合成与分解
    table.insert(requiresTable, "lua/DailyView/decomposeChooseLayer") -- 装备的分解
    table.insert(requiresTable, "lua/DailyView/composeChooseLayer") -- 装备的合成
    table.insert(requiresTable, "lua/DailyView/composeNeedsLayer") -- 装备的合成所需材料
    table.insert(requiresTable, "lua/DailyView/composeUpdata") -- 装备的合成器升级页面
    table.insert(requiresTable, "lua/DailyView/DailyNewComposeChooseLayer") -- 装备合成--选择合成装备页面
    table.insert(requiresTable, "lua/DailyView/DailyRestoreChooseLayer") -- 装备合成--选择还原装备页面
    table.insert(requiresTable, "lua/DailyView/DailyNewComposeChooseRequire") -- 装备合成--选择装备材料页面

    table.insert(requiresTable, "lua/MarineBranchView/MarineBranchMobsConfirm") -- 海军支部 打小喽喽 确认弹窗

    table.insert(requiresTable, "lua/AdventureView/uninhabitedLayer") -- 无人岛
    table.insert(requiresTable, "lua/Module/uninhabitedData")
    table.insert(requiresTable, "lua/TeamView/hakiCellLayer")
    table.insert(requiresTable, "lua/TeamView/hakiTalkLayer")
    table.insert(requiresTable, "lua/TeamView/hakiInfoLayer")
    table.insert(requiresTable, "lua/TeamView/hakiDetailLayer")

    

    for i, name in ipairs(requiresTable) do
        -- package.loaded[name] = nil
        -- print(" -------- reload -------- ", name)
        require(name)
    end
end