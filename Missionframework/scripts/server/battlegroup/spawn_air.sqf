params [
    ["_objective", [0, 0, 0], [[]], [3]],
    ["_min", 0, [0]]
];

if (KPLIB_o_planes isEqualTo []) exitWith {false};

private _planes_number = ((floor linearConversion [40, 100, KPLIB_enemyReadiness, 1, 3]) min 3) max _min;

if (_planes_number < 1) exitWith {};

private _class = selectRandom KPLIB_o_planes;
private _spawnPoint = ([KPLIB_sectors_airSpawn, [_first_objective], {(markerPos _x) distance _input0}, "ASCEND"] call BIS_fnc_sortBy) select 0;
private _spawnPos = [];
private _plane = objNull;
private _grp = createGroup [KPLIB_side_enemy, true];

for "_i" from 1 to _planes_number do {
    _spawnPos = markerPos _spawnPoint;
    _spawnPos = [(((_spawnPos select 0) + 500) - random 1000), (((_spawnPos select 1) + 500) - random 1000), 200];
    _plane = createVehicle [_class, _spawnPos, [], 0, "FLY"];
    createVehicleCrew _plane;
    _plane flyInHeight (120 + (random 180));
    [_plane] call KPLIB_fnc_addObjectInit;

    _plane addMPEventHandler ["MPKilled", {
        params ["_unit", "_killer"];
        ["KPLIB_manageKills", [_unit, _killer]] call CBA_fnc_localEvent;
    }];
    {
        _x addMPEventHandler ["MPKilled", {
            params ["_unit", "_killer"];
            ["KPLIB_manageKills", [_unit,_killer]] call CBA_fnc_localEvent;
        }];
    } forEach (crew _plane);

    (crew _plane) joinSilent _grp;
    sleep 5;
};

{ deleteWaypoint _x } forEachReversed waypoints _grp;
sleep 1;
{_x doFollow leader _grp} forEach (units _grp);
sleep 1;

private _waypoint = _grp addWaypoint [_first_objective, 500];
_waypoint setWaypointType "MOVE";
_waypoint setWaypointSpeed "FULL";
_waypoint setWaypointBehaviour "AWARE";
_waypoint setWaypointCombatMode "RED";

_waypoint = _grp addWaypoint [_first_objective, 500];
_waypoint setWaypointType "MOVE";
_waypoint setWaypointSpeed "FULL";
_waypoint setWaypointBehaviour "AWARE";
_waypoint setWaypointCombatMode "RED";

_waypoint = _grp addWaypoint [_first_objective, 500];
_waypoint setWaypointType "MOVE";
_waypoint setWaypointSpeed "FULL";
_waypoint setWaypointBehaviour "AWARE";
_waypoint setWaypointCombatMode "RED";

for "_i" from 1 to 6 do {
    _waypoint = _grp addWaypoint [_first_objective, 500];
    _waypoint setWaypointType "SAD";
};

_waypoint = _grp addWaypoint [_first_objective, 500];
_waypoint setWaypointType "CYCLE";

_grp setCurrentWaypoint [_grp, 2];
