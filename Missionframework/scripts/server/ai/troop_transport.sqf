params [
    ["_transVeh", objNull, [objNull]],
    ["_start_pos", [0, 0, 0], [[]], [3]],
    ["_objective", [0, 0, 0], [[]], [3]]
];

if (isNull _transVeh) exitWith {};
sleep 1;

private _transGrp = (group (driver _transVeh));
private _unload_distance = KPLIB_range_sectorCapture + random KPLIB_range_sectorCapture;

if ((_start_pos select 0) == 0 && (_start_pos select 1) == 0 && (_start_pos select 2) == 0) then {
    _start_pos = getpos _transVeh;
};
if ((_objective select 0) == 0 && (_objective select 1) == 0 && (_objective select 2) == 0) then {
    _objective = [getpos _transVeh] call KPLIB_fnc_getNearestBluforObjective;
};

{ deleteWaypoint _x } forEachReversed waypoints _transGrp;

// Move to objective
private _transVehWp = _transGrp addWaypoint [_objective, 0,0];
_transVehWp setWaypointType "TR UNLOAD";
_transVehWp setWaypointCompletionRadius _unload_distance;

private _infCargo = fullCrew [_transVeh, "cargo"];
private _infGrp = group ((_infCargo select 0) select 0);

// Wait until at objective, dead or empty
waitUntil {
    sleep 0.2;
    !(alive _transVeh) ||
    !(alive (driver _transVeh)) ||
    (count (fullCrew [_transVeh, "cargo"]) == 0) ||
    (((_transVeh distance _objective) < _unload_distance) && !(surfaceIsWater (getpos _transVeh)))
};

sleep 1;

if ((alive _transVeh)) then {
    // Troops get out
    if !(count _infCargo == 0) then {
        _infWp = _infGrp addWaypoint [getpos _transVeh, 0];
        _infWp setWaypointType "GETOUT";
        _infWp setWaypointCompletionRadius 20;

        _infWp synchronizeWaypoint [_transVehWp];

        {unassignVehicle _transVeh} forEach (units _infGrp);
        _infGrp leaveVehicle _transVeh;
        (units _infGrp) allowGetIn false;

        _infWp = _infGrp addWaypoint [_objective, 100];
        _infWp setWaypointType "MOVE";
        _infWp setWaypointSpeed "NORMAL";
        _infWp setWaypointBehaviour "AWARE";
        _infWp setWaypointCombatMode "YELLOW";
        _infWp setWaypointCompletionRadius 30;

        _infWp = _infGrp addWaypoint [_objective, 100];
        _infWp setWaypointType "SAD";
        _infWp = _infGrp addWaypoint [_objective, 100];
        _infWp setWaypointType "SAD";
        _infWp = _infGrp addWaypoint [_objective, 100];
        _infWp setWaypointType "SAD";
        _infWp = _infGrp addWaypoint [_objective, 100];
        _infWp setWaypointType "CYCLE";

        _infGrp setVariable ["KPLIB_isBattleGroup", true];
    };

    if (alive (driver _transVeh)) then {
        // After troops get out
        waitUntil {sleep 0.5; count fullCrew [_transVeh, "cargo"] == 0};

        { deleteWaypoint _x } forEachReversed waypoints _transGrp;

        sleep 5;

        // If vehicle has gunner, search and destroy, else go home and delete vehicle
        if !(isNull gunner _transVeh) then {
            _transVehWp = _transGrp addWaypoint [_objective, 100];
            _transVehWp setWaypointType "MOVE";
            _transVehWp setWaypointSpeed "NORMAL";
            _transVehWp setWaypointBehaviour "AWARE";
            _transVehWp setWaypointCombatMode "YELLOW";
            _transVehWp setWaypointCompletionRadius 50;

            _transVehWp = _transGrp addWaypoint [_objective, 100];
            _transVehWp setWaypointType "SAD";
            _transVehWp = _transGrp addWaypoint [_objective, 100];
            _transVehWp setWaypointType "SAD";
            _transVehWp = _transGrp addWaypoint [_objective, 100];
            _transVehWp setWaypointType "SAD";
            _transVehWp = _transGrp addWaypoint [_objective, 100];
            _transVehWp setWaypointType "CYCLE";
        } else {
            _transVehWp = _transGrp addWaypoint [_start_pos, 100];
            _transVehWp setWaypointType "MOVE";
            _transVehWp setWaypointStatements ["true", "{ this deleteVehicleCrew _x } forEach crew this; deleteVehicle this;"];
        };
    };
};
