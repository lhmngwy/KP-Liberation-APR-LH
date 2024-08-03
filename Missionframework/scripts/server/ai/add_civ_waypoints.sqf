private _grp = _this select 0;
private _basepos = getpos (leader _grp);

fn_setWaypoints = {
    { deleteWaypoint _x } forEachReversed waypoints _grp;
    {_x doFollow leader _grp} foreach units _grp;

    _wpPositions = [];
    for "_i" from 1 to 5 do {
        _position = _basepos getPos [random 125, random 360];
        while {surfaceIsWater _position} do {
            _position = _basepos getPos [random 125, random 360];
        };
        _wpPositions pushBack (_basepos getPos [random 125, random 360]);
    };

    _minus = nearestObjects [_basePos, ["PowerLines_Wires_base_F","Lamps_base_F","Piers_base_F","Land_NavigLight"], 125];
    _houses = (_basePos nearObjects ["House", 125]) - _minus;
    _houses = _houses call BIS_fnc_arrayShuffle;
    {
        if !(alive _x) then {continue};
        if (count (_x buildingPos -1) > 0) then {
            _wpPositions pushBack (AGLtoASL (selectRandom (_x buildingPos -1)));
        };
        if (count _wpPositions == 10) then { break; };
    } forEach _houses;
    _wpPositions = _wpPositions call BIS_fnc_arrayShuffle;

    _waypoint = _grp addWaypoint [_wpPositions select 0, -1];
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
};

[] call fn_setWaypoints;

_sunriseTime = date call BIS_fnc_sunriseSunsetTime select 0;
_sunsetTime = date call BIS_fnc_sunriseSunsetTime select 1;
_atHome = false;
while { ({alive _x} count units _grp) > 0 } do {
    {
        _raining = rain > 0.2;
        _night = dayTime > _sunsetTime || dayTime < _sunriseTime;

        if (_atHome) then {
            if (!(_raining || _night) && (count waypoints _grp == 1)) then {
                [] call fn_setWaypoints;
                _atHome = false;
            };
        } else {
            if (_raining || _night) then {
                _minus = nearestObjects [_x,["PowerLines_Wires_base_F","Lamps_base_F","Piers_base_F","Land_NavigLight"], 125];
                _houses = (_x nearObjects ["House", 125]) - _minus;
                _houses = _houses call BIS_fnc_arrayShuffle;
                {
                    if (count (_x buildingPos -1) > 0) then {
                        { deleteWaypoint _x } forEachReversed waypoints _grp;
                        _waypoint = _grp addWaypoint [AGLtoASL (selectRandom (_x buildingPos -1)), -1];
                        _waypoint setWaypointType "MOVE";
                        _waypoint setWaypointBehaviour "SAFE";
                        _waypoint setWaypointSpeed "LIMITED";
                        _waypoint setWaypointCombatMode "BLUE";
                        _waypoint setWaypointCompletionRadius 1;
                        _atHome = true;
                        break;
                    };
                } forEach _houses;
            };
        };
    } forEach units _grp;
    sleep 60 + random 60;
};