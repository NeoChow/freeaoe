%skeleton "lalr1.cc"
%require  "3.0"

%defines
%define api.namespace { ai }
%define api.parser.class {ScriptParser}
%define api.value.type variant
%define api.token.constructor
%define parse.assert true
%define parse.error verbose
%locations


%param {ai::ScriptLoader &driver}
%parse-param {ai::ScriptTokenizer &scanner}

%code requires {

    namespace ai {
        class ScriptTokenizer;
        class ScriptLoader;
    }

    #ifndef YYDEBUG
        #define YYDEBUG 1
    #endif

    #define YY_NULLPTR nullptr
}


%{

    #include <cassert>
    #include <iostream>

    #include "ScriptLoader.h"
    #include "ScriptTokenizer.h"

    #include "grammar.gen.tab.hh"
    #include "location.hh"

    #undef yylex
    #define yylex scanner.yylex
%}

// %union {
// 	int number;
// 	char *string;
// }

// %destructor { delete $$; $$ = nullptr; } String SymbolName;

%token<int> Number
%token<std::string> String
%token<std::string> SymbolName
%token<std::string> StrategicNumber

%token OpenParen CloseParen
%token RuleStart ConditionActionSeparator

%token LessThan LessOrEqual GreaterThan GreaterOrEqual Equal Not Or

%token LoadIfDefined Else EndIf

%token Space NewLine

%token ScriptEnd 0

%start aiscript
%token AgeDarkAge AgeFeudalAge AgeCastleAge AgeImperialAge AgePostImperialAge
%token BuildingArcheryRange BuildingBarracks BuildingBlacksmith BuildingBombardTower BuildingCastle BuildingDock BuildingFarm BuildingFishTrap BuildingGuardTower BuildingHouse BuildingKeep BuildingLumberCamp BuildingMarket BuildingMill BuildingMiningCamp BuildingMonastery BuildingOutpost BuildingSiegeWorkshop BuildingStable BuildingTownCenter BuildingUniversity BuildingWatchTower BuildingWonder BuildingWatchTowerLine
%token CivBriton CivByzantine CivCeltic CivChinese CivFrankish CivGothic CivJapanese CivMongol CivPersian CivSaracen CivTeutonic CivTurkish CivViking
%token CommodityFood CommodityStone CommodityWood
%token DifficultyEasiest DifficultyEasy DifficultyModerate DifficultyHard DifficultyHardest
%token DifficultyParameterAbilityToDodgeMissiles DifficultyParameterAbilityToMaintainDistance
%token DiplomaticStanceAlly DiplomaticStanceNeutral DiplomaticStanceEnemy
%token EventId0 EventId1 EventId2 EventId3 EventId4 EventId5 EventId6 EventId7 EventId8 EventId9 EventId10 EventId11 EventId12 EventId13 EventId14 EventId15 EventId16 EventId17 EventId18 EventId19 EventId20 EventId21 EventId22 EventId23 EventId24 EventId25 EventId26 EventId27 EventId28 EventId29 EventId30 EventId31 EventId32 EventId33 EventId34 EventId35 EventId36 EventId37 EventId38 EventId39 EventId40 EventId41 EventId42 EventId43 EventId44 EventId45 EventId46 EventId47 EventId48 EventId49 EventId50 EventId51 EventId52 EventId53 EventId54 EventId55 EventId56 EventId57 EventId58 EventId59 EventId60 EventId61 EventId62 EventId63 EventId64 EventId65 EventId66 EventId67 EventId68 EventId69 EventId70 EventId71 EventId72 EventId73 EventId74 EventId75 EventId76 EventId77 EventId78 EventId79 EventId80 EventId81 EventId82 EventId83 EventId84 EventId85 EventId86 EventId87 EventId88 EventId89 EventId90 EventId91 EventId92 EventId93 EventId94 EventId95 EventId96 EventId97 EventId98 EventId99 EventId100 EventId101 EventId102 EventId103 EventId104 EventId105 EventId106 EventId107 EventId108 EventId109 EventId110 EventId111 EventId112 EventId113 EventId114 EventId115 EventId116 EventId117 EventId118 EventId119 EventId120 EventId121 EventId122 EventId123 EventId124 EventId125 EventId126 EventId127 EventId128 EventId129 EventId130 EventId131 EventId132 EventId133 EventId134 EventId135 EventId136 EventId137 EventId138 EventId139 EventId140 EventId141 EventId142 EventId143 EventId144 EventId145 EventId146 EventId147 EventId148 EventId149 EventId150 EventId151 EventId152 EventId153 EventId154 EventId155 EventId156 EventId157 EventId158 EventId159 EventId160 EventId161 EventId162 EventId163 EventId164 EventId165 EventId166 EventId167 EventId168 EventId169 EventId170 EventId171 EventId172 EventId173 EventId174 EventId175 EventId176 EventId177 EventId178 EventId179 EventId180 EventId181 EventId182 EventId183 EventId184 EventId185 EventId186 EventId187 EventId188 EventId189 EventId190 EventId191 EventId192 EventId193 EventId194 EventId195 EventId196 EventId197 EventId198 EventId199 EventId200 EventId201 EventId202 EventId203 EventId204 EventId205 EventId206 EventId207 EventId208 EventId209 EventId210 EventId211 EventId212 EventId213 EventId214 EventId215 EventId216 EventId217 EventId218 EventId219 EventId220 EventId221 EventId222 EventId223 EventId224 EventId225 EventId226 EventId227 EventId228 EventId229 EventId230 EventId231 EventId232 EventId233 EventId234 EventId235 EventId236 EventId237 EventId238 EventId239 EventId240 EventId241 EventId242 EventId243 EventId244 EventId245 EventId246 EventId247 EventId248 EventId249 EventId250 EventId251 EventId252 EventId253 EventId254 EventId255
%token EventTypeTrigger
%token GoalId1 GoalId2 GoalId3 GoalId4 GoalId5 GoalId6 GoalId7 GoalId8 GoalId9 GoalId10 GoalId11 GoalId12 GoalId13 GoalId14 GoalId15 GoalId16 GoalId17 GoalId18 GoalId19 GoalId20 GoalId21 GoalId22 GoalId23 GoalId24 GoalId25 GoalId26 GoalId27 GoalId28 GoalId29 GoalId30 GoalId31 GoalId32 GoalId33 GoalId34 GoalId35 GoalId36 GoalId37 GoalId38 GoalId39 GoalId40
%token MapSizeTiny MapSizeSmall MapSizeMedium MapSizeNormal MapSizeLarge MapSizeGiant
%token MapTypeArabia MapTypeArchipelago MapTypeBaltic MapTypeBlackForest MapTypeCoastal MapTypeContinental MapTypeCraterLake MapTypeFortress MapTypeGoldRush MapTypeHighland MapTypeIslands MapTypeMediterranean MapTypeMigration MapTypeRivers MapTypeTeamIslands MapTypeScenarioMap
%token Perimeter1 Perimeter2
%token PlayerNumberAnyAlly PlayerNumberAnyComputer PlayerNumberAnyComputerAlly PlayerNumberAnyComputerEnemy PlayerNumberAnyComputerNeutral PlayerNumberAnyEnemy PlayerNumberAnyHuman PlayerNumberAnyHumanAlly PlayerNumberAnyHumanEnemy PlayerNumberAnyHumanNeutral PlayerNumberAnyNeutral PlayerNumberEveryAlly PlayerNumberEveryComputer PlayerNumberEveryEnemy PlayerNumberEveryHuman PlayerNumberEveryNeutral
%token RelOpLessThan RelOpLessOrEqual RelOpGreaterThan RelOpGreaterOrEqual RelOpEqual RelOpNotEqual
%token ResearchItemRiArbalest ResearchItemRiCrossbow ResearchItemRiEliteSkirmisher ResearchItemRiHandCannon ResearchItemRiHeavyCavalryArcher ResearchItemRiChampion ResearchItemRiEliteEagleWarrior ResearchItemRiHalberdier ResearchItemRiLongSwordsman ResearchItemRiManAtArms ResearchItemRiParthianTactics ResearchItemRiPikeman ResearchItemRiSquires ResearchItemRiThumbRing ResearchItemRiTracking ResearchItemRiTwoHandedSwordsman ResearchItemRiBlastFurnace ResearchItemRiBodkinArrow ResearchItemRiBracer ResearchItemRiChainBarding ResearchItemRiChainMail ResearchItemRiFletching ResearchItemRiForging ResearchItemRiIronCasting ResearchItemRiLeatherArcherArmor ResearchItemRiPaddedArcherArmor ResearchItemRiPlateBarding ResearchItemRiPlateMail ResearchItemRiRingArcherArmor ResearchItemRiScaleBarding ResearchItemRiScaleMail ResearchItemRiConscription ResearchItemRiHoardings ResearchItemRiSappers ResearchItemRiEliteBerserk ResearchItemRiEliteCataphract ResearchItemRiEliteChuKoNu ResearchItemRiEliteHuskarl ResearchItemRiEliteJanissary ResearchItemRiEliteLongbowman ResearchItemRiEliteMameluke ResearchItemRiEliteMangudai ResearchItemRiEliteSamurai ResearchItemRiEliteTeutonicKnight ResearchItemRiEliteThrowingAxeman ResearchItemRiEliteWarElephant ResearchItemRiEliteWoadRaider ResearchItemRiMyUniqueEliteUnit ResearchItemRiMyUniqueResearch ResearchItemRiCannonGalleon ResearchItemRiCareening ResearchItemRiDeckGuns ResearchItemRiDryDock ResearchItemRiEliteLongboat ResearchItemRiFastFireShip ResearchItemRiGalleon ResearchItemRiHeavyDemolitionShip ResearchItemRiShipwright ResearchItemRiWarGalley ResearchItemRiBowSaw ResearchItemRiDoubleBitAxe ResearchItemRiTwoManSaw ResearchItemRiBanking ResearchItemRiCaravan ResearchItemRiCartography ResearchItemRiCoinage ResearchItemRiGuilds ResearchItemRiCropRotation ResearchItemRiHeavyPlow ResearchItemRiHorseCollar ResearchItemRiGoldMining ResearchItemRiGoldShaftMining ResearchItemRiStoneMining ResearchItemRiStoneShaftMining ResearchItemRiAtonement ResearchItemRiBlockPrinting ResearchItemRiFaith ResearchItemRiFervor ResearchItemRiHerbalMedicine ResearchItemRiHeresy ResearchItemRiIllumination ResearchItemRiRedemption ResearchItemRiSanctity ResearchItemRiTheocracy ResearchItemRiBombardCannon ResearchItemRiCappedRam ResearchItemRiHeavyScorpion ResearchItemRiOnager ResearchItemRiScorpion ResearchItemRiSiegeOnager ResearchItemRiSiegeRam ResearchItemRiBloodlines ResearchItemRiCavalier ResearchItemRiHeavyCamel ResearchItemRiHusbandry ResearchItemRiHussar ResearchItemRiLightCavalry ResearchItemRiPaladin ResearchItemRiHandCart ResearchItemRiLoom ResearchItemRiTownPatrol ResearchItemRiTownWatch ResearchItemRiWheelBarrow ResearchItemRiArchitecture ResearchItemRiBallistics ResearchItemRiBombardTower ResearchItemRiChemistry ResearchItemRiFortifiedWall ResearchItemRiGuardTower ResearchItemRiHeatedShot ResearchItemRiKeep ResearchItemRiMasonry ResearchItemRiMurderHoles ResearchItemRiSiegeEngineers ResearchItemRiStonecutting
%token ResourceTypeFood ResourceTypeGold ResourceTypeStone ResourceTypeWood
%token SharedGoalId0 SharedGoalId1 SharedGoalId2 SharedGoalId3 SharedGoalId4 SharedGoalId5 SharedGoalId6 SharedGoalId7 SharedGoalId8 SharedGoalId9 SharedGoalId10 SharedGoalId11 SharedGoalId12 SharedGoalId13 SharedGoalId14 SharedGoalId15 SharedGoalId16 SharedGoalId17 SharedGoalId18 SharedGoalId19 SharedGoalId20 SharedGoalId21 SharedGoalId22 SharedGoalId23 SharedGoalId24 SharedGoalId25 SharedGoalId26 SharedGoalId27 SharedGoalId28 SharedGoalId29 SharedGoalId30 SharedGoalId31 SharedGoalId32 SharedGoalId33 SharedGoalId34 SharedGoalId35 SharedGoalId36 SharedGoalId37 SharedGoalId38 SharedGoalId39 SharedGoalId40 SharedGoalId41 SharedGoalId42 SharedGoalId43 SharedGoalId44 SharedGoalId45 SharedGoalId46 SharedGoalId47 SharedGoalId48 SharedGoalId49 SharedGoalId50 SharedGoalId51 SharedGoalId52 SharedGoalId53 SharedGoalId54 SharedGoalId55 SharedGoalId56 SharedGoalId57 SharedGoalId58 SharedGoalId59 SharedGoalId60 SharedGoalId61 SharedGoalId62 SharedGoalId63 SharedGoalId64 SharedGoalId65 SharedGoalId66 SharedGoalId67 SharedGoalId68 SharedGoalId69 SharedGoalId70 SharedGoalId71 SharedGoalId72 SharedGoalId73 SharedGoalId74 SharedGoalId75 SharedGoalId76 SharedGoalId77 SharedGoalId78 SharedGoalId79 SharedGoalId80 SharedGoalId81 SharedGoalId82 SharedGoalId83 SharedGoalId84 SharedGoalId85 SharedGoalId86 SharedGoalId87 SharedGoalId88 SharedGoalId89 SharedGoalId90 SharedGoalId91 SharedGoalId92 SharedGoalId93 SharedGoalId94 SharedGoalId95 SharedGoalId96 SharedGoalId97 SharedGoalId98 SharedGoalId99 SharedGoalId100 SharedGoalId101 SharedGoalId102 SharedGoalId103 SharedGoalId104 SharedGoalId105 SharedGoalId106 SharedGoalId107 SharedGoalId108 SharedGoalId109 SharedGoalId110 SharedGoalId111 SharedGoalId112 SharedGoalId113 SharedGoalId114 SharedGoalId115 SharedGoalId116 SharedGoalId117 SharedGoalId118 SharedGoalId119 SharedGoalId120 SharedGoalId121 SharedGoalId122 SharedGoalId123 SharedGoalId124 SharedGoalId125 SharedGoalId126 SharedGoalId127 SharedGoalId128 SharedGoalId129 SharedGoalId130 SharedGoalId131 SharedGoalId132 SharedGoalId133 SharedGoalId134 SharedGoalId135 SharedGoalId136 SharedGoalId137 SharedGoalId138 SharedGoalId139 SharedGoalId140 SharedGoalId141 SharedGoalId142 SharedGoalId143 SharedGoalId144 SharedGoalId145 SharedGoalId146 SharedGoalId147 SharedGoalId148 SharedGoalId149 SharedGoalId150 SharedGoalId151 SharedGoalId152 SharedGoalId153 SharedGoalId154 SharedGoalId155 SharedGoalId156 SharedGoalId157 SharedGoalId158 SharedGoalId159 SharedGoalId160 SharedGoalId161 SharedGoalId162 SharedGoalId163 SharedGoalId164 SharedGoalId165 SharedGoalId166 SharedGoalId167 SharedGoalId168 SharedGoalId169 SharedGoalId170 SharedGoalId171 SharedGoalId172 SharedGoalId173 SharedGoalId174 SharedGoalId175 SharedGoalId176 SharedGoalId177 SharedGoalId178 SharedGoalId179 SharedGoalId180 SharedGoalId181 SharedGoalId182 SharedGoalId183 SharedGoalId184 SharedGoalId185 SharedGoalId186 SharedGoalId187 SharedGoalId188 SharedGoalId189 SharedGoalId190 SharedGoalId191 SharedGoalId192 SharedGoalId193 SharedGoalId194 SharedGoalId195 SharedGoalId196 SharedGoalId197 SharedGoalId198 SharedGoalId199 SharedGoalId200 SharedGoalId201 SharedGoalId202 SharedGoalId203 SharedGoalId204 SharedGoalId205 SharedGoalId206 SharedGoalId207 SharedGoalId208 SharedGoalId209 SharedGoalId210 SharedGoalId211 SharedGoalId212 SharedGoalId213 SharedGoalId214 SharedGoalId215 SharedGoalId216 SharedGoalId217 SharedGoalId218 SharedGoalId219 SharedGoalId220 SharedGoalId221 SharedGoalId222 SharedGoalId223 SharedGoalId224 SharedGoalId225 SharedGoalId226 SharedGoalId227 SharedGoalId228 SharedGoalId229 SharedGoalId230 SharedGoalId231 SharedGoalId232 SharedGoalId233 SharedGoalId234 SharedGoalId235 SharedGoalId236 SharedGoalId237 SharedGoalId238 SharedGoalId239 SharedGoalId240 SharedGoalId241 SharedGoalId242 SharedGoalId243 SharedGoalId244 SharedGoalId245 SharedGoalId246 SharedGoalId247 SharedGoalId248 SharedGoalId249 SharedGoalId250 SharedGoalId251 SharedGoalId252 SharedGoalId253 SharedGoalId254 SharedGoalId255
%token SignalId0 SignalId1 SignalId2 SignalId3 SignalId4 SignalId5 SignalId6 SignalId7 SignalId8 SignalId9 SignalId10 SignalId11 SignalId12 SignalId13 SignalId14 SignalId15 SignalId16 SignalId17 SignalId18 SignalId19 SignalId20 SignalId21 SignalId22 SignalId23 SignalId24 SignalId25 SignalId26 SignalId27 SignalId28 SignalId29 SignalId30 SignalId31 SignalId32 SignalId33 SignalId34 SignalId35 SignalId36 SignalId37 SignalId38 SignalId39 SignalId40 SignalId41 SignalId42 SignalId43 SignalId44 SignalId45 SignalId46 SignalId47 SignalId48 SignalId49 SignalId50 SignalId51 SignalId52 SignalId53 SignalId54 SignalId55 SignalId56 SignalId57 SignalId58 SignalId59 SignalId60 SignalId61 SignalId62 SignalId63 SignalId64 SignalId65 SignalId66 SignalId67 SignalId68 SignalId69 SignalId70 SignalId71 SignalId72 SignalId73 SignalId74 SignalId75 SignalId76 SignalId77 SignalId78 SignalId79 SignalId80 SignalId81 SignalId82 SignalId83 SignalId84 SignalId85 SignalId86 SignalId87 SignalId88 SignalId89 SignalId90 SignalId91 SignalId92 SignalId93 SignalId94 SignalId95 SignalId96 SignalId97 SignalId98 SignalId99 SignalId100 SignalId101 SignalId102 SignalId103 SignalId104 SignalId105 SignalId106 SignalId107 SignalId108 SignalId109 SignalId110 SignalId111 SignalId112 SignalId113 SignalId114 SignalId115 SignalId116 SignalId117 SignalId118 SignalId119 SignalId120 SignalId121 SignalId122 SignalId123 SignalId124 SignalId125 SignalId126 SignalId127 SignalId128 SignalId129 SignalId130 SignalId131 SignalId132 SignalId133 SignalId134 SignalId135 SignalId136 SignalId137 SignalId138 SignalId139 SignalId140 SignalId141 SignalId142 SignalId143 SignalId144 SignalId145 SignalId146 SignalId147 SignalId148 SignalId149 SignalId150 SignalId151 SignalId152 SignalId153 SignalId154 SignalId155 SignalId156 SignalId157 SignalId158 SignalId159 SignalId160 SignalId161 SignalId162 SignalId163 SignalId164 SignalId165 SignalId166 SignalId167 SignalId168 SignalId169 SignalId170 SignalId171 SignalId172 SignalId173 SignalId174 SignalId175 SignalId176 SignalId177 SignalId178 SignalId179 SignalId180 SignalId181 SignalId182 SignalId183 SignalId184 SignalId185 SignalId186 SignalId187 SignalId188 SignalId189 SignalId190 SignalId191 SignalId192 SignalId193 SignalId194 SignalId195 SignalId196 SignalId197 SignalId198 SignalId199 SignalId200 SignalId201 SignalId202 SignalId203 SignalId204 SignalId205 SignalId206 SignalId207 SignalId208 SignalId209 SignalId210 SignalId211 SignalId212 SignalId213 SignalId214 SignalId215 SignalId216 SignalId217 SignalId218 SignalId219 SignalId220 SignalId221 SignalId222 SignalId223 SignalId224 SignalId225 SignalId226 SignalId227 SignalId228 SignalId229 SignalId230 SignalId231 SignalId232 SignalId233 SignalId234 SignalId235 SignalId236 SignalId237 SignalId238 SignalId239 SignalId240 SignalId241 SignalId242 SignalId243 SignalId244 SignalId245 SignalId246 SignalId247 SignalId248 SignalId249 SignalId250 SignalId251 SignalId252 SignalId253 SignalId254 SignalId255
%token StartingResourcesLowResources StartingResourcesMediumResources StartingResourcesHighResources
%token StrategicNumberSnPercentCivilianExplorers StrategicNumberSnPercentCivilianBuilders StrategicNumberSnPercentCivilianGatherers StrategicNumberSnCapCivilianExplorers StrategicNumberSnCapCivilianBuilders StrategicNumberSnCapCivilianGatherers StrategicNumberSnMinimumAttackGroupSize StrategicNumberSnTotalNumberExplorers StrategicNumberSnPercentEnemySightedResponse StrategicNumberSnEnemySightedResponseDistance StrategicNumberSnSentryDistance StrategicNumberSnRelicReturnDistance StrategicNumberSnMinimumDefendGroupSize StrategicNumberSnMaximumAttackGroupSize StrategicNumberSnMaximumDefendGroupSize StrategicNumberSnMinimumPeaceLikeLevel StrategicNumberSnPercentExplorationRequired StrategicNumberSnZeroPriorityDistance StrategicNumberSnMinimumCivilianExplorers StrategicNumberSnNumberAttackGroups StrategicNumberSnNumberDefendGroups StrategicNumberSnAttackGroupGatherSpacing StrategicNumberSnNumberExploreGroups StrategicNumberSnMinimumExploreGroupSize StrategicNumberSnMaximumExploreGroupSize StrategicNumberSnGoldDefendPriority StrategicNumberSnStoneDefendPriority StrategicNumberSnForageDefendPriority StrategicNumberSnRelicDefendPriority StrategicNumberSnTownDefendPriority StrategicNumberSnDefenseDistance StrategicNumberSnNumberBoatAttackGroups StrategicNumberSnMinimumBoatAttackGroupSize StrategicNumberSnMaximumBoatAttackGroupSize StrategicNumberSnNumberBoatExploreGroups StrategicNumberSnMinimumBoatExploreGroupSize StrategicNumberSnMaximumBoatExploreGroupSize StrategicNumberSnNumberBoatDefendGroups StrategicNumberSnMinimumBoatDefendGroupSize StrategicNumberSnMaximumBoatDefendGroupSize StrategicNumberSnDockDefendPriority StrategicNumberSnSentryDistanceVariation StrategicNumberSnMinimumTownSize StrategicNumberSnMaximumTownSize StrategicNumberSnGroupCommanderSelectionMethod StrategicNumberSnConsecutiveIdleUnitLimit StrategicNumberSnTargetEvaluationDistance StrategicNumberSnTargetEvaluationHitpoints StrategicNumberSnTargetEvaluationDamageCapability StrategicNumberSnTargetEvaluationKills StrategicNumberSnTargetEvaluationAllyProximity StrategicNumberSnTargetEvaluationRof StrategicNumberSnTargetEvaluationRandomness StrategicNumberSnCampMaxDistance StrategicNumberSnMillMaxDistance StrategicNumberSnTargetEvaluationAttackAttempts StrategicNumberSnTargetEvaluationRange StrategicNumberSnDefendOverlapDistance StrategicNumberSnScaleMinimumAttackGroupSize StrategicNumberSnScaleMaximumAttackGroupSize StrategicNumberSnAttackGroupSizeRandomness StrategicNumberSnScalingFrequency StrategicNumberSnMaximumGaiaAttackResponse StrategicNumberSnBuildFrequency StrategicNumberSnAttackSeparationTimeRandomness StrategicNumberSnAttackIntelligence StrategicNumberSnInitialAttackDelay StrategicNumberSnSaveScenarioInformation StrategicNumberSnSpecialAttackType1 StrategicNumberSnSpecialAttackInfluence1 StrategicNumberSnMinimumWaterBodySizeForDock StrategicNumberSnNumberBuildAttemptsBeforeSkip StrategicNumberSnMaxSkipsPerAttempt StrategicNumberSnFoodGathererPercentage StrategicNumberSnGoldGathererPercentage StrategicNumberSnStoneGathererPercentage StrategicNumberSnWoodGathererPercentage StrategicNumberSnTargetEvaluationContinent StrategicNumberSnTargetEvaluationSiegeWeapon StrategicNumberSnGroupLeaderDefenseDistance StrategicNumberSnInitialAttackDelayType StrategicNumberSnBlotExplorationMap StrategicNumberSnBlotSize StrategicNumberSnIntelligentGathering StrategicNumberSnTaskUngroupedSoldiers StrategicNumberSnTargetEvaluationBoat StrategicNumberSnNumberEnemyObjectsRequired StrategicNumberSnNumberMaxSkipCycles StrategicNumberSnRetaskGatherAmount StrategicNumberSnMaxRetaskGatherAmount StrategicNumberSnMaxBuildPlanGathererPercentage StrategicNumberSnFoodDropsiteDistance StrategicNumberSnWoodDropsiteDistance StrategicNumberSnStoneDropsiteDistance StrategicNumberSnGoldDropsiteDistance StrategicNumberSnInitialExplorationRequired StrategicNumberSnRandomPlacementFactor StrategicNumberSnRequiredForestTiles StrategicNumberSnAttackDiplomacyImpact StrategicNumberSnPercentHalfExploration StrategicNumberSnTargetEvaluationTimeKillRatio StrategicNumberSnTargetEvaluationInProgress StrategicNumberSnAttackWinningPlayer StrategicNumberSnCoopShareInformation StrategicNumberSnAttackWinningPlayerFactor StrategicNumberSnCoopShareAttacking StrategicNumberSnCoopShareAttackingInterval StrategicNumberSnPercentageExploreExterminators StrategicNumberSnTrackPlayerHistory StrategicNumberSnMinimumDropsiteBuffer StrategicNumberSnUseByTypeMaxGathering StrategicNumberSnMinimumBoarHuntGroupSize StrategicNumberSnMinimumAmountForTrading StrategicNumberSnEasiestReactionPercentage StrategicNumberSnEasierReactionPercentage StrategicNumberSnHitsBeforeAllianceChange StrategicNumberSnAllowCivilianDefense StrategicNumberSnNumberForwardBuilders StrategicNumberSnPercentAttackSoldiers StrategicNumberSnPercentAttackBoats StrategicNumberSnDoNotScaleForDifficultyLevel StrategicNumberSnGroupFormDistance StrategicNumberSnIgnoreAttackGroupUnderAttack StrategicNumberSnGatherDefenseUnits StrategicNumberSnMaximumWoodDropDistance StrategicNumberSnMaximumFoodDropDistance StrategicNumberSnMaximumHuntDropDistance StrategicNumberSnMaximumFishBoatDropDistance StrategicNumberSnMaximumGoldDropDistance StrategicNumberSnMaximumStoneDropDistance StrategicNumberSnGatherIdleSoldiersAtCenter StrategicNumberSnGarrisonRams
%token TimerId1 TimerId2 TimerId3 TimerId4 TimerId5 TimerId6 TimerId7 TimerId8 TimerId9 TimerId10
%token UnitArbalest UnitArcher UnitCavalryArcher UnitCrossbowman UnitEliteSkirmisher UnitHandCannoneer UnitHeavyCavalryArcher UnitSkirmisher UnitChampion UnitEagleWarrior UnitEliteEagleWarrior UnitHalberdier UnitLongSwordsman UnitManAtArms UnitMilitiaman UnitPikeman UnitSpearman UnitTwoHandedSwordsman UnitBerserk UnitCataphract UnitChuKoNu UnitConquistador UnitEliteBerserk UnitEliteCataphract UnitEliteChuKoNu UnitEliteConquistador UnitEliteHuskarl UnitEliteJaguarWarrior UnitEliteJanissary UnitEliteLongbowman UnitEliteMameluke UnitEliteMangudai UnitElitePlumedArcher UnitEliteSamurai UnitEliteTarkan UnitEliteTeutonicKnight UnitEliteThrowingAxeman UnitEliteWarElephant UnitEliteWarWagon UnitEliteWoadRaider UnitHuskarl UnitJaguarWarrior UnitJanissary UnitLongbowman UnitMameluke UnitMangudai UnitPetard UnitPlumedArcher UnitSamurai UnitTarkan UnitTeutonicKnight UnitThrowingAxeman UnitTrebuchet UnitWarElephant UnitWarWagon UnitWoadRaider UnitCannonGalleon UnitDemolitionShip UnitEliteCannonGalleon UnitEliteLongboat UnitEliteTurtleShip UnitFastFireShip UnitFireShip UnitFishingShip UnitGalleon UnitGalley UnitHeavyDemolitionShip UnitLongboat UnitTradeCog UnitTransportShip UnitTurtleShip UnitWarGalley UnitTradeCart UnitMissionary UnitMonk UnitBatteringRam UnitBombardCannon UnitCappedRam UnitHeavyScorpion UnitMangonel UnitOnager UnitScorpion UnitSiegeOnager UnitSiegeRam UnitCamel UnitCavalier UnitHeavyCamel UnitHussar UnitKnight UnitLightCavalry UnitPaladin UnitScoutCavalry UnitVillager UnitArcherLine UnitCavalryArcherLine UnitSkirmisherLine UnitEagleWarriorLine UnitMilitiamanLine UnitSpearmanLine UnitBerserkLine UnitCataphractLine UnitChuKoNuLine UnitConquistadorLine UnitHuskarlLine UnitJaguarWarriorLine UnitJanissaryLine UnitLongbowmanLine UnitMamelukeLine UnitMangudaiLine UnitPlumedArcherLine UnitSamuraiLine UnitTarkanLine UnitTeutonicKnightLine UnitThrowingAxemanLine UnitWarElephantLine UnitWarWagonLine UnitWoadRaiderLine UnitCannonGalleonLine UnitDemolitionShipLine UnitFireShipLine UnitGalleyLine UnitLongboatLine UnitTurtleShipLine UnitBatteringRamLine UnitMangonelLine UnitScorpionLine UnitCamelLine UnitKnightLine UnitScoutCavalryLine
%token VictoryConditionStandard VictoryConditionConquest VictoryConditionTimeLimit VictoryConditionScore VictoryConditionCustom
%token WallTypeFortifiedWall WallTypePalisadeWall WallTypeStoneWall WallTypeStoneWallLine
%token DoNothing
%token AcknowledgeEvent
%token AcknowledgeTaunt
%token AttackNow
%token Build
%token BuildForward
%token BuildGate
%token BuildWall
%token BuyCommodity
%token CcAddResource
%token ChatLocal
%token ChatLocalUsingId
%token ChatLocalUsingRange
%token ChatLocalToSelf
%token ChatToAll
%token ChatToAllUsingId
%token ChatToAllUsingRange
%token ChatToAllies
%token ChatToAlliesUsingId
%token ChatToAlliesUsingRange
%token ChatToEnemies
%token ChatToEnemiesUsingId
%token ChatToEnemiesUsingRange
%token ChatToPlayer
%token ChatToPlayerUsingId
%token ChatToPlayerUsingRange
%token ChatTrace
%token ClearTributeMemory
%token DeleteBuilding
%token DeleteUnit
%token DisableSelf
%token DisableTimer
%token EnableTimer
%token EnableWallPlacement
%token GenerateRandomNumber
%token Log
%token LogTrace
%token ReleaseEscrow
%token Research
%token Resign
%token SellCommodity
%token SetDifficultyParameter
%token SetDoctrine
%token SetEscrowPercentage
%token SetGoal
%token SetSharedGoal
%token SetSignal
%token SetStance
%token SetStrategicNumber
%token Spy
%token Taunt
%token TauntUsingRange
%token Train
%token TributeToPlayer
%%

