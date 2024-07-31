params [
    ["_transVeh", objNull, [objNull]],
    ["_start_pos", objNull, [objNull]],
    ["_objective", objNull, [objNull]]
];

if (isNull _transVeh) exitWith {};
sleep 1;

private _transGrp = (group (driver _transVeh));
private _unload_distance = random [KPLIB_range_sectorCapture, KPLIB_range_sectorCapture * 1.5, KPLIB_range_sectorCapture * 2];

if (isNull _start_pos) then {
    _start_pos = getpos _transVeh;
};
if (isNull _objective) then {
    _objective = [getpos _transVeh] call KPLIB_fnc_getNearestBluforObjective;
};

{ deleteWaypoint _x } forEachReversed waypoints _transGrp;

// Move to objective
private _transVehWp = _transGrp addWaypoint [_objective, 0,0];
_transVehWp setWaypointType "TR UNLOAD";
_transVehWp setWaypointCompletionRadius _unload_distance;

// Wait until at objective, dead or empty
waitUntil {
    sleep 0.2;
    !(alive _transVeh) ||
    !(alive (driver _transVeh)) ||
    (count (fullCrew [_transVeh, "cargo"]) == 0) ||
    (((_transVeh distance _objective) < _unload_distance) && !(surfaceIsWater (getpos _transVeh)))
};

private _infCargo = fullCrew [_transVeh, "cargo"];
private _infGrp = group ((_infCargo select 0) select 0);
[_infGrp, _objective] spawn battlegroup_ai;
_infGrp setVariable ["KPLIB_isBattleGroup", true];

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
    };

    if (alive (driver _transVeh)) then {
        // After troops get out
        waitUntil {sleep 0.5; count fullCrew [_transVeh, "cargo"] == 0};

        { deleteWaypoint _x } forEachReversed waypoints _transGrp;

        sleep 5;

        // If vehicle has gunner, search and destroy, else go home and delete vehicle
        if !(isNull gunner _transVeh) then {
            _transVehWp = _transGrp addWaypoint [_objective, 100];
            _transVehWp setWaypointType "SAD";
            _transVehWp setWaypointSpeed "NORMAL";
            _transVehWp setWaypointBehaviour "COMBAT";
            _transVehWp setWaypointCombatMode "RED";
            _transVehWp setWaypointCompletionRadius 30;

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
