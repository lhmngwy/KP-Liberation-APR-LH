/*
    File: fn_getMobileRespawnName.sqf
    Author: doxus
    Date: 2024-04-23
    Last Update: 2024-04-23
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Gets NATO military name of the given respawn vehicle (assigned per idx)

    Parameter(s):
        _msp - mobile respawn vehicle object reference (defaults to nil)

    Returns:
        Mobile respawn name
*/

private _tents = [];

params [
    ["_msp", nil],
    ["_getSector", false]
];

private _respawn_vehicles = [] call KPLIB_fnc_getMobileRespawns;
private _name = "VEHICLE_NOT_FOUND";

if (!isNil "_msp") then {
    private _vehicle_idx = _respawn_vehicles find _msp;
    if (_vehicle_idx != -1 && _vehicle_idx < count KPLIB_militaryAlphabet) then {
        _alpha = KPLIB_militaryAlphabet select _vehicle_idx;
        _name = _alpha;
        _nearestSectorName = "";
        if (_getSector) then {
            _nearestSectorName = markerText ([2000, getPosATL _msp] call KPLIB_fnc_getNearestSector);
            if (_nearestSectorName == "") then {
                _nearestSectorName = mapGridPosition _msp;
            };
            _name = [_alpha, _nearestSectorName] joinString " - ";
        };
    };
};
_name