aiscript:
    /* Empty */
    | rules { printf("got script\n"); }
;

rules:
    rule { printf("got single rule\n"); }
    | rule rules { printf("got multiple rules\n"); }

rule:
    OpenParen RuleStart conditions ConditionActionSeparator actions CloseParen { printf("got rule\n====\n\n"); }

conditions:
    condition {  printf("got single condition\n"); }
    | condition conditions {  printf("got multiple conditions\n"); }

condition:
    OpenParen Not condition CloseParen {  printf("got negated condition\n"); }
    | OpenParen Or conditions CloseParen {  printf("got multiple or conditions\n"); }
    | OpenParen SymbolName CloseParen {  printf("got condition with symbol '%s'\n", $2.c_str()); }
    | OpenParen SymbolName Number CloseParen {  printf("got condition with symbol '%s' and number %d\n", $2.c_str(), $3); }
    | OpenParen SymbolName Number Number CloseParen {  printf("got condition with symbol '%s' and numbers %d %d\n", $2.c_str(), $3, $4); }
    | OpenParen SymbolName SymbolName CloseParen {  printf("got condition with two symbols '%s' %s\n", $2.c_str(), $3.c_str()); }
    | OpenParen SymbolName SymbolName SymbolName CloseParen {  printf("got condition with three symbols %s %s %s\n", $2.c_str(), $3.c_str(), $4.c_str()); }
    | OpenParen SymbolName comparison Number CloseParen {  printf("got condition with comparison %s %d\n", $2.c_str(), $4); }
    | OpenParen SymbolName comparison SymbolName CloseParen {  printf("got condition with comparison %s %s\n", $2.c_str(), $4.c_str()); }
    | OpenParen SymbolName SymbolName comparison SymbolName CloseParen {  printf("got condition with comparison %s %s %s\n", $2.c_str(), $3.c_str(), $5.c_str()); }
    | OpenParen SymbolName SymbolName comparison Number CloseParen {  printf("got condition with comparison %s %s %d\n", $2.c_str(), $3.c_str(), $5); }
    | OpenParen SymbolName SymbolName SymbolName comparison Number CloseParen {  printf("got condition with comparison %s %s %s %d\n", $2.c_str(), $3.c_str(), $4.c_str(), $6); }


comparison:
    RelOpLessThan {  printf("got lessthan\n"); }
    | RelOpLessOrEqual {  printf("got lessorequal\n"); }
    | RelOpGreaterThan {  printf("got greaterthan\n"); }
    | RelOpGreaterOrEqual {  printf("got greaterorequal\n"); }
    | RelOpEqual {  printf("got equals\n"); }

actions:
    OpenParen action CloseParen {  printf("got single action\n"); }
    | action actions {  printf("got multiple actions\n"); }

//action:
//    OpenParen SymbolName CloseParen { printf("got action %s without arguments\n", $2.c_str()); }
//    | OpenParen SymbolName String CloseParen {  printf("got action %s with string %s\n", $2.c_str(), $3.c_str()); }
//    | OpenParen SymbolName SymbolName Number CloseParen {  printf("got action %s with symbol %s and number %d\n", $2.c_str(), $3.c_str(), $4); }
//    | OpenParen SymbolName SymbolName CloseParen {  printf("got action %s with symbol %s\n", $2.c_str(), $3.c_str()); }
//    | OpenParen SymbolName Number CloseParen {  printf("got action %s with number %d\n", $2.c_str(), $3); }
//    | OpenParen SymbolName Number Number CloseParen {  printf("got action %s with numbers %d %d\n", $2.c_str(), $3, $4); }
//
age:
    AgeDarkAge  {}// static_cast<Condition*>(aiRule)->type = Age::DarkAge; } 
  | AgeFeudalAge  {}// static_cast<Condition*>(aiRule)->type = Age::FeudalAge; } 
  | AgeCastleAge  {}// static_cast<Condition*>(aiRule)->type = Age::CastleAge; } 
  | AgeImperialAge  {}// static_cast<Condition*>(aiRule)->type = Age::ImperialAge; } 
  | AgePostImperialAge  {}// static_cast<Condition*>(aiRule)->type = Age::PostImperialAge; } 

