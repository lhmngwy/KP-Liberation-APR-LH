if (!isServer) exitWith {};

private _grp = _this select 0;
private _patrol_startpos = getpos (leader _grp);
private _waypoint = [];
if ( isNil "reinforcements_sector_under_attack" ) then { reinforcements_sector_under_attack = "" };

while { count (units _grp) > 0 } do {

    if ( reinforcements_sector_under_attack != "" ) then {

        { deleteWaypoint _x } forEachReversed waypoints _grp;
        {doStop _x; _x doFollow leader _grp} foreach units _grp;

        _vehicle = objectParent (leader _grp);
        if (!(isNull _vehicle) && ((typeOf _vehicle) in KPLIB_o_troopTransports)) then {
            [_vehicle, markerpos reinforcements_sector_under_attack, _patrol_startpos] spawn troop_transport;
        } else {
            [_grp, markerpos reinforcements_sector_under_attack] call battlegroup_ai;
        };

        sleep 300;

    } else {
    
        private _sectors_patrol = [];
        {
            if ( _patrol_startpos distance (markerpos _x) < 2500) then {
                _sectors_patrol pushBack _x;
            };
        } foreach (KPLIB_sectors_all - KPLIB_sectors_player);
        _sectors_patrol = _sectors_patrol call BIS_fnc_arrayShuffle;

        { deleteWaypoint _x } forEachReversed waypoints _grp;
        {doStop _x; _x doFollow leader _grp} foreach units _grp;

        {
            if ((leader _grp) isEqualTo (vehicle leader _grp) || (vehicle leader _grp) isKindOf "Helicopter") then {
                _waypoint = _grp addWaypoint [markerpos _x, 300];
            } else {
                private _nearestroad = [(markerPos _x) getPos [random(100), random(360)], 200, []] call BIS_fnc_nearestRoad;
                if ( isNull _nearestroad ) then {_waypoint = _grp addWaypoint [markerpos _x, 300];} else {_waypoint = _grp addWaypoint [getpos _nearestroad, 0];};
            };
            _waypoint setWaypointType "MOVE";
            _waypoint setWaypointSpeed "NORMAL";
            _waypoint setWaypointBehaviour "SAFE";
            _waypoint setWaypointCombatMode "YELLOW";
            _waypoint setWaypointCompletionRadius 30;
        } foreach _sectors_patrol;

        if ((leader _grp) isEqualTo (vehicle leader _grp) || (vehicle leader _grp) isKindOf "Helicopter") then {
            _waypoint = _grp addWaypoint [_patrol_startpos, 300];
        } else {
            private _nearestroad = [_patrol_startpos getPos [random(100), random(360)], 200, []] call BIS_fnc_nearestRoad;
            if ( isNull _nearestroad ) then {_waypoint = _grp addWaypoint [_patrol_startpos, 300];} else {_waypoint = _grp addWaypoint [getpos _nearestroad, 0];};
        };
        _waypoint setWaypointType "MOVE";
        _waypoint setWaypointCompletionRadius 100;
        private _waypointfinalpos = waypointPosition _waypoint;
        _waypoint = _grp addWaypoint [_waypointfinalpos, 5];
        _waypoint setWaypointType "CYCLE";
    };

    waitUntil { sleep 5; (count (units _grp) == 0) || (reinforcements_sector_under_attack != "") };
};
