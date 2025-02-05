/*
    File: fn_createManagedUnit.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 2019-10-04
    Last Update: 2023-10-28
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Creates unit managed by kill tracker.

    Parameter(s):
        _type       - Type of unit              [STRING, defaults to ""]
        _spawnPos   - Where to spawn            [ARRAY|OBJECT|GROUP, defaults to [0, 0, 0]]
        _group      - Group to add the unit to  [GROUP, defaults to grpNull]
        _rank       - Unit rank                 [STRING, defaults to "PRIVATE"]
        _placement  - Placement radius          [NUMBER, defaults to 0]

    Returns:
        Created unit [OBJECT]
*/

params [
    ["_type", "", [""]],
    ["_spawnPos", [0, 0, 0], [[], objNull, grpNull], [2, 3]],
    ["_group", grpNull, [grpNull]],
    ["_rank", "PRIVATE", [""]],
    ["_placement", 0, [0]]
];

private ["_unit"];
isNil {
    // Create temp group, as we need to let the unit join the "correct side group".
    // If we use the "correct side group" for the createUnit, the group would switch to the side of the unit written in the config.
    private _groupTemp = createGroup [CIVILIAN, true];

    _unit = _groupTemp createUnit [_type, _spawnPos, [], _placement, "FORM"];
    if (side _group == KPLIB_side_player) then {
        _unit setVariable ['KPLIB_playerSide', true, true];
    };
    _unit addMPEventHandler ["MPKilled", {
        params ["_unit", "_killer"];
        [_unit] joinSilent grpNull;
        ["KPLIB_manageKills", [_unit, _killer]] call CBA_fnc_localEvent;
    }];
    _unit setRank _rank;

    // Set unit traits here because they are not properly configured in all faction mods.
    switch _type do {
        case KPLIB_o_engineer: {_unit setUnitTrait ["Engineer", true]; _unit setUnitTrait ["explosiveSpecialist", true]};
        case KPLIB_o_medic: {_unit setUnitTrait ["Medic", true]};
        default {};
    };

    // Join to target group to preserve Side
    [_unit] joinSilent _group;
    deleteGroup _groupTemp;

    // Process KP object init
    [_unit] call KPLIB_fnc_addObjectInit;
};

sleep 0.1;

_unit
