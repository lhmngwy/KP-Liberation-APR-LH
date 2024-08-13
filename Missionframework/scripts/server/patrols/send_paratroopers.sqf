params [
    ["_pos", [0, 0, 0], [[]], [3]],
    ["_objective", [0, 0, 0], [[]], [3]],
    ["_chopper_type", "", [""]]
];

if !(isServer) exitWith {};

if (((_objective select 0) == 0 && (_objective select 1) == 0 && (_objective select 2) == 0) || KPLIB_o_helicopters isEqualTo []) exitWith {false};
    
if (_chopper_type == "") then {
    _chopper_type = selectRandom KPLIB_o_helicopters;

    while {!(_chopper_type in KPLIB_o_troopTransports)} do {
        _chopper_type = selectRandom KPLIB_o_helicopters;
    };
};

private _i = 0;
private _spawnPos = [];
while {_spawnPos isEqualTo []} do {
    _i = _i + 1;
    _spawnpos = (_pos getPos [150 + random 100, random 360]) findEmptyPosition [10, 100, _chopper_type];
    if (_i isEqualTo 10) exitWith {_spawnPos = zeroPos};
};

private _newVehicle = createVehicle [_chopper_type, _spawnPos, [], 0, "FLY"];
_newVehicle remoteExec ["AIDC_fnc_init"];
private _pilot_group = createGroup [KPLIB_side_enemy, true];
private _crew = units (createVehicleCrew _newVehicle);
_crew joinSilent _pilot_group;
_newVehicle addMPEventHandler ["MPKilled", {
    params ["_unit", "_killer"];
    ["KPLIB_manageKills", [_unit, _killer]] call CBA_fnc_localEvent;
}];
{
    _x addMPEventHandler ["MPKilled", {
        params ["_unit", "_killer"];
        ["KPLIB_manageKills", [_unit, _killer]] call CBA_fnc_localEvent;
    }];
} forEach (crew _newVehicle);

// Clear cargo, if enabled
[_newVehicle] call KPLIB_fnc_clearCargo;
_newVehicle addItemCargoGlobal ["toolkit", 1];
// Process KP object init
[_newVehicle] call KPLIB_fnc_addObjectInit;

private _para_group = createGroup [KPLIB_side_enemy, true];

while {(count (units _para_group)) < 8} do {
    [KPLIB_o_paratrooper, _spawnPos, _para_group] call KPLIB_fnc_createManagedUnit;
};

_newVehicle lock true;

_pilot_group setVariable ["acex_headless_blacklist", true, true];
_para_group setVariable ["acex_headless_blacklist", true, true];

{deleteWaypoint _x} forEachReversed waypoints _pilot_group;
{deleteWaypoint _x} forEachReversed waypoints _para_group;

{removeBackpack _x; _x addBackPack "B_parachute"; _x assignAsCargo _newvehicle; sleep 0.1; _x moveInCargo _newVehicle; 0.1} forEach (units _para_group);

private _pilot = driver _newVehicle;
private _pilotSkill = skill _pilot;
_pilot allowFleeing 0;
_pilot setSkill 1;

_newVehicle flyInHeight [100 + random 40, true];

_i = 0;
private _objective_offset = _objective getPos [125 + random 125, random 360];
while {surfaceIsWater _objective_offset} do {
    _i = _i + 1;
    _objective_offset = _objective getPos [125 + random 125, random 360];
    if (_i isEqualTo 10) exitWith {_objective_offset = _objective};
};
private _pilot_wp_target = _pilot_group addWaypoint [_objective_offset, 100];
_pilot_wp_target setWaypointType "MOVE";
_pilot_wp_target setWaypointSpeed "NORMAL";
_pilot_wp_target setWaypointBehaviour "CARELESS";
_pilot_wp_target setWaypointCombatMode "BLUE";
_pilot_wp_target setWaypointCompletionRadius 100;

_pilot_wp_target = _pilot_group addWaypoint [_objective_offset, 100];
_pilot_wp_target setWaypointType "MOVE";

_pilot_wp_target = _pilot_group addWaypoint [_objective_offset, 100];
_pilot_wp_target setWaypointType "CYCLE";

