/*
    File: fn_cleanOpforVehicle.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 2019-11-25
    Last Update: 2023-03-07
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Deletes given vehicle, if not an opfor vehicle captured by players.

    Parameter(s):
        _veh - Vehicle to delete if not captured [OBJECT, defaults to objNull]

    Returns:
        Function reached the end [BOOL]
*/

params [
    ["_veh", objNull, [objNull]]
];

if (isNull _veh) exitWith {["Null object given"] call BIS_fnc_error; false};

sleep 0.1;

if !(_veh getVariable ["KPLIB_captured", false]) then {
    deleteVehicleCrew _veh;
    deleteVehicle _veh;
};

true
