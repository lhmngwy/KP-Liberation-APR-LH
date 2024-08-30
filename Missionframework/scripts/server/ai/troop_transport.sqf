params [
    ["_transVeh", objNull, [objNull]],
    ["_objective", [0, 0, 0], [[]], [3]],
    ["_start_pos", [0, 0, 0], [[]], [3]]
];

if (isNull _transVeh) exitWith {};
sleep 1;

private _transGrp = (group (driver _transVeh));
private _unload_distance = KPLIB_range_sectorCapture + random KPLIB_range_sectorCapture;

if ((_objective select 0) == 0 && (_objective select 1) == 0 && (_objective select 2) == 0) then {
    _objective = [getpos _transVeh] call KPLIB_fnc_getNearestBluforObjective;
};
if ((_start_pos select 0) == 0 && (_start_pos select 1) == 0 && (_start_pos select 2) == 0) then {
    _start_pos = getpos _transVeh;
};

private _helipad = objNull;
private _target = _objective;
if (_transVeh isKindOf "Air") then {
    _transVeh flyInHeight [100 + random 40, true];
    _helipad_pos = [];
    private _i = 0;
    while {_helipad_pos isEqualTo []} do {
        _i = _i + 1;
        _helipad_pos = (_objective getPos [_unload_distance, 360]) findEmptyPosition [10, 100, typeOf _transVeh];
        if (_i isEqualTo 10) exitWith {};
    };
    _helipad = "Land_HelipadEmpty_F" createVehicle _helipad_pos;
    _target = _helipad_pos;
};

{ deleteWaypoint _x } forEachReversed waypoints _transGrp;

// Move to objective
private _transVehWp = _transGrp addWaypoint [_target, 0,0];
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
    (((_transVeh distance _target) < _unload_distance) && !(surfaceIsWater (getpos _transVeh)))
};

sleep 1;

if ((alive _transVeh)) then {
    // Troops get out
    if !(count _infCargo == 0) then {
        _infWp = _infGrp addWaypoint [_objective, 100];
        _infWp setWaypointType "GETOUT";
        _infWp setWaypointSpeed "NORMAL";
        _infWp setWaypointBehaviour "AWARE";
        _infWp setWaypointCombatMode "YELLOW";
        _infWp setWaypointCompletionRadius 30;

        _infWp synchronizeWaypoint [_transVehWp];

        {unassignVehicle _transVeh} forEach (units _infGrp);
        _infGrp leaveVehicle _transVeh;
        (units _infGrp) allowGetIn false;

        _infWp = _infGrp addWaypoint [_objective, 100];
        _infWp setWaypointType "SAD";
        _infWp setWaypointBehaviour "COMBAT";
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
        _magazines = magazinesAllTurrets [_transVeh, true];
        if ((count _magazines > 1 || ((count _magazines == 1) && {toLower ((_magazines select 0) select 0) find "cmflare" == -1}))
            && (typeOf _transVeh != "O_Heli_Light_02_F")) then {
            _radius = 100;
            if (_transVeh isKindOf "Air") then {
                _radius = 300;
            };
            _transVehWp = _transGrp addWaypoint [_objective, _radius];
            _transVehWp setWaypointType "SAD";
            _transVehWp setWaypointSpeed "NORMAL";
            _transVehWp setWaypointBehaviour "COMBAT";
            _transVehWp setWaypointCombatMode "RED";
            _transVehWp setWaypointCompletionRadius _radius;

            _transVehWp = _transGrp addWaypoint [_objective, _radius];
            _transVehWp setWaypointType "SAD";
            _transVehWp setWaypointBehaviour "COMBAT";
            _transVehWp setWaypointCombatMode "RED";
            _transVehWp = _transGrp addWaypoint [_objective, _radius];
            _transVehWp setWaypointType "SAD";
            _transVehWp = _transGrp addWaypoint [_objective, _radius];
            _transVehWp setWaypointType "SAD";
            _transVehWp = _transGrp addWaypoint [_objective, _radius];
            _transVehWp setWaypointType "CYCLE";

            _transGrp setVariable ["KPLIB_isBattleGroup", true];
        } else {
            _transVehWp = _transGrp addWaypoint [_start_pos, 100];
            _transVehWp setWaypointType "MOVE";
            _transVehWp setWaypointSpeed "FULL";
            _transVehWp setWaypointBehaviour "CARELESS";
            _transVehWp setWaypointCombatMode "BLUE";
            _transVehWp setWaypointCompletionRadius 100;

            _transVehWp = _transGrp addWaypoint [_start_pos, 100];
            _transVehWp setWaypointType "MOVE";

            _transVehWp = _transGrp addWaypoint [_start_pos, 100];
            _transVehWp setWaypointType "CYCLE";

            waitUntil {sleep 1;
                !(alive driver _transVeh) || (_transVeh distance2D _start_pos < 200)
            };

            if (!alive driver _transVeh) exitWith {};

            deleteVehicleCrew _transVeh;
            deleteVehicle _transVeh;
        };
    };
};

if !(isNull _helipad) then {
    deleteVehicle _helipad;
};