waitUntil {sleep 1;
    _newVehicle distance2D _objective_offset < 1200
};

private _unload_distance = ((speed _newVehicle) * 2) max 300;

waitUntil {sleep 1;
    !(alive _newVehicle) || (damage _newVehicle > 0.2) || ((_newVehicle distance2D _objective_offset < _unload_distance) && !(surfaceIsWater (getpos _newVehicle)))
};

_newVehicle lock false;

{sleep 0.5; unassignVehicle _x; moveout _x;} forEach (units _para_group);

{deleteWaypoint _x} forEachReversed waypoints _para_group;

_para_wp_combat_1 = _para_group addWaypoint [_objective, 100];
_para_wp_combat_1 setWaypointType "MOVE";
_para_wp_combat_1 setWaypointSpeed "NORMAL";
_para_wp_combat_1 setWaypointBehaviour "AWARE";
_para_wp_combat_1 setWaypointCombatMode "YELLOW";
_para_wp_combat_1 setWaypointCompletionRadius 30;

_para_wp_combat_1 = _para_group addWaypoint [_objective, 100];
_para_wp_combat_1 setWaypointType "SAD";
_para_wp_combat_1 = _para_group addWaypoint [_objective, 100];
_para_wp_combat_1 setWaypointType "SAD";
_para_wp_combat_1 = _para_group addWaypoint [_objective, 100];
_para_wp_combat_1 setWaypointType "SAD";
_para_wp_combat_1 = _para_group addWaypoint [_objective, 100];
_para_wp_combat_1 setWaypointType "CYCLE";

_para_group setVariable ["KPLIB_isBattleGroup", true];

sleep 4;

{deleteWaypoint _x} forEachReversed waypoints _pilot_group;

_newVehicle forceSpeed -1;

_pilot setSkill _pilotSkill;

_magazines = magazinesAllTurrets [_newVehicle, true];
if (count _magazines > 1 || ((count _magazines == 1) && {toLower ((_magazines select 0) select 0) find "cmflare" == -1})) then {
    _pilot_wp_combat_1 = _pilot_group addWaypoint [_objective, 100];
    _pilot_wp_combat_1 setWaypointType "MOVE";
    _pilot_wp_combat_1 setWaypointSpeed "NORMAL";
    _pilot_wp_combat_1 setWaypointBehaviour "AWARE";
    _pilot_wp_combat_1 setWaypointCombatMode "YELLOW";
    _pilot_wp_combat_1 setWaypointCompletionRadius 300;

    _pilot_wp_combat_1 = _pilot_group addWaypoint [_objective, 100];
    _pilot_wp_combat_1 setWaypointType "SAD";
    _pilot_wp_combat_1 = _pilot_group addWaypoint [_objective, 100];
    _pilot_wp_combat_1 setWaypointType "SAD";
    _pilot_wp_combat_1 = _pilot_group addWaypoint [_objective, 100];
    _pilot_wp_combat_1 setWaypointType "SAD";
    _pilot_wp_combat_1 = _pilot_group addWaypoint [_objective, 100];
    _pilot_wp_combat_1 setWaypointType "CYCLE";
} else {
    _pilot_wp_rtb = _pilot_group addWaypoint [_spawnPos, 100];
    _pilot_wp_rtb setWaypointType "MOVE";
    _pilot_wp_rtb setWaypointSpeed "FULL";
    _pilot_wp_rtb setWaypointBehaviour "CARELESS";
    _pilot_wp_rtb setWaypointCombatMode "BLUE";
    _pilot_wp_rtb setWaypointCompletionRadius 100;

    _pilot_wp_rtb = _pilot_group addWaypoint [_spawnPos, 100];
    _pilot_wp_rtb setWaypointType "MOVE";

    _pilot_wp_rtb = _pilot_group addWaypoint [_spawnPos, 100];
    _pilot_wp_rtb setWaypointType "CYCLE";

    waitUntil {sleep 1;
        !(alive driver _newVehicle) || (_newVehicle distance2D _spawnPos < 200)
    };

    if (!alive driver _newVehicle) exitWith {};

    deleteVehicleCrew _newVehicle;
    deleteVehicle _newVehicle;
};
