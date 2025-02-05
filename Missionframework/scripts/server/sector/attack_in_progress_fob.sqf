params [ "_thispos" ];
private [ "_attacktime", "_ownership", "_grp" ];

sleep 5;

_ownership = [ _thispos ] call KPLIB_fnc_getSectorOwnership;
if ( _ownership != KPLIB_side_enemy ) exitWith {};

if ( KPLIB_param_bluforDefenders ) then {
    _grp = creategroup [KPLIB_side_player, true];
    {
        [_x, _thispos, _grp] call KPLIB_fnc_createManagedUnit;
    } foreach KPLIB_b_squadInf;
    sleep 3;
    _grp setBehaviour "COMBAT";
};

sleep 60;

private _fobMarker = createMarker ["KPLIB_fobUnderAttack", _thispos];
KPLIB_sectorsUnderAttack pushBack _fobMarker;
KPLIB_sectorsUnderAttack pushBack _thispos;
publicVariable "KPLIB_sectorsUnderAttack";

_ownership = [ _thispos ] call KPLIB_fnc_getSectorOwnership;
if ( _ownership == KPLIB_side_player ) exitWith {
    if ( KPLIB_param_bluforDefenders ) then {
        {
            if ( alive _x ) then { deleteVehicle _x };
        } foreach units _grp;
    };
};

[_thispos, 1] remoteExec ["remote_call_fob"];
_attacktime = KPLIB_vulnerability_timer;

sleep 0.5;

[_fobMarker] remoteExec ["reinforcements_remote_call",2];

while { _attacktime > 0 && ( _ownership == KPLIB_side_enemy || _ownership == KPLIB_side_resistance ) } do {
    _ownership = [ _thispos ] call KPLIB_fnc_getSectorOwnership;
    _blufor_count = (([_thispos, KPLIB_range_sectorCapture, KPLIB_side_player] call KPLIB_fnc_getUnitsCount));
    if (_blufor_count == 0) then {
        [_thispos, 5] remoteExec ["remote_call_fob"];
        _attacktime = _attacktime - 1;
    } else {
        [_thispos, 4] remoteExec ["remote_call_fob"];
    };
    sleep 1;
};

waitUntil {
    sleep 1;
    [ _thispos ] call KPLIB_fnc_getSectorOwnership != KPLIB_side_resistance;
};

if ( KPLIB_endgame == 0 ) then {
    if ( _attacktime <= 1 && ( [ _thispos ] call KPLIB_fnc_getSectorOwnership == KPLIB_side_enemy ) ) then {
        [_thispos, 2] remoteExec ["remote_call_fob"];
        sleep 3;
        KPLIB_sectors_fob = KPLIB_sectors_fob - [_thispos];
        publicVariable "KPLIB_sectors_fob";
        ["KPLIB_ResetBattleGroups"] call CBA_fnc_serverEvent;
        [_thispos] call KPLIB_fnc_destroyFob;
        [] spawn KPLIB_fnc_doSave;
        stats_fobs_lost = stats_fobs_lost + 1;
    } else {
        [_thispos, 3] remoteExec ["remote_call_fob"];
        {
            if (captive _x) then {
                [_x, true] spawn prisonner_ai;
            } else {
                [_x] spawn prisonner_ai;
            };
        } foreach ((_thispos nearEntities ["CAManBase", KPLIB_range_sectorCapture * 0.8]) select {side group _x == KPLIB_side_enemy});
    };
};

KPLIB_sectorsUnderAttack = KPLIB_sectorsUnderAttack - [_thispos] - [_fobMarker];
publicVariable "KPLIB_sectorsUnderAttack";
deleteMarker _fobMarker;

sleep 60;

if ( KPLIB_param_bluforDefenders ) then {
    {
        if ( alive _x ) then { if (isNull objectParent _x) then {deleteVehicle _x} else {(objectParent _x) deleteVehicleCrew _x}; };
    } foreach units _grp;
};
