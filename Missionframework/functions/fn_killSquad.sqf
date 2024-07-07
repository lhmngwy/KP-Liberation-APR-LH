params ["_unit"];

private _hcgrp = _unit getVariable ["KPLIB_lastHC", objNull];
private _playerGroup = group _unit;

// Initialize a flag to check if there are AI members in the player's group
private _hasAIMembers = false;

// Loop through the player's group and delete AI members
{
    if (!isPlayer _x) then {
        _x setDamage 1;
        [_x] joinSilent grpNull;
        _hasAIMembers = true;
    };
} forEach units _playerGroup;

// If the player's group had no AI members and _hcgrp is not null, delete AI members from _hcgrp
if (!_hasAIMembers && !isNull _hcgrp) then {
    {
        if (!isPlayer _x) then {
            _x setDamage 1;
            [_x] joinSilent grpNull;
        };
    } forEach units _hcgrp;
};

_unit setVariable ["KPLIB_lastHC", objNull, true];