/*
    File: fn_spawnVehicle.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 2019-12-03
    Last Update: 2023-11-14
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Spawns a vehicle with all needed Liberation connections/dependencies.

    Parameter(s):
        _pos        - Position to spawn the vehicle                                         [POSITION, defaults to [0, 0, 0]]
        _classname  - Classname of the vehicle to spawn                                     [STRING, defaults to ""]
        _precise    - Selector if the vehicle should spawned precisely on given position    [BOOL, defaults to false]
        _rndDir     - Selector if the direction should be randomized                        [BOOL, defaults to true]

    Returns:
        Spawned vehicle [OBJECT]
*/

params [
    ["_pos", [0, 0, 0], [[]], [2, 3]],
    ["_classname", "", [""]],
    ["_precise", false, [false]],
    ["_rndDir", true, [false]],
    ["_range", 150, [0]]
];

if (_pos isEqualTo [0, 0, 0]) exitWith {["No or zero pos given"] call BIS_fnc_error; objNull};
if (_classname isEqualTo "") exitWith {["Empty string given"] call BIS_fnc_error; objNull};

private _newvehicle = objNull;
private _spawnpos = [];

if (_precise) then {
    // Directly use given pos, if precise placement is true
    _spawnpos = _pos;
} else {
    // Otherwise find a suitable position for vehicle spawning near given pos
    private _i = 0;
    while {_spawnPos isEqualTo []} do {
        _i = _i + 1;
        _spawnpos = (_pos getPos [random _range, random 360]) findEmptyPosition [10, 100, _classname];
        if (_i isEqualTo 20) exitWith {_spawnPos = []};
    };
};

if (_spawnPos isEqualTo []) exitWith {
    ["No suitable spawn position found."] call BIS_fnc_error;
    [format ["Couldn't find spawn position for %1 around position %2", _classname, _pos], "WARNING"] call KPLIB_fnc_log;
    objNull
};

// If it's a chopper, spawn it flying
if (_classname in KPLIB_o_helicopters) then {
    _newvehicle = createVehicle [_classname, _spawnpos, [], 0, 'FLY'];
    _newvehicle flyInHeight (100 + (random 120));
    _newvehicle allowDamage false;
} else {
    _newvehicle = _classname createVehicle _spawnpos;
    _newvehicle allowDamage false;

    [_newvehicle] call KPLIB_fnc_allowCrewInImmobile;

    // Randomize direction and reset position and vector
    if (_rndDir) then {
        _newvehicle setDir (random 360);
    };
    _newvehicle setPos _spawnpos;
    _newvehicle setVectorUp surfaceNormal position _newvehicle;
};

_newVehicle lock true;
// Clear cargo, if enabled
[_newvehicle] call KPLIB_fnc_clearCargo;
_newvehicle addItemCargoGlobal ["toolkit", 1];
// Process KP object init
[_newvehicle] call KPLIB_fnc_addObjectInit;

// Spawn crew of vehicle
if (_classname in KPLIB_o_militiaVehicles) then {
    [_newvehicle] call KPLIB_fnc_spawnMilitiaCrew;
} else {
    private _grp = createGroup [KPLIB_side_enemy, true];
    private _crew = units (createVehicleCrew _newvehicle);
    _crew joinSilent _grp;
    {
        _x addMPEventHandler ["MPKilled", {
            params ["_unit", "_killer"];
            ["KPLIB_manageKills", [_unit, _killer]] call CBA_fnc_localEvent;
        }];
    } forEach _crew;
};

// Spawn troop cargo if transport
if (_classname in KPLIB_o_troopTransports) then {
    _newvehicle setUnloadInCombat [true, false];
    _infGrp = createGroup [KPLIB_side_enemy, true];
    _seats = count fullCrew [_newvehicle, "cargo", true];
    _spawned = 0;
    {
        [_x, _spawnPos, _infGrp, "PRIVATE", 0.5] call KPLIB_fnc_createManagedUnit;
        _spawned = _spawned + 1;
        if (_spawned == _seats) then { break; };
    } foreach (([] call KPLIB_fnc_getSquadComp) + ([KPLIB_o_rifleman, KPLIB_o_rifleman, KPLIB_o_rifleman, KPLIB_o_rifleman, KPLIB_o_rifleman]));

    {_x assignAsCargo _newvehicle; sleep 0.1; _x moveInCargo _newvehicle; sleep 0.1;} forEach (units _infGrp);

    // Delete crew that isn't in the vehicle
    {
        if (isNull objectParent _x) then {deleteVehicle _x};
    } forEach (units _infGrp);
};

// Add Killed and GetIn EHs and enable damage again
_newvehicle addMPEventHandler ["MPKilled", {
    params ["_unit", "_killer"];
    ["KPLIB_manageKills", [_unit, _killer]] call CBA_fnc_localEvent;
}];
sleep 0.1;
_newvehicle allowDamage true;
_newvehicle setDamage 0;
_newVehicle lock false;

_newVehicle remoteExec ["AIDC_fnc_init"];

_newvehicle
