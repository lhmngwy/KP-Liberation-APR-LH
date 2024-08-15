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
            if ((random KPLIB_enemyReadiness) > (20 + (30 / KPLIB_param_aggressivity))) then {
                sleep 10;
                _spawnPoint = ([KPLIB_sectors_airSpawn, [markerpos _targetsector], {(markerPos _x) distance _input0}, "ASCEND"] call BIS_fnc_sortBy) select 0;
                [markerpos _spawnPoint, markerpos _targetsector] spawn send_paratroopers;
            };
            stats_reinforcements_called = stats_reinforcements_called + 1;
        };
    };
};
