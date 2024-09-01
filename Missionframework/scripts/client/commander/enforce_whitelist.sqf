scriptName "[KPLIB] Enforce Whitelist";

waitUntil { sleep 1; !isNil "KPLIB_param_cmdrWhitelist" };

if (!KPLIB_param_cmdrWhitelist) exitWith {};

waitUntil {alive player};
sleep 2;

if (player isEqualTo ([] call KPLIB_fnc_getCommander) && !(serverCommandAvailable "#kick")) then {
    if !((getPlayerUID player) in KPLIB_whitelist_cmdrSlot) then {
        sleep 1;
        endMission "END1";
    };
};
