params ["_unit"];

if(!isServer) exitWith {};

if (([getPosATL player, 350, KPLIB_side_enemy ] call KPLIB_fnc_getUnitsCount) < 4) exitWith {};

_nearFOB = [getPos _unit] call KPLIB_fnc_getNearestFob;
if(count _nearFOB == 0) exitWith {};

_unitsBought = _unit getVariable ["KPLIB_unitsBought", 1];

_price = 30 / _unitsBought;
if (_price < 1) then {
    _price = 1;
};

_storage_areas = (_nearFOB nearobjects (KPLIB_range_fob * 2)) select {(_x getVariable ["KPLIB_storage_type",-1]) == 0};
[_price, _price, _price, "", 0, _storage_areas] remoteExec ["build_remote_call",2];