building:
    BuildingArcheryRange  {}// static_cast<Condition*>(aiRule)->type = Building::ArcheryRange; } 
  | BuildingBarracks  {}// static_cast<Condition*>(aiRule)->type = Building::Barracks; } 
  | BuildingBlacksmith  {}// static_cast<Condition*>(aiRule)->type = Building::Blacksmith; } 
  | BuildingBombardTower  {}// static_cast<Condition*>(aiRule)->type = Building::BombardTower; } 
  | BuildingCastle  {}// static_cast<Condition*>(aiRule)->type = Building::Castle; } 
  | BuildingDock  {}// static_cast<Condition*>(aiRule)->type = Building::Dock; } 
  | BuildingFarm  {}// static_cast<Condition*>(aiRule)->type = Building::Farm; } 
  | BuildingFishTrap  {}// static_cast<Condition*>(aiRule)->type = Building::FishTrap; } 
  | BuildingGuardTower  {}// static_cast<Condition*>(aiRule)->type = Building::GuardTower; } 
  | BuildingHouse  {}// static_cast<Condition*>(aiRule)->type = Building::House; } 
  | BuildingKeep  {}// static_cast<Condition*>(aiRule)->type = Building::Keep; } 
  | BuildingLumberCamp  {}// static_cast<Condition*>(aiRule)->type = Building::LumberCamp; } 
  | BuildingMarket  {}// static_cast<Condition*>(aiRule)->type = Building::Market; } 
  | BuildingMill  {}// static_cast<Condition*>(aiRule)->type = Building::Mill; } 
  | BuildingMiningCamp  {}// static_cast<Condition*>(aiRule)->type = Building::MiningCamp; } 
  | BuildingMonastery  {}// static_cast<Condition*>(aiRule)->type = Building::Monastery; } 
  | BuildingOutpost  {}// static_cast<Condition*>(aiRule)->type = Building::Outpost; } 
  | BuildingSiegeWorkshop  {}// static_cast<Condition*>(aiRule)->type = Building::SiegeWorkshop; } 
  | BuildingStable  {}// static_cast<Condition*>(aiRule)->type = Building::Stable; } 
  | BuildingTownCenter  {}// static_cast<Condition*>(aiRule)->type = Building::TownCenter; } 
  | BuildingUniversity  {}// static_cast<Condition*>(aiRule)->type = Building::University; } 
  | BuildingWatchTower  {}// static_cast<Condition*>(aiRule)->type = Building::WatchTower; } 
  | BuildingWonder  {}// static_cast<Condition*>(aiRule)->type = Building::Wonder; } 
  | BuildingWatchTowerLine  {}// static_cast<Condition*>(aiRule)->type = Building::WatchTowerLine; } 

commodity:
    CommodityFood  {}// static_cast<Condition*>(aiRule)->type = Commodity::Food; } 
  | CommodityStone  {}// static_cast<Condition*>(aiRule)->type = Commodity::Stone; } 
  | CommodityWood  {}// static_cast<Condition*>(aiRule)->type = Commodity::Wood; } 

difficultyparameter:
    DifficultyParameterAbilityToDodgeMissiles  {}// static_cast<Condition*>(aiRule)->type = DifficultyParameter::AbilityToDodgeMissiles; } 
  | DifficultyParameterAbilityToMaintainDistance  {}// static_cast<Condition*>(aiRule)->type = DifficultyParameter::AbilityToMaintainDistance; } 

diplomaticstance:
    DiplomaticStanceAlly  {}// static_cast<Condition*>(aiRule)->type = DiplomaticStance::Ally; } 
  | DiplomaticStanceNeutral  {}// static_cast<Condition*>(aiRule)->type = DiplomaticStance::Neutral; } 
  | DiplomaticStanceEnemy  {}// static_cast<Condition*>(aiRule)->type = DiplomaticStance::Enemy; } 

eventid:
    EventId0  {}// static_cast<Condition*>(aiRule)->type = EventId::0; } 
  | EventId1  {}// static_cast<Condition*>(aiRule)->type = EventId::1; } 
  | EventId2  {}// static_cast<Condition*>(aiRule)->type = EventId::2; } 
  | EventId3  {}// static_cast<Condition*>(aiRule)->type = EventId::3; } 
  | EventId4  {}// static_cast<Condition*>(aiRule)->type = EventId::4; } 
  | EventId5  {}// static_cast<Condition*>(aiRule)->type = EventId::5; } 
  | EventId6  {}// static_cast<Condition*>(aiRule)->type = EventId::6; } 
  | EventId7  {}// static_cast<Condition*>(aiRule)->type = EventId::7; } 
  | EventId8  {}// static_cast<Condition*>(aiRule)->type = EventId::8; } 
  | EventId9  {}// static_cast<Condition*>(aiRule)->type = EventId::9; } 
  | EventId10  {}// static_cast<Condition*>(aiRule)->type = EventId::10; } 
  | EventId11  {}// static_cast<Condition*>(aiRule)->type = EventId::11; } 
  | EventId12  {}// static_cast<Condition*>(aiRule)->type = EventId::12; } 
  | EventId13  {}// static_cast<Condition*>(aiRule)->type = EventId::13; } 
  | EventId14  {}// static_cast<Condition*>(aiRule)->type = EventId::14; } 
  | EventId15  {}// static_cast<Condition*>(aiRule)->type = EventId::15; } 
  | EventId16  {}// static_cast<Condition*>(aiRule)->type = EventId::16; } 
  | EventId17  {}// static_cast<Condition*>(aiRule)->type = EventId::17; } 
  | EventId18  {}// static_cast<Condition*>(aiRule)->type = EventId::18; } 
  | EventId19  {}// static_cast<Condition*>(aiRule)->type = EventId::19; } 
  | EventId20  {}// static_cast<Condition*>(aiRule)->type = EventId::20; } 
  | EventId21  {}// static_cast<Condition*>(aiRule)->type = EventId::21; } 
  | EventId22  {}// static_cast<Condition*>(aiRule)->type = EventId::22; } 
  | EventId23  {}// static_cast<Condition*>(aiRule)->type = EventId::23; } 
  | EventId24  {}// static_cast<Condition*>(aiRule)->type = EventId::24; } 
  | EventId25  {}// static_cast<Condition*>(aiRule)->type = EventId::25; } 
  | EventId26  {}// static_cast<Condition*>(aiRule)->type = EventId::26; } 
  | EventId27  {}// static_cast<Condition*>(aiRule)->type = EventId::27; } 
  | EventId28  {}// static_cast<Condition*>(aiRule)->type = EventId::28; } 
  | EventId29  {}// static_cast<Condition*>(aiRule)->type = EventId::29; } 
  | EventId30  {}// static_cast<Condition*>(aiRule)->type = EventId::30; } 
  | EventId31  {}// static_cast<Condition*>(aiRule)->type = EventId::31; } 
  | EventId32  {}// static_cast<Condition*>(aiRule)->type = EventId::32; } 
  | EventId33  {}// static_cast<Condition*>(aiRule)->type = EventId::33; } 
  | EventId34  {}// static_cast<Condition*>(aiRule)->type = EventId::34; } 
  | EventId35  {}// static_cast<Condition*>(aiRule)->type = EventId::35; } 
  | EventId36  {}// static_cast<Condition*>(aiRule)->type = EventId::36; } 
  | EventId37  {}// static_cast<Condition*>(aiRule)->type = EventId::37; } 
  | EventId38  {}// static_cast<Condition*>(aiRule)->type = EventId::38; } 
  | EventId39  {}// static_cast<Condition*>(aiRule)->type = EventId::39; } 
  | EventId40  {}// static_cast<Condition*>(aiRule)->type = EventId::40; } 
  | EventId41  {}// static_cast<Condition*>(aiRule)->type = EventId::41; } 
  | EventId42  {}// static_cast<Condition*>(aiRule)->type = EventId::42; } 
  | EventId43  {}// static_cast<Condition*>(aiRule)->type = EventId::43; } 
  | EventId44  {}// static_cast<Condition*>(aiRule)->type = EventId::44; } 
  | EventId45  {}// static_cast<Condition*>(aiRule)->type = EventId::45; } 
  | EventId46  {}// static_cast<Condition*>(aiRule)->type = EventId::46; } 
  | EventId47  {}// static_cast<Condition*>(aiRule)->type = EventId::47; } 
  | EventId48  {}// static_cast<Condition*>(aiRule)->type = EventId::48; } 
  | EventId49  {}// static_cast<Condition*>(aiRule)->type = EventId::49; } 
  | EventId50  {}// static_cast<Condition*>(aiRule)->type = EventId::50; } 
  | EventId51  {}// static_cast<Condition*>(aiRule)->type = EventId::51; } 
  | EventId52  {}// static_cast<Condition*>(aiRule)->type = EventId::52; } 
  | EventId53  {}// static_cast<Condition*>(aiRule)->type = EventId::53; } 
  | EventId54  {}// static_cast<Condition*>(aiRule)->type = EventId::54; } 
  | EventId55  {}// static_cast<Condition*>(aiRule)->type = EventId::55; } 
  | EventId56  {}// static_cast<Condition*>(aiRule)->type = EventId::56; } 
  | EventId57  {}// static_cast<Condition*>(aiRule)->type = EventId::57; } 
  | EventId58  {}// static_cast<Condition*>(aiRule)->type = EventId::58; } 
  | EventId59  {}// static_cast<Condition*>(aiRule)->type = EventId::59; } 
  | EventId60  {}// static_cast<Condition*>(aiRule)->type = EventId::60; } 
  | EventId61  {}// static_cast<Condition*>(aiRule)->type = EventId::61; } 
  | EventId62  {}// static_cast<Condition*>(aiRule)->type = EventId::62; } 
  | EventId63  {}// static_cast<Condition*>(aiRule)->type = EventId::63; } 
  | EventId64  {}// static_cast<Condition*>(aiRule)->type = EventId::64; } 
  | EventId65  {}// static_cast<Condition*>(aiRule)->type = EventId::65; } 
  | EventId66  {}// static_cast<Condition*>(aiRule)->type = EventId::66; } 
  | EventId67  {}// static_cast<Condition*>(aiRule)->type = EventId::67; } 
  | EventId68  {}// static_cast<Condition*>(aiRule)->type = EventId::68; } 
  | EventId69  {}// static_cast<Condition*>(aiRule)->type = EventId::69; } 
  | EventId70  {}// static_cast<Condition*>(aiRule)->type = EventId::70; } 
  | EventId71  {}// static_cast<Condition*>(aiRule)->type = EventId::71; } 
  | EventId72  {}// static_cast<Condition*>(aiRule)->type = EventId::72; } 
  | EventId73  {}// static_cast<Condition*>(aiRule)->type = EventId::73; } 
  | EventId74  {}// static_cast<Condition*>(aiRule)->type = EventId::74; } 
  | EventId75  {}// static_cast<Condition*>(aiRule)->type = EventId::75; } 
  | EventId76  {}// static_cast<Condition*>(aiRule)->type = EventId::76; } 
  | EventId77  {}// static_cast<Condition*>(aiRule)->type = EventId::77; } 
  | EventId78  {}// static_cast<Condition*>(aiRule)->type = EventId::78; } 
  | EventId79  {}// static_cast<Condition*>(aiRule)->type = EventId::79; } 
  | EventId80  {}// static_cast<Condition*>(aiRule)->type = EventId::80; } 
  | EventId81  {}// static_cast<Condition*>(aiRule)->type = EventId::81; } 
  | EventId82  {}// static_cast<Condition*>(aiRule)->type = EventId::82; } 
  | EventId83  {}// static_cast<Condition*>(aiRule)->type = EventId::83; } 
  | EventId84  {}// static_cast<Condition*>(aiRule)->type = EventId::84; } 
  | EventId85  {}// static_cast<Condition*>(aiRule)->type = EventId::85; } 
  | EventId86  {}// static_cast<Condition*>(aiRule)->type = EventId::86; } 
  | EventId87  {}// static_cast<Condition*>(aiRule)->type = EventId::87; } 
  | EventId88  {}// static_cast<Condition*>(aiRule)->type = EventId::88; } 
  | EventId89  {}// static_cast<Condition*>(aiRule)->type = EventId::89; } 
  | EventId90  {}// static_cast<Condition*>(aiRule)->type = EventId::90; } 
  | EventId91  {}// static_cast<Condition*>(aiRule)->type = EventId::91; } 
  | EventId92  {}// static_cast<Condition*>(aiRule)->type = EventId::92; } 
  | EventId93  {}// static_cast<Condition*>(aiRule)->type = EventId::93; } 
  | EventId94  {}// static_cast<Condition*>(aiRule)->type = EventId::94; } 
  | EventId95  {}// static_cast<Condition*>(aiRule)->type = EventId::95; } 
  | EventId96  {}// static_cast<Condition*>(aiRule)->type = EventId::96; } 
  | EventId97  {}// static_cast<Condition*>(aiRule)->type = EventId::97; } 
  | EventId98  {}// static_cast<Condition*>(aiRule)->type = EventId::98; } 
  | EventId99  {}// static_cast<Condition*>(aiRule)->type = EventId::99; } 
  | EventId100  {}// static_cast<Condition*>(aiRule)->type = EventId::100; } 
  | EventId101  {}// static_cast<Condition*>(aiRule)->type = EventId::101; } 
  | EventId102  {}// static_cast<Condition*>(aiRule)->type = EventId::102; } 
  | EventId103  {}// static_cast<Condition*>(aiRule)->type = EventId::103; } 
  | EventId104  {}// static_cast<Condition*>(aiRule)->type = EventId::104; } 
  | EventId105  {}// static_cast<Condition*>(aiRule)->type = EventId::105; } 
  | EventId106  {}// static_cast<Condition*>(aiRule)->type = EventId::106; } 
  | EventId107  {}// static_cast<Condition*>(aiRule)->type = EventId::107; } 
  | EventId108  {}// static_cast<Condition*>(aiRule)->type = EventId::108; } 
  | EventId109  {}// static_cast<Condition*>(aiRule)->type = EventId::109; } 
  | EventId110  {}// static_cast<Condition*>(aiRule)->type = EventId::110; } 
  | EventId111  {}// static_cast<Condition*>(aiRule)->type = EventId::111; } 
  | EventId112  {}// static_cast<Condition*>(aiRule)->type = EventId::112; } 
  | EventId113  {}// static_cast<Condition*>(aiRule)->type = EventId::113; } 
  | EventId114  {}// static_cast<Condition*>(aiRule)->type = EventId::114; } 
  | EventId115  {}// static_cast<Condition*>(aiRule)->type = EventId::115; } 
  | EventId116  {}// static_cast<Condition*>(aiRule)->type = EventId::116; } 
  | EventId117  {}// static_cast<Condition*>(aiRule)->type = EventId::117; } 
  | EventId118  {}// static_cast<Condition*>(aiRule)->type = EventId::118; } 
  | EventId119  {}// static_cast<Condition*>(aiRule)->type = EventId::119; } 
  | EventId120  {}// static_cast<Condition*>(aiRule)->type = EventId::120; } 
  | EventId121  {}// static_cast<Condition*>(aiRule)->type = EventId::121; } 
  | EventId122  {}// static_cast<Condition*>(aiRule)->type = EventId::122; } 
  | EventId123  {}// static_cast<Condition*>(aiRule)->type = EventId::123; } 
  | EventId124  {}// static_cast<Condition*>(aiRule)->type = EventId::124; } 
  | EventId125  {}// static_cast<Condition*>(aiRule)->type = EventId::125; } 
  | EventId126  {}// static_cast<Condition*>(aiRule)->type = EventId::126; } 
  | EventId127  {}// static_cast<Condition*>(aiRule)->type = EventId::127; } 
  | EventId128  {}// static_cast<Condition*>(aiRule)->type = EventId::128; } 
  | EventId129  {}// static_cast<Condition*>(aiRule)->type = EventId::129; } 
  | EventId130  {}// static_cast<Condition*>(aiRule)->type = EventId::130; } 
  | EventId131  {}// static_cast<Condition*>(aiRule)->type = EventId::131; } 
  | EventId132  {}// static_cast<Condition*>(aiRule)->type = EventId::132; } 
  | EventId133  {}// static_cast<Condition*>(aiRule)->type = EventId::133; } 
  | EventId134  {}// static_cast<Condition*>(aiRule)->type = EventId::134; } 
  | EventId135  {}// static_cast<Condition*>(aiRule)->type = EventId::135; } 
  | EventId136  {}// static_cast<Condition*>(aiRule)->type = EventId::136; } 
  | EventId137  {}// static_cast<Condition*>(aiRule)->type = EventId::137; } 
  | EventId138  {}// static_cast<Condition*>(aiRule)->type = EventId::138; } 
  | EventId139  {}// static_cast<Condition*>(aiRule)->type = EventId::139; } 
  | EventId140  {}// static_cast<Condition*>(aiRule)->type = EventId::140; } 
  | EventId141  {}// static_cast<Condition*>(aiRule)->type = EventId::141; } 
  | EventId142  {}// static_cast<Condition*>(aiRule)->type = EventId::142; } 
  | EventId143  {}// static_cast<Condition*>(aiRule)->type = EventId::143; } 
  | EventId144  {}// static_cast<Condition*>(aiRule)->type = EventId::144; } 
  | EventId145  {}// static_cast<Condition*>(aiRule)->type = EventId::145; } 
  | EventId146  {}// static_cast<Condition*>(aiRule)->type = EventId::146; } 
  | EventId147  {}// static_cast<Condition*>(aiRule)->type = EventId::147; } 
  | EventId148  {}// static_cast<Condition*>(aiRule)->type = EventId::148; } 
  | EventId149  {}// static_cast<Condition*>(aiRule)->type = EventId::149; } 
  | EventId150  {}// static_cast<Condition*>(aiRule)->type = EventId::150; } 
  | EventId151  {}// static_cast<Condition*>(aiRule)->type = EventId::151; } 
  | EventId152  {}// static_cast<Condition*>(aiRule)->type = EventId::152; } 
  | EventId153  {}// static_cast<Condition*>(aiRule)->type = EventId::153; } 
  | EventId154  {}// static_cast<Condition*>(aiRule)->type = EventId::154; } 
  | EventId155  {}// static_cast<Condition*>(aiRule)->type = EventId::155; } 
  | EventId156  {}// static_cast<Condition*>(aiRule)->type = EventId::156; } 
  | EventId157  {}// static_cast<Condition*>(aiRule)->type = EventId::157; } 
  | EventId158  {}// static_cast<Condition*>(aiRule)->type = EventId::158; } 
  | EventId159  {}// static_cast<Condition*>(aiRule)->type = EventId::159; } 
  | EventId160  {}// static_cast<Condition*>(aiRule)->type = EventId::160; } 
  | EventId161  {}// static_cast<Condition*>(aiRule)->type = EventId::161; } 
  | EventId162  {}// static_cast<Condition*>(aiRule)->type = EventId::162; } 
  | EventId163  {}// static_cast<Condition*>(aiRule)->type = EventId::163; } 
  | EventId164  {}// static_cast<Condition*>(aiRule)->type = EventId::164; } 
  | EventId165  {}// static_cast<Condition*>(aiRule)->type = EventId::165; } 
  | EventId166  {}// static_cast<Condition*>(aiRule)->type = EventId::166; } 
  | EventId167  {}// static_cast<Condition*>(aiRule)->type = EventId::167; } 
  | EventId168  {}// static_cast<Condition*>(aiRule)->type = EventId::168; } 
  | EventId169  {}// static_cast<Condition*>(aiRule)->type = EventId::169; } 
  | EventId170  {}// static_cast<Condition*>(aiRule)->type = EventId::170; } 
  | EventId171  {}// static_cast<Condition*>(aiRule)->type = EventId::171; } 
  | EventId172  {}// static_cast<Condition*>(aiRule)->type = EventId::172; } 
  | EventId173  {}// static_cast<Condition*>(aiRule)->type = EventId::173; } 
  | EventId174  {}// static_cast<Condition*>(aiRule)->type = EventId::174; } 
  | EventId175  {}// static_cast<Condition*>(aiRule)->type = EventId::175; } 
  | EventId176  {}// static_cast<Condition*>(aiRule)->type = EventId::176; } 
  | EventId177  {}// static_cast<Condition*>(aiRule)->type = EventId::177; } 
  | EventId178  {}// static_cast<Condition*>(aiRule)->type = EventId::178; } 
  | EventId179  {}// static_cast<Condition*>(aiRule)->type = EventId::179; } 
  | EventId180  {}// static_cast<Condition*>(aiRule)->type = EventId::180; } 
  | EventId181  {}// static_cast<Condition*>(aiRule)->type = EventId::181; } 
  | EventId182  {}// static_cast<Condition*>(aiRule)->type = EventId::182; } 
  | EventId183  {}// static_cast<Condition*>(aiRule)->type = EventId::183; } 
  | EventId184  {}// static_cast<Condition*>(aiRule)->type = EventId::184; } 
  | EventId185  {}// static_cast<Condition*>(aiRule)->type = EventId::185; } 
  | EventId186  {}// static_cast<Condition*>(aiRule)->type = EventId::186; } 
  | EventId187  {}// static_cast<Condition*>(aiRule)->type = EventId::187; } 
  | EventId188  {}// static_cast<Condition*>(aiRule)->type = EventId::188; } 
  | EventId189  {}// static_cast<Condition*>(aiRule)->type = EventId::189; } 
  | EventId190  {}// static_cast<Condition*>(aiRule)->type = EventId::190; } 
  | EventId191  {}// static_cast<Condition*>(aiRule)->type = EventId::191; } 
  | EventId192  {}// static_cast<Condition*>(aiRule)->type = EventId::192; } 
  | EventId193  {}// static_cast<Condition*>(aiRule)->type = EventId::193; } 
  | EventId194  {}// static_cast<Condition*>(aiRule)->type = EventId::194; } 
  | EventId195  {}// static_cast<Condition*>(aiRule)->type = EventId::195; } 
  | EventId196  {}// static_cast<Condition*>(aiRule)->type = EventId::196; } 
  | EventId197  {}// static_cast<Condition*>(aiRule)->type = EventId::197; } 
  | EventId198  {}// static_cast<Condition*>(aiRule)->type = EventId::198; } 
  | EventId199  {}// static_cast<Condition*>(aiRule)->type = EventId::199; } 
  | EventId200  {}// static_cast<Condition*>(aiRule)->type = EventId::200; } 
  | EventId201  {}// static_cast<Condition*>(aiRule)->type = EventId::201; } 
  | EventId202  {}// static_cast<Condition*>(aiRule)->type = EventId::202; } 
  | EventId203  {}// static_cast<Condition*>(aiRule)->type = EventId::203; } 
  | EventId204  {}// static_cast<Condition*>(aiRule)->type = EventId::204; } 
  | EventId205  {}// static_cast<Condition*>(aiRule)->type = EventId::205; } 
  | EventId206  {}// static_cast<Condition*>(aiRule)->type = EventId::206; } 
  | EventId207  {}// static_cast<Condition*>(aiRule)->type = EventId::207; } 
  | EventId208  {}// static_cast<Condition*>(aiRule)->type = EventId::208; } 
  | EventId209  {}// static_cast<Condition*>(aiRule)->type = EventId::209; } 
  | EventId210  {}// static_cast<Condition*>(aiRule)->type = EventId::210; } 
  | EventId211  {}// static_cast<Condition*>(aiRule)->type = EventId::211; } 
  | EventId212  {}// static_cast<Condition*>(aiRule)->type = EventId::212; } 
  | EventId213  {}// static_cast<Condition*>(aiRule)->type = EventId::213; } 
  | EventId214  {}// static_cast<Condition*>(aiRule)->type = EventId::214; } 
  | EventId215  {}// static_cast<Condition*>(aiRule)->type = EventId::215; } 
  | EventId216  {}// static_cast<Condition*>(aiRule)->type = EventId::216; } 
  | EventId217  {}// static_cast<Condition*>(aiRule)->type = EventId::217; } 
  | EventId218  {}// static_cast<Condition*>(aiRule)->type = EventId::218; } 
  | EventId219  {}// static_cast<Condition*>(aiRule)->type = EventId::219; } 
  | EventId220  {}// static_cast<Condition*>(aiRule)->type = EventId::220; } 
  | EventId221  {}// static_cast<Condition*>(aiRule)->type = EventId::221; } 
  | EventId222  {}// static_cast<Condition*>(aiRule)->type = EventId::222; } 
  | EventId223  {}// static_cast<Condition*>(aiRule)->type = EventId::223; } 
  | EventId224  {}// static_cast<Condition*>(aiRule)->type = EventId::224; } 
  | EventId225  {}// static_cast<Condition*>(aiRule)->type = EventId::225; } 
  | EventId226  {}// static_cast<Condition*>(aiRule)->type = EventId::226; } 
  | EventId227  {}// static_cast<Condition*>(aiRule)->type = EventId::227; } 
  | EventId228  {}// static_cast<Condition*>(aiRule)->type = EventId::228; } 
  | EventId229  {}// static_cast<Condition*>(aiRule)->type = EventId::229; } 
  | EventId230  {}// static_cast<Condition*>(aiRule)->type = EventId::230; } 
  | EventId231  {}// static_cast<Condition*>(aiRule)->type = EventId::231; } 
  | EventId232  {}// static_cast<Condition*>(aiRule)->type = EventId::232; } 
  | EventId233  {}// static_cast<Condition*>(aiRule)->type = EventId::233; } 
  | EventId234  {}// static_cast<Condition*>(aiRule)->type = EventId::234; } 
  | EventId235  {}// static_cast<Condition*>(aiRule)->type = EventId::235; } 
  | EventId236  {}// static_cast<Condition*>(aiRule)->type = EventId::236; } 
  | EventId237  {}// static_cast<Condition*>(aiRule)->type = EventId::237; } 
  | EventId238  {}// static_cast<Condition*>(aiRule)->type = EventId::238; } 
  | EventId239  {}// static_cast<Condition*>(aiRule)->type = EventId::239; } 
  | EventId240  {}// static_cast<Condition*>(aiRule)->type = EventId::240; } 
  | EventId241  {}// static_cast<Condition*>(aiRule)->type = EventId::241; } 
  | EventId242  {}// static_cast<Condition*>(aiRule)->type = EventId::242; } 
  | EventId243  {}// static_cast<Condition*>(aiRule)->type = EventId::243; } 
  | EventId244  {}// static_cast<Condition*>(aiRule)->type = EventId::244; } 
  | EventId245  {}// static_cast<Condition*>(aiRule)->type = EventId::245; } 
  | EventId246  {}// static_cast<Condition*>(aiRule)->type = EventId::246; } 
  | EventId247  {}// static_cast<Condition*>(aiRule)->type = EventId::247; } 
  | EventId248  {}// static_cast<Condition*>(aiRule)->type = EventId::248; } 
  | EventId249  {}// static_cast<Condition*>(aiRule)->type = EventId::249; } 
  | EventId250  {}// static_cast<Condition*>(aiRule)->type = EventId::250; } 
  | EventId251  {}// static_cast<Condition*>(aiRule)->type = EventId::251; } 
  | EventId252  {}// static_cast<Condition*>(aiRule)->type = EventId::252; } 
  | EventId253  {}// static_cast<Condition*>(aiRule)->type = EventId::253; } 
  | EventId254  {}// static_cast<Condition*>(aiRule)->type = EventId::254; } 
  | EventId255  {}// static_cast<Condition*>(aiRule)->type = EventId::255; } 

