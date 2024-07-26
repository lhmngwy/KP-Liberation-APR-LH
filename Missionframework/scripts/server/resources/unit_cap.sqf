scriptName "unit_cap";

unitcap = 0;
KPLIB_heli_count = 0;
KPLIB_plane_count = 0;

while {true} do {
    private _local_unitcap = 0;
    private _local_heli_count = 0;
    private _local_plane_count = 0;
    private _local_units = (units KPLIB_side_player) select {alive _x && !(captive _x) && ((_x distance startbase) > 250 || (isPlayer _x))};
    private _local_vehicles = (entities "AIR") select {alive _x && (toLowerANSI (typeOf _x)) in KPLIB_b_air_classes && !(_x getVariable ["KPLIB_preplaced", false])};
    {
        _class = typeOf _x;
        _isNotCaptured = false;
        if ((toLowerANSI _class) in KPLIB_o_allVeh_classes) then {
            _isCaptured = _x getVariable ["KPLIB_captured", false];
            if !(_isCaptured) then {_isNotCaptured = true;};
        };
        _isNotSeized = false;
        if (_class in KPLIB_c_vehicles) then {
            _isSeized = _x getVariable ["KPLIB_seized", false];
            if !(_isSeized) then {_isNotSeized = true;};
        };
        if (_isNotCaptured || _isNotSeized) then {_local_vehicles deleteAt _forEachIndex;};
    } forEachReversed _local_vehicles;
    {
        _local_unitcap = _local_unitcap + 1;
    } forEach _local_units;
    {
        if (!([typeOf _x] call KPLIB_fnc_isClassUAV)) then {
            if (_x isKindOf "Helicopter") then {
                _local_heli_count = _local_heli_count + 1;
                continue;
            };
            if (_x isKindOf "Plane") then {
                _local_plane_count = _local_plane_count + 1;
            };
        };
    } forEach _local_vehicles;
    unitcap = _local_unitcap;
    KPLIB_heli_count = _local_heli_count;
    KPLIB_plane_count = _local_plane_count;
    sleep 1;
};
