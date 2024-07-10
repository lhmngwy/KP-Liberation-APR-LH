params ["_unit"];

if(!isServer) exitWith {};

_nearFOB = [] call KPLIB_fnc_getNearestFob;
if(count _nearFOB == 0) exitWith {};

_unitsBought = _unit getVariable ["KPLIB_unitsBought", 1];

_playerCount = count (call BIS_fnc_listPlayers);
if (_playerCount <= 1) then {
    _playerCount = 2;
};

_price = 100 / _playerCount / _unitsBought;
if (_price < 1) then {
    _price = 1;
};

_storage_areas = (_nearFOB nearobjects (KPLIB_range_fob * 2)) select {(_x getVariable ["KPLIB_storage_type",-1]) == 0};
[_price, _price, _price, "", 0, _storage_areas] remoteExec ["build_remote_call",2];

_unit setVariable ["KPLIB_unitsBought", 1, true];