eventtype:
    EventTypeTrigger  {}// static_cast<Condition*>(aiRule)->type = EventType::Trigger; } 

goalid:
    GoalId1  {}// static_cast<Condition*>(aiRule)->type = GoalId::1; } 
  | GoalId2  {}// static_cast<Condition*>(aiRule)->type = GoalId::2; } 
  | GoalId3  {}// static_cast<Condition*>(aiRule)->type = GoalId::3; } 
  | GoalId4  {}// static_cast<Condition*>(aiRule)->type = GoalId::4; } 
  | GoalId5  {}// static_cast<Condition*>(aiRule)->type = GoalId::5; } 
  | GoalId6  {}// static_cast<Condition*>(aiRule)->type = GoalId::6; } 
  | GoalId7  {}// static_cast<Condition*>(aiRule)->type = GoalId::7; } 
  | GoalId8  {}// static_cast<Condition*>(aiRule)->type = GoalId::8; } 
  | GoalId9  {}// static_cast<Condition*>(aiRule)->type = GoalId::9; } 
  | GoalId10  {}// static_cast<Condition*>(aiRule)->type = GoalId::10; } 
  | GoalId11  {}// static_cast<Condition*>(aiRule)->type = GoalId::11; } 
  | GoalId12  {}// static_cast<Condition*>(aiRule)->type = GoalId::12; } 
  | GoalId13  {}// static_cast<Condition*>(aiRule)->type = GoalId::13; } 
  | GoalId14  {}// static_cast<Condition*>(aiRule)->type = GoalId::14; } 
  | GoalId15  {}// static_cast<Condition*>(aiRule)->type = GoalId::15; } 
  | GoalId16  {}// static_cast<Condition*>(aiRule)->type = GoalId::16; } 
  | GoalId17  {}// static_cast<Condition*>(aiRule)->type = GoalId::17; } 
  | GoalId18  {}// static_cast<Condition*>(aiRule)->type = GoalId::18; } 
  | GoalId19  {}// static_cast<Condition*>(aiRule)->type = GoalId::19; } 
  | GoalId20  {}// static_cast<Condition*>(aiRule)->type = GoalId::20; } 
  | GoalId21  {}// static_cast<Condition*>(aiRule)->type = GoalId::21; } 
  | GoalId22  {}// static_cast<Condition*>(aiRule)->type = GoalId::22; } 
  | GoalId23  {}// static_cast<Condition*>(aiRule)->type = GoalId::23; } 
  | GoalId24  {}// static_cast<Condition*>(aiRule)->type = GoalId::24; } 
  | GoalId25  {}// static_cast<Condition*>(aiRule)->type = GoalId::25; } 
  | GoalId26  {}// static_cast<Condition*>(aiRule)->type = GoalId::26; } 
  | GoalId27  {}// static_cast<Condition*>(aiRule)->type = GoalId::27; } 
  | GoalId28  {}// static_cast<Condition*>(aiRule)->type = GoalId::28; } 
  | GoalId29  {}// static_cast<Condition*>(aiRule)->type = GoalId::29; } 
  | GoalId30  {}// static_cast<Condition*>(aiRule)->type = GoalId::30; } 
  | GoalId31  {}// static_cast<Condition*>(aiRule)->type = GoalId::31; } 
  | GoalId32  {}// static_cast<Condition*>(aiRule)->type = GoalId::32; } 
  | GoalId33  {}// static_cast<Condition*>(aiRule)->type = GoalId::33; } 
  | GoalId34  {}// static_cast<Condition*>(aiRule)->type = GoalId::34; } 
  | GoalId35  {}// static_cast<Condition*>(aiRule)->type = GoalId::35; } 
  | GoalId36  {}// static_cast<Condition*>(aiRule)->type = GoalId::36; } 
  | GoalId37  {}// static_cast<Condition*>(aiRule)->type = GoalId::37; } 
  | GoalId38  {}// static_cast<Condition*>(aiRule)->type = GoalId::38; } 
  | GoalId39  {}// static_cast<Condition*>(aiRule)->type = GoalId::39; } 
  | GoalId40  {}// static_cast<Condition*>(aiRule)->type = GoalId::40; } 

perimeter:
    Perimeter1  {}// static_cast<Condition*>(aiRule)->type = Perimeter::1; } 
  | Perimeter2  {}// static_cast<Condition*>(aiRule)->type = Perimeter::2; } 

playernumber:
    PlayerNumberAnyAlly  {}// static_cast<Condition*>(aiRule)->type = PlayerNumber::AnyAlly; } 
  | PlayerNumberAnyComputer  {}// static_cast<Condition*>(aiRule)->type = PlayerNumber::AnyComputer; } 
  | PlayerNumberAnyComputerAlly  {}// static_cast<Condition*>(aiRule)->type = PlayerNumber::AnyComputerAlly; } 
  | PlayerNumberAnyComputerEnemy  {}// static_cast<Condition*>(aiRule)->type = PlayerNumber::AnyComputerEnemy; } 
  | PlayerNumberAnyComputerNeutral  {}// static_cast<Condition*>(aiRule)->type = PlayerNumber::AnyComputerNeutral; } 
  | PlayerNumberAnyEnemy  {}// static_cast<Condition*>(aiRule)->type = PlayerNumber::AnyEnemy; } 
  | PlayerNumberAnyHuman  {}// static_cast<Condition*>(aiRule)->type = PlayerNumber::AnyHuman; } 
  | PlayerNumberAnyHumanAlly  {}// static_cast<Condition*>(aiRule)->type = PlayerNumber::AnyHumanAlly; } 
  | PlayerNumberAnyHumanEnemy  {}// static_cast<Condition*>(aiRule)->type = PlayerNumber::AnyHumanEnemy; } 
  | PlayerNumberAnyHumanNeutral  {}// static_cast<Condition*>(aiRule)->type = PlayerNumber::AnyHumanNeutral; } 
  | PlayerNumberAnyNeutral  {}// static_cast<Condition*>(aiRule)->type = PlayerNumber::AnyNeutral; } 
  | PlayerNumberEveryAlly  {}// static_cast<Condition*>(aiRule)->type = PlayerNumber::EveryAlly; } 
  | PlayerNumberEveryComputer  {}// static_cast<Condition*>(aiRule)->type = PlayerNumber::EveryComputer; } 
  | PlayerNumberEveryEnemy  {}// static_cast<Condition*>(aiRule)->type = PlayerNumber::EveryEnemy; } 
  | PlayerNumberEveryHuman  {}// static_cast<Condition*>(aiRule)->type = PlayerNumber::EveryHuman; } 
  | PlayerNumberEveryNeutral  {}// static_cast<Condition*>(aiRule)->type = PlayerNumber::EveryNeutral; } 

researchitem:
    ResearchItemRiArbalest  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiArbalest; } 
  | ResearchItemRiCrossbow  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiCrossbow; } 
  | ResearchItemRiEliteSkirmisher  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiEliteSkirmisher; } 
  | ResearchItemRiHandCannon  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiHandCannon; } 
  | ResearchItemRiHeavyCavalryArcher  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiHeavyCavalryArcher; } 
  | ResearchItemRiChampion  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiChampion; } 
  | ResearchItemRiEliteEagleWarrior  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiEliteEagleWarrior; } 
  | ResearchItemRiHalberdier  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiHalberdier; } 
  | ResearchItemRiLongSwordsman  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiLongSwordsman; } 
  | ResearchItemRiManAtArms  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiManAtArms; } 
  | ResearchItemRiParthianTactics  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiParthianTactics; } 
  | ResearchItemRiPikeman  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiPikeman; } 
  | ResearchItemRiSquires  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiSquires; } 
  | ResearchItemRiThumbRing  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiThumbRing; } 
  | ResearchItemRiTracking  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiTracking; } 
  | ResearchItemRiTwoHandedSwordsman  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiTwoHandedSwordsman; } 
  | ResearchItemRiBlastFurnace  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiBlastFurnace; } 
  | ResearchItemRiBodkinArrow  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiBodkinArrow; } 
  | ResearchItemRiBracer  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiBracer; } 
  | ResearchItemRiChainBarding  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiChainBarding; } 
  | ResearchItemRiChainMail  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiChainMail; } 
  | ResearchItemRiFletching  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiFletching; } 
  | ResearchItemRiForging  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiForging; } 
  | ResearchItemRiIronCasting  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiIronCasting; } 
  | ResearchItemRiLeatherArcherArmor  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiLeatherArcherArmor; } 
  | ResearchItemRiPaddedArcherArmor  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiPaddedArcherArmor; } 
  | ResearchItemRiPlateBarding  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiPlateBarding; } 
  | ResearchItemRiPlateMail  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiPlateMail; } 
  | ResearchItemRiRingArcherArmor  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiRingArcherArmor; } 
  | ResearchItemRiScaleBarding  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiScaleBarding; } 
  | ResearchItemRiScaleMail  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiScaleMail; } 
  | ResearchItemRiConscription  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiConscription; } 
  | ResearchItemRiHoardings  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiHoardings; } 
  | ResearchItemRiSappers  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiSappers; } 
  | ResearchItemRiEliteBerserk  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiEliteBerserk; } 
  | ResearchItemRiEliteCataphract  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiEliteCataphract; } 
  | ResearchItemRiEliteChuKoNu  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiEliteChuKoNu; } 
  | ResearchItemRiEliteHuskarl  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiEliteHuskarl; } 
  | ResearchItemRiEliteJanissary  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiEliteJanissary; } 
  | ResearchItemRiEliteLongbowman  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiEliteLongbowman; } 
  | ResearchItemRiEliteMameluke  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiEliteMameluke; } 
  | ResearchItemRiEliteMangudai  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiEliteMangudai; } 
  | ResearchItemRiEliteSamurai  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiEliteSamurai; } 
  | ResearchItemRiEliteTeutonicKnight  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiEliteTeutonicKnight; } 
  | ResearchItemRiEliteThrowingAxeman  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiEliteThrowingAxeman; } 
  | ResearchItemRiEliteWarElephant  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiEliteWarElephant; } 
  | ResearchItemRiEliteWoadRaider  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiEliteWoadRaider; } 
  | ResearchItemRiMyUniqueEliteUnit  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiMyUniqueEliteUnit; } 
  | ResearchItemRiMyUniqueResearch  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiMyUniqueResearch; } 
  | ResearchItemRiCannonGalleon  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiCannonGalleon; } 
  | ResearchItemRiCareening  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiCareening; } 
  | ResearchItemRiDeckGuns  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiDeckGuns; } 
  | ResearchItemRiDryDock  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiDryDock; } 
  | ResearchItemRiEliteLongboat  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiEliteLongboat; } 
  | ResearchItemRiFastFireShip  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiFastFireShip; } 
  | ResearchItemRiGalleon  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiGalleon; } 
  | ResearchItemRiHeavyDemolitionShip  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiHeavyDemolitionShip; } 
  | ResearchItemRiShipwright  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiShipwright; } 
  | ResearchItemRiWarGalley  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiWarGalley; } 
  | ResearchItemRiBowSaw  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiBowSaw; } 
  | ResearchItemRiDoubleBitAxe  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiDoubleBitAxe; } 
  | ResearchItemRiTwoManSaw  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiTwoManSaw; } 
  | ResearchItemRiBanking  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiBanking; } 
  | ResearchItemRiCaravan  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiCaravan; } 
  | ResearchItemRiCartography  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiCartography; } 
  | ResearchItemRiCoinage  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiCoinage; } 
  | ResearchItemRiGuilds  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiGuilds; } 
  | ResearchItemRiCropRotation  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiCropRotation; } 
  | ResearchItemRiHeavyPlow  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiHeavyPlow; } 
  | ResearchItemRiHorseCollar  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiHorseCollar; } 
  | ResearchItemRiGoldMining  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiGoldMining; } 
  | ResearchItemRiGoldShaftMining  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiGoldShaftMining; } 
  | ResearchItemRiStoneMining  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiStoneMining; } 
  | ResearchItemRiStoneShaftMining  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiStoneShaftMining; } 
  | ResearchItemRiAtonement  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiAtonement; } 
  | ResearchItemRiBlockPrinting  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiBlockPrinting; } 
  | ResearchItemRiFaith  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiFaith; } 
  | ResearchItemRiFervor  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiFervor; } 
  | ResearchItemRiHerbalMedicine  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiHerbalMedicine; } 
  | ResearchItemRiHeresy  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiHeresy; } 
  | ResearchItemRiIllumination  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiIllumination; } 
  | ResearchItemRiRedemption  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiRedemption; } 
  | ResearchItemRiSanctity  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiSanctity; } 
  | ResearchItemRiTheocracy  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiTheocracy; } 
  | ResearchItemRiBombardCannon  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiBombardCannon; } 
  | ResearchItemRiCappedRam  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiCappedRam; } 
  | ResearchItemRiHeavyScorpion  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiHeavyScorpion; } 
  | ResearchItemRiOnager  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiOnager; } 
  | ResearchItemRiScorpion  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiScorpion; } 
  | ResearchItemRiSiegeOnager  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiSiegeOnager; } 
  | ResearchItemRiSiegeRam  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiSiegeRam; } 
  | ResearchItemRiBloodlines  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiBloodlines; } 
  | ResearchItemRiCavalier  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiCavalier; } 
  | ResearchItemRiHeavyCamel  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiHeavyCamel; } 
  | ResearchItemRiHusbandry  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiHusbandry; } 
  | ResearchItemRiHussar  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiHussar; } 
  | ResearchItemRiLightCavalry  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiLightCavalry; } 
  | ResearchItemRiPaladin  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiPaladin; } 
  | ResearchItemRiHandCart  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiHandCart; } 
  | ResearchItemRiLoom  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiLoom; } 
  | ResearchItemRiTownPatrol  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiTownPatrol; } 
  | ResearchItemRiTownWatch  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiTownWatch; } 
  | ResearchItemRiWheelBarrow  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiWheelBarrow; } 
  | ResearchItemRiArchitecture  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiArchitecture; } 
  | ResearchItemRiBallistics  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiBallistics; } 
  | ResearchItemRiBombardTower  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiBombardTower; } 
  | ResearchItemRiChemistry  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiChemistry; } 
  | ResearchItemRiFortifiedWall  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiFortifiedWall; } 
  | ResearchItemRiGuardTower  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiGuardTower; } 
  | ResearchItemRiHeatedShot  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiHeatedShot; } 
  | ResearchItemRiKeep  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiKeep; } 
  | ResearchItemRiMasonry  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiMasonry; } 
  | ResearchItemRiMurderHoles  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiMurderHoles; } 
  | ResearchItemRiSiegeEngineers  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiSiegeEngineers; } 
  | ResearchItemRiStonecutting  {}// static_cast<Condition*>(aiRule)->type = ResearchItem::RiStonecutting; } 

