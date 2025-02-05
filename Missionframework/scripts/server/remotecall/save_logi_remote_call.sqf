if (!isServer) exitWith {};

params ["_index", "_dest_a", "_ress_a", "_dest_b", "_ress_b", "_clientID"];

logiError = 0;

if ((_ress_a isEqualTo [0,0,0]) && (_ress_b isEqualTo [0,0,0])) then {
    _ress_a = [9999999999,9999999999,9999999999];
};

if (
    (((_ress_a select 0) != 0) && ((_ress_b select 0) != 0))
    || (((_ress_a select 1) != 0) && ((_ress_b select 1) != 0))
    || (((_ress_a select 2) != 0) && ((_ress_b select 2) != 0))
) then {
    logiError = 1;
};

if (_dest_a isEqualTo _dest_b) then {
    logiError = 1;
};

{
    if (
        ((((_x select 2) isEqualTo _dest_a)) || (((_x select 2) isEqualTo _dest_b)))
        && ((((_x select 3) isEqualTo _dest_a)) || (((_x select 3) isEqualTo _dest_b)))
    ) exitWith {logiError = 1;}
} forEach KPLIB_logistics;

if (logiError == 1) exitWith {(localize "STR_LOGISTIC_SAVE_ERROR") remoteExec ["hint",_clientID]; _clientID publicVariableClient "logiError";};

private _time = ceil (((ceil ((_ress_a select 0) / 100)) + (ceil ((_ress_a select 1) / 100)) + (ceil ((_ress_a select 2) / 100))) / 3);

if (_time > ((KPLIB_logistics select _index) select 1)) then {
    _time = ((KPLIB_logistics select _index) select 1);
};

_time = _time + 1;

KPLIB_logistics set [_index,[
    (KPLIB_logistics select _index) select 0,
    (KPLIB_logistics select _index) select 1,
    _dest_a,
    _dest_b,
    _ress_a,
    _ress_b,
    (KPLIB_logistics select _index) select 6,
    1,
    _time,
    0
]];
