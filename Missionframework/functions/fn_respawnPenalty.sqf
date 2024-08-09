params ["_unit"];

if(!isServer) exitWith {};

if (([getPosATL _unit, 350, KPLIB_side_enemy ] call KPLIB_fnc_getUnitsCount) < 4) exitWith {};

private _nearFOB = _unit getVariable ["KPLIB_fobPos", []];
if(count _nearFOB == 0) exitWith {};

private _unitsBought = _unit getVariable ["KPLIB_unitsBought", 0];
private _unitsSquad = count ((units group _unit) select {alive _x && !(_x getVariable ['PAR_isUnconscious', false]) && !(isPlayer _x)});

private _price = 40 / (_unitsBought - _unitsSquad + 1);
if (_price < 1) then {
    _price = 1;
};

private _storage_areas = (_nearFOB nearobjects (KPLIB_range_fob * 2)) select {(_x getVariable ["KPLIB_storage_type",-1]) == 0};
[_price, _price, _price, "", 0, _storage_areas] remoteExec ["build_remote_call",2];
