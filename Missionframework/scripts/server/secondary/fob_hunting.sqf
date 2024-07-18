
_defenders_amount = (15 * (sqrt (KPLIB_param_unitcap))) min 15;

_spawn_marker = [2000,999999,false] call KPLIB_fnc_getOpforSpawnPoint;
if (_spawn_marker == "") exitWith {["Could not find position for fob hunting mission", "ERROR"] call KPLIB_fnc_log;};

used_positions pushBack _spawn_marker;
_base_position = markerpos _spawn_marker;
_base_objects = [];
_base_objectives = [];

([] call (compile preprocessFileLineNumbers (selectRandom KPLIB_fob_templates))) params [
    "_objects_to_build",
    "_objectives_to_build",
    "_defenders_to_build",
    "_base_corners"
];

[_base_position, 50] call KPLIB_fnc_createClearance;

private _nextobject = objNull;

{
    _x params [
        "_nextclass",
        "_nextpos",
        "_nextdir"
    ];

    _nextpos = [((_base_position select 0) + (_nextpos select 0)), ((_base_position select 1) + (_nextpos select 1)), 0];

    _nextobject = _nextclass createVehicle _nextpos;
    _nextobject allowDamage false;
    _nextobject setVectorUp [0, 0, 1];
    _nextobject setdir _nextdir;
    _nextobject setpos _nextpos;
    _nextobject setVectorUp [0, 0, 1];
    _nextobject setdir _nextdir;
    _nextobject setpos _nextpos;

    _base_objects pushBack _nextobject;
} forEach _objects_to_build;

sleep 1;

{
    _x params [
        "_nextclass",
        "_nextpos",
        "_nextdir"
    ];

    _nextpos = [((_base_position select 0) + (_nextpos select 0)), ((_base_position select 1) + (_nextpos select 1)), 0];

    _nextobject = _nextclass createVehicle _nextpos;
    _nextobject allowDamage false;
    _nextobject setVectorUp [0, 0, 1];
    _nextobject setpos _nextpos;
    _nextobject setdir _nextdir;
    _nextobject setVectorUp [0, 0, 1];
    _nextobject setpos _nextpos;
    _nextobject setdir _nextdir;
    _nextobject lock 2;

    _base_objectives pushBack _nextobject;
} forEach _objectives_to_build;

sleep 1;

{_x setDamage 0; _x allowDamage true;} foreach (_base_objectives + _base_objects);

_grpdefenders = createGroup [KPLIB_side_enemy, true];
_grpdefenders setVariable ["acex_headless_blacklist", true, true];
_idxselected = [];

while {(count _idxselected) < _defenders_amount && (count _idxselected) < (count _defenders_to_build)} do {
    _idxselected pushBackUnique (floor (random (count _defenders_to_build)));
};

{
    (_defenders_to_build select _x) params [
        "_nextclass",
        "_nextpos",
        "_nextdir"
    ];

    _nextpos = [((_base_position select 0) + (_nextpos select 0)), ((_base_position select 1) + (_nextpos select 1)), (_nextpos select 2)];
    private _nextDefender = [_nextclass, _nextpos, _grpdefenders, "PRIVATE", 0.5] call KPLIB_fnc_createManagedUnit;
    _nextDefender setdir _nextdir;
    _nextDefender setpos _nextpos;
    [_nextDefender, "", true] spawn building_defence_ai;
} forEach _idxselected;

private _sentryMax = ceil ((3 + (floor (random 4))) * (sqrt (KPLIB_param_unitcap)));

_grpsentry = createGroup [KPLIB_side_enemy, true];
_base_sentry_pos = [(_base_position select 0) + ((_base_corners select 0) select 0), (_base_position select 1) + ((_base_corners select 0) select 1), 0];
for [{_idx=0}, {_idx < _sentryMax}, {_idx=_idx+1}] do {
    [KPLIB_o_sentry, _base_sentry_pos, _grpsentry, "PRIVATE", 0.5] call KPLIB_fnc_createManagedUnit;
};

{ deleteWaypoint _x } forEachReversed waypoints _grpsentry;
private _waypoint = [];
{
    _waypoint = _grpsentry addWaypoint [[((_base_position select 0) + (_x select 0)), ((_base_position select 1) + (_x select 1)), 0], -1];
    _waypoint setWaypointType "MOVE";
    _waypoint setWaypointSpeed "LIMITED";
    _waypoint setWaypointBehaviour "SAFE";
    _waypoint setWaypointCompletionRadius 5;
} forEach _base_corners;

_waypoint = _grpsentry addWaypoint [[(_base_position select 0) + ((_base_corners select 0) select 0), (_base_position select 1) + ((_base_corners select 0) select 1), 0], -1];
_waypoint setWaypointType "CYCLE";