resourcetype:
    ResourceTypeFood  {}// static_cast<Condition*>(aiRule)->type = ResourceType::Food; } 
  | ResourceTypeGold  {}// static_cast<Condition*>(aiRule)->type = ResourceType::Gold; } 
  | ResourceTypeStone  {}// static_cast<Condition*>(aiRule)->type = ResourceType::Stone; } 
  | ResourceTypeWood  {}// static_cast<Condition*>(aiRule)->type = ResourceType::Wood; } 

sharedgoalid:
    SharedGoalId0  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::0; } 
  | SharedGoalId1  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::1; } 
  | SharedGoalId2  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::2; } 
  | SharedGoalId3  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::3; } 
  | SharedGoalId4  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::4; } 
  | SharedGoalId5  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::5; } 
  | SharedGoalId6  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::6; } 
  | SharedGoalId7  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::7; } 
  | SharedGoalId8  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::8; } 
  | SharedGoalId9  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::9; } 
  | SharedGoalId10  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::10; } 
  | SharedGoalId11  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::11; } 
  | SharedGoalId12  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::12; } 
  | SharedGoalId13  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::13; } 
  | SharedGoalId14  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::14; } 
  | SharedGoalId15  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::15; } 
  | SharedGoalId16  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::16; } 
  | SharedGoalId17  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::17; } 
  | SharedGoalId18  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::18; } 
  | SharedGoalId19  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::19; } 
  | SharedGoalId20  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::20; } 
  | SharedGoalId21  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::21; } 
  | SharedGoalId22  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::22; } 
  | SharedGoalId23  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::23; } 
  | SharedGoalId24  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::24; } 
  | SharedGoalId25  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::25; } 
  | SharedGoalId26  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::26; } 
  | SharedGoalId27  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::27; } 
  | SharedGoalId28  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::28; } 
  | SharedGoalId29  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::29; } 
  | SharedGoalId30  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::30; } 
  | SharedGoalId31  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::31; } 
  | SharedGoalId32  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::32; } 
  | SharedGoalId33  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::33; } 
  | SharedGoalId34  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::34; } 
  | SharedGoalId35  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::35; } 
  | SharedGoalId36  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::36; } 
  | SharedGoalId37  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::37; } 
  | SharedGoalId38  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::38; } 
  | SharedGoalId39  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::39; } 
  | SharedGoalId40  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::40; } 
  | SharedGoalId41  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::41; } 
  | SharedGoalId42  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::42; } 
  | SharedGoalId43  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::43; } 
  | SharedGoalId44  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::44; } 
  | SharedGoalId45  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::45; } 
  | SharedGoalId46  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::46; } 
  | SharedGoalId47  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::47; } 
  | SharedGoalId48  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::48; } 
  | SharedGoalId49  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::49; } 
  | SharedGoalId50  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::50; } 
  | SharedGoalId51  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::51; } 
  | SharedGoalId52  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::52; } 
  | SharedGoalId53  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::53; } 
  | SharedGoalId54  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::54; } 
  | SharedGoalId55  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::55; } 
  | SharedGoalId56  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::56; } 
  | SharedGoalId57  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::57; } 
  | SharedGoalId58  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::58; } 
  | SharedGoalId59  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::59; } 
  | SharedGoalId60  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::60; } 
  | SharedGoalId61  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::61; } 
  | SharedGoalId62  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::62; } 
  | SharedGoalId63  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::63; } 
  | SharedGoalId64  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::64; } 
  | SharedGoalId65  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::65; } 
  | SharedGoalId66  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::66; } 
  | SharedGoalId67  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::67; } 
  | SharedGoalId68  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::68; } 
  | SharedGoalId69  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::69; } 
  | SharedGoalId70  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::70; } 
  | SharedGoalId71  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::71; } 
  | SharedGoalId72  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::72; } 
  | SharedGoalId73  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::73; } 
  | SharedGoalId74  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::74; } 
  | SharedGoalId75  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::75; } 
  | SharedGoalId76  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::76; } 
  | SharedGoalId77  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::77; } 
  | SharedGoalId78  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::78; } 
  | SharedGoalId79  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::79; } 
  | SharedGoalId80  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::80; } 
  | SharedGoalId81  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::81; } 
  | SharedGoalId82  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::82; } 
  | SharedGoalId83  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::83; } 
  | SharedGoalId84  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::84; } 
  | SharedGoalId85  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::85; } 
  | SharedGoalId86  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::86; } 
  | SharedGoalId87  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::87; } 
  | SharedGoalId88  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::88; } 
  | SharedGoalId89  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::89; } 
  | SharedGoalId90  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::90; } 
  | SharedGoalId91  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::91; } 
  | SharedGoalId92  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::92; } 
  | SharedGoalId93  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::93; } 
  | SharedGoalId94  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::94; } 
  | SharedGoalId95  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::95; } 
  | SharedGoalId96  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::96; } 
  | SharedGoalId97  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::97; } 
  | SharedGoalId98  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::98; } 
  | SharedGoalId99  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::99; } 
  | SharedGoalId100  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::100; } 
  | SharedGoalId101  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::101; } 
  | SharedGoalId102  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::102; } 
  | SharedGoalId103  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::103; } 
  | SharedGoalId104  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::104; } 
  | SharedGoalId105  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::105; } 
  | SharedGoalId106  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::106; } 
  | SharedGoalId107  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::107; } 
  | SharedGoalId108  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::108; } 
  | SharedGoalId109  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::109; } 
  | SharedGoalId110  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::110; } 
  | SharedGoalId111  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::111; } 
  | SharedGoalId112  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::112; } 
  | SharedGoalId113  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::113; } 
  | SharedGoalId114  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::114; } 
  | SharedGoalId115  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::115; } 
  | SharedGoalId116  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::116; } 
  | SharedGoalId117  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::117; } 
  | SharedGoalId118  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::118; } 
  | SharedGoalId119  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::119; } 
  | SharedGoalId120  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::120; } 
  | SharedGoalId121  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::121; } 
  | SharedGoalId122  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::122; } 
  | SharedGoalId123  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::123; } 
  | SharedGoalId124  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::124; } 
  | SharedGoalId125  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::125; } 
  | SharedGoalId126  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::126; } 
  | SharedGoalId127  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::127; } 
  | SharedGoalId128  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::128; } 
  | SharedGoalId129  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::129; } 
  | SharedGoalId130  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::130; } 
  | SharedGoalId131  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::131; } 
  | SharedGoalId132  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::132; } 
  | SharedGoalId133  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::133; } 
  | SharedGoalId134  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::134; } 
  | SharedGoalId135  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::135; } 
  | SharedGoalId136  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::136; } 
  | SharedGoalId137  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::137; } 
  | SharedGoalId138  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::138; } 
  | SharedGoalId139  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::139; } 
  | SharedGoalId140  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::140; } 
  | SharedGoalId141  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::141; } 
  | SharedGoalId142  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::142; } 
  | SharedGoalId143  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::143; } 
  | SharedGoalId144  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::144; } 
  | SharedGoalId145  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::145; } 
  | SharedGoalId146  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::146; } 
  | SharedGoalId147  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::147; } 
  | SharedGoalId148  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::148; } 
  | SharedGoalId149  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::149; } 
  | SharedGoalId150  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::150; } 
  | SharedGoalId151  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::151; } 
  | SharedGoalId152  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::152; } 
  | SharedGoalId153  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::153; } 
  | SharedGoalId154  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::154; } 
  | SharedGoalId155  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::155; } 
  | SharedGoalId156  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::156; } 
  | SharedGoalId157  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::157; } 
  | SharedGoalId158  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::158; } 
  | SharedGoalId159  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::159; } 
  | SharedGoalId160  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::160; } 
  | SharedGoalId161  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::161; } 
  | SharedGoalId162  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::162; } 
  | SharedGoalId163  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::163; } 
  | SharedGoalId164  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::164; } 
  | SharedGoalId165  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::165; } 
  | SharedGoalId166  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::166; } 
  | SharedGoalId167  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::167; } 
  | SharedGoalId168  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::168; } 
  | SharedGoalId169  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::169; } 
  | SharedGoalId170  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::170; } 
  | SharedGoalId171  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::171; } 
  | SharedGoalId172  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::172; } 
  | SharedGoalId173  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::173; } 
  | SharedGoalId174  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::174; } 
  | SharedGoalId175  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::175; } 
  | SharedGoalId176  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::176; } 
  | SharedGoalId177  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::177; } 
  | SharedGoalId178  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::178; } 
  | SharedGoalId179  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::179; } 
  | SharedGoalId180  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::180; } 
  | SharedGoalId181  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::181; } 
  | SharedGoalId182  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::182; } 
  | SharedGoalId183  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::183; } 
  | SharedGoalId184  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::184; } 
  | SharedGoalId185  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::185; } 
  | SharedGoalId186  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::186; } 
  | SharedGoalId187  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::187; } 
  | SharedGoalId188  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::188; } 
  | SharedGoalId189  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::189; } 
  | SharedGoalId190  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::190; } 
  | SharedGoalId191  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::191; } 
  | SharedGoalId192  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::192; } 
  | SharedGoalId193  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::193; } 
  | SharedGoalId194  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::194; } 
  | SharedGoalId195  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::195; } 
  | SharedGoalId196  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::196; } 
  | SharedGoalId197  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::197; } 
  | SharedGoalId198  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::198; } 
  | SharedGoalId199  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::199; } 
  | SharedGoalId200  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::200; } 
  | SharedGoalId201  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::201; } 
  | SharedGoalId202  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::202; } 
  | SharedGoalId203  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::203; } 
  | SharedGoalId204  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::204; } 
  | SharedGoalId205  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::205; } 
  | SharedGoalId206  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::206; } 
  | SharedGoalId207  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::207; } 
  | SharedGoalId208  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::208; } 
  | SharedGoalId209  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::209; } 
  | SharedGoalId210  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::210; } 
  | SharedGoalId211  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::211; } 
  | SharedGoalId212  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::212; } 
  | SharedGoalId213  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::213; } 
  | SharedGoalId214  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::214; } 
  | SharedGoalId215  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::215; } 
  | SharedGoalId216  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::216; } 
  | SharedGoalId217  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::217; } 
  | SharedGoalId218  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::218; } 
  | SharedGoalId219  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::219; } 
  | SharedGoalId220  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::220; } 
  | SharedGoalId221  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::221; } 
  | SharedGoalId222  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::222; } 
  | SharedGoalId223  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::223; } 
  | SharedGoalId224  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::224; } 
  | SharedGoalId225  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::225; } 
  | SharedGoalId226  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::226; } 
  | SharedGoalId227  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::227; } 
  | SharedGoalId228  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::228; } 
  | SharedGoalId229  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::229; } 
  | SharedGoalId230  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::230; } 
  | SharedGoalId231  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::231; } 
  | SharedGoalId232  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::232; } 
  | SharedGoalId233  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::233; } 
  | SharedGoalId234  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::234; } 
  | SharedGoalId235  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::235; } 
  | SharedGoalId236  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::236; } 
  | SharedGoalId237  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::237; } 
  | SharedGoalId238  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::238; } 
  | SharedGoalId239  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::239; } 
  | SharedGoalId240  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::240; } 
  | SharedGoalId241  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::241; } 
  | SharedGoalId242  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::242; } 
  | SharedGoalId243  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::243; } 
  | SharedGoalId244  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::244; } 
  | SharedGoalId245  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::245; } 
  | SharedGoalId246  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::246; } 
  | SharedGoalId247  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::247; } 
  | SharedGoalId248  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::248; } 
  | SharedGoalId249  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::249; } 
  | SharedGoalId250  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::250; } 
  | SharedGoalId251  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::251; } 
  | SharedGoalId252  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::252; } 
  | SharedGoalId253  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::253; } 
  | SharedGoalId254  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::254; } 
  | SharedGoalId255  {}// static_cast<Condition*>(aiRule)->type = SharedGoalId::255; } 

