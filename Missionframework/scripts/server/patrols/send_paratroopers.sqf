params [
    ["_targetSector", "", ["",[]]],
    ["_chopper_type", objNull, [objNull]]
];

if !(isServer) exitWith {};

if (_targetSector isEqualTo "" || KPLIB_o_helicopters isEqualTo []) exitWith {false};

private _targetPos = _targetSector;
if (_targetPos isEqualType "") then {
    _targetPos = markerPos _targetSector;
};

private _spawnMarker = ([KPLIB_sectors_airSpawn, [_targetPos], {(markerpos _x) distance _input0}, "ASCEND"] call BIS_fnc_sortBy) select 0;
private _spawnPos = markerPos _spawnMarker;

private _newVehicle = objNull;
private _pilot_group = grpNull;
    
if (isNull _chopper_type) then {
    _chopper_type = selectRandom KPLIB_o_helicopters;

    while {!(_chopper_type in KPLIB_o_troopTransports)} do {
        _chopper_type = selectRandom KPLIB_o_helicopters;
    };

    _newVehicle = createVehicle [_chopper_type, _spawnPos, [], 0, "FLY"];
    _pilot_group = createGroup [KPLIB_side_enemy, true];
    private _crew = units (createVehicleCrew _newVehicle);
    _crew joinSilent _pilot_group;
    _newVehicle addMPEventHandler ["MPKilled", {
        params ["_unit", "_killer"];
        ["KPLIB_manageKills", [_unit, _killer]] call CBA_fnc_localEvent;
    }];
    {
        _x addMPEventHandler ["MPKilled", {
            params ["_unit", "_killer"];
            ["KPLIB_manageKills", [_unit, _killer]] call CBA_fnc_localEvent;
        }];
    } forEach (crew _newVehicle);

    // Clear cargo, if enabled
    [_newVehicle] call KPLIB_fnc_clearCargo;
    _newVehicle addItemCargoGlobal ["toolkit", 1];
    // Process KP object init
    [_newVehicle] call KPLIB_fnc_addObjectInit;
} else {
    _newVehicle = _chopper_type;
    _pilot_group = group _newVehicle;
};

private _para_group = createGroup [KPLIB_side_enemy, true];

while {(count (units _para_group)) < 8} do {
    [KPLIB_o_paratrooper, _spawnPos, _para_group] call KPLIB_fnc_createManagedUnit;
};

_newVehicle lock true;

_pilot_group setVariable ["acex_headless_blacklist", true, true];
_para_group setVariable ["acex_headless_blacklist", true, true];

{deleteWaypoint _x} forEachReversed waypoints _pilot_group;
{deleteWaypoint _x} forEachReversed waypoints _para_group;

{removeBackpack _x; _x addBackPack "B_parachute"; _x moveInCargo _newVehicle;} forEach (units _para_group);

private _pilot = driver _newVehicle;
private _pilotSkill = skill _pilot;
_pilot allowFleeing 0;
_pilot setSkill 1;

_newVehicle flyInHeight [120, true];

private _pilot_wp_target = _pilot_group addWaypoint [_targetPos, 50];
_pilot_wp_target setWaypointType "MOVE";
_pilot_wp_target setWaypointSpeed "FULL";
_pilot_wp_target setWaypointBehaviour "CARELESS";
_pilot_wp_target setWaypointCombatMode "BLUE";
_pilot_wp_target setWaypointCompletionRadius 200;

private _offset_dir = vectorNormalized (_targetPos vectorFromTo _spawnPos);
private _offset_pos = _targetPos vectorAdd (_offset_dir vectorMultiply -500);
_offset_pos set [2,0];
private _pilot_wp_offset = _pilot_group addWaypoint [_offset_pos, 50];
_pilot_wp_offset setWaypointType "MOVE";
_pilot_wp_offset setWaypointSpeed "FULL";
_pilot_wp_offset setWaypointBehaviour "CARELESS";
_pilot_wp_offset setWaypointCombatMode "BLUE";
_pilot_wp_offset setWaypointCompletionRadius 200;

_pilot_group setCurrentWaypoint _pilot_wp_target;
{_x doFollow leader _pilot_group} forEach units _pilot_group;

