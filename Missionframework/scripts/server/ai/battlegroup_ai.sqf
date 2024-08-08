params [
    ["_grp", grpNull, [grpNull]],
    ["_objective", [0, 0, 0], [[]], [3]]
];

if (isNull _grp) exitWith {};

if (_objective == [0, 0, 0]) then {
    _objective = [getPos (leader _grp)] call KPLIB_fnc_getNearestBluforObjective;
};

[_objective] remoteExec ["remote_call_incoming"];

private _waypoint = [];
{ deleteWaypoint _x } forEachReversed waypoints _grp;
{_x doFollow leader _grp} forEach units _grp;

_waypoint = _grp addWaypoint [_objective, 100];
_waypoint setWaypointType "MOVE";
_waypoint setWaypointSpeed "NORMAL";
_waypoint setWaypointBehaviour "AWARE";
_waypoint setWaypointCombatMode "YELLOW";
_waypoint setWaypointCompletionRadius 30;

_waypoint = _grp addWaypoint [_objective, 100];
_waypoint setWaypointType "SAD";
_waypoint = _grp addWaypoint [_objective, 100];
_waypoint setWaypointType "SAD";
_waypoint = _grp addWaypoint [_objective, 100];
_waypoint setWaypointType "SAD";
_waypoint = _grp addWaypoint [_objective, 100];
_waypoint setWaypointType "CYCLE";
