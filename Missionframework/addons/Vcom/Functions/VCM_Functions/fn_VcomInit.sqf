//Parameters
VCM_PublicScript = compileFinal "[] call (_this select 0);";
VCM_ServerAsk = compileFinal "(_this select 1) publicVariableClient (_this select 0);";

/*
"AwareFormationSoft" enableAIFeature false;
"CombatFormationSoft" enableAIFeature false;
*/

if (isServer) then
{
	if (isFilePatchingEnabled) then
	{
		
		private _path = "\userconfig\VCOM_AI\AISettingsV3.4.1.hpp";
		
		if (fileExists _path) then
		{
			[] call compile preprocessFileLineNumbers "\userconfig\VCOM_AI\AISettingsV3.4.1.hpp";
			[Vcm_Settings] remoteExec ["VCM_PublicScript",0,false];		
		}
		else
		{
			[] call compile preprocessFileLineNumbers "addons\Vcom\Functions\VCOMAI_DefaultSettings.sqf";
			[Vcm_Settings] remoteExec ["VCM_PublicScript",0,false];			
		};
	}
	else
	{
			[] call compile preprocessFileLineNumbers "addons\Vcom\Functions\VCOMAI_DefaultSettings.sqf";
			[Vcm_Settings] remoteExec ["VCM_PublicScript",0,false];
	};
};

//waitUntil {!(isNil "VCM_AIMagLimit")};

//Mod checks
//ACE CHECK
if (!(isNil "ACE_Medical_enableFor") && {ACE_Medical_enableFor isEqualTo 1}) then {VCM_MEDICALACTIVE = true;} else {VCM_MEDICALACTIVE = false;};
//CBA CHECK
if (isClass(configFile >> "CfgPatches" >> "cba_main")) then {CBAACT = true;} else {CBAACT = false;};
//ENHANCED MOVEMENT CHECK
if !(isNil "EM_debug") then {VCOM_EM_ENABLED = true;} else {VCOM_EM_ENABLED = false;};
if !(isNil "emr_main_climbingenabled") then {VCOM_EMR_ENABLED = true;} else {VCOM_EMR_ENABLED = false;};


//Global actions compiles
Vcm_PMN = compileFinal "(_this select 0) playMoveNow (_this select 1);";
Vcm_SM = compileFinal "(_this select 0) switchMove (_this select 1);";
Vcm_PAN = compileFinal "(_this select 0) playActionNow (_this select 1);";
VCOM_MINEARRAY = [];
VCM_CoverQueue = [];





