/*
    File: fn_getAdaptiveVehicle.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 2019-11-25
    Last Update: 2020-05-23
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Provides a vehicle classname depending on the combat readiness.

    Parameter(s):
        _type        - defense or patrol

    Returns:
        Vehicle classname [STRING]
*/

params [
    ["_type", "", [""]]
];

private _vehicle_class = selectRandom ([KPLIB_o_armyVehicles, KPLIB_o_armyVehiclesLight] select (KPLIB_enemyReadiness < 40));

if (_type == "defense") then {
    while {_vehicle_class in KPLIB_o_troopTransports} do {
        _vehicle_class = [] call KPLIB_fnc_getAdaptiveVehicle;
    };
};

if (_type == "patrol") then {
    while {_vehicle_class in KPLIB_param_supportModule_artyVeh || _vehicle_class in aa_vehicles} do {
        _vehicle_class = [] call KPLIB_fnc_getAdaptiveVehicle;
    };
};

_vehicle_class