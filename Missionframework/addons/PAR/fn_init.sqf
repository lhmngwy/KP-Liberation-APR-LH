if (isDedicated) exitWith {};
ACE_enabled = isClass(configFile >> "cfgPatches" >> "ace_medical");
if (ACE_enabled) exitWith { diag_log "-- PAR loading Error : PAR is incompatible with ACE Medical." };
[] execVM "PAR\PAR_AI_Revive.sqf";