private _para_wp_target_1 = _para_group addWaypoint [_targetPos, 25];
_para_wp_target_1 setWaypointType "MOVE";
_para_wp_target_1 setWaypointSpeed "FULL";
_para_wp_target_1 setWaypointBehaviour "CARELESS";
_para_wp_target_1 setWaypointCombatMode "BLUE";
_para_wp_target_1 setWaypointCompletionRadius 100;
private _para_wp_target_2 = _para_group addWaypoint [_targetPos, 25];
_para_wp_target_2 setWaypointType "MOVE";
_para_wp_target_2 setWaypointCompletionRadius 100;

_para_group setCurrentWaypoint _para_wp_target_1;
{_x doFollow leader _para_group} forEach units _para_group;

waitUntil {sleep 1;
    !(alive _newVehicle) || (damage _newVehicle > 0.2) || (_newVehicle distance2D _targetPos < 300)
};

_newVehicle lock false;

{sleep 0.5; unassignVehicle _x; moveout _x;} forEach (units _para_group);

{deleteWaypoint _x} forEachReversed waypoints _para_group;

private _para_wp_combat_1 = _para_group addWaypoint [_targetPos, 100];
_para_wp_combat_1 setWaypointType "SAD";
_para_wp_combat_1 setWaypointSpeed "FULL";
_para_wp_combat_1 setWaypointBehaviour "AWARE";
_para_wp_combat_1 setWaypointCombatMode "RED";
_para_wp_combat_1 setWaypointCompletionRadius 100;
_para_wp_combat_1 setWaypointTimeout [60, 90, 120];
private _para_wp_combat_2 = _para_group addWaypoint [_targetPos, 100];
_para_wp_combat_2 setWaypointType "SAD";
_para_wp_combat_2 setWaypointSpeed "NORMAL";
_para_wp_combat_2 setWaypointBehaviour "COMBAT";
_para_wp_combat_2 setWaypointCompletionRadius 100;
private _para_wp_combat_3 = _para_group addWaypoint [_targetPos, 100];
_para_wp_combat_3 setWaypointType "SAD";
_para_wp_combat_3 setWaypointCompletionRadius 100;
private _para_wp_combat_4 = _para_group addWaypoint [_targetPos, 100];
_para_wp_combat_4 setWaypointType "SAD";
_para_wp_combat_4 setWaypointCompletionRadius 100;

_pilot_group setCurrentWaypoint _pilot_wp_offset;
_para_group setCurrentWaypoint _para_wp_combat_1;
{_x doFollow leader _para_group} forEach units _para_group;
{_x doFollow leader _pilot_group} forEach units _pilot_group;

sleep 8;

_pilot setSkill _pilotSkill;
_newVehicle flyInHeight [100, false];
{deleteWaypoint _x} forEachReversed waypoints _pilot_group;

private _pilot_wp_combat_1 = _pilot_group addWaypoint [_targetPos, 100];
_pilot_wp_combat_1 setWaypointType "SAD";
_pilot_wp_combat_1 setWaypointBehaviour "COMBAT";
_pilot_wp_combat_1 setWaypointCombatMode "RED";
_pilot_wp_combat_1 setWaypointCompletionRadius 500;
_pilot_wp_combat_1 setWaypointTimeout [210, 240, 270];

private _pilot_wp_rtb = _pilot_group addWaypoint [_spawnPos, 25];
_pilot_wp_rtb setWaypointType "MOVE";
_pilot_wp_rtb setWaypointSpeed "FULL";
_pilot_wp_rtb setWaypointBehaviour "CARELESS";
_pilot_wp_rtb setWaypointCombatMode "BLUE";
_pilot_wp_rtb setWaypointCompletionRadius 25;

_pilot_group setCurrentWaypoint _pilot_wp_combat_1;

sleep 240;

_pilot_group setCurrentWaypoint _pilot_wp_rtb;

waitUntil {sleep 1;
    !(alive driver _newVehicle) || (_newVehicle distance2D _spawnPos < 100)
};

sleep 5;
if (!alive driver _newVehicle) exitWith {};

deleteVehicleCrew _newVehicle;
deleteVehicle _newVehicle;