signalid:
    SignalId0  {}// static_cast<Condition*>(aiRule)->type = SignalId::0; } 
  | SignalId1  {}// static_cast<Condition*>(aiRule)->type = SignalId::1; } 
  | SignalId2  {}// static_cast<Condition*>(aiRule)->type = SignalId::2; } 
  | SignalId3  {}// static_cast<Condition*>(aiRule)->type = SignalId::3; } 
  | SignalId4  {}// static_cast<Condition*>(aiRule)->type = SignalId::4; } 
  | SignalId5  {}// static_cast<Condition*>(aiRule)->type = SignalId::5; } 
  | SignalId6  {}// static_cast<Condition*>(aiRule)->type = SignalId::6; } 
  | SignalId7  {}// static_cast<Condition*>(aiRule)->type = SignalId::7; } 
  | SignalId8  {}// static_cast<Condition*>(aiRule)->type = SignalId::8; } 
  | SignalId9  {}// static_cast<Condition*>(aiRule)->type = SignalId::9; } 
  | SignalId10  {}// static_cast<Condition*>(aiRule)->type = SignalId::10; } 
  | SignalId11  {}// static_cast<Condition*>(aiRule)->type = SignalId::11; } 
  | SignalId12  {}// static_cast<Condition*>(aiRule)->type = SignalId::12; } 
  | SignalId13  {}// static_cast<Condition*>(aiRule)->type = SignalId::13; } 
  | SignalId14  {}// static_cast<Condition*>(aiRule)->type = SignalId::14; } 
  | SignalId15  {}// static_cast<Condition*>(aiRule)->type = SignalId::15; } 
  | SignalId16  {}// static_cast<Condition*>(aiRule)->type = SignalId::16; } 
  | SignalId17  {}// static_cast<Condition*>(aiRule)->type = SignalId::17; } 
  | SignalId18  {}// static_cast<Condition*>(aiRule)->type = SignalId::18; } 
  | SignalId19  {}// static_cast<Condition*>(aiRule)->type = SignalId::19; } 
  | SignalId20  {}// static_cast<Condition*>(aiRule)->type = SignalId::20; } 
  | SignalId21  {}// static_cast<Condition*>(aiRule)->type = SignalId::21; } 
  | SignalId22  {}// static_cast<Condition*>(aiRule)->type = SignalId::22; } 
  | SignalId23  {}// static_cast<Condition*>(aiRule)->type = SignalId::23; } 
  | SignalId24  {}// static_cast<Condition*>(aiRule)->type = SignalId::24; } 
  | SignalId25  {}// static_cast<Condition*>(aiRule)->type = SignalId::25; } 
  | SignalId26  {}// static_cast<Condition*>(aiRule)->type = SignalId::26; } 
  | SignalId27  {}// static_cast<Condition*>(aiRule)->type = SignalId::27; } 
  | SignalId28  {}// static_cast<Condition*>(aiRule)->type = SignalId::28; } 
  | SignalId29  {}// static_cast<Condition*>(aiRule)->type = SignalId::29; } 
  | SignalId30  {}// static_cast<Condition*>(aiRule)->type = SignalId::30; } 
  | SignalId31  {}// static_cast<Condition*>(aiRule)->type = SignalId::31; } 
  | SignalId32  {}// static_cast<Condition*>(aiRule)->type = SignalId::32; } 
  | SignalId33  {}// static_cast<Condition*>(aiRule)->type = SignalId::33; } 
  | SignalId34  {}// static_cast<Condition*>(aiRule)->type = SignalId::34; } 
  | SignalId35  {}// static_cast<Condition*>(aiRule)->type = SignalId::35; } 
  | SignalId36  {}// static_cast<Condition*>(aiRule)->type = SignalId::36; } 
  | SignalId37  {}// static_cast<Condition*>(aiRule)->type = SignalId::37; } 
  | SignalId38  {}// static_cast<Condition*>(aiRule)->type = SignalId::38; } 
  | SignalId39  {}// static_cast<Condition*>(aiRule)->type = SignalId::39; } 
  | SignalId40  {}// static_cast<Condition*>(aiRule)->type = SignalId::40; } 
  | SignalId41  {}// static_cast<Condition*>(aiRule)->type = SignalId::41; } 
  | SignalId42  {}// static_cast<Condition*>(aiRule)->type = SignalId::42; } 
  | SignalId43  {}// static_cast<Condition*>(aiRule)->type = SignalId::43; } 
  | SignalId44  {}// static_cast<Condition*>(aiRule)->type = SignalId::44; } 
  | SignalId45  {}// static_cast<Condition*>(aiRule)->type = SignalId::45; } 
  | SignalId46  {}// static_cast<Condition*>(aiRule)->type = SignalId::46; } 
  | SignalId47  {}// static_cast<Condition*>(aiRule)->type = SignalId::47; } 
  | SignalId48  {}// static_cast<Condition*>(aiRule)->type = SignalId::48; } 
  | SignalId49  {}// static_cast<Condition*>(aiRule)->type = SignalId::49; } 
  | SignalId50  {}// static_cast<Condition*>(aiRule)->type = SignalId::50; } 
  | SignalId51  {}// static_cast<Condition*>(aiRule)->type = SignalId::51; } 
  | SignalId52  {}// static_cast<Condition*>(aiRule)->type = SignalId::52; } 
  | SignalId53  {}// static_cast<Condition*>(aiRule)->type = SignalId::53; } 
  | SignalId54  {}// static_cast<Condition*>(aiRule)->type = SignalId::54; } 
  | SignalId55  {}// static_cast<Condition*>(aiRule)->type = SignalId::55; } 
  | SignalId56  {}// static_cast<Condition*>(aiRule)->type = SignalId::56; } 
  | SignalId57  {}// static_cast<Condition*>(aiRule)->type = SignalId::57; } 
  | SignalId58  {}// static_cast<Condition*>(aiRule)->type = SignalId::58; } 
  | SignalId59  {}// static_cast<Condition*>(aiRule)->type = SignalId::59; } 
  | SignalId60  {}// static_cast<Condition*>(aiRule)->type = SignalId::60; } 
  | SignalId61  {}// static_cast<Condition*>(aiRule)->type = SignalId::61; } 
  | SignalId62  {}// static_cast<Condition*>(aiRule)->type = SignalId::62; } 
  | SignalId63  {}// static_cast<Condition*>(aiRule)->type = SignalId::63; } 
  | SignalId64  {}// static_cast<Condition*>(aiRule)->type = SignalId::64; } 
  | SignalId65  {}// static_cast<Condition*>(aiRule)->type = SignalId::65; } 
  | SignalId66  {}// static_cast<Condition*>(aiRule)->type = SignalId::66; } 
  | SignalId67  {}// static_cast<Condition*>(aiRule)->type = SignalId::67; } 
  | SignalId68  {}// static_cast<Condition*>(aiRule)->type = SignalId::68; } 
  | SignalId69  {}// static_cast<Condition*>(aiRule)->type = SignalId::69; } 
  | SignalId70  {}// static_cast<Condition*>(aiRule)->type = SignalId::70; } 
  | SignalId71  {}// static_cast<Condition*>(aiRule)->type = SignalId::71; } 
  | SignalId72  {}// static_cast<Condition*>(aiRule)->type = SignalId::72; } 
  | SignalId73  {}// static_cast<Condition*>(aiRule)->type = SignalId::73; } 
  | SignalId74  {}// static_cast<Condition*>(aiRule)->type = SignalId::74; } 
  | SignalId75  {}// static_cast<Condition*>(aiRule)->type = SignalId::75; } 
  | SignalId76  {}// static_cast<Condition*>(aiRule)->type = SignalId::76; } 
  | SignalId77  {}// static_cast<Condition*>(aiRule)->type = SignalId::77; } 
  | SignalId78  {}// static_cast<Condition*>(aiRule)->type = SignalId::78; } 
  | SignalId79  {}// static_cast<Condition*>(aiRule)->type = SignalId::79; } 
  | SignalId80  {}// static_cast<Condition*>(aiRule)->type = SignalId::80; } 
  | SignalId81  {}// static_cast<Condition*>(aiRule)->type = SignalId::81; } 
  | SignalId82  {}// static_cast<Condition*>(aiRule)->type = SignalId::82; } 
  | SignalId83  {}// static_cast<Condition*>(aiRule)->type = SignalId::83; } 
  | SignalId84  {}// static_cast<Condition*>(aiRule)->type = SignalId::84; } 
  | SignalId85  {}// static_cast<Condition*>(aiRule)->type = SignalId::85; } 
  | SignalId86  {}// static_cast<Condition*>(aiRule)->type = SignalId::86; } 
  | SignalId87  {}// static_cast<Condition*>(aiRule)->type = SignalId::87; } 
  | SignalId88  {}// static_cast<Condition*>(aiRule)->type = SignalId::88; } 
  | SignalId89  {}// static_cast<Condition*>(aiRule)->type = SignalId::89; } 
  | SignalId90  {}// static_cast<Condition*>(aiRule)->type = SignalId::90; } 
  | SignalId91  {}// static_cast<Condition*>(aiRule)->type = SignalId::91; } 
  | SignalId92  {}// static_cast<Condition*>(aiRule)->type = SignalId::92; } 
  | SignalId93  {}// static_cast<Condition*>(aiRule)->type = SignalId::93; } 
  | SignalId94  {}// static_cast<Condition*>(aiRule)->type = SignalId::94; } 
  | SignalId95  {}// static_cast<Condition*>(aiRule)->type = SignalId::95; } 
  | SignalId96  {}// static_cast<Condition*>(aiRule)->type = SignalId::96; } 
  | SignalId97  {}// static_cast<Condition*>(aiRule)->type = SignalId::97; } 
  | SignalId98  {}// static_cast<Condition*>(aiRule)->type = SignalId::98; } 
  | SignalId99  {}// static_cast<Condition*>(aiRule)->type = SignalId::99; } 
  | SignalId100  {}// static_cast<Condition*>(aiRule)->type = SignalId::100; } 
  | SignalId101  {}// static_cast<Condition*>(aiRule)->type = SignalId::101; } 
  | SignalId102  {}// static_cast<Condition*>(aiRule)->type = SignalId::102; } 
  | SignalId103  {}// static_cast<Condition*>(aiRule)->type = SignalId::103; } 
  | SignalId104  {}// static_cast<Condition*>(aiRule)->type = SignalId::104; } 
  | SignalId105  {}// static_cast<Condition*>(aiRule)->type = SignalId::105; } 
  | SignalId106  {}// static_cast<Condition*>(aiRule)->type = SignalId::106; } 
  | SignalId107  {}// static_cast<Condition*>(aiRule)->type = SignalId::107; } 
  | SignalId108  {}// static_cast<Condition*>(aiRule)->type = SignalId::108; } 
  | SignalId109  {}// static_cast<Condition*>(aiRule)->type = SignalId::109; } 
  | SignalId110  {}// static_cast<Condition*>(aiRule)->type = SignalId::110; } 
  | SignalId111  {}// static_cast<Condition*>(aiRule)->type = SignalId::111; } 
  | SignalId112  {}// static_cast<Condition*>(aiRule)->type = SignalId::112; } 
  | SignalId113  {}// static_cast<Condition*>(aiRule)->type = SignalId::113; } 
  | SignalId114  {}// static_cast<Condition*>(aiRule)->type = SignalId::114; } 
  | SignalId115  {}// static_cast<Condition*>(aiRule)->type = SignalId::115; } 
  | SignalId116  {}// static_cast<Condition*>(aiRule)->type = SignalId::116; } 
  | SignalId117  {}// static_cast<Condition*>(aiRule)->type = SignalId::117; } 
  | SignalId118  {}// static_cast<Condition*>(aiRule)->type = SignalId::118; } 
  | SignalId119  {}// static_cast<Condition*>(aiRule)->type = SignalId::119; } 
  | SignalId120  {}// static_cast<Condition*>(aiRule)->type = SignalId::120; } 
  | SignalId121  {}// static_cast<Condition*>(aiRule)->type = SignalId::121; } 
  | SignalId122  {}// static_cast<Condition*>(aiRule)->type = SignalId::122; } 
  | SignalId123  {}// static_cast<Condition*>(aiRule)->type = SignalId::123; } 
  | SignalId124  {}// static_cast<Condition*>(aiRule)->type = SignalId::124; } 
  | SignalId125  {}// static_cast<Condition*>(aiRule)->type = SignalId::125; } 
  | SignalId126  {}// static_cast<Condition*>(aiRule)->type = SignalId::126; } 
  | SignalId127  {}// static_cast<Condition*>(aiRule)->type = SignalId::127; } 
  | SignalId128  {}// static_cast<Condition*>(aiRule)->type = SignalId::128; } 
  | SignalId129  {}// static_cast<Condition*>(aiRule)->type = SignalId::129; } 
  | SignalId130  {}// static_cast<Condition*>(aiRule)->type = SignalId::130; } 
  | SignalId131  {}// static_cast<Condition*>(aiRule)->type = SignalId::131; } 
  | SignalId132  {}// static_cast<Condition*>(aiRule)->type = SignalId::132; } 
  | SignalId133  {}// static_cast<Condition*>(aiRule)->type = SignalId::133; } 
  | SignalId134  {}// static_cast<Condition*>(aiRule)->type = SignalId::134; } 
  | SignalId135  {}// static_cast<Condition*>(aiRule)->type = SignalId::135; } 
  | SignalId136  {}// static_cast<Condition*>(aiRule)->type = SignalId::136; } 
  | SignalId137  {}// static_cast<Condition*>(aiRule)->type = SignalId::137; } 
  | SignalId138  {}// static_cast<Condition*>(aiRule)->type = SignalId::138; } 
  | SignalId139  {}// static_cast<Condition*>(aiRule)->type = SignalId::139; } 
  | SignalId140  {}// static_cast<Condition*>(aiRule)->type = SignalId::140; } 
  | SignalId141  {}// static_cast<Condition*>(aiRule)->type = SignalId::141; } 
  | SignalId142  {}// static_cast<Condition*>(aiRule)->type = SignalId::142; } 
  | SignalId143  {}// static_cast<Condition*>(aiRule)->type = SignalId::143; } 
  | SignalId144  {}// static_cast<Condition*>(aiRule)->type = SignalId::144; } 
  | SignalId145  {}// static_cast<Condition*>(aiRule)->type = SignalId::145; } 
  | SignalId146  {}// static_cast<Condition*>(aiRule)->type = SignalId::146; } 
  | SignalId147  {}// static_cast<Condition*>(aiRule)->type = SignalId::147; } 
  | SignalId148  {}// static_cast<Condition*>(aiRule)->type = SignalId::148; } 
  | SignalId149  {}// static_cast<Condition*>(aiRule)->type = SignalId::149; } 
  | SignalId150  {}// static_cast<Condition*>(aiRule)->type = SignalId::150; } 
  | SignalId151  {}// static_cast<Condition*>(aiRule)->type = SignalId::151; } 
  | SignalId152  {}// static_cast<Condition*>(aiRule)->type = SignalId::152; } 
  | SignalId153  {}// static_cast<Condition*>(aiRule)->type = SignalId::153; } 
  | SignalId154  {}// static_cast<Condition*>(aiRule)->type = SignalId::154; } 
  | SignalId155  {}// static_cast<Condition*>(aiRule)->type = SignalId::155; } 
  | SignalId156  {}// static_cast<Condition*>(aiRule)->type = SignalId::156; } 
  | SignalId157  {}// static_cast<Condition*>(aiRule)->type = SignalId::157; } 
  | SignalId158  {}// static_cast<Condition*>(aiRule)->type = SignalId::158; } 
  | SignalId159  {}// static_cast<Condition*>(aiRule)->type = SignalId::159; } 
  | SignalId160  {}// static_cast<Condition*>(aiRule)->type = SignalId::160; } 
  | SignalId161  {}// static_cast<Condition*>(aiRule)->type = SignalId::161; } 
  | SignalId162  {}// static_cast<Condition*>(aiRule)->type = SignalId::162; } 
  | SignalId163  {}// static_cast<Condition*>(aiRule)->type = SignalId::163; } 
  | SignalId164  {}// static_cast<Condition*>(aiRule)->type = SignalId::164; } 
  | SignalId165  {}// static_cast<Condition*>(aiRule)->type = SignalId::165; } 
  | SignalId166  {}// static_cast<Condition*>(aiRule)->type = SignalId::166; } 
  | SignalId167  {}// static_cast<Condition*>(aiRule)->type = SignalId::167; } 
  | SignalId168  {}// static_cast<Condition*>(aiRule)->type = SignalId::168; } 
  | SignalId169  {}// static_cast<Condition*>(aiRule)->type = SignalId::169; } 
  | SignalId170  {}// static_cast<Condition*>(aiRule)->type = SignalId::170; } 
  | SignalId171  {}// static_cast<Condition*>(aiRule)->type = SignalId::171; } 
  | SignalId172  {}// static_cast<Condition*>(aiRule)->type = SignalId::172; } 
  | SignalId173  {}// static_cast<Condition*>(aiRule)->type = SignalId::173; } 
  | SignalId174  {}// static_cast<Condition*>(aiRule)->type = SignalId::174; } 
  | SignalId175  {}// static_cast<Condition*>(aiRule)->type = SignalId::175; } 
  | SignalId176  {}// static_cast<Condition*>(aiRule)->type = SignalId::176; } 
  | SignalId177  {}// static_cast<Condition*>(aiRule)->type = SignalId::177; } 
  | SignalId178  {}// static_cast<Condition*>(aiRule)->type = SignalId::178; } 
  | SignalId179  {}// static_cast<Condition*>(aiRule)->type = SignalId::179; } 
  | SignalId180  {}// static_cast<Condition*>(aiRule)->type = SignalId::180; } 
  | SignalId181  {}// static_cast<Condition*>(aiRule)->type = SignalId::181; } 
  | SignalId182  {}// static_cast<Condition*>(aiRule)->type = SignalId::182; } 
  | SignalId183  {}// static_cast<Condition*>(aiRule)->type = SignalId::183; } 
  | SignalId184  {}// static_cast<Condition*>(aiRule)->type = SignalId::184; } 
  | SignalId185  {}// static_cast<Condition*>(aiRule)->type = SignalId::185; } 
  | SignalId186  {}// static_cast<Condition*>(aiRule)->type = SignalId::186; } 
  | SignalId187  {}// static_cast<Condition*>(aiRule)->type = SignalId::187; } 
  | SignalId188  {}// static_cast<Condition*>(aiRule)->type = SignalId::188; } 
  | SignalId189  {}// static_cast<Condition*>(aiRule)->type = SignalId::189; } 
  | SignalId190  {}// static_cast<Condition*>(aiRule)->type = SignalId::190; } 
  | SignalId191  {}// static_cast<Condition*>(aiRule)->type = SignalId::191; } 
  | SignalId192  {}// static_cast<Condition*>(aiRule)->type = SignalId::192; } 
  | SignalId193  {}// static_cast<Condition*>(aiRule)->type = SignalId::193; } 
  | SignalId194  {}// static_cast<Condition*>(aiRule)->type = SignalId::194; } 
  | SignalId195  {}// static_cast<Condition*>(aiRule)->type = SignalId::195; } 
  | SignalId196  {}// static_cast<Condition*>(aiRule)->type = SignalId::196; } 
  | SignalId197  {}// static_cast<Condition*>(aiRule)->type = SignalId::197; } 
  | SignalId198  {}// static_cast<Condition*>(aiRule)->type = SignalId::198; } 
  | SignalId199  {}// static_cast<Condition*>(aiRule)->type = SignalId::199; } 
  | SignalId200  {}// static_cast<Condition*>(aiRule)->type = SignalId::200; } 
  | SignalId201  {}// static_cast<Condition*>(aiRule)->type = SignalId::201; } 
  | SignalId202  {}// static_cast<Condition*>(aiRule)->type = SignalId::202; } 
  | SignalId203  {}// static_cast<Condition*>(aiRule)->type = SignalId::203; } 
  | SignalId204  {}// static_cast<Condition*>(aiRule)->type = SignalId::204; } 
  | SignalId205  {}// static_cast<Condition*>(aiRule)->type = SignalId::205; } 
  | SignalId206  {}// static_cast<Condition*>(aiRule)->type = SignalId::206; } 
  | SignalId207  {}// static_cast<Condition*>(aiRule)->type = SignalId::207; } 
  | SignalId208  {}// static_cast<Condition*>(aiRule)->type = SignalId::208; } 
  | SignalId209  {}// static_cast<Condition*>(aiRule)->type = SignalId::209; } 
  | SignalId210  {}// static_cast<Condition*>(aiRule)->type = SignalId::210; } 
  | SignalId211  {}// static_cast<Condition*>(aiRule)->type = SignalId::211; } 
  | SignalId212  {}// static_cast<Condition*>(aiRule)->type = SignalId::212; } 
  | SignalId213  {}// static_cast<Condition*>(aiRule)->type = SignalId::213; } 
  | SignalId214  {}// static_cast<Condition*>(aiRule)->type = SignalId::214; } 
  | SignalId215  {}// static_cast<Condition*>(aiRule)->type = SignalId::215; } 
  | SignalId216  {}// static_cast<Condition*>(aiRule)->type = SignalId::216; } 
  | SignalId217  {}// static_cast<Condition*>(aiRule)->type = SignalId::217; } 
  | SignalId218  {}// static_cast<Condition*>(aiRule)->type = SignalId::218; } 
  | SignalId219  {}// static_cast<Condition*>(aiRule)->type = SignalId::219; } 
  | SignalId220  {}// static_cast<Condition*>(aiRule)->type = SignalId::220; } 
  | SignalId221  {}// static_cast<Condition*>(aiRule)->type = SignalId::221; } 
  | SignalId222  {}// static_cast<Condition*>(aiRule)->type = SignalId::222; } 
  | SignalId223  {}// static_cast<Condition*>(aiRule)->type = SignalId::223; } 
  | SignalId224  {}// static_cast<Condition*>(aiRule)->type = SignalId::224; } 
  | SignalId225  {}// static_cast<Condition*>(aiRule)->type = SignalId::225; } 
  | SignalId226  {}// static_cast<Condition*>(aiRule)->type = SignalId::226; } 
  | SignalId227  {}// static_cast<Condition*>(aiRule)->type = SignalId::227; } 
  | SignalId228  {}// static_cast<Condition*>(aiRule)->type = SignalId::228; } 
  | SignalId229  {}// static_cast<Condition*>(aiRule)->type = SignalId::229; } 
  | SignalId230  {}// static_cast<Condition*>(aiRule)->type = SignalId::230; } 
  | SignalId231  {}// static_cast<Condition*>(aiRule)->type = SignalId::231; } 
  | SignalId232  {}// static_cast<Condition*>(aiRule)->type = SignalId::232; } 
  | SignalId233  {}// static_cast<Condition*>(aiRule)->type = SignalId::233; } 
  | SignalId234  {}// static_cast<Condition*>(aiRule)->type = SignalId::234; } 
  | SignalId235  {}// static_cast<Condition*>(aiRule)->type = SignalId::235; } 
  | SignalId236  {}// static_cast<Condition*>(aiRule)->type = SignalId::236; } 
  | SignalId237  {}// static_cast<Condition*>(aiRule)->type = SignalId::237; } 
  | SignalId238  {}// static_cast<Condition*>(aiRule)->type = SignalId::238; } 
  | SignalId239  {}// static_cast<Condition*>(aiRule)->type = SignalId::239; } 
  | SignalId240  {}// static_cast<Condition*>(aiRule)->type = SignalId::240; } 
  | SignalId241  {}// static_cast<Condition*>(aiRule)->type = SignalId::241; } 
  | SignalId242  {}// static_cast<Condition*>(aiRule)->type = SignalId::242; } 
  | SignalId243  {}// static_cast<Condition*>(aiRule)->type = SignalId::243; } 
  | SignalId244  {}// static_cast<Condition*>(aiRule)->type = SignalId::244; } 
  | SignalId245  {}// static_cast<Condition*>(aiRule)->type = SignalId::245; } 
  | SignalId246  {}// static_cast<Condition*>(aiRule)->type = SignalId::246; } 
  | SignalId247  {}// static_cast<Condition*>(aiRule)->type = SignalId::247; } 
  | SignalId248  {}// static_cast<Condition*>(aiRule)->type = SignalId::248; } 
  | SignalId249  {}// static_cast<Condition*>(aiRule)->type = SignalId::249; } 
  | SignalId250  {}// static_cast<Condition*>(aiRule)->type = SignalId::250; } 
  | SignalId251  {}// static_cast<Condition*>(aiRule)->type = SignalId::251; } 
  | SignalId252  {}// static_cast<Condition*>(aiRule)->type = SignalId::252; } 
  | SignalId253  {}// static_cast<Condition*>(aiRule)->type = SignalId::253; } 
  | SignalId254  {}// static_cast<Condition*>(aiRule)->type = SignalId::254; } 
  | SignalId255  {}// static_cast<Condition*>(aiRule)->type = SignalId::255; } 

