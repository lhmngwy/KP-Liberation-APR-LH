waitUntil {!isNil "KPLIB_initServerDone"};

params ["_newUnit", "_oldUnit"];

if( (uniform _oldUnit) isEqualTo "" ) then {
    _newUnit addUniform KPLIB_b_basic_uniform;
} else {
    removeUniform _newUnit;
    _newUnit addUniform (uniform _oldUnit);
};

if (isNil "KPLIB_respawn_loadout") then {
    removeAllWeapons player;
    removeAllItems player;
    removeAllAssignedItems player;
    removeVest player;
    removeBackpack player;
    removeHeadgear player;
    removeGoggles player;
    player linkItem "ItemMap";
    player linkItem "ItemCompass";
    player linkItem "ItemWatch";
    //player unlinkItem "ItemRadio";
    //player unlinkItem "ItemGPS";
} else {
    sleep 4;
    [player, KPLIB_respawn_loadout] call KPLIB_fnc_setLoadout;
};

[] call KPLIB_fnc_addActionsPlayer;

// Support Module handling
if ([
    false,
    player isEqualTo ([] call KPLIB_fnc_getCommander) || (getPlayerUID player) in KPLIB_whitelist_supportModule,
    true
] select KPLIB_param_supportModule) then {
    waitUntil {!isNil "KPLIB_param_supportModule_req" && !isNil "KPLIB_param_supportModule_arty" && !isNil "KPLIB_param_supportModule_casHeli"
               && !isNil "KPLIB_param_supportModule_casBombing" && !isNil "KPLIB_param_supportModule_transport" && time > 5};

    // Remove link to corpse, if respawned
    if (!isNull _oldUnit) then {
        KPLIB_param_supportModule_req synchronizeObjectsRemove [_oldUnit];
        _oldUnit synchronizeObjectsRemove [KPLIB_param_supportModule_req];
    };

    // Link player to support modules
    [player, KPLIB_param_supportModule_req, KPLIB_param_supportModule_arty] call BIS_fnc_addSupportLink;
    [player, KPLIB_param_supportModule_req, KPLIB_param_supportModule_casHeli] call BIS_fnc_addSupportLink;
    [player, KPLIB_param_supportModule_req, KPLIB_param_supportModule_casBombing] call BIS_fnc_addSupportLink;
    [player, KPLIB_param_supportModule_req, KPLIB_param_supportModule_transport] call BIS_fnc_addSupportLink;

    // Init modules, if newly joined and not client host
    if (isNull _oldUnit && !isServer) then {
        [KPLIB_param_supportModule_req] call BIS_fnc_moduleSupportsInitRequester;
        [KPLIB_param_supportModule_arty] call BIS_fnc_moduleSupportsInitProvider;
        [KPLIB_param_supportModule_casHeli] call BIS_fnc_moduleSupportsInitProvider;
        [KPLIB_param_supportModule_casBombing] call BIS_fnc_moduleSupportsInitProvider;
        [KPLIB_param_supportModule_transport] call BIS_fnc_moduleSupportsInitProvider;
    };
};

player setUnitTrait ["engineer", true];
player setUnitTrait ["explosiveSpecialist", true];
player setUnitTrait ["medic", true];
player setUnitTrait ["UAVHacker", true];

_aiSquad = (units group player) select {alive _x && !isPlayer _x};
player setVariable ["KPLIB_unitsBought", (count _aiSquad) + 1, true];
_unconsciousAiSquad = (units group player) select {_x getVariable ['PAR_isUnconscious', false] && !isPlayer _x};
doStop _aiSquad;
{
    _x setDamage 1;
    [_x] joinSilent grpNull;
} forEach _unconsciousAiSquad;
{
    _x setposATL getPosATL player;
    _x setDir (random 360);
} forEach _aiSquad;

[] spawn {
    waitUntil { sleep 1; player getVariable ["KPLIB_namespaceSet", false] };

    if ((player == [] call KPLIB_fnc_getCommander) || (player getVariable ['KPLIB_hasDirectAccess', false])) then {
        // Request Zeus if enabled
        if (KPLIB_param_zeusCommander) then {
            [] call KPLIB_fnc_requestZeus;
        };
    };
};
