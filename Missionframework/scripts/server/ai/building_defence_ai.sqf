scriptName "building_defence_ai";

params ["_unit", ["_sector", ""], ["_forceNoLAMBS", false]];

private _sectorPos = (markerPos _sector);
//Check LAMBS_Danger.fsm is running. if running, skip KPLIB built in troop garrisoning and call lambs wp garrisoning.

private _checkLAMBS = isClass (configfile >> "CfgPatches" >> "lambs_wp");
if (_forceNoLAMBS) then {_checkLAMBS = false};

if (_checkLAMBS) then {
    _taskRange = round (KPLIB_range_sectorCapture / 3 * 2);
    [_unit, _sectorPos, _taskRange, [], true, false, -1, false] call lambs_wp_fnc_taskGarrison;

    private _move_is_disabled = true;
    private _hostiles = 0;
    private _ratio = 0.4;
    private _range = 40;

    while {_move_is_disabled && local _unit && alive _unit && !(captive _unit)} do {

        if !(_sector isEqualTo "") then {
            _ratio = [_sector] call KPLIB_fnc_getBluforRatio;
        };

        _range = floor (linearConversion [0, 1, _ratio, 0, KPLIB_range_sectorCapture / 3 * 2, true]);

        _hostiles = (_unit nearEntities [["CAManBase"], _range]) select {side _x == KPLIB_side_player};

        if (_move_is_disabled &&
            {
                (_sector in KPLIB_sectors_player) ||
                {!(_hostiles isEqualTo [])} ||
                {damage _unit > 0.25}
            }
        ) then {
            _move_is_disabled = false;
            if (KPLIB_ace_ai) then {
                [[_unit]] call ace_ai_fnc_unGarrison;
                _unit setCombatMode "RED";
                _unit setCombatBehaviour "COMBAT";
            } else {
                _unit enableAI "PATH";
                _unit setUnitPos "AUTO";
                _unit setCombatMode "RED";
                _unit setCombatBehaviour "COMBAT";
            };
        };

        if (_move_is_disabled) then {
            private _target = assignedTarget _unit;
            if(!(isnull _target)) then {
                private _vd = (getPosASL _target) vectorDiff (getpos _unit);
                private _newdir = (_vd select 0) atan2 (_vd select 1);
                if (_newdir < 0) then {_dir = 360 + _newdir};
                _unit setdir (_newdir);
            };
        };
        sleep 5;
    };
} else {
    _unit setUnitPos "UP";
    _unit disableAI "PATH";
    private _move_is_disabled = true;
    private _hostiles = 0;
    private _ratio = 0.4;
    private _range = 40;
    
    _unit addEventHandler ["Hit", {params ["_unit"];_unit setVariable ["KPLIB_bda_move_Enabled",true,true];}];
    _unit addEventHandler ["Fired", {params ["_unit"];_unit setVariable ["KPLIB_bda_move_Enabled",true,true];}];
    _unit addEventHandler ["FiredNear", {params ["_unit"];_unit setVariable ["KPLIB_bda_move_Enabled",true,true];}];
    _unit addEventHandler ["Suppressed", {params ["_unit"];_unit setVariable ["KPLIB_bda_move_Enabled",true,true];}];

    while {_move_is_disabled && local _unit && alive _unit && !(captive _unit)} do {

        if !(_sector isEqualTo "") then {
            _ratio = [_sector] call KPLIB_fnc_getBluforRatio;
        };

        _range = floor (linearConversion [0, 1, _ratio, 0, KPLIB_range_sectorCapture / 3 * 2, true]);

        _hostiles = (_unit nearEntities [["CAManBase"], _range]) select {side _x == KPLIB_side_player};

        if (_move_is_disabled &&
            {
                (_sector in KPLIB_sectors_player) ||
                (_unit getVariable ["KPLIB_bda_move_Enabled", false]) ||
                {!(_hostiles isEqualTo [])} ||
                {damage _unit > 0.25}
            }
        ) then {
            _move_is_disabled = false;
            if (KPLIB_ace_ai) then {
                [[_unit]] call ace_ai_fnc_unGarrison;
                _unit setCombatMode "RED";
                _unit setCombatBehaviour "COMBAT";
            } else {
                _unit enableAI "PATH";
                _unit setUnitPos "AUTO";
                _unit setCombatMode "RED";
                _unit setCombatBehaviour "COMBAT";
            };
        };

        if (_move_is_disabled) then {
            private _target = assignedTarget _unit;
            if(!(isnull _target)) then {
                private _vd = (getPosASL _target) vectorDiff (getpos _unit);
                private _newdir = (_vd select 0) atan2 (_vd select 1);
                if (_newdir < 0) then {_dir = 360 + _newdir};
                _unit setdir (_newdir);
            };
        };
        sleep 5;
    };
};
