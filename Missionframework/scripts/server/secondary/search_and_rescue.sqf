
private _spawn_marker = [ 2000, 999999, false ] call KPLIB_fnc_getOpforSpawnPoint;
if ( _spawn_marker == "" ) exitWith {["Could not find position for search and rescue mission", "ERROR"] call KPLIB_fnc_log;};
used_positions pushbackUnique _spawn_marker;

private _helopos = (markerPos _spawn_marker) getPos [random 200, random 360];
private _helowreck = KPLIB_sarWreck createVehicle _helopos;
_helowreck allowDamage false;
_helowreck setPos _helopos;
_helowreck setPos _helopos;
private _helowreckDir = (random 360);
_helowreck setDir _helowreckDir;

private _helofire = KPLIB_sarFire createVehicle (getpos _helowreck);
_helofire setpos (getpos _helowreck);
_helofire setpos (getpos _helowreck);

private _pilotsGrp = createGroup [KPLIB_side_enemy, true];
private _pilotsPos = (getpos _helowreck) getPos [25, random 360];

[KPLIB_b_heliPilotUnit, _pilotsPos, _pilotsGrp, "PRIVATE", 0.5] call KPLIB_fnc_createManagedUnit;
sleep 0.2;

[KPLIB_b_heliPilotUnit, _pilotsPos getPos [1, random 360], _pilotsGrp, "PRIVATE", 0.5] call KPLIB_fnc_createManagedUnit;
sleep 2;

private _pilotUnits = units _pilotsGrp;
{
    [ _x, true] spawn prisonner_ai;
    _x setDir (random 360);
    sleep 0.5
} foreach (_pilotUnits);

private _grppatrol = createGroup [KPLIB_side_enemy, true];
private _patrolcorners = [
    [ (getpos _helowreck select 0) - 40, (getpos _helowreck select 1) - 40, 0 ],
    [ (getpos _helowreck select 0) + 40, (getpos _helowreck select 1) - 40, 0 ],
    [ (getpos _helowreck select 0) + 40, (getpos _helowreck select 1) + 40, 0 ],
    [ (getpos _helowreck select 0) - 40, (getpos _helowreck select 1) + 40, 0 ]
];

{
    [_x, _patrolcorners select 0, _grppatrol, "PRIVATE", 0.5] call KPLIB_fnc_createManagedUnit;
} foreach ([] call KPLIB_fnc_getSquadComp);

{ deleteWaypoint _x } forEachReversed waypoints _grppatrol;
{
    private _nextcorner = _x;
    _waypoint = _grppatrol addWaypoint [_nextcorner,0];
    _waypoint setWaypointType "MOVE";
    _waypoint setWaypointSpeed "LIMITED";
    _waypoint setWaypointBehaviour "SAFE";
    _waypoint setWaypointCompletionRadius 5;
} foreach _patrolcorners;

_waypoint = _grppatrol addWaypoint [(_patrolcorners select 0), 0];
_waypoint setWaypointType "CYCLE";
{doStop _x; _x doFollow (leader _grppatrol)} foreach units _grppatrol;

private _grpsentry = createGroup [KPLIB_side_enemy, true];
private _nbsentry = 2 + (floor (random 3));

for [ {_idx=0},{_idx < _nbsentry},{_idx=_idx+1} ] do {
    [KPLIB_o_sentry, _pilotsPos getPos [1, random 360], _grpsentry, "PRIVATE", 0.5] call KPLIB_fnc_createManagedUnit;
};

(leader _grpsentry) setDir (random 360);

(KPLIB_o_transportTruck createVehicle ((getpos _helowreck) getPos [25, random 360])) setDir random 360;

private _vehicle_pool = KPLIB_o_armyVehicles;
if ( KPLIB_enemyReadiness < 50 ) then {
    _vehicle_pool = KPLIB_o_armyVehiclesLight;
};

private _vehtospawn = [];
private _spawnchances = [75,50,15];
{if (random 100 < _x) then {_vehtospawn pushBack (selectRandom _vehicle_pool);};} foreach _spawnchances;
{
    private _vehicle = [(getpos _helowreck) getPos [30 + (random 30), random 360], _x, true] call KPLIB_fnc_spawnVehicle;
    _vehicle addMPEventHandler ["MPKilled", {
        params ["_unit", "_killer"];
        ["KPLIB_manageKills", [_unit, _killer]] call CBA_fnc_localEvent;
    }];
} foreach _vehtospawn;

secondary_objective_position = getpos _helowreck;
secondary_objective_position_marker = secondary_objective_position getPos [800 * (KPLIB_param_difficulty min 1), random 360];
publicVariable "secondary_objective_position_marker";
sleep 1;
KPLIB_secondary_in_progress = 2; publicVariable "KPLIB_secondary_in_progress";
[6] remoteExec ["remote_call_intel"];

waitUntil {
    sleep 5;
    { ( alive _x ) && ( _x distance ( [ getpos _x ] call KPLIB_fnc_getNearestFob ) > 50 ) } count _pilotUnits == 0
};

sleep 5;

private _alive_crew_count = { alive _x } count _pilotUnits;
if ( _alive_crew_count == 0 ) then {
    [7] remoteExec ["remote_call_intel"];
} else {
    [8] remoteExec ["remote_call_intel"];
    private _grp = createGroup [KPLIB_side_player, true];
    { [_x ] joinSilent _grp; } foreach _pilotUnits;
    { deleteWaypoint _x } forEachReversed waypoints _grp;
    {doStop _x; _x doFollow leader _grp} foreach units _grp;
    { [ _x ] spawn {
        sleep 600;
        if (isNull objectParent (_this # 0)) then {deleteVehicle (_this # 0)} else {(objectParent (_this # 0)) deleteVehicleCrew (_this # 0)};
        };
    } foreach _pilotUnits;
};

resources_intel = resources_intel + (10 * _alive_crew_count);
stats_secondary_objectives = stats_secondary_objectives + 1;

KPLIB_secondary_in_progress = -1; publicVariable "KPLIB_secondary_in_progress";
sleep 1;
doSaveTrigger = true;