strategicnumber:
    StrategicNumberSnPercentCivilianExplorers  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnPercentCivilianExplorers; } 
  | StrategicNumberSnPercentCivilianBuilders  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnPercentCivilianBuilders; } 
  | StrategicNumberSnPercentCivilianGatherers  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnPercentCivilianGatherers; } 
  | StrategicNumberSnCapCivilianExplorers  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnCapCivilianExplorers; } 
  | StrategicNumberSnCapCivilianBuilders  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnCapCivilianBuilders; } 
  | StrategicNumberSnCapCivilianGatherers  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnCapCivilianGatherers; } 
  | StrategicNumberSnMinimumAttackGroupSize  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnMinimumAttackGroupSize; } 
  | StrategicNumberSnTotalNumberExplorers  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnTotalNumberExplorers; } 
  | StrategicNumberSnPercentEnemySightedResponse  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnPercentEnemySightedResponse; } 
  | StrategicNumberSnEnemySightedResponseDistance  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnEnemySightedResponseDistance; } 
  | StrategicNumberSnSentryDistance  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnSentryDistance; } 
  | StrategicNumberSnRelicReturnDistance  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnRelicReturnDistance; } 
  | StrategicNumberSnMinimumDefendGroupSize  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnMinimumDefendGroupSize; } 
  | StrategicNumberSnMaximumAttackGroupSize  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnMaximumAttackGroupSize; } 
  | StrategicNumberSnMaximumDefendGroupSize  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnMaximumDefendGroupSize; } 
  | StrategicNumberSnMinimumPeaceLikeLevel  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnMinimumPeaceLikeLevel; } 
  | StrategicNumberSnPercentExplorationRequired  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnPercentExplorationRequired; } 
  | StrategicNumberSnZeroPriorityDistance  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnZeroPriorityDistance; } 
  | StrategicNumberSnMinimumCivilianExplorers  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnMinimumCivilianExplorers; } 
  | StrategicNumberSnNumberAttackGroups  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnNumberAttackGroups; } 
  | StrategicNumberSnNumberDefendGroups  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnNumberDefendGroups; } 
  | StrategicNumberSnAttackGroupGatherSpacing  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnAttackGroupGatherSpacing; } 
  | StrategicNumberSnNumberExploreGroups  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnNumberExploreGroups; } 
  | StrategicNumberSnMinimumExploreGroupSize  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnMinimumExploreGroupSize; } 
  | StrategicNumberSnMaximumExploreGroupSize  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnMaximumExploreGroupSize; } 
  | StrategicNumberSnGoldDefendPriority  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnGoldDefendPriority; } 
  | StrategicNumberSnStoneDefendPriority  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnStoneDefendPriority; } 
  | StrategicNumberSnForageDefendPriority  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnForageDefendPriority; } 
  | StrategicNumberSnRelicDefendPriority  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnRelicDefendPriority; } 
  | StrategicNumberSnTownDefendPriority  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnTownDefendPriority; } 
  | StrategicNumberSnDefenseDistance  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnDefenseDistance; } 
  | StrategicNumberSnNumberBoatAttackGroups  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnNumberBoatAttackGroups; } 
  | StrategicNumberSnMinimumBoatAttackGroupSize  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnMinimumBoatAttackGroupSize; } 
  | StrategicNumberSnMaximumBoatAttackGroupSize  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnMaximumBoatAttackGroupSize; } 
  | StrategicNumberSnNumberBoatExploreGroups  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnNumberBoatExploreGroups; } 
  | StrategicNumberSnMinimumBoatExploreGroupSize  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnMinimumBoatExploreGroupSize; } 
  | StrategicNumberSnMaximumBoatExploreGroupSize  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnMaximumBoatExploreGroupSize; } 
  | StrategicNumberSnNumberBoatDefendGroups  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnNumberBoatDefendGroups; } 
  | StrategicNumberSnMinimumBoatDefendGroupSize  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnMinimumBoatDefendGroupSize; } 
  | StrategicNumberSnMaximumBoatDefendGroupSize  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnMaximumBoatDefendGroupSize; } 
  | StrategicNumberSnDockDefendPriority  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnDockDefendPriority; } 
  | StrategicNumberSnSentryDistanceVariation  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnSentryDistanceVariation; } 
  | StrategicNumberSnMinimumTownSize  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnMinimumTownSize; } 
  | StrategicNumberSnMaximumTownSize  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnMaximumTownSize; } 
  | StrategicNumberSnGroupCommanderSelectionMethod  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnGroupCommanderSelectionMethod; } 
  | StrategicNumberSnConsecutiveIdleUnitLimit  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnConsecutiveIdleUnitLimit; } 
  | StrategicNumberSnTargetEvaluationDistance  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnTargetEvaluationDistance; } 
  | StrategicNumberSnTargetEvaluationHitpoints  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnTargetEvaluationHitpoints; } 
  | StrategicNumberSnTargetEvaluationDamageCapability  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnTargetEvaluationDamageCapability; } 
  | StrategicNumberSnTargetEvaluationKills  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnTargetEvaluationKills; } 
  | StrategicNumberSnTargetEvaluationAllyProximity  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnTargetEvaluationAllyProximity; } 
  | StrategicNumberSnTargetEvaluationRof  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnTargetEvaluationRof; } 
  | StrategicNumberSnTargetEvaluationRandomness  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnTargetEvaluationRandomness; } 
  | StrategicNumberSnCampMaxDistance  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnCampMaxDistance; } 
  | StrategicNumberSnMillMaxDistance  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnMillMaxDistance; } 
  | StrategicNumberSnTargetEvaluationAttackAttempts  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnTargetEvaluationAttackAttempts; } 
  | StrategicNumberSnTargetEvaluationRange  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnTargetEvaluationRange; } 
  | StrategicNumberSnDefendOverlapDistance  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnDefendOverlapDistance; } 
  | StrategicNumberSnScaleMinimumAttackGroupSize  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnScaleMinimumAttackGroupSize; } 
  | StrategicNumberSnScaleMaximumAttackGroupSize  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnScaleMaximumAttackGroupSize; } 
  | StrategicNumberSnAttackGroupSizeRandomness  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnAttackGroupSizeRandomness; } 
  | StrategicNumberSnScalingFrequency  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnScalingFrequency; } 
  | StrategicNumberSnMaximumGaiaAttackResponse  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnMaximumGaiaAttackResponse; } 
  | StrategicNumberSnBuildFrequency  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnBuildFrequency; } 
  | StrategicNumberSnAttackSeparationTimeRandomness  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnAttackSeparationTimeRandomness; } 
  | StrategicNumberSnAttackIntelligence  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnAttackIntelligence; } 
  | StrategicNumberSnInitialAttackDelay  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnInitialAttackDelay; } 
  | StrategicNumberSnSaveScenarioInformation  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnSaveScenarioInformation; } 
  | StrategicNumberSnSpecialAttackType1  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnSpecialAttackType1; } 
  | StrategicNumberSnSpecialAttackInfluence1  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnSpecialAttackInfluence1; } 
  | StrategicNumberSnMinimumWaterBodySizeForDock  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnMinimumWaterBodySizeForDock; } 
  | StrategicNumberSnNumberBuildAttemptsBeforeSkip  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnNumberBuildAttemptsBeforeSkip; } 
  | StrategicNumberSnMaxSkipsPerAttempt  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnMaxSkipsPerAttempt; } 
  | StrategicNumberSnFoodGathererPercentage  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnFoodGathererPercentage; } 
  | StrategicNumberSnGoldGathererPercentage  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnGoldGathererPercentage; } 
  | StrategicNumberSnStoneGathererPercentage  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnStoneGathererPercentage; } 
  | StrategicNumberSnWoodGathererPercentage  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnWoodGathererPercentage; } 
  | StrategicNumberSnTargetEvaluationContinent  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnTargetEvaluationContinent; } 
  | StrategicNumberSnTargetEvaluationSiegeWeapon  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnTargetEvaluationSiegeWeapon; } 
  | StrategicNumberSnGroupLeaderDefenseDistance  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnGroupLeaderDefenseDistance; } 
  | StrategicNumberSnInitialAttackDelayType  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnInitialAttackDelayType; } 
  | StrategicNumberSnBlotExplorationMap  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnBlotExplorationMap; } 
  | StrategicNumberSnBlotSize  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnBlotSize; } 
  | StrategicNumberSnIntelligentGathering  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnIntelligentGathering; } 
  | StrategicNumberSnTaskUngroupedSoldiers  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnTaskUngroupedSoldiers; } 
  | StrategicNumberSnTargetEvaluationBoat  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnTargetEvaluationBoat; } 
  | StrategicNumberSnNumberEnemyObjectsRequired  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnNumberEnemyObjectsRequired; } 
  | StrategicNumberSnNumberMaxSkipCycles  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnNumberMaxSkipCycles; } 
  | StrategicNumberSnRetaskGatherAmount  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnRetaskGatherAmount; } 
  | StrategicNumberSnMaxRetaskGatherAmount  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnMaxRetaskGatherAmount; } 
  | StrategicNumberSnMaxBuildPlanGathererPercentage  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnMaxBuildPlanGathererPercentage; } 
  | StrategicNumberSnFoodDropsiteDistance  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnFoodDropsiteDistance; } 
  | StrategicNumberSnWoodDropsiteDistance  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnWoodDropsiteDistance; } 
  | StrategicNumberSnStoneDropsiteDistance  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnStoneDropsiteDistance; } 
  | StrategicNumberSnGoldDropsiteDistance  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnGoldDropsiteDistance; } 
  | StrategicNumberSnInitialExplorationRequired  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnInitialExplorationRequired; } 
  | StrategicNumberSnRandomPlacementFactor  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnRandomPlacementFactor; } 
  | StrategicNumberSnRequiredForestTiles  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnRequiredForestTiles; } 
  | StrategicNumberSnAttackDiplomacyImpact  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnAttackDiplomacyImpact; } 
  | StrategicNumberSnPercentHalfExploration  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnPercentHalfExploration; } 
  | StrategicNumberSnTargetEvaluationTimeKillRatio  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnTargetEvaluationTimeKillRatio; } 
  | StrategicNumberSnTargetEvaluationInProgress  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnTargetEvaluationInProgress; } 
  | StrategicNumberSnAttackWinningPlayer  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnAttackWinningPlayer; } 
  | StrategicNumberSnCoopShareInformation  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnCoopShareInformation; } 
  | StrategicNumberSnAttackWinningPlayerFactor  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnAttackWinningPlayerFactor; } 
  | StrategicNumberSnCoopShareAttacking  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnCoopShareAttacking; } 
  | StrategicNumberSnCoopShareAttackingInterval  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnCoopShareAttackingInterval; } 
  | StrategicNumberSnPercentageExploreExterminators  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnPercentageExploreExterminators; } 
  | StrategicNumberSnTrackPlayerHistory  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnTrackPlayerHistory; } 
  | StrategicNumberSnMinimumDropsiteBuffer  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnMinimumDropsiteBuffer; } 
  | StrategicNumberSnUseByTypeMaxGathering  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnUseByTypeMaxGathering; } 
  | StrategicNumberSnMinimumBoarHuntGroupSize  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnMinimumBoarHuntGroupSize; } 
  | StrategicNumberSnMinimumAmountForTrading  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnMinimumAmountForTrading; } 
  | StrategicNumberSnEasiestReactionPercentage  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnEasiestReactionPercentage; } 
  | StrategicNumberSnEasierReactionPercentage  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnEasierReactionPercentage; } 
  | StrategicNumberSnHitsBeforeAllianceChange  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnHitsBeforeAllianceChange; } 
  | StrategicNumberSnAllowCivilianDefense  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnAllowCivilianDefense; } 
  | StrategicNumberSnNumberForwardBuilders  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnNumberForwardBuilders; } 
  | StrategicNumberSnPercentAttackSoldiers  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnPercentAttackSoldiers; } 
  | StrategicNumberSnPercentAttackBoats  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnPercentAttackBoats; } 
  | StrategicNumberSnDoNotScaleForDifficultyLevel  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnDoNotScaleForDifficultyLevel; } 
  | StrategicNumberSnGroupFormDistance  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnGroupFormDistance; } 
  | StrategicNumberSnIgnoreAttackGroupUnderAttack  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnIgnoreAttackGroupUnderAttack; } 
  | StrategicNumberSnGatherDefenseUnits  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnGatherDefenseUnits; } 
  | StrategicNumberSnMaximumWoodDropDistance  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnMaximumWoodDropDistance; } 
  | StrategicNumberSnMaximumFoodDropDistance  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnMaximumFoodDropDistance; } 
  | StrategicNumberSnMaximumHuntDropDistance  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnMaximumHuntDropDistance; } 
  | StrategicNumberSnMaximumFishBoatDropDistance  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnMaximumFishBoatDropDistance; } 
  | StrategicNumberSnMaximumGoldDropDistance  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnMaximumGoldDropDistance; } 
  | StrategicNumberSnMaximumStoneDropDistance  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnMaximumStoneDropDistance; } 
  | StrategicNumberSnGatherIdleSoldiersAtCenter  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnGatherIdleSoldiersAtCenter; } 
  | StrategicNumberSnGarrisonRams  {}// static_cast<Condition*>(aiRule)->type = StrategicNumber::SnGarrisonRams; } 

stringid:
    Number
stringidrange:
    Number
stringidstart:
    Number

timerid:
    TimerId1  {}// static_cast<Condition*>(aiRule)->type = TimerId::1; } 
  | TimerId2  {}// static_cast<Condition*>(aiRule)->type = TimerId::2; } 
  | TimerId3  {}// static_cast<Condition*>(aiRule)->type = TimerId::3; } 
  | TimerId4  {}// static_cast<Condition*>(aiRule)->type = TimerId::4; } 
  | TimerId5  {}// static_cast<Condition*>(aiRule)->type = TimerId::5; } 
  | TimerId6  {}// static_cast<Condition*>(aiRule)->type = TimerId::6; } 
  | TimerId7  {}// static_cast<Condition*>(aiRule)->type = TimerId::7; } 
  | TimerId8  {}// static_cast<Condition*>(aiRule)->type = TimerId::8; } 
  | TimerId9  {}// static_cast<Condition*>(aiRule)->type = TimerId::9; } 
  | TimerId10  {}// static_cast<Condition*>(aiRule)->type = TimerId::10; } 

