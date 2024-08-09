scriptName "counter_battle_group";

if (isNil "infantry_weight") then {infantry_weight = 33;};
if (isNil "armor_weight") then {armor_weight = 33;};
if (isNil "air_weight") then {air_weight = 33;};

sleep 1800;
private _sleeptime = 0;
private _target_player = objNull;
private _target_pos = "";
while {KPLIB_param_aggressivity >= 0.9 && KPLIB_endgame == 0} do {
    _sleeptime = (1800 + (random 1800)) / (([] call KPLIB_fnc_getOpforFactor) * KPLIB_param_aggressivity);

    if (KPLIB_enemyReadiness >= 75) then {_sleeptime = _sleeptime * 0.75;};
    if (KPLIB_enemyReadiness >= 85) then {_sleeptime = _sleeptime * 0.75;};
    if (KPLIB_enemyReadiness >= 95) then {_sleeptime = _sleeptime * 0.75;};

    sleep _sleeptime;

    waitUntil {sleep 5;
        KPLIB_enemyReadiness >= 60 && {armor_weight >= 50 || air_weight >= 50}
        && {[] call KPLIB_fnc_getOpforCap < KPLIB_cap_battlegroup}
        && {diag_fps > 30.0}
    };

    _target_player = objNull;
    {
        if (
            (armor_weight >= 50 && {(objectParent _x) isKindOf "Tank"})
            || (air_weight >= 50 && {(objectParent _x) isKindOf "Air"})
        ) exitWith {
            _target_player = _x;
        };
    } forEach (allPlayers - entities "HeadlessClient_F");

    if (!isNull _target_player) then {
        _target_pos = [99999, getPos _target_player] call KPLIB_fnc_getNearestSector;
        if !(_target_pos isEqualTo "") then {
            ["", false, _target_pos, (air_weight >= 50 && {(objectParent _target_player) isKindOf "Air"})] spawn spawn_battlegroup;
        };
    };
};