_base_staticDefence = [];
_grpStaticHMG = createGroup [KPLIB_side_enemy, true];
if !(isNil "KPLIB_o_turrets_HMG") then {
    private _staticDefenceDistMin = 25;
    private _staticDefenceDistMax = 50;
    private _staticDefenceDist = _staticDefenceDistMin + (random (_staticDefenceDistMax - _staticDefenceDistMin));
    private _staticDefenceAngle = random 360;
    private _staticDefencePosX_1 = (_base_position select 0) + _staticDefenceDist * cos(_staticDefenceAngle);
    private _staticDefencePosX_2 = (_base_position select 0) + _staticDefenceDist * cos(_staticDefenceAngle);
    private _staticDefencePosY_1 = (_base_position select 1) + _staticDefenceDist * sin(_staticDefenceAngle);
    private _staticDefencePosY_2 = (_base_position select 1) + _staticDefenceDist * sin(_staticDefenceAngle);
    private _staticDefencePos_1 = [_staticDefencePosX_1, _staticDefencePosY_1];
    private _staticDefencePos_2 = [_staticDefencePosX_2, _staticDefencePosY_2];
    _staticDefencePos_1 = _staticDefencePos_1 findEmptyPosition [5, 50, KPLIB_b_crateAmmo];
    _staticDefencePos_2 = _staticDefencePos_2 findEmptyPosition [5, 50, KPLIB_b_crateAmmo];
    _staticDefenceHMG_1 = [_staticDefencePos_1, selectRandom KPLIB_o_turrets_HMG] call KPLIB_fnc_spawnVehicle;
    _staticDefenceHMG_2 = [_staticDefencePos_2, selectRandom KPLIB_o_turrets_HMG] call KPLIB_fnc_spawnVehicle;
    (crew _staticDefenceHMG_1) joinSilent _grpStaticHMG;
    (crew _staticDefenceHMG_2) joinSilent _grpStaticHMG;
    _base_staticDefence pushBack _staticDefenceHMG_1;
    _base_staticDefence pushBack _staticDefenceHMG_2;
};
_grpStaticAA = createGroup [KPLIB_side_enemy, true];
if !(isNil "KPLIB_o_turrets_AA") then {
    private _staticDefenceDistMin = 50;
    private _staticDefenceDistMax = 75;
    private _staticDefenceDist = _staticDefenceDistMin + (random (_staticDefenceDistMax - _staticDefenceDistMin));
    private _staticDefenceAngle = random 360;
    private _staticDefencePosX_1 = (_base_position select 0) + _staticDefenceDist * cos(_staticDefenceAngle);
    private _staticDefencePosX_2 = (_base_position select 0) + _staticDefenceDist * cos(_staticDefenceAngle);
    private _staticDefencePosY_1 = (_base_position select 1) + _staticDefenceDist * sin(_staticDefenceAngle);
    private _staticDefencePosY_2 = (_base_position select 1) + _staticDefenceDist * sin(_staticDefenceAngle);
    private _staticDefencePos_1 = [_staticDefencePosX_1, _staticDefencePosY_1, (_base_position select 2)];
    private _staticDefencePos_2 = [_staticDefencePosX_2, _staticDefencePosY_2, (_base_position select 2)];
    _staticDefencePos_1 = _staticDefencePos_1 findEmptyPosition [5, 50, KPLIB_b_crateAmmo];
    _staticDefencePos_2 = _staticDefencePos_2 findEmptyPosition [5, 50, KPLIB_b_crateAmmo];
    _staticDefenceAA_1 = [_staticDefencePos_1, selectRandom KPLIB_o_turrets_AA] call KPLIB_fnc_spawnVehicle;
    _staticDefenceAA_2 = [_staticDefencePos_2, selectRandom KPLIB_o_turrets_AA] call KPLIB_fnc_spawnVehicle;
    (crew _staticDefenceAA_1) joinSilent _grpStaticAA;
    (crew _staticDefenceAA_2) joinSilent _grpStaticAA;
    _base_staticDefence pushBack _staticDefenceAA_1;
    _base_staticDefence pushBack _staticDefenceAA_2;
};

secondary_objective_position = _base_position;
secondary_objective_position_marker = [(((secondary_objective_position select 0) + (800 * (KPLIB_param_difficulty min 1))) - random (1600 * (KPLIB_param_difficulty min 1))), (((secondary_objective_position select 1) + (800 * (KPLIB_param_difficulty min 1))) - random (1600 * (KPLIB_param_difficulty min 1))), 0];
publicVariable "secondary_objective_position_marker";
sleep 1;

KPLIB_secondary_in_progress = 0; publicVariable "KPLIB_secondary_in_progress";
[2] remoteExec ["remote_call_intel"];

waitUntil {
    sleep 5;
    (_base_objectives select {alive _x}) isEqualTo []
};

KPLIB_enemyReadiness = round (KPLIB_enemyReadiness * (1 - KPLIB_secondary_objective_impact));
stats_secondary_objectives = stats_secondary_objectives + 1;
sleep 1;
[] spawn KPLIB_fnc_doSave;
sleep 3;

[3] remoteExec ["remote_call_intel"];

KPLIB_secondary_in_progress = -1; publicVariable "KPLIB_secondary_in_progress";

sleep 900;
{deleteVehicle _x} forEach _base_objectives;
{deleteVehicle _x} forEach units _grpdefenders;
{deleteVehicle _x} forEach units _grpsentry;
sleep 900;
{objectParent _x deleteVehicleCrew _x} forEach units _grpStaticHMG;
{objectParent _x deleteVehicleCrew _x} forEach units _grpStaticAA;
sleep 900;
{if (_x getVariable ["KPLIB_captured", false]) then {deleteVehicle _x};} forEach _base_staticDefence;
{if (_x getVariable ["KPLIB_captured", false]) then {deleteVehicle _x};} forEach _base_objects;