unit:
    UnitArbalest  {}// static_cast<Condition*>(aiRule)->type = Unit::Arbalest; } 
  | UnitArcher  {}// static_cast<Condition*>(aiRule)->type = Unit::Archer; } 
  | UnitCavalryArcher  {}// static_cast<Condition*>(aiRule)->type = Unit::CavalryArcher; } 
  | UnitCrossbowman  {}// static_cast<Condition*>(aiRule)->type = Unit::Crossbowman; } 
  | UnitEliteSkirmisher  {}// static_cast<Condition*>(aiRule)->type = Unit::EliteSkirmisher; } 
  | UnitHandCannoneer  {}// static_cast<Condition*>(aiRule)->type = Unit::HandCannoneer; } 
  | UnitHeavyCavalryArcher  {}// static_cast<Condition*>(aiRule)->type = Unit::HeavyCavalryArcher; } 
  | UnitSkirmisher  {}// static_cast<Condition*>(aiRule)->type = Unit::Skirmisher; } 
  | UnitChampion  {}// static_cast<Condition*>(aiRule)->type = Unit::Champion; } 
  | UnitEagleWarrior  {}// static_cast<Condition*>(aiRule)->type = Unit::EagleWarrior; } 
  | UnitEliteEagleWarrior  {}// static_cast<Condition*>(aiRule)->type = Unit::EliteEagleWarrior; } 
  | UnitHalberdier  {}// static_cast<Condition*>(aiRule)->type = Unit::Halberdier; } 
  | UnitLongSwordsman  {}// static_cast<Condition*>(aiRule)->type = Unit::LongSwordsman; } 
  | UnitManAtArms  {}// static_cast<Condition*>(aiRule)->type = Unit::ManAtArms; } 
  | UnitMilitiaman  {}// static_cast<Condition*>(aiRule)->type = Unit::Militiaman; } 
  | UnitPikeman  {}// static_cast<Condition*>(aiRule)->type = Unit::Pikeman; } 
  | UnitSpearman  {}// static_cast<Condition*>(aiRule)->type = Unit::Spearman; } 
  | UnitTwoHandedSwordsman  {}// static_cast<Condition*>(aiRule)->type = Unit::TwoHandedSwordsman; } 
  | UnitBerserk  {}// static_cast<Condition*>(aiRule)->type = Unit::Berserk; } 
  | UnitCataphract  {}// static_cast<Condition*>(aiRule)->type = Unit::Cataphract; } 
  | UnitChuKoNu  {}// static_cast<Condition*>(aiRule)->type = Unit::ChuKoNu; } 
  | UnitConquistador  {}// static_cast<Condition*>(aiRule)->type = Unit::Conquistador; } 
  | UnitEliteBerserk  {}// static_cast<Condition*>(aiRule)->type = Unit::EliteBerserk; } 
  | UnitEliteCataphract  {}// static_cast<Condition*>(aiRule)->type = Unit::EliteCataphract; } 
  | UnitEliteChuKoNu  {}// static_cast<Condition*>(aiRule)->type = Unit::EliteChuKoNu; } 
  | UnitEliteConquistador  {}// static_cast<Condition*>(aiRule)->type = Unit::EliteConquistador; } 
  | UnitEliteHuskarl  {}// static_cast<Condition*>(aiRule)->type = Unit::EliteHuskarl; } 
  | UnitEliteJaguarWarrior  {}// static_cast<Condition*>(aiRule)->type = Unit::EliteJaguarWarrior; } 
  | UnitEliteJanissary  {}// static_cast<Condition*>(aiRule)->type = Unit::EliteJanissary; } 
  | UnitEliteLongbowman  {}// static_cast<Condition*>(aiRule)->type = Unit::EliteLongbowman; } 
  | UnitEliteMameluke  {}// static_cast<Condition*>(aiRule)->type = Unit::EliteMameluke; } 
  | UnitEliteMangudai  {}// static_cast<Condition*>(aiRule)->type = Unit::EliteMangudai; } 
  | UnitElitePlumedArcher  {}// static_cast<Condition*>(aiRule)->type = Unit::ElitePlumedArcher; } 
  | UnitEliteSamurai  {}// static_cast<Condition*>(aiRule)->type = Unit::EliteSamurai; } 
  | UnitEliteTarkan  {}// static_cast<Condition*>(aiRule)->type = Unit::EliteTarkan; } 
  | UnitEliteTeutonicKnight  {}// static_cast<Condition*>(aiRule)->type = Unit::EliteTeutonicKnight; } 
  | UnitEliteThrowingAxeman  {}// static_cast<Condition*>(aiRule)->type = Unit::EliteThrowingAxeman; } 
  | UnitEliteWarElephant  {}// static_cast<Condition*>(aiRule)->type = Unit::EliteWarElephant; } 
  | UnitEliteWarWagon  {}// static_cast<Condition*>(aiRule)->type = Unit::EliteWarWagon; } 
  | UnitEliteWoadRaider  {}// static_cast<Condition*>(aiRule)->type = Unit::EliteWoadRaider; } 
  | UnitHuskarl  {}// static_cast<Condition*>(aiRule)->type = Unit::Huskarl; } 
  | UnitJaguarWarrior  {}// static_cast<Condition*>(aiRule)->type = Unit::JaguarWarrior; } 
  | UnitJanissary  {}// static_cast<Condition*>(aiRule)->type = Unit::Janissary; } 
  | UnitLongbowman  {}// static_cast<Condition*>(aiRule)->type = Unit::Longbowman; } 
  | UnitMameluke  {}// static_cast<Condition*>(aiRule)->type = Unit::Mameluke; } 
  | UnitMangudai  {}// static_cast<Condition*>(aiRule)->type = Unit::Mangudai; } 
  | UnitPetard  {}// static_cast<Condition*>(aiRule)->type = Unit::Petard; } 
  | UnitPlumedArcher  {}// static_cast<Condition*>(aiRule)->type = Unit::PlumedArcher; } 
  | UnitSamurai  {}// static_cast<Condition*>(aiRule)->type = Unit::Samurai; } 
  | UnitTarkan  {}// static_cast<Condition*>(aiRule)->type = Unit::Tarkan; } 
  | UnitTeutonicKnight  {}// static_cast<Condition*>(aiRule)->type = Unit::TeutonicKnight; } 
  | UnitThrowingAxeman  {}// static_cast<Condition*>(aiRule)->type = Unit::ThrowingAxeman; } 
  | UnitTrebuchet  {}// static_cast<Condition*>(aiRule)->type = Unit::Trebuchet; } 
  | UnitWarElephant  {}// static_cast<Condition*>(aiRule)->type = Unit::WarElephant; } 
  | UnitWarWagon  {}// static_cast<Condition*>(aiRule)->type = Unit::WarWagon; } 
  | UnitWoadRaider  {}// static_cast<Condition*>(aiRule)->type = Unit::WoadRaider; } 
  | UnitCannonGalleon  {}// static_cast<Condition*>(aiRule)->type = Unit::CannonGalleon; } 
  | UnitDemolitionShip  {}// static_cast<Condition*>(aiRule)->type = Unit::DemolitionShip; } 
  | UnitEliteCannonGalleon  {}// static_cast<Condition*>(aiRule)->type = Unit::EliteCannonGalleon; } 
  | UnitEliteLongboat  {}// static_cast<Condition*>(aiRule)->type = Unit::EliteLongboat; } 
  | UnitEliteTurtleShip  {}// static_cast<Condition*>(aiRule)->type = Unit::EliteTurtleShip; } 
  | UnitFastFireShip  {}// static_cast<Condition*>(aiRule)->type = Unit::FastFireShip; } 
  | UnitFireShip  {}// static_cast<Condition*>(aiRule)->type = Unit::FireShip; } 
  | UnitFishingShip  {}// static_cast<Condition*>(aiRule)->type = Unit::FishingShip; } 
  | UnitGalleon  {}// static_cast<Condition*>(aiRule)->type = Unit::Galleon; } 
  | UnitGalley  {}// static_cast<Condition*>(aiRule)->type = Unit::Galley; } 
  | UnitHeavyDemolitionShip  {}// static_cast<Condition*>(aiRule)->type = Unit::HeavyDemolitionShip; } 
  | UnitLongboat  {}// static_cast<Condition*>(aiRule)->type = Unit::Longboat; } 
  | UnitTradeCog  {}// static_cast<Condition*>(aiRule)->type = Unit::TradeCog; } 
  | UnitTransportShip  {}// static_cast<Condition*>(aiRule)->type = Unit::TransportShip; } 
  | UnitTurtleShip  {}// static_cast<Condition*>(aiRule)->type = Unit::TurtleShip; } 
  | UnitWarGalley  {}// static_cast<Condition*>(aiRule)->type = Unit::WarGalley; } 
  | UnitTradeCart  {}// static_cast<Condition*>(aiRule)->type = Unit::TradeCart; } 
  | UnitMissionary  {}// static_cast<Condition*>(aiRule)->type = Unit::Missionary; } 
  | UnitMonk  {}// static_cast<Condition*>(aiRule)->type = Unit::Monk; } 
  | UnitBatteringRam  {}// static_cast<Condition*>(aiRule)->type = Unit::BatteringRam; } 
  | UnitBombardCannon  {}// static_cast<Condition*>(aiRule)->type = Unit::BombardCannon; } 
  | UnitCappedRam  {}// static_cast<Condition*>(aiRule)->type = Unit::CappedRam; } 
  | UnitHeavyScorpion  {}// static_cast<Condition*>(aiRule)->type = Unit::HeavyScorpion; } 
  | UnitMangonel  {}// static_cast<Condition*>(aiRule)->type = Unit::Mangonel; } 
  | UnitOnager  {}// static_cast<Condition*>(aiRule)->type = Unit::Onager; } 
  | UnitScorpion  {}// static_cast<Condition*>(aiRule)->type = Unit::Scorpion; } 
  | UnitSiegeOnager  {}// static_cast<Condition*>(aiRule)->type = Unit::SiegeOnager; } 
  | UnitSiegeRam  {}// static_cast<Condition*>(aiRule)->type = Unit::SiegeRam; } 
  | UnitCamel  {}// static_cast<Condition*>(aiRule)->type = Unit::Camel; } 
  | UnitCavalier  {}// static_cast<Condition*>(aiRule)->type = Unit::Cavalier; } 
  | UnitHeavyCamel  {}// static_cast<Condition*>(aiRule)->type = Unit::HeavyCamel; } 
  | UnitHussar  {}// static_cast<Condition*>(aiRule)->type = Unit::Hussar; } 
  | UnitKnight  {}// static_cast<Condition*>(aiRule)->type = Unit::Knight; } 
  | UnitLightCavalry  {}// static_cast<Condition*>(aiRule)->type = Unit::LightCavalry; } 
  | UnitPaladin  {}// static_cast<Condition*>(aiRule)->type = Unit::Paladin; } 
  | UnitScoutCavalry  {}// static_cast<Condition*>(aiRule)->type = Unit::ScoutCavalry; } 
  | UnitVillager  {}// static_cast<Condition*>(aiRule)->type = Unit::Villager; } 
  | UnitArcherLine  {}// static_cast<Condition*>(aiRule)->type = Unit::ArcherLine; } 
  | UnitCavalryArcherLine  {}// static_cast<Condition*>(aiRule)->type = Unit::CavalryArcherLine; } 
  | UnitSkirmisherLine  {}// static_cast<Condition*>(aiRule)->type = Unit::SkirmisherLine; } 
  | UnitEagleWarriorLine  {}// static_cast<Condition*>(aiRule)->type = Unit::EagleWarriorLine; } 
  | UnitMilitiamanLine  {}// static_cast<Condition*>(aiRule)->type = Unit::MilitiamanLine; } 
  | UnitSpearmanLine  {}// static_cast<Condition*>(aiRule)->type = Unit::SpearmanLine; } 
  | UnitBerserkLine  {}// static_cast<Condition*>(aiRule)->type = Unit::BerserkLine; } 
  | UnitCataphractLine  {}// static_cast<Condition*>(aiRule)->type = Unit::CataphractLine; } 
  | UnitChuKoNuLine  {}// static_cast<Condition*>(aiRule)->type = Unit::ChuKoNuLine; } 
  | UnitConquistadorLine  {}// static_cast<Condition*>(aiRule)->type = Unit::ConquistadorLine; } 
  | UnitHuskarlLine  {}// static_cast<Condition*>(aiRule)->type = Unit::HuskarlLine; } 
  | UnitJaguarWarriorLine  {}// static_cast<Condition*>(aiRule)->type = Unit::JaguarWarriorLine; } 
  | UnitJanissaryLine  {}// static_cast<Condition*>(aiRule)->type = Unit::JanissaryLine; } 
  | UnitLongbowmanLine  {}// static_cast<Condition*>(aiRule)->type = Unit::LongbowmanLine; } 
  | UnitMamelukeLine  {}// static_cast<Condition*>(aiRule)->type = Unit::MamelukeLine; } 
  | UnitMangudaiLine  {}// static_cast<Condition*>(aiRule)->type = Unit::MangudaiLine; } 
  | UnitPlumedArcherLine  {}// static_cast<Condition*>(aiRule)->type = Unit::PlumedArcherLine; } 
  | UnitSamuraiLine  {}// static_cast<Condition*>(aiRule)->type = Unit::SamuraiLine; } 
  | UnitTarkanLine  {}// static_cast<Condition*>(aiRule)->type = Unit::TarkanLine; } 
  | UnitTeutonicKnightLine  {}// static_cast<Condition*>(aiRule)->type = Unit::TeutonicKnightLine; } 
  | UnitThrowingAxemanLine  {}// static_cast<Condition*>(aiRule)->type = Unit::ThrowingAxemanLine; } 
  | UnitWarElephantLine  {}// static_cast<Condition*>(aiRule)->type = Unit::WarElephantLine; } 
  | UnitWarWagonLine  {}// static_cast<Condition*>(aiRule)->type = Unit::WarWagonLine; } 
  | UnitWoadRaiderLine  {}// static_cast<Condition*>(aiRule)->type = Unit::WoadRaiderLine; } 
  | UnitCannonGalleonLine  {}// static_cast<Condition*>(aiRule)->type = Unit::CannonGalleonLine; } 
  | UnitDemolitionShipLine  {}// static_cast<Condition*>(aiRule)->type = Unit::DemolitionShipLine; } 
  | UnitFireShipLine  {}// static_cast<Condition*>(aiRule)->type = Unit::FireShipLine; } 
  | UnitGalleyLine  {}// static_cast<Condition*>(aiRule)->type = Unit::GalleyLine; } 
  | UnitLongboatLine  {}// static_cast<Condition*>(aiRule)->type = Unit::LongboatLine; } 
  | UnitTurtleShipLine  {}// static_cast<Condition*>(aiRule)->type = Unit::TurtleShipLine; } 
  | UnitBatteringRamLine  {}// static_cast<Condition*>(aiRule)->type = Unit::BatteringRamLine; } 
  | UnitMangonelLine  {}// static_cast<Condition*>(aiRule)->type = Unit::MangonelLine; } 
  | UnitScorpionLine  {}// static_cast<Condition*>(aiRule)->type = Unit::ScorpionLine; } 
  | UnitCamelLine  {}// static_cast<Condition*>(aiRule)->type = Unit::CamelLine; } 
  | UnitKnightLine  {}// static_cast<Condition*>(aiRule)->type = Unit::KnightLine; } 
  | UnitScoutCavalryLine  {}// static_cast<Condition*>(aiRule)->type = Unit::ScoutCavalryLine; } 

value:
    Number

walltype:
    WallTypeFortifiedWall  {}// static_cast<Condition*>(aiRule)->type = WallType::FortifiedWall; } 
  | WallTypePalisadeWall  {}// static_cast<Condition*>(aiRule)->type = WallType::PalisadeWall; } 
  | WallTypeStoneWall  {}// static_cast<Condition*>(aiRule)->type = WallType::StoneWall; } 
  | WallTypeStoneWallLine  {}// static_cast<Condition*>(aiRule)->type = WallType::StoneWallLine; } 


donothing:
    DoNothing

acknowledgeevent:
    AcknowledgeEvent eventtype eventid

attacknow:
    AttackNow

build:
    Build building

buildforward:
    BuildForward building

buildgate:
    BuildGate perimeter

buildwall:
    BuildWall perimeter walltype

buycommodity:
    BuyCommodity commodity

ccaddresource:
    CcAddResource resourcetype value

chatlocal:
    ChatLocal String

chatlocalusingid:
    ChatLocalUsingId stringid

chatlocalusingrange:
    ChatLocalUsingRange stringidstart stringidrange

chatlocaltoself:
    ChatLocalToSelf String

chattoall:
    ChatToAll String

chattoallusingid:
    ChatToAllUsingId stringid

chattoallusingrange:
    ChatToAllUsingRange stringidstart stringidrange

chattoallies:
    ChatToAllies String

chattoalliesusingid:
    ChatToAlliesUsingId stringid

chattoalliesusingrange:
    ChatToAlliesUsingRange stringidstart stringidrange

chattoenemies:
    ChatToEnemies String

chattoenemiesusingid:
    ChatToEnemiesUsingId stringid

chattoenemiesusingrange:
    ChatToEnemiesUsingRange stringidstart stringidrange

chattoplayer:
    ChatToPlayer playernumber String

chattoplayerusingid:
    ChatToPlayerUsingId playernumber stringid

chattoplayerusingrange:
    ChatToPlayerUsingRange playernumber stringidstart stringidrange

chattrace:
    ChatTrace value

cleartributememory:
    ClearTributeMemory playernumber resourcetype

deletebuilding:
    DeleteBuilding building

deleteunit:
    DeleteUnit unit

disableself:
    DisableSelf

disabletimer:
    DisableTimer timerid

enabletimer:
    EnableTimer timerid

enablewallplacement:
    EnableWallPlacement perimeter

generaterandomnumber:
    GenerateRandomNumber value

log:
    Log String

logtrace:
    LogTrace value

releaseescrow:
    ReleaseEscrow resourcetype

research:
    Research researchitem

research:
    Research age

resign:
    Resign

sellcommodity:
    SellCommodity commodity

setdifficultyparameter:
    SetDifficultyParameter difficultyparameter value

setdoctrine:
    SetDoctrine value

setescrowpercentage:
    SetEscrowPercentage resourcetype value

setgoal:
    SetGoal goalid value

setsharedgoal:
    SetSharedGoal sharedgoalid value

setsignal:
    SetSignal signalid

setstance:
    SetStance playernumber diplomaticstance

setstrategicnumber:
    SetStrategicNumber strategicnumber value

spy:
    Spy

train:
    Train unit

tributetoplayer:
    TributeToPlayer playernumber resourcetype value

action:
    donothing  | acknowledgeevent  | attacknow  | build  | buildforward  | buildgate  | buildwall  | buycommodity  | ccaddresource  | chatlocal  | chatlocalusingid  | chatlocalusingrange  | chatlocaltoself  | chattoall  | chattoallusingid  | chattoallusingrange  | chattoallies  | chattoalliesusingid  | chattoalliesusingrange  | chattoenemies  | chattoenemiesusingid  | chattoenemiesusingrange  | chattoplayer  | chattoplayerusingid  | chattoplayerusingrange  | chattrace  | cleartributememory  | deletebuilding  | deleteunit  | disableself  | disabletimer  | enabletimer  | enablewallplacement  | generaterandomnumber  | log  | logtrace  | releaseescrow  | research  | research  | resign  | sellcommodity  | setdifficultyparameter  | setdoctrine  | setescrowpercentage  | setgoal  | setsharedgoal  | setsignal  | setstance  | setstrategicnumber  | spy  | train  | tributetoplayer

%%

int main() {
       ai::ScriptLoader parser;
       return parser.parse(std::cin, std::cout);
}

void ai::ScriptParser::error(const location_type &loc, const std::string& message) {
    std::cerr << "parser error: " << message << " at " << loc.begin.line << std::endl;
}
