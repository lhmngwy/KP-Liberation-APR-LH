private _grp = _this select 0;
private _basepos = getpos (leader _grp);

{ deleteWaypoint _x } forEachReversed waypoints _grp;
{_x doFollow leader _grp} foreach units _grp;

private _houses = _basePos nearObjects ["House", 125];
private _wpPositions = [
        _basepos getPos [random 125, random 360],
        _basepos getPos [random 125, random 360],
        _basepos getPos [random 125, random 360],
        _basepos getPos [random 125, random 360],
        _basepos getPos [random 125, random 360]
];
_houses = _houses call BIS_fnc_arrayShuffle;
{
    if !(alive _x) then {continue};
    if (count (_x buildingPos -1) > 0) then {
	    _wpPositions pushBack (AGLtoASL (selectRandom (_x buildingPos -1)));
    };
    if (count _wpPositions == 10) then { break; };
} forEach _houses;
_wpPositions = _wpPositions call BIS_fnc_arrayShuffle;

private _waypoint = _grp addWaypoint [_wpPositions select 0, -1];
_waypoint setWaypointType "MOVE";
_waypoint setWaypointBehaviour "SAFE";
_waypoint setWaypointSpeed "LIMITED";
_waypoint setWaypointCombatMode "BLUE";
_waypoint setWaypointCompletionRadius 1;
if (_waypoint in _houses) then {
    _waypoint setWaypointTimeout [15, 30, 60];
} else {
    _waypoint setWaypointTimeout [5, 10, 20];
};

_waypoint = _grp addWaypoint [_wpPositions select 1, -1];
_waypoint setWaypointType "MOVE";
_waypoint setWaypointBehaviour "SAFE";
_waypoint setWaypointSpeed "LIMITED";
_waypoint setWaypointCombatMode "BLUE";
_waypoint setWaypointCompletionRadius 1;
if (_waypoint in _houses) then {
    _waypoint setWaypointTimeout [15, 30, 60];
} else {
    _waypoint setWaypointTimeout [5, 10, 20];
};

_waypoint = _grp addWaypoint [_wpPositions select 2, -1];
_waypoint setWaypointType "MOVE";
_waypoint setWaypointBehaviour "SAFE";
_waypoint setWaypointSpeed "LIMITED";
_waypoint setWaypointCombatMode "BLUE";
_waypoint setWaypointCompletionRadius 1;
if (_waypoint in _houses) then {
    _waypoint setWaypointTimeout [15, 30, 60];
} else {
    _waypoint setWaypointTimeout [5, 10, 20];
};

_waypoint = _grp addWaypoint [_wpPositions select 3, -1];
_waypoint setWaypointType "MOVE";
_waypoint setWaypointBehaviour "SAFE";
_waypoint setWaypointSpeed "LIMITED";
_waypoint setWaypointCombatMode "BLUE";
_waypoint setWaypointCompletionRadius 1;
if (_waypoint in _houses) then {
    _waypoint setWaypointTimeout [15, 30, 60];
} else {
    _waypoint setWaypointTimeout [5, 10, 20];
};

_waypoint = _grp addWaypoint [_wpPositions select 4, -1];
_waypoint setWaypointType "CYCLE";
_waypoint setWaypointBehaviour "SAFE";
_waypoint setWaypointSpeed "LIMITED";
_waypoint setWaypointCombatMode "BLUE";
_waypoint setWaypointCompletionRadius 1;
if (_waypoint in _houses) then {
    _waypoint setWaypointTimeout [15, 30, 60];
} else {
    _waypoint setWaypointTimeout [5, 10, 20];
};

while { count units _grp > 0 } do {
    {
        _nearcars = (_x nearentities [["car","tank"],8]) select {simulationenabled _x};
        if (count _nearcars > 0) then
        {
            _x domove (position nearestbuilding _x);
        };
    } forEach units _grp;
    sleep random 5;
};