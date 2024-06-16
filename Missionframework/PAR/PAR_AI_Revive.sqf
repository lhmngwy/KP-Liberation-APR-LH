/*
  pSiKO AI Revive - v3.05 - SP/MP - AI
  aka: PAR Revive

Author:

	[AKH] pSiKO

Description:

	give ablitty to ai to revive player or other ai
  unit sharing the same PAR_Grp_ID revive each others

Instructions:

	ExecVM from init.sqf in your mission directory.
  [] execVM "PAR\PAR_AI_Revive.sqf";

Based on:
  AI REVIVE HEAL SCRIPT SP/MP by Pierre MGI
  at : https://forums.bohemia.net/forums/topic/207522-ai-revive-heal-script-spmp/

  Farooq's Revive by farooqaaa
  at : https://forums.bohemia.net/forums/topic/146926-farooqs-revive/

todo:
 - cleanup if unit leave group

_________________________________________________________________________*/

if (!hasInterface) exitWith {};

diag_log "-_- LRX PAR Mod by pSiKO -_-";

//--- Configuration ---------------------------------------//
// PAR Main mode
// 0 - Disabled
// 1 - Enabled - Everyone can revive
// 2 - Enabled - Everyone can revive using Medikit/FAK
// 3 - Enabled - Only medics can revive

if (isNil "PAR_revive") then { PAR_revive = 2 };
if (PAR_revive == 0) exitWith {};

// Seconds until unconscious unit bleeds out and dies.
if (isNil "PAR_bleedout") then { PAR_bleedout = 300 };

// Revive extra boost
if (isNil "PAR_bleedout_extra") then { PAR_bleedout_extra = 60 };

// Max AI in PAR group
if (isNil "PAR_ai_limit") then { PAR_ai_limit = 12 };

// Max AI revive counter
if (isNil "PAR_ai_revive") then { PAR_ai_revive = 2 };

// Enable info killer message
PAR_EnableDeathMessages = false;

// player AI brothers
PAR_AI_bros = [];

// PAR player group ID
PAR_Grp_ID = getPlayerUID player;

//--- Classnames ---------------------------------------//
PAR_Medikit = "Medikit";
PAR_AidKit = "FirstAidKit";
PAR_BloodSplat = [
  "BloodPool_01_Large_New_F",
  "BloodPool_01_Medium_New_F",
  "BloodSplatter_01_Large_New_F",
  "BloodSplatter_01_Medium_New_F",
  "BloodSplatter_01_Small_New_F"
];
PAR_MedGarbage = [
  "MedicalGarbage_01_3x3_v1_F",
  "MedicalGarbage_01_3x3_v2_F"
];
PAR_medical_source = "Land_MedicalTent_01_base_F";

//--- Init functions --------------------------------//
[] call compile preprocessFile "PAR\PAR_global_functions.sqf";

//--- PAR Manager ---------------------------------------//
[] spawn PAR_AI_Manager;
[] spawn PAR_ActionManager;

diag_log "LRX PAR Mod Initialized.";

player createDiarySubject["LRX","PAR"];
player createDiaryRecord ["LRX", ["PAR", format ["PAR Revive by <font color='#ff4000'>pSiKO</font>."]]];