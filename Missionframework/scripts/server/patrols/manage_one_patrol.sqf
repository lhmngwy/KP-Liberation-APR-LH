scriptName "manage_one_patrol";

params [ "_minimum_readiness", "_is_infantry" ];
private [ "_headless_client", "_grp", "_squad"];

waitUntil { !isNil "KPLIB_sectors_player" };
waitUntil { !isNil "KPLIB_enemyReadiness" };

while { KPLIB_endgame == 0 } do {
    waitUntil { sleep 1; count KPLIB_sectors_player >= 3 };
    waitUntil { sleep 1; KPLIB_enemyReadiness >= (_minimum_readiness / KPLIB_param_difficulty) };

    sleep (random 30);

    while {  ([] call KPLIB_fnc_getOpforCap > KPLIB_cap_patrol) || (diag_fps < 30.0) } do {
            sleep (random 30);
    };

    _grp = grpNull;

    private _minSpawnRange = round (KPLIB_range_pointActivation * 1.5);
    private _maxSpawnRange = round (KPLIB_range_pointActivation * 4);

    _spawn_marker = "";
    _usable_sectors = [];
    while { _spawn_marker == "" } do {
        {
            if ((count ([markerPos _x, 1500] call KPLIB_fnc_getNearbyPlayers) == 0) && (count ([markerPos _x, 3500] call KPLIB_fnc_getNearbyPlayers) > 0)) then {
                _usable_sectors pushback _x;
            }

        } foreach (KPLIB_sectors_all - KPLIB_sectors_player);
        _spawn_marker = selectRandom _usable_sectors;
        if ( _spawn_marker == "" ) then {
            sleep (150 + (random 150));
        };
    };

    if (KPLIB_active_enemy_patrols < (count _usable_sectors)) then {
        KPLIB_active_enemy_patrols = KPLIB_active_enemy_patrols + 1;

        _sector_spawn_pos = [(((markerpos _spawn_marker) select 0) - 500) + (random 1000),(((markerpos _spawn_marker) select 1) - 500) + (random 1000),0];
        _vehicle_object = objNull;

        if (_is_infantry) then {

            private _minRange = round (KPLIB_range_pointActivation * 0.75);
            private _maxRange = round (KPLIB_range_pointActivation * 2.5);

            private _sectors_spawn = [];
            {
                if ((_sector_spawn_pos distance (markerpos _x) > _minRange) && (_sector_spawn_pos distance (markerpos _x) < _maxRange)) then {
                    _sectors_spawn pushBack _x;
                };
            } foreach (KPLIB_sectors_all - KPLIB_sectors_player);
            private _sector_spawn = selectRandom _sectors_spawn;
            if (!isNil "_sector_spawn") then {_sector_spawn_pos = markerPos _sector_spawn};

            _grp = createGroup [KPLIB_side_enemy, true];
            _squad = [] call KPLIB_fnc_getSquadComp;
            {
                [_x, _sector_spawn_pos, _grp, "PRIVATE", 0.5] call KPLIB_fnc_createManagedUnit;
            } foreach _squad;
        } else {

            if ((KPLIB_enemyReadiness > 75) && ((random 100) > 85) && !(KPLIB_o_helicopters isEqualTo [])) then {
                _vehicle_object = [_sector_spawn_pos, selectRandom KPLIB_o_helicopters] call KPLIB_fnc_spawnVehicle;
            } else {
                private _vehicle_class = ["patrol"] call KPLIB_fnc_getAdaptiveVehicle;
                _vehicle_object = [_sector_spawn_pos, _vehicle_class] call KPLIB_fnc_spawnVehicle;
            };

            sleep 0.5;
            private _crewmens = (crew _vehicle_object);
            // wait leader and he is alive in vehicle
            waitUntil {
                sleep 1;
                count _crewmens > 0
            };
            _grp = group (_crewmens select 0);
        };

        [_grp] remoteExec ["patrol_ai", 2];

        _patrol_continue = true;

        if ( local _grp ) then {
            _headless_client = [] call KPLIB_fnc_getLessLoadedHC;
            if ( !isNull _headless_client ) then {
                _grp setGroupOwner ( owner _headless_client );
            };
        };

        _vel = 12;
        while { _patrol_continue } do {
            sleep (15 + (random 15));
            if ( count (units _grp) == 0  ) then {
                _patrol_continue = false;
            } else {
                _stuck = false;
                if !(_is_infantry) then {
                    _vel = ((sqrt (((velocity _vehicle_object) select 0) ^ 2 + ((velocity _vehicle_object) select 1) ^ 2)) + _vel) / 2;
                    _stuck = ((_vel < 3) && (count ([getpos leader _grp, 1000] call KPLIB_fnc_getNearbyPlayers) == 0) && ((behaviour (leader group _vehicle_object)) != "COMBAT"));
                };
                if ( _stuck || ([ getpos (leader _grp) , 4000 , KPLIB_side_player ] call KPLIB_fnc_getUnitsCount == 0 ) ) then {
                    _patrol_continue = false;
                    {
                        if ( vehicle _x != _x ) then {
                            [(vehicle _x)] call KPLIB_fnc_cleanOpforVehicle;
                        };
                        deleteVehicle _x;
                    } foreach (units _grp);
                };
            };
        };

        KPLIB_active_enemy_patrols = KPLIB_active_enemy_patrols - 1;
    };

    if ( !([] call KPLIB_fnc_isCapitalActive) ) then {
        sleep (((random 300.0) + 300) / KPLIB_param_difficulty);
    };

};
