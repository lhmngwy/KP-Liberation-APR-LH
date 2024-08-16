params ["_targetsector"];

if (KPLIB_enemyReadiness > 15) then {

    private _init_units_count = (([markerPos _targetsector, KPLIB_range_sectorCapture, KPLIB_side_enemy] call KPLIB_fnc_getUnitsCount));

    private _reinforce_threshold = 0.75;
    if (_targetsector in KPLIB_sectors_capital) then {
        _reinforce_threshold = 0.85;
    };
    if (_targetsector in KPLIB_sectorsUnderAttack) then {
        _reinforce_threshold = 0.95;
    };
    while {(_init_units_count * _reinforce_threshold) <= ([markerPos _targetsector, KPLIB_range_sectorCapture, KPLIB_side_enemy] call KPLIB_fnc_getUnitsCount)} do {
        sleep 5;
    };

    private _nearestower = [markerpos _targetsector, KPLIB_side_enemy, KPLIB_range_radioTowerScan * 1.4] call KPLIB_fnc_getNearestTower;

    if !(isNil "_nearestower") then {
        private _reinforcements_time = (((((markerpos _nearestower) distance (markerpos _targetsector)) / 1000) ^ 1.66 ) * 120) / (KPLIB_param_difficulty * KPLIB_param_aggressivity);
        if (_targetsector in KPLIB_sectors_capital) then {
            _reinforcements_time = _reinforcements_time * 0.4;
        };
        if (_targetsector in KPLIB_sectorsUnderAttack) then {
            _reinforcements_time = _reinforcements_time * 0.2;
        };
        private _current_timer = time;

        waitUntil {sleep 1; (_current_timer + _reinforcements_time < time) || (_targetsector in KPLIB_sectors_player) || (_nearestower in KPLIB_sectors_player)};

        sleep 15;

        if ((_targetsector in KPLIB_sectorsUnderAttack) || (((_targetsector in KPLIB_sectors_active) && !(_targetsector in KPLIB_sectors_player) && !(_nearestower in KPLIB_sectors_player)))) then {
            reinforcements_sector_under_attack = _targetsector;
            reinforcements_set = true;
            ["lib_reinforcements",[markertext _targetsector]] remoteExec ["bis_fnc_shownotification"];
            _spawn_marker = [1000, 2200, false, [0,0,0]] call KPLIB_fnc_getOpforSpawnPoint;
            _vehicle_pool = [KPLIB_o_battleGrpVehicles, KPLIB_o_battleGrpVehiclesLight] select (KPLIB_enemyReadiness < 40);
            _plane_pilots = count (allPlayers select { (objectParent _x) isKindOf "Plane" && (driver vehicle _x) == _x });
            _heli_chances = ((floor linearConversion [0, 100, KPLIB_enemyReadiness, 1, 4]) max 1);
            _i = 0;
            while { i < _heli_chances } do {
                _vehicle_class = selectRandom _vehicle_pool;
                if ((_x in KPLIB_o_helicopters) && (_x in KPLIB_o_troopTransports) && (random (KPLIB_enemyReadiness max 40) > 25)) then {
                    [markerpos _spawn_marker, markertext _targetsector, _vehicle_class] spawn send_paratroopers;
                } else {
                    _newvehicle = [markerpos _spawn_marker, _vehicle_class] call KPLIB_fnc_spawnVehicle;

                    sleep 0.5;

                    _grp = group driver _vehicle;
                    if (_x in KPLIB_o_troopTransports) then {
                        [_newvehicle, markertext _targetsector] spawn troop_transport;
                    } else {
                        [_grp, markertext _targetsector] call battlegroup_ai;
                    };

                    sleep 0.5;
                };
                _i = _i + 1;
            };
            if ((KPLIB_param_aggressivity > 0.9) && ((random (KPLIB_enemyReadiness max 50) > 25) || (_plane_pilots > 0))) then {
                [markerpos _targetsector, _plane_pilots] spawn spawn_air;
            };
            stats_reinforcements_called = stats_reinforcements_called + 1;
        };
    };
};
