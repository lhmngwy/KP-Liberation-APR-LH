// TODO Refactor and create function
params [
    ["_spawn_marker", "", [""]],
    ["_infOnly", false, [false]],
    ["_objective", objNull, [objNull]]
];

if (KPLIB_endgame == 1) exitWith {};

_spawn_marker = [[1000, 800] select _infOnly, [2200, 1600] select _infOnly, false, markerPos _spawn_marker] call KPLIB_fnc_getOpforSpawnPoint;

if (isNull _objective) then {
    _objective = [markerPos _spawn_marker] call KPLIB_fnc_getNearestBluforObjective;
};

if !(_spawn_marker isEqualTo "") then {
    KPLIB_last_battlegroup_time = diag_tickTime;

    private _bg_groups = [];
    private _selected_opfor_battlegroup = [];
    private _target_size = (round (KPLIB_battlegroup_size * ([] call KPLIB_fnc_getOpforFactor) * (sqrt KPLIB_param_aggressivity))) min 16;
    if (KPLIB_enemyReadiness < 60) then {_target_size = round (_target_size * 0.65);};

    [_spawn_marker] remoteExec ["remote_call_battlegroup"];

    if (worldName in KPLIB_battlegroup_clearance) then {
        [markerPos _spawn_marker, 15] call KPLIB_fnc_createClearance;
    };

    if (_infOnly) then {
        // Infantry units to choose from
        private _infClasses = [KPLIB_o_inf_classes, KPLIB_o_militiaInfantry] select (KPLIB_enemyReadiness < 50);

        // Adjust target size for infantry
        _target_size = 12 max (_target_size * 4);
        private _squadNumber = round (_target_size/8);

        for "_i" from 1 to _squadNumber do {
            // Create infantry groups with up to 8 units per squad
            private _grp = createGroup [KPLIB_side_enemy, true];
            for "_i" from 0 to 7 do {
                [selectRandom _infClasses, markerPos _spawn_marker, _grp] call KPLIB_fnc_createManagedUnit;
            };
            [_grp] call KPLIB_fnc_LAMBS_enableReinforcements;
            [_grp] call battlegroup_ai;
            _grp setVariable ["KPLIB_isBattleGroup",true];
        };
    } else {
        private _vehicle_pool = [KPLIB_o_battleGrpVehicles, KPLIB_o_battleGrpVehiclesLight] select (KPLIB_enemyReadiness < 50);

        while {count _selected_opfor_battlegroup < _target_size} do {
            _selected_opfor_battlegroup pushback (selectRandom _vehicle_pool);
        };

        {
            if ((_x in KPLIB_o_helicopters) && (_x in KPLIB_o_troopTransports)) then {
                [_objective, _x] spawn send_paratroopers;
            } else {
                _vehicle = [markerpos _spawn_marker, _x] call KPLIB_fnc_spawnVehicle;

                sleep 0.5;

                _nextgrp = group driver _vehicle;
                _nextgrp setVariable ["KPLIB_isBattleGroup", true];
                _bg_groups pushback _nextgrp;

                if (_x in KPLIB_o_troopTransports) then {
                    [_vehicle] spawn troop_transport;
                } else {
                    [_nextgrp] call battlegroup_ai;
                };
            };
            sleep 20;
        } forEach _selected_opfor_battlegroup;

        if ((KPLIB_param_aggressivity > 0.9) && (random 2 > 0)) then {
            [_objective] spawn spawn_air;
        };
    };

    sleep 3;

    KPLIB_enemyReadiness = (KPLIB_enemyReadiness - (round ((count _bg_groups) + (random (count _bg_groups))))) max 0;
    stats_hostile_battlegroups = stats_hostile_battlegroups + 1;

    {
        if (local _x) then {
            _headless_client = [] call KPLIB_fnc_getLessLoadedHC;
            if (!isNull _headless_client) then {
                _x setGroupOwner (owner _headless_client);
            };
        };
        sleep 1;
    } forEach _bg_groups;
};